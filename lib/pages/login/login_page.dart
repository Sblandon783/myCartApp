import 'package:flutter/material.dart';
import 'package:soccer/pages/login/widgets/custom_card_3%20copy.dart';
import 'package:soccer/tabs_page.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../user_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _heightProfile = 300.0;
  final _future = Supabase.instance.client
      .from('_user')
      .select<List<Map<String, dynamic>>>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserPreferences _prefs = UserPreferences();
  late ValueNotifier<bool> _remembermeNotifier;
  @override
  void initState() {
    _usernameController.text = _prefs.userName;
    _remembermeNotifier = ValueNotifier(_prefs.isRememberme);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _generateContent(),
        bottomNavigationBar: Container(
          color: Colors.blue.shade200,
          height: 50.0,
          child: const Text(
            "Created by Sblandon",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15, height: 2.5),
          ),
        ),
      ),
    );
  }

  Widget _generateContent() => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _generateBackground(),
          _generateData(),
          const CustomCicularImage(
            image: 'assets/online-store.png',
            padding: EdgeInsets.only(top: 130.0),
          )
        ],
      );

  Widget _generateData() => Positioned(
        top: _heightProfile - 100,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(
                top: 10, left: 10, right: 10.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const Center(
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                TextField(
                  controller: _usernameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                _generateRememberme(),
                Center(
                    child: ElevatedButton(
                        onPressed: _login, child: const Text("Start session")))
              ],
            ),
          ),
        ),
      );

  Widget _generateRememberme() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: _remembermeNotifier,
            builder: (context, count, child) => Checkbox(
                value: _remembermeNotifier.value,
                onChanged: (value) =>
                    _remembermeNotifier.value = !_remembermeNotifier.value),
          ),
          const Text("Rememberme")
        ],
      );

  Widget _generateBackground() => Align(
        alignment: AlignmentDirectional.topCenter,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              stops: const [
                0.01,
                0.1,
                0.4,
                0.5,
                0.6,
                0.8,
                0.9,
              ],
              colors: [
                Colors.purple,
                Colors.purple.shade600,
                Colors.blue.shade600,
                Colors.blue.shade500,
                Colors.blue.shade400,
                Colors.blue.shade300,
                Colors.blue.shade200,
              ],
            ),
            //borderRadius: BorderRadius.circular(20.0),
          ),
          width: double.infinity,
          height: double.infinity,
        ),
      );

  void _login() async {
    final List<dynamic> response =
        await Supabase.instance.client.rpc('get_login', params: {
      '_email': _usernameController.text,
      '_password': _passwordController.text,
    });

    if (response.isNotEmpty) {
      _prefs.userId = response.first["id"];
      successfulAlert();
    } else {
      unSuccessfulAlert();
    }
  }

  void successfulAlert() {
    _prefs.isLogin = true;
    _prefs.userName = _remembermeNotifier.value ? _usernameController.text : '';
    _prefs.isRememberme = _remembermeNotifier.value;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          final route =
              MaterialPageRoute(builder: (context) => const TabsPage());
          Navigator.push(context, route);
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Welcome ${_usernameController.text}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void unSuccessfulAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(
            const Duration(seconds: 3), () => Navigator.pop(context));
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.close_outlined,
                color: Colors.red,
                size: 40.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Correo o contraseña incorrecta',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
