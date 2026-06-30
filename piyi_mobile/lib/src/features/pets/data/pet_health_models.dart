class PetQrCode {
  PetQrCode({
    required this.id,
    required this.petId,
    required this.code,
    required this.publicUrl,
    required this.isActive,
    required this.scanCount,
  });

  final String id;
  final String petId;
  final String code;
  final String publicUrl;
  final bool isActive;
  final int scanCount;

  factory PetQrCode.fromJson(Map<String, dynamic> json) {
    return PetQrCode(
      id: json['id'] as String,
      petId: json['petId'] as String,
      code: json['code'] as String,
      publicUrl: json['publicUrl'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      scanCount: json['scanCount'] as int? ?? 0,
    );
  }
}

class PetVaccine {
  PetVaccine({
    required this.id,
    required this.name,
    this.appliedDate,
    this.nextDueDate,
    this.notes,
  });

  final String id;
  final String name;
  final String? appliedDate;
  final String? nextDueDate;
  final String? notes;

  factory PetVaccine.fromJson(Map<String, dynamic> json) {
    return PetVaccine(
      id: json['id'] as String,
      name: json['name'] as String,
      appliedDate: json['appliedDate'] as String?,
      nextDueDate: json['nextDueDate'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

class PetReminder {
  PetReminder({
    required this.id,
    required this.title,
    required this.type,
    required this.reminderDate,
    required this.isCompleted,
    this.notes,
  });

  final String id;
  final String title;
  final String type;
  final String reminderDate;
  final bool isCompleted;
  final String? notes;

  factory PetReminder.fromJson(Map<String, dynamic> json) {
    return PetReminder(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String? ?? '',
      reminderDate: json['reminderDate'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}

class PetAppointment {
  PetAppointment({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.appointmentDateTime,
    this.placeName,
    this.address,
    this.contactPhone,
    this.notes,
  });

  final String id;
  final String title;
  final String type;
  final String status;
  final String appointmentDateTime;
  final String? placeName;
  final String? address;
  final String? contactPhone;
  final String? notes;

  factory PetAppointment.fromJson(Map<String, dynamic> json) {
    return PetAppointment(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? '',
      appointmentDateTime: json['appointmentDateTime'] as String? ?? '',
      placeName: json['placeName'] as String?,
      address: json['address'] as String?,
      contactPhone: json['contactPhone'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
