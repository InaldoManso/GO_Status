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
  String _fcm = "";
  bool _showKillDeath = true;

  UserProfile();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "admin": this.admin,
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "steamid": this.steamid,
      "userid": this.userid,
      "team": this.team,
      "urlimage": this.urlimage,
      "country": this.country,
      "version": this.version,
      "fcm": this.fcm,
      "showkilldeath": this.showKillDeath
    };
    return map;
  }

  get admin => this._admin;
  set admin(value) => this._admin = value;

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

  get version => this._version;
  set version(value) => this._version = value;

  get fcm => this._fcm;
  set fcm(value) => this._fcm = value;

  get showKillDeath => this._showKillDeath;
  set showKillDeath(value) => this._showKillDeath = value;
}
