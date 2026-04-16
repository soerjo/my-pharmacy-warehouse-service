/*
  Warnings:

  - You are about to drop the column `quantity` on the `Batch` table. All the data in the column will be lost.
  - The `status` column on the `InboundShipment` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `OutboundShipment` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `PurchaseOrder` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `Transfer` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `categoryId` on the `UnitOfMeasure` table. All the data in the column will be lost.
  - You are about to drop the `Alert` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Inventory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Organization` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ProductImage` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Role` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UnitOfMeasureCategory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UserOrganization` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[compoundingBatchId]` on the table `Batch` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,batchNumber]` on the table `Batch` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,shipmentNumber]` on the table `InboundShipment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[inboundShipmentId,batchId]` on the table `InboundShipmentItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,code]` on the table `Manufacturer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,name]` on the table `Manufacturer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,shipmentNumber]` on the table `OutboundShipment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[outboundShipmentId,batchId]` on the table `OutboundShipmentItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,code]` on the table `Product` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,name]` on the table `ProductCategory` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,orderNumber]` on the table `PurchaseOrder` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[purchaseOrderId,productId]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,adjustmentNumber]` on the table `StockAdjustment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,code]` on the table `Supplier` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,transferNumber]` on the table `Transfer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,code]` on the table `UnitOfMeasure` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizationId,code]` on the table `WarehouseLocation` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `locationId` to the `InboundShipmentItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `code` to the `Manufacturer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `batchId` to the `OutboundShipmentItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `locationId` to the `OutboundShipmentItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `organizationId` to the `ProductCategory` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `movementType` on the `StockMovement` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `batchId` to the `Transfer` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `locationType` on the `WarehouseLocation` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "ProductType" AS ENUM ('FINISHED_GOOD', 'RAW_MATERIAL');

-- CreateEnum
CREATE TYPE "PurchaseOrderStatus" AS ENUM ('DRAFT', 'SENT', 'CONFIRMED', 'PARTIALLY_RECEIVED', 'RECEIVED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "InboundShipmentStatus" AS ENUM ('PENDING', 'RECEIVING', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "OutboundShipmentStatus" AS ENUM ('PENDING', 'PICKING', 'PACKED', 'SHIPPED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "TransferStatus" AS ENUM ('PENDING', 'IN_TRANSIT', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "CompoundingStatus" AS ENUM ('PENDING', 'MIXING', 'QC_CHECK', 'COMPLETED', 'CANCELLED', 'FAILED');

-- CreateEnum
CREATE TYPE "LocationType" AS ENUM ('BULK_STORAGE', 'PICKING', 'COLD_STORAGE', 'QUARANTINE', 'LABORATORY', 'DISPENSING');

-- CreateEnum
CREATE TYPE "StockMovementType" AS ENUM ('INBOUND', 'OUTBOUND', 'TRANSFER_IN', 'TRANSFER_OUT', 'ADJUSTMENT', 'COMPOUNDING_IN', 'COMPOUNDING_OUT');

-- DropForeignKey
ALTER TABLE "Alert" DROP CONSTRAINT "Alert_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Alert" DROP CONSTRAINT "Alert_productId_fkey";

-- DropForeignKey
ALTER TABLE "Batch" DROP CONSTRAINT "Batch_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "InboundShipment" DROP CONSTRAINT "InboundShipment_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Inventory" DROP CONSTRAINT "Inventory_locationId_fkey";

-- DropForeignKey
ALTER TABLE "Inventory" DROP CONSTRAINT "Inventory_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Inventory" DROP CONSTRAINT "Inventory_productId_fkey";

-- DropForeignKey
ALTER TABLE "Manufacturer" DROP CONSTRAINT "Manufacturer_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "OutboundShipment" DROP CONSTRAINT "OutboundShipment_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "ProductImage" DROP CONSTRAINT "ProductImage_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "ProductImage" DROP CONSTRAINT "ProductImage_productId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrder" DROP CONSTRAINT "PurchaseOrder_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "StockAdjustment" DROP CONSTRAINT "StockAdjustment_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "StockMovement" DROP CONSTRAINT "StockMovement_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Supplier" DROP CONSTRAINT "Supplier_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Transfer" DROP CONSTRAINT "Transfer_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "UnitOfMeasure" DROP CONSTRAINT "UnitOfMeasure_categoryId_fkey";

-- DropForeignKey
ALTER TABLE "UnitOfMeasure" DROP CONSTRAINT "UnitOfMeasure_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "UserOrganization" DROP CONSTRAINT "UserOrganization_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "UserOrganization" DROP CONSTRAINT "UserOrganization_roleId_fkey";

-- DropForeignKey
ALTER TABLE "UserOrganization" DROP CONSTRAINT "UserOrganization_userId_fkey";

-- DropForeignKey
ALTER TABLE "WarehouseLocation" DROP CONSTRAINT "WarehouseLocation_organizationId_fkey";

-- DropIndex
DROP INDEX "Batch_batchNumber_key";

-- DropIndex
DROP INDEX "InboundShipment_shipmentNumber_key";

-- DropIndex
DROP INDEX "Manufacturer_name_key";

-- DropIndex
DROP INDEX "OutboundShipment_shipmentNumber_key";

-- DropIndex
DROP INDEX "Product_code_key";

-- DropIndex
DROP INDEX "ProductCategory_name_key";

-- DropIndex
DROP INDEX "PurchaseOrder_orderNumber_key";

-- DropIndex
DROP INDEX "StockAdjustment_adjustmentNumber_key";

-- DropIndex
DROP INDEX "Supplier_code_key";

-- DropIndex
DROP INDEX "Transfer_transferNumber_key";

-- DropIndex
DROP INDEX "UnitOfMeasure_code_key";

-- DropIndex
DROP INDEX "WarehouseLocation_code_key";

-- AlterTable
ALTER TABLE "Batch" DROP COLUMN "quantity",
ADD COLUMN     "compoundingBatchId" TEXT;

-- AlterTable
ALTER TABLE "InboundShipment" DROP COLUMN "status",
ADD COLUMN     "status" "InboundShipmentStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "InboundShipmentItem" ADD COLUMN     "locationId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Manufacturer" ADD COLUMN     "code" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "OutboundShipment" DROP COLUMN "status",
ADD COLUMN     "status" "OutboundShipmentStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "OutboundShipmentItem" ADD COLUMN     "batchId" TEXT NOT NULL,
ADD COLUMN     "locationId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Product" ADD COLUMN     "casNumber" TEXT,
ADD COLUMN     "grade" TEXT,
ADD COLUMN     "maxStock" INTEGER,
ADD COLUMN     "minStock" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "productType" "ProductType" NOT NULL DEFAULT 'FINISHED_GOOD';

-- AlterTable
ALTER TABLE "ProductCategory" ADD COLUMN     "organizationId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "status",
ADD COLUMN     "status" "PurchaseOrderStatus" NOT NULL DEFAULT 'DRAFT';

-- AlterTable
ALTER TABLE "StockMovement" DROP COLUMN "movementType",
ADD COLUMN     "movementType" "StockMovementType" NOT NULL;

-- AlterTable
ALTER TABLE "Transfer" ADD COLUMN     "batchId" TEXT NOT NULL,
DROP COLUMN "status",
ADD COLUMN     "status" "TransferStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "UnitOfMeasure" DROP COLUMN "categoryId";

-- AlterTable
ALTER TABLE "WarehouseLocation" DROP COLUMN "locationType",
ADD COLUMN     "locationType" "LocationType" NOT NULL;

-- DropTable
DROP TABLE "Alert";

-- DropTable
DROP TABLE "Inventory";

-- DropTable
DROP TABLE "Organization";

-- DropTable
DROP TABLE "ProductImage";

-- DropTable
DROP TABLE "Role";

-- DropTable
DROP TABLE "UnitOfMeasureCategory";

-- DropTable
DROP TABLE "User";

-- DropTable
DROP TABLE "UserOrganization";

-- CreateTable
CREATE TABLE "BatchInventory" (
    "id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 0,
    "batchId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BatchInventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Formula" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "dosageForm" TEXT,
    "totalYield" INTEGER NOT NULL,
    "yieldUnitId" TEXT NOT NULL,
    "instructions" TEXT,
    "productId" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "organizationId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Formula_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FormulaIngredient" (
    "id" TEXT NOT NULL,
    "quantity" DECIMAL(10,4) NOT NULL,
    "productId" TEXT NOT NULL,
    "unitOfMeasureId" TEXT NOT NULL,
    "formulaId" TEXT NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FormulaIngredient_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompoundingBatch" (
    "id" TEXT NOT NULL,
    "batchNumber" TEXT NOT NULL,
    "producedDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expirationDate" TIMESTAMP(3) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "status" "CompoundingStatus" NOT NULL DEFAULT 'PENDING',
    "notes" TEXT,
    "formulaId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CompoundingBatch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompoundingBatchMaterial" (
    "id" TEXT NOT NULL,
    "quantityUsed" DECIMAL(10,4) NOT NULL,
    "productId" TEXT NOT NULL,
    "batchId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "compoundingBatchId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CompoundingBatchMaterial_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "BatchInventory_organizationId_idx" ON "BatchInventory"("organizationId");

-- CreateIndex
CREATE INDEX "BatchInventory_productId_locationId_idx" ON "BatchInventory"("productId", "locationId");

-- CreateIndex
CREATE INDEX "BatchInventory_productId_idx" ON "BatchInventory"("productId");

-- CreateIndex
CREATE INDEX "BatchInventory_locationId_idx" ON "BatchInventory"("locationId");

-- CreateIndex
CREATE INDEX "BatchInventory_batchId_idx" ON "BatchInventory"("batchId");

-- CreateIndex
CREATE UNIQUE INDEX "BatchInventory_batchId_locationId_key" ON "BatchInventory"("batchId", "locationId");

-- CreateIndex
CREATE INDEX "Formula_organizationId_idx" ON "Formula"("organizationId");

-- CreateIndex
CREATE INDEX "Formula_productId_idx" ON "Formula"("productId");

-- CreateIndex
CREATE INDEX "Formula_isActive_idx" ON "Formula"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Formula_organizationId_code_key" ON "Formula"("organizationId", "code");

-- CreateIndex
CREATE INDEX "FormulaIngredient_formulaId_idx" ON "FormulaIngredient"("formulaId");

-- CreateIndex
CREATE INDEX "FormulaIngredient_productId_idx" ON "FormulaIngredient"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "FormulaIngredient_formulaId_productId_key" ON "FormulaIngredient"("formulaId", "productId");

-- CreateIndex
CREATE INDEX "CompoundingBatch_organizationId_idx" ON "CompoundingBatch"("organizationId");

-- CreateIndex
CREATE INDEX "CompoundingBatch_formulaId_idx" ON "CompoundingBatch"("formulaId");

-- CreateIndex
CREATE INDEX "CompoundingBatch_locationId_idx" ON "CompoundingBatch"("locationId");

-- CreateIndex
CREATE INDEX "CompoundingBatch_organizationId_status_idx" ON "CompoundingBatch"("organizationId", "status");

-- CreateIndex
CREATE INDEX "CompoundingBatch_expirationDate_idx" ON "CompoundingBatch"("expirationDate");

-- CreateIndex
CREATE INDEX "CompoundingBatch_producedDate_idx" ON "CompoundingBatch"("producedDate");

-- CreateIndex
CREATE UNIQUE INDEX "CompoundingBatch_organizationId_batchNumber_key" ON "CompoundingBatch"("organizationId", "batchNumber");

-- CreateIndex
CREATE INDEX "CompoundingBatchMaterial_compoundingBatchId_idx" ON "CompoundingBatchMaterial"("compoundingBatchId");

-- CreateIndex
CREATE INDEX "CompoundingBatchMaterial_productId_idx" ON "CompoundingBatchMaterial"("productId");

-- CreateIndex
CREATE INDEX "CompoundingBatchMaterial_batchId_idx" ON "CompoundingBatchMaterial"("batchId");

-- CreateIndex
CREATE INDEX "CompoundingBatchMaterial_locationId_idx" ON "CompoundingBatchMaterial"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "Batch_compoundingBatchId_key" ON "Batch"("compoundingBatchId");

-- CreateIndex
CREATE INDEX "Batch_organizationId_idx" ON "Batch"("organizationId");

-- CreateIndex
CREATE INDEX "Batch_productId_idx" ON "Batch"("productId");

-- CreateIndex
CREATE INDEX "Batch_manufacturerId_idx" ON "Batch"("manufacturerId");

-- CreateIndex
CREATE INDEX "Batch_supplierId_idx" ON "Batch"("supplierId");

-- CreateIndex
CREATE INDEX "Batch_compoundingBatchId_idx" ON "Batch"("compoundingBatchId");

-- CreateIndex
CREATE INDEX "Batch_expirationDate_idx" ON "Batch"("expirationDate");

-- CreateIndex
CREATE INDEX "Batch_isActive_idx" ON "Batch"("isActive");

-- CreateIndex
CREATE INDEX "Batch_expirationDate_isActive_idx" ON "Batch"("expirationDate", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Batch_organizationId_batchNumber_key" ON "Batch"("organizationId", "batchNumber");

-- CreateIndex
CREATE INDEX "InboundShipment_organizationId_idx" ON "InboundShipment"("organizationId");

-- CreateIndex
CREATE INDEX "InboundShipment_supplierId_idx" ON "InboundShipment"("supplierId");

-- CreateIndex
CREATE INDEX "InboundShipment_purchaseOrderId_idx" ON "InboundShipment"("purchaseOrderId");

-- CreateIndex
CREATE INDEX "InboundShipment_status_idx" ON "InboundShipment"("status");

-- CreateIndex
CREATE INDEX "InboundShipment_receivedDate_idx" ON "InboundShipment"("receivedDate");

-- CreateIndex
CREATE UNIQUE INDEX "InboundShipment_organizationId_shipmentNumber_key" ON "InboundShipment"("organizationId", "shipmentNumber");

-- CreateIndex
CREATE INDEX "InboundShipmentItem_inboundShipmentId_idx" ON "InboundShipmentItem"("inboundShipmentId");

-- CreateIndex
CREATE INDEX "InboundShipmentItem_batchId_idx" ON "InboundShipmentItem"("batchId");

-- CreateIndex
CREATE INDEX "InboundShipmentItem_productId_idx" ON "InboundShipmentItem"("productId");

-- CreateIndex
CREATE INDEX "InboundShipmentItem_locationId_idx" ON "InboundShipmentItem"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "InboundShipmentItem_inboundShipmentId_batchId_key" ON "InboundShipmentItem"("inboundShipmentId", "batchId");

-- CreateIndex
CREATE INDEX "Manufacturer_organizationId_idx" ON "Manufacturer"("organizationId");

-- CreateIndex
CREATE INDEX "Manufacturer_isActive_idx" ON "Manufacturer"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Manufacturer_organizationId_code_key" ON "Manufacturer"("organizationId", "code");

-- CreateIndex
CREATE UNIQUE INDEX "Manufacturer_organizationId_name_key" ON "Manufacturer"("organizationId", "name");

-- CreateIndex
CREATE INDEX "OutboundShipment_organizationId_idx" ON "OutboundShipment"("organizationId");

-- CreateIndex
CREATE INDEX "OutboundShipment_status_idx" ON "OutboundShipment"("status");

-- CreateIndex
CREATE INDEX "OutboundShipment_shipmentDate_idx" ON "OutboundShipment"("shipmentDate");

-- CreateIndex
CREATE UNIQUE INDEX "OutboundShipment_organizationId_shipmentNumber_key" ON "OutboundShipment"("organizationId", "shipmentNumber");

-- CreateIndex
CREATE INDEX "OutboundShipmentItem_outboundShipmentId_idx" ON "OutboundShipmentItem"("outboundShipmentId");

-- CreateIndex
CREATE INDEX "OutboundShipmentItem_batchId_idx" ON "OutboundShipmentItem"("batchId");

-- CreateIndex
CREATE INDEX "OutboundShipmentItem_productId_idx" ON "OutboundShipmentItem"("productId");

-- CreateIndex
CREATE INDEX "OutboundShipmentItem_locationId_idx" ON "OutboundShipmentItem"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "OutboundShipmentItem_outboundShipmentId_batchId_key" ON "OutboundShipmentItem"("outboundShipmentId", "batchId");

-- CreateIndex
CREATE INDEX "Product_organizationId_idx" ON "Product"("organizationId");

-- CreateIndex
CREATE INDEX "Product_productType_idx" ON "Product"("productType");

-- CreateIndex
CREATE INDEX "Product_categoryId_idx" ON "Product"("categoryId");

-- CreateIndex
CREATE INDEX "Product_manufacturerId_idx" ON "Product"("manufacturerId");

-- CreateIndex
CREATE INDEX "Product_baseUnitId_idx" ON "Product"("baseUnitId");

-- CreateIndex
CREATE INDEX "Product_stockingUnitId_idx" ON "Product"("stockingUnitId");

-- CreateIndex
CREATE INDEX "Product_sellingUnitId_idx" ON "Product"("sellingUnitId");

-- CreateIndex
CREATE INDEX "Product_isActive_idx" ON "Product"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Product_organizationId_code_key" ON "Product"("organizationId", "code");

-- CreateIndex
CREATE INDEX "ProductCategory_organizationId_idx" ON "ProductCategory"("organizationId");

-- CreateIndex
CREATE INDEX "ProductCategory_parentId_idx" ON "ProductCategory"("parentId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductCategory_organizationId_name_key" ON "ProductCategory"("organizationId", "name");

-- CreateIndex
CREATE INDEX "PurchaseOrder_organizationId_idx" ON "PurchaseOrder"("organizationId");

-- CreateIndex
CREATE INDEX "PurchaseOrder_supplierId_idx" ON "PurchaseOrder"("supplierId");

-- CreateIndex
CREATE INDEX "PurchaseOrder_status_idx" ON "PurchaseOrder"("status");

-- CreateIndex
CREATE INDEX "PurchaseOrder_orderDate_idx" ON "PurchaseOrder"("orderDate");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrder_organizationId_orderNumber_key" ON "PurchaseOrder"("organizationId", "orderNumber");

-- CreateIndex
CREATE INDEX "PurchaseOrderItem_purchaseOrderId_idx" ON "PurchaseOrderItem"("purchaseOrderId");

-- CreateIndex
CREATE INDEX "PurchaseOrderItem_productId_idx" ON "PurchaseOrderItem"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_purchaseOrderId_productId_key" ON "PurchaseOrderItem"("purchaseOrderId", "productId");

-- CreateIndex
CREATE INDEX "StockAdjustment_organizationId_idx" ON "StockAdjustment"("organizationId");

-- CreateIndex
CREATE INDEX "StockAdjustment_productId_idx" ON "StockAdjustment"("productId");

-- CreateIndex
CREATE INDEX "StockAdjustment_locationId_idx" ON "StockAdjustment"("locationId");

-- CreateIndex
CREATE INDEX "StockAdjustment_batchId_idx" ON "StockAdjustment"("batchId");

-- CreateIndex
CREATE INDEX "StockAdjustment_adjustmentDate_idx" ON "StockAdjustment"("adjustmentDate");

-- CreateIndex
CREATE UNIQUE INDEX "StockAdjustment_organizationId_adjustmentNumber_key" ON "StockAdjustment"("organizationId", "adjustmentNumber");

-- CreateIndex
CREATE INDEX "StockMovement_organizationId_idx" ON "StockMovement"("organizationId");

-- CreateIndex
CREATE INDEX "StockMovement_productId_idx" ON "StockMovement"("productId");

-- CreateIndex
CREATE INDEX "StockMovement_locationId_idx" ON "StockMovement"("locationId");

-- CreateIndex
CREATE INDEX "StockMovement_batchId_idx" ON "StockMovement"("batchId");

-- CreateIndex
CREATE INDEX "StockMovement_movementType_idx" ON "StockMovement"("movementType");

-- CreateIndex
CREATE INDEX "StockMovement_createdAt_idx" ON "StockMovement"("createdAt");

-- CreateIndex
CREATE INDEX "StockMovement_organizationId_productId_locationId_createdAt_idx" ON "StockMovement"("organizationId", "productId", "locationId", "createdAt");

-- CreateIndex
CREATE INDEX "Supplier_organizationId_idx" ON "Supplier"("organizationId");

-- CreateIndex
CREATE INDEX "Supplier_isActive_idx" ON "Supplier"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_organizationId_code_key" ON "Supplier"("organizationId", "code");

-- CreateIndex
CREATE INDEX "Transfer_organizationId_idx" ON "Transfer"("organizationId");

-- CreateIndex
CREATE INDEX "Transfer_productId_idx" ON "Transfer"("productId");

-- CreateIndex
CREATE INDEX "Transfer_batchId_idx" ON "Transfer"("batchId");

-- CreateIndex
CREATE INDEX "Transfer_fromLocationId_idx" ON "Transfer"("fromLocationId");

-- CreateIndex
CREATE INDEX "Transfer_toLocationId_idx" ON "Transfer"("toLocationId");

-- CreateIndex
CREATE INDEX "Transfer_status_idx" ON "Transfer"("status");

-- CreateIndex
CREATE INDEX "Transfer_transferDate_idx" ON "Transfer"("transferDate");

-- CreateIndex
CREATE UNIQUE INDEX "Transfer_organizationId_transferNumber_key" ON "Transfer"("organizationId", "transferNumber");

-- CreateIndex
CREATE INDEX "UnitOfMeasure_organizationId_idx" ON "UnitOfMeasure"("organizationId");

-- CreateIndex
CREATE INDEX "UnitOfMeasure_isActive_idx" ON "UnitOfMeasure"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "UnitOfMeasure_organizationId_code_key" ON "UnitOfMeasure"("organizationId", "code");

-- CreateIndex
CREATE INDEX "WarehouseLocation_organizationId_idx" ON "WarehouseLocation"("organizationId");

-- CreateIndex
CREATE INDEX "WarehouseLocation_isActive_idx" ON "WarehouseLocation"("isActive");

-- CreateIndex
CREATE INDEX "WarehouseLocation_locationType_idx" ON "WarehouseLocation"("locationType");

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseLocation_organizationId_code_key" ON "WarehouseLocation"("organizationId", "code");

-- AddForeignKey
ALTER TABLE "Batch" ADD CONSTRAINT "Batch_compoundingBatchId_fkey" FOREIGN KEY ("compoundingBatchId") REFERENCES "CompoundingBatch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BatchInventory" ADD CONSTRAINT "BatchInventory_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES "Batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BatchInventory" ADD CONSTRAINT "BatchInventory_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BatchInventory" ADD CONSTRAINT "BatchInventory_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "WarehouseLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InboundShipmentItem" ADD CONSTRAINT "InboundShipmentItem_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "WarehouseLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OutboundShipmentItem" ADD CONSTRAINT "OutboundShipmentItem_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES "Batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OutboundShipmentItem" ADD CONSTRAINT "OutboundShipmentItem_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "WarehouseLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transfer" ADD CONSTRAINT "Transfer_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES "Batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Formula" ADD CONSTRAINT "Formula_yieldUnitId_fkey" FOREIGN KEY ("yieldUnitId") REFERENCES "UnitOfMeasure"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Formula" ADD CONSTRAINT "Formula_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FormulaIngredient" ADD CONSTRAINT "FormulaIngredient_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FormulaIngredient" ADD CONSTRAINT "FormulaIngredient_unitOfMeasureId_fkey" FOREIGN KEY ("unitOfMeasureId") REFERENCES "UnitOfMeasure"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FormulaIngredient" ADD CONSTRAINT "FormulaIngredient_formulaId_fkey" FOREIGN KEY ("formulaId") REFERENCES "Formula"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompoundingBatch" ADD CONSTRAINT "CompoundingBatch_formulaId_fkey" FOREIGN KEY ("formulaId") REFERENCES "Formula"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompoundingBatch" ADD CONSTRAINT "CompoundingBatch_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "WarehouseLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompoundingBatchMaterial" ADD CONSTRAINT "CompoundingBatchMaterial_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompoundingBatchMaterial" ADD CONSTRAINT "CompoundingBatchMaterial_batchId_fkey" FOREIGN KEY ("batchId") REFERENCES "Batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompoundingBatchMaterial" ADD CONSTRAINT "CompoundingBatchMaterial_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "WarehouseLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompoundingBatchMaterial" ADD CONSTRAINT "CompoundingBatchMaterial_compoundingBatchId_fkey" FOREIGN KEY ("compoundingBatchId") REFERENCES "CompoundingBatch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
