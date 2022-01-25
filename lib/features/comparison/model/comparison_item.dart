class ComparisonItem {
  String? id;
  String? name;
  String? ammunition;
  int? category;
  int? damage;
  int? firingRate;
  int? penetrationInProtection;
  int? precisionRange;
  int? prizeForKilling;
  int? recoilControl;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "name": this.name,
      "ammunition": this.ammunition,
      "category": this.category,
      "firingRate": this.firingRate,
      "penetrationInProtection": this.penetrationInProtection,
      "precisionRange": this.precisionRange,
      "prizeForKilling": this.prizeForKilling,
      "recoilControl": this.recoilControl,
    };
    return map;
  }

  get getId => this.id;
  set setId(id) => this.id = id;

  get getName => this.name;
  set setName(name) => this.name = name;

  get getAmmunition => this.ammunition;
  set setAmmunition(ammunition) => this.ammunition = ammunition;

  get getCategory => this.category;
  set setCategory(category) => this.category = category;

  get getDamage => this.damage;
  set setDamage(damage) => this.damage = damage;

  get getFiringRate => this.firingRate;
  set setFiringRate(firingRate) => this.firingRate = firingRate;

  get getPenetrationInProtection => this.penetrationInProtection;
  set setPenetrationInProtection(penetrationInProtection) =>
      this.penetrationInProtection = penetrationInProtection;

  get getPrecisionRange => this.precisionRange;
  set setPrecisionRange(precisionRange) => this.precisionRange = precisionRange;

  get getPrizeForKilling => this.prizeForKilling;
  set setPrizeForKilling(prizeForKilling) =>
      this.prizeForKilling = prizeForKilling;

  get getRecoilControl => this.recoilControl;
  set setRecoilControl(recoilControl) => this.recoilControl = recoilControl;
}
