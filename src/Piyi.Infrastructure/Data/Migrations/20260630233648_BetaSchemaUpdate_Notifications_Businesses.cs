using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Piyi.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class BetaSchemaUpdate_Notifications_Businesses : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Businesses_BusinessTypes_BusinessTypeId",
                table: "Businesses");

            migrationBuilder.AlterColumn<string>(
                name: "WhatsApp",
                table: "Businesses",
                type: "character varying(40)",
                maxLength: 40,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(30)",
                oldMaxLength: 30,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Website",
                table: "Businesses",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "TikTokUrl",
                table: "Businesses",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Status",
                table: "Businesses",
                type: "character varying(40)",
                maxLength: 40,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(30)",
                oldMaxLength: 30);

            migrationBuilder.AlterColumn<string>(
                name: "Region",
                table: "Businesses",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(80)",
                oldMaxLength: 80,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Phone",
                table: "Businesses",
                type: "character varying(40)",
                maxLength: 40,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(30)",
                oldMaxLength: 30,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Businesses",
                type: "character varying(180)",
                maxLength: 180,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(150)",
                oldMaxLength: 150);

            migrationBuilder.AlterColumn<string>(
                name: "LogoUrl",
                table: "Businesses",
                type: "character varying(1000)",
                maxLength: 1000,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<bool>(
                name: "IsVerified",
                table: "Businesses",
                type: "boolean",
                nullable: false,
                defaultValue: false,
                oldClrType: typeof(bool),
                oldType: "boolean");

            migrationBuilder.AlterColumn<string>(
                name: "InstagramUrl",
                table: "Businesses",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "FacebookUrl",
                table: "Businesses",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Businesses",
                type: "character varying(180)",
                maxLength: 180,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(150)",
                oldMaxLength: 150,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Description",
                table: "Businesses",
                type: "character varying(2000)",
                maxLength: 2000,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Country",
                table: "Businesses",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(80)",
                oldMaxLength: 80);

            migrationBuilder.AlterColumn<string>(
                name: "City",
                table: "Businesses",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(80)",
                oldMaxLength: 80,
                oldNullable: true);

            migrationBuilder.AlterColumn<Guid>(
                name: "BusinessTypeId",
                table: "Businesses",
                type: "uuid",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uuid");

            migrationBuilder.AlterColumn<string>(
                name: "Address",
                table: "Businesses",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Businesses",
                type: "boolean",
                nullable: false,
                defaultValue: true);

            migrationBuilder.CreateTable(
                name: "LostPetSightings",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    LostPetId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: true),
                    Latitude = table.Column<decimal>(type: "numeric(10,7)", precision: 10, scale: 7, nullable: false),
                    Longitude = table.Column<decimal>(type: "numeric(10,7)", precision: 10, scale: 7, nullable: false),
                    Address = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    Observation = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    PhotoUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    Status = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LostPetSightings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_LostPetSightings_LostPets_LostPetId",
                        column: x => x.LostPetId,
                        principalTable: "LostPets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_LostPetSightings_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "PetAppointments",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PetId = table.Column<Guid>(type: "uuid", nullable: false),
                    BusinessId = table.Column<Guid>(type: "uuid", nullable: true),
                    Type = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Status = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Title = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: false),
                    AppointmentDateTime = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    PlaceName = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: true),
                    Address = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    Latitude = table.Column<decimal>(type: "numeric(10,7)", precision: 10, scale: 7, nullable: true),
                    Longitude = table.Column<decimal>(type: "numeric(10,7)", precision: 10, scale: 7, nullable: true),
                    ContactName = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: true),
                    ContactPhone = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: true),
                    Notes = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    ReminderEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    ReminderAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PetAppointments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PetAppointments_Businesses_BusinessId",
                        column: x => x.BusinessId,
                        principalTable: "Businesses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_PetAppointments_Pets_PetId",
                        column: x => x.PetId,
                        principalTable: "Pets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserAlertSettings",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    LostPetAlertsEnabled = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true),
                    Latitude = table.Column<decimal>(type: "numeric(10,7)", precision: 10, scale: 7, nullable: true),
                    Longitude = table.Column<decimal>(type: "numeric(10,7)", precision: 10, scale: 7, nullable: true),
                    RadiusKm = table.Column<decimal>(type: "numeric(8,2)", precision: 8, scale: 2, nullable: false, defaultValue: 10m),
                    Country = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Region = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    City = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserAlertSettings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserAlertSettings_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserDevices",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    DeviceIdentifier = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Platform = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    PushToken = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    DeviceName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    AppVersion = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true),
                    LastSeenAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserDevices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserDevices_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserNotifications",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    Type = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: false),
                    Title = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: false),
                    Body = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    DataJson = table.Column<string>(type: "jsonb", nullable: true),
                    IsRead = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    ReadAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserNotifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserNotifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PushNotificationQueue",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserDeviceId = table.Column<Guid>(type: "uuid", nullable: true),
                    UserNotificationId = table.Column<Guid>(type: "uuid", nullable: true),
                    PushToken = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    Title = table.Column<string>(type: "character varying(180)", maxLength: 180, nullable: false),
                    Body = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    DataJson = table.Column<string>(type: "jsonb", nullable: true),
                    Status = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: false),
                    AttemptCount = table.Column<int>(type: "integer", nullable: false),
                    LastError = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    SentAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    NextAttemptAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    UpdatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedBy = table.Column<Guid>(type: "uuid", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PushNotificationQueue", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PushNotificationQueue_UserDevices_UserDeviceId",
                        column: x => x.UserDeviceId,
                        principalTable: "UserDevices",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_PushNotificationQueue_UserNotifications_UserNotificationId",
                        column: x => x.UserNotificationId,
                        principalTable: "UserNotifications",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_PushNotificationQueue_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Businesses_IsActive",
                table: "Businesses",
                column: "IsActive");

            migrationBuilder.CreateIndex(
                name: "IX_Businesses_IsVerified",
                table: "Businesses",
                column: "IsVerified");

            migrationBuilder.CreateIndex(
                name: "IX_Businesses_Name",
                table: "Businesses",
                column: "Name");

            migrationBuilder.CreateIndex(
                name: "IX_LostPetSightings_Latitude_Longitude",
                table: "LostPetSightings",
                columns: new[] { "Latitude", "Longitude" });

            migrationBuilder.CreateIndex(
                name: "IX_LostPetSightings_LostPetId",
                table: "LostPetSightings",
                column: "LostPetId");

            migrationBuilder.CreateIndex(
                name: "IX_LostPetSightings_Status",
                table: "LostPetSightings",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_LostPetSightings_UserId",
                table: "LostPetSightings",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_PetAppointments_AppointmentDateTime",
                table: "PetAppointments",
                column: "AppointmentDateTime");

            migrationBuilder.CreateIndex(
                name: "IX_PetAppointments_BusinessId",
                table: "PetAppointments",
                column: "BusinessId");

            migrationBuilder.CreateIndex(
                name: "IX_PetAppointments_PetId",
                table: "PetAppointments",
                column: "PetId");

            migrationBuilder.CreateIndex(
                name: "IX_PetAppointments_Status",
                table: "PetAppointments",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_PushNotificationQueue_NextAttemptAt",
                table: "PushNotificationQueue",
                column: "NextAttemptAt");

            migrationBuilder.CreateIndex(
                name: "IX_PushNotificationQueue_Status",
                table: "PushNotificationQueue",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_PushNotificationQueue_UserDeviceId",
                table: "PushNotificationQueue",
                column: "UserDeviceId");

            migrationBuilder.CreateIndex(
                name: "IX_PushNotificationQueue_UserId",
                table: "PushNotificationQueue",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_PushNotificationQueue_UserNotificationId",
                table: "PushNotificationQueue",
                column: "UserNotificationId");

            migrationBuilder.CreateIndex(
                name: "IX_UserAlertSettings_Latitude_Longitude",
                table: "UserAlertSettings",
                columns: new[] { "Latitude", "Longitude" });

            migrationBuilder.CreateIndex(
                name: "IX_UserAlertSettings_UserId",
                table: "UserAlertSettings",
                column: "UserId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserDevices_PushToken",
                table: "UserDevices",
                column: "PushToken");

            migrationBuilder.CreateIndex(
                name: "IX_UserDevices_UserId",
                table: "UserDevices",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserDevices_UserId_DeviceIdentifier",
                table: "UserDevices",
                columns: new[] { "UserId", "DeviceIdentifier" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_CreatedAt",
                table: "UserNotifications",
                column: "CreatedAt");

            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_IsRead",
                table: "UserNotifications",
                column: "IsRead");

            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_UserId",
                table: "UserNotifications",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Businesses_BusinessTypes_BusinessTypeId",
                table: "Businesses",
                column: "BusinessTypeId",
                principalTable: "BusinessTypes",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Businesses_BusinessTypes_BusinessTypeId",
                table: "Businesses");

            migrationBuilder.DropTable(
                name: "LostPetSightings");

            migrationBuilder.DropTable(
                name: "PetAppointments");

            migrationBuilder.DropTable(
                name: "PushNotificationQueue");

            migrationBuilder.DropTable(
                name: "UserAlertSettings");

            migrationBuilder.DropTable(
                name: "UserDevices");

            migrationBuilder.DropTable(
                name: "UserNotifications");

            migrationBuilder.DropIndex(
                name: "IX_Businesses_IsActive",
                table: "Businesses");

            migrationBuilder.DropIndex(
                name: "IX_Businesses_IsVerified",
                table: "Businesses");

            migrationBuilder.DropIndex(
                name: "IX_Businesses_Name",
                table: "Businesses");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Businesses");

            migrationBuilder.AlterColumn<string>(
                name: "WhatsApp",
                table: "Businesses",
                type: "character varying(30)",
                maxLength: 30,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(40)",
                oldMaxLength: 40,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Website",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "TikTokUrl",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Status",
                table: "Businesses",
                type: "character varying(30)",
                maxLength: 30,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(40)",
                oldMaxLength: 40);

            migrationBuilder.AlterColumn<string>(
                name: "Region",
                table: "Businesses",
                type: "character varying(80)",
                maxLength: 80,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Phone",
                table: "Businesses",
                type: "character varying(30)",
                maxLength: 30,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(40)",
                oldMaxLength: 40,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Businesses",
                type: "character varying(150)",
                maxLength: 150,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(180)",
                oldMaxLength: 180);

            migrationBuilder.AlterColumn<string>(
                name: "LogoUrl",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(1000)",
                oldMaxLength: 1000,
                oldNullable: true);

            migrationBuilder.AlterColumn<bool>(
                name: "IsVerified",
                table: "Businesses",
                type: "boolean",
                nullable: false,
                oldClrType: typeof(bool),
                oldType: "boolean",
                oldDefaultValue: false);

            migrationBuilder.AlterColumn<string>(
                name: "InstagramUrl",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "FacebookUrl",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Businesses",
                type: "character varying(150)",
                maxLength: 150,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(180)",
                oldMaxLength: 180,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Description",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(2000)",
                oldMaxLength: 2000,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Country",
                table: "Businesses",
                type: "character varying(80)",
                maxLength: 80,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "City",
                table: "Businesses",
                type: "character varying(80)",
                maxLength: 80,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<Guid>(
                name: "BusinessTypeId",
                table: "Businesses",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Address",
                table: "Businesses",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Businesses_BusinessTypes_BusinessTypeId",
                table: "Businesses",
                column: "BusinessTypeId",
                principalTable: "BusinessTypes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
