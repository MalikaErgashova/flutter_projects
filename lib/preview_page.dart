import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/repo/repository.dart';

class PreviewPage extends StatefulWidget {
  final String imageUrl;
  final int imageId;
  const PreviewPage({super.key, required this.imageUrl, required this.imageId});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Repository repo = Repository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          repo.downloadImage(
              imageUrl: widget.imageUrl,
              imageId: widget.imageId,
              context: context);
        },
        child: Icon(Icons.download),
        backgroundColor: Color.fromRGBO(230, 10, 10, .5),
        foregroundColor: Color.fromRGBO(255, 255, 255, .8),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
