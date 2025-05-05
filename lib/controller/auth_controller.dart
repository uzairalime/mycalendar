import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:mycalender/controller/calender_controller.dart';
import 'package:mycalender/utils/app_constant.dart';
import '../helper/route_helper.dart';
import '../service/google_auth_client.dart';

enum LoginProvider { google, microsoft }

class AuthController extends GetxController{

  // Initialize the plugin
  final loginProvider = Rxn<LoginProvider>();
  String? accessTokenMicrosoft;

  void setGoogleUser(calendar.CalendarApi api, String email) {
    loginProvider.value = LoginProvider.google;
    calendarApi = api;
  }
  void setMicrosoftUser(String accessToken, String email) {
    loginProvider.value = LoginProvider.microsoft;
    accessTokenMicrosoft = accessToken;

  }

  final FlutterAppAuth _appAuth = FlutterAppAuth();

  // Future<String?> signInWithMicrosoft() async {
  //   try {
  //     // Configuration for Microsoft Identity Platform v2.0
  //     final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
  //       AuthorizationTokenRequest(
  //         AppConstant.clientIdMicrosoft, // Your Azure AD client ID
  //         AppConstant.redirectUrl, // Your registered redirect URI
  //         discoveryUrl: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/v2.0/.well-known/openid-configuration',
  //         scopes: ['openid', 'profile', 'email', 'User.Read', 'Calendars.ReadWrite', 'offline_access'],
  //         promptValues: ['login'],
  //         serviceConfiguration: AuthorizationServiceConfiguration(
  //           authorizationEndpoint: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/authorize',
  //           tokenEndpoint: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/token',
  //         ),
  //       ),
  //     );
  //     accessTokenMicrosoft = result?.accessToken;
  //     print('Microsoft Sign In Error: $result');
  //     if (result != null) {
  //       print("message${result.idToken}");
  //       print("message${result.authorizationAdditionalParameters}");
  //       print("message${result.scopes}");
  //       print("message${result.accessToken}");
  //       Get.toNamed(AppRoutes.home);
  //
  //
  //     }
  //   } catch (e) {
  //     print('Microsoft Sign In Error: $e');
  //     rethrow;
  //   }
  //   return null;
  // }
  ///----------------------------------------------------------
  Future<String?> signInWithMicrosoft() async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AppConstant.clientIdMicrosoft,
          AppConstant.redirectUrl,
          // discoveryUrl: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/v2.0/.well-known/openid-configuration',
          discoveryUrl: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/token',
          scopes: ['User.Read', 'Calendars.ReadWrite', 'offline_access'],
        ),
      );

      if (result != null && result.accessToken != null) {
        accessTokenMicrosoft = result.accessToken!;
        print(result.accessToken!.split('.').last.length);
        loginProvider.value = LoginProvider.microsoft;
        _isSignedIn = true;
        Get.toNamed(AppRoutes.getHomeRoute());
      }
    } catch (e) {
      print('Microsoft Sign-In Error: $e');
      rethrow;
    }
    return null;
  }


  Future<void> signOutMicrosoft() async {
    accessTokenMicrosoft = null;
    _isSignedIn = false;
    loginProvider.value = null;
    Get.find<CalController>().appointments.clear();
    Get.offAllNamed(AppRoutes.getLoginRoute());
  }

  ///----------------------------------------------------------
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

  @override
  void onInit() {
    super.onInit();

    // Google Sign-in init
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
        loginProvider.value = LoginProvider.google;
        Get.toNamed(AppRoutes.getHomeRoute());
      }
    });

    // Try Google silent login
    _googleSignIn.signInSilently().then((account) async {
      if (account != null) {
        _currentUser = account;
        await _initializeCalendar();
        _isSignedIn = true;
        loginProvider.value = LoginProvider.google;
        Get.toNamed(AppRoutes.getHomeRoute());
      }
    }).catchError((error) {
      print('Silent Google Sign-In Error: $error');
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
  void logoutDialog(BuildContext context) {
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
            onPressed: () {
              final provider = loginProvider.value;
              Navigator.pop(context);
              if (provider == LoginProvider.google) {
                signOutGoogle();
              } else if (provider == LoginProvider.microsoft) {
                signOutMicrosoft();
              }
            },
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