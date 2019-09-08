import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';

Future<dynamic> updateClearanceForUser({@required String email, @required int clearance}) async {
  final HttpsCallable updateAdmin = CloudFunctions.instance.getHttpsCallable(
    functionName: "updateAdmin"
  );

  HttpsCallableResult response = await updateAdmin.call({
    "email": email,
    "clearance": clearance,
    "updation": (clearance != 0) ? true : false
  });

  return response.data;
}