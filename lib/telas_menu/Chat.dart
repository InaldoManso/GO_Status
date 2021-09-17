import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Suas conversas"),
      ),
      bottomNavigationBar: Padding(
        //padding que acompanha o telclado
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: null,
                      maxLength: 300,
                      minLines: 1,
                      maxLines: 3,
                      style: TextStyle(fontSize: 19),
                      onChanged: (mensagem) {},
                      decoration: InputDecoration(
                        //Espaçamento interior
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                        hintText: "Digite uma mengem...",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.send_outlined), onPressed: () {}),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
