
class employe_model {
  final id, nom, prenom, email, canViewStatistics, canAccessGallery, canAccessScan  ;
  employe_model(
  {
     this.id,
     this.nom,
     this.prenom,
     this.email,
     this.canAccessGallery = true,
     this.canViewStatistics = true,
     this.canAccessScan =  true,

  } );

  // map data to firebase
Map<String, dynamic> add_data(){
  return { "nom": nom,"prenom": prenom , "email": email, "canAccessGallery": canAccessGallery,
    "canViewStatistics": canViewStatistics, "canAccessScan": canAccessScan };
}
}