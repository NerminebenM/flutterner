import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID:
            1441951493, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            '408ff644f740e3435da1adb48e8af9f63599e926eb3d471522668bb63bc89d1b', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: '112',
        userName: 'achref',
        callID: callID,
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
