/*
  Warnings:

  - A unique constraint covering the columns `[code]` on the table `Formula` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[code]` on the table `Manufacturer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `Manufacturer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[code]` on the table `Product` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `ProductCategory` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[code]` on the table `Supplier` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[code]` on the table `UnitOfMeasure` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[code]` on the table `WarehouseLocation` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Formula_organizationId_code_key";

-- DropIndex
DROP INDEX "Manufacturer_organizationId_code_key";

-- DropIndex
DROP INDEX "Manufacturer_organizationId_name_key";

-- DropIndex
DROP INDEX "Product_organizationId_code_key";

-- DropIndex
DROP INDEX "ProductCategory_organizationId_name_key";

-- DropIndex
DROP INDEX "Supplier_organizationId_code_key";

-- DropIndex
DROP INDEX "UnitOfMeasure_organizationId_code_key";

-- DropIndex
DROP INDEX "WarehouseLocation_organizationId_code_key";

-- AlterTable
ALTER TABLE "Formula" ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Manufacturer" ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Product" ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "ProductCategory" ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Supplier" ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "UnitOfMeasure" ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "WarehouseLocation" ALTER COLUMN "organizationId" DROP NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Formula_code_key" ON "Formula"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Manufacturer_code_key" ON "Manufacturer"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Manufacturer_name_key" ON "Manufacturer"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Product_code_key" ON "Product"("code");

-- CreateIndex
CREATE UNIQUE INDEX "ProductCategory_name_key" ON "ProductCategory"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_code_key" ON "Supplier"("code");

-- CreateIndex
CREATE UNIQUE INDEX "UnitOfMeasure_code_key" ON "UnitOfMeasure"("code");

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseLocation_code_key" ON "WarehouseLocation"("code");
