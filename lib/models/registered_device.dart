class RegisteredDevice {
  String id;
  String name;
  int rssi;
  bool isDetected;

  RegisteredDevice({
    required this.id,
    required this.name,
    required this.rssi,
    this.isDetected = false,
  });
}