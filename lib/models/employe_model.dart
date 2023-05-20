
class employe_model {
  final id, nom, prenom, departement ;
  employe_model(
  {
     this.id,
     this.nom,
     this.prenom,
     this.departement,
  } );

  // map data to firebase
Map<String, dynamic> add_data(){
  return { "nom": nom,"prenom": prenom , "departement": departement};
}
}