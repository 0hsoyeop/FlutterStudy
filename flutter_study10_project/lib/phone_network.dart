import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study10_project/flutter_project.dart';
import 'package:flutter_study10_project/phone_info.dart';
import 'package:flutter_study10_project/telepony.dart';
import 'package:flutter_study10_project/component_build.dart';

class PhoneNetwork extends StatefulWidget {
  _PhoneNetworkState createState() => _PhoneNetworkState();
}

class _PhoneNetworkState extends State<PhoneNetwork> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Icon(
                    Icons.signal_cellular_alt,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '단말기 네트워크',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              buildTitleBottomBar(150.0),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildPhoneInfoContainer('망사업자명'),
                        SizedBox(height: 5),
                        buildPhoneInfoContainer('데이터 연결상태'),
                        SizedBox(height: 5),
                        buildPhoneInfoContainer('네트워크 타입'),
                        SizedBox(height: 5),
                        buildPhoneInfoContainer('신호세기'),
                        SizedBox(height: 5),
                        buildPhoneInfoContainer('로밍 여부'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFutureBuilder(getNetworkOperatorName()),
                        SizedBox(height: 5),
                        buildFutureBuilder(getServiceState()),
                        SizedBox(height: 5),
                        buildFutureBuilder(getNetworkType()),
                        SizedBox(height: 5),
                        buildFutureBuilder(getSignalStrength()),
                        SizedBox(height: 5),
                        buildFutureBuilder(getNetworkRoaming()),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}




