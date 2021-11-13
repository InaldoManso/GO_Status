class OptionSpliter {
  Map<String, dynamic> option(String optionSelected) {
    List<String> menuIdpostId = optionSelected.split("/");

    Map<String, dynamic> _mapResult = {
      "id": menuIdpostId[0].toLowerCase(),
      "post": menuIdpostId[1],
      "userid": menuIdpostId[2],
      "imageName": menuIdpostId[3],
    };

    return _mapResult;
  }
}
