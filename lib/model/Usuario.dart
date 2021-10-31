class UserProfile {
  int _admin = 0;
  String _name = "";
  String _email = "";
  String _password = "";
  String _steamid = "";
  String _userid = "";
  String _team = "";
  String _urlimage = "";
  String _country = "";
  String _version = "";
  bool _showKillDeath = false;

  //Contrutor
  UserProfile();

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

  get nome => this._name;

  set nome(value) => this._name = value;

  get email => this._email;

  set email(value) => this._email = value;

  get senha => this._password;

  set senha(value) => this._password = value;

  get steamid => this._steamid;

  set steamid(value) => this._steamid = value;

  get userid => this._userid;

  set userid(value) => this._userid = value;

  get time => this._team;

  set time(value) => this._team = value;

  get urlimage => this._urlimage;

  set urlimage(value) => this._urlimage = value;

  get pais => this._country;

  set pais(value) => this._country = value;

  get version => this._version;

  set version(value) => this._version = value;

  get exibirclass => this._showKillDeath;

  set exibirclass(value) => this._showKillDeath = value;
}
