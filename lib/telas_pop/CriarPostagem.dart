import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Postagem.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CriarPostagem extends StatefulWidget {
  @override
  _CriarPostagemState createState() => _CriarPostagemState();
}

class _CriarPostagemState extends State<CriarPostagem> {
  //Atributos Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Atributos
  TextEditingController _controllerTexto = TextEditingController();
  Paleta paleta = Paleta();
  Postagem postagem = Postagem();
  final _picker = ImagePicker();
  File _imagem;

  String _iduser;
  String _nomeuser;
  String _imageuser;
  String _texto;
  String _urlImage;
  String _horario;

  String _urlImagemRecuperada = null;

  Future _recuperarImagem(bool daCamera) async {
    PickedFile imagemSelecionada;
    if (daCamera) {
      _picker.getImage(source: ImageSource.camera);
      // _uploadImage();
    } else {
      _picker.getImage(source: ImageSource.gallery);
      // _uploadImage();
    }

    final File file = File(imagemSelecionada.path);

    setState(() {
      _imagem = file;
    });
  }

  Future _uploadImage() async {
    //Instancia do Storage
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    //Refernciar Arquivo
    firebase_storage.Reference pastaRaiz = storage.ref();

    firebase_storage.Reference arquivos = pastaRaiz
        .child("previewPost")
        .child(_iduser)
        .child("postagemPreview.jpg");

    //Fazer Upload da imagem
    firebase_storage.UploadTask task = arquivos.putFile(_imagem);

    //Controlar progresso da tarefa de Upload
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot storageEvent) {
      if (storageEvent.state == firebase_storage.TaskState.running) {
        setState(() {});
      } else if (storageEvent.state == firebase_storage.TaskState.success) {
        setState(() {});
      }
    });

    //Recuperando a URL da imagem
    String url = await (await task).ref.getDownloadURL();
    print("URL: " + url.toString());

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  recuperarDadosUser() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    setState(() {
      _iduser = snapshot["userid"];
      _nomeuser = snapshot["nome"];
      _imageuser = snapshot["urlimage"];
    });
  }

  @override
  void initState() {
    recuperarDadosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar postagem"),
        iconTheme: IconThemeData(color: paleta.royalBlue),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: paleta.grey850,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            child: _imageuser == ""
                                ? CircularProgressIndicator()
                                : ClipOval(child: Image.network(_imageuser)),
                            radius: 20,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              _nomeuser,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Divider(color: paleta.royalBlue),
                    ),
                    TextField(
                      minLines: 3,
                      maxLines: 10,
                      maxLength: 300,
                      controller: _controllerTexto,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Digite aqui",
                        labelStyle: TextStyle(color: Colors.grey),
                        counterStyle: TextStyle(color: Colors.white),
                        //Borda externa
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: paleta.grey900,
                        image: _urlImagemRecuperada == null
                            ? DecorationImage(
                                image: NetworkImage(
                                    "https://hiperjoias.com.br/wp-content/plugins/gutentor/assets/img/default-image.jpg"),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: NetworkImage(_urlImagemRecuperada),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                              child: Text("Camera"),
                              onPressed: () {
                                _recuperarImagem(true);
                              }),
                          RaisedButton(
                              child: Text("Galeria"),
                              onPressed: () {
                                _recuperarImagem(false);
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Divider(color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Padding(
                  child: RaisedButton(
                      color: paleta.royalBlue,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Publicar",
                        style: TextStyle(fontSize: 16),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        _uploadImage();
                      }),
                  padding: EdgeInsets.all(20))
            ],
          ),
        ),
      ),
    );
  }
}
