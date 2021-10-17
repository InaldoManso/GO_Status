class Postagem {
  int _idtime;
  String _idpostagem;
  String _idtipo;
  String _iduser;
  String _nomeuser;
  String _imageuser;
  String _texto;
  String _urlimage;
  String _horario;

  Postagem();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idpostagem": this.idpostagem,
      "idtime": this.idtime,
      "idtipo": this.idtipo,
      "iduser": this.iduser,
      "nomeuser": this.nomeuser,
      "imageuser": this.imageuser,
      "texto": this.texto,
      "urlimage": this.urlimage,
      "horario": this.horario,
    };
    return map;
  }

  get idpostagem => this._idpostagem;
  set idpostagem(value) => this._idpostagem = value;

  get idtime => this._idtime;
  set idtime(value) => this._idtime = value;

  get idtipo => this._idtipo;
  set idtipo(value) => this._idtipo = value;

  get iduser => this._iduser;
  set iduser(value) => this._iduser = value;

  get nomeuser => this._nomeuser;
  set nomeuser(value) => this._nomeuser = value;

  get imageuser => this._imageuser;
  set imageuser(value) => this._imageuser = value;

  get texto => this._texto;
  set texto(value) => this._texto = value;

  get urlimage => this._urlimage;
  set urlimage(value) => this._urlimage = value;

  get horario => this._horario;
  set horario(value) => this._horario = value;
}
