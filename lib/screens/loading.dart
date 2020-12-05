import 'package:flutter/material.dart';
import 'package:learning_aid/components/helper.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    Helper().getPrefs().whenComplete(() {
      if(Helper.prefs.getBool("first_time_seen")??false){
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(""),
              CircularProgressIndicator(backgroundColor: Colors.lightBlueAccent,),
              Text("LearningAid vPRE1.0", style: Theme.of(context).textTheme.bodyText2,)
            ],
          ),
        ),
      ),
    );
  }
}
