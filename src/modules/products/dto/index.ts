import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsBoolean,
  IsUUID,
  IsArray,
} from 'class-validator';
import { Transform } from 'class-transformer';
import { ProductType } from '@prisma/client';
import { PaginationQueryDto } from '../../../common/dto/index.js';

export class CreateProductDto {
  @ApiProperty({ example: 'PRD-001' })
  @IsString()
  @IsOptional()
  code?: string;

  @ApiProperty({ example: 'Paracetamol 500mg' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({ example: 'Analgesik dan Antipiretik' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ enum: ProductType, default: ProductType.FINISHED_GOOD })
  @IsEnum(ProductType)
  productType: ProductType;

  @ApiPropertyOptional({ example: 'Tablet' })
  @IsString()
  @IsOptional()
  dosageForm?: string;

  @ApiPropertyOptional({ example: '500mg' })
  @IsString()
  @IsOptional()
  strength?: string;

  @ApiPropertyOptional({ example: '103-90-2' })
  @IsString()
  @IsOptional()
  casNumber?: string;

  @ApiPropertyOptional({ example: 'Pharmaceutical Grade' })
  @IsString()
  @IsOptional()
  grade?: string;

  @ApiPropertyOptional({ example: 100 })
  @IsInt()
  @IsOptional()
  minStock?: number;

  @ApiPropertyOptional({ example: 1000 })
  @IsInt()
  @IsOptional()
  maxStock?: number;

  @ApiProperty({ example: 'uuid-of-category' })
  @IsString()
  @IsNotEmpty()
  categoryId: string;

  @ApiProperty({ example: 'uuid-of-manufacturer' })
  @IsString()
  @IsNotEmpty()
  manufacturerId: string;

  @ApiProperty({ example: 'uuid-of-base-unit' })
  @IsString()
  @IsNotEmpty()
  baseUnitId: string;

  @ApiPropertyOptional({ example: 'uuid-of-purchase-unit' })
  @IsString()
  @IsOptional()
  purchaseUnitId?: string;
}

export class UpdateProductDto extends CreateProductDto {
}

export class ProductQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ type: Boolean })
  @Transform(({ value }) => {
    if (value === 'true') return true;
    if (value === 'false') return false;
    return undefined;
  })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @ApiPropertyOptional({ enum: ProductType })
  @IsEnum(ProductType)
  @IsOptional()
  productType?: ProductType;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional()
  @IsUUID()
  @IsOptional()
  categoryId?: string;

  @ApiPropertyOptional({
    type: [String],
    description: 'Comma-separated list of product IDs',
  })
  @Transform(({ value }) =>
    value ? value.split(',').map((id: string) => id.trim()) : undefined,
  )
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  ids?: string[];
}
