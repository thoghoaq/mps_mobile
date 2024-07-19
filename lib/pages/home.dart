import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late InAppWebViewController inAppWebViewController;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permantly denied, we cannot request permissions.");
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            "Location permissions are denied (actual value: $permission).");
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    if (kDebugMode) {
      print(permission);
      print(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri("https://mps-client-ashen.vercel.app/")),
        onWebViewCreated: (controller) {
          inAppWebViewController = controller;
        },
        onGeolocationPermissionsShowPrompt: (controller, origin) async {
          return GeolocationPermissionShowPromptResponse(
              origin: origin, allow: true, retain: true);
        },
        initialSettings: InAppWebViewSettings(
          useWideViewPort: true,
          geolocationEnabled: true,
        ),
        onPermissionRequest: (controller, permissionRequest) async {
          return PermissionResponse(
            resources: permissionRequest.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
      ),
    ));
  }
}
