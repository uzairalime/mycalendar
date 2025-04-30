import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:mycalender/controller/calender_controller.dart';
import '../helper/route_helper.dart';
import '../service/google_auth_client.dart';

class AuthController extends GetxController{
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