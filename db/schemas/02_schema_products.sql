-- ============================================
-- PRODUCTS SCHEMA - PostgreSQL
-- DZ-Fellah Marketplace
-- ============================================

DROP TABLE IF EXISTS products CASCADE;

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

-- ============================================
-- TRIGGER FOR UPDATED_AT
-- ============================================

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();