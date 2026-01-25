-- ============================================
-- DZ-FELLAH MARKETPLACE - SEED DATA
-- PostgreSQL Seed Script
-- ============================================

-- ============================================
-- INSERT USERS (2 producers, 2 clients)
-- ============================================

INSERT INTO users (email, password, user_type, first_name, last_name, phone, is_active, is_verified) VALUES
('ahmed.producer@dzfellah.dz', '$2a$10$abcdefghijklmnopqrstuv', 'producer', 'Ahmed', 'Benali', '+213555123456', TRUE, TRUE),
('fatima.producer@dzfellah.dz', '$2a$10$wxyzabcdefghijklmnopqr', 'producer', 'Fatima', 'Kaddour', '+213555789012', TRUE, TRUE),
('karim.client@dzfellah.dz', '$2a$10$123456789abcdefghijklm', 'client', 'Karim', 'Messaoudi', '+213555345678', TRUE, TRUE),
('sarah.client@dzfellah.dz', '$2a$10$nopqrstuvwxyz123456789', 'client', 'Sarah', 'Amrani', '+213555901234', TRUE, TRUE);

-- ============================================
-- INSERT PRODUCERS
-- ============================================

INSERT INTO producers (user_id, shop_name, description, photo_url, address, city, wilaya, methods, is_bio_certified) VALUES
(1, 'Ferme Bio Ahmed', 'Production biologique de fruits et légumes de saison. Méthodes traditionnelles et respectueuses de l''environnement.', 'https://example.com/photos/ferme-ahmed.jpg', 'Route de Boudouaou, Zone Agricole', 'Bab Ezzouar', 'Alger', 'Agriculture biologique, permaculture', TRUE),
(2, 'Jardin de Fatima', 'Spécialiste des produits maraîchers frais et des confitures artisanales. Culture locale et durable.', 'https://example.com/photos/jardin-fatima.jpg', 'Chemin des Oliviers, Ferme N°15', 'Rouiba', 'Alger', 'Agriculture raisonnée, rotation des cultures', FALSE);

-- ============================================
-- INSERT CLIENTS
-- ============================================

INSERT INTO clients (user_id, address, city, wilaya) VALUES
(3, 'Cité 200 Logements, Bt A, Appt 12', 'Bab Ezzouar', 'Alger'),
(4, 'Résidence Les Palmiers, Villa 8', 'Hydra', 'Alger');

-- ============================================
-- INSERT PRODUCTS
-- ============================================

INSERT INTO products (producer_id, name, description, photo_url, sale_type, price, stock, product_type, harvest_date, is_anti_gaspi) VALUES
-- Ahmed's products
(1, 'Tomates Bio', 'Tomates fraîches cultivées sans pesticides. Variété locale, goût authentique.', 'https://example.com/products/tomates.jpg', 'weight', 250.00, 50.00, 'fresh', '2026-01-20', FALSE),
(1, 'Huile d''Olive Extra Vierge', 'Huile d''olive pressée à froid, première pression. Production artisanale 2025.', 'https://example.com/products/huile-olive.jpg', 'unit', 1200.00, 30.00, 'processed', NULL, FALSE),

-- Fatima's products
(2, 'Courgettes Fraîches', 'Courgettes du jour, cueillies le matin même. Parfaites pour vos ratatouilles.', 'https://example.com/products/courgettes.jpg', 'weight', 180.00, 35.00, 'fresh', '2026-01-24', FALSE),
(2, 'Confiture de Figues', 'Confiture artisanale aux figues de Kabylie. Sans conservateurs, 70% de fruits.', 'https://example.com/products/confiture-figues.jpg', 'unit', 450.00, 25.00, 'processed', NULL, TRUE);

-- ============================================
-- INSERT PRODUCT RATINGS
-- ============================================

INSERT INTO product_ratings (product_id, user_id, rating) VALUES
-- Karim rates products
(1, 3, 5),
(2, 3, 4),

-- Sarah rates products
(3, 4, 5),
(4, 4, 5);

-- ============================================
-- INSERT SEASONAL BASKETS
-- ============================================

INSERT INTO seasonal_baskets (producer_id, name, description, photo_url, discount_percentage, original_price, discounted_price, delivery_frequency, is_active) VALUES
(1, 'Panier Bio Hebdomadaire', 'Sélection de 5kg de fruits et légumes bio de saison. Composition variable selon les récoltes.', 'https://example.com/baskets/panier-bio.jpg', 15.00, 2500.00, 2125.00, 'weekly', TRUE),
(2, 'Panier Découverte Mensuel', 'Assortiment de produits frais et transformés. Idéal pour découvrir notre production.', 'https://example.com/baskets/panier-decouverte.jpg', 20.00, 3000.00, 2400.00, 'monthly', TRUE);

-- ============================================
-- INSERT BASKET PRODUCTS
-- ============================================

INSERT INTO basket_products (basket_id, product_id, quantity) VALUES
-- Ahmed's basket contains
(1, 1, 3.00),  -- 3kg of tomatoes
(1, 2, 1.00),  -- 1 bottle of olive oil

-- Fatima's basket contains
(2, 3, 2.50),  -- 2.5kg of courgettes
(2, 4, 2.00);  -- 2 jars of fig jam

-- ============================================
-- INSERT CLIENT SUBSCRIPTIONS
-- ============================================

INSERT INTO client_subscriptions (client_id, basket_id, status, start_date, next_delivery_date, delivery_method, delivery_address, total_deliveries) VALUES
(1, 1, 'active', '2026-01-15', '2026-01-29', 'pickup_producer', NULL, 2),
(2, 2, 'active', '2026-01-01', '2026-02-01', 'pickup_point', 'Résidence Les Palmiers, Villa 8', 1);

-- ============================================
-- INSERT SUBSCRIPTION DELIVERIES
-- ============================================

INSERT INTO subscription_deliveries (subscription_id, delivery_date, status, picked_up_at, notes) VALUES
-- Karim's deliveries
(1, '2026-01-15', 'picked_up', '2026-01-15 10:30:00', 'Client très satisfait'),
(1, '2026-01-22', 'picked_up', '2026-01-22 11:15:00', 'RAS'),
(1, '2026-01-29', 'pending', NULL, NULL),

-- Sarah's deliveries
(2, '2026-01-01', 'picked_up', '2026-01-02 14:00:00', 'Première livraison'),
(2, '2026-02-01', 'pending', NULL, NULL);

-- ============================================
-- VERIFY DATA
-- ============================================

DO $$ 
BEGIN 
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'SEED DATA INSERTED SUCCESSFULLY!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Users: % total (% producers, % clients)', 
        (SELECT COUNT(*) FROM users),
        (SELECT COUNT(*) FROM users WHERE user_type = 'producer'),
        (SELECT COUNT(*) FROM users WHERE user_type = 'client');
    RAISE NOTICE 'Producers: %', (SELECT COUNT(*) FROM producers);
    RAISE NOTICE 'Clients: %', (SELECT COUNT(*) FROM clients);
    RAISE NOTICE 'Products: %', (SELECT COUNT(*) FROM products);
    RAISE NOTICE 'Product Ratings: %', (SELECT COUNT(*) FROM product_ratings);
    RAISE NOTICE 'Seasonal Baskets: %', (SELECT COUNT(*) FROM seasonal_baskets);
    RAISE NOTICE 'Basket Products: %', (SELECT COUNT(*) FROM basket_products);
    RAISE NOTICE 'Client Subscriptions: %', (SELECT COUNT(*) FROM client_subscriptions);
    RAISE NOTICE 'Subscription Deliveries: %', (SELECT COUNT(*) FROM subscription_deliveries);
    RAISE NOTICE '==============================================';
END $$;