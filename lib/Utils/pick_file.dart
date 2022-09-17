

import 'package:file_picker/file_picker.dart';

Future<String> pickImage() async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    // allowedExtensions: ['png']
    type: FileType.image,
    allowMultiple: false,
    allowCompression: false
  );

  //method for picking only one image not multi
  if(result != null){
    final files = result.files.single.path;
    return files!;
  }else{
    return '';
  }
}