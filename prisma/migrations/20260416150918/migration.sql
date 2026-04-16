-- DropIndex
DROP INDEX "Formula_code_key";

-- DropIndex
DROP INDEX "Formula_organizationId_idx";

-- DropIndex
DROP INDEX "Manufacturer_code_key";

-- DropIndex
DROP INDEX "Manufacturer_name_key";

-- DropIndex
DROP INDEX "Manufacturer_organizationId_idx";

-- DropIndex
DROP INDEX "Product_code_key";

-- DropIndex
DROP INDEX "Product_organizationId_idx";

-- DropIndex
DROP INDEX "ProductCategory_name_key";

-- DropIndex
DROP INDEX "ProductCategory_organizationId_idx";

-- DropIndex
DROP INDEX "Supplier_code_key";

-- DropIndex
DROP INDEX "Supplier_organizationId_idx";

-- DropIndex
DROP INDEX "UnitOfMeasure_code_key";

-- DropIndex
DROP INDEX "UnitOfMeasure_organizationId_idx";

-- DropIndex
DROP INDEX "WarehouseLocation_code_key";

-- DropIndex
DROP INDEX "WarehouseLocation_organizationId_idx";

-- CreateIndex
CREATE INDEX "Formula_organizationId_code_idx" ON "Formula"("organizationId", "code");

-- CreateIndex
CREATE INDEX "Manufacturer_organizationId_code_idx" ON "Manufacturer"("organizationId", "code");

-- CreateIndex
CREATE INDEX "Manufacturer_organizationId_name_idx" ON "Manufacturer"("organizationId", "name");

-- CreateIndex
CREATE INDEX "Product_organizationId_code_idx" ON "Product"("organizationId", "code");

-- CreateIndex
CREATE INDEX "ProductCategory_organizationId_name_idx" ON "ProductCategory"("organizationId", "name");

-- CreateIndex
CREATE INDEX "Supplier_organizationId_code_idx" ON "Supplier"("organizationId", "code");

-- CreateIndex
CREATE INDEX "UnitOfMeasure_organizationId_code_idx" ON "UnitOfMeasure"("organizationId", "code");

-- CreateIndex
CREATE INDEX "WarehouseLocation_organizationId_code_idx" ON "WarehouseLocation"("organizationId", "code");
