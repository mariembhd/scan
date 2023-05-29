



class mesure_model {
  final id,code, largeur, longueur,type ;
  mesure_model(
      {
        this.id,
        this.code,
        this.largeur,
        this.longueur,
        this.type
      } );

  // map data to firebase
  Map<String, dynamic> add_data(){
    return { "code": code,"largeur": largeur , "longueur": longueur , "type": type};
  }
}