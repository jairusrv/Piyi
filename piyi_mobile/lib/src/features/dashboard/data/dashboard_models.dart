class DashboardSummary {
  const DashboardSummary({
    required this.petsCount,
    required this.lostPetsCount,
    required this.notificationsCount,
    required this.businessesCount,
  });

  final int petsCount;
  final int lostPetsCount;
  final int notificationsCount;
  final int businessesCount;
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
