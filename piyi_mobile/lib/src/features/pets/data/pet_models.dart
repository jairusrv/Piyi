class Species {
  Species({
    required this.id,
    required this.name,
    required this.code,
    this.icon,
  });

  final String id;
  final String name;
  final String code;
  final String? icon;

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      icon: json['icon'] as String?,
    );
  }
}

class Breed {
  Breed({
    required this.id,
    required this.speciesId,
    required this.name,
  });

  final String id;
  final String speciesId;
  final String name;

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      name: json['name'] as String,
    );
  }
}

class Pet {
  Pet({
    required this.id,
    required this.name,
    required this.speciesId,
    required this.speciesName,
    this.breedId,
    this.breedName,
    this.color,
    this.birthDate,
    required this.sex,
    this.weightKg,
    required this.isSterilized,
    this.microchipNumber,
    this.photoUrl,
    required this.status,
  });

  final String id;
  final String name;
  final String speciesId;
  final String speciesName;
  final String? breedId;
  final String? breedName;
  final String? color;
  final String? birthDate;
  final String sex;
  final num? weightKg;
  final bool isSterilized;
  final String? microchipNumber;
  final String? photoUrl;
  final String status;

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      speciesId: json['speciesId'] as String,
      speciesName: json['speciesName'] as String? ?? '',
      breedId: json['breedId'] as String?,
      breedName: json['breedName'] as String?,
      color: json['color'] as String?,
      birthDate: json['birthDate'] as String?,
      sex: json['sex'] as String? ?? 'Unknown',
      weightKg: json['weightKg'] as num?,
      isSterilized: json['isSterilized'] as bool? ?? false,
      microchipNumber: json['microchipNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      status: json['status'] as String? ?? '',
    );
  }
}
