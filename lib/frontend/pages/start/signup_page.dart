import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_sync/frontend/widgets/snak_bar.dart';
import 'package:gym_sync/utils/debug/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final uid = userCredential.user?.uid;

      // ✅ Save UID and logged-in status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefKeys.uid, uid ?? '');
      await prefs.setBool(SharedPrefKeys.isLoggedIn, true);

      AppSnackBar.showSuccess("Signed in with Google successfully!");
      Get.offAllNamed(
        '/personalDetails',
      ); // clear page stack and push /personalDetails
    } catch (e) {
      AppSnackBar.showError("Google Sign-In failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2C3639),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffDCD7C9)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xff2C3639),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffDCD7C9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join GYM SYNC and start tracking your fitness journey",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 16,
                    color: const Color(0xffDCD7C9).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),

                // Google Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 30,
                      color: Color(0xff2C3639),
                    ),
                    label: const Text(
                      "CONTINUE WITH GOOGLE",
                      style: TextStyle(
                        color: Color(0xff2C3639),
                        fontFamily: "Nunito",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _signInWithGoogle(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffDCD7C9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Terms and Conditions
                Text(
                  "By signing up, you agree to our Terms of Service and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffDCD7C9).withOpacity(0.7),
                    fontFamily: "Nunito",
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 32),

                // Already have account option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: const Color(0xffDCD7C9).withOpacity(0.7),
                        fontFamily: "Nunito",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xffDCD7C9),
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
