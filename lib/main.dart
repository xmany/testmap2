// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _appleStyle;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();

    getJsonFile('assets/map_standard.json').then((value) {
      assert(value != null);
      if (value != null && value.isNotEmpty) {
        _appleStyle = value;
        if (_controller != null) {
          _controller!.setMapStyle(_appleStyle);
        }
        print('parsing file: assets/map_standard.json');
      } else {
        print('Error parsing file: assets/map_standard.json');
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        rotateGesturesEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(40.7127837, -74.0059413),
          zoom: 16,
        ),
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (_appleStyle != null) {
      print('set style: assets/map_standard.json');
      controller.setMapStyle(_appleStyle);
    } else {
      print('style: assets/map_standard.json not load');
    }
  }
}

Future<String?> getJsonFile(String path) async {
  print('getting file $path');
  try {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  } catch (e) {
    print(e);
  }
  return null;
}
