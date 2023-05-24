
class employe_model {
  final id, nom, prenom,email  ;
  employe_model(
  {
     this.id,
     this.nom,
     this.prenom,
     this.email

  } );

  // map data to firebase
Map<String, dynamic> add_data(){
  return { "nom": nom,"prenom": prenom , "email": email};
}
}