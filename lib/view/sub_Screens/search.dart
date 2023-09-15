import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videoplayer_miniproject/helpers/appcolors.dart';
import '../../controller/searchcontroller.dart';
import '../video/video_play.dart';

class VideoSearchScreenState extends StatefulWidget {
  const VideoSearchScreenState({Key? key}) : super(key: key);

  @override
  VideoSearchScreenStateState createState() => VideoSearchScreenStateState();
}

class VideoSearchScreenStateState extends State<VideoSearchScreenState> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Appcolors.primaryTheme,
            title: const Text('Search Videos'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  value.clearSearch();
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: value.searchController,
                  style: const TextStyle(fontSize: 20),
                  onChanged: (query) {
                    value.performSearch(query);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Appcolors.secondaryTheme, width: 3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Appcolors.secondaryTheme, width: 3),
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Appcolors.secondaryTheme,
                      size: 30,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        value.clearSearch();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Appcolors.secondaryTheme,
                      ),
                    ),
                    hintText: 'Search here...',
                    hintStyle: const TextStyle(
                        color: Appcolors.primaryTheme, fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: value.searchResults.length,
                  itemBuilder: (context, index) {
                    final video = value.searchResults[index];
                    return Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(bottom: 2, top: 2),
                          child: SizedBox(
                            height: double.infinity,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(
                                  video.thumbnailPath!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        horizontalTitleGap: 10,
                        title: Text(video.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerWidget(video),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
