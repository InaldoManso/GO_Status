import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Usuario.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //Atributos
  TextEditingController _controllerMensagem = TextEditingController();
  Usuario usuario = Usuario();
  Paleta paleta = Paleta();

  //Lsita de mensagens Exemplo
  List<String> listaMensagens = [
    "Salveoo",
    "Chora Boy",
    "HJUMMM",
    "to sabendo"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        child: ListView.builder(
            itemCount: listaMensagens.length,
            itemBuilder: (context, indice) {
              Alignment alinhamento = Alignment.centerRight;
              Color color = paleta.orange;
              double laguraContainer = MediaQuery.of(context).size.width * 0.8;

              if (indice % 2 == 0) {
                color = paleta.royalBlue;
                alinhamento = Alignment.centerLeft;
              }
              return Align(
                alignment: alinhamento,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: laguraContainer,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(listaMensagens[indice],
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              );
            }),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: Colors.transparent,
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
                      controller: _controllerMensagem,
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
                      icon: Icon(Icons.send_outlined),
                      onPressed: () {
                        _controllerMensagem.clear();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
