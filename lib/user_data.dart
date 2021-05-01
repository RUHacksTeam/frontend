import 'package:cloud_firestore/cloud_firestore.dart';

class Data{
   String Name, BlooGrp,PhoneNo, Age, email, city;
   Data(this.Name,this.BlooGrp,this.PhoneNo,this.email,this.Age,this.city);

   Data.fromSnapshot(DocumentSnapshot snapshot) :
          Name =  snapshot['full_name'],
          BlooGrp =  snapshot['blood grp'],
          PhoneNo =  snapshot['phone'],
          Age =  snapshot['age'],
          email =  snapshot['email'],
         city =  snapshot['city'];
}