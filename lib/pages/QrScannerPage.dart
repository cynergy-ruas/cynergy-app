import 'package:cynergy_app/services/Database.dart';
import 'package:cynergy_app/services/QrHandler.dart';
import 'package:cynergy_app/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cynergy_app/states/QrScannerStates.dart';
import 'package:cynergy_app/events/QrScannerEvents.dart';
import 'package:cynergy_app/bloc/QrScannerBloc.dart';

class QrScannerPage extends StatefulWidget {

  final Database db;

  QrScannerPage({@required this.db}):
      assert(db != null);

  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {

  QrScannerBloc _qrScannerBloc;
  Database get _db => widget.db;

  @override
  void initState(){
    _qrScannerBloc = QrScannerBloc(qrHandler: QrHandler(db: _db));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: BlocBuilder<QrScannerEvent, QrScannerState>(
        bloc: _qrScannerBloc,
        builder: (BuildContext context, QrScannerState state) {
          if(state is QrScannerInitial){
            return Center(
              child: _scanButton(),
            );
          }

          if (state is QrScannerProcessingResults){
            return LoadingIndicator();
          }

          if(state is QrScannerSuccess){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _scanButton(),
                  SizedBox(height: 20,),
                  Text("Attendance of "+state.email+" taken!")
                ],
              ),
            );
          }

          if(state is QrScannerFailure){
            _onWidgetDidBuild(() => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Try again'),
                backgroundColor: Colors.red,
              ),
            ));
            return Center(
              child: _scanButton(),
            );
          }
        },
      )
    );
  }

  Widget _scanButton(){
    return Container(
      child: IconButton(
        icon: Icon(Icons.filter_center_focus),
        iconSize: 60,
        onPressed: () => _qrScannerBloc.dispatch(QrScannerStartScan()),
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  void dispose() {
    _qrScannerBloc.dispose();
    super.dispose();
  }
}
