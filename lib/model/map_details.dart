class MapDetails {
  String capa;
  String image;
  String titulo;
  String descricao;
  bool exibirimage;

  MapDetails(
      this.capa, this.image, this.titulo, this.descricao, this.exibirimage);

  get getCapa => this.capa;

  set setCapa(capa) => this.capa = capa;

  get getImage => this.image;
  set setImage(image) => this.image = image;

  get getTitulo => this.titulo;
  set setTitulo(titulo) => this.titulo = titulo;

  get getDescricao => this.descricao;
  set setDescricao(descricao) => this.descricao = descricao;

  get getExibirimage => this.exibirimage;
  set setExibirimage(exibirimage) => this.exibirimage = exibirimage;
}
