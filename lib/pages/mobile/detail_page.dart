import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinterest_ap/models/image_model.dart' as model;
import 'package:share_plus/share_plus.dart';
import '../../services/network_service.dart';
import '../../views/gallery_view.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final int crossAxisCount;
  final model.Image image;
  String? title;

  DetailPage({Key? key, required this.image, this.crossAxisCount = 2}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late model.Image image;
  double ratio = 16 / 9;
  String title = "";
  String subTitle = "";
  int vote = 0;
  bool isLiked = false;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _convertData();
  }

  void _favourite(){
    setState(() {
      isLiked = !isLiked;
      isVisible = true;
    });
  }

  int get limit {
    return widget.crossAxisCount * 15 >= 100 ? 90 : widget.crossAxisCount * 15;
  }

  void _convertData() {
    image = widget.image;
    if (image.width != null && image.height != null) {
      ratio = image.width! / image.height!;
    }
    if(image.breeds != null && image.breeds!.isNotEmpty) {
      title = image.breeds!.first.name ?? "";
      subTitle = image.breeds!.first.bredFor ?? "";
    }
    setState(() {});
  }

  void pressVote() async {
    String? responseCreate;
    if(vote == 0) {
      responseCreate = await NetworkService.POST(NetworkService.API_LIST_VOTES, NetworkService.paramsEmpty(), NetworkService.bodyVotes(image.id!, image.subId, 1));
      if(responseCreate != null) {
        vote = 1;
      }
    } else {
      responseCreate = await NetworkService.POST(NetworkService.API_LIST_VOTES, NetworkService.paramsEmpty(), NetworkService.bodyVotes(image.id!, image.subId, 0));
      if(responseCreate != null) {
        vote = 0;
      }
    }

    setState(() {});
  }

  void share()async{
    final uri = Uri.parse(image.url!);
    final res = await http.get(uri);
    final bytes = res.bodyBytes;
    final temp = await getApplicationDocumentsDirectory();
    print(temp);
    final path = '${temp.path}/image.jpg';
    print(path);
    // File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path]);
  }

  void _saveNetworkImage() {
    String path = image.url!;
    GallerySaver.saveImage(path).then((bool? success) {
      setState(() {});
      print("Saved");
    });
  }


  // void getStatusOfConnection()async{
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   bool result = await InternetConnectionChecker().hasConnection;
  //   if (connectivityResult == ConnectivityResult.mobile && result == true) {
  //     print("Online Mobile");
  //   } else if (connectivityResult == ConnectivityResult.wifi && result == false) {
  //     print("Offline WiFi");
  //   }else if(connectivityResult == ConnectivityResult.mobile && result == false){
  //     print("Offline Mobile");
  //   }else if(connectivityResult == ConnectivityResult.wifi && result == true){
  //     print("Online WiFi");
  //   }
  // }



  //
  // File? _displayImage;
  //
  // final String _url =
  //     'https://www.kindacode.com/wp-content/uploads/2022/02/orange.jpeg';
  //
  // Future<void> _download() async {
  //   final response = await http.get(Uri.parse(_url));
  //
  //   // Get the image name
  //   final imageName = path.basename(_url);
  //   // Get the document directory path
  //   final appDir = await getApplicationDocumentsDirectory();
  //
  //   // This is the saved image path
  //   // You can use it to display the saved image later
  //   final localPath = path.join(appDir.path, imageName);
  //
  //   // Downloading
  //   final imageFile = File(localPath);
  //   await imageFile.writeAsBytes(response.bodyBytes);
  //
  //   setState(() {
  //     _displayImage = imageFile;
  //   });



// void save()async{
//
//   // Future<File> file(String filename) async {
//   //   Directory dir = await getApplicationDocumentsDirectory();
//     // String pathName = p.join(dir.path, filename);
//     // return File(pathName);
//   // }
//
//   // var myFile = await file("myFileName.png");
//   // Image(image:
//   // NetworkToFileImage(
//   //     url: "https://example.com/someFile.png",
//   //     file: myFile,
//   //     debug: true));
//
//   // final uri = Uri.parse(image.url!);
//   // print("uri -> $uri");
//   // var response = await http.get(uri);
//   // print("response -> $response");
//   // Directory? documentDirectory = await getDownloadsDirectory();
//   // print('documentDirectory -> $documentDirectory');
//   // File file = File(path.join(documentDirectory!.path, 'imagetest.png'));
//   // print('file -> $file');
//   // file.writeAsBytesSync(response.bodyBytes);
// }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        // title: Text(widget.title ?? 'aaaa'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            splashRadius: 35,
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_outlined, size: 30,),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // #image
            Stack(
              children: [
                GestureDetector(
                  onDoubleTap: () => _favourite,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    foregroundDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.1),
                            ]
                        )
                    ),
                    child: AspectRatio(
                      aspectRatio: ratio,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: image.url!,
                        placeholder: (context, url) => Container(
                          color: Colors.primaries[Random().nextInt(18) % 18],
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                if (!isLiked && isLiked)
                  Center(
                      child: Lottie.asset(
                          "assets/lottie/lottie_broken_heart.json",
                          repeat: false, onLoaded: (lottieComposition) {
                        Future.delayed(
                          lottieComposition.duration,
                              () {
                            setState(() {
                              isLiked = false;
                            });
                          },
                        );
                      })),
                if (isLiked && isLiked)
                  Center(
                      child: Lottie.asset("assets/lottie/lottie_heart.json",
                          repeat: false, onLoaded: (lottieComposition) {
                            Future.delayed(
                              lottieComposition.duration,
                                  () {
                                setState(() {
                                  isLiked = false;
                                });
                              },
                            );
                          }))
              ],
            ),

            // #footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // #vote and #channel
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.pink,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    title: const Text("My Dogs"),
                    trailing: IconButton(
                      icon: vote == 0
                          ? const Icon(Icons.thumb_up_alt_outlined, size: 30,)
                          : const Icon(Icons.thumb_up_alt, color: Colors.red, size: 30,),
                      onPressed: pressVote,
                    ),
                  ),
                  const SizedBox(height: 10,),

                  // #title
                  Visibility(
                    visible: title.isNotEmpty,
                    child: Text(title, style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  const SizedBox(height: 10,),

                  // #subtitle
                  Visibility(
                    visible: subTitle.isNotEmpty,
                    child: Text(subTitle, style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox.shrink(),
                      ),

                      // #favorite
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: (){

                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: const Color.fromRGBO(239, 239, 239, 1),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          ),
                          child: const Text("Favorite", style: TextStyle(color: Colors.black, fontSize: 17.5, fontWeight: FontWeight.w600),),
                        ),
                      ),
                      const SizedBox(width: 15,),

                      // #save
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveNetworkImage,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.red,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          ),
                          child: const Text("Save", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),),
                        ),
                      ),

                      // #share
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.share, size: 30,),
                          onPressed: share
                        ),
                      ),
                    ],
                  ),


                  // Visibility(
                  //   visible: Provider.of<InternetConnectionStatus>(context) ==
                  //       InternetConnectionStatus.disconnected,
                  //   child: const InternetNotAvailable(),
                  // ),
                  // Provider.of<InternetConnectionStatus>(context) ==
                  //     InternetConnectionStatus.disconnected
                  //     ? Expanded(
                  //   child: Center(
                  //     child: Text(
                  //       'Not connected',
                  //       style: Theme.of(context).textTheme.headline4,
                  //     ),
                  //   ),
                  // )
                  //     : Expanded(
                  //   child: Center(
                  //     child: Text(
                  //       'Connected',
                  //       style: Theme.of(context).textTheme.headline4,
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 20,)
                ],
              ),
            ),
            const SizedBox(height: 2,),

            // #similary
            Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: const Text("Similar", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
                  ),
                  GalleryView(
                    api: NetworkService.API_IMAGE_LIST,
                    crossAxisCount: widget.crossAxisCount,
                    params: NetworkService.paramsImageSearch(size: "small", breedId: image.breedIds,
                      limit: limit,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
