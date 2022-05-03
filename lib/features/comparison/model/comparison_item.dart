class ComparisonItem {
  String? id;
  String? name;
  String? ammunition;
  int? order;
  int? prizeForKilling;
  int? damage;
  int? firingRate;
  int? recoilControl;
  int? precisionRange;
  int? penetration;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "name": this.name,
      "ammunition": this.ammunition,
      "order": this.order,
      "prizeForKilling": this.prizeForKilling,
      "damage": this.damage,
      "firingRate": this.firingRate,
      "recoilControl": this.recoilControl,
      "precisionRange": this.precisionRange,
      "penetrationInProtection": this.penetration,
    };
    return map;
  }
}
