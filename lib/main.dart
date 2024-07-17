import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    var subscription = FlutterBluePlus.scanResults.listen(
      (results) {
        setState(() {
          devices = results.map((r) => r.device).toList();
        });
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          print(
              '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        }
      },
      onError: (e) => print(e),
    );
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
                BluetoothDevice device = devices[index];
                return ListTile(
                  title: Text(device.advName),
                  subtitle: Text(device.remoteId.toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _startScan,
              child: Text('Scan for Devices'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        child: Icon(Icons.search),
      ),
    );
  }
}
