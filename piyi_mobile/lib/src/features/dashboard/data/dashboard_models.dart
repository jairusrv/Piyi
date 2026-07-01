class DashboardSummary {
  const DashboardSummary({
    required this.petsCount,
    required this.lostPetsCount,
    required this.notificationsCount,
    required this.businessesCount,
    this.petsError,
    this.lostPetsError,
    this.notificationsError,
    this.businessesError,
  });

  final int petsCount;
  final int lostPetsCount;
  final int notificationsCount;
  final int businessesCount;

  final String? petsError;
  final String? lostPetsError;
  final String? notificationsError;
  final String? businessesError;

  bool get hasPartialErrors =>
      petsError != null ||
      lostPetsError != null ||
      notificationsError != null ||
      businessesError != null;
}

class DashboardActivity {
  const DashboardActivity({
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String title;
  final String subtitle;
  final String type;
}

class DashboardReminder {
  const DashboardReminder({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.type,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String type;
}
