import 'package:flutter/material.dart';

void main() {
  runApp(PrattleApp());
}

class PrattleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prattle',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'IBM Plex Sans',
        primaryColor: Colors.red[700],
        primaryColorDark: Colors.red[900],
        accentColor: Colors.amberAccent,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
          child: Row(
            children: [
              Flexible(
                  child: TextFormField(
                    controller: _textController,
                    onFieldSubmitted: _handleSubmitted,
                    decoration: InputDecoration.collapsed(hintText: 'Send a text'),
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)),
              )
            ],
          )
      )
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prattle',
          style: TextStyle(fontFamily: 'Playfair Display'),
        ),
      ),
      body: _buildTextComposer(),
    );
  }
}
