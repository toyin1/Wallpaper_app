import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UploadWallPaperProvider extends ChangeNotifier {

  //get and setter
  String _message = "";

  bool _status = false;

  String get message => _message;

  bool get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //Cloud storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void clear(){
    _message = "";
    notifyListeners();
  }
  void addWallPaper({
  File? wallPaperImage,
    String? uid,
    String? price,
}) async{
    _status = true;
    notifyListeners();

    CollectionReference _product = _firestore.collection("AllWallpaper");

    String imagePath = '';

    try{
      _message = "Uploading Image...";
      notifyListeners();
      //to get the name of image
      final imageName = wallPaperImage!.path.split('/').last;

      await _storage.ref().child("$uid/WallPaper/$imageName").putFile(wallPaperImage).whenComplete(() async{
        await _storage.ref().child("$uid/WallPaper/$imageName").getDownloadURL().then((value) {

          //assign downloaded url to imagepath
          imagePath = value;
        });
        //create the variable that will get the download url. create string image path above
        final data = {
          'price': price,
          'uid': uid,
          'wallpaper_image': imagePath,
        };

        //save the database
        await _product.add(data);

        _status = false;
        _message = 'Successful';
        notifyListeners();


      });

    }on FirebaseException catch (e){
      _status = false;
      _message = e.message.toString();
      notifyListeners();
    }on SocketException catch (_){
      _status = false;
      _message = "Internet is required to perform this action";
      notifyListeners();
    } catch (e){
      print(e);
      _status = false;
      _message = "Please try again";
      notifyListeners();
    }
  }
  

}