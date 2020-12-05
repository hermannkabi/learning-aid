import 'dart:convert';

import 'package:learning_aid/components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Helper{



  static void showInfoBottomSheet(String info, BuildContext context){
    showModalBottomSheet(context: context, builder: (_)=>Container(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(info??"", textAlign: TextAlign.center,),
            SizedBox(height: 12,),
            Button(color: Colors.green, onPressed: (){Navigator.pop(context);}, label: "OK",)
          ],
        ),
      ),

    ));
  }


  Future<void> getPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }
  static SharedPreferences prefs;


  static Future<bool>genericOnWillPop(BuildContext context, [String ending = ""])async{
    bool choice = await showModalBottomSheet(context: context, builder: (_)=>Container(child: Button(color: Colors.red[400], label: "$ending?", onPressed: ()async{

      Navigator.pop(context, true);
    },),))?? false;



    return choice;
  }

  static Future<void>addToPubGames({String title, String id, List<String> words, List<String> meanings, String subject, int percentage, bool showBottomSheet})async{

    final String gist = "8f72de4baa1a40ab2a633cd13d57b9b0";
    final String token = "***";

      Response answer = await get("https://api.github.com/gists/$gist", headers: {"user":token});
      Map data = jsonDecode(answer.body);
      String newsUrl = data["files"]["la-public-api.json"]["raw_url"];
      Response gistRes = await get(newsUrl);
      Map api = jsonDecode(gistRes.body);
      api["games"]["$id"] = {
        "title":"$title",
        "words":jsonEncode(words),
        "meanings":jsonEncode(meanings),
        "subject": "$subject",
        "probability": percentage,
        "answer_confirmation": showBottomSheet
      };

      print(jsonEncode(api));
      await patch("https://api.github.com/gists/$gist", body: jsonEncode({"description":"new", "files":{
        "la-public-api.json": {"content":"${jsonEncode(api)}"}

      }}),
        headers: {
          "Authorization":"token $token",
          "gist_id":"$gist",
        },
      );

  }


  static Future<Map>getPublicGames()async{
    final String gist = "8f72de4baa1a40ab2a633cd13d57b9b0";
    final String token = "***";

    Response answer = await get("https://api.github.com/gists/$gist", headers: {"user":token});
    Map data = jsonDecode(answer.body);
    String newsUrl = data["files"]["la-public-api.json"]["raw_url"];
    Response gistRes = await get(newsUrl);
    Map api = jsonDecode(gistRes.body);
    return api["games"];
  }

}
