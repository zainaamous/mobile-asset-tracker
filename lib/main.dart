import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/theme.dart'; // Changed import path here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Asset Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.accent,
        ),
        fontFamily: AppTypography.fontFamily,
        textTheme: TextTheme(
          bodyMedium: AppTypography.bodyText,
          titleLarge: AppTypography.title,
          titleMedium: AppTypography.subtitle,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const AssetTrackerHomePage(),
    );
  }
}

class AssetTrackerHomePage extends StatefulWidget {
  const AssetTrackerHomePage({super.key});

  @override
  State<AssetTrackerHomePage> createState() => _AssetTrackerHomePageState();
}

class _AssetTrackerHomePageState extends State<AssetTrackerHomePage> {
  List<RegisteredDevice> registeredDevices = [];
  String mobileDeviceId = "";

  @override
  void initState() {
    super.initState();
    mobileDeviceId = const Uuid().v4();
    _simulateRssiUpdates();
  }

  void _simulateRssiUpdates() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        for (var device in registeredDevices) {
          device.rssi = Random().nextInt(71) - 100;
        }
      });
      _simulateRssiUpdates();
    });
  }

  Future<void> _showDeviceNameDialog(String deviceId) async {
    String deviceName = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Enter Device Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            onChanged: (value) {
              deviceName = value;
            },
            decoration: const InputDecoration(
              hintText: "Device Name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addDevice(deviceId, deviceName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _simulateScan() {
    String newDeviceId = "";
    do {
      newDeviceId = const Uuid().v4();
    } while (registeredDevices.any((device) => device.id == newDeviceId));

    _showDeviceNameDialog(newDeviceId);
  }

  void _addDevice(String deviceId, String deviceName) {
    setState(() {
      registeredDevices.add(
        RegisteredDevice(
          id: deviceId,
          name: deviceName,
          rssi: Random().nextInt(71) - 100,
          lastDetected: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Asset Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: _simulateScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Scan for Devices'),
            ),
            const SizedBox(height: 32),
            Text(
              'Mobile Device ID: $mobileDeviceId',
              style: AppTypography.subtitle,
            ),
            const SizedBox(height: 32),
            Text('Registered Devices:', style: AppTypography.subtitle),
            const SizedBox(height: 16),
            ...registeredDevices.map((device) => DeviceCard(device: device)),
          ],
        ),
      ),
    );
  }
}

class RegisteredDevice {
  final String id;
  String name;
  int rssi;
  DateTime lastDetected;
  bool isDetected = false;

  RegisteredDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.lastDetected,
  });

  void toggleDetection() {
    isDetected = !isDetected;
  }
}

class DeviceCard extends StatelessWidget {
  final RegisteredDevice device;

  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device.name, style: AppTypography.subtitle),
              const SizedBox(height: 8),
              Text('ID: ${device.id}', style: AppTypography.bodyText),
              Text('RSSI: ${device.rssi} dB', style: AppTypography.bodyText),
              Text(
                'Last Detected: ${device.lastDetected}',
                style: AppTypography.bodyText,
              ),
              Text(
                device.isDetected ? 'Detected' : 'Not Detected',
                style: AppTypography.bodyText,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    device.toggleDetection();
                    (context as Element).markNeedsBuild();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),

                  child: Text(
                    device.isDetected ? 'Hide Device' : 'Detect Device',
                    style: AppTypography.bodyText.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
