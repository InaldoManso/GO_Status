class Message {
  //Types of messages
  static const int typeMessage = 1;
  static const int typePhoto = 2;

  int _messageid = 0;
  String? _iduser = "";
  String? _name = "";
  String _message = "";
  String _urlimage = "";
  int _type = 0;
  String _timeshow = "";

  Message();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "messageid": this.messageid,
      "iduser": this.iduser,
      "name": this.name,
      "message": this.message,
      "urlimage": this.urlimage,
      "type": this.type,
      "timeshow": this.timeshow,
    };
    return map;
  }

  get messageid => this._messageid;
  set messageid(value) => this._messageid = value;

  get iduser => this._iduser;
  set iduser(value) => this._iduser = value;

  get name => this._name;
  set name(value) => this._name = value;

  get message => this._message;
  set message(value) => this._message = value;

  get urlimage => this._urlimage;
  set urlimage(value) => this._urlimage = value;

  get type => this._type;
  set type(value) => this._type = value;

  get timeshow => this._timeshow;
  set timeshow(value) => this._timeshow = value;
}
