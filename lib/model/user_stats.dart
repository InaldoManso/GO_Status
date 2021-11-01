class UserStats {
  String _nome = "";
  String _urlimage = "";
  String _killdeath = "";
  String _kill = "";
  String _death = "";
  String _timeplay = "";
  String _wins = "";
  String _mvps = "";
  String _headshots = "";

  UserStats();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "urlimage": this.urlimage,
      "killdeath": this.killdeath,
      "kill": this.kill,
      "death": this.death,
      "timeplay": this.timeplay,
      "wins": this.wins,
      "mvps": this.mvps,
      "headshots": this.headshots,
    };
    return map;
  }

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get urlimage => this._urlimage;

  set urlimage(value) => this._urlimage = value;

  get killdeath => this._killdeath;

  set killdeath(value) => this._killdeath = value;

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
