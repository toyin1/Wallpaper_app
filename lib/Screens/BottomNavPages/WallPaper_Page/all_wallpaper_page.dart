import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/Screens/BottomNavPages/WallPaper_Page/add_wallpaper_page.dart';
import 'package:wallpaper_app/Screens/BottomNavPages/WallPaper_Page/view_wallpaper_page.dart';

import '../../../Utils/routers.dart';

class WallPaperHomePage extends StatefulWidget {
  const WallPaperHomePage({Key? key}) : super(key: key);

  @override
  State<WallPaperHomePage> createState() => _WallPaperHomePageState();
}

class _WallPaperHomePageState extends State<WallPaperHomePage> {
  //to get data from database first create a collection refrence
  final CollectionReference wallpaper = FirebaseFirestore.instance.collection('AllWallpaper');


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
        future: wallpaper.get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          print(snapshot.data);
            if(snapshot.hasData){
              if(!snapshot.hasData){
                return const Center(
                  child: Text('No wallpaper'));
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
                            page: ViewWallPaperPage(data: image)
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

      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            nextPage(page: const AddWallPaperPage(), context: context);
          },
          label: const Text("Upload")),

    );
  }
}
