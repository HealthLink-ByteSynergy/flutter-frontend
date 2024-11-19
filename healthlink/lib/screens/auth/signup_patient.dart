import 'package:flutter/material.dart';
import 'package:healthlink/Service/auth_service.dart'; // Import your AuthMethods class
import 'package:healthlink/utils/colors.dart'; // Import your color utils file
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/screens/auth/login.dart';

class PatientSignupScreen extends StatefulWidget {
  const PatientSignupScreen({Key? key}) : super(key: key);

  @override
  State<PatientSignupScreen> createState() => _PatientSignupScreenState();
}

class _PatientSignupScreenState extends State<PatientSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool isObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _numberController.dispose();
  }

  void signUp() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signing up the user, by using the AuthMethods class
    Map<String, dynamic> res = await AuthService().signUpUser(
        _usernameController.text,
        _emailController.text,
        _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res['success'] == true) {
      // navigate to the login screen after successful signup
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } else {
      print(res['message']);
      // Show error message if signup fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: color2,
            content: Text(
              res['message'],
              style: GoogleFonts.raleway(fontSize: 18, color: color1),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // Screen width
    final height = MediaQuery.of(context).size.height; // Screen height

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(minHeight: height),
          color: collaborateAppBarBgColor,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.2),
              Text('HealthLink',
                  style: GoogleFonts.raleway(
                    fontSize: width * 0.12,
                    color: collaborateAppBarTextColor,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: height * 0.1,
              ),
              TextField(
                controller: _usernameController,
                autocorrect: true,
                cursorColor: color4,
                maxLength: 18,
                style: const TextStyle(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                    color: color4,
                  ),
                  labelText: 'Your username',
                  labelStyle: const TextStyle(color: color4),
                  counterStyle: const TextStyle(color: color4),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextField(
                controller: _emailController,
                autocorrect: true,
                cursorColor: color4,
                style: const TextStyle(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: color4,
                  ),
                  labelText: 'Your email',
                  labelStyle: const TextStyle(color: color4),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: height * 0.025,
              ),
              TextField(
                controller: _numberController,
                autocorrect: false,
                cursorColor: color4,
                style: const TextStyle(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: color4,
                  ),
                  labelText: 'Your Phone Number',
                  labelStyle: const TextStyle(color: color4),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: height * 0.025,
              ),
              TextField(
                controller: _passwordController,
                obscureText: isObscured,
                autocorrect: false,
                cursorColor: color4,
                style: const TextStyle(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: color4,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: color4,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                  ),
                  labelText: 'Your password',
                  labelStyle: const TextStyle(color: color4),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: height * 0.075,
              ),
              InkWell(
                onTap: signUp,
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => HomeBody(jwtToken: 'ji')),
                // ),
                child: Container(
                  height: height * 0.065,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    color: Colors.black,
                  ),
                  child: !_isLoading
                      ? Text(
                          'Sign up',
                          style: GoogleFonts.ptSans(
                              fontWeight: FontWeight.bold, color: color4),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(color: color4),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: color4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
