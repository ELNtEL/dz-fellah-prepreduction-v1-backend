-- ============================================
-- DZ-FELLAH MARKETPLACE - COMPLETE DATABASE SCHEMA
-- PostgreSQL Database Creation Script
-- ============================================

-- ============================================
-- DROP ALL TABLES IN CORRECT ORDER (reverse of dependencies)
-- ============================================

DROP TABLE IF EXISTS subscription_deliveries CASCADE;
DROP TABLE IF EXISTS client_subscriptions CASCADE;
DROP TABLE IF EXISTS basket_products CASCADE;
DROP TABLE IF EXISTS seasonal_baskets CASCADE;
DROP TABLE IF EXISTS product_ratings CASCADE;
DROP VIEW IF EXISTS producer_rating_summary CASCADE;
DROP VIEW IF EXISTS product_rating_summary CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS producers CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Drop function if exists
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- ============================================
-- CREATE HELPER FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- USERS TABLE
-- ============================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('producer', 'client')),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_type ON users(user_type);
CREATE INDEX idx_users_is_active ON users(is_active);

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- PRODUCERS TABLE
-- ============================================

CREATE TABLE producers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shop_name VARCHAR(255) NOT NULL,
    description TEXT,
    photo_url VARCHAR(500),
    address TEXT,
    city VARCHAR(100),
    wilaya VARCHAR(100),
    methods TEXT,
    is_bio_certified BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_producers_user_id ON producers(user_id);
CREATE INDEX idx_producers_city ON producers(city);
CREATE INDEX idx_producers_wilaya ON producers(wilaya);
CREATE INDEX idx_producers_is_bio_certified ON producers(is_bio_certified);
CREATE INDEX idx_producers_shop_name ON producers(shop_name);

CREATE TRIGGER update_producers_updated_at
    BEFORE UPDATE ON producers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- CLIENTS TABLE
-- ============================================

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    address TEXT,
    city VARCHAR(100),
    wilaya VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_clients_user_id ON clients(user_id);
CREATE INDEX idx_clients_city ON clients(city);
CREATE INDEX idx_clients_wilaya ON clients(wilaya);

CREATE TRIGGER update_clients_updated_at
    BEFORE UPDATE ON clients
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- PRODUCTS TABLE
-- ============================================

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    producer_id INTEGER NOT NULL REFERENCES producers(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    photo_url VARCHAR(500),
    sale_type VARCHAR(20) NOT NULL CHECK (sale_type IN ('unit', 'weight')),
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock NUMERIC(10, 2) NOT NULL CHECK (stock >= 0),
    product_type VARCHAR(20) NOT NULL CHECK (product_type IN ('fresh', 'processed', 'other')),
    harvest_date DATE,
    is_anti_gaspi BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_products_producer_id ON products(producer_id);
CREATE INDEX idx_products_sale_type ON products(sale_type);
CREATE INDEX idx_products_product_type ON products(product_type);
CREATE INDEX idx_products_is_anti_gaspi ON products(is_anti_gaspi);
CREATE INDEX idx_products_harvest_date ON products(harvest_date) WHERE product_type = 'fresh' AND harvest_date IS NOT NULL;
CREATE INDEX idx_products_type_anti_gaspi ON products(product_type, is_anti_gaspi);

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- PRODUCT RATINGS TABLE
-- ============================================

CREATE TABLE product_ratings (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_product_rating UNIQUE(product_id, user_id)
);

CREATE INDEX idx_product_ratings_product ON product_ratings(product_id);
CREATE INDEX idx_product_ratings_user ON product_ratings(user_id);

-- ============================================
-- PRODUCT RATING SUMMARY VIEW
-- ============================================

CREATE OR REPLACE VIEW product_rating_summary AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    p.producer_id,
    COUNT(pr.id) AS total_ratings,
    COALESCE(ROUND(AVG(pr.rating), 1), 0) AS average_rating,
    COUNT(CASE WHEN pr.rating = 5 THEN 1 END) AS five_star_count,
    COUNT(CASE WHEN pr.rating = 4 THEN 1 END) AS four_star_count,
    COUNT(CASE WHEN pr.rating = 3 THEN 1 END) AS three_star_count,
    COUNT(CASE WHEN pr.rating = 2 THEN 1 END) AS two_star_count,
    COUNT(CASE WHEN pr.rating = 1 THEN 1 END) AS one_star_count
FROM products p
LEFT JOIN product_ratings pr ON p.id = pr.product_id
GROUP BY p.id, p.name, p.producer_id;

-- ============================================
-- PRODUCER RATING SUMMARY VIEW
-- ============================================

CREATE OR REPLACE VIEW producer_rating_summary AS
SELECT
    prod.id AS producer_id,
    prod.shop_name::TEXT AS producer_name,
    COUNT(DISTINCT p.id) AS total_products,
    COUNT(pr.id) AS total_ratings,
    COALESCE(ROUND(AVG(pr.rating), 1), 0) AS average_rating
FROM producers prod
INNER JOIN products p ON prod.id = p.producer_id
LEFT JOIN product_ratings pr ON p.id = pr.product_id
GROUP BY prod.id, prod.shop_name;

-- ============================================
-- SEASONAL BASKETS TABLE
-- ============================================

CREATE TABLE seasonal_baskets (
    id SERIAL PRIMARY KEY,
    producer_id INTEGER NOT NULL REFERENCES producers(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    photo_url TEXT,
    discount_percentage NUMERIC(5, 2) NOT NULL CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    original_price NUMERIC(10, 2) NOT NULL CHECK (original_price >= 0),
    discounted_price NUMERIC(10, 2) NOT NULL CHECK (discounted_price >= 0),
    delivery_frequency VARCHAR(20) NOT NULL DEFAULT 'weekly' CHECK (delivery_frequency IN ('weekly', 'biweekly', 'monthly')),
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_seasonal_baskets_producer_id ON seasonal_baskets(producer_id);
CREATE INDEX idx_seasonal_baskets_is_active ON seasonal_baskets(is_active);

-- ============================================
-- BASKET PRODUCTS (Many-to-Many)
-- ============================================

CREATE TABLE basket_products (
    id SERIAL PRIMARY KEY,
    basket_id INTEGER NOT NULL REFERENCES seasonal_baskets(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity NUMERIC(10, 2) NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(basket_id, product_id)
);

CREATE INDEX idx_basket_products_basket_id ON basket_products(basket_id);
CREATE INDEX idx_basket_products_product_id ON basket_products(product_id);

-- ============================================
-- CLIENT SUBSCRIPTIONS TABLE
-- ============================================

CREATE TABLE client_subscriptions (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    basket_id INTEGER NOT NULL REFERENCES seasonal_baskets(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'paused', 'cancelled')),
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    next_delivery_date DATE,
    delivery_method VARCHAR(50) NOT NULL CHECK (delivery_method IN ('pickup_producer', 'pickup_point')),
    delivery_address TEXT,
    pickup_point_id VARCHAR(100),
    total_deliveries INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cancelled_at TIMESTAMP,
    UNIQUE(client_id, basket_id, status)
);

CREATE INDEX idx_client_subscriptions_client_id ON client_subscriptions(client_id);
CREATE INDEX idx_client_subscriptions_basket_id ON client_subscriptions(basket_id);
CREATE INDEX idx_client_subscriptions_status ON client_subscriptions(status);
CREATE INDEX idx_client_subscriptions_next_delivery ON client_subscriptions(next_delivery_date);

-- ============================================
-- SUBSCRIPTION DELIVERIES (Tracking)
-- ============================================

CREATE TABLE subscription_deliveries (
    id SERIAL PRIMARY KEY,
    subscription_id INTEGER NOT NULL REFERENCES client_subscriptions(id) ON DELETE CASCADE,
    delivery_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'ready', 'picked_up', 'missed')),
    picked_up_at TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_subscription_deliveries_subscription_id ON subscription_deliveries(subscription_id);
CREATE INDEX idx_subscription_deliveries_status ON subscription_deliveries(status);
CREATE INDEX idx_subscription_deliveries_delivery_date ON subscription_deliveries(delivery_date);

-- ============================================
-- SCRIPT COMPLETION
-- ============================================

-- Display success message
DO $$ 
BEGIN 
    RAISE NOTICE 'DZ-Fellah database schema created successfully!';
    RAISE NOTICE 'Tables created: users, producers, clients, products, product_ratings, seasonal_baskets, basket_products, client_subscriptions, subscription_deliveries';
    RAISE NOTICE 'Views created: product_rating_summary, producer_rating_summary';
END $$;