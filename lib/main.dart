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
  List<String> lista = ["direita", "esquerda"];
  String estadodaaplicao = "esquerda";
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  double size = 50.0;
  double x = 0;
  double y = 200;
  var gravity = 10;
  var ticker;

  @override
  void initState() {
    super.initState();
    ticker = Ticker((now) {
      setState(() {
        x = x;
        y = y;
      });
    });
    ticker.start();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords.split(" ")[0];
      switch (_lastWords) {
        case 'direita':
          estadodaaplicao = "direita";
          break;
        case 'esquerda':
          estadodaaplicao = "esquerda";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    verificaEstadoAplicacao();

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
                'Aplicação que utiliza sua voz :',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(child: Animateste()),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                onPressed: () => {
                  setState(() => {
                        if (estadodaaplicao == "esquerda")
                          {estadodaaplicao = "direita"}
                        else
                          {estadodaaplicao = "esquerda"}
                      })
                },
                child: Text(
                    "Mude a direção da bolinha apertando  aqui, ou fale 'esquerda' ou 'direita' no microfone "),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _speechToText.isListening
                      ? '$_lastWords'
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
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }

  void verificaEstadoAplicacao() {
    switch (estadodaaplicao) {
      case 'direita':
        if (x < (MediaQuery.of(context).size.width - size)) {
          print(x);
          print(MediaQuery.of(context).size.width - size);
          x += gravity;
        }
        break;
      case 'esquerda':
        if (x > 0) {
          x -= gravity;
        }
        break;
    }
  }

  Widget Animateste() {
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.red,
        ),
        width: size,
        height: size,
      ),
    );
  }
}
