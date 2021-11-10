import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/general/tools/date_formatter.dart';
import 'package:go_status/general/helpers/color_pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/model/publication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PublicationCreator extends StatefulWidget {
  @override
  _PublicationCreatorState createState() => _PublicationCreatorState();
}

class _PublicationCreatorState extends State<PublicationCreator> {
  //Classes and Packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateFormatter dateFormatter = DateFormatter();
  FirebaseAuth auth = FirebaseAuth.instance;
  Publication postagem = Publication();
  ColorPallete paleta = ColorPallete();
  File _image;

  //Image attributes

  TextEditingController _controllerTexto = TextEditingController();
  final _picker = ImagePicker();

  String _urlImagRecovered = "";
  bool _uploadingImage = false;
  String _publicationTime;
  String _imageuser;
  String _urlImage;
  String _nameuser;
  String _message;
  String _iduser;

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
    _uploadImageOFC();
    Publication postagem = Publication();
    _message = _controllerTexto.text;

    if (_message.isNotEmpty) {
      postagem.idtime = dateFormatter.generateDateTimeIdentification();
      postagem.idpublication = "empty";
      postagem.iduser = _iduser;
      postagem.type = Publication.typeImage;
      postagem.nameuser = _nameuser;
      postagem.imageuser = _imageuser;
      postagem.message = _message;
      postagem.urlimage = _urlImagRecovered;
      postagem.timeshow = DateTime.now().toString();
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

  _publishPost(Publication postagem) async {
    await db
        .collection("publications")
        .add(postagem.toMap())
        .then((referenceId) {
      Map<String, dynamic> postingId = {"idpostagem": referenceId.id};
      db.collection("publications").doc(referenceId.id).update(postingId);
      Navigator.pop(context);
    });
  }

  _recoveringUserData() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    setState(() {
      _iduser = snapshot["userid"];
      _nameuser = snapshot["name"];
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
        iconTheme: IconThemeData(color: paleta.dodgerBlue),
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
                      child: Divider(color: paleta.dodgerBlue),
                    ),
                    TextField(
                      minLines: 3,
                      maxLines: 10,
                      maxLength: 300,
                      controller: _controllerTexto,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
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
                      child: Divider(color: paleta.dodgerBlue),
                    ),
                  ],
                ),
              ),
              Padding(
                  child: RaisedButton(
                      color: paleta.dodgerBlue,
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
