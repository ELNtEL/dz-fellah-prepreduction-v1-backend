-- =============================================
-- DZ-FELLAH DATABASE SCHEMA
-- PostgreSQL 14+
-- =============================================

-- Drop existing tables (cascade pour les foreign keys)
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS subscription_products CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS seasonal_basket_products CASCADE;
DROP TABLE IF EXISTS seasonal_baskets CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS producer_profiles CASCADE;
DROP TABLE IF EXISTS client_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- =============================================
-- TABLE: users (Authentification)
-- =============================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150) UNIQUE NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('producer', 'client')),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    is_staff BOOLEAN DEFAULT FALSE,
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- =============================================
-- TABLE: producer_profiles
-- =============================================
CREATE TABLE producer_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shop_name VARCHAR(200) NOT NULL,
    wilaya VARCHAR(100) NOT NULL,
    commune VARCHAR(100) NOT NULL,
    address TEXT,
    bio_certified BOOLEAN DEFAULT FALSE,
    avatar TEXT, -- Base64 encoded image
    description TEXT,
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
    total_sales INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_producer_user ON producer_profiles(user_id);
CREATE INDEX idx_producer_wilaya ON producer_profiles(wilaya);

-- =============================================
-- TABLE: client_profiles
-- =============================================
CREATE TABLE client_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    wilaya VARCHAR(100) NOT NULL,
    commune VARCHAR(100),
    address TEXT,
    avatar TEXT, -- Base64 encoded image
    total_orders INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_client_user ON client_profiles(user_id);
CREATE INDEX idx_client_wilaya ON client_profiles(wilaya);

-- =============================================
-- TABLE: products
-- =============================================
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    producer_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    photo_url TEXT, -- Base64 encoded image
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    original_price DECIMAL(10,2), -- Pour anti-gaspi
    sale_type VARCHAR(20) NOT NULL CHECK (sale_type IN ('unit', 'weight')),
    unit VARCHAR(50) DEFAULT 'piece', -- kg, piece, liter, etc.
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    product_type VARCHAR(50) NOT NULL CHECK (product_type IN ('vegetable', 'fruit', 'dairy', 'honey', 'meat', 'grain', 'other')),
    is_anti_gaspi BOOLEAN DEFAULT FALSE,
    discount_percentage INTEGER DEFAULT 0 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    is_seasonal BOOLEAN DEFAULT FALSE,
    season VARCHAR(20) CHECK (season IN ('winter', 'spring', 'summer', 'fall')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_producer ON products(producer_id);
CREATE INDEX idx_products_type ON products(product_type);
CREATE INDEX idx_products_anti_gaspi ON products(is_anti_gaspi);
CREATE INDEX idx_products_seasonal ON products(is_seasonal);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_created ON products(created_at);

-- =============================================
-- TABLE: seasonal_baskets
-- =============================================
CREATE TABLE seasonal_baskets (
    id SERIAL PRIMARY KEY,
    producer_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    discount_percentage INTEGER DEFAULT 0 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    delivery_frequency VARCHAR(20) NOT NULL CHECK (delivery_frequency IN ('weekly', 'biweekly', 'monthly')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_baskets_producer ON seasonal_baskets(producer_id);
CREATE INDEX idx_baskets_active ON seasonal_baskets(is_active);

-- =============================================
-- TABLE: seasonal_basket_products (Many-to-Many)
-- =============================================
CREATE TABLE seasonal_basket_products (
    id SERIAL PRIMARY KEY,
    basket_id INTEGER NOT NULL REFERENCES seasonal_baskets(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(basket_id, product_id)
);

CREATE INDEX idx_basket_products_basket ON seasonal_basket_products(basket_id);
CREATE INDEX idx_basket_products_product ON seasonal_basket_products(product_id);

-- =============================================
-- TABLE: subscriptions
-- =============================================
CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    basket_id INTEGER NOT NULL REFERENCES seasonal_baskets(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'paused', 'cancelled')),
    delivery_method VARCHAR(20) NOT NULL CHECK (delivery_method IN ('home_delivery', 'pickup')),
    delivery_address TEXT,
    next_delivery TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cancelled_at TIMESTAMP,
    paused_at TIMESTAMP
);

CREATE INDEX idx_subscriptions_client ON subscriptions(client_id);
CREATE INDEX idx_subscriptions_basket ON subscriptions(basket_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_next_delivery ON subscriptions(next_delivery);

-- =============================================
-- TABLE: cart_items
-- =============================================
CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(client_id, product_id)
);

CREATE INDEX idx_cart_client ON cart_items(client_id);
CREATE INDEX idx_cart_product ON cart_items(product_id);

-- =============================================
-- TABLE: orders (Commandes)
-- =============================================
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    client_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    producer_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    parent_order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    is_parent BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    delivery_method VARCHAR(20) NOT NULL CHECK (delivery_method IN ('home_delivery', 'pickup')),
    delivery_address TEXT,
    payment_method VARCHAR(20) DEFAULT 'cash_on_delivery',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    confirmed_at TIMESTAMP,
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,
    cancelled_at TIMESTAMP
);

CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_client ON orders(client_id);
CREATE INDEX idx_orders_producer ON orders(producer_id);
CREATE INDEX idx_orders_parent ON orders(parent_order_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at);

-- =============================================
-- TABLE: order_items
-- =============================================
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    product_name VARCHAR(200) NOT NULL, -- Snapshot du nom
    product_photo TEXT, -- Snapshot de la photo
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- =============================================
-- TRIGGERS pour updated_at automatique
-- =============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_producer_profiles_updated_at BEFORE UPDATE ON producer_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_client_profiles_updated_at BEFORE UPDATE ON client_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_seasonal_baskets_updated_at BEFORE UPDATE ON seasonal_baskets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cart_items_updated_at BEFORE UPDATE ON cart_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- VUES UTILES
-- =============================================

-- Vue: Produits avec infos producteur
CREATE OR REPLACE VIEW v_products_with_producer AS
SELECT 
    p.*,
    u.username as producer_username,
    pp.shop_name,
    pp.wilaya,
    pp.commune,
    pp.phone,
    pp.bio_certified,
    pp.avatar as producer_avatar,
    pp.rating as producer_rating
FROM products p
JOIN users u ON p.producer_id = u.id
JOIN producer_profiles pp ON u.id = pp.user_id
WHERE p.is_active = TRUE;

-- Vue: Paniers avec prix total
CREATE OR REPLACE VIEW v_baskets_with_totals AS
SELECT 
    sb.*,
    u.username as producer_username,
    pp.shop_name,
    pp.wilaya,
    COUNT(sbp.id) as product_count,
    SUM(p.price * sbp.quantity) as total_price,
    SUM(p.price * sbp.quantity * (100 - sb.discount_percentage) / 100) as discounted_price
FROM seasonal_baskets sb
JOIN users u ON sb.producer_id = u.id
JOIN producer_profiles pp ON u.id = pp.user_id
LEFT JOIN seasonal_basket_products sbp ON sb.id = sbp.basket_id
LEFT JOIN products p ON sbp.product_id = p.id
GROUP BY sb.id, u.username, pp.shop_name, pp.wilaya;

-- Vue: Paniers clients avec totaux
CREATE OR REPLACE VIEW v_cart_totals AS
SELECT 
    ci.client_id,
    COUNT(ci.id) as item_count,
    SUM(p.price * ci.quantity) as total
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
GROUP BY ci.client_id;

-- =============================================
-- DONNÉES INITIALES (Wilayas d'Algérie)
-- =============================================

-- Fonction pour faciliter le seeding des wilayas
CREATE TABLE IF NOT EXISTS wilayas (
    id SERIAL PRIMARY KEY,
    code VARCHAR(2) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL
);

INSERT INTO wilayas (code, name) VALUES
('01', 'Adrar'), ('02', 'Chlef'), ('03', 'Laghouat'), ('04', 'Oum El Bouaghi'),
('05', 'Batna'), ('06', 'Béjaïa'), ('07', 'Biskra'), ('08', 'Béchar'),
('09', 'Blida'), ('10', 'Bouira'), ('11', 'Tamanrasset'), ('12', 'Tébessa'),
('13', 'Tlemcen'), ('14', 'Tiaret'), ('15', 'Tizi Ouzou'), ('16', 'Alger'),
('17', 'Djelfa'), ('18', 'Jijel'), ('19', 'Sétif'), ('20', 'Saïda'),
('21', 'Skikda'), ('22', 'Sidi Bel Abbès'), ('23', 'Annaba'), ('24', 'Guelma'),
('25', 'Constantine'), ('26', 'Médéa'), ('27', 'Mostaganem'), ('28', 'M''Sila'),
('29', 'Mascara'), ('30', 'Ouargla'), ('31', 'Oran'), ('32', 'El Bayadh'),
('33', 'Illizi'), ('34', 'Bordj Bou Arréridj'), ('35', 'Boumerdès'), ('36', 'El Tarf'),
('37', 'Tindouf'), ('38', 'Tissemsilt'), ('39', 'El Oued'), ('40', 'Khenchela'),
('41', 'Souk Ahras'), ('42', 'Tipaza'), ('43', 'Mila'), ('44', 'Aïn Defla'),
('45', 'Naâma'), ('46', 'Aïn Témouchent'), ('47', 'Ghardaïa'), ('48', 'Relizane');

COMMENT ON TABLE users IS 'Table principale des utilisateurs (producteurs et clients)';
COMMENT ON TABLE products IS 'Catalogue des produits avec support anti-gaspi';
COMMENT ON TABLE seasonal_baskets IS 'Paniers saisonniers proposés par les producteurs';
COMMENT ON TABLE subscriptions IS 'Abonnements des clients aux paniers saisonniers';
COMMENT ON TABLE orders IS 'Commandes avec système parent-enfant pour multi-producteurs';