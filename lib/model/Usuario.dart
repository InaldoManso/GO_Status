class Usuario {
  // Atributos
  int _admin = 0;
  String _nome = "";
  String _email = "";
  String _senha = "";
  String _steamid = "";
  String _userid = "";
  String _time = "";
  String _urlimage = "";
  String _pais = "";
  String _version = "";
  bool _exibirclass = false;

  //Contrutor
  Usuario();

  //conversor em Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "admin": this.admin,
      "nome": this.nome,
      "email": this.email,
      "senha": this.senha,
      "steamid": this.steamid,
      "userid": this.userid,
      "time": this.time,
      "urlimage": this.urlimage,
      "pais": this.pais,
      "version": this.version,
      "exibirclass": this.exibirclass
    };
    return map;
  }

  //Getters e Setters

  get admin => this._admin;

  set admin(value) => this._admin = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get email => this._email;

  set email(value) => this._email = value;

  get senha => this._senha;

  set senha(value) => this._senha = value;

  get steamid => this._steamid;

  set steamid(value) => this._steamid = value;

  get userid => this._userid;

  set userid(value) => this._userid = value;

  get time => this._time;

  set time(value) => this._time = value;

  get urlimage => this._urlimage;

  set urlimage(value) => this._urlimage = value;

  get pais => this._pais;

  set pais(value) => this._pais = value;

  get version => this._version;

  set version(value) => this._version = value;

  get exibirclass => this._exibirclass;

  set exibirclass(value) => this._exibirclass = value;
}
