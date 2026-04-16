-- ============================================================================
-- Pharmacy Warehouse Service — Master Data Seed
-- Run: psql -d <your_db> -f prisma/seed/master-data.sql
-- ============================================================================
-- organizationId = NULL means global default data, accessible by all
-- organizations. Specific organizations can override by inserting their own
-- records with a non-null organizationId.
-- All inserts use ON CONFLICT DO NOTHING for idempotent re-runs.
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. Unit of Measure (base units first, then derived)
-- ============================================================================
-- Hierarchy: carton(100) → box(10) → tablet(1)
-- Hierarchy: bottle(100ml) → milliliter(1ml)
-- Hierarchy: kilogram(1000g) → gram(1g)

-- Base units
INSERT INTO "UnitOfMeasure" ("id", "code", "name", "abbreviation", "isBase", "baseUnitId", "conversionFactor", "isActive","organizationId")
VALUES
  ('uom-tablet',     'tablet',     'Tablet',     'tbl', true, NULL, NULL,     true, NULL),
  ('uom-capsule',    'capsule',    'Capsule',    'cap', true, NULL, NULL,     true, NULL),
  ('uom-milliliter', 'milliliter', 'Milliliter', 'ml',  true, NULL, NULL,     true, NULL),
  ('uom-gram',       'gram',       'Gram',       'g',   true, NULL, NULL,     true, NULL),
  ('uom-piece',      'piece',      'Piece',      'pcs', true, NULL, NULL,     true, NULL),
  ('uom-ampoule',    'ampoule',    'Ampoule',    'amp', true, NULL, NULL,     true, NULL),
  ('uom-vial',       'vial',       'Vial',       'via', true, NULL, NULL,     true, NULL),
  ('uom-sachet',     'sachet',     'Sachet',     'sac', true, NULL, NULL,     true, NULL),
  ('uom-tube',       'tube',       'Tube',       'tub', true, NULL, NULL,     true, NULL),
  ('uom-drop',       'drop',       'Drop',       'drt', true, NULL, NULL,     true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Derived units
INSERT INTO "UnitOfMeasure" ("id", "code", "name", "abbreviation", "isBase", "baseUnitId", "conversionFactor", "isActive","organizationId")
VALUES
  ('uom-box-tablet',     'box-tablet',     'Box',     'box', false, 'uom-tablet',     10.0000,    true, NULL),
  ('uom-box-capsule',    'box-capsule',    'Box',     'box', false, 'uom-capsule',    10.0000,    true, NULL),
  ('uom-box-ampoule',    'box-ampoule',    'Box',     'box', false, 'uom-ampoule',    10.0000,    true, NULL),
  ('uom-box-sachet',     'box-sachet',     'Box',     'box', false, 'uom-sachet',     10.0000,    true, NULL),
  ('uom-box-piece',      'box-piece',      'Box',     'box', false, 'uom-piece',      10.0000,    true, NULL),
  ('uom-bottle-ml',      'bottle-ml',      'Bottle',  'btl', false, 'uom-milliliter', 100.0000,   true, NULL),
  ('uom-bottle-drop',    'bottle-drop',    'Bottle',  'btl', false, 'uom-drop',       15.0000,    true, NULL),
  ('uom-kilogram',       'kilogram',       'Kilogram','kg',  false, 'uom-gram',       1000.0000,  true, NULL),
  ('uom-carton-tablet',  'carton-tablet',  'Carton',  'ctn', false, 'uom-box-tablet', 10.0000,    true, NULL),
  ('uom-carton-capsule', 'carton-capsule', 'Carton',  'ctn', false, 'uom-box-capsule',10.0000,    true, NULL),
  ('uom-carton-box-pcs', 'carton-box-pcs', 'Carton',  'ctn', false, 'uom-box-piece',  10.0000,    true, NULL),
  ('uom-strip',          'strip',          'Strip',   'str', false, 'uom-tablet',     10.0000,    true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 2. Product Categories (hierarchical)
-- ============================================================================

-- Level 1 — Root categories
INSERT INTO "ProductCategory" ("id", "name", "description", "parentId","organizationId")
VALUES
  ('cat-medicines',        'Medicines',        'Finished pharmaceutical products',       NULL, NULL),
  ('cat-raw-materials',    'Raw Materials',    'Active ingredients and excipients',       NULL, NULL),
  ('cat-medical-supplies', 'Medical Supplies', 'Consumable medical supplies',             NULL, NULL)
ON CONFLICT (id) DO NOTHING;

-- Level 2 — Subcategories for Medicines
INSERT INTO "ProductCategory" ("id", "name", "description", "parentId","organizationId")
VALUES
  ('cat-analgesics',       'Analgesics',       'Pain relief medications',        'cat-medicines', NULL),
  ('cat-antibiotics',      'Antibiotics',      'Antibacterial medications',      'cat-medicines', NULL),
  ('cat-antipyretics',     'Antipyretics',     'Fever reduction medications',    'cat-medicines', NULL),
  ('cat-antihypertensive', 'Antihypertensive', 'Blood pressure medications',     'cat-medicines', NULL),
  ('cat-antidiabetic',     'Antidiabetic',     'Diabetes medications',           'cat-medicines', NULL),
  ('cat-gi-drugs',         'GI Drugs',         'Gastrointestinal medications',   'cat-medicines', NULL),
  ('cat-respiratory',      'Respiratory',      'Respiratory tract medications',  'cat-medicines', NULL),
  ('cat-dermatological',   'Dermatological',   'Skin treatments',                'cat-medicines', NULL),
  ('cat-eye-ear',          'Eye & Ear',        'Ophthalmic and otic products',   'cat-medicines', NULL),
  ('cat-vitamins',         'Vitamins',         'Vitamin and mineral supplements', 'cat-medicines', NULL)
ON CONFLICT (id) DO NOTHING;

-- Level 3 — Subcategories for Antibiotics
INSERT INTO "ProductCategory" ("id", "name", "description", "parentId","organizationId")
VALUES
  ('cat-penicillins',    'Penicillins',    'Penicillin-class antibiotics',     'cat-antibiotics', NULL),
  ('cat-cephalosporins', 'Cephalosporins', 'Cephalosporin-class antibiotics', 'cat-antibiotics', NULL),
  ('cat-macrolides',     'Macrolides',     'Macrolide-class antibiotics',     'cat-antibiotics', NULL),
  ('cat-fluoroquinolones','Fluoroquinolones','Fluoroquinolone-class antibiotics','cat-antibiotics', NULL)
ON CONFLICT (id) DO NOTHING;

-- Level 2 — Subcategories for Raw Materials
INSERT INTO "ProductCategory" ("id", "name", "description", "parentId","organizationId")
VALUES
  ('cat-api',               'Active Pharmaceutical Ingredients', 'APIs for compounding',           'cat-raw-materials', NULL),
  ('cat-excipients',        'Excipients',                        'Formulation excipients',          'cat-raw-materials', NULL),
  ('cat-suspending-agents', 'Suspending Agents',                 'Agents for liquid preparations',   'cat-raw-materials', NULL),
  ('cat-compounding-output','Compounding Output Products',        'Products produced by compounding', 'cat-medicines',     NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 3. Manufacturers
-- ============================================================================

INSERT INTO "Manufacturer" ("id", "code", "name", "contactEmail", "contactPhone", "address", "isActive","organizationId")
VALUES
  ('mfr-kimia-farma', 'KIMIA-FARMA', 'PT Kimia Farma (Persero) Tbk',     'info@kimiafarma.co.id',    '+62-22-7332026',  'Jl. Brigjen Katamso No.1, Bandung, Jawa Barat',    true, NULL),
  ('mfr-kalbe',       'KALBE',       'PT Kalbe Farma Tbk',                'info@kalbe.co.id',         '+62-21-5445888',  'Jl. Pulomas Barat Kav. 8, Jakarta Timur',         true, NULL),
  ('mfr-indofarma',   'INDOFARMA',   'PT Indofarma (Persero) Tbk',        'info@indofarma.co.id',     '+62-21-8243611',  'Jl. Raya Industri Cikarang, Bekasi, Jawa Barat',   true, NULL),
  ('mfr-dexa',        'DEXA',        'Dexa Medica',                        'info@dexa-medica.com',     '+62-21-8564000',  'Jl. Industri No.5, Cikarang, Bekasi',              true, NULL),
  ('mfr-soho',        'SOHO',        'PT SOHO Global Health',              'info@sohoglobalhealth.com','+62-21-89349999', 'Jl. MT Haryono Kav. 8, Jakarta Selatan',          true, NULL),
  ('mfr-bernofarm',   'BERNOFARM',   'PT Bernofarm',                       'info@bernofarm.co.id',     '+62-31-7416666',  'Jl. Brigjen Katamso No.1, Surabaya',               true, NULL),
  ('mfr-meprofarm',   'MEPROFARM',   'PT Meprofarm',                       'info@meprofarm.com',       '+62-265-337111',  'Jl. Raya Cianjur Km.14, Cianjur, Jawa Barat',     true, NULL),
  ('mfr-inhouse',     'IN-HOUSE',    'In-House Compounding',               NULL,                       NULL,              'Internal compounding production',                   true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 4. Suppliers
-- ============================================================================

INSERT INTO "Supplier" ("id", "code", "name", "contactEmail", "contactPhone", "address", "isActive","organizationId")
VALUES
  ('sup-distributor-indo', 'DIST-INDO',    'PT Distributor Indo Farma',       'order@distindo.co.id',       '+62-21-55667788', 'Jl. Pusat Distribusi, Jakarta Utara',               true, NULL),
  ('sup-pharma-supply',    'PHARMA-SUP',   'PT Pharma Supply Chain',          'sales@pharmasupply.co.id',   '+62-21-33445566', 'Jl. Logistik No.10, Cakung, Jakarta Timur',         true, NULL),
  ('sup-medika-abadi',     'MED-ABADI',    'CV Medika Abadi',                 'order@medikaabadi.com',      '+62-31-77889900', 'Jl. Pasar Besar No.5, Surabaya',                     true, NULL),
  ('sup-chem-raw',         'CHEM-RAW',     'PT Chemical Raw Indonesia',       'sales@chemraw.co.id',        '+62-21-11223344', 'Jl. Kimia No.3, Kawasan Industri MM2100, Bekasi',    true, NULL),
  ('sup-global-pharma',    'GLOBAL-PHARMA','PT Global Pharma Distribution',   'info@globalpharma.co.id',    '+62-21-55661234', 'Jl. Angkasa No.15, Kemayoran, Jakarta',              true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 5. Warehouse Locations
-- ============================================================================

INSERT INTO "WarehouseLocation" ("id", "code", "name", "zone", "shelf", "bin", "locationType", "isActive","organizationId")
VALUES
  ('loc-bulk-a-1', 'BULK-A-1', 'Bulk Storage Zone A - Shelf 1', 'A',  '1', '01-05', 'BULK_STORAGE', true, NULL),
  ('loc-bulk-a-2', 'BULK-A-2', 'Bulk Storage Zone A - Shelf 2', 'A',  '2', '01-05', 'BULK_STORAGE', true, NULL),
  ('loc-bulk-b-1', 'BULK-B-1', 'Bulk Storage Zone B - Shelf 1', 'B',  '1', '01-05', 'BULK_STORAGE', true, NULL),
  ('loc-bulk-b-2', 'BULK-B-2', 'Bulk Storage Zone B - Shelf 2', 'B',  '2', '01-05', 'BULK_STORAGE', true, NULL),
  ('loc-pick-c-1', 'PICK-C-1', 'Picking Area Zone C - Shelf 1', 'C',  '1', '01-10', 'PICKING',      true, NULL),
  ('loc-pick-c-2', 'PICK-C-2', 'Picking Area Zone C - Shelf 2', 'C',  '2', '01-10', 'PICKING',      true, NULL),
  ('loc-pick-c-3', 'PICK-C-3', 'Picking Area Zone C - Shelf 3', 'C',  '3', '01-10', 'PICKING',      true, NULL),
  ('loc-cold-1',   'COLD-01',  'Cold Storage Room 1',            'CS', '1', '01-04', 'COLD_STORAGE', true, NULL),
  ('loc-cold-2',   'COLD-02',  'Cold Storage Room 2',            'CS', '2', '01-04', 'COLD_STORAGE', true, NULL),
  ('loc-quar-1',   'QUAR-01',  'Quarantine Area',                'Q',  '1', '01-03', 'QUARANTINE',   true, NULL),
  ('loc-lab-1',    'LAB-01',   'Laboratory',                      'L',  '1', '01-02', 'LABORATORY',   true, NULL),
  ('loc-lab-2',    'LAB-02',   'Lab Raw Material Storage',        'L',  '2', '01-04', 'LABORATORY',   true, NULL),
  ('loc-disp-1',   'DISP-01',  'Dispensing Counter 1',           'D',  '1', '01-05', 'DISPENSING',   true, NULL),
  ('loc-disp-2',   'DISP-02',  'Dispensing Counter 2',           'D',  '2', '01-05', 'DISPENSING',   true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 6. Products — Finished Goods (commercial)
-- ============================================================================

-- Analgesics
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-para-500',      'PARA-500',  'Paracetamol 500mg',             'Analgesic & Antipyretic',      'FINISHED_GOOD', 'Tablet', '500mg',    200, 5000, 'cat-analgesics',   'mfr-kimia-farma', 'uom-tablet',    'uom-box-tablet',    'uom-tablet',    'uom-carton-tablet',  true, NULL),
  ('prod-para-syrup',    'PARA-SYR',  'Paracetamol Syrup 120mg/5ml',   'Analgesic syrup for children', 'FINISHED_GOOD', 'Syrup',  '120mg/5ml', 50, 1000, 'cat-analgesics',   'mfr-kalbe',       'uom-milliliter','uom-bottle-ml',     'uom-milliliter','uom-bottle-ml',      true, NULL),
  ('prod-ibuprofen-400', 'IBU-400',   'Ibuprofen 400mg',               'NSAID Analgesic',              'FINISHED_GOOD', 'Tablet', '400mg',    100, 3000, 'cat-analgesics',   'mfr-dexa',        'uom-tablet',    'uom-box-tablet',    'uom-tablet',    'uom-carton-tablet',  true, NULL),
  ('prod-mefenamic',     'MEF-500',   'Mefenamic Acid 500mg',          'Analgesic for menstrual pain', 'FINISHED_GOOD', 'Capsule','500mg',    100, 2000, 'cat-analgesics',   'mfr-kalbe',       'uom-capsule',   'uom-box-capsule',   'uom-capsule',   'uom-carton-capsule', true, NULL),
  ('prod-para-drop',     'PARA-DROP', 'Paracetamol Drops 100mg/1ml',    'Analgesic drops for infants',  'FINISHED_GOOD', 'Drops',  '100mg/ml',  30,  500, 'cat-analgesics',   'mfr-soho',        'uom-milliliter','uom-bottle-drop',   'uom-drop',      'uom-bottle-drop',    true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Antibiotics — Penicillins
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-amox-500',   'AMOX-500', 'Amoxicillin 500mg',                'Broad-spectrum penicillin antibiotic',  'FINISHED_GOOD','Capsule','500mg',     150, 4000, 'cat-penicillins',  'mfr-kimia-farma','uom-capsule',   'uom-box-capsule',   'uom-capsule',   'uom-carton-capsule', true, NULL),
  ('prod-ampicillin', 'AMP-500',  'Ampicillin 500mg',                'Aminopenicillin antibiotic',             'FINISHED_GOOD','Capsule','500mg',     100, 3000, 'cat-penicillins',  'mfr-indofarma',  'uom-capsule',   'uom-box-capsule',   'uom-capsule',   'uom-carton-capsule', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Antibiotics — Cephalosporins
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-cefixime',    'CEF-100', 'Cefixime 100mg',                 'Third-gen cephalosporin',               'FINISHED_GOOD','Capsule',  '100mg', 80, 2000, 'cat-cephalosporins','mfr-dexa',       'uom-capsule',   'uom-box-capsule',   'uom-capsule',   'uom-carton-capsule', true, NULL),
  ('prod-cefadroxil',  'CFD-500', 'Cefadroxil 500mg',               'First-gen cephalosporin',               'FINISHED_GOOD','Capsule',  '500mg', 80, 2000, 'cat-cephalosporins','mfr-kalbe',      'uom-capsule',   'uom-box-capsule',   'uom-capsule',   'uom-carton-capsule', true, NULL),
  ('prod-ceftriaxone', 'CRO-1G',  'Ceftriaxone 1g Inj',             'Injectable cephalosporin',              'FINISHED_GOOD','Injection','1g',     50, 1000, 'cat-cephalosporins','mfr-kimia-farma','uom-vial',      'uom-box-piece',     'uom-vial',      'uom-carton-box-pcs', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Antibiotics — Macrolides
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-azithromycin', 'AZI-500',  'Azithromycin 500mg',             'Macrolide antibiotic (Z-Pak)',          'FINISHED_GOOD','Tablet','500mg',    60, 1500, 'cat-macrolides',   'mfr-dexa',       'uom-tablet',    'uom-box-tablet',    'uom-tablet',    'uom-carton-tablet',  true, NULL),
  ('prod-erythromycin', 'ERY-500',  'Erythromycin 500mg',             'Macrolide antibiotic',                 'FINISHED_GOOD','Tablet','500mg',    50, 1000, 'cat-macrolides',   'mfr-indofarma',  'uom-tablet',    'uom-box-tablet',    'uom-tablet',    'uom-carton-tablet',  true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Antibiotics — Fluoroquinolones
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-ciprofloxacin','CIP-500',  'Ciprofloxacin 500mg',            'Fluoroquinolone antibiotic',            'FINISHED_GOOD','Tablet','500mg',    80, 2000, 'cat-fluoroquinolones','mfr-kimia-farma','uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-levofloxacin', 'LEV-500',  'Levofloxacin 500mg',             'Fluoroquinolone antibiotic',            'FINISHED_GOOD','Tablet','500mg',    50, 1500, 'cat-fluoroquinolones','mfr-dexa',      'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Antihypertensive
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-amlodipine', 'AML-5',  'Amlodipine 5mg',  'Calcium channel blocker', 'FINISHED_GOOD','Tablet','5mg',  80, 2000, 'cat-antihypertensive','mfr-kalbe',     'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-captopril',  'CAP-25', 'Captopril 25mg',  'ACE inhibitor',          'FINISHED_GOOD','Tablet','25mg', 80, 2000, 'cat-antihypertensive','mfr-indofarma', 'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Antidiabetic
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-metformin',     'MET-500', 'Metformin 500mg',      'Biguanide antidiabetic',    'FINISHED_GOOD','Tablet','500mg',100, 3000, 'cat-antidiabetic','mfr-kimia-farma','uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-glibenclamide', 'GLIB-5',  'Glibenclamide 5mg',   'Sulfonylurea antidiabetic','FINISHED_GOOD','Tablet','5mg',  60, 1500, 'cat-antidiabetic','mfr-dexa',       'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- GI Drugs
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-omeprazole', 'OMP-20', 'Omeprazole 20mg',     'Proton pump inhibitor',       'FINISHED_GOOD','Capsule','20mg',      120, 3000, 'cat-gi-drugs','mfr-kalbe',       'uom-capsule',   'uom-box-capsule',  'uom-capsule','uom-carton-capsule', true, NULL),
  ('prod-antacid',    'ANT-ML', 'Antacid Suspension', 'Antacid for heartburn relief', 'FINISHED_GOOD','Syrup',  NULL,       40,  800, 'cat-gi-drugs','mfr-soho',        'uom-milliliter','uom-bottle-ml',   'uom-milliliter','uom-bottle-ml',    true, NULL),
  ('prod-loperamide', 'LOP-2',  'Loperamide 2mg',      'Antidiarrheal',                'FINISHED_GOOD','Capsule','2mg',       50, 1200, 'cat-gi-drugs','mfr-kalbe',       'uom-capsule',   'uom-box-capsule',  'uom-capsule','uom-carton-capsule', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Respiratory
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-salbutamol',    'SAL-2',  'Salbutamol 2mg',      'Bronchodilator',                  'FINISHED_GOOD','Tablet','2mg',   60, 1500, 'cat-respiratory','mfr-kimia-farma','uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-cetirizine',    'CET-10', 'Cetirizine 10mg',     'Antihistamine',                    'FINISHED_GOOD','Tablet','10mg', 100, 2500, 'cat-respiratory','mfr-kalbe',      'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-dexamethasone', 'DEX-05', 'Dexamethasone 0.5mg', 'Corticosteroid anti-inflammatory',  'FINISHED_GOOD','Tablet','0.5mg', 60, 1500, 'cat-respiratory','mfr-indofarma',  'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Dermatological
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-betadine',     'BET-TUBE', 'Betadine Ointment 5%',    'Topical antiseptic',  'FINISHED_GOOD','Ointment','5%',  40,  800, 'cat-dermatological','mfr-kalbe',      'uom-tube','uom-box-piece','uom-tube','uom-carton-box-pcs', true, NULL),
  ('prod-clotrimazole', 'CLO-1',    'Clotrimazole Cream 1%',   'Antifungal cream',     'FINISHED_GOOD','Cream',   '1%',  40,  800, 'cat-dermatological','mfr-dexa',       'uom-tube','uom-box-piece','uom-tube','uom-carton-box-pcs', true, NULL),
  ('prod-mupirocin',    'MUP-OINT', 'Mupirocin Ointment 2%',   'Topical antibiotic',  'FINISHED_GOOD','Ointment','2%',  30,  500, 'cat-dermatological','mfr-kimia-farma','uom-tube','uom-box-piece','uom-tube','uom-carton-box-pcs', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Eye & Ear
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-chloramphenicol-eye','CPE-EYE', 'Chloramphenicol Eye Drops 0.5%', 'Antibiotic eye drops', 'FINISHED_GOOD','Eye Drops','0.5%',30, 600, 'cat-eye-ear','mfr-indofarma','uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL),
  ('prod-ofloxacin-ear',     'OFX-EAR', 'Ofloxacin Ear Drops 0.3%',      'Antibiotic ear drops', 'FINISHED_GOOD','Ear Drops','0.3%',20, 400, 'cat-eye-ear','mfr-kalbe',    'uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Vitamins
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-vit-c-500',     'VITC-500',  'Vitamin C 500mg',        'Ascorbic acid supplement',        'FINISHED_GOOD','Tablet', '500mg',  150, 4000, 'cat-vitamins','mfr-soho',       'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-vit-b-complex', 'VITB-COM',  'Vitamin B Complex',       'B vitamin supplement',            'FINISHED_GOOD','Tablet', NULL,     100, 2500, 'cat-vitamins','mfr-kalbe',      'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL),
  ('prod-vit-d3-1000',   'VITD-1000', 'Vitamin D3 1000IU',       'Cholecalciferol supplement',      'FINISHED_GOOD','Capsule','1000IU', 80, 2000, 'cat-vitamins','mfr-dexa',       'uom-capsule','uom-box-capsule','uom-capsule','uom-carton-capsule', true, NULL),
  ('prod-calcium-500',   'CAL-500',   'Calcium 500mg + Vit D3',  'Calcium with vitamin D supplement','FINISHED_GOOD','Tablet', '500mg',   80, 2000, 'cat-vitamins','mfr-kalbe',      'uom-tablet','uom-box-tablet','uom-tablet','uom-carton-tablet', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Medical Supplies
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-mask-medical',  'MASK-MED', 'Medical Mask 3-Ply',      'Disposable surgical mask',           'FINISHED_GOOD', NULL, NULL, 200, 5000, 'cat-medical-supplies','mfr-kalbe',    'uom-piece','uom-box-piece','uom-piece','uom-carton-box-pcs', true, NULL),
  ('prod-gloves-latex',  'GLOVE-LTX','Latex Gloves (Pair)',     'Disposable latex examination gloves', 'FINISHED_GOOD', NULL, NULL, 100, 3000, 'cat-medical-supplies','mfr-meprofarm','uom-piece','uom-box-piece','uom-piece','uom-carton-box-pcs', true, NULL),
  ('prod-bandage',       'BANDAGE-RL','Elastic Bandage Roll',   'Crepe bandage 10cm x 4m',            'FINISHED_GOOD', NULL, NULL,  50, 1000, 'cat-medical-supplies','mfr-kalbe',    'uom-piece','uom-box-piece','uom-piece','uom-carton-box-pcs', true, NULL),
  ('prod-alcohol-swab',  'ALC-SWAB', 'Alcohol Swab 70%',        'Prep pad alcohol swab',              'FINISHED_GOOD', NULL, NULL, 300, 8000, 'cat-medical-supplies','mfr-soho',     'uom-piece','uom-box-piece','uom-piece','uom-carton-box-pcs', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 7. Products — Compounding Output (produced by formulas, no commercial PO)
-- ============================================================================

INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('prod-amox-susp-comp',   'COMP-AMOX-SUSP', 'Amoxicillin Susp 125mg/5ml (Comp)',  'Compounded antibiotic suspension', 'FINISHED_GOOD','Suspension','125mg/5ml', 0, NULL, 'cat-compounding-output','mfr-inhouse','uom-milliliter','uom-bottle-ml','uom-milliliter',NULL, true, NULL),
  ('prod-cet-syrup-comp',   'COMP-CET-SYR',  'Cetirizine Syrup 5mg/5ml (Comp)',     'Compounded antihistamine syrup',   'FINISHED_GOOD','Syrup',     '5mg/5ml',   0, NULL, 'cat-compounding-output','mfr-inhouse','uom-milliliter','uom-bottle-ml','uom-milliliter',NULL, true, NULL),
  ('prod-hc-cream-comp',    'COMP-HC-CRM',   'Hydrocortisone Cream 1% (Comp)',      'Compounded corticosteroid cream',   'FINISHED_GOOD','Cream',     '1%',        0, NULL, 'cat-compounding-output','mfr-inhouse','uom-gram',     'uom-tube',    'uom-gram',     NULL, true, NULL),
  ('prod-nia-serum-comp',   'COMP-NIA-SER',  'Niacinamide Serum 5% (Comp)',         'Compounded brightening serum',       'FINISHED_GOOD','Serum',     '5%',        0, NULL, 'cat-compounding-output','mfr-inhouse','uom-milliliter','uom-bottle-ml','uom-milliliter',NULL, true, NULL),
  ('prod-ret-cream-comp',   'COMP-RET-CRM',  'Tretinoin Cream 0.025% (Comp)',       'Compounded retinoid cream',         'FINISHED_GOOD','Cream',     '0.025%',     0, NULL, 'cat-compounding-output','mfr-inhouse','uom-gram',     'uom-tube',    'uom-gram',     NULL, true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 8. Products — Raw Materials (for compounding)
-- ============================================================================

-- Active Pharmaceutical Ingredients (API)
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "casNumber", "grade", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('rm-amox-powder',    'RM-AMOX-PW', 'Amoxicillin Trihydrate Powder',   'API for compounding', 'RAW_MATERIAL', NULL, NULL, '61336-70-7', 'USP', 5,  50, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-cetirizine-pw',  'RM-CET-PW',  'Cetirizine HCl Powder',           'API for compounding', 'RAW_MATERIAL', NULL, NULL, '83881-51-0', 'USP', 3,  30, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-hydrocortisone', 'RM-HC-PW',   'Hydrocortisone Powder',           'API for compounding', 'RAW_MATERIAL', NULL, NULL, '50-23-7',    'USP', 2,  20, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-ketoconazole',   'RM-KC-PW',   'Ketoconazole Powder',             'API for compounding', 'RAW_MATERIAL', NULL, NULL, '65277-42-1', 'USP', 2,  20, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-niacinamide',    'RM-NIA-PW',  'Niacinamide Powder',              'API for compounding', 'RAW_MATERIAL', NULL, NULL, '98-92-0',    'USP', 3,  30, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-retinoic',       'RM-RA-PW',   'Tretinoin Powder',                'API for compounding', 'RAW_MATERIAL', NULL, NULL, '302-79-4',   'USP', 1,  10, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-chlorphenamine', 'RM-CPM-PW',  'Chlorpheniramine Maleate Powder', 'API for compounding', 'RAW_MATERIAL', NULL, NULL, '113-92-8',   'USP', 2,  20, 'cat-api','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Excipients
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "casNumber", "grade", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('rm-lactose',         'RM-LAC-PW', 'Lactose Monohydrate',            'Filler/Diluent excipient', 'RAW_MATERIAL', NULL, NULL, '64044-51-5','PhEur', 10, 100, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-mcc',             'RM-MCC-PW', 'Microcrystalline Cellulose',     'Binder/Filler excipient',  'RAW_MATERIAL', NULL, NULL, '9004-34-6', 'PhEur', 10, 100, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-magnesium-stear', 'RM-MGST-PW','Magnesium Stearate',             'Lubricant excipient',      'RAW_MATERIAL', NULL, NULL, '557-04-0',  'PhEur',  5,  50, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-cornstarch',      'RM-CST-PW', 'Corn Starch',                    'Disintegrant excipient',  'RAW_MATERIAL', NULL, NULL, '9005-25-8', 'PhEur', 10, 100, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-saccharin',       'RM-SAC-PW', 'Saccharin Sodium',               'Artificial sweetener',     'RAW_MATERIAL', NULL, NULL, '128-44-9',  'PhEur',  2,  20, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-cream-base',      'RM-CRM-PW', 'Cold Cream Base',                'Cream base for compounding','RAW_MATERIAL', NULL, NULL, NULL,        'PhEur',  5,  50, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL),
  ('rm-preservative',    'RM-MPB-PW', 'Methylparaben',                  'Preservative for compounding','RAW_MATERIAL',NULL,NULL, '99-76-3',   'PhEur',  2,  20, 'cat-excipients','mfr-indofarma','uom-gram','uom-kilogram','uom-gram','uom-kilogram', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- Suspending Agents & Vehicles
INSERT INTO "Product" ("id", "code", "name", "description", "productType", "dosageForm", "strength", "casNumber", "grade", "minStock", "maxStock", "categoryId", "manufacturerId", "baseUnitId", "stockingUnitId", "sellingUnitId", "purchaseUnitId", "isActive","organizationId")
VALUES
  ('rm-suspending-agent', 'RM-SUSP-AGT', 'Compound Suspending Agent (CCA-Na)','Suspending agent',    'RAW_MATERIAL', NULL, NULL, NULL,        'PhEur', 5,  50, 'cat-suspending-agents','mfr-indofarma','uom-gram',     'uom-kilogram','uom-gram',     'uom-kilogram', true, NULL),
  ('rm-purified-water',   'RM-PW-ML',    'Purified Water',                 'Vehicle for compounding','RAW_MATERIAL', NULL, NULL, '7732-18-5', 'PhEur', 20, 200, 'cat-suspending-agents','mfr-indofarma','uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL),
  ('rm-glycerin',         'RM-GLY-ML',   'Glycerin',                       'Humectant excipient',     'RAW_MATERIAL', NULL, NULL, '56-81-5',   'PhEur', 5,  50, 'cat-suspending-agents','mfr-indofarma','uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL),
  ('rm-propylene-glycol', 'RM-PG-ML',    'Propylene Glycol',               'Co-solvent excipient',    'RAW_MATERIAL', NULL, NULL, '57-55-6',   'PhEur', 5,  50, 'cat-suspending-agents','mfr-indofarma','uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL),
  ('rm-flavor-strawberry','RM-FLV-SB',   'Strawberry Flavor',              'Flavoring agent',         'RAW_MATERIAL', NULL, NULL, NULL,        'PhEur', 2,  20, 'cat-suspending-agents','mfr-indofarma','uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL),
  ('rm-flavor-cherry',   'RM-FLV-CH',   'Cherry Flavor',                  'Flavoring agent',         'RAW_MATERIAL', NULL, NULL, NULL,        'PhEur', 2,  20, 'cat-suspending-agents','mfr-indofarma','uom-milliliter','uom-bottle-ml','uom-milliliter','uom-bottle-ml', true, NULL)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 9. Formulas (compounding recipes)
-- ============================================================================

-- Formula: Amoxicillin Suspension 125mg/5ml
INSERT INTO "Formula" ("id", "code", "name", "description", "dosageForm", "totalYield", "yieldUnitId", "instructions", "productId", "isActive","organizationId")
VALUES
   ('form-amox-susp', 'FRM-AMOX-SUSP', 'Amoxicillin Suspension 125mg/5ml',
    'Pediatric antibiotic suspension for compounding',
    'Suspension', 100, 'uom-milliliter',
    '1. Weigh amoxicillin trihydrate powder. 2. Mix with suspending agent and purified water in a mortar. 3. Transfer to measuring cylinder and QS to 100ml with purified water. 4. Transfer to dispensing bottle. 5. Label with expiry date (14 days).',
    'prod-amox-susp-comp', true, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO "FormulaIngredient" ("id", "quantity", "productId", "unitOfMeasureId", "formulaId", "notes")
VALUES
  ('fi-amox-susp-1', 2.5000, 'rm-amox-powder',       'uom-gram',       'form-amox-susp', 'Amoxicillin trihydrate equivalent to 125mg/5ml amoxicillin'),
  ('fi-amox-susp-2', 3.0000, 'rm-suspending-agent',   'uom-gram',       'form-amox-susp', 'Suspending agent for stability'),
  ('fi-amox-susp-3', 0.5000, 'rm-saccharin',          'uom-gram',       'form-amox-susp', 'Sweetening agent'),
  ('fi-amox-susp-4', 0.2000, 'rm-flavor-strawberry',  'uom-milliliter', 'form-amox-susp', 'Flavoring agent for palatability'),
  ('fi-amox-susp-5', 0.5000, 'rm-glycerin',           'uom-milliliter', 'form-amox-susp', 'Sweetener & humectant'),
  ('fi-amox-susp-6', 93.3000, 'rm-purified-water',    'uom-milliliter', 'form-amox-susp', 'QS to 100ml')
ON CONFLICT (id) DO NOTHING;

-- Formula: Cetirizine Syrup 5mg/5ml
INSERT INTO "Formula" ("id", "code", "name", "description", "dosageForm", "totalYield", "yieldUnitId", "instructions", "productId", "isActive","organizationId")
VALUES
   ('form-cet-syrup', 'FRM-CET-SYR', 'Cetirizine Syrup 5mg/5ml',
    'Antihistamine syrup for compounding',
    'Syrup', 60, 'uom-milliliter',
    '1. Dissolve cetirizine HCl in purified water. 2. Add glycerin and propylene glycol. 3. QS to 60ml with purified water. 4. Transfer to dispensing bottle. 5. Label with expiry date (30 days).',
    'prod-cet-syrup-comp', true, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO "FormulaIngredient" ("id", "quantity", "productId", "unitOfMeasureId", "formulaId", "notes")
VALUES
  ('fi-cet-syrup-1', 0.0600, 'rm-cetirizine-pw',    'uom-gram',       'form-cet-syrup', 'Cetirizine HCl equivalent to 5mg/5ml'),
  ('fi-cet-syrup-2', 6.0000, 'rm-glycerin',          'uom-milliliter', 'form-cet-syrup', 'Sweetener & viscosity agent'),
  ('fi-cet-syrup-3', 3.0000, 'rm-propylene-glycol',  'uom-milliliter', 'form-cet-syrup', 'Co-solvent for solubility'),
  ('fi-cet-syrup-4', 0.0300, 'rm-saccharin',         'uom-gram',       'form-cet-syrup', 'Sweetening agent'),
  ('fi-cet-syrup-5', 0.3000, 'rm-flavor-cherry',     'uom-milliliter', 'form-cet-syrup', 'Flavoring agent'),
  ('fi-cet-syrup-6', 50.6100, 'rm-purified-water',   'uom-milliliter', 'form-cet-syrup', 'QS to 60ml')
ON CONFLICT (id) DO NOTHING;

-- Formula: Hydrocortisone Cream 1%
INSERT INTO "Formula" ("id", "code", "name", "description", "dosageForm", "totalYield", "yieldUnitId", "instructions", "productId", "isActive","organizationId")
VALUES
   ('form-hc-cream', 'FRM-HC-CRM', 'Hydrocortisone Cream 1%',
    'Topical corticosteroid cream for compounding',
    'Cream', 30, 'uom-gram',
    '1. Weigh hydrocortisone powder. 2. Levigate with small amount of cream base. 3. Incorporate into remaining cream base using geometric dilution. 4. Transfer to ointment jar. 5. Label with expiry date (30 days).',
    'prod-hc-cream-comp', true, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO "FormulaIngredient" ("id", "quantity", "productId", "unitOfMeasureId", "formulaId", "notes")
VALUES
  ('fi-hc-cream-1', 0.3000, 'rm-hydrocortisone', 'uom-gram', 'form-hc-cream', 'Hydrocortisone powder 1%'),
  ('fi-hc-cream-2', 29.7000, 'rm-cream-base',   'uom-gram', 'form-hc-cream', 'Cold cream base QS to 30g')
ON CONFLICT (id) DO NOTHING;

-- Formula: Niacinamide Serum 5%
INSERT INTO "Formula" ("id", "code", "name", "description", "dosageForm", "totalYield", "yieldUnitId", "instructions", "productId", "isActive","organizationId")
VALUES
   ('form-nia-serum', 'FRM-NIA-SER', 'Niacinamide Serum 5%',
    'Cosmeceutical serum for skin brightening',
    'Serum', 30, 'uom-milliliter',
    '1. Dissolve niacinamide in purified water. 2. Add glycerin and propylene glycol. 3. Add preservative and mix well. 4. Transfer to dropper bottle. 5. Label with expiry date (60 days).',
    'prod-nia-serum-comp', true, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO "FormulaIngredient" ("id", "quantity", "productId", "unitOfMeasureId", "formulaId", "notes")
VALUES
  ('fi-nia-serum-1', 1.5000, 'rm-niacinamide',      'uom-gram',       'form-nia-serum', 'Niacinamide 5% w/v'),
  ('fi-nia-serum-2', 1.5000, 'rm-glycerin',         'uom-milliliter', 'form-nia-serum', 'Humectant'),
  ('fi-nia-serum-3', 1.0000, 'rm-propylene-glycol', 'uom-milliliter', 'form-nia-serum', 'Co-solvent & penetration enhancer'),
  ('fi-nia-serum-4', 0.0300, 'rm-preservative',     'uom-gram',       'form-nia-serum', 'Preservative (methylparaben)'),
  ('fi-nia-serum-5', 27.4700, 'rm-purified-water',   'uom-milliliter', 'form-nia-serum', 'QS to 30ml')
ON CONFLICT (id) DO NOTHING;

-- Formula: Tretinoin Cream 0.025%
INSERT INTO "Formula" ("id", "code", "name", "description", "dosageForm", "totalYield", "yieldUnitId", "instructions", "productId", "isActive","organizationId")
VALUES
   ('form-ret-cream', 'FRM-RET-CRM', 'Tretinoin Cream 0.025%',
    'Topical retinoid for acne treatment',
    'Cream', 15, 'uom-gram',
    '1. Protect from light. Weigh tretinoin powder. 2. Levigate with small amount of cream base. 3. Incorporate using geometric dilution. 4. Transfer to amber ointment jar. 5. Label: photosensitive, keep away from light. Expiry: 30 days.',
    'prod-ret-cream-comp', true, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO "FormulaIngredient" ("id", "quantity", "productId", "unitOfMeasureId", "formulaId", "notes")
VALUES
  ('fi-ret-cream-1', 0.0038, 'rm-retinoic',   'uom-gram', 'form-ret-cream', 'Tretinoin 0.025% — LIGHT SENSITIVE, prepare under yellow light'),
  ('fi-ret-cream-2', 14.9962, 'rm-cream-base', 'uom-gram', 'form-ret-cream', 'Cold cream base QS to 15g')
ON CONFLICT (id) DO NOTHING;

COMMIT;
