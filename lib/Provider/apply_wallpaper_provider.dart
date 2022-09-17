import 'package:flutter/foundation.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:wallpaper_app/Provider/save_purchased_wallpaper.dart';
import 'package:wallpaper_app/Utils/convert_url_to_file.dart';

//register the provider in main.dart
class ApplyWallpaperProvider extends ChangeNotifier{
  String _message = '';
  bool _status = false;

  String get message => _message;
  bool get status => _status;

  void apply(String? image, int? location, String? path) async{
    //to change apply text to applying pls wait while trying to apply image. set status to true
    _status = true;
    notifyListeners();

    try{
      // write the logic that will handle the application of the wallpaper

      //method to handle the wallpaper
      //filepath lead to store in ur local device
      final file = await convertUrlToFile(image!);
      await WallpaperManager.setWallpaperFromFile(file.path, location!);

      if(path != 'saved'){
        SavePurchasedProvider().save(wallpaperImage: image!);
      }




    } catch (e){
      print(e);
      _status = false;
      _message = 'Error occured';
      notifyListeners();
    }
  }

  void clearMessage(){
    _message = '';
    notifyListeners();
  }
}