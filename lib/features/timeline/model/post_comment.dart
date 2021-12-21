class PostComment {
  int? _idcomment;
  String? _uidUser;
  String? _nameUser;
  String? _timeComment;
  String? _type;
  String? _message;

  PostComment();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idcomment": this.idcomment,
      "uidUser": this.uidUser,
      "nameUser": this.nameUser,
      "timeComment": this.timeComment,
      "type": this.type,
      "message": this.message,
    };
    return map;
  }

  get idcomment => this._idcomment;
  set idcomment(value) => this._idcomment = value;

  get uidUser => this._uidUser;
  set uidUser(value) => this._uidUser = value;

  get nameUser => this._nameUser;
  set nameUser(value) => this._nameUser = value;

  get timeComment => this._timeComment;
  set timeComment(value) => this._timeComment = value;

  get type => this._type;
  set type(value) => this._type = value;

  get message => this._message;
  set message(value) => this._message = value;
}
