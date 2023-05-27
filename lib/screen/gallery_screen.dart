import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery/screen/look_photo_screen.dart';
import 'package:gallery/service/check_service.dart';
import 'package:gallery/service/gallery_service.dart';
import 'package:gallery/service/user_service.dart';
import 'package:provider/provider.dart';

class GalleryScreem extends StatefulWidget {
  const GalleryScreem({super.key});

  @override
  State<GalleryScreem> createState() => _GalleryScreemState();
}

class _GalleryScreemState extends State<GalleryScreem> {
  User? user;
  Map<String, dynamic>? myInfo;
  bool isLoading = true;
  CheckService checkService = CheckService();
  GalleryService galleryService = GalleryService();

  void init() async {
    user = context.read<UserService>().currentUser()!;
    DocumentSnapshot snapshot =
        await context.read<UserService>().getMyInfo(user!.uid);

    myInfo = snapshot.data() as Map<String, dynamic>;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: Text("loading..."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Image.network(myInfo!["profile_img"]),
                    title: Text(myInfo!["name"]),
                    subtitle: Text(myInfo!["email"]),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      checkService.check(myInfo!);
                    },
                    child: const Text("출석하기"),
                  ),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: checkService.getChecks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<QueryDocumentSnapshot> docs =
                              snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Image.network(
                                      docs[index]["profile_img"],
                                    ),
                                  ),
                                  Text(docs[index]["name"])
                                ],
                              );
                            },
                          );
                        } else {
                          return const Text("loadding...");
                        }
                      },
                    ),
                  ),
                  const Text("갤러리"),
                  ElevatedButton(
                    onPressed: () {
                      galleryService.addImage(myInfo!);
                    },
                    child: const Text("사진 추가"),
                  ),
                  FutureBuilder(
                    future: galleryService.getPhotos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var doc = snapshot.data!.docs;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: doc.length,
                            itemBuilder: (context, index) {
                              var current_doc = doc[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LookPhotoScreen(
                                          current_doc, myInfo!["uid"]),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    current_doc["photo_url"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Text("loading..");
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }
}
