class Message {
  // Atributos
  String _iduser = "";
  String _nome = "";
  String _mensagem = "";
  String _urlimage = "";
  String _tipo = "";
  String _horaexibir = "";
  int _time = 0;

  //Contrutor
  Message();

  //conversor em Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "iduser": this.iduser,
      "nome": this.nome,
      "mensagem": this.mensagem,
      "urlimage": this.urlimage,
      "tipo": this.tipo,
      "horaexibir": this.horaexibir,
      "time": this.time,
    };
    return map;
  }

  //Getters e Setters
  get iduser => this._iduser;

  set iduser(value) => this._iduser = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get mensagem => this._mensagem;

  set mensagem(value) => this._mensagem = value;

  get urlimage => this._urlimage;

  set urlimage(value) => this._urlimage = value;

  get tipo => this._tipo;

  set tipo(value) => this._tipo = value;

  get horaexibir => this._horaexibir;

  set horaexibir(value) => this._horaexibir = value;

  get time => this._time;

  set time(value) => this._time = value;
}
