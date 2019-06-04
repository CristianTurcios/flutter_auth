import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerlogin/model/user_repository.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  static final Config config = new Config(
    "7cbac582-454f-462e-b992-5642da630bbf",
    "12492267-1ded-40b8-bfef-7e6164d57d02",
    "openid profile offline_access",
    "https://login.live.com/oauth20_desktop.srf",
  );
  final AadOAuth oauth = AadOAuth(config);

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _email,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter Email" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _password,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter Password" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder()),
                ),
              ),
              user.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (!await user.signIn(
                                  _email.text, _password.text))
                                _key.currentState.showSnackBar(SnackBar(
                                  content: Text("Something is wrong"),
                                ));
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              user.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                        child: MaterialButton(
                          onPressed: () async {
                            if (!await user.signInWithGoogle())
                              _key.currentState.showSnackBar(SnackBar(
                                content: Text("Something is wrong"),
                              ));
                          },
                          child: Text(
                            "Sign In With Google",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              user.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                        child: MaterialButton(
                          onPressed: () async {
                            // final String info = await user.signInWithO365();
                            // if (info == null ) logoutO365();
                            // else UserInfoPageMicrosoft(token: info);
                            await user.signInWithO365();
                            logoutO365();
                          },
                          child: Text(
                            "Sign In With Office 365",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
      new FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void logoutO365() async {
    await oauth.logout();
    showMessage("Logged out");
  }
}

class UserInfoPageMicrosoft extends StatelessWidget {
  final String token = '';

  const UserInfoPageMicrosoft({Key key, token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Token"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(token),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () => Provider.of<UserRepository>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}
