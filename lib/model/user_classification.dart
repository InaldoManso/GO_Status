class UserClassification {
  // Atributos
  String _nome;
  String _email;
  String _senha;
  String _steamid;
  String _userid;
  String _time;
  String _urlimage;
  String _pais;
  String _resultkd;
  String _kill;
  String _death;
  String _timeplay;
  String _wins;
  String _mvps;
  String _headshots;

  //Contrutor
  UserClassification();

  //conversor em Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "senha": this.senha,
      "steamid": this.steamid,
      "userid": this.userid,
      "time": this.time,
      "urlimage": this.urlimage,
      "pais": this.pais,
      "resultkd": this.resultkd,
      "kill": this.kill,
      "death": this.death,
      "timeplay": this.timeplay,
      "wins": this.wins,
      "mvps": this.mvps,
      "headshots": this.headshots,
    };
    return map;
  }

  //Getters e Setters

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

  get resultkd => this._resultkd;

  set resultkd(value) => this._resultkd = value;

  get kill => this._kill;

  set kill(value) => this._kill = value;

  get death => this._death;

  set death(value) => this._death = value;

  get timeplay => this._timeplay;

  set timeplay(value) => this._timeplay = value;

  get wins => this._wins;

  set wins(value) => this._wins = value;

  get mvps => this._mvps;

  set mvps(value) => this._mvps = value;

  get headshots => this._headshots;

  set headshots(value) => this._headshots = value;
}
