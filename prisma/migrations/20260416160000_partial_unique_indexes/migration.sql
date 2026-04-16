-- ============================================================================
-- Partial unique indexes for master data tables with nullable organizationId
-- ============================================================================
--
-- Problem: Standard UNIQUE (organizationId, code) treats each NULL as
-- distinct, so multiple global (NULL) rows with the same code would pass.
--
-- Solution: Two partial indexes per constraint:
--   1. WHERE organizationId IS NULL  → only one global record per code
--   2. WHERE organizationId IS NOT NULL → unique code within each org
--
-- This allows:
--   ✓ One global record with code='tablet' (org=NULL)
--   ✓ Org A can have code='tablet' (org-scoped override)
--   ✓ Org B can have code='tablet' (different org)
--   ✗ Two global records with code='tablet'
--   ✗ Two records in Org A with code='tablet'
-- ============================================================================

-- Drop old composite unique constraints (from previous migrations)
DROP INDEX IF EXISTS "UnitOfMeasure_organizationId_code_key";
DROP INDEX IF EXISTS "Manufacturer_organizationId_code_key";
DROP INDEX IF EXISTS "Manufacturer_organizationId_name_key";
DROP INDEX IF EXISTS "ProductCategory_organizationId_name_key";
DROP INDEX IF EXISTS "Product_organizationId_code_key";
DROP INDEX IF EXISTS "Supplier_organizationId_code_key";
DROP INDEX IF EXISTS "WarehouseLocation_organizationId_code_key";
DROP INDEX IF EXISTS "Formula_organizationId_code_key";

-- UnitOfMeasure: unique code (global + per-org)
CREATE UNIQUE INDEX "UnitOfMeasure_code_global_key"
  ON "UnitOfMeasure" ("code") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "UnitOfMeasure_code_org_key"
  ON "UnitOfMeasure" ("organizationId", "code") WHERE "organizationId" IS NOT NULL;

-- Manufacturer: unique code (global + per-org)
CREATE UNIQUE INDEX "Manufacturer_code_global_key"
  ON "Manufacturer" ("code") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "Manufacturer_code_org_key"
  ON "Manufacturer" ("organizationId", "code") WHERE "organizationId" IS NOT NULL;

-- Manufacturer: unique name (global + per-org)
CREATE UNIQUE INDEX "Manufacturer_name_global_key"
  ON "Manufacturer" ("name") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "Manufacturer_name_org_key"
  ON "Manufacturer" ("organizationId", "name") WHERE "organizationId" IS NOT NULL;

-- ProductCategory: unique name (global + per-org)
CREATE UNIQUE INDEX "ProductCategory_name_global_key"
  ON "ProductCategory" ("name") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "ProductCategory_name_org_key"
  ON "ProductCategory" ("organizationId", "name") WHERE "organizationId" IS NOT NULL;

-- Product: unique code (global + per-org)
CREATE UNIQUE INDEX "Product_code_global_key"
  ON "Product" ("code") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "Product_code_org_key"
  ON "Product" ("organizationId", "code") WHERE "organizationId" IS NOT NULL;

-- Supplier: unique code (global + per-org)
CREATE UNIQUE INDEX "Supplier_code_global_key"
  ON "Supplier" ("code") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "Supplier_code_org_key"
  ON "Supplier" ("organizationId", "code") WHERE "organizationId" IS NOT NULL;

-- WarehouseLocation: unique code (global + per-org)
CREATE UNIQUE INDEX "WarehouseLocation_code_global_key"
  ON "WarehouseLocation" ("code") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "WarehouseLocation_code_org_key"
  ON "WarehouseLocation" ("organizationId", "code") WHERE "organizationId" IS NOT NULL;

-- Formula: unique code (global + per-org)
CREATE UNIQUE INDEX "Formula_code_global_key"
  ON "Formula" ("code") WHERE "organizationId" IS NULL;
CREATE UNIQUE INDEX "Formula_code_org_key"
  ON "Formula" ("organizationId", "code") WHERE "organizationId" IS NOT NULL;
