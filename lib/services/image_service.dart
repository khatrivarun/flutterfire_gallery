import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterfire_gallery/models/models.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid uuid = new Uuid();

  Future<List<ImageModel>> fetchImages(String uid) async {
    List<ImageModel> _images = new List();
    List<QueryDocumentSnapshot> imagesDocs =
        (await this._firestore.collection(uid).get()).docs;

    imagesDocs.forEach(
      (image) => _images.add(
        new ImageModel(
          uid: image.id,
          uuid: image["uuid"],
          imgUrl: image["imgUrl"],
        ),
      ),
    );

    return _images;
  }

  Future<ImageModel> insertImage(File imageFile, String userId) async {
    String uid = uuid.v4();

    await this
        ._storage
        .ref()
        .child('gallery')
        .child('$uid.png')
        .putFile(imageFile)
        .onComplete;

    String imgUrl = await this
        ._storage
        .ref()
        .child('gallery')
        .child('$uid.png')
        .getDownloadURL();

    DocumentReference imageDoc = await this._firestore.collection(userId).add({
      'uuid': uid,
      'imgUrl': imgUrl,
    });

    return new ImageModel(
      uid: imageDoc.id,
      uuid: uid,
      imgUrl: imgUrl,
    );
  }

  Future<void> deleteImage(String userId, ImageModel imageModel) async {
    await this
        ._storage
        .ref()
        .child('gallery')
        .child('${imageModel.uuid}.png')
        .delete();

    await this._firestore.collection(userId).doc(imageModel.uid).delete();
  }

  Future<void> downloadImage(ImageModel imageModel) async {
    await ImageDownloader.downloadImage(imageModel.imgUrl);
  }
}
