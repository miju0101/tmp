import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class GalleryService {
  void addImage(Map<String, dynamic> myInfo) async {
    XFile? selectedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
      File file = File(selectedFile.path);

      DocumentReference doc =
          await FirebaseFirestore.instance.collection("gallery").add({});

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child("gallery")
          .child(doc.id)
          .putFile(file);

      task.snapshotEvents.listen((event) async {
        if (event.state == TaskState.success) {
          var url = await event.ref.getDownloadURL();

          FirebaseFirestore.instance.collection("gallery").doc(doc.id).set({
            "photo_url": url,
            "sendDate": DateTime.now(),
            "uid": myInfo["uid"],
            "name": myInfo["name"],
            "profile_img": myInfo["profile_img"],
          });
        }
      });
    }
  }

  Future<QuerySnapshot> getPhotos() {
    return FirebaseFirestore.instance.collection("gallery").get();
  }

  void deletePhoto(String docId) {
    //내가 올린 이미지이면 삭제가능
    FirebaseFirestore.instance.collection("gallery").doc(docId).delete();
    FirebaseStorage.instance.ref().child("gallery").child(docId).delete();
    print("삭제완료");
  }

  void downloadImg() {}
}
