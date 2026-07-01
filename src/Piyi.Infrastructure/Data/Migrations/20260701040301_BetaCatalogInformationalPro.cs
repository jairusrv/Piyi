using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Piyi.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class BetaCatalogInformationalPro : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsProviderPro",
                table: "Businesses",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateTable(
                name: "BusinessCatalogItems",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessId = table.Column<Guid>(type: "uuid", nullable: false),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: false),
                    Description = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    Category = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    Brand = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    Barcode = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: true),
                    Sku = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: true),
                    ReferencePrice = table.Column<decimal>(type: "numeric", nullable: true),
                    Currency = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false, defaultValue: "CRC"),
                    PhotoUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    IsAvailable = table.Column<bool>(type: "boolean", nullable: false),
                    IsFeatured = table.Column<bool>(type: "boolean", nullable: false),
                    PetSpecies = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    BreedTarget = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    AgeTarget = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    WeightTarget = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                    Tags = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    Notes = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusinessCatalogItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusinessCatalogItems_Businesses_BusinessId",
                        column: x => x.BusinessId,
                        principalTable: "Businesses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_Barcode",
                table: "BusinessCatalogItems",
                column: "Barcode");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_Brand",
                table: "BusinessCatalogItems",
                column: "Brand");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_BusinessId",
                table: "BusinessCatalogItems",
                column: "BusinessId");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_Category",
                table: "BusinessCatalogItems",
                column: "Category");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_IsAvailable",
                table: "BusinessCatalogItems",
                column: "IsAvailable");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_IsDeleted",
                table: "BusinessCatalogItems",
                column: "IsDeleted");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_IsFeatured",
                table: "BusinessCatalogItems",
                column: "IsFeatured");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_Sku",
                table: "BusinessCatalogItems",
                column: "Sku");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessCatalogItems_Type",
                table: "BusinessCatalogItems",
                column: "Type");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BusinessCatalogItems");

            migrationBuilder.DropColumn(
                name: "IsProviderPro",
                table: "Businesses");
        }
    }
}
