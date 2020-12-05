import 'package:flutter/material.dart';
import 'package:learning_aid/components/button.dart';
import 'package:learning_aid/components/helper.dart';

class WelcomeScreen extends StatefulWidget {


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void setWelcomeSeen()async{
    await Helper.prefs.setBool("first_time_seen", true);
  }

  @override
  void initState() {
    super.initState();
    setWelcomeSeen();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(
                'Welcome to LearningAid!', style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 15,),
              Text(
                "Learning words, phrases or anything has never been easier.", style: Theme.of(context).textTheme.subtitle2,
              ),
              Spacer(),
              Button(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "/home");
                },
                color: Colors.lightBlue[300],
                label: "Let's go!",
              )
            ],
          ),
        ),
      ),
    );
  }
}
