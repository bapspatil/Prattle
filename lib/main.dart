import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(PrattleApp());
}

const String _name = 'Bapusaheb Patil';

final ThemeData kIOSTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.lightBlue,
  primaryColor: Colors.lightBlue[700],
  fontFamily: 'IBM Plex Sans',
);

final ThemeData kDefaultTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.red[700],
  primaryColorDark: Colors.red[900],
  accentColor: Colors.amberAccent,
  fontFamily: 'IBM Plex Sans',
);

class PrattleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prattle',
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    decoration: InputDecoration.collapsed(hintText: 'Send a nice text'),
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS ?
                CupertinoButton(
                  child: Text("Send"),
                  onPressed: _isComposing
                      ? () =>  _handleSubmitted(_textController.text)
                      : null,) :
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null),
              )
            ],
          )
      )
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
          duration: Duration(milliseconds: 500),
          vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prattle',
          style: TextStyle(fontFamily: 'Playfair Display'),
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0, color: Colors.white30,),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ?
          BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white30),
            ),
          )
            :
          null),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
