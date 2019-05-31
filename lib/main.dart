import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerlogin/login_page.dart';
import 'package:providerlogin/model/user_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return UserInfoPage(user: user.user);
          }
        },
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final FirebaseUser user;

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Info"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email),
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

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}


// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'AAD OAuth Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(title: 'AAD OAuth Home'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static final Config config = new Config("7cbac582-454f-462e-b992-5642da630bbf", "7d78c2b8-7374-4a64-af14-e9f66463011e", "openid profile offline_access", "https://login.live.com/oauth20_desktop.srf",);
//   final AadOAuth oauth = AadOAuth(config);

//   Widget build(BuildContext context) {
//     // adjust window size for browser login
//     var screenSize = MediaQuery.of(context).size;
//     var rectSize =  Rect.fromLTWH(0.0, 25.0, screenSize.width, screenSize.height - 25);
//     oauth.setWebViewScreenSize(rectSize);

//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text(
//               "AzureAD OAuth",
//               style: Theme.of(context).textTheme.headline,
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.launch),
//             title: Text('Login'),
//             onTap: () {
//               login();
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.delete),
//             title: Text('Logout'),
//             onTap: () {
//               logout();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void showError(dynamic ex) {
//     showMessage(ex.toString());
//   }

//   void showMessage(String text) {
//     var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
//       new FlatButton(
//           child: const Text("Ok"),
//           onPressed: () {
//             Navigator.pop(context);
//           })
//     ]);
//     showDialog(context: context, builder: (BuildContext context) => alert);
//   }

//   void login() async {
//     try {
//       await oauth.login();
//       String accessToken = await oauth.getAccessToken();
//       showMessage("Logged in successfully, your access token: $accessToken");
//     } catch (e) {
//       showError(e);
//     }
//   }

//   void logout() async {
//     await oauth.logout();
//     showMessage("Logged out");
//   }
// }