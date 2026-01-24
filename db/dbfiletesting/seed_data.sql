-- =============================================
-- DZ-FELLAH SEED DATA
-- Jeu de données de test cohérent
-- =============================================

-- =============================================
-- USERS (20 utilisateurs: 10 producteurs + 10 clients)
-- =============================================
-- Note: Les mots de passe sont hashés avec Django's PBKDF2
-- Le mot de passe pour tous les comptes de test est: "TestPass123!"
-- Hash: pbkdf2_sha256$600000$randomsalt$hashedpassword

INSERT INTO users (username, email, password, role, phone, is_active) VALUES
-- Producteurs (10)
('ferme_ali', 'ali@dzfellah.dz', 'pbkdf2_sha256$600000$salt1$hash1', 'producer', '0555123456', TRUE),
('bio_karim', 'karim@dzfellah.dz', 'pbkdf2_sha256$600000$salt2$hash2', 'producer', '0770234567', TRUE),
('mohamed_farm', 'mohamed@dzfellah.dz', 'pbkdf2_sha256$600000$salt3$hash3', 'producer', '0661345678', TRUE),
('ferme_fatima', 'fatima@dzfellah.dz', 'pbkdf2_sha256$600000$salt4$hash4', 'producer', '0550456789', TRUE),
('rachid_bio', 'rachid@dzfellah.dz', 'pbkdf2_sha256$600000$salt5$hash5', 'producer', '0770567890', TRUE),
('zahia_products', 'zahia@dzfellah.dz', 'pbkdf2_sha256$600000$salt6$hash6', 'producer', '0555678901', TRUE),
('youcef_organic', 'youcef@dzfellah.dz', 'pbkdf2_sha256$600000$salt7$hash7', 'producer', '0661789012', TRUE),
('amina_farm', 'amina@dzfellah.dz', 'pbkdf2_sha256$600000$salt8$hash8', 'producer', '0550890123', TRUE),
('said_agriculture', 'said@dzfellah.dz', 'pbkdf2_sha256$600000$salt9$hash9', 'producer', '0770901234', TRUE),
('nadia_bio', 'nadia@dzfellah.dz', 'pbkdf2_sha256$600000$salt10$hash10', 'producer', '0555012345', TRUE),

-- Clients (10)
('client_sara', 'sara@client.dz', 'pbkdf2_sha256$600000$salt11$hash11', 'client', '0550987654', TRUE),
('hamza_client', 'hamza@client.dz', 'pbkdf2_sha256$600000$salt12$hash12', 'client', '0770876543', TRUE),
('lynda_dz', 'lynda@client.dz', 'pbkdf2_sha256$600000$salt13$hash13', 'client', '0661765432', TRUE),
('kamel_user', 'kamel@client.dz', 'pbkdf2_sha256$600000$salt14$hash14', 'client', '0555654321', TRUE),
('samia_client', 'samia@client.dz', 'pbkdf2_sha256$600000$salt15$hash15', 'client', '0770543210', TRUE),
('farid_dz', 'farid@client.dz', 'pbkdf2_sha256$600000$salt16$hash16', 'client', '0550432109', TRUE),
('meriem_user', 'meriem@client.dz', 'pbkdf2_sha256$600000$salt17$hash17', 'client', '0661321098', TRUE),
('nassim_client', 'nassim@client.dz', 'pbkdf2_sha256$600000$salt18$hash18', 'client', '0555210987', TRUE),
('sihem_dz', 'sihem@client.dz', 'pbkdf2_sha256$600000$salt19$hash19', 'client', '0770109876', TRUE),
('rabah_user', 'rabah@client.dz', 'pbkdf2_sha256$600000$salt20$hash20', 'client', '0550098765', TRUE);

-- =============================================
-- PRODUCER PROFILES (10)
-- =============================================
INSERT INTO producer_profiles (user_id, shop_name, wilaya, commune, address, bio_certified, rating, total_sales, description) VALUES
(1, 'Ferme Bio Ali', 'Alger', 'Bab Ezzouar', 'Route nationale 5, Bab Ezzouar', TRUE, 4.8, 156, 'Produits bio certifiés depuis 2018'),
(2, 'Karim Agriculture Bio', 'Blida', 'Boufarik', 'Zone agricole Boufarik', TRUE, 4.6, 98, 'Spécialiste en agrumes biologiques'),
(3, 'مزرعة محمد', 'Tipaza', 'Kolea', 'Route de Kolea', FALSE, 4.5, 142, 'Fruits et légumes frais de saison'),
(4, 'Ferme Fatima', 'Boumerdès', 'Dellys', 'Plaine de Dellys', TRUE, 4.9, 203, 'Production familiale biologique'),
(5, 'Rachid Bio Products', 'Tizi Ouzou', 'Azazga', 'Village Azazga', TRUE, 4.7, 87, 'Huile d''olive et olives bio'),
(6, 'Zahia Produits du Terroir', 'Béjaïa', 'Akbou', 'Zone rurale Akbou', FALSE, 4.4, 65, 'Produits traditionnels de Kabylie'),
(7, 'Youcef Organic Farm', 'Oran', 'Aïn El Turk', 'Route côtière', TRUE, 4.6, 124, 'Maraîchage biologique côtier'),
(8, 'Amina Exploitation', 'Sétif', 'El Eulma', 'Plaine El Eulma', FALSE, 4.3, 78, 'Céréales et légumineuses'),
(9, 'Saïd Agriculture', 'Constantine', 'El Khroub', 'Zone El Khroub', FALSE, 4.5, 91, 'Produits fermiers traditionnels'),
(10, 'Nadia Bio & Fresh', 'Annaba', 'Berrahal', 'Route Berrahal', TRUE, 4.8, 167, 'Fruits et légumes bio premium');

-- =============================================
-- CLIENT PROFILES (10)
-- =============================================
INSERT INTO client_profiles (user_id, wilaya, commune, address, total_orders) VALUES
(11, 'Alger', 'Bab Ezzouar', 'Cité 1024 Logts, Bt 12, Bab Ezzouar', 8),
(12, 'Blida', 'Blida', 'Cité Ben Boulaid, Blida', 5),
(13, 'Alger', 'Hydra', 'Résidence Les Jardins, Hydra', 12),
(14, 'Oran', 'Bir El Djir', 'Lotissement El Yasmine, Bir El Djir', 3),
(15, 'Constantine', 'Constantine', 'Cité Zouaghi, Constantine', 7),
(16, 'Tipaza', 'Tipaza', 'Centre ville Tipaza', 4),
(17, 'Sétif', 'Sétif', 'Cité 1000 Logts, Sétif', 9),
(18, 'Béjaïa', 'Béjaïa', 'Quartier Sidi Ahmed, Béjaïa', 6),
(19, 'Tizi Ouzou', 'Tizi Ouzou', 'Nouvelle ville, Tizi Ouzou', 11),
(20, 'Annaba', 'Annaba', 'Cité Plaine Ouest, Annaba', 2);

-- =============================================
-- PRODUCTS (60 produits variés)
-- =============================================
INSERT INTO products (producer_id, name, description, price, original_price, sale_type, unit, stock, product_type, is_anti_gaspi, discount_percentage, is_seasonal, season, created_at) VALUES
-- Producteur 1 (Ferme Bio Ali) - 6 produits
(1, 'Tomates Bio', 'Tomates rondes biologiques', 250.00, 250.00, 'weight', 'kg', 150, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '10 days'),
(1, 'Courgettes', 'Courgettes fraîches', 180.00, 180.00, 'weight', 'kg', 80, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '8 days'),
(1, 'Oranges', 'Oranges de Blida', 200.00, 200.00, 'weight', 'kg', 200, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '5 days'),
(1, 'Pommes de terre', 'Pommes de terre locales', 120.00, 120.00, 'weight', 'kg', 300, 'vegetable', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '15 days'),
(1, 'Carottes Bio', 'Carottes biologiques', 150.00, 300.00, 'weight', 'kg', 60, 'vegetable', TRUE, 50, TRUE, 'winter', NOW() - INTERVAL '3 days'),
(1, 'Laitues', 'Laitues fraîches du jour', 80.00, 80.00, 'unit', 'piece', 100, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '1 day'),

-- Producteur 2 (Karim Agriculture Bio) - 6 produits
(2, 'برتقال', 'برتقال طازج من البليدة', 180.00, 180.00, 'weight', 'kg', 250, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '7 days'),
(2, 'Citrons', 'Citrons juteux', 220.00, 220.00, 'weight', 'kg', 120, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '9 days'),
(2, 'Mandarines', 'Mandarines sucrées', 280.00, 280.00, 'weight', 'kg', 180, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '4 days'),
(2, 'Pamplemousses', 'Pamplemousses roses', 200.00, 400.00, 'weight', 'kg', 70, 'fruit', TRUE, 50, TRUE, 'winter', NOW() - INTERVAL '3 days'),
(2, 'Clémentines', 'Clémentines sans pépins', 300.00, 300.00, 'weight', 'kg', 150, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '6 days'),
(2, 'Avocats Bio', 'Avocats biologiques', 450.00, 450.00, 'unit', 'piece', 80, 'fruit', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '2 days'),

-- Producteur 3 (Mohamed Farm) - 6 produits
(3, 'طماطم', 'طماطم طازجة', 150.00, 150.00, 'weight', 'kg', 200, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '12 days'),
(3, 'فلفل أخضر', 'فلفل أخضر حلو', 200.00, 200.00, 'weight', 'kg', 90, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '8 days'),
(3, 'بصل', 'بصل أبيض', 100.00, 100.00, 'weight', 'kg', 400, 'vegetable', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '20 days'),
(3, 'بطاطا', 'بطاطا محلية', 110.00, 110.00, 'weight', 'kg', 500, 'vegetable', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '18 days'),
(3, 'خيار', 'خيار طازج', 130.00, 260.00, 'weight', 'kg', 70, 'vegetable', TRUE, 50, TRUE, 'winter', NOW() - INTERVAL '3 days'),
(3, 'باذنجان', 'باذنجان أسود', 170.00, 170.00, 'weight', 'kg', 100, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '5 days'),

-- Producteur 4 (Ferme Fatima) - 6 produits
(4, 'Fraises', 'Fraises de saison', 600.00, 600.00, 'weight', 'kg', 50, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '2 days'),
(4, 'Bananes', 'Bananes importées fraîches', 350.00, 350.00, 'weight', 'kg', 120, 'fruit', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '4 days'),
(4, 'Raisins', 'Raisins blancs sans pépins', 500.00, 500.00, 'weight', 'kg', 80, 'fruit', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '6 days'),
(4, 'Grenades', 'Grenades juteuses', 400.00, 400.00, 'weight', 'kg', 100, 'fruit', FALSE, 0, TRUE, 'fall', NOW() - INTERVAL '10 days'),
(4, 'Kiwis', 'Kiwis verts', 450.00, 900.00, 'weight', 'kg', 40, 'fruit', TRUE, 50, FALSE, NULL, NOW() - INTERVAL '3 days'),
(4, 'Poires', 'Poires Williams', 380.00, 380.00, 'weight', 'kg', 90, 'fruit', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '7 days'),

-- Producteur 5 (Rachid Bio) - 6 produits
(5, 'Huile d''Olive Bio', 'Huile d''olive extra vierge 1L', 1200.00, 1200.00, 'unit', 'liter', 100, 'other', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '30 days'),
(5, 'Olives Vertes', 'Olives vertes marinées 500g', 400.00, 400.00, 'unit', 'jar', 150, 'other', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '25 days'),
(5, 'Olives Noires', 'Olives noires marinées 500g', 380.00, 380.00, 'unit', 'jar', 140, 'other', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '25 days'),
(5, 'Miel de Montagne', 'Miel pur de montagne 1kg', 2500.00, 2500.00, 'unit', 'kg', 50, 'honey', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '45 days'),
(5, 'Figues Sèches', 'Figues sèches 500g', 600.00, 600.00, 'unit', 'pack', 80, 'fruit', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '20 days'),
(5, 'Amandes', 'Amandes décortiquées 500g', 800.00, 1600.00, 'unit', 'pack', 30, 'other', TRUE, 50, FALSE, NULL, NOW() - INTERVAL '3 days'),

-- Producteur 6 (Zahia Produits) - 6 produits
(6, 'Couscous Artisanal', 'Couscous fait main 1kg', 350.00, 350.00, 'unit', 'kg', 200, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '10 days'),
(6, 'Huile d''Olive Traditionnelle', 'Huile d''olive 1L', 900.00, 900.00, 'unit', 'liter', 120, 'other', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '35 days'),
(6, 'Figues Fraîches', 'Figues de Kabylie', 500.00, 500.00, 'weight', 'kg', 60, 'fruit', FALSE, 0, TRUE, 'summer', NOW() - INTERVAL '5 days'),
(6, 'Confiture de Figues', 'Confiture artisanale 500g', 450.00, 450.00, 'unit', 'jar', 100, 'other', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '15 days'),
(6, 'Kesra (Pain Kabyle)', 'Pain traditionnel kabyle', 200.00, 400.00, 'unit', 'piece', 40, 'grain', TRUE, 50, FALSE, NULL, NOW() - INTERVAL '3 days'),
(6, 'Semoule Fine', 'Semoule fine 1kg', 280.00, 280.00, 'unit', 'kg', 150, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '12 days'),

-- Producteur 7 (Youcef Organic) - 6 produits
(7, 'Salade Verte Bio', 'Salade verte biologique', 120.00, 120.00, 'unit', 'piece', 150, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '1 day'),
(7, 'Épinards Bio', 'Épinards frais biologiques', 200.00, 200.00, 'weight', 'kg', 80, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '2 days'),
(7, 'Persil', 'Persil frais', 50.00, 50.00, 'unit', 'bunch', 200, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '1 day'),
(7, 'Coriandre', 'Coriandre fraîche', 50.00, 50.00, 'unit', 'bunch', 180, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '1 day'),
(7, 'Menthe', 'Menthe fraîche', 50.00, 100.00, 'unit', 'bunch', 100, 'vegetable', TRUE, 50, TRUE, 'winter', NOW() - INTERVAL '3 days'),
(7, 'Roquette', 'Roquette biologique', 150.00, 150.00, 'weight', 'kg', 60, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '2 days'),

-- Producteur 8 (Amina Exploitation) - 6 produits
(8, 'Blé Dur', 'Blé dur local 1kg', 180.00, 180.00, 'unit', 'kg', 500, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '40 days'),
(8, 'Orge', 'Orge locale 1kg', 150.00, 150.00, 'unit', 'kg', 400, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '40 days'),
(8, 'Pois Chiches', 'Pois chiches 1kg', 250.00, 250.00, 'unit', 'kg', 300, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '30 days'),
(8, 'Lentilles Vertes', 'Lentilles vertes 1kg', 280.00, 280.00, 'unit', 'kg', 250, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '30 days'),
(8, 'Haricots Blancs', 'Haricots blancs 1kg', 300.00, 600.00, 'unit', 'kg', 100, 'grain', TRUE, 50, FALSE, NULL, NOW() - INTERVAL '3 days'),
(8, 'Fèves Sèches', 'Fèves sèches 1kg', 200.00, 200.00, 'unit', 'kg', 200, 'grain', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '35 days'),

-- Producteur 9 (Saïd Agriculture) - 6 produits
(9, 'Œufs Frais', 'Œufs fermiers (boîte de 6)', 250.00, 250.00, 'unit', 'box', 200, 'other', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '2 days'),
(9, 'Poulet Fermier', 'Poulet élevé en plein air', 800.00, 800.00, 'unit', 'kg', 50, 'meat', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '1 day'),
(9, 'Lait Frais', 'Lait de vache frais 1L', 150.00, 150.00, 'unit', 'liter', 100, 'dairy', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '1 day'),
(9, 'Yaourt Artisanal', 'Yaourt fait maison (pot 1L)', 200.00, 200.00, 'unit', 'jar', 80, 'dairy', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '2 days'),
(9, 'Fromage Frais', 'Fromage frais fermier 500g', 400.00, 800.00, 'unit', 'pack', 30, 'dairy', TRUE, 50, FALSE, NULL, NOW() - INTERVAL '3 days'),
(9, 'Beurre Fermier', 'Beurre traditionnel 250g', 350.00, 350.00, 'unit', 'pack', 60, 'dairy', FALSE, 0, FALSE, NULL, NOW() - INTERVAL '4 days'),

-- Producteur 10 (Nadia Bio & Fresh) - 6 produits
(10, 'Poivrons Rouges Bio', 'Poivrons rouges biologiques', 280.00, 280.00, 'weight', 'kg', 100, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '5 days'),
(10, 'Brocoli Bio', 'Brocoli frais biologique', 300.00, 300.00, 'weight', 'kg', 70, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '3 days'),
(10, 'Chou-fleur Bio', 'Chou-fleur blanc biologique', 250.00, 250.00, 'unit', 'piece', 80, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '4 days'),
(10, 'Betteraves Bio', 'Betteraves rouges biologiques', 180.00, 180.00, 'weight', 'kg', 120, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '7 days'),
(10, 'Navets Bio', 'Navets blancs biologiques', 140.00, 280.00, 'weight', 'kg', 50, 'vegetable', TRUE, 50, TRUE, 'winter', NOW() - INTERVAL '3 days'),
(10, 'Radis Bio', 'Radis rouges biologiques', 100.00, 100.00, 'weight', 'kg', 90, 'vegetable', FALSE, 0, TRUE, 'winter', NOW() - INTERVAL '2 days');

-- =============================================
-- SEASONAL BASKETS (8 paniers saisonniers)
-- =============================================
INSERT INTO seasonal_baskets (producer_id, name, description, discount_percentage, delivery_frequency, is_active) VALUES
(1, 'Panier Hiver Bio', 'Sélection de légumes biologiques d''hiver', 15, 'weekly', TRUE),
(2, 'Panier Agrumes Premium', 'Les meilleurs agrumes de Blida', 10, 'weekly', TRUE),
(3, 'السلة الأسبوعية', 'سلة الخضار والفواكه الطازجة', 12, 'weekly', TRUE),
(4, 'Panier Fruits Exotiques', 'Fruits exotiques et de saison', 20, 'biweekly', TRUE),
(5, 'Panier Terroir Kabyle', 'Produits du terroir kabyle', 8, 'monthly', TRUE),
(7, 'Panier Herbes Fraîches', 'Herbes aromatiques et salades bio', 15, 'weekly', TRUE),
(9, 'Panier Fermier Complet', 'Œufs, lait, fromage et yaourt', 10, 'weekly', TRUE),
(10, 'Panier Légumes Premium Bio', 'Légumes biologiques premium', 18, 'weekly', TRUE);

-- =============================================
-- SEASONAL BASKET PRODUCTS (Produits dans les paniers)
-- =============================================
INSERT INTO seasonal_basket_products (basket_id, product_id, quantity) VALUES
-- Panier 1 (Hiver Bio - Ferme Ali)
(1, 1, 2),  -- Tomates Bio 2kg
(1, 2, 1),  -- Courgettes 1kg
(1, 4, 3),  -- Pommes de terre 3kg
(1, 6, 3),  -- Laitues 3 pièces

-- Panier 2 (Agrumes - Karim)
(2, 7, 3),  -- برتقال 3kg
(2, 8, 2),  -- Citrons 2kg
(2, 9, 2),  -- Mandarines 2kg
(2, 11, 1), -- Clémentines 1kg

-- Panier 3 (السلة الأسبوعية - Mohamed)
(3, 13, 2), -- طماطم 2kg
(3, 14, 1), -- فلفل 1kg
(3, 15, 2), -- بصل 2kg
(3, 16, 2), -- بطاطا 2kg

-- Panier 4 (Fruits Exotiques - Fatima)
(4, 19, 1), -- Fraises 1kg
(4, 20, 2), -- Bananes 2kg
(4, 21, 1), -- Raisins 1kg
(4, 24, 1), -- Poires 1kg

-- Panier 5 (Terroir Kabyle - Rachid)
(5, 25, 1), -- Huile d'Olive Bio 1L
(5, 26, 2), -- Olives Vertes 2 pots
(5, 28, 1), -- Miel 1kg
(5, 29, 1), -- Figues Sèches 1 pack

-- Panier 6 (Herbes Fraîches - Youcef)
(6, 37, 3), -- Salade Verte 3 pièces
(6, 38, 1), -- Épinards 1kg
(6, 39, 2), -- Persil 2 bottes
(6, 40, 2), -- Coriandre 2 bottes
(6, 41, 2), -- Menthe 2 bottes

-- Panier 7 (Fermier - Saïd)
(7, 49, 3), -- Œufs 3 boîtes
(7, 51, 2), -- Lait 2L
(7, 52, 2), -- Yaourt 2 pots
(7, 54, 1), -- Beurre 1 pack

-- Panier 8 (Légumes Premium - Nadia)
(8, 55, 2), -- Poivrons Rouges 2kg
(8, 56, 1), -- Brocoli 1kg
(8, 57, 2), -- Chou-fleur 2 pièces
(8, 58, 1); -- Betteraves 1kg

-- =============================================
-- SUBSCRIPTIONS (15 abonnements actifs)
-- =============================================
INSERT INTO subscriptions (client_id, basket_id, status, delivery_method, delivery_address, next_delivery) VALUES
(11, 1, 'active', 'home_delivery', 'Cité 1024 Logts, Bt 12, Bab Ezzouar', NOW() + INTERVAL '3 days'),
(11, 6, 'active', 'home_delivery', 'Cité 1024 Logts, Bt 12, Bab Ezzouar', NOW() + INTERVAL '4 days'),
(12, 2, 'active', 'pickup', NULL, NOW() + INTERVAL '5 days'),
(13, 1, 'active', 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() + INTERVAL '3 days'),
(13, 8, 'active', 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() + INTERVAL '2 days'),
(14, 7, 'paused', 'home_delivery', 'Lotissement El Yasmine, Bir El Djir', NULL),
(15, 3, 'active', 'home_delivery', 'Cité Zouaghi, Constantine', NOW() + INTERVAL '6 days'),
(16, 4, 'active', 'pickup', NULL, NOW() + INTERVAL '10 days'),
(17, 5, 'active', 'home_delivery', 'Cité 1000 Logts, Sétif', NOW() + INTERVAL '15 days'),
(18, 1, 'active', 'home_delivery', 'Quartier Sidi Ahmed, Béjaïa', NOW() + INTERVAL '3 days'),
(19, 6, 'active', 'home_delivery', 'Nouvelle ville, Tizi Ouzou', NOW() + INTERVAL '4 days'),
(19, 7, 'active', 'home_delivery', 'Nouvelle ville, Tizi Ouzou', NOW() + INTERVAL '5 days'),
(20, 2, 'cancelled', 'home_delivery', 'Cité Plaine Ouest, Annaba', NULL),
(12, 8, 'active', 'pickup', NULL, NOW() + INTERVAL '3 days'),
(15, 7, 'active', 'home_delivery', 'Cité Zouaghi, Constantine', NOW() + INTERVAL '6 days');

-- =============================================
-- CART ITEMS (Paniers en cours - 12 clients avec articles)
-- =============================================
INSERT INTO cart_items (client_id, product_id, quantity) VALUES
-- Client Sara (11)
(11, 1, 2),
(11, 3, 3),
(11, 19, 1),

-- Client Hamza (12)
(12, 7, 5),
(12, 20, 2),

-- Client Lynda (13)
(13, 25, 1),
(13, 28, 1),
(13, 55, 2),

-- Client Kamel (14)
(14, 49, 2),
(14, 51, 3),

-- Client Samia (15)
(15, 13, 3),
(15, 15, 2),
(15, 16, 4),

-- Client Farid (16)
(16, 37, 4),
(16, 39, 3),
(16, 40, 3),

-- Client Meriem (17)
(17, 31, 2),
(17, 43, 3),

-- Client Nassim (18)
(18, 1, 2),
(18, 2, 1),
(18, 4, 5),

-- Client Sihem (19)
(19, 56, 1),
(19, 57, 2),
(19, 58, 2),

-- Client Rabah (20)
(20, 20, 3),
(20, 21, 1);

-- =============================================
-- ORDERS (25 commandes historiques)
-- =============================================
INSERT INTO orders (order_number, client_id, producer_id, parent_order_id, is_parent, status, total, delivery_method, delivery_address, created_at, delivered_at) VALUES
-- Commandes livrées
('ORD-2025-001', 11, 1, NULL, TRUE, 'delivered', 1200.00, 'home_delivery', 'Cité 1024 Logts, Bt 12, Bab Ezzouar', NOW() - INTERVAL '20 days', NOW() - INTERVAL '18 days'),
('ORD-2025-002', 12, 2, NULL, TRUE, 'delivered', 850.00, 'pickup', NULL, NOW() - INTERVAL '18 days', NOW() - INTERVAL '16 days'),
('ORD-2025-003', 13, 1, NULL, TRUE, 'delivered', 1500.00, 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() - INTERVAL '17 days', NOW() - INTERVAL '15 days'),
('ORD-2025-004', 14, 7, NULL, TRUE, 'delivered', 400.00, 'home_delivery', 'Lotissement El Yasmine, Bir El Djir', NOW() - INTERVAL '15 days', NOW() - INTERVAL '13 days'),
('ORD-2025-005', 15, 3, NULL, TRUE, 'delivered', 980.00, 'home_delivery', 'Cité Zouaghi, Constantine', NOW() - INTERVAL '14 days', NOW() - INTERVAL '12 days'),
('ORD-2025-006', 16, 4, NULL, TRUE, 'delivered', 1100.00, 'pickup', NULL, NOW() - INTERVAL '13 days', NOW() - INTERVAL '11 days'),
('ORD-2025-007', 17, 5, NULL, TRUE, 'delivered', 3200.00, 'home_delivery', 'Cité 1000 Logts, Sétif', NOW() - INTERVAL '12 days', NOW() - INTERVAL '10 days'),
('ORD-2025-008', 18, 1, NULL, TRUE, 'delivered', 750.00, 'home_delivery', 'Quartier Sidi Ahmed, Béjaïa', NOW() - INTERVAL '11 days', NOW() - INTERVAL '9 days'),
('ORD-2025-009', 19, 6, NULL, TRUE, 'delivered', 1400.00, 'home_delivery', 'Nouvelle ville, Tizi Ouzou', NOW() - INTERVAL '10 days', NOW() - INTERVAL '8 days'),
('ORD-2025-010', 20, 2, NULL, TRUE, 'delivered', 620.00, 'home_delivery', 'Cité Plaine Ouest, Annaba', NOW() - INTERVAL '9 days', NOW() - INTERVAL '7 days'),

-- Commandes expédiées
('ORD-2025-011', 11, 10, NULL, TRUE, 'shipped', 890.00, 'home_delivery', 'Cité 1024 Logts, Bt 12, Bab Ezzouar', NOW() - INTERVAL '3 days', NULL),
('ORD-2025-012', 13, 9, NULL, TRUE, 'shipped', 1050.00, 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() - INTERVAL '2 days', NULL),
('ORD-2025-013', 15, 8, NULL, TRUE, 'shipped', 780.00, 'home_delivery', 'Cité Zouaghi, Constantine', NOW() - INTERVAL '2 days', NULL),

-- Commandes confirmées
('ORD-2025-014', 12, 7, NULL, TRUE, 'confirmed', 550.00, 'pickup', NULL, NOW() - INTERVAL '1 day', NULL),
('ORD-2025-015', 17, 1, NULL, TRUE, 'confirmed', 920.00, 'home_delivery', 'Cité 1000 Logts, Sétif', NOW() - INTERVAL '1 day', NULL),
('ORD-2025-016', 19, 4, NULL, TRUE, 'confirmed', 1300.00, 'home_delivery', 'Nouvelle ville, Tizi Ouzou', NOW() - INTERVAL '1 day', NULL),

-- Commandes en attente
('ORD-2025-017', 11, 5, NULL, TRUE, 'pending', 2400.00, 'home_delivery', 'Cité 1024 Logts, Bt 12, Bab Ezzouar', NOW() - INTERVAL '5 hours', NULL),
('ORD-2025-018', 14, 3, NULL, TRUE, 'pending', 670.00, 'home_delivery', 'Lotissement El Yasmine, Bir El Djir', NOW() - INTERVAL '4 hours', NULL),
('ORD-2025-019', 16, 6, NULL, TRUE, 'pending', 1150.00, 'pickup', NULL, NOW() - INTERVAL '3 hours', NULL),
('ORD-2025-020', 18, 2, NULL, TRUE, 'pending', 980.00, 'home_delivery', 'Quartier Sidi Ahmed, Béjaïa', NOW() - INTERVAL '2 hours', NULL),
('ORD-2025-021', 20, 10, NULL, TRUE, 'pending', 740.00, 'home_delivery', 'Cité Plaine Ouest, Annaba', NOW() - INTERVAL '1 hour', NULL),

-- Commandes multi-producteurs (parent-child)
('ORD-2025-022', 13, NULL, NULL, TRUE, 'confirmed', 1850.00, 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() - INTERVAL '6 hours', NULL),
('ORD-2025-022-A', 13, 1, 22, FALSE, 'confirmed', 900.00, 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() - INTERVAL '6 hours', NULL),
('ORD-2025-022-B', 13, 4, 22, FALSE, 'confirmed', 950.00, 'home_delivery', 'Résidence Les Jardins, Hydra', NOW() - INTERVAL '6 hours', NULL),

('ORD-2025-023', 19, NULL, NULL, TRUE, 'pending', 2100.00, 'home_delivery', 'Nouvelle ville, Tizi Ouzou', NOW() - INTERVAL '30 minutes', NULL);

-- =============================================
-- ORDER ITEMS (Détails des commandes)
-- =============================================
INSERT INTO order_items (order_id, product_id, product_name, product_photo, quantity, unit_price, subtotal) VALUES
-- ORD-2025-001 (Client 11, Producteur 1)
(1, 1, 'Tomates Bio', '', 3, 250.00, 750.00),
(1, 3, 'Oranges', '', 2, 200.00, 400.00),
(1, 6, 'Laitues', '', 2, 80.00, 160.00),

-- ORD-2025-002 (Client 12, Producteur 2)
(2, 7, 'برتقال', '', 4, 180.00, 720.00),
(2, 8, 'Citrons', '', 1, 220.00, 220.00),

-- ORD-2025-003 (Client 13, Producteur 1)
(3, 1, 'Tomates Bio', '', 4, 250.00, 1000.00),
(3, 4, 'Pommes de terre', '', 5, 120.00, 600.00),

-- ORD-2025-004 (Client 14, Producteur 7)
(4, 37, 'Salade Verte Bio', '', 5, 120.00, 600.00),

-- ORD-2025-005 (Client 15, Producteur 3)
(5, 13, 'طماطم', '', 3, 150.00, 450.00),
(5, 15, 'بصل', '', 4, 100.00, 400.00),
(5, 16, 'بطاطا', '', 2, 110.00, 220.00),

-- ORD-2025-006 (Client 16, Producteur 4)
(6, 19, 'Fraises', '', 1, 600.00, 600.00),
(6, 20, 'Bananes', '', 2, 350.00, 700.00),

-- ORD-2025-007 (Client 17, Producteur 5)
(7, 25, 'Huile d''Olive Bio', '', 2, 1200.00, 2400.00),
(7, 28, 'Miel de Montagne', '', 1, 2500.00, 2500.00),

-- ORD-2025-008 (Client 18, Producteur 1)
(8, 2, 'Courgettes', '', 2, 180.00, 360.00),
(8, 6, 'Laitues', '', 3, 80.00, 240.00),

-- ORD-2025-009 (Client 19, Producteur 6)
(9, 31, 'Couscous Artisanal', '', 4, 350.00, 1400.00),

-- ORD-2025-010 (Client 20, Producteur 2)
(10, 9, 'Mandarines', '', 2, 280.00, 560.00),
(10, 11, 'Clémentines', '', 1, 300.00, 300.00),

-- ORD-2025-011 (Client 11, Producteur 10)
(11, 55, 'Poivrons Rouges Bio', '', 2, 280.00, 560.00),
(11, 56, 'Brocoli Bio', '', 1, 300.00, 300.00),

-- ORD-2025-012 (Client 13, Producteur 9)
(12, 49, 'Œufs Frais', '', 3, 250.00, 750.00),
(12, 51, 'Lait Frais', '', 2, 150.00, 300.00),

-- ORD-2025-013 (Client 15, Producteur 8)
(13, 43, 'Pois Chiches', '', 2, 250.00, 500.00),
(13, 44, 'Lentilles Vertes', '', 1, 280.00, 280.00),

-- ORD-2025-014 (Client 12, Producteur 7)
(14, 39, 'Persil', '', 5, 50.00, 250.00),
(14, 40, 'Coriandre', '', 4, 50.00, 200.00),
(14, 41, 'Menthe', '', 2, 50.00, 100.00),

-- ORD-2025-015 (Client 17, Producteur 1)
(15, 1, 'Tomates Bio', '', 2, 250.00, 500.00),
(15, 3, 'Oranges', '', 2, 200.00, 400.00),

-- ORD-2025-016 (Client 19, Producteur 4)
(16, 21, 'Raisins', '', 2, 500.00, 1000.00),
(16, 24, 'Poires', '', 1, 380.00, 380.00),

-- ORD-2025-017 (Client 11, Producteur 5)
(17, 25, 'Huile d''Olive Bio', '', 2, 1200.00, 2400.00),

-- ORD-2025-018 (Client 14, Producteur 3)
(18, 14, 'فلفل أخضر', '', 2, 200.00, 400.00),
(18, 18, 'باذنجان', '', 1, 170.00, 170.00),

-- ORD-2025-019 (Client 16, Producteur 6)
(19, 32, 'Huile d''Olive Traditionnelle', '', 1, 900.00, 900.00),
(19, 34, 'Confiture de Figues', '', 1, 450.00, 450.00),

-- ORD-2025-020 (Client 18, Producteur 2)
(20, 7, 'برتقال', '', 4, 180.00, 720.00),
(20, 9, 'Mandarines', '', 1, 280.00, 280.00),

-- ORD-2025-021 (Client 20, Producteur 10)
(21, 57, 'Chou-fleur Bio', '', 2, 250.00, 500.00),
(21, 58, 'Betteraves Bio', '', 1, 180.00, 180.00),

-- ORD-2025-022-A (Sous-commande Producteur 1)
(23, 1, 'Tomates Bio', '', 2, 250.00, 500.00),
(23, 4, 'Pommes de terre', '', 3, 120.00, 360.00),

-- ORD-2025-022-B (Sous-commande Producteur 4)
(24, 19, 'Fraises', '', 1, 600.00, 600.00),
(24, 20, 'Bananes', '', 1, 350.00, 350.00);

-- =============================================
-- STATISTIQUES FINALES
-- =============================================

-- Mise à jour des statistiques producteurs (total_sales)
UPDATE producer_profiles pp
SET total_sales = (
    SELECT COUNT(DISTINCT o.id)
    FROM orders o
    WHERE o.producer_id = pp.user_id
    AND o.status IN ('delivered', 'shipped', 'confirmed')
)
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.producer_id = pp.user_id
);

-- Mise à jour des statistiques clients (total_orders)
UPDATE client_profiles cp
SET total_orders = (
    SELECT COUNT(DISTINCT o.id)
    FROM orders o
    WHERE o.client_id = cp.user_id
    AND o.is_parent = TRUE
)
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.client_id = cp.user_id
);

-- =============================================
-- VERIFICATION DES DONNEES
-- =============================================

SELECT 'SEEDING COMPLETE!' as status;
SELECT 'Users: ' || COUNT(*) FROM users;
SELECT 'Producers: ' || COUNT(*) FROM producer_profiles;
SELECT 'Clients: ' || COUNT(*) FROM client_profiles;
SELECT 'Products: ' || COUNT(*) FROM products;
SELECT 'Anti-Gaspi Products: ' || COUNT(*) FROM products WHERE is_anti_gaspi = TRUE;
SELECT 'Seasonal Baskets: ' || COUNT(*) FROM seasonal_baskets;
SELECT 'Active Subscriptions: ' || COUNT(*) FROM subscriptions WHERE status = 'active';
SELECT 'Cart Items: ' || COUNT(*) FROM cart_items;
SELECT 'Orders: ' || COUNT(*) FROM orders;
SELECT 'Order Items: ' || COUNT(*) FROM order_items;