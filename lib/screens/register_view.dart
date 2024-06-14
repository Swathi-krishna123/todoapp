import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/usermodel.dart';
import 'package:todo_app/services/auth_services.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final _regkey = GlobalKey<FormState>();
  UserModel _userModel = UserModel();
  final AuthServices _authServices = AuthServices();
  bool _isLoading = false;
  void _register() async {
    setState(() {
      _isLoading = true;
    });
    _userModel = UserModel(
      name: _namecontroller.text,
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
      createdAt: DateTime.now(),
      status: 1,
    );
    try {
      await Future.delayed(Duration(seconds: 3));
      final userdata = await _authServices.RegisterUser(_userModel);
      if (userdata != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      List err = e.toString().split("]");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err[1])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Form(
              key: _regkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create an Account",
                    style: ThemeData.textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: ThemeData.textTheme.displaySmall,
                    controller: _emailcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter your email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "enter email",
                        hintStyle: ThemeData.textTheme.displaySmall),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: ThemeData.textTheme.displaySmall,
                    controller: _namecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter your Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "enter Name",
                        hintStyle: ThemeData.textTheme.displaySmall),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: ThemeData.textTheme.displaySmall,
                    controller: _passwordcontroller,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "password is mandatory!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "enter your password",
                        hintStyle: ThemeData.textTheme.displaySmall),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_regkey.currentState!.validate()) {
                        _register();
                        // UserCredential UserData = await FirebaseAuth.instance
                        //     .createUserWithEmailAndPassword(
                        //         email: _emailcontroller.text,
                        //         password: _passwordcontroller.text);
                        // if (UserData!= null) {
                        //   FirebaseFirestore.instance
                        //       .collection("users")
                        //       .doc(UserData.user!.uid)
                        //       .set({
                        //     "email": UserData.user!.email,
                        //     "name": _namecontroller.text,
                        //     "uid": UserData.user!.uid,
                        //     "createdAt": DateTime.now(),
                        //     "status": 1
                        //   }).then((value) => Navigator.pushNamedAndRemoveUntil(
                        //           context, '/home', (route) => false
                        //           ));

                        // }
                      }
                    },
                    child: Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "Create",
                          style: ThemeData.textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text("Already have an account?",
                          style: ThemeData.textTheme.displaySmall),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text("login",
                            style: TextStyle(
                                color: Color.fromARGB(255, 99, 233, 219),
                                fontSize: 18)),
                      )
                    ],
                  )
                ],
              ),
            ),
            Visibility(
                visible: _isLoading,
                child: Center(
                  child: CircularProgressIndicator(),
                ))
          ],
        ),
      ),
    );
  }
}
