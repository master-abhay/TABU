import 'dart:io';

import 'package:firestore_tutorial/constant.dart';
import 'package:firestore_tutorial/models/user_profile.dart';
import 'package:firestore_tutorial/services/alert_services.dart';
import 'package:firestore_tutorial/services/auth_services.dart';
import 'package:firestore_tutorial/services/database_services.dart';
import 'package:firestore_tutorial/services/media_services.dart';
import 'package:firestore_tutorial/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/storage_services.dart';
import '../widgets/Custom_Button.dart';
import '../widgets/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormGlobalKey = GlobalKey();

  String? email, password, name;

  File? selectedImage;

  bool isLoading = false;

  final GetIt _getIt = GetIt.instance;
  late MediaServices _mediaServices;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;
  late AlertServices _alertServices;
  late StorageServices _storageServices;
  late DatabaseServices _databaseServices;

  @override
  void initState() {
    super.initState();
    _mediaServices = _getIt.get<MediaServices>();
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
    _storageServices = _getIt.get<StorageServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
  }

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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          _headerText(),
          if (!isLoading) _registerForm(),
          if (!isLoading) _createLoginLink(),
          if (isLoading)
            const Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            )),
        ],
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
              "Let's get going!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              "Register an account using the form below",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            )
          ],
        ));
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormGlobalKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profilePicSelector(),
            CustomFormField(
              hintText: "Name",
              obsecureText: false,
              onSaved: (value) {
                name = value;
              },
              validateRegExp: NAME_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            CustomFormField(
              hintText: "Email",
              obsecureText: false,
              onSaved: (value) {
                email = value;
              },
              validateRegExp: EMAIL_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            CustomFormField(
              hintText: "Password",
              obsecureText: false,
              onSaved: (value) {
                password = value;
              },
              validateRegExp: PASSWORD_VALIDATION_REGEX,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            CustomButton(
              isLoading: isLoading,
              text: "Register",
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });

                  if ((_registerFormGlobalKey.currentState?.validate() ??
                          false) &&
                      selectedImage != null) {
                    _registerFormGlobalKey.currentState!.save();

                    bool result =
                        await _authServices.register(email!, password!);
                    if (result) {
                      String? profilePictureDownloadUrl =
                          await _storageServices.uploadUserPfp(
                              file: selectedImage!,
                              uid: _authServices.user!.uid);

                      if (profilePictureDownloadUrl != null) {
                        _databaseServices.createUserProfile(
                            userProfile: UserProfile(
                                uid: _authServices.user!.uid,
                                name: name,
                                pfpURL: profilePictureDownloadUrl));
                      } else {
                        throw Exception(
                            "failed to upload user profile picture");
                      }
                      _alertServices.showToast(
                          text: "Account Created Succesfully :)",
                          icon: Icons.done_outlined);

                      _navigationServices.goBack();
                      _navigationServices.pushReplacementNamed("/home");
                    } else {
                      throw Exception("failed to register user! Please try again");
                    }

                    print(result);
                  }
                } catch (e) {
                  _alertServices.showToast(
                      text: e.toString(),
                      icon: Icons.error_outline);

                  print("printint the result in the catch block of the register page ...................$e");
                }
                setState(() {
                  isLoading = false;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _profilePicSelector() {
    return GestureDetector(
      onTap: () async {
        File? _file = await _mediaServices.getImageFromGallery();
        if (_file != null) {
          setState(() {
            selectedImage = _file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _createLoginLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Already have account! "),
        GestureDetector(
          onTap: () {
            _navigationServices.goBack();
          },
          child: const Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    ));
  }
}
