
import 'package:firestore_tutorial/services/alert_services.dart';
import 'package:firestore_tutorial/services/auth_services.dart';
import 'package:firestore_tutorial/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../constant.dart';
import '../widgets/Custom_Button.dart';
import '../widgets/custom_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  final GetIt _getIt = GetIt.instance;
  late AuthServices _authServices;
  late NavigationServices _navigationServices;
  late AlertServices _alertServices;

  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertServices = _getIt.get<AlertServices>();
  }

  String? email, password;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [_headerText(), _loginForm(), _createAnAccountLink()],
      ),
    ));
  }

  Widget _headerText() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: const Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Welcome Back!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              "Hello again, you've been missed",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            )
          ],
        ));
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              hintText: "Email",
              obsecureText: false,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              height: MediaQuery.sizeOf(context).height * 0.1,
              validateRegExp: EMAIL_VALIDATION_REGEX,
            ),
            CustomFormField(
                hintText: "Password",
                validateRegExp: PASSWORD_VALIDATION_REGEX,
                obsecureText: true,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                height: MediaQuery.sizeOf(context).height * 0.1),
            CustomButton(
              text: "Login",
              isLoading: isLoading,
              onPressed: () async {
                if (_loginFormKey.currentState?.validate() ?? false) {
                  _loginFormKey.currentState?.save();
                  print(email);
                  print(password);
                  setState(() {
                    isLoading = true;
                  });
                  bool result = await _authServices.login(email!, password!);
                  if (result == true) {
                    _alertServices.showToast(
                        text: "login Successful!", icon: Icons.done);
                    _navigationServices.pushReplacementNamed("/home");
                    setState(() {
                      isLoading = false;
                    });

                  } else {
                    setState((){
                      isLoading = false;
                    });

                    _alertServices.showToast(
                        text: "Failed to login! please try again",
                        icon: Icons.error);

                    print("false");

                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Don't have Account? "),
        GestureDetector(
          onTap: () {
            _navigationServices.pushNamed("/register");
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    ));
  }
}
