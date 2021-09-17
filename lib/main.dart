import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> lista = ["direita","esquerda","cima","baixo"];
  String estadodaaplicao= "baixo";
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  double size=50.0;
  double x= 0;
  double y = 100.0;
  var gravity=1;
  var ticker;



  @override
  void initState() {
    super.initState();
     ticker= Ticker((now){
       setState(() {
         x=x;
         y=y;
       });
     });
     ticker.start();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords.split(" ")[0];
      switch(_lastWords){
        case 'baixo':
          estadodaaplicao="baixo";
          break;
        case 'cima':
          estadodaaplicao="cima";
          break;
        case 'direita':
          estadodaaplicao="direita";
          break;
        case 'esquerda':
          estadodaaplicao="esquerda";
          break;
        default:
          estadodaaplicao="baixo";
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    switch(estadodaaplicao){
      case 'baixo':
        if(y< (MediaQuery.of(context).size.height - size)){
          y+=gravity;
        }
        break;
      case 'cima':
        if(y > size){
          y-=gravity;
        }
        break;
      case 'direita':
        if(x < (MediaQuery.of(context).size.width-size)){
          print(x);
          print(MediaQuery.of(context).size.width - size);
          x+=gravity;
        }
        break;
      case 'esquerda':
        if(x > size){
          x-=gravity;
        }
        break;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
                child: Animateste()
            ),
            RaisedButton(onPressed:()=>{

            },
              child: Text("Mude o texto apertando ak"),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? '$_lastWords'
                  // If listening isn't active but could be tell the user
                  // how to start it, otherwise indicate that speech
                  // recognition is not yet ready or not supported on
                  // the target device
                      : _speechEnabled
                      ? 'Tap the microphone to start listening...'
                      : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        // If not yet listening for speech start, otherwise stop
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  Widget Animateste(){
    return  Transform.translate(offset:Offset(x,y),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color:Colors.red,
          ),
          width: size,
          height:size,
        ),
      );
  }
}