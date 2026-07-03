using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Piyi.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class BetaBusinessReviewsRatings : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BusinessProfiles",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessId = table.Column<Guid>(type: "uuid", nullable: false),
                    BannerUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    ShortDescription = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    LongDescription = table.Column<string>(type: "character varying(3000)", maxLength: 3000, nullable: true),
                    Story = table.Column<string>(type: "character varying(3000)", maxLength: 3000, nullable: true),
                    Mission = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    Specialties = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    Languages = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    AcceptsSinpe = table.Column<bool>(type: "boolean", nullable: false),
                    AcceptsCard = table.Column<bool>(type: "boolean", nullable: false),
                    HasParking = table.Column<bool>(type: "boolean", nullable: false),
                    IsAccessible = table.Column<bool>(type: "boolean", nullable: false),
                    HasEmergency24h = table.Column<bool>(type: "boolean", nullable: false),
                    HasHomeService = table.Column<bool>(type: "boolean", nullable: false),
                    HasOwnDelivery = table.Column<bool>(type: "boolean", nullable: false),
                    WebsiteUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    FacebookUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    InstagramUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    TikTokUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    YouTubeUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    GalleryJson = table.Column<string>(type: "jsonb", nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusinessProfiles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusinessProfiles_Businesses_BusinessId",
                        column: x => x.BusinessId,
                        principalTable: "Businesses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BusinessReviews",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    Rating = table.Column<int>(type: "integer", nullable: false),
                    Comment = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    PhotosJson = table.Column<string>(type: "jsonb", nullable: true),
                    BusinessReply = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    BusinessRepliedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    IsReported = table.Column<bool>(type: "boolean", nullable: false),
                    ReportReason = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    IsApproved = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusinessReviews", x => x.Id);
                    table.CheckConstraint("CK_BusinessReviews_Rating", "\"Rating\" >= 1 AND \"Rating\" <= 5");
                    table.ForeignKey(
                        name: "FK_BusinessReviews_Businesses_BusinessId",
                        column: x => x.BusinessId,
                        principalTable: "Businesses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BusinessReviews_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BusinessProfiles_BusinessId",
                table: "BusinessProfiles",
                column: "BusinessId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_BusinessProfiles_IsDeleted",
                table: "BusinessProfiles",
                column: "IsDeleted");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessReviews_BusinessId",
                table: "BusinessReviews",
                column: "BusinessId");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessReviews_IsApproved",
                table: "BusinessReviews",
                column: "IsApproved");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessReviews_IsDeleted",
                table: "BusinessReviews",
                column: "IsDeleted");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessReviews_IsReported",
                table: "BusinessReviews",
                column: "IsReported");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessReviews_Rating",
                table: "BusinessReviews",
                column: "Rating");

            migrationBuilder.CreateIndex(
                name: "IX_BusinessReviews_UserId",
                table: "BusinessReviews",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BusinessProfiles");

            migrationBuilder.DropTable(
                name: "BusinessReviews");
        }
    }
}
