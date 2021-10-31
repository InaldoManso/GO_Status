class UserSettings {
  bool exibirclass;

  UserSettings();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "exibirclass": this.exibirclass,
    };
    return map;
  }

  get getExibirclass => this.exibirclass;

  set setExibirclass(exibirclass) => this.exibirclass = exibirclass;
}
