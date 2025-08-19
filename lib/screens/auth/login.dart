import 'package:ecommerce_app2/constants/validators.dart';
import 'package:ecommerce_app2/root_screen.dart';
import 'package:ecommerce_app2/screens/auth/forget_pass.dart';
import 'package:ecommerce_app2/screens/auth/register.dart';
import 'package:ecommerce_app2/screens/loading_manager.dart';
import 'package:ecommerce_app2/utilities/app_methods.dart';
import 'package:ecommerce_app2/widgets/app_name_text.dart';
import 'package:ecommerce_app2/widgets/auth/google_btn.dart';
import 'package:ecommerce_app2/widgets/subtitle_text.dart';
import 'package:ecommerce_app2/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName='login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late bool isvalidate;
   bool absecureText=true;
   bool isloading=false;
   final auth=FirebaseAuth.instance;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Future<void> login() async {
    final isValid = formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {


      try {
        setState(() {
          isloading = true;
        });
        UserCredential userCredential =await auth.signInWithEmailAndPassword(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim(),
        );
        Fluttertoast.showToast(
            msg: "login successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
        if(!mounted)return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseAuthException catch (e) {
        AppMethods.showErrorDialog(
          context: context,
          function: () {},
          title: "an error has been occurred : ${e.message}",
        );
      }catch(e){
        AppMethods.showErrorDialog(
          context: context,
          function: () {},
          title: "an error has been occurred : $e",
        );
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  void initState() {
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingManager(
        isLoading: isloading,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    AppNameText(fontSize: 30),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TitleText(text: "Welcome back", fontSize: 20),
                    ),
                    SizedBox(height: 20),

                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(

                            controller: emailcontroller,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              return MyValidators.emailValidator(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(

                            controller: passwordcontroller,
                            focusNode: passwordFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: absecureText,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 20),

                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      absecureText=!absecureText;
                                    });
                                  },
                                  icon:Icon(absecureText?Icons.visibility_off:Icons.visibility,) ),
                              hintText: "Password",
                              prefixIcon: Icon(Icons.password),

                            ),
                            validator: (value) {
                              return MyValidators.passwordValidator(value);
                            },
                            onFieldSubmitted: (value) {
                              login();
                            },
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                              },
                              child: SubtitleText(
                                text: "Forgot Password?",
                                textDecoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(

                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),

                                  backgroundColor:Colors.blue,
                                ),
                                onPressed: ()async{
                                  login();

                                },
                                label: Text("Login",style: TextStyle(color: Colors.white),),
                                icon: Icon(IconlyBold.logout,color: Colors.white,)),
                          ),
                          SizedBox(height: 20),
                         SubtitleText(text: "or continue with".toUpperCase(),fontSize: 20,color: Colors.grey),
                          SizedBox(height: 20),
                          FittedBox(
                            child: Row(
                              children: [
                                GoogleButton(),
                                SizedBox(width: 10,),
                                ElevatedButton(

                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),

                                      backgroundColor:Colors.blue,
                                    ),
                                    onPressed: ()async{
                                      Navigator.pushNamed(context, RootScreen.routeName);

                                    },
                                    child: Text("guest",style: TextStyle(color: Colors.white,fontSize: 20),),
                                    ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            SubtitleText(
                              text: "Don't have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RegisterScreen.routeName);
                              },
                              child: SubtitleText(
                                text: "Sign Up",
                                textDecoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue,
                              ),
                            ),
                          ],)

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
