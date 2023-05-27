import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery/service/gallery_service.dart';
import 'package:intl/intl.dart';

class LookPhotoScreen extends StatelessWidget {
  final QueryDocumentSnapshot data;
  final String myUid;
  LookPhotoScreen(this.data, this.myUid);

  var galleryService = GalleryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.network(
                    data["profile_img"],
                    fit: BoxFit.cover,
                  ),
                ),
                Text(data["name"]),
              ],
            ),
            Text(
              DateFormat("yyyy M dd a hh:mm").format(data["sendDate"].toDate()),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              data["photo_url"],
              fit: BoxFit.cover,
            ),
          ),
          Row(
            //사진 다운로드
            children: [
              IconButton(
                onPressed: () {
                  galleryService.downloadImg();
                },
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
              ),

              //사진 삭제.
              IconButton(
                onPressed: () {
                  if (data["uid"] == myUid) {
                    galleryService.deletePhoto(data.id);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
