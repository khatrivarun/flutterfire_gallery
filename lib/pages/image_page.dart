import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/models/models.dart';
import 'package:flutterfire_gallery/providers/providers.dart';
import 'package:provider/provider.dart';

class ImagePage extends StatelessWidget {
  static final String routeName = "image-page";
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    ImageModel imageModel = arguments['imageModel'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Image',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 400.0,
              width: 300.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton.icon(
                  onPressed: () async {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Downloading'),
                      ),
                    );

                    await Provider.of<ImagesProvider>(
                      context,
                      listen: false,
                    ).downloadImage(imageModel);

                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Downloaded'),
                      ),
                    );
                  },
                  icon: Icon(Icons.download_sharp),
                  label: Text('Download Image'),
                ),
                FlatButton.icon(
                  onPressed: () async {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Deleting'),
                      ),
                    );

                    await Provider.of<ImagesProvider>(
                      context,
                      listen: false,
                    ).deleteImage(imageModel);

                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Deleted'),
                      ),
                    );

                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete Image'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
