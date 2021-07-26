import 'dart:async';
import 'dart:ffi';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> assertImage = new List<String>();
  List<String> soundType = new List<String>();

  @override
  Widget build(BuildContext context) {
    assertImage.add('assets/images/leaves.jpg');
    assertImage.add('assets/images/rain.jpg');
    assertImage.add('assets/images/strone.jpg');

    soundType.add('Leaves');
    soundType.add('Rain');
    soundType.add('Strone');

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(
            3,
            (index) {
              return new GestureDetector(
                onTap: () {
                  pressButton(index);
                },
                child: Container(
                  constraints: new BoxConstraints.expand(
                    height: 200.0,
                  ),
                  padding:
                      new EdgeInsets.only(left: 1.0, bottom: 0.0, right: 1.0),
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage(assertImage[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: new Icon(Icons.star),
                      ),
                      Container(
                          height: 35,
                          alignment: Alignment.center,
                          width: double.infinity,
                          color: Colors.black87,
                          child: new Text(soundType[index],
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0,
                              ))),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  pressButton(int index) {
    print("Index number is: $index");
    if (index == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PlayScreen(sound: "forest")));
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PlayScreen(sound: "rain")));
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PlayScreen(sound: "sunset")));
    }
  }
}

class PlayScreen extends StatefulWidget {
  final String sound;
  const PlayScreen({Key key, this.sound}) : super(key: key);
  @override
  _PlayRouteState createState() => _PlayRouteState();
}

class _PlayRouteState extends State<PlayScreen> {
  AudioPlayer player;
  AudioCache cache;
  bool initialPlay = true;
  bool playing;

  @override
  initState() {
    super.initState();
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  playPause(sound) {
    if (initialPlay) {
      cache.play('audio/$sound.mp3');
      playing = true;
      initialPlay = false;
    }
    return IconButton(
      color: Colors.white70,
      iconSize: 80.0,
      icon: playing
          ? Icon(Icons.pause_circle_filled)
          : Icon(Icons.play_circle_filled),
      onPressed: () {
        setState(() {
          if (playing) {
            playing = false;
            player.pause();
          } else {
            playing = true;
            player.resume();
          }
        });
      },
    );
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Background(sound: widget.sound),
            bottom: 0,
            left: 0,
            top: 0,
            right: 0,
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(backgroundColor: Colors.transparent, elevation: 0)),
          Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Center(
                  child: Column(children: [
                Text(
                  widget.sound.toUpperCase(),
                  style: new TextStyle(color: Colors.white, fontSize: 30),
                ),
                playPause(widget.sound)
              ]))),
        ],
      ),
    );
  }
}

class Background extends StatefulWidget {
  final String sound;
  const Background({Key key, this.sound}) : super(key: key);
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  Timer timer;
  bool _visible = false;

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  swap() {
    if (mounted) {
      setState(() {
        _visible = !_visible;
      });
    }
  }

  @override
  build(BuildContext context) {
    timer = Timer(Duration(seconds: 6), swap);
    return Stack(
      children: [
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/leaves.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedOpacity(
            child: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/rain.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            duration: Duration(seconds: 2),
            opacity: _visible ? 1.0 : 0.0)
      ],
    );
  }
}
