import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study10_project/component_build.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Chart
class NetworkSummary extends StatefulWidget {
  _NetworkSummary createState() => _NetworkSummary();
}

class _NetworkSummary extends State<NetworkSummary> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true; // 리랜더링 방지
  bool isDataCollecting = true; // 데이터 수집 중인지
  bool isTimerOn = true;
  final DataGridController _dataGridController = DataGridController();

  late Timer autoScrollTimer;
  late Timer updateTimer;

  var _buttonText = Text('Stop');
  var _buttonIcon = Icon(Icons.stop);

  String result = '';
  String rsrpResult = '';
  String rsrqResult = '';
  String rssiResult = '';


  // SfDataGrid에 사용할 데이터
  late SignalDataStringSource signalDataStringSource;
  List<Map<DateTime, String>> signalDataStringList = []; // DataGridView 데이터

  // 데이터 수집 시간
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(seconds: 59));
  DateTime previousEndTime = DateTime.now();

  // Chart에 사용할 데이터
  List<ChartData> rsrpData = [];
  List<ChartData> rsrqData = [];
  List<ChartData> rssiData = [];

  // 네이티브 코드와 일치하는 Channel
  static const platform =
      MethodChannel('com.example.flutter_study10_project/telephony');

  String signalStrength = ''; // RSRP 변수

  @override
  void initState() {
    super.initState();

    // SfDataGrid 데이터 초기화
    signalDataStringSource =
        SignalDataStringSource(signalDataStringList: signalDataStringList);

    // 20초 동안 반복해서 RSRP 수집
    _startSignalStrengthUpdates();
  }

  void _startSignalStrengthUpdates() {
    // 20초 후에 정지되도록 Timer 설정
    // Timer(Duration(seconds: 60), () {
    //   setState(() {
    //     isDataCollecting = false;
    //     isTimerOn = false;
    //     _buttonText = Text('Start');
    //     _buttonIcon = Icon(Icons.play_arrow);
    //   });
    // });

    // 1초마다 반복 실행할 타이머 생성

    updateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!isDataCollecting) {
        // isDataCollecting이 false일 경우 타이머 정지 (반복 정지)
        timer.cancel();
        isTimerOn = false;
      } else {
        // 1초마다 _getSignalStrength 호출
        await _getSignalStrength();
        setState(() {
          // DataGrid 새로 그리기

          signalDataStringSource = SignalDataStringSource(
              signalDataStringList: signalDataStringList);


          // Chart 새로 그리기
          DateTime currentTime = DateTime.now();
          DateTime autoScrollTime = startTime.add(Duration(seconds: 50));

          if (currentTime.isAfter(autoScrollTime)) {
            // 현재 시간이 autoScrollTime보다 뒤에 있다면 autoScroll 실행
            startTime = startTime.add(Duration(seconds: 10));
            endTime = endTime.add(Duration(seconds: 10));
            previousEndTime = endTime; // autoScroll을 위해 이전 endTime 저장
          }

          // 현재 시간이 이전 endTime과 같다면 autoScroll 실행
          if (currentTime.isAtSameMomentAs(previousEndTime)) {
            startTime = startTime.add(Duration(seconds: 10));
            endTime = endTime.add(Duration(seconds: 10));
            previousEndTime = endTime;
          }
        });
      }
    });

    autoScrollTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _dataGridController.scrollToRow(
        signalDataStringList.length-1,
        position: DataGridScrollPosition.end,
      );
    });

    updateTimer;

    autoScrollTimer;
  }

  // Java 코드로 RSRP 가져오는 부분
  Future<void> _getSignalStrength() async {
    if (await _requestPermission()) {
      // 권한 허용했을 경우 -> 데이터 수집 시작
      try {
        // MainActivity.java의 getSignalStrength 함수를 실행
        result = await platform.invokeMethod('getSignalStrength');
        rsrpResult = result.split(',')[0];
        rsrqResult = result.split(',')[1];
        rssiResult = result.split(',')[2];
      } on PlatformException catch (e) {
        // TODO: RSRP, RSRQ, SINR 에러 각각 처리하기
        result = '-';
      }
      // 수집한 RSRP 값을 토대로 위젯 새로 작성
      setState(() {
        int rsrpChartValue = int.parse(rsrpResult); // String을 double로 형변환
        int rsrqChartValue = int.parse(rsrqResult);
        int rssiChartValue = int.parse(rssiResult);

        DateTime now = DateTime.now();
        DateTime nowInSeconds = DateTime(
            now.year, now.month, now.day, now.hour, now.minute, now.second);

        // SfDataGrid 데이터 추가
        signalDataStringList.add({nowInSeconds: result});

        // Chart 데이터 추가
        rsrpData.add(
          ChartData(nowInSeconds, rsrpChartValue),
        );

        rsrqData.add(
          ChartData(nowInSeconds, rsrqChartValue),
        );

        rssiData.add(
          ChartData(nowInSeconds, rssiChartValue),
        );
      });
    } else {
      // 권한 허용하지 않았을 경우
      setState(() {
        signalStrength = '권한이 없습니다.';
      });
    }
  }

  // 권한 체크
  Future<bool> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone, // READ_PHONE_STATE 권한 추가
      Permission.location, // ACCESS_FINE_LOCATION 권한 추가
    ].request();

    if (statuses[Permission.phone] == PermissionStatus.granted &&
        statuses[Permission.location] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Row(
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Table',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                buildTitleBottomBar(82.0),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // 테이블
                  height: 440,
                  child: SfDataGrid(
                    controller: _dataGridController,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerRowHeight: 45,
                    rowHeight: 50,
                    frozenColumnsCount: 1,
                    highlightRowOnHover: true,
                    source: signalDataStringSource,
                    allowEditing: true,
                    columns: <GridColumn>[
                      buildGridColum('time', 'Time'),
                      buildGridColum('rsrp', 'RSRP'),
                      buildGridColum('rsrq', 'RSRQ'),
                      buildGridColum('rssi', 'RSSI'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.show_chart,
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      // 차트
                      'Chart',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                buildTitleBottomBar(82.0),
              ],
            ),
          ),
          buildChart('RSRP', rsrpData, -140, -43, startTime, endTime),
          SizedBox(height: 30),
          buildChart('RSRQ', rsrqData, -19.5, -3, startTime, endTime),
          SizedBox(height: 30),
          buildChart('RSSI', rssiData, -113, 51, startTime, endTime),
          SizedBox(height: 30),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton.extended(
                  icon: _buttonIcon,
                  label: _buttonText,
                  onPressed: () {
                    if (autoScrollTimer.isActive && updateTimer.isActive) {
                      // 멈춤
                      print('1번 눌림');
                      autoScrollTimer.cancel();
                      updateTimer.cancel();

                      print(autoScrollTimer.isActive);
                      print(updateTimer.isActive);
                      setState(() {
                        _buttonText = Text('Restart');
                        _buttonIcon = Icon(Icons.play_arrow);
                      });
                    } else if (!autoScrollTimer.isActive && !updateTimer.isActive)  {
                      //재시작
                      print('2번 눌림');
                      rsrpData.clear();
                      rsrqData.clear();
                      rssiData.clear();
                      signalDataStringList.clear();

                      startTime = DateTime.now();
                      endTime = DateTime.now().add(Duration(seconds: 59));
                      setState(() {
                        updateTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
                          if (!isDataCollecting) {
                            // isDataCollecting이 false일 경우 타이머 정지 (반복 정지)
                            timer.cancel();
                            isTimerOn = false;
                          } else {
                            // 1초마다 _getSignalStrength 호출
                            await _getSignalStrength();
                            setState(() {
                              // DataGrid 새로 그리기

                              signalDataStringSource = SignalDataStringSource(
                                  signalDataStringList: signalDataStringList);


                              // Chart 새로 그리기
                              DateTime currentTime = DateTime.now();
                              DateTime autoScrollTime = startTime.add(Duration(seconds: 50));

                              if (currentTime.isAfter(autoScrollTime)) {
                                // 현재 시간이 autoScrollTime보다 뒤에 있다면 autoScroll 실행
                                startTime = startTime.add(Duration(seconds: 10));
                                endTime = endTime.add(Duration(seconds: 10));
                                previousEndTime = endTime; // autoScroll을 위해 이전 endTime 저장
                              }

                              // 현재 시간이 이전 endTime과 같다면 autoScroll 실행
                              if (currentTime.isAtSameMomentAs(previousEndTime)) {
                                startTime = startTime.add(Duration(seconds: 10));
                                endTime = endTime.add(Duration(seconds: 10));
                                previousEndTime = endTime;
                              }
                            });
                          }
                        });
                        autoScrollTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
                          _dataGridController.scrollToRow(
                            signalDataStringList.length-1,
                            position: DataGridScrollPosition.end,
                          );
                        });

                        autoScrollTimer;
                        updateTimer;
                        _buttonText = Text('Stop');
                        _buttonIcon = Icon(Icons.stop);
                      });
                      print(autoScrollTimer.isActive);
                      print(updateTimer.isActive);
                    }
                    // if (isDataCollecting) {
                    //   isDataCollecting = false;
                    //   rsrpData.clear();
                    //   rsrqData.clear();
                    //   rssiData.clear();
                    //   setState(() {
                    //     _buttonText = Text('Restart');
                    //     _buttonIcon = Icon(Icons.play_arrow);
                    //   });
                    // } else if (!isDataCollecting) {
                    //   isDataCollecting = true;
                    //   signalDataStringList.clear();
                    //   startTime = DateTime.now();
                    //   // endTime = startTime.add(Duration(seconds: 60));
                    //   setState(() {
                    //     _buttonText = Text('Stop');
                    //     _buttonIcon = Icon(Icons.stop);
                    //     Timer.periodic(Duration(seconds: 1), (timer) async {
                    //       if (!isDataCollecting) {
                    //         // isDataCollecting이 false일 경우 타이머 정지 (반복 정지)
                    //         timer.cancel();
                    //       } else {
                    //         // 1초마다 _getSignalStrength 호출
                    //         await _getSignalStrength();
                    //         // 데이터 소스를 다시 생성하여 SfDataGrid 새로 작성
                    //         signalDataStringSource = SignalDataStringSource(
                    //             signalDataStringList: signalDataStringList);
                    //       }
                    //     });
                    //   });
                    // }
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class SignalDataStringSource extends DataGridSource {
  SignalDataStringSource(
      {required List<Map<DateTime, String>> signalDataStringList}) {
    _signalDataStringList = signalDataStringList.map<DataGridRow>((data) {
      DateTime time = data.keys.first;
      String rsrpDataGridValue = data.values.first.split(',')[0];
      String rsrqDataGridValue = data.values.first.split(',')[1];
      String rssiDataGridValue = data.values.first.split(',')[2];

      String timeInSeconds =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(data.keys.first);

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'time', value: timeInSeconds),
        DataGridCell<String>(columnName: 'rsrp', value: rsrpDataGridValue),
        DataGridCell<String>(columnName: 'rsrq', value: rsrqDataGridValue),
        DataGridCell<String>(columnName: 'rsrp', value: rssiDataGridValue),
      ]);
    }).toList();
  }

  List<DataGridRow> _signalDataStringList = [];

  @override
  List<DataGridRow> get rows => _signalDataStringList;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }
}
