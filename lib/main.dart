import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'add_item.dart';
import 'db_operation.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  bool IsLoadingFinished=false;
  bool IsThereAnyCheklist=false;
  DbOperation db=new DbOperation();
  List defaultS;
  List<IconData> icopns=[Icons.cake,Icons.four_k,Icons.four_k,Icons.four_k,Icons.four_k,Icons.four_k];
  List<PickerItem> icopns2=[PickerItem(text: Icon(Icons.cake)),PickerItem(text: Icon(Icons.business)),
    PickerItem(text: Icon(Icons.local_grocery_store)),PickerItem(text: Icon(Icons.music_note)),
    PickerItem(text: Icon(Icons.trip_origin)),PickerItem(text: Icon(Icons.schedule)),
    PickerItem(text: Icon(Icons.access_alarm)),PickerItem(text: Icon(Icons.account_balance)),
    PickerItem(text: Icon(Icons.face)),PickerItem(text: Icon(Icons.add_circle_outline)),
    PickerItem(text: Icon(Icons.add_a_photo)),PickerItem(text: Icon(Icons.access_time)),
    PickerItem(text: Icon(Icons.adjust)),PickerItem(text: Icon(Icons.close)),];

  void initState(){
    super.initState();
    Timer(Duration(seconds: 1),(){
      db.openDb().then((onValue1)async{
        db.dogs(onValue1).then((onValue3){
          IsLoadingFinished=true;
          setState((){});
          if(onValue3!=null && onValue3.length>0){
            IsThereAnyCheklist=true;
            setState((){});
            defaultS=onValue3;
            print(defaultS);
            print(DateTime.parse(defaultS[0].time).minute);
          }
        });
      });
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Asosiy ekran",),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (context) => AddItemAdd(update: false,));
              Navigator.pushReplacement(context, route);
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePageAdd(title: "Add item",)),
              );*/
            },
          ),IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              final List<DateTime> picked = await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: new DateTime.now(),
                  initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
                  firstDate: new DateTime(2018),
                  lastDate: new DateTime(2022)
              );
              if (picked != null && picked.length == 2) {
                onSearchDate(picked);
              }
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: IsLoadingFinished ?
        IsThereAnyCheklist?
        ListView.separated(
          padding: const EdgeInsets.all(3),
          itemCount: defaultS.length,
          itemBuilder: (BuildContext context, int index) {
            return  GestureDetector(
                onTap: (){},
                child:  ListTile(
                  leading: icopns2[defaultS[index].iconNumber].text,
                  title: Text(defaultS[index].name,
                    style: TextStyle(fontSize: 23),
                  ),
                  //subtitle: Text("There are "),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Colors.lightBlue,
                          size: 35.0,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black26,
                              size: 19.0,
                            ),
                            onPressed: (){
                              Route route = MaterialPageRoute(builder: (context) => AddItemAdd(
                                  titleName:defaultS[index].name,update: true,titlenameitem: defaultS[index].texts,
                                  id:defaultS[index].id ,time:defaultS[index].time,Remindsa: defaultS[index].completed));
                              Navigator.pushReplacement(context, route);
                            }
                        )
                      ]),
                )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ):
        Text("None" ,style: TextStyle(fontSize: 23),):
        new CircularProgressIndicator(),
      ),
    );
  }
  Future onSearchDate(var query)async{
     IsLoadingFinished=false;
     IsThereAnyCheklist=false;
     setState((){});
     List<dynamic> data=new List<dynamic>();
    db.openDb().then((onValue1)async{
      db.dogs(onValue1).then((onValue3){
        IsLoadingFinished=true;
        setState((){});
        if(onValue3!=null && onValue3.length>0){
          //    print(DateTime.parse(defaultS[0].time).minute);
          for(int i=0;i<onValue3.length;i++){
            var parsedDate = DateTime.parse(onValue3[i].time.toString());
            if(parsedDate.isAfter(query[0]) && parsedDate.isBefore(query[1])){
              data.add(onValue3[i]);
              IsThereAnyCheklist=true;
            }else{
              print('no');
            }
          }
          defaultS=data;
          setState((){});
        }
      });
    });

  }
}

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Asosiy Ekran'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initState()  {
    super.initState();

    initNotification();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.separated(
            padding: const EdgeInsets.all(3),
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: (){},
                child: ListTile(
                  // leading: icopns2[defaultS[index].iconNumber].text,
                  title: Text("Axe",
                    style: TextStyle(fontSize: 23),
                  ),
                  //subtitle: Text("There are "),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Colors.lightBlue,
                          size: 35.0,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black26,
                              size: 19.0,
                            ),
                            onPressed: (){
                         //     Route route = MaterialPageRoute(builder: (context) => MyHomePage2(title: defaultS[index].texts,));
                          //    Navigator.pushReplacement(context, route);
                            }
                        )
                      ]),
                )
              );
            } ,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: 23)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
   showDialog(
     context:context,
     builder: (BuildContext context)=>new CupertinoAlertDialog(
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
     )
   );
  }
  Future DisplayNotifications(String title,String body,DateTime dateTime,int Id) async {
    var scheduledNotificationDateTime = dateTime;
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
    /*   const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');*/
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
}
*/