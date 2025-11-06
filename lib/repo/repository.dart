import 'dart:convert';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';
import 'package:http/http.dart' as http;
import 'package:media_scanner/media_scanner.dart';

class Repository {

  final String baseUrl = 'https://api.pexels.com/v1/';

  ///making it as a ist
  Future<List<Images>> getImagesList({required int? pageNumber}) async {
    String url = '';

    if (pageNumber == null) {
      url = "${baseUrl}curated?per_page=80";
    } else {
      url = "${baseUrl}curated?per_page=80&page=$pageNumber";
    }

    List<Images> imageslist = [];

    try {
      final response =
          await http.get(Uri.parse(url), headers: {'Authorization': apiKey});

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = jsonDecode(response.body);

        for (final json in jsonData['photos'] as Iterable) {
          final image = Images.fromJson(json);
          imageslist.add(image);
        }
      }
    } catch (_) {}

    return imageslist;
  }

  ///getting image by Id
  Future<Images> getImageById({required int id}) async {
    final url = '${baseUrl}photos/$id';
    Images image = Images.emptyConstructor();

    try {
      final response =
          await http.get(Uri.parse(url), headers: {'Authorization': apiKey});

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);

        image = Images.fromJson(jsonData);
      }
    } catch (_) {}

    return image;
  }

  ///getting image by searching
  Future<List<Images>> getImagesBySerach({required String query}) async {
    final url = "${baseUrl}search?query=$query&per_page=80";
    List<Images> imageslist = [];

    try {
      final response =
          await http.get(Uri.parse(url), headers: {'Authorization': apiKey});

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = jsonDecode(response.body);

        for (final json in jsonData['photos'] as Iterable) {
          final image = Images.fromJson(json);
          imageslist.add(image);
        }
      }
    } catch (_) {}

    return imageslist;
  }

  ///downloading the image
  Future<void> downloadImage(
      {required String imageUrl,
      required int imageId,
      required BuildContext context}) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final bytes = response.bodyBytes;
        final directory = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOAD);
        final file = File("$directory/$imageId.png");
        await file.writeAsBytes(bytes);

        MediaScanner.loadMedia(path: file.path);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "File has been saved at: ${file.path}",
            ),
            duration: const Duration(seconds: 2),
          ));
        }
      }
    } catch (_) {}
  }
}
