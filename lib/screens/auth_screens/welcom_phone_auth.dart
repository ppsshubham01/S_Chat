import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_chat/res/components/round_button.dart';
import 'package:s_chat/screens/auth_screens/otp_screen.dart';
import 'package:s_chat/screens/home_screens/home_screens.dart';
import 'package:s_chat/screens/home_screens/setting_page.dart';

import 'login_screen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneController = TextEditingController();
  Rx<User?> savedUser = Rx<User?>(null);

  Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth auth0 = FirebaseAuth.instance;
    auth0.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth0.signInWithCredential(credential).then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingPage(user: value.user)));
        }).catchError((e) {
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                      verificationID: verificationId,
                    )));
        // // Update the UI - wait for the user to enter the SMS code
        // String smsCode = 'xxxx';
        // showDialog(context: context, barrierDismissible: false,builder: (context)=> AlertDialog(
        //   title:  const Text('Enter OTP code'),
        //   content: Column(
        //     children: [
        //       TextField(
        //         controller: _codeController,
        //       )
        //     ],
        //   ),
        //   actions: [
        //     RoundButton(title: 'submit', onPress: (){
        //       FirebaseAuth auth = FirebaseAuth.instance;
        //       smsCode   = _codeController.text.trim();
        //       AuthCredential credential0 = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        //
        //       auth.signInWithCredential(credential0).then((value) {
        //         Navigator.pushReplacement(context, MaterialPageRoute(
        //             builder: (context) => SettingPage(user: value.user)
        //         ));
        //       }).catchError((e){
        //         print(e);
        //       });
        //     })
        //   ],
        // ));
        //
        // // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);
        // await auth0.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print(verificationId);
        print("TimeOut");
      },
    );
  }

  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(credential);
      savedUser.value = user.user;

      print('user name: ${user.user?.displayName}');
      print('user email: ${user.user?.email}');
      print('savedUser.value: ${savedUser.value!}');
      // Once signed in, return the UserCredential
      // if(user.user != null){
      //   Get.to(HomeScreen());
      // }
      // return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google signin error $e');
    }
  }


  // List<String> googleScopes = <String>[
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ];
  //
  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   // Optional clientId
  //   // clientId: 'your-client_id.apps.googleusercontent.com',
  //   scopes: googleScopes,
  // );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Welcome Back Home\n it's Dad's Home..You've been missed!"),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      // borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey,
                    hintText: 'Enter Phone Number',
                  ),
                  controller: _phoneController,
                  // keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 5,
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       // borderSide: const BorderSide(color: Colors.grey),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       borderSide: const BorderSide(color: Colors.grey),
                //     ),
                //     filled: true,
                //     fillColor: Colors.grey,
                //     hintText: 'Enter Password',
                //   ),
                //   controller: _passController,
                // ),
                const SizedBox(
                  height: 10,
                ),
                RoundButton(
                  title: "Get OTP",
                  onPress: () async {
                    final mobile = _phoneController.text.trim();
                    await registerUser(mobile, context);
                    // Get.toNamed(RouteName.homeScreen);
                    Get.off(OtpScreen(
                      verificationID: '',
                    ));
                  },
                  width: 110,
                  height: 45,
                  textColor: Colors.white,
                  buttonColor: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 3,
                ),
                IconButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    icon: const Icon(
                      Icons.g_mobiledata_outlined,
                      size: 45,
                    )),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Not Member! Register",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: (){
                    Get.to(const LoginScreen());
                  },
                  child: const Text(
                    "Login Via Email",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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

// Future<UserCredential>
