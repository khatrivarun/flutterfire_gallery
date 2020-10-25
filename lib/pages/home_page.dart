import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/models/image.dart';
import 'package:flutterfire_gallery/pages/login_page.dart';
import 'package:flutterfire_gallery/providers/providers.dart';
import 'package:flutterfire_gallery/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker imagePicker = new ImagePicker();
  final GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;

  Future<void> getStorage(BuildContext context) async {
    final PickedFile pickedImage = await this.imagePicker.getImage(
          source: ImageSource.gallery,
        );

    setState(() {
      this.isLoading = true;
    });

    await Provider.of<ImagesProvider>(
      context,
      listen: false,
    ).insertImage(
      new File(
        pickedImage.path,
      ),
    );

    setState(() {
      this.isLoading = false;
    });
  }

  Future<void> getCamera(BuildContext context) async {
    final PickedFile pickedImage = await this.imagePicker.getImage(
          source: ImageSource.camera,
        );

    setState(() {
      this.isLoading = true;
    });

    await Provider.of<ImagesProvider>(
      context,
      listen: false,
    ).insertImage(
      new File(
        pickedImage.path,
      ),
    );

    setState(() {
      this.isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      this.isLoading = true;
    });

    Provider.of<ImagesProvider>(context, listen: false).fetchImages().then((_) {
      setState(() {
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ImageModel> images = Provider.of<ImagesProvider>(
      context,
      listen: true,
    ).images;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add_disabled,
              color: Colors.black,
            ),
            onPressed: () async {
              await Provider.of<AuthProvider>(
                context,
                listen: false,
              ).signOut();

              Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ImagesProvider>(context, listen: false)
              .fetchImages();
          setState(() {
            this.isLoading = false;
          });
        },
        child: !isLoading
            ? images.length > 0
                ? GridView.builder(
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageWidget(
                        imageModel: images[index],
                      ),
                    ),
                  )
                : Center(
                    child: Text('No Images To Display!'),
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Loading Images'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt_rounded),
                    title: Text('Upload from camera'),
                    onTap: () async {
                      await this.getCamera(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_album_sharp),
                    title: Text('Upload from storage'),
                    onTap: () async {
                      await this.getStorage(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
