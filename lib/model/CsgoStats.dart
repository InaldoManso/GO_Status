class CsgoStats {
  String _resultkd;
  String _kill;
  String _death;
  String _timeplay;
  String _wins;
  String _mvps;
  String _headshots;

  CsgoStats();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
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
