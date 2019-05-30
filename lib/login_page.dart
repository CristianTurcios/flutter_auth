import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerlogin/model/user_repository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  _LoginPageState2 createState2() => _LoginPageState2();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Onecampus By Laureate"),
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
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.red,
                  child: MaterialButton(
                    // onPressed: () async {
                    //   if (_formKey.currentState.validate()) {
                    //     if (!await user.signIn(
                    //         _email.text, _password.text))
                    //       _key.currentState.showSnackBar(SnackBar(
                    //         content: Text("Something is wrong"),
                    //       ));
                    //   }
                    // },
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new _LoginPageState2(email: _email.text)));
                      }
                    },
                    child: Text(
                      "Continue",
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    if (value.isEmpty)
      return 'Please Enter an Email';
    else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    // _password.dispose();
    super.dispose();
  }
}

class _LoginPageState2 extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _password;

  final String email;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  _LoginPageState2({Key key, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserRepository>(context);

    return MaterialApp(
      title: 'Onecampus By Laureate',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Onecampus By Laureate'),
        ),
        body: Container(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
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
                // user.status == Status.Authenticating
                //   ? Center(child: CircularProgressIndicator())
                //   :
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.red,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print('email: $email , password: $_password.text');
                          // if (!await user.signIn(
                          //     email, _password.text))
                          //   _key.currentState.showSnackBar(SnackBar(
                          //     content: Text("Something is wrong"),
                          //   ));
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
                // user.status == Status.Authenticating
                //   ? Center(child: CircularProgressIndicator())
                //   :
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                        child: MaterialButton(
                          onPressed: () async {
                            // if (!await user.signInWithGoogle())
                            //   _key.currentState.showSnackBar(SnackBar(
                            //     content: Text("Something is wrong"),
                            //   ));
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
