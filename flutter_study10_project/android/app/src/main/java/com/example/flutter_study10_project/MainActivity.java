package com.example.flutter_study10_project;

import androidx.annotation.NonNull;

import android.telephony.CellInfo;
import android.telephony.CellInfoLte;
import android.telephony.CellSignalStrengthLte;
import android.telephony.SignalStrength;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;

import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.List;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.flutter_study10_project/telephony";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getSignalStrength")) {
                                getSignalStrength(result);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
    private void getSignalStrength(MethodChannel.Result result) {
        // getSystemService() : 안드로이드 앱에서 시스템 서비스를 얻을 때 사용
        //- TELEPHONY_SERVICE : 통신 관련 정보
        TelephonyManager telephonyManager = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);

        // getAllCellInfo() : 시스템의 모든 정보 가져옴
        List<CellInfo> cellInfoList = telephonyManager.getAllCellInfo();

        if (cellInfoList != null) {
            for (CellInfo cellInfo : cellInfoList) {
                if (cellInfo instanceof CellInfoLte) {
                    CellInfoLte cellInfoLte = (CellInfoLte) cellInfo;
                    // LTE 신호 세기
                    CellSignalStrengthLte signalStrengthLte = cellInfoLte.getCellSignalStrength();

                    int rsrp = signalStrengthLte.getRsrp();
                    int rsrq = signalStrengthLte.getRsrq();
                    int rssi = signalStrengthLte.getRssi();
                    int sinr = signalStrengthLte.getRssnr();

                    Log.i("SignalStrength", "[RSRP: " + rsrp + "dBm] [RSRQ: " + rsrq + "dBm] [RSSI: " + rssi + "dB] [SINR: " + sinr + "]");

                    // 네이티브 코드 -> flutter로 결과 전송 (String)
                    result.success(rsrp + "," + rsrq + "," + rssi);
                    return;
                }
            }
        }
        // 네이티브 코드 -> flutter로 결과 전송 (String)
        // 에러 코드, 에러 메세지, 추가 정보
        result.error("NO_SIGNAL_INFO", "LTE 신호 정보를 가져올 수 없습니다", null);
    }
}







