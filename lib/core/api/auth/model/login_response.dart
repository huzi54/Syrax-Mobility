class LoginData {
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;

  final int? residentId;
  final String? residentName;
  final String? phone;
  final String? email;

  final String? apt;
  final String? aptName;
  final String? address;

  final String? fcmToken;
  final bool? notificationEnabled;
  final String? notificationSnoozeUntil;

  final String? guardNotes;

  final int? guardHouseId;
  final int? communityId;
  final int? buildingId;

  final int? languageId;
  final List<Language>? languages;

  final bool? mustResetPassword;

  LoginData({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.residentId,
    this.residentName,
    this.phone,
    this.email,
    this.apt,
    this.aptName,
    this.address,
    this.fcmToken,
    this.notificationEnabled,
    this.notificationSnoozeUntil,
    this.guardNotes,
    this.guardHouseId,
    this.communityId,
    this.buildingId,
    this.languageId,
    this.languages,
    this.mustResetPassword,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      residentId: json['resident_id'],
      residentName: json['resident_name'],
      phone: json['phone'],
      email: json['email'],
      apt: json['apt'],
      aptName: json['apt_name'],
      address: json['address'],
      fcmToken: json['fcm_token'],
      notificationEnabled: json['notification_enabled'],
      notificationSnoozeUntil: json['notification_snooze_until'],
      guardNotes: json['resident_guard_notes'],
      guardHouseId: json['guard_house_id'],
      communityId: json['community_id'],
      buildingId: json['building_id'],
      languageId: json['language_id'],
      mustResetPassword: json['must_reset_password'],
      languages: json['languages'] != null
          ? (json['languages'] as List)
                .map((e) => Language.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
    'resident_id': residentId,
    'resident_name': residentName,
    'phone': phone,
    'email': email,
    'apt': apt,
    'apt_name': aptName,
    'address': address,
    'fcm_token': fcmToken,
    'notification_enabled': notificationEnabled,
    'notification_snooze_until': notificationSnoozeUntil,
    'resident_guard_notes': guardNotes,
    'guard_house_id': guardHouseId,
    'community_id': communityId,
    'building_id': buildingId,
    'language_id': languageId,
    'must_reset_password': mustResetPassword,
    'languages': languages?.map((e) => e.toJson()).toList(),
  };
}

class Language {
  final int? id;
  final String? code;
  final String? name;

  Language({this.id, this.code, this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(id: json['id'], code: json['code'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'code': code, 'name': name};
}
