import { PrismaService } from '../../prisma/prisma.service.js';
import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import {
  CreateUnitOfMeasureDto,
  UpdateUnitOfMeasureDto,
  UnitOfMeasureQueryDto,
} from './dto/index.js';

@Injectable()
export class UnitOfMeasuresService {
  constructor(private prisma: PrismaService) {}

  async create(dto: CreateUnitOfMeasureDto, organizationId: string) {
    if (dto.baseUnitId) {
      const base = await this.prisma.unitOfMeasure.findFirst({
        where: { id: dto.baseUnitId, organizationId },
      });
      if (!base) throw new NotFoundException('Base unit not found');
    }

    return this.prisma.unitOfMeasure.create({
      data: {
        code: dto.code,
        name: dto.name,
        abbreviation: dto.abbreviation,
        isBase: dto.isBase ?? !dto.baseUnitId,
        baseUnitId: dto.baseUnitId,
        conversionFactor: dto.conversionFactor
          ? dto.conversionFactor
          : undefined,
        organizationId,
      },
      include: { baseUnit: true, derivedUnits: true },
    });
  }

  async findAll(organizationId: string, query: UnitOfMeasureQueryDto) {
    const { page = 1, limit = 20, search } = query;

    const where: Prisma.UnitOfMeasureWhereInput = {
      AND: [
        { OR: [{ organizationId }, { organizationId: null }] },
        { isActive: true },
        ...(search
          ? [
              {
                OR: [
                  {
                    name: {
                      contains: search,
                      mode: Prisma.QueryMode.insensitive,
                    },
                  },
                  {
                    code: {
                      contains: search,
                      mode: Prisma.QueryMode.insensitive,
                    },
                  },
                  {
                    abbreviation: {
                      contains: search,
                      mode: Prisma.QueryMode.insensitive,
                    },
                  },
                ],
              },
            ]
          : []),
      ],
    };

    const [data, total] = await Promise.all([
      this.prisma.unitOfMeasure.findMany({
        where,
        include: { baseUnit: true, derivedUnits: true },
        orderBy: { name: 'asc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      this.prisma.unitOfMeasure.count({ where }),
    ]);

    const mapped = data.map((u) => ({
      id: u.id,
      code: u.code,
      name: u.name,
      abbreviation: u.abbreviation,
    }));

    return {
      data: mapped,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string, organizationId: string) {
    const uom = await this.prisma.unitOfMeasure.findFirst({
      where: { id, organizationId },
      include: { baseUnit: true, derivedUnits: true },
    });
    if (!uom) throw new NotFoundException('Unit of measure not found');
    return uom;
  }

  async update(
    id: string,
    dto: UpdateUnitOfMeasureDto,
    organizationId: string,
  ) {
    await this.findOne(id, organizationId);
    return this.prisma.unitOfMeasure.update({
      where: { id },
      data: dto,
      include: { baseUnit: true, derivedUnits: true },
    });
  }

  async remove(id: string, organizationId: string) {
    await this.findOne(id, organizationId);
    const inUse = await this.prisma.product.findFirst({
      where: {
        organizationId,
        OR: [
          { baseUnitId: id },
          { stockingUnitId: id },
          { sellingUnitId: id },
          { purchaseUnitId: id },
        ],
      },
    });
    if (inUse)
      throw new ConflictException('Unit of measure is in use by products');
    return this.prisma.unitOfMeasure.update({
      where: { id },
      data: { isActive: false },
    });
  }
}
