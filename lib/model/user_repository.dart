import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<String> signInWithO365() async {
    _status = Status.Authenticating;
    notifyListeners();

    final Config config = new Config(
    "7cbac582-454f-462e-b992-5642da630bbf",
    "12492267-1ded-40b8-bfef-7e6164d57d02",
    "openid profile offline_access",
    "https://login.live.com/oauth20_desktop.srf",
    );

    final AadOAuth oauth = AadOAuth(config);

    try {
      await oauth.login();
      String accessToken = await oauth.getAccessToken();
      print("Logged in successfully, your access token: $accessToken");
       _status = Status.Unauthenticated;
       notifyListeners();
      return accessToken;
    } catch (e) {
      print('Error $e');
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
