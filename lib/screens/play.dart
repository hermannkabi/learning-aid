import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_aid/components/button.dart';
import 'package:learning_aid/components/helper.dart';
import 'package:randomizer/randomizer.dart';

class Play extends StatefulWidget {

  final int id;
  Play({this.id});

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {


  Randomizer randomizer;
  int id;
  String toShow = "";
  String correctAns = "";
  int wordIndex;
  int shownPart;
  bool chipsShown = false;
  List<Widget>chips = [];
  Icon resultIcon = Icon(Icons.play_arrow, size: 150,);
  bool iconVisible = false;
  String nextLabel = "Next";
  bool bottomSheetShown = false;


  List<Widget> makeRandomAnswers(String correctAns){
    List allowed = [];
    for(var elem in shownPart == 0 ? Helper.prefs.getStringList("meanings$id") : Helper.prefs.getStringList("words$id")){
      allowed.add(elem);
    }
    allowed.remove(correctAns);
    List<Widget> items = [];
    items.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: InputChip(label: Text(correctAns), onPressed: () {
            setIcon(Icon(Icons.check, size: 150,), correctAns);
            setState(() {
              chipsShown = false;
            });
          },),
        )
    );

    for(int i = 0; i<2; i++){
      print(allowed);
      String randomWord = randomizer.getrandomelementfromlist(allowed);
      allowed.remove(randomWord);
      items.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: InputChip(label: Text(randomWord), onPressed: (){
            setIcon(Icon(Icons.close, size: 150,), "Correct: $correctAns");
            setState(() {
              chipsShown = false;
            });
          },),
        )
      );
    }

    items.shuffle();
    return items;
  }

  void setIcon(Icon icon, String ans){
    setState(() {
      resultIcon = icon;
      iconVisible = true;
      toShow = ans;
    });
  }


  @override
  void initState() {
    super.initState();
    randomizer = Randomizer();
    id = widget.id;
    wordsRemaining = Helper.prefs.getStringList("words$id") ?? [];
    meanRemaining = Helper.prefs.getStringList("meanings$id") ?? [];
    generateWord();
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  List<String>wordsRemaining = [];
  List<String>meanRemaining = [];


  void generateWord(){
    //This determines whether the word or meaning is shown
    //0 - word, 1 - meaning
    iconVisible = false;
    chipsShown = false;
    bottomSheetShown = false;

    wordIndex = null;
    shownPart = Random().nextInt(2);

    if((shownPart == 0 ? wordsRemaining : meanRemaining).length == 1){
      setState(() {
        nextLabel = "Finish";
      });
    }
    if((shownPart == 0 ? wordsRemaining : meanRemaining).length != 0){
      toShow = (shownPart == 0 ? wordsRemaining : meanRemaining)[Random().nextInt((shownPart == 0 ? wordsRemaining : meanRemaining).length)];
    }else{
      showModalBottomSheet(context: context, builder: (_)=>Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Well done!", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1,),
            SizedBox(height: 10,),
            Text("You finished your learning!", style: Theme.of(context).textTheme.bodyText1,),
            SizedBox(height: 15,),
            Button(color: Colors.green, label: "Finish", onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            })
          ],
        ),
      ));
      return;
    }

      for(int i = 0; i<wordsRemaining.length; i++){
        if(shownPart == 0 ? wordsRemaining[i]==toShow : meanRemaining[i]==toShow){
          setState(() {
            wordIndex = i;
          });
          correctAns = shownPart == 0 ? meanRemaining [wordIndex] : wordsRemaining[wordIndex];

        }
      }
      if(Helper.prefs.getStringList("words$id").length >= 3){
        chips = makeRandomAnswers(correctAns);
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop:()=>Helper.genericOnWillPop(context, "Exit this game"),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                child: Column(
                  children: [
                    Visibility(visible: iconVisible, child: resultIcon),
                    Text(toShow, style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center,),
                    Visibility(
                      visible: chipsShown,
                      child: Wrap(
                        children: chips,
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Visibility(
                visible: !iconVisible && !chipsShown && !bottomSheetShown,
                child: Row(
                  children: [
                    Expanded(child: Button(label: "I know", color: Colors.greenAccent, onPressed: ()async{
                      int rng = Random().nextInt(100) +1;
                      bool canContinue = false;

                      if(rng<=(Helper.prefs.getInt("percentage$id")??60) && (Helper.prefs.getBool("show_bottomsheet$id")??true)){
                        String submitted;
                        setState(() {
                          bottomSheetShown = true;
                        });
                        await showModalBottomSheet(isScrollControlled: true, context: context, builder: (_)=>Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("What's the correct answer?"),
                                TextField(onChanged: (val){
                                  submitted = val;
                                },),
                                Button(
                                  label: "Submit",
                                  color: Colors.blueAccent,
                                  onPressed: (){
                                    if(submitted==correctAns){
                                      setState(() {
                                        bottomSheetShown = false;
                                        canContinue = true;
                                        wordsRemaining.removeAt(wordIndex);
                                        meanRemaining.removeAt(wordIndex);
                                      });
                                    }else{
                                      canContinue = true;
                                      setIcon(Icon(Icons.close, size: 150, ), "Correct: $correctAns");
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ));
                      }
                      if(canContinue || rng >60 || (Helper.prefs.getBool("show_bottomsheet$id")??true) == false){
                        setState(() {
                          iconVisible = true;
                        });
                        setIcon(Icon(Icons.check, size: 150,), correctAns);
                        wordsRemaining.removeAt(wordIndex);
                        meanRemaining.removeAt(wordIndex);

                      }
                    },)),
                    Expanded(child: Button(label: "I don't know", color: Colors.grey[500], onPressed: (){
                      if(Helper.prefs.getStringList("words$id").length >= 3){
                        setState(() {
                          chipsShown = true;
                        });
                      }else{
                        setState(() {
                          iconVisible = true;
                        });
                        setIcon(Icon(Icons.close, size: 150,), "Correct: $correctAns");
                      }
                    },)),
                  ],
                ),
              ),
              Visibility(
                visible: iconVisible,
                child: Button(label: nextLabel, color: Colors.lightBlue, onPressed: (){
                  generateWord();
                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
