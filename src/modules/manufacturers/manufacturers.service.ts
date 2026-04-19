import {
  Injectable,
  ConflictException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service.js';
import {
  CreateManufacturerDto,
  UpdateManufacturerDto,
  ManufacturerQueryDto,
} from './dto/index.js';

@Injectable()
export class ManufacturersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(organizationId: string, dto: CreateManufacturerDto) {
    await this.checkUniqueConstraints(organizationId, dto.code, dto.name);

    return this.prisma.manufacturer.create({
      data: {
        code: dto.code,
        name: dto.name,
        contactEmail: dto.contactEmail,
        contactPhone: dto.contactPhone,
        address: dto.address,
        organizationId,
      },
    });
  }

  async findAll(organizationId: string, query: ManufacturerQueryDto) {
    const { page = 1, limit = 20, search } = query;

    const where: Prisma.ManufacturerWhereInput = {
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
                ],
              },
            ]
          : []),
      ],
    };

    const [data, total] = await Promise.all([
      this.prisma.manufacturer.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      this.prisma.manufacturer.count({ where }),
    ]);

    const mapped = data.map((m) => ({
      id: m.id,
      code: m.code,
      name: m.name,
      address: m.address,
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

  async findOne(organizationId: string, id: string) {
    const manufacturer = await this.prisma.manufacturer.findUnique({
      where: { id },
    });

    if (!manufacturer || manufacturer.organizationId !== organizationId) {
      throw new NotFoundException('Manufacturer not found');
    }

    return manufacturer;
  }

  async update(organizationId: string, id: string, dto: UpdateManufacturerDto) {
    await this.findOne(organizationId, id);

    if (dto.code || dto.name) {
      const existing = await this.prisma.manufacturer.findFirst({
        where: {
          organizationId,
          id: { not: id },
          ...(dto.code && { code: dto.code }),
          ...(dto.name && { name: dto.name }),
        },
      });

      if (existing && dto.code && existing.code === dto.code) {
        throw new ConflictException(
          'Manufacturer with this code already exists in the organization',
        );
      }

      if (existing && dto.name && existing.name === dto.name) {
        throw new ConflictException(
          'Manufacturer with this name already exists in the organization',
        );
      }
    }

    return this.prisma.manufacturer.update({
      where: { id },
      data: {
        ...(dto.name && { name: dto.name }),
        ...(dto.code && { code: dto.code }),
        ...(dto.contactEmail !== undefined && {
          contactEmail: dto.contactEmail,
        }),
        ...(dto.contactPhone !== undefined && {
          contactPhone: dto.contactPhone,
        }),
        ...(dto.address !== undefined && { address: dto.address }),
        ...(dto.isActive !== undefined && { isActive: dto.isActive }),
      },
    });
  }

  async remove(organizationId: string, id: string) {
    await this.findOne(organizationId, id);

    const [productsCount, batchesCount] = await Promise.all([
      this.prisma.product.count({
        where: { manufacturerId: id },
      }),
      this.prisma.batch.count({
        where: { manufacturerId: id },
      }),
    ]);

    if (productsCount > 0 || batchesCount > 0) {
      throw new BadRequestException(
        'Cannot delete manufacturer: it is referenced by products or batches',
      );
    }

    return this.prisma.manufacturer.update({
      where: { id },
      data: { isActive: false },
    });
  }

  private async checkUniqueConstraints(
    organizationId: string,
    code: string,
    name: string,
  ) {
    const existing = await this.prisma.manufacturer.findFirst({
      where: {
        organizationId,
        OR: [{ code }, { name }],
      },
    });

    if (existing && existing.code === code) {
      throw new ConflictException(
        'Manufacturer with this code already exists in the organization',
      );
    }

    if (existing && existing.name === name) {
      throw new ConflictException(
        'Manufacturer with this name already exists in the organization',
      );
    }
  }
}
