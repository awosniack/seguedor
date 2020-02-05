// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'widget.dart';
import 'package:vibration/vibration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FirstRoute();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class FirstRoute extends StatefulWidget {
  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  @override
  Widget build(BuildContext context) {
    String kp = "1.0";
    String kd = "1.0";
    String vel = "1.0";
    String velMax = "1.0";

    return Scaffold(
      body: Stack(children: [
        Row(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          labelText: "Kp",
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          kd = text;
                          print("Kp: $kp");
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          labelText: "Kd",
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          kd = text;
                          print("Kd: $kd");
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          labelText: "Vel",
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          vel = text;
                          print("Vel: $vel");
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          labelText: "VelMax",
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          velMax = text;
                          print("velMax: $velMax");
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      child: FlatButton(
                        child: Text("Upload"),
                        onPressed: () {
                          //TODO Enviar dados
                          Vibration.vibrate(duration: 1000);
                          print(
                              "Enviando Kp=$kp Kd=$kd Vel=$vel VelMax=$velMax");
                        },
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(22.0),
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 15,
          right: 20,
          child: Container(
            child: IconButton(
              icon: Icon(Icons.bluetooth),
              color: Colors.black87,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FindDevicesScreen()),
                );
              },
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange,
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          right: 20,
          child: Container(
            child: FlatButton(
              child: Text("Enable control"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnableControl()),
                );
              },
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(22.0),
              color: Colors.deepOrange,
            ),
          ),
        ),
      ]),
    );
  }
}

class EnableControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
          bottom: 70,
          right: 20,
          child: Container(
            child: FlatButton(
              child: Text("Disable control"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(22.0),
              color: Colors.deepOrange,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.lerp(
                Alignment.topCenter, Alignment.bottomCenter, 0.05),
            child: GestureDetector(
              onTapDown: (_) {
                Vibration.vibrate(duration: 10000);
                //TODO ficar mandando os dados pro bluetooth
              },
              onTapUp: (_) {
                Vibration.cancel();
                //TODO parar de ficar mandando os dados pro bluetooth
              },
              child: Container(
                child: Icon(
                  Icons.arrow_upward,
                  size: 130.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.lerp(
                Alignment.bottomCenter, Alignment.topCenter, 0.05),
            child: GestureDetector(
              onTapDown: (_) {
                Vibration.vibrate(duration: 10000);
                //TODO ficar mandando os dados pro bluetooth
              },
              onTapUp: (_) {
                Vibration.cancel();
                //TODO parar de ficar mandando os dados pro bluetooth
              },
              child: Container(
                child: Icon(
                  Icons.arrow_downward,
                  size: 130.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.lerp(
                Alignment.centerLeft, Alignment.centerRight, 0.32),
            child: GestureDetector(
              onTapDown: (_) {
                Vibration.vibrate(duration: 10000);
                //TODO ficar mandando os dados pro bluetooth
              },
              onTapUp: (_) {
                Vibration.cancel();
                //TODO parar de ficar mandando os dados pro bluetooth
              },
              child: Container(
                child: Icon(
                  Icons.arrow_back,
                  size: 130.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.lerp(
                Alignment.centerRight, Alignment.centerLeft, 0.32),
            child: GestureDetector(
              onTapDown: (_) {
                Vibration.vibrate(duration: 10000);
                //TODO ficar mandando os dados pro bluetooth
              },
              onTapUp: (_) {
                Vibration.cancel();
                //TODO parar de ficar mandando os dados pro bluetooth
              },
              child: Container(
                child: Icon(
                  Icons.arrow_forward,
                  size: 130.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.lerp(
                Alignment.centerRight, Alignment.centerLeft, 0.5),
            child: GestureDetector(
              onTapDown: (_) {
                Vibration.vibrate(duration: 10000);
                //TODO ficar mandando os dados pro bluetooth
              },
              onTapUp: (_) {
                Vibration.cancel();
                //TODO parar de ficar mandando os dados pro bluetooth
              },
              child: Container(
                child: Icon(
                  Icons.stop,
                  size: 80.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.black87,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.deepOrange,
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.black87, displayColor: Colors.black87),
        title: Text('Procurar dispositivos dente azul'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
            );
          } else {
            return FloatingActionButton(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.search),
              onPressed: () => FlutterBlue.instance.startScan(
                timeout: Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () => c.write(_getRandomBytes()),
                    onNotificationPressed: () =>
                        c.setNotifyValue(!c.isNotifying),
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                onPressed: onPressed,
                child: Text(
                  text,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
