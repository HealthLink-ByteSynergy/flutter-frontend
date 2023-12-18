import 'package:flutter/material.dart';
import 'package:healthlink/Service/auth_service.dart'; // Import your AuthMethods class
import 'package:healthlink/models/Doctor.dart';
import 'package:healthlink/screens/Patient/home.dart';
import 'package:healthlink/utils/colors.dart'; // Import your color utils file
import 'package:google_fonts/google_fonts.dart';
import 'package:healthlink/screens/auth/login.dart';
import 'package:healthlink/utils/widgets/member_selection.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({Key? key}) : super(key: key);

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  List specializations = [];
  List _selectedspecializations = [];
  bool isObscured = true;
  bool _isLoading = false;
  Map<String, String> specializationsMap = {
    '1': 'General Medicine / Internal Medicine',
    '2': 'Cardiology',
    '3': 'Dermatology',
    '4': 'Endocrinology',
    '5': 'Gastroenterology',
    '6': 'Hematology',
    '7': 'Infectious Disease',
    '8': 'Nephrology',
    '9': 'Neurology',
    '10': 'Obstetrics and Gynecology',
    '11': 'Oncology',
    '12': 'Ophthalmology',
    '13': 'Orthopedics',
    '14': 'Otolaryngology (ENT - Ear, Nose, Throat)',
    '15': 'Pediatrics',
    '16': 'Psychiatry',
    '17': 'Pulmonology',
    '18': 'Rheumatology',
    '19': 'Urology',
    '20': 'General Surgery',
    '21': 'Plastic Surgery',
  };

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _licenseController.dispose();
    _usernameController.dispose();
    _numberController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void signUp() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // String userId = await AuthService().getUserId() as String;
    Doctor doctor = Doctor(
        doctorId: '',
        userId: '',
        docPatientId: '',
        specializations: _selectedspecializations,
        availability: 'not available',
        phoneNumber: _numberController.text,
        licenseNumber: _licenseController.text,
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text);

    // signing up the user, by using the AuthMethods class
    Map<String, dynamic> res = await AuthService().signUpDoctor(doctor);

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
          constraints: BoxConstraints(
            minHeight: height, // Set your minimum height here
          ),
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
                height: height * 0.011,
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
                controller: _licenseController,
                autocorrect: false,
                cursorColor: color4,
                style: const TextStyle(color: color4),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.numbers,
                    color: color4,
                  ),
                  labelText: 'Your Medical License Number',
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
                height: height * 0.025,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showMemberSelectionDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Choose your specializations',
                          style: GoogleFonts.raleway(
                              color: collaborateAppBarBgColor,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: specializations.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                specializations[index],
                                style: GoogleFonts.raleway(
                                    color: color4,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21),
                              ));
                        },
                      ),
                      for (int i = 0; i < _selectedspecializations.length; i++)
                        Row(
                          children: [
                            SizedBox(width: width * 0.1),
                            Expanded(
                              child: Text(_selectedspecializations[i],
                                  style: GoogleFonts.raleway(
                                      color: color4,
                                      fontSize: width * 0.06,
                                      fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeMember(i),
                            ),
                            SizedBox(width: width * 0.1),
                          ],
                        ),
                    ]),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              InkWell(
                onTap: signUp,
                // onTap: () => Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const HomeBody(),
                //   ),
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
                height: height * 0.01,
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
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

  void removeMember(int index) {
    setState(() {
      _selectedspecializations.removeAt(index);
    });
  }

  //it shows all the users and we can select users to add
  void _showMemberSelectionDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MemberSelectionDialog(
          selectedSpecializations: _selectedspecializations,
          available: specializationsMap,
          displayMembers: specializationsMap,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedspecializations = _selectedspecializations;
      });
    }
  }
}
