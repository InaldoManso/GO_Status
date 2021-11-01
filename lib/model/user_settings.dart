class UserSettings {
  bool _showkilldeath;

  UserSettings();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "showkilldeath": this.showkilldeath,
    };
    return map;
  }

  get showkilldeath => this._showkilldeath;
  set showkilldeath(value) => this._showkilldeath = value;
}
