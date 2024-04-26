import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_api/youtube_api.dart';


import '../blocs/VideoPageBloc.dart';
import '../utils/universal_variables.dart';

class VideoSearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => VideoPageBloc(), child: VideoSearch());
  }
}


class VideoSearch extends StatefulWidget {

  @override
  State<VideoSearch> createState() => _VideoSearchState();
}

class _VideoSearchState extends State<VideoSearch> {

  bool typing = false;
  static String key = "AIzaSyDgH9Oz5tCLAcrv2rcR0To9zy38i6pDA0Y";
  String header = "What are You looking for?";

  YoutubeAPI youtube = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];

  final TextEditingController searchCtrl = TextEditingController();
  late VideoPageBloc videoPageBloc;

  Future<void> callAPI() async {
    videoResult = await youtube.search(
      "Foods",
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    videoPageBloc = Provider.of<VideoPageBloc>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Icon(
                Icons.play_circle_filled,
                color: Colors.red,
                size: 30,
              ),
              SizedBox(width: 5),
              Text(
                "YouTube",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          actions: [
            const Icon(
              Icons.cast,
              color: Colors.black,
              size: 23,
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
              size: 27,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("search_page");
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.withOpacity(0.5),
              backgroundImage: const NetworkImage(
                "https://avatars.githubusercontent.com/u/111499361?v=4",
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: videoResult.map<Widget>(listItem).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return GestureDetector(
      onTap: () {
        //
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              image: DecorationImage(
                image: NetworkImage("${video.thumbnail.high.url}"),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Padding(
            padding:
            const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  video.channelTitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildSuggestions(String query) {
    return Expanded(
      child: ListView.builder(
        itemCount: videoPageBloc.searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              'https://img.youtube.com/vi/${videoPageBloc.searchResults[index]["id"]}/maxresdefault.jpg',
              fit: BoxFit.cover,
            ),
            onTap: () {
              // Handle video selection
            },
          );
        },
      ),
    );
  }

  createSearchBar() {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: UniversalVariables.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (search) {
                videoPageBloc.setQuery(search);
              },
              controller: searchCtrl,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search..."),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: UniversalVariables.orangeColor,
                ),
                onPressed: () => videoPageBloc.searchVideos(videoPageBloc.query)
                ),
          ),
        ],
      ),
    );
  }

}


class VideoPlayerPage extends StatelessWidget {
  final String videoId;

  const VideoPlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
// Open video player
// You can use any video player package or WebView to play the video
// For simplicity, let's just print the videoId here
                print('Playing video with ID: $videoId');
              },
              child: Text('Play Video'),
            ),
          ],
        ),
      ),
    );
  }
}

