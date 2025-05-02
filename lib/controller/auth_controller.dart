import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:mycalender/controller/calender_controller.dart';
import 'package:mycalender/utils/app_constant.dart';
import '../helper/route_helper.dart';
import '../service/google_auth_client.dart';

class AuthController extends GetxController{

  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  final isMicrosoftLoggedIn = false.obs;
  final microsoftAccessToken = ''.obs;
  final microsoftRefreshToken = ''.obs;

  final String clientId = AppConstant.clientIdMicrosoft;
  // final String redirectUrl = 'com.example.mycalender://oauthredirect';
  // final String redirectUrl = 'msauth://com.example.mycalender/VzSiQcXRmi2kyjzcA%2BmYLEtbGVs%3D';
  final String redirectUrl = AppConstant.redirectUrl;
  final String tenantId = AppConstant.tencentIdMicrosoft;
  final List<String> scopes = [
    'openid',
    'profile',
    'offline_access',
    'Calendars.ReadWrite'
  ];

  Future<void> signInWithMicrosoft() async {
    try {
      // final result = await _appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(
      //     clientId,
      //     redirectUrl,
      //     discoveryUrl:
      //     'https://login.microsoftonline.com/$tenantId/v2.0/.well-known/openid-configuration',
      //     scopes: scopes,
      //   ),
      // );
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          discoveryUrl: 'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
          scopes: ['openid', 'profile', 'email', 'offline_access', 'Calendars.ReadWrite'],
        ),
      );


      if (result != null) {
        microsoftAccessToken.value = result.accessToken!;
        microsoftRefreshToken.value = result.refreshToken!;
        isMicrosoftLoggedIn.value = true;
      }
    } catch (e) {
      print('Microsoft login error: $e');
    }
  }

  Future<void> signOutMicrosoft() async {
    microsoftAccessToken.value = '';
    microsoftRefreshToken.value = '';
    isMicrosoftLoggedIn.value = false;
  }


  late GoogleSignIn _googleSignIn;
  late GoogleSignInAccount? _currentUser;
  late calendar.CalendarApi calendarApi;
  String _userName = "";
  String _profileUrl = "";

  String get getUserEmail => _currentUser?.email ?? '';
  bool _isSignedIn = false;
  String get getUserName => _userName;
  String get getProfileUrl => _profileUrl;
  bool get isSignedIn => _isSignedIn;

  // var isSignedIn = false.obs;

  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn(
      scopes: [
        calendar.CalendarApi.calendarScope,
      ],
    );

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      _currentUser = account;
      if (_currentUser != null) {
        await _initializeCalendar();
        _isSignedIn = true;
        Get.toNamed(AppRoutes.getHomeRoute());
      }
    });

    _googleSignIn.signInSilently().then((account) async {
      if (account != null) {
        _currentUser = account;
        await _initializeCalendar();
        _isSignedIn = true;
        Get.toNamed(AppRoutes.getHomeRoute()); // Redirect to home if signed in
      }
    }).catchError((error) {
      print('Silent Sign-In Error: $error');
    });
  }
  /// Google SignIn
  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      if (_currentUser != null) {
        _userName = _currentUser!.displayName ?? 'No Name';
        _profileUrl = _currentUser!.photoUrl ?? '';
        _isSignedIn = true;
        Get.toNamed(AppRoutes.getHomeRoute());
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }
  /// Google SignOut
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      _isSignedIn = false;
      Get.find<CalController>(). appointments.clear();
      Get.offAllNamed(AppRoutes.getLoginRoute());
    }catch(e){
      print('Google Sign-Out Error: $e');
    }
  }
  /// logout Dialog
  void logoutDialog(BuildContext context,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          TextButton(
            onPressed: () => Get.find<AuthController>().signOutGoogle(),
            child: Text("Logout"),
          ),

        ],
      ),
    );
  }
  ///
  Future<void> _initializeCalendar() async {
    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    calendarApi = calendar.CalendarApi(authenticateClient);
    _userName = _currentUser!.displayName ?? 'No Name';
    _profileUrl = _currentUser!.photoUrl ?? '';
  }

}