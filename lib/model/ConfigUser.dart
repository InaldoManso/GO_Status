class ConfigUser {
  bool exibirclass;
  bool modoescuro;

  ConfigUser();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "exibirclass": this.exibirclass,
      "modoescuro": this.modoescuro,
    };
    return map;
  }

  get getExibirclass => this.exibirclass;

  set setExibirclass(exibirclass) => this.exibirclass = exibirclass;

  get getModoescuro => this.modoescuro;

  set setModoescuro(modoescuro) => this.modoescuro = modoescuro;
}
