import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_aid/components/button.dart';
import 'package:learning_aid/components/circle_button.dart';
import 'package:learning_aid/components/helper.dart';
import 'package:learning_aid/components/square_button.dart';
import 'package:learning_aid/components/text_field_row.dart';

class AddGame extends StatefulWidget {
  @override
  _AddGameState createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {

  List<Widget> words = [];
  TextEditingController nameCon = TextEditingController();
  TextEditingController subjCon = TextEditingController();
  String newWord;
  String newMeaning;
  int newIndex;
  List<Widget>children = [];
  bool switchDisabled = false;
  bool switchVal = true;
  int percentage = 60;





  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    nameCon.dispose();
  }

  deleteWord(int at)async{
    List<String>wl = Helper.prefs.getStringList("words$newIndex");
    List<String>ml = Helper.prefs.getStringList("meanings$newIndex");
    wl.removeAt(at);
    ml.removeAt(at);
    await Helper.prefs.setStringList("words$newIndex", wl);
    await Helper.prefs.setStringList("meanings$newIndex", ml);
    updateScreen();
    setState(() {
    });

  }


  void updateScreen(){
    if(newIndex!=null){
      List<String>words = Helper.prefs.getStringList("words$newIndex");
      List<String>meanings = Helper.prefs.getStringList("meanings$newIndex");
      if(words.length==meanings.length){
        children = [];
        for(int i = 0; i<words.length; i++){
          String word = words[i];
          String meaning = meanings[i];
          children.add(
            ListTile(
              title: Text(word),
              subtitle: Text(meaning),
              onLongPress: ()async{
                bool choice = await showModalBottomSheet(context: context, builder: (_)=>Container(
                  child: Button(color: Colors.red[400], label: "Confirm deletion", onPressed: (){
                    Navigator.pop(context, true);
                  },),
                )) ?? false;
                choice ?deleteWord(i) : print("Avoided deleting word");
              },
            )
          );
        }
      }else{print("Words are not the same as meanings");}

    }
  }


  Future<bool> onWillPop()async{
    bool choice = await showModalBottomSheet(context: context, builder: (_)=>Container(child: Button(color: Colors.red[400], label: "Exit without saving", onPressed: ()async{
      if(newIndex!=null){
        await Helper.prefs.setStringList("words$newIndex", null);
        await Helper.prefs.setStringList("meanings$newIndex", null);
      }
      Navigator.pop(context, true);
    },),))?? false;



    return choice;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Add A Helper", style: Theme.of(context).textTheme.headline1,), elevation: 0, centerTitle: true, backgroundColor: Colors.transparent, automaticallyImplyLeading: false,),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Column(
            children: [
              TextFieldRow(controller: nameCon, label: "Helper name", horizontalPadding: 8,),
              TextFieldRow(controller: subjCon, label: "Subject", horizontalPadding: 8,),
              Expanded(
                child: ListView(
                  children: children,
                ),
              ),
              Button(icon: Icon(Icons.add, size: 30,), label: "Add A Word", color: Colors.lightBlueAccent, onPressed: ()async{
                await showModalBottomSheet(isScrollControlled: true, context: context, builder: (_)=>Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          TextField(onChanged: (val){newWord=val;}, style: Theme.of(context).textTheme.headline1, decoration: InputDecoration(hintText: "The word is..."),),
                          TextField(onChanged: (val){newMeaning=val;}, style: Theme.of(context).textTheme.headline1, decoration: InputDecoration(hintText: "Which means..."),),
                          Button(label: "Save", color: Colors.lightGreen, onPressed: ()async{
                            if(newWord!=null && newMeaning!=null){
                              List<String>gl = Helper.prefs.getStringList("games");
                              if(gl==null){
                                gl = [];
                                await Helper.prefs.setStringList("games", gl);
                              }
                              List<int>gamesList = gl.map(int.parse).toList();
                              int greatest = -1;
                              for(int i in gamesList){
                                if(i>greatest){
                                  greatest = i;
                                }
                              }
                              greatest++;
                              int newGameId = greatest;
                              newIndex = newGameId;
                              print(newGameId);
                              List<String>list = Helper.prefs.getStringList("words$newGameId")??[];
                              list.add(newWord);
                              await Helper.prefs.setStringList("words$newGameId", list);
                              List<String>mean = Helper.prefs.getStringList("meanings$newGameId")??[];
                              mean.add(newMeaning);
                              await Helper.prefs.setStringList("meanings$newGameId", mean);


                              print(Helper.prefs.getStringList("words$newGameId"));
                              print(Helper.prefs.getStringList("meanings$newGameId"));
                              print("${Helper.prefs.getStringList("games")}!!!");
                              updateScreen();
                              Navigator.pop(context);


                            }
                          },),


                        ],
                      ),
                    ),
                  ),
                ),);
              },),
              Row(
                children: [
                  Expanded(
                    child: Button(label: "Save", color: Colors.lightGreen, onPressed: ()async{
                      // await Helper.prefs.clear();
                      if(nameCon.text.trim() == ""){
                        Helper.showInfoBottomSheet("No name: Add a name to this game to continue", context);
                      }else if(newIndex==null){
                        Helper.showInfoBottomSheet("No words: Add words to this game to continue", context);
                      }
                      else{
                        List<String>list1 = Helper.prefs.getStringList("games");
                        list1.add("$newIndex");
                        await Helper.prefs.setStringList("games", list1);
                        await Helper.prefs.setString("title$newIndex", nameCon.text);
                        subjCon.text.trim()!="" ? await Helper.prefs.setString("subject$newIndex", subjCon.text) : print("No subj");
                        Navigator.pop(context, true);
                      }
                    },),
                  ),
                  SquareButton(
                    icon: Icon(Icons.settings),
                    color: Colors.grey[500],
                    length: 60,
                    onPressed: (){
                      showModalBottomSheet(context: context, builder: (_)=>StatefulBuilder(
                        builder:(BuildContext context, StateSetter setState)=> Container(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  SwitchListTile(value: switchVal, onChanged: switchDisabled ? null : (val){
                                    setState(() {
                                      switchVal = val;
                                    });
                                  }, title: Text("Sometimes ask confirmation that you know the answer", style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),),
                                    subtitle: Text(switchVal ? "Your test will sometimes ask you to write the correct answer" : "You will not have to confirm that you know the answer in this test", style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15, color: Colors.grey),),
                                  ),
                                  ListTile(
                                    title: Text("The probability of confirming if you know the answer", style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                                    subtitle: Text(switchVal ? "$percentage%" : "0%", style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15, color: Colors.grey, ), textAlign: TextAlign.center,),
                                    leading: CircleButton(
                                      icon: Icon(Icons.remove, color: Colors.white,),
                                      color: switchVal ? Colors.blueAccent : Colors.grey,
                                      onPressed: switchVal ? (){
                                        setState((){
                                          percentage >= 10 ? percentage-=5: print("Can't");
                                        });
                                      } : null,
                                    ),
                                    trailing: CircleButton(
                                      icon: Icon(Icons.add, color: Colors.white),
                                      color: switchVal ? Colors.blueAccent : Colors.grey,
                                      onPressed: switchVal ? (){
                                        setState((){
                                          percentage <= 95 ? percentage += 5: print("Can't");
                                        });
                                      } : null,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Button(label: "Done", color: Colors.green, onPressed: ()async{
                                await Helper.prefs.setBool("show_bottomsheet$newIndex", switchVal);
                                await Helper.prefs.setInt("probability$newIndex", percentage);
                                Navigator.pop(context);
                              },)
                            ],
                          ),
                        ),
                      ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


