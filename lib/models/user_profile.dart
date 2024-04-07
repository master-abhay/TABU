const String UID = 'uid';
const String NAME = 'name';
const String PFP_URL = 'pfpURL';

class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  //another style of creating constructor: because if want to use only some characters then we use only that.
  UserProfile(
      {required String? uid, required String? name, required String? pfpURL}) {
    this.name = name;
    this.uid = uid;
    this.pfpURL = pfpURL;
  }

  // Another named Constructor: which we calling as fromJSON
  UserProfile.fromJSON(Map<String, dynamic> json) {
    uid = json[UID];
    name = json[NAME];
    pfpURL = json[PFP_URL];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data[NAME] = name;
    data[UID] = uid;
    data[PFP_URL] = pfpURL;

    return data;
  }
}
