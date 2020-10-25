import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutterfire_gallery/models/models.dart';
import 'package:flutterfire_gallery/services/services.dart';

class ImagesProvider with ChangeNotifier {
  final List<ImageModel> _images = [];
  final ImageService _imageService = new ImageService();
  String userId;

  ImagesProvider({this.userId});

  get images => [...this._images];

  void setUserId(String userId) {
    this.userId = userId;

    notifyListeners();
  }

  Future<void> fetchImages() async {

    while(this._images.isNotEmpty) {
      this._images.removeLast();
    }

    List<ImageModel> fetchedImages =
        await this._imageService.fetchImages(userId);

    fetchedImages.forEach((image) {
      this._images.add(image);
    });

    notifyListeners();
  }

  ImageModel getImage(int index) {
    return this._images[index];
  }

  Future<void> insertImage(File imageFile) async {
    ImageModel imageModel =
        await this._imageService.insertImage(imageFile, userId);

    this._images.add(imageModel);

    notifyListeners();
  }

  Future<void> deleteImage(ImageModel imageModel) async {
    await this._imageService.deleteImage(userId, imageModel);

    this._images.removeWhere((element) => element.uid == imageModel.uid);

    notifyListeners();
  }

  Future<void> downloadImage(ImageModel imageModel) async {
    await this._imageService.downloadImage(imageModel);
  }
}
