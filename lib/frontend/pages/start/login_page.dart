import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xff2C3639)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                // Logo
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xff3F4E4F),
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset("assets/images/app_icon.png"),
                  ),
                ),
                SizedBox(height: 30),
                // App Name
                Text(
                  "GYM SYNC",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffDCD7C9),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your Workout Partner",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 16,
                    color: Color(0xffDCD7C9).withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 50),
                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          color: Color(0xffDCD7C9),
                          fontFamily: "Nunito",
                        ),
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          hintStyle: TextStyle(
                            color: Color(0xffDCD7C9).withOpacity(0.5),
                            fontFamily: "Nunito",
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xffDCD7C9),
                          ),
                          filled: true,
                          fillColor: Color(0xff3F4E4F),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: TextStyle(
                          color: Color(0xffDCD7C9),
                          fontFamily: "Nunito",
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Color(0xffDCD7C9).withOpacity(0.5),
                            fontFamily: "Nunito",
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xffDCD7C9),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xffDCD7C9),
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xff3F4E4F),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xffDCD7C9),
                              fontFamily: "Nunito",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Login Button
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Implement login functionality
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffDCD7C9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Color(0xff2C3639),
                              fontFamily: "Nunito",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Register Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Color(0xffDCD7C9).withOpacity(0.7),
                              fontFamily: "Nunito",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to register page
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Color(0xffDCD7C9),
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Social Login Options
                      Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Color(0xffDCD7C9).withOpacity(0.7),
                          fontFamily: "Nunito",
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialLoginButton(
                            icon: Icons.g_mobiledata,
                            onPressed: () {},
                          ),
                          SizedBox(width: 24),
                          _socialLoginButton(
                            icon: Icons.facebook,
                            onPressed: () {},
                          ),
                          SizedBox(width: 24),
                          _socialLoginButton(
                            icon: Icons.apple,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xff3F4E4F),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 30, color: Color(0xffDCD7C9)),
        onPressed: onPressed,
      ),
    );
  }
}
