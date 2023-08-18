import 'package:device_imei/device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Device IMEI & Device Info &
final DeviceImei deviceImei = DeviceImei();
final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

//- model
Future<String> getPhoneModel() async {
  final AndroidDeviceInfo androidDeviceInfo =
  await deviceInfoPlugin.androidInfo;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  return androidInfo.model;
}

//- Manufacturer
Future<String?> getManufacturer() async {
  final AndroidDeviceInfo androidDeviceInfo =
  await deviceInfoPlugin.androidInfo;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  return androidInfo.manufacturer;
}

//- PlatformVersion
Future<String?> getPlatformVersion() async {
  return deviceImei.getPlatformVersion();
}




