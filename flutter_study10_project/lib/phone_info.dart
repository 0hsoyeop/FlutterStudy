import 'package:flutter/material.dart';
import 'package:flutter_study10_project/component_build.dart';
import 'package:flutter_study10_project/device_info.dart';
import 'package:flutter_study10_project/network_summary.dart';

class PhoneInfo extends StatefulWidget {
  _PhoneInfoState createState() => _PhoneInfoState();
}

class _PhoneInfoState extends State<PhoneInfo> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    Icons.phone_iphone,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '단말기 정보',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              buildTitleBottomBar(120.0),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildPhoneInfoContainer('모델명'),
                        SizedBox(height: 5),
                        buildPhoneInfoContainer('제조사'),
                        SizedBox(height: 5),
                        buildPhoneInfoContainer('소프트웨어 버전'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFutureBuilder(getPhoneModel()),
                        SizedBox(height: 5),
                        buildFutureBuilder(getManufacturer()),
                        SizedBox(height: 5),
                        buildFutureBuilder(getPlatformVersion()),
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
