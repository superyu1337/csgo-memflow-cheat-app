/// Flutter code sample for Scaffold

// This example shows a [Scaffold] with a [body] and [FloatingActionButton].
// The [body] is a [Text] placed in a [Center] in order to center the text
// within the [Scaffold]. The [FloatingActionButton] is connected to a
// callback that increments a counter.
//
// ![The Scaffold has a white background with a blue AppBar at the top. A blue FloatingActionButton is positioned at the bottom right corner of the Scaffold.](https://flutter.github.io/assets-for-api-docs/assets/material/scaffold.png)

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Project M",
      theme: ThemeData.dark(),
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _glow = false;
  bool _radar = false;
  bool _noflash = false;
  var _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.178.81:42069'),
  );

  void SaveChanges(context) {
    print(_channel);
    if (_channel.closeCode != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Unable to contact WebSocket, retrying connection."),
              duration: Duration(seconds: 1),
              action: SnackBarAction(
                  label: "Retry",
                  onPressed: () { this.SaveChanges(context); }
              )
          )
      );
      _channel = WebSocketChannel.connect(
          Uri.parse('ws://192.168.178.81:42069')
      );
    } else {
      _channel.sink.add([_glow ? 1 : 0, _radar ? 1 : 0, _noflash ? 1 : 0,]);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Saved changes."),
            duration: Duration(seconds: 1),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Project M'),
        ),
        body: Column(
          children: <Widget>[
            CheckboxListTile(
                title: Text("Glow ESP"),
                checkColor: Colors.white,
                value: _glow,
                onChanged: (bool? value) {
                  setState(() { _glow = value!; });
                },
                secondary: const Icon(Icons.remove_red_eye_outlined)
            ),
            CheckboxListTile(
                title: Text("Force Radar"),
                checkColor: Colors.white,
                value: _radar,
                onChanged: (bool? value) {
                  setState(() { _radar = value!; });
                },
                secondary: const Icon(Icons.radar)
            ),
            CheckboxListTile(
                title: Text("No Flash"),
                checkColor: Colors.white,
                value: _noflash,
                onChanged: (bool? value) {
                  setState(() { _noflash = value!; });
                },
                secondary: const Icon(Icons.flash_off)
            ),
          ],
        ),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () => {
                  SaveChanges(context)
                },
                tooltip: 'Save changes',
                child: const Icon(Icons.save),
              ),
            ]
        )
    );
  }
}