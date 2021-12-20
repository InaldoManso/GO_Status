class StatsItem {
  String? name;
  int? value;

  StatsItem({
    this.name,
    this.value,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "value": this.value,
    };
    return map;
  }

  factory StatsItem.fromJson(Map<String, dynamic> json) {
    return StatsItem(
      name: json["name"],
      value: json["value"],
    );
  }
  get getName => this.name;

  set setName(name) => this.name = name;

  get getValue => this.value;

  set setValue(value) => this.value = value;
}
