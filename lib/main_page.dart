import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/preview_page.dart';
import 'package:wallpaper_app/repo/repository.dart';

import 'model/model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Repository repo = Repository();
  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  late Future<List<Images>> imagesList;
  int pageNumber = 1;
  final List<String> categories = [
    'Nature',
    "Abstract",
    'Technologies',
    'Mountains',
    'Cars',
    'Bikes',
    'People'
  ];

  ///function to get images by search
  void getImagesBySearch({required String query}) {
    imagesList = repo.getImagesBySerach(query: query);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    imagesList = repo.getImagesList(pageNumber: pageNumber);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Wallpaper",
              style: TextStyle(color: Colors.blue),
            ),
            Text("App", style: TextStyle(color: Colors.orange)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 25),
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: IconButton(
                          onPressed: () {
                            getImagesBySearch(query: controller.text);
                          },
                          icon: Icon(Icons.search)),
                    )),

                ///learn about it
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
                ],
                onSubmitted: (value) {
                  getImagesBySearch(query: value);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        getImagesBySearch(query: categories[index]);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 1.5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Center(
                              child: Text(categories[index]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: imagesList,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: MasonryGridView.count(
                              controller: scrollController,
                              itemCount: snapshot.data?.length,
                              shrinkWrap: true,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                ///height of the image
                                double height = (index % 10 + 1) * 100;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PreviewPage(
                                                imageUrl: snapshot.data![index]
                                                    .imagePortraitPath,
                                                imageId: snapshot
                                                    .data![index].imageID)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      height: height > 300 ? 250 : height,
                                      fit: BoxFit.cover,
                                      imageUrl: snapshot
                                          .data![index].imagePortraitPath,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            pageNumber++;
                            imagesList =
                                repo.getImagesList(pageNumber: pageNumber);
                            setState(() {});
                          },
                          child: Text("Load more"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          minWidth: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }
}
