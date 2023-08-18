import 'package:telephony/telephony.dart';

// Telephony
final telephony = Telephony.instance;

//- NetworkOperatorName
Future<String?> getNetworkOperatorName() async {
  var networkOperatorName = telephony.networkOperatorName;

  return networkOperatorName;
}

//- NetworkRoaming
Future<String> getNetworkRoaming() async {
  var isNetworkRoaming = telephony.isNetworkRoaming;

  if (isNetworkRoaming == true) {
    return 'Y';
  } else {
    return 'N';
  }
}

//- NetworkType
Future<String> getNetworkType() async {
  var networkType = await telephony.dataNetworkType;
  String networkTypeString = networkType.toString();

  int index = networkTypeString.indexOf('.') + 1;

  networkTypeString = networkTypeString.substring(index);
  return networkTypeString;
}

//- ServiceState
Future<String> getServiceState() async {
  var serviceState = await telephony.serviceState;

  int index = -1;

  String serviceStateString = serviceState.toString();
  index = serviceStateString.indexOf('.') + 1;

  serviceStateString = serviceStateString.substring(index);

  if (serviceStateString == 'IN_SERVICE') {
    return '정상';
  } else if (serviceStateString == 'EMERGENCY_ONLY') {
    return '긴급전화만 가능';
  } else {
    return '서비스 불가';
  }
}

// - SignalStrength
Future<String> getSignalStrength() async {
  List<SignalStrength> signalStrengths = await telephony.signalStrengths;
  var signalStrengthsString = signalStrengths.toString();
  int startIndex = signalStrengthsString.indexOf('.')+1;
  int endIndex = signalStrengthsString.indexOf(']');
  signalStrengthsString = signalStrengthsString.substring(startIndex, endIndex);

  if (signalStrengthsString == 'NONE_OR_UNKNOWN') {
    return '연결없음';
  } else if (signalStrengthsString == 'POOR') {
    return '약함';
  } else if (signalStrengthsString == 'MODERATE') {
    return '보통';
  } else if (signalStrengthsString == 'GOOD') {
    return '좋음';
  } else if (signalStrengthsString == 'GREAT') {
    return '매우 좋음';
  } else if (signalStrengthsString == null) {
    return '연결없음';
  } else {
    return 'ERROR';
  }

}
