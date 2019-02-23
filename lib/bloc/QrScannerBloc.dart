import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:cynergy_app/events/QrScannerEvents.dart';

import 'package:cynergy_app/states/QrScannerStates.dart';

import 'package:cynergy_app/services/QrHandler.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState>{

  final QrHandler qrHandler;

  QrScannerBloc({@required this.qrHandler}):
      assert(qrHandler != null);

  @override
  QrScannerState get initialState => QrScannerInitial();

  @override
  Stream<QrScannerState> mapEventToState(QrScannerState currentState, QrScannerEvent event) async*{
    if (event is QrScannerStartScan){
      List<String> res = await qrHandler.scan();

      if (res != null){
        yield QrScannerSuccess(email: res[0], eventid: res[1]);
      }else{
        yield QrScannerFailure();
      }
    }
  }

}