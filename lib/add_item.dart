import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db_operation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class AddItemAdd extends StatefulWidget {
  AddItemAdd({Key key, this.titleName, this.update, this.titlenameitem, this.id, this.time, this.Remindsa}) : super(key: key);

  final String titleName;
  final bool update;

  String titlenameitem;
  final int id;
  String time;
  final int Remindsa;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddItemAdd> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid;
  var initializationSettingsIOS  ;
  var initializationSettings ;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  DbOperation db=new DbOperation();
  int iconNumber=0;
  TextEditingController myControllerName =  TextEditingController();
  TextEditingController myControllertexts = TextEditingController();
  bool not=false;
  bool not2=false;
  String datetimed= "0000-00-00 00:00:00.000";
  List<PickerItem> icopns=[PickerItem(text: Icon(Icons.cake)),PickerItem(text: Icon(Icons.business)),
    PickerItem(text: Icon(Icons.local_grocery_store)),PickerItem(text: Icon(Icons.music_note)),
    PickerItem(text: Icon(Icons.trip_origin)),PickerItem(text: Icon(Icons.schedule)),
    PickerItem(text: Icon(Icons.access_alarm)),PickerItem(text: Icon(Icons.account_balance)),
    PickerItem(text: Icon(Icons.face)),PickerItem(text: Icon(Icons.add_circle_outline)),
    PickerItem(text: Icon(Icons.add_a_photo)),PickerItem(text: Icon(Icons.access_time)),
    PickerItem(text: Icon(Icons.adjust)),PickerItem(text: Icon(Icons.close)),];

  void initState(){
    super.initState();
    initNotification();

    //DisplayNotifications();

    if(widget.update){
      if(widget.Remindsa==0){
        not2=false;
      }else{
        not2=true;
      }
      setState((){});
    }
  }
  Future<void> initNotification() async {
    flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
   // DisplayNotifications("123","123123",DateTime.now(),2);
  }
  Future DisplayNotifications(String title,String body,DateTime dateTime,int Id) async {
    var scheduledNotificationDateTime =dateTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      Id, title, body,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context)=>MyHomePage()),
    ).then((ghf){
      return null;
    });
  }
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void onDone(){
    Route route = MaterialPageRoute(builder: (context) =>  MyHomePage());
    Navigator.pushReplacement(context, route);
    db.openDb().then((onValue1){

      if(widget.update){
        if(myControllerName.text.length>0){
          widget.titlenameitem=myControllerName.text;
        }
        var fido = new Dog(
          id:widget.id,
          name: widget.titleName,
          texts: widget.titlenameitem,
          time: widget.time,
          completed: not ? 1 : 0,
          iconNumber: iconNumber,
        );
        db.updateDog(fido, onValue1).then((sdf){
          db.ItemSelectNot(onValue1).then((onvalu4) async {
            if(onvalu4!=null && onvalu4.length>0){
              await flutterLocalNotificationsPlugin.cancelAll().then((df){
                for(int k=0;k<onvalu4.length;k++){
                  print(DateTime.parse(onvalu4[k].time).isAfter(DateTime.now()).toString() + onvalu4[k].completed.toString());
                  if(DateTime.parse(onvalu4[k].time).isAfter(DateTime.now()) && onvalu4[k].completed==1){
                    DisplayNotifications(onvalu4[k].name,onvalu4[k].texts,DateTime.parse(onvalu4[k].time),onvalu4[k].id);
                  }
                }
              });
            }
          });
        });
      }else{
        var fido = new Dog(
          name: myControllerName.text,
          texts:  myControllertexts.text,
          time: datetimed,
          completed: not ? 1 : 0,
          iconNumber: iconNumber,
        );
        db.insertDog(fido,onValue1).then((asd){
          db.ItemSelectNot(onValue1).then((onvalu4) async {
            if(onvalu4!=null && onvalu4.length>0){
              await flutterLocalNotificationsPlugin.cancelAll().then((df){
                for(int k=0;k<onvalu4.length;k++){
                  print(DateTime.parse(onvalu4[k].time).isAfter(DateTime.now()).toString() + onvalu4[k].completed.toString());
                  if(DateTime.parse(onvalu4[k].time).isAfter(DateTime.now()) && onvalu4[k].completed==1){
                    DisplayNotifications(onvalu4[k].name,onvalu4[k].texts,DateTime.parse(onvalu4[k].time),onvalu4[k].id);
                  }

                }
              });
            }
          });
        });
      }
    });
  }
  void onDelete(){
    Route route = MaterialPageRoute(builder: (context) => MyHomePage());
    Navigator.pushReplacement(context, route);

    db.openDb().then((onValue1) async {
      if(widget.update){
        await flutterLocalNotificationsPlugin.cancel(widget.id);
        db.deleteDog(widget.id, onValue1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (context) =>  MyHomePage());
            Navigator.pushReplacement(context, route);
          },
        ),
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Add item",),
        actions: <Widget>[
          Column(
              children: widget.update ? <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 33,
                  onPressed: ()=>onDelete(),
                ),
              ]:<Widget>[]
          ),
          IconButton(
            icon: Icon(Icons.done),
            iconSize: 33,
            onPressed: ()=>onDone(),
          ),
        ],
      ),
      body: Center(
        child:Padding(
          padding: const EdgeInsets.all(11.0),
          child: ListView(
            // padding: const EdgeInsets.all(8),
            children: <Widget>[

              Column(
                  children:<Widget>[
                    Container(
                      height: 30,
                      //   color: Colors.white30,
                      //child: const Center(child: Text('Entry A')),
                    ),
                    TextField(
                      controller: myControllertexts,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: widget.update ? widget.titleName: 'Name ',
                      ),
                    ),
                  ]
              ),
              Container(
                height: 30,
                color: Colors.white30,
                //  child: const Center(child: Text('Entry C')),
              ),
              TextField(
                controller: myControllerName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: widget.update ? widget.titlenameitem: ' long Name ',
                ),
              ),
              Container(
                height: 30,
                color: Colors.white30,
                //  child: const Center(child: Text('Entry C')),
              ),
              SwitchListTile(
                title: const Text('Remind me'),
                value: widget.update? not2:not,
                onChanged: (bool value) { setState(() {not = value;not2=value;}); },
                secondary: const Icon(Icons.notifications_active),
              ),
              Container(
                height: 30,
                color: Colors.white30,
                //  child: const Center(child: Text('Entry C')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: widget.update ? widget.time.substring(0,16) :datetimed.substring(0,16),
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black45,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {},
                    ),
                  ),
                  RaisedButton(
                    color: Colors.black45,
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          onChanged: (date) {
                            //   print('change $date');
                          },
                          onConfirm: (date) {
                            //   print('confirm '+date.toString());
                            datetimed=date.toString();
                            widget.time=datetimed;
                            setState(() {});
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.en);
                    },
                    textColor: Colors.white,
                    child: Center(
                      child: Text('Select time'),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween   ,
                children: <Widget>[
                  icopns[iconNumber].text,
                  RaisedButton(
                    color: Colors.black45,
                    onPressed: () {
                      return new Picker(
                          adapter: PickerDataAdapter(data:icopns),
                          title: new Text("Select Icon"),
                          onConfirm: (Picker picker, List value) {
                               print(value[0]);
                            iconNumber=value[0];
                            setState(() {});
                          }
                      ).show(_scaffoldKey.currentState);
                    },
                    textColor: Colors.white,
                    child: Center(
                      child: Text('Add an Icon'),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ) ,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}