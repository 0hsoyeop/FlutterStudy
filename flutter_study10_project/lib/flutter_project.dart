import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study10_project/network_summary.dart';
import 'package:flutter_study10_project/phone_info.dart';
import 'package:flutter_study10_project/phone_network.dart';


class FlutterProject extends StatefulWidget {
  _FlutterProjectState createState() => _FlutterProjectState();
}

class _FlutterProjectState extends State<FlutterProject> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            controller: controller,
            indicator: BoxDecoration(
              color: Colors.blue[50],
            ),
            tabs: <Widget>[
              Tab(
                child: Center(
                  child: Text(
                    '신호 품질',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Center(
                  child: Text(
                    '단말기 정보',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Center(
                  child: Text(
                    '단말기 네트워크',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: TabBarView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              NetworkSummary(),
              PhoneInfo(),
              PhoneNetwork(),
            ],
          ),
        ),
      ),
    );
  }
}

