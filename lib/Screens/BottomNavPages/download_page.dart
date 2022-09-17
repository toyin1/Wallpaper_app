import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../Utils/routers.dart';
import 'WallPaper_Page/view_wallpaper_page.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);



  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final CollectionReference wallpaper = FirebaseFirestore.instance.collection('PurchasedWallpaper');

  final uid = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: wallpaper.doc(uid).collection('Wallpaper').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          print(snapshot.data);
          if(snapshot.hasData){

            if(snapshot.data!.docs.isEmpty){

              return const Center(
                  child: Text('No Saved wallpaper'));
            }else{
              final data = snapshot.data!.docs;

              return Container(
                  padding: const EdgeInsets.all(10),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.6,
                    children: List.generate(data.length, (index) {
                      final image = data[index];

                      return GestureDetector(
                          onTap: (){
                            nextPage(
                                context: context,
                                //path: saved to tell us that downloaded imaged as saved
                                page: ViewWallPaperPage(data: image, path: 'saved',)
                            );
                          },
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      //wallpaper_image most be thesame with the one add_wallpaper_provider
                                        image.get('wallpaper_image')
                                    )
                                )
                            ),
                            child: Center(
                              child: image.get('price') == ''
                                  ? const Text('')
                                  : CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(image.get('price')),
                              ),
                            ),
                          ));
                    }),
                  ));
            }

          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
