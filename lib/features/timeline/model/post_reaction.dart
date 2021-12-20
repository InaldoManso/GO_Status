class PostReaction {
  int? _idreaction;
  String? _uidUser;
  String? _nameUser;
  String? _timeReaction;
  String? _type;

  PostReaction();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idreaction": this.idreaction,
      "uidUser": this.uidUser,
      "nameUser": this.nameUser,
      "timeReaction": this.timeReaction,
      "type": this.type,
    };
    return map;
  }

  get idreaction => this._idreaction;
  set idreaction(value) => this._idreaction = value;

  get uidUser => this._uidUser;
  set uidUser(value) => this._uidUser = value;

  get nameUser => this._nameUser;
  set nameUser(value) => this._nameUser = value;

  get timeReaction => this._timeReaction;
  set timeReaction(value) => this._timeReaction = value;

  get type => this._type;
  set type(value) => this._type = value;
}
