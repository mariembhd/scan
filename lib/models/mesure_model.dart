
class pantalon_model {
  final id, ref, tourDeTaille, largeur, longueur;
  pantalon_model(
      {
        this.id,
        this.ref,
        this.tourDeTaille,
        this.largeur,
        this.longueur,
      } );

  // map data to firebase
  Map<String, dynamic> add_data(){
    return { "ref": ref,"largeur": largeur , "tourDeTaille": tourDeTaille , "longueur": longueur};
  }
}


class jupe_model {
  final id,ref, largeur, longueur ;
  jupe_model(
      {
        this.id,
        this.ref,
        this.largeur,
        this.longueur,
      } );

  // map data to firebase
  Map<String, dynamic> add_data(){
    return { "ref": ref,"largeur": largeur , "longueur": longueur};
  }
}