
class employe_model {
  final id, nom, prenom, email, canAccessStatistics, canAccessGallery, canAccessScan, password, role  ;
  employe_model(
  {
     this.id,
     this.nom,
     this.prenom,
     this.email,
     this.canAccessGallery = false,
     this.canAccessStatistics = false,
     this.canAccessScan =  false,
     this.password,
     this.role = false,

  } );

  // map data to firebase
Map<String, dynamic> add_data(){
  return { "nom": nom,"prenom": prenom , "email": email, "canAccessGallery": canAccessGallery,
    "canAccessStatistics": canAccessStatistics, "canAccessScan": canAccessScan ,"password": password , "role":role};
}
}