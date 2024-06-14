import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _loginkey = GlobalKey<FormState>();
   final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Form(
              key: _loginkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login to your Account",
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
                      if (_loginkey.currentState!.validate()) {
                        UserCredential UserData = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailcontroller.text,
                                password: _passwordcontroller.text);

                                if(UserData!=null){
                                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                }
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
                          "Login",
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
                      Text("Don't have an account?",
                          style: ThemeData.textTheme.displaySmall),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("create now",
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
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
          ],
        ),
      ),
    );
  }
}
