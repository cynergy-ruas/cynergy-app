import 'package:qr_flutter/qr_flutter.dart';
//import 'package:cynergy_app/pages/qr/qrGenerator.dart';
import 'package:flutter/material.dart';


class Painter extends StatefulWidget {
  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  String _dataString = 'yolo';
  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentWidget(),
      resizeToAvoidBottomPadding: true,
    );
  }

  @override
  void didUpdateWidget(Painter oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Widget _contentWidget() {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 30.0,
              right: 20.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              height: _topSectionHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Enter a custom message',
                        errorText: _inputErrorText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FlatButton(
                      child: const Text('SUBMIT'),
                      onPressed: () {
                        setState(() {
                          _dataString = _textController.text;
                          _inputErrorText = null;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: QrImage(
                  data: _dataString,
                  gapless: false,
                  foregroundColor: const Color(0xFF111111),
                  onError: (dynamic ex) {
                    print('[QR] ERROR - $ex');
                    setState(() {
                      _inputErrorText =
                          'Error! Maybe your input value is too long?';
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}