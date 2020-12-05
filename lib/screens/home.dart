import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learning_aid/components/button.dart';
import 'package:learning_aid/components/helper.dart';
import 'package:learning_aid/screens/add_game.dart';
import 'package:learning_aid/screens/play.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {




  GlobalKey<ScaffoldState>globalKey = GlobalKey<ScaffoldState>();
  bool codeAllowed = false;
  String uniqueCode = "";
  String webGameCode = "";
  bool noGames = false;
  List<Widget>games = [];
  var data;
  @override
  void initState() {
    super.initState();
    getData().then((value) {
      data = value;
    });
    if(Helper.prefs == null){
      Future.delayed(Duration.zero, (){
        Navigator.pushReplacementNamed(context, "/");
      });
    }
    List<String>list1 = (Helper.prefs.getStringList("games"))??[];
    noGames = list1.length == 0 ? true : false;
    WidgetsBinding.instance.addPostFrameCallback((_){
      updateScreen();
    });

  }

  Future getData()async=>await Helper.getPublicGames();


  Future<void>getPrefs()async{
    Helper.prefs = await SharedPreferences.getInstance();
    if(Helper.prefs.getStringList("games")==null){
      await Helper.prefs.setStringList("games", []);
    }
  }

  void deleteGame(int gameId)async{
    bool delete = await Helper.genericOnWillPop(context, "Delete") ?? false;
    if(delete){
      List<String>gl=Helper.prefs.getStringList("games");
      gl.remove(gameId.toString());
      await Helper.prefs.setStringList("games", gl);
      await Helper.prefs.setStringList("words$gameId", null);
      await Helper.prefs.setStringList("meanings$gameId", null);
      await Helper.prefs.setStringList("title$gameId", null);
      await Helper.prefs.setStringList("subject$gameId", null);
      await Helper.prefs.setInt("percentage$gameId", null);
      await Helper.prefs.setBool("show_bottomsheet$gameId", null);
      updateScreen();
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    codeAllowed = false;
    uniqueCode = "";

  }


  void updateScreen(){
    List<String>gamesID = Helper.prefs.getStringList("games") ?? [];
    games = [];
    for(int i = 0; i<gamesID.length; i++){
      int id = int.parse(gamesID[i]);
      games.add(
          ListTile(
            leading: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${(Helper.prefs.getStringList("words$id")??[]).length}", style: Theme.of(context).textTheme.button,),
                Text("word${(Helper.prefs.getStringList("words$id")??[]).length==1 ? "" : "s"}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              ],
            ),
            title: Text(Helper.prefs.getString("title$id")??"Unnamed", style: Theme.of(context).textTheme.bodyText1,),
            subtitle: Text(Helper.prefs.getString("subject$id")??"No subject", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            trailing: IconButton(icon: Icon(Icons.share_sharp, color: Colors.black,), onPressed: ()async{
              await showModalBottomSheet(isScrollControlled: true, context: context, builder: (_)=>Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: StatefulBuilder(
                  builder:(BuildContext context, StateSetter setState)=> Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Create a unique Helper ID to continue.", textAlign: TextAlign.center,),
                      Row(
                        children: [
                          Icon(codeAllowed ? Icons.check : Icons.clear, color: codeAllowed ? Colors.green : Colors.red,),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                maxLength: 8,
                                keyboardType: TextInputType.number,
                                onChanged: (String val)async{

                                  setState(() {
                                    uniqueCode = val;
                                    codeAllowed = !data.containsKey(uniqueCode) && uniqueCode.trim().length>=3;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Button(
                        color: codeAllowed ? Colors.green : Colors.grey[400],
                        label: "Save",
                        onPressed: !codeAllowed ? null : ()async{
                          if(codeAllowed){

                            await Helper.addToPubGames(
                              id: uniqueCode,
                              title: Helper.prefs.getString("title$id") ?? "No name",
                              subject: Helper.prefs.getString("subject$id") ?? "No subject",
                              words: Helper.prefs.getStringList("words$id") ?? [],
                              meanings: Helper.prefs.getStringList("meanings$id") ?? [],
                              showBottomSheet: Helper.prefs.getBool("show_bottomsheet$id") ?? true,
                              percentage: Helper.prefs.getInt("percentage$id") ?? 55,

                            );
                            Navigator.pop(globalKey.currentContext);
                            data = await Helper.getPublicGames();
                            Helper.showInfoBottomSheet("Successfully added to cloud!", globalKey.currentContext);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ));

            },),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>Play(id:id)));
            },
            onLongPress: (){
              deleteGame(id);
            },
          )
      );
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.lightGreen, size: 45,),
        elevation: 0,
        backgroundColor: Colors.lightGreenAccent,
        onPressed: ()async{
          showModalBottomSheet(context: context, builder: (_)=>Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                color: Colors.green,
                icon: Icon(Icons.web_outlined),
                label: "Add from web",
                onPressed: ()async{
                  Navigator.pop(context);
                  await Future.delayed(Duration.zero);
                  await showModalBottomSheet(isScrollControlled: true, context: context, builder: (_)=>Padding(

                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Enter game code"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[600],
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              )
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (val){
                              setState(() {
                                webGameCode = val;
                              });
                            },
                          ),
                        ),
                        Button(
                          color: Colors.lightGreen,
                          icon: Icon(Icons.add),
                          label: "Add",
                          onPressed: ()async{
                            Map data = await Helper.getPublicGames();
                            if(!data.containsKey("$webGameCode")){
                              Navigator.pop(context);
                              Helper.showInfoBottomSheet("That game couldn't be found!", context);
                            }else{
                              Navigator.pop(context);
                              //Do something
                              int ind = 0;
                              for(String i in Helper.prefs.getStringList("games")??[]){
                                int n = int.parse(i);
                                if(n>ind){
                                  ind = n;
                                }
                              }
                              ind++;
                              List<String> words =  jsonDecode(data["$webGameCode"]["words"]).cast<String>().toList();
                              List<String> means =  jsonDecode(data["$webGameCode"]["meanings"]).cast<String>().toList();
                              List<String> indexes = Helper.prefs.getStringList("games") ?? [];
                              indexes.add("$ind");
                              await Helper.prefs.setStringList("games", indexes);
                              await Helper.prefs.setStringList("words$ind", words);
                              await Helper.prefs.setStringList("meanings$ind", means);
                              await Helper.prefs.setBool("show_bottomsheet$ind", data["$webGameCode"]["answer_confirmation"]);
                              await Helper.prefs.setInt("percentage$ind", data["$webGameCode"]["probability"]);
                              await Helper.prefs.setString("subject$ind", data["$webGameCode"]["subject"]);
                              await Helper.prefs.setString("title$ind", data["$webGameCode"]["title"]);
                              setState(() {
                                updateScreen();
                              });
                              Helper.showInfoBottomSheet("Succesfully downloaded ${data["$webGameCode"]["title"]}", context);
                            }
                          },
                        )
                      ],
                    ),
                  ));
                },
              ),
              Button(
                color: Colors.blueAccent,
                icon: Icon(Icons.add),
                label: "Create New",
                onPressed: ()async{
                  Navigator.pop(context);
                  bool shouldUpdate = await Navigator.push(context, MaterialPageRoute(builder: (_)=>AddGame())) ?? false;
                  if(shouldUpdate) {
                    setState(() {
                      updateScreen();
                    });
                  }
                },

              )
            ],
          ));

        }),

      appBar: AppBar(leading: IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: ()async{
        await Helper.prefs.clear();
      }), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent, title: Text("My Helpers", style: Theme.of(context).textTheme.headline1,),),
      body: SafeArea(
        child: noGames ? Center(child: Column(children: [
          Icon(Icons.architecture_rounded, size: 175,),
          SizedBox(height: 24,),
          Text("No games found. Create one!", style: Theme.of(context).textTheme.bodyText2,),
        ],),) :
            ListView(
              children: games,
            )
      ),
    );
  }
}
