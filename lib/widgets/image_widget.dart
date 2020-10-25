import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/models/models.dart';
import 'package:flutterfire_gallery/pages/pages.dart';

class ImageWidget extends StatelessWidget {
  final ImageModel imageModel;

  const ImageWidget({Key key, this.imageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ImagePage.routeName,
          arguments: {
            'imageModel': imageModel,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
              imageModel.imgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
