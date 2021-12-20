class SnappingItem {
  bool? enabled;
  String? id;
  int? order;
  String? tittle;
  String? type;

  SnappingItem({this.enabled, this.id, this.order, this.type});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "enabled": this.enabled,
      "id": this.id,
      "order": this.order,
      "tittle": this.tittle,
      "type": this.type,
    };
    return map;
  }

  get getEnabled => this.enabled;
  set setEnabled(enabled) => this.enabled = enabled;

  get getId => this.id;
  set setId(id) => this.id = id;

  get getOrder => this.order;
  set setOrder(order) => this.order = order;

  get getTittle => this.tittle;
  set setTittle(tittle) => this.tittle = tittle;

  get getType => this.type;
  set setType(type) => this.type = type;
}
