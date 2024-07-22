import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth App',
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> devices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions().then((granted) {
      if (granted) {
        _startScan();
      }
    });
  }

  Future<bool> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permissions required'),
          content: Text(
              'This app needs Bluetooth and Location permissions to scan for devices.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return allGranted;
  }

  void _startScan() {
    setState(() {
      devices.clear();
      isScanning = true;
    });

    bluetooth.startDiscovery().listen((r) {
      setState(() {
        devices.add(r);
      });
      print('${r.device.address}: "${r.device.name}" found!');
    }).onDone(() {
      setState(() {
        isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Nama : Muhammad Irfan Noufal'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('NIM : 2207411025'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                BluetoothDiscoveryResult result = devices[index];
                return ListTile(
                  title: Text(result.device.name ?? 'Unknown Device'),
                  subtitle: Text(result.device.address),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isScanning ? null : _checkPermissions,
              child: Text('Scan for Devices'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : _checkPermissions,
        child: Icon(Icons.search),
      ),
    );
  }
}
