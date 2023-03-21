import 'package:flutter/material.dart';
import 'main.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  bool checkedValue = false;
  //bool newValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 50.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _firstName = value.trim();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                hintText: 'Enter your first name',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _lastName = value.trim();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                hintText: 'Enter your last name',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _email = value.trim();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _password = value.trim();
                                });
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            CheckboxListTile(
                              title: Text(
                                  "I agree to the Terms of Service and Privacy Policy"),
                              value: checkedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue == true) {
                                    checkedValue = true;
                                  } else {
                                    checkedValue = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                //   dynamic result =
                                //       await _auth.signUpWithEmailAndPassword(
                                //           _email, _password);
                                //   if (result == null) {
                                //     print('Registration failed');
                                //   } else {
                                //     print('Registration successful');
                                //   }
                                // }
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: _email,
                                    password: _password,
                                  );
                                  print('Registration successful');
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              color: Color.fromARGB(255, 85, 197, 200),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 40),
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 3, left: 3),
                    //     child: MaterialButton(
                    //       minWidth: double.infinity,
                    //       height: 60,
                    //       onPressed: () {},
                    //       color: Color.fromARGB(255, 85, 197, 200),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(40)),
                    //       child: Text(
                    //         "Sign Up",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 16,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromARGB(255, 54, 55, 54)),
                          ),
                        ),
                        // Text(
                        //   "Login",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w600, fontSize: 18),
                        // ),
                      ],
                    )
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

// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final AuthService _auth = AuthService();
//   String _email = '';
//   String _password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 validator: (String? value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _email = value.trim();
//                   });
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   hintText: 'Enter your email',
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               TextFormField(
//                 validator: (String? value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _password = value.trim();
//                   });
//                 },
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     dynamic result = await _auth.signUpWithEmailAndPassword(
//                         _email, _password);
//                     if (result == null) {
//                       print('Registration failed');
//                     } else {
//                       print('Registration successful');
//                     }
//                   }
//                 },
//                 child: Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
