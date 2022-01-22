class UserSettings {
  bool? _showkilldeath;
  bool? _sendchatnotify;

  UserSettings();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "showkilldeath": this.showkilldeath,
      "sendchatnotify": this.sendchatnotify,
    };
    return map;
  }

  get showkilldeath => this._showkilldeath;
  set showkilldeath(value) => this._showkilldeath = value;

  get sendchatnotify => this._sendchatnotify;
  set sendchatnotify(value) => this._sendchatnotify = value;
}
