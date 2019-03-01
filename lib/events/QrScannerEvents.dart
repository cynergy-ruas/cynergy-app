import 'package:equatable/equatable.dart';

class QrScannerEvent extends Equatable{
  QrScannerEvent([List props = const []]):
      super(props);
}

class QrScannerStartScan extends QrScannerEvent{
  @override
  String toString() => "QrScannerStartScan";
}

