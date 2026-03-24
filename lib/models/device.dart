class Device {
  final int id;
  final String uuid;
  final bool available;
  final bool isNew;

  Device({
    required this.id,
    required this.uuid,
    required this.available,
    required this.isNew,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      uuid: json['uuid'],
      available: json['available'],
      isNew: json['isNew'],
    );
  }
}