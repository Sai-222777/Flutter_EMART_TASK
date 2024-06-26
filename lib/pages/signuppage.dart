import 'package:emart/components/my_text_field.dart';
import 'package:emart/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage ({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage > {

  final _auth = FirebaseAuth.instance;
  //final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confrimPasswordController = TextEditingController();

  void SignUp() async{
    if(emailController.text.isEmpty | passwordController.text.isEmpty)
    {
      return;
    }
    if(passwordController.text != confrimPasswordController.text)
    {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Passwords do not match!'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
        return ;
    }
    try {
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Icon(
                  Icons.shopping_bag,
                  size: 100,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 20.0,),
                const Text(
                    'Lets Shop!',
                    style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 25.0,),
                MyTextField(
                  controller: emailController, 
                  hintText: 'Email',
                  obscureText: false
                ),
                const SizedBox(height: 20.0,),
                MyTextField(
                  controller: passwordController, 
                  hintText: 'Password',
                  obscureText: true
                ),
                const SizedBox(height: 20.0,),
                MyTextField(
                  controller: confrimPasswordController, 
                  hintText: ' Confirm Password',
                  obscureText: true
                ),
                const SizedBox(height:20.0,),
                GestureDetector(
                  onTap: SignUp,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Already a User?'),
                      const SizedBox(width:5),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(),),);
                        },
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        )
        )
    );
  }
}