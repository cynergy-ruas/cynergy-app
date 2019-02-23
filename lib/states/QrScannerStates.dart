import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class QrScannerState extends Equatable{
  QrScannerState([List props = const []]):
      super(props);
}

class QrScannerInitial extends QrScannerState{
  @override
  String toString() => "QrScannerInitial";
}

//class QrScannerScanning extends QrScannerState{
//  @override
//  String toString() => "QrScannerScanning";
//}

class QrScannerSuccess extends QrScannerState{

  final String email;
  final String eventid;

  QrScannerSuccess({@required this.email, @required this.eventid}):
      assert(email != null),
      assert(eventid != null);

  @override
  String toString() => "QrScannerSucess";
}

class QrScannerFailure extends QrScannerState{
  @override
  String toString() => "QrScannerFailure";
}