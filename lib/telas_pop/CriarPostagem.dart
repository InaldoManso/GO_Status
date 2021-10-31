import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/helper/DateFormatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_status/model/Postagem.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CriarPostagem extends StatefulWidget {
  @override
  _CriarPostagemState createState() => _CriarPostagemState();
}

class _CriarPostagemState extends State<CriarPostagem> {
  //Classes end Especial Attributes
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateFormatter dateFormatter = DateFormatter();
  FirebaseAuth auth = FirebaseAuth.instance;
  Postagem postagem = Postagem();
  Paleta paleta = Paleta();

  //Image attributes
  File _image;
  final _picker = ImagePicker();
  bool _uploadingImage = false;
  String _urlImagRecovered = "";

  //General attributes
  TextEditingController _controllerTexto = TextEditingController();
  String _iduser;
  String _nameuser;
  String _imageuser;
  String _message;
  String _urlImage;
  String _publicationTime;

  Future _selectLocalImage(String originImage) async {
    PickedFile imageSelected;

    switch (originImage) {
      case "camera":
        imageSelected = await _picker.getImage(source: ImageSource.camera);
        break;

      case "galeria":
        imageSelected = await _picker.getImage(source: ImageSource.gallery);
        break;
    }

    final File fileImageConvert = File(imageSelected.path);

    setState(() {
      _image = fileImageConvert;
      if (_image != null) {
        _uploadingImage = true;
        _uploadImagePreviw();
      }
    });
  }

  Future _uploadImagePreviw() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    // String imageId = Timestamp.now().toString();

    //Reference archive
    firebase_storage.Reference pastaRaiz = storage.ref();
    firebase_storage.Reference arquivos =
        pastaRaiz.child("previewPost").child(_iduser).child("preview.jpg");

    //Uploade image and lister progres: .UploadTask
    firebase_storage.UploadTask task = arquivos.putFile(_image);

    //Controller progress
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot storageEvent) {
      if (storageEvent.state == firebase_storage.TaskState.running) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (storageEvent.state == firebase_storage.TaskState.success) {
        setState(() {
          _uploadingImage = false;
        });
      }
    });

    //Recovering url ImagePreview
    task.then((firebase_storage.TaskSnapshot snapshot) {
      _recoveringUrlImage(snapshot);
    });
  }

  _recoveringUrlImage(firebase_storage.TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    //Retrieving url to display
    setState(() {
      _urlImagRecovered = url;
    });
  }

  _createPosting() {
    print("XXXXXXXXXXXXXXXXXXXX");
    _uploadImageOFC();
    Postagem postagem = Postagem();
    _message = _controllerTexto.text;
    print("GGGGG" + _message);

    if (_message.isNotEmpty) {
      print("ZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
      postagem.idtime = dateFormatter.generateDateTimeIdentification();
      postagem.idpostagem = _iduser;
      postagem.idtipo = "1";
      postagem.iduser = _iduser;
      postagem.nomeuser = _nameuser;
      postagem.imageuser = _imageuser;
      postagem.texto = _message;
      postagem.urlimage = _urlImagRecovered;
      postagem.horario = DateTime.now().toString();
      _publishPost(postagem);
    }
  }

  Future _uploadImageOFC() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    String imageId = dateFormatter.generateDateTimeIdentification().toString();

    //Reference archive
    firebase_storage.Reference pastaRaiz = storage.ref();
    firebase_storage.Reference arquivos =
        pastaRaiz.child("publicPost").child(_iduser).child("$imageId.jpg");

    //Uploade image and lister progres: .UploadTask
    firebase_storage.UploadTask task = arquivos.putFile(_image);

    //Controller progress
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot storageEvent) {
      if (storageEvent.state == firebase_storage.TaskState.running) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (storageEvent.state == firebase_storage.TaskState.success) {
        setState(() {
          _uploadingImage = false;
        });
      }
    });

    //Recovering url ImagePreview
    task.then((firebase_storage.TaskSnapshot snapshot) {
      _recoveringUrlImageOFC(snapshot);
    });
  }

  _recoveringUrlImageOFC(firebase_storage.TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    //Retrieving url to display
    setState(() {
      _urlImagRecovered = url;
    });
  }

  _publishPost(Postagem postagem) async {
    await db.collection("postagens").add(postagem.toMap()).then((referenceId) {
      Map<String, dynamic> postingId = {"idpostagem": referenceId.id};
      db.collection("postagens").doc(referenceId.id).update(postingId);
      Navigator.pop(context);
    });
  }

  _recoveringUserData() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    setState(() {
      _iduser = snapshot["userid"];
      _nameuser = snapshot["nome"];
      _imageuser = snapshot["urlimage"];
    });
  }

  @override
  void initState() {
    _recoveringUserData();
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
                              _nameuser,
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
                        image: _urlImagRecovered != ""
                            ? DecorationImage(
                                image: NetworkImage(_urlImagRecovered),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: NetworkImage(""),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: _uploadingImage
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                    child: Text("Camera",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      _selectLocalImage("camera");
                                    }),
                                FlatButton(
                                    child: Text("Galeria",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      _selectLocalImage("galeria");
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
                        if (_urlImagRecovered != "") {
                          _createPosting();
                        }
                      }),
                  padding: EdgeInsets.all(20))
            ],
          ),
        ),
      ),
    );
  }
}
