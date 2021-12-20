import 'package:go_status/features/timeline/model/post_reaction.dart';

class PostItem {
  static const int typeImage = 1;

  int? _idtime;
  String? _idpublication;
  String? _iduser;
  int? _type;
  String? _nameuser;
  String? _imageuser;
  String? _message;
  String? _urlimage;
  String? _timeshow;
  String? _imageName;
  List<PostReaction> _reactions = [];

  PostItem();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idtime": this.idtime,
      "idpublication": this.idpublication,
      "iduser": this.iduser,
      "type": this.type,
      "nameuser": this.nameuser,
      "imageuser": this.imageuser,
      "message": this.message,
      "urlimage": this.urlimage,
      "timeshow": this.timeshow,
      "imageName": this.imageName,
      "reactions": this.reactions,
    };
    return map;
  }

  get idtime => this._idtime;
  set idtime(value) => this._idtime = value;

  get idpublication => this._idpublication;
  set idpublication(value) => this._idpublication = value;

  get iduser => this._iduser;
  set iduser(value) => this._iduser = value;

  get type => this._type;
  set type(value) => this._type = value;

  get nameuser => this._nameuser;
  set nameuser(value) => this._nameuser = value;

  get imageuser => this._imageuser;
  set imageuser(value) => this._imageuser = value;

  get message => this._message;
  set message(value) => this._message = value;

  get urlimage => this._urlimage;
  set urlimage(value) => this._urlimage = value;

  get timeshow => this._timeshow;
  set timeshow(value) => this._timeshow = value;

  get imageName => this._imageName;
  set imageName(value) => this._imageName = value;

  get reactions => this._reactions;
  set reactions(value) => this._reactions = value;
}
