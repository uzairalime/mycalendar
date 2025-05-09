import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:msal_flutter/msal_flutter.dart';
import 'package:mycalender/controller/calender_controller.dart';
import 'package:mycalender/utils/app_constant.dart';
import '../helper/route_helper.dart';
import '../service/google_auth_client.dart';
import '../utils/app_constant.dart';

enum LoginProvider { google, microsoft }

class AuthController extends GetxController {
  // Initialize the plugin
  final loginProvider = Rxn<LoginProvider>();
  String? accessTokenMicrosoft;
  String? tokenTypeMicrosoft;
  AuthorizationTokenResponse? res;

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
  //   print("---------------------------signInWithMicrosoft---------------------");
  //   try {
  //     // Configuration for Microsoft Identity Platform v2.0
  //     final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
  //       AuthorizationTokenRequest(
  //         AppConstant.clientIdMicrosoft, // Your Azure AD client ID
  //         AppConstant.androidRedirectUrl, // Your registered redirect URI
  //         discoveryUrl: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/v2.0/.well-known/openid-configuration',
  //         scopes: ['openid', 'profile', 'email', 'User.Read', 'Calendars.ReadWrite', 'offline_access'],
  //         promptValues: ['login', 'admin_consent'],
  //         serviceConfiguration: AuthorizationServiceConfiguration(
  //           authorizationEndpoint: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/authorize',
  //           tokenEndpoint: 'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/token',
  //         ),
  //       ),
  //     );
  //     accessTokenMicrosoft = result?.accessToken;
  //     print('Microsoft Sign In Error: ${result}');
  //     if (result != null) {
  //       print("message${result.idToken}");
  //       print("message${result.authorizationAdditionalParameters}");
  //       print("message${result.scopes}");
  //       print("message${result.accessToken?.split('.')}");
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
  ///--------------------msal aad_oauth--------------------------------------
  // Future azureSignInApi(bool redirect) async {
  //   print("message");
  //
  //   final Config config = new Config(
  //     tenant: AppConstant.tencentIdMicrosoft,
  //     clientId: AppConstant.clientIdMicrosoft,
  //     scope: "openid profile offline_access Calendars.ReadWrite",
  //     // redirectUri is Optional as a default is calculated based on app type/web location
  //     redirectUri: "com.example.mycalender://oauthredirect",
  //     webUseRedirect: true, // default is false - on web only, forces a redirect flow instead of popup auth
  //     loader: Center(child: CircularProgressIndicator()),
  //     navigatorKey: Get.key,
  //   );
  //   final AadOAuth oauth = AadOAuth(config);
  //   config.webUseRedirect = redirect;
  //   final result = await oauth.login();
  //   // result.fold(error) {
  //   //   _showError("Error: $error");
  //   // };
  //   result.fold(
  //         (failure) => print(failure.toString()),
  //         (token) => print('Logged in successfully, your access token: $token'),
  //   );
  //       (result) async{
  //     print("Success: $result");
  //     // await fetchMicrosoftEvents(result.accessToken);
  //
  //   };
  // }
  ///--------------------msal app_auth--------------------------------------
  ///--------------------flutter_Appauth--------------------------------------

  Future<String?> signInWithMicrosoft() async {
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AppConstant.clientIdMicrosoft, AppConstant.redirectUrl,
          discoveryUrl:
              'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/v2.0/.well-known/openid-configuration',
          scopes: [
            'User.Read',
            'Calendars.ReadWrite',
            'offline_access',
            'openid',
            'profile',
            'email'
          ],
          // serviceConfiguration: AuthorizationServiceConfiguration(
          //     authorizationEndpoint:
          //         'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/token',
          //     tokenEndpoint:
          //         'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}/oauth2/v2.0/authorize')
        ),
      );
      // AuthorizationTokenResponse? res = result;
      if (result != null && result.accessToken != null) {
        accessTokenMicrosoft = result.accessToken!;
        tokenTypeMicrosoft = result.tokenType;

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

  /// ------------------------msal_flutter----------------
  late PublicClientApplication pca;

  Future<void> init() async {
    print("object------------------------------------");

    pca = await PublicClientApplication.createPublicClientApplication(
        AppConstant.clientIdMicrosoft,
        authority:
            'https://login.microsoftonline.com/${AppConstant.tencentIdMicrosoft}',
        androidRedirectUri:
            // 'msauth://com.example.mycalender/qhs5ObYu%2BoUk%2BYaa%2BMrF0WUplyQ%3D');
            'msauth://com.example.mycalender/qhs5ObYu%2BoUk%2BYaa%2BMrF0WUplyQ%3D');

    print("object------------------------------------$pca");
  }

  ///-------
  Future<String?> signInWithMicrosoftpca() async {
    try {
      final result = await pca.acquireToken([
        'User.Read',
        'Calendars.ReadWrite',
        'offline_access',
        'openid',
        'profile',
        'email'
      ]);
      print("result: $result");
      print("result: $accessTokenMicrosoft");
      return result;
    } on MsalException catch (e) {
      print('Authentication Error: $e');
      return null;
    }
  }

  ///-------------------------Microsoft SignOut-------------------------------
  /// signOutMicrosoft
  Future<void> signOutMicrosoft() async {
    accessTokenMicrosoft = null;
    _isSignedIn = false;
    loginProvider.value = null;
    Get.find<CalController>().appointments.clear();
    Get.offAllNamed(AppRoutes.getLoginRoute());
  }

  ///-------------------------SignIn firebase microsoft---------------------------------

  Future<void> signInWithMicrosoftFire() async {
    final provider = OAuthProvider('microsoft.com');
    provider.setCustomParameters({
      'tenant': '98fa2aed-e1be-477c-b8ba-59ea5ab8768d',
    });
    // final userCredential = await FirebaseAuth.instance.signInWithProvider(provider);

    // final microsoftProvider = MicrosoftAuthProvider()
    //   ..addScope('Calendars.ReadWrite')
    //   ..addScope('offline_access')
    //   ..setCustomParameters({
    //     'prompt': 'consent',
    //     'tenant': AppConstant.tencentIdMicrosoft,
    //   });

    try {
      // Sign in using Microsoft OAuth
      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);

      // Extract the access token
      final accessToken = userCredential.credential?.accessToken;

      if (accessToken != null) {
        // Log the access token
        print('Access Token: $accessToken');
      } else {
        print('No access token received');
      }
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.code} - ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  ///-------------------------Extra Function---------------------------------

  void printTokenInParts(String token) {
    int partLength = (token.length / 4).ceil();
    for (int i = 0; i < token.length; i += partLength) {
      int end = (i + partLength < token.length) ? i + partLength : token.length;
      print(token.substring(i, end));
    }
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // init(); // now it's safe to call async setup
    // });
    // Google Sign-in init
    _googleSignIn = GoogleSignIn(
      scopes: [
        calendar.CalendarApi.calendarScope,
      ],
    );
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
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
      Get.find<CalController>().appointments.clear();
      Get.offAllNamed(AppRoutes.getLoginRoute());
    } catch (e) {
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

  /// google calendar initializer
  Future<void> _initializeCalendar() async {
    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    calendarApi = calendar.CalendarApi(authenticateClient);
    _userName = _currentUser!.displayName ?? 'No Name';
    _profileUrl = _currentUser!.photoUrl ?? '';
  }
}
