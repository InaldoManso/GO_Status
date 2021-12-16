class UserClassification {
  String _name;
  String _email;
  String _password;
  String _steamid;
  String _userid;
  String _team;
  String _urlimage;
  String _country;
  String _killdeath;
  String _kill;
  String _death;
  String _timeplay;
  String _wins;
  String _mvps;
  String _headshots;

  UserClassification();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "steamid": this.steamid,
      "userid": this.userid,
      "team": this.team,
      "urlimage": this.urlimage,
      "country": this.country,
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

  get name => this._name;
  set name(value) => this._name = value;

  get email => this._email;
  set email(value) => this._email = value;

  get password => this._password;
  set password(value) => this._password = value;

  get steamid => this._steamid;
  set steamid(value) => this._steamid = value;

  get userid => this._userid;
  set userid(value) => this._userid = value;

  get team => this._team;
  set team(value) => this._team = value;

  get urlimage => this._urlimage;
  set urlimage(value) => this._urlimage = value;

  get country => this._country;
  set country(value) => this._country = value;

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
