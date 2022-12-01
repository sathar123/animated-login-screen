import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var  email = 'abcd@gmail.com';
  var pass = 'password';
  bool hidepass = true;
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailCon = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  TextEditingController passCon = TextEditingController();

  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

   SMIInput<bool>? trigSucess;
   SMIInput<bool>? trigFail;
void check(){
  if(emailCon.text == email && passCon.text == pass){
    trigSucess?.change(true);
  }else{
    trigFail?.change(true);
  }
}
  void showpassfn() {
    setState(() {

      hidepass = !hidepass;
      if(hidepass){
        isHandsUp?.change(true);
      }
      else
      {
        isHandsUp?.change(false);
      }
    });

  }

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passFocusNode.addListener(passFocus);
    super.initState();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passFocus() {
    isHandsUp?.change(passFocusNode.hasFocus);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passFocusNode.removeListener(passFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFD6E2EA),
        body: Center(
          child: Column(
            children: [
              Container(
                height: 250,
                width: 300,
                child: RiveAnimation.asset(
                  'assets/animated-login-screen.riv',
                  fit: BoxFit.cover,
                  stateMachines: ['Login Machine'],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                        artboard, 'Login Machine');
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller?.findInput('isChecking');
                    numLook = controller?.findInput('numLook');
                    isHandsUp = controller?.findInput('isHandsUp');
                     trigSucess = controller?.findInput('trigSucess');
                     trigFail = controller?.findInput('trigFail');
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  onChanged: (value) {
                    numLook?.change(value.length.toDouble()*2);
                  },
                  focusNode: emailFocusNode,
                  controller: emailCon,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  obscureText: hidepass,
                  focusNode: passFocusNode,
                  controller: passCon,
                  decoration: InputDecoration(
                      suffixIcon: hidepass
                          ? IconButton(
                              onPressed: () {
                                showpassfn();
                              },
                              icon: Icon(Icons.visibility_off,color: Colors.grey,))
                          : IconButton(
                              onPressed: () {
                                showpassfn();
                              },
                              icon: Icon(Icons.visibility,color: Colors.grey,)),

                      hintText: 'Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(500, 40)
                ),
                onPressed: () { check();}, child: Text('Login')))

            ],
          ),
        ),
      ),
    );
  }
}
