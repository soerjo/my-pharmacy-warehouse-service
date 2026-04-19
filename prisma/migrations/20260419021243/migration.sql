-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_sellingUnitId_fkey";

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_stockingUnitId_fkey";

-- AlterTable
ALTER TABLE "Product" ALTER COLUMN "stockingUnitId" DROP NOT NULL,
ALTER COLUMN "sellingUnitId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_stockingUnitId_fkey" FOREIGN KEY ("stockingUnitId") REFERENCES "UnitOfMeasure"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_sellingUnitId_fkey" FOREIGN KEY ("sellingUnitId") REFERENCES "UnitOfMeasure"("id") ON DELETE SET NULL ON UPDATE CASCADE;
