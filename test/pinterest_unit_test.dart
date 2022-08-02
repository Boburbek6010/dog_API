import 'package:flutter_test/flutter_test.dart';
import 'package:pinterest_ap/services/network_service.dart';

void main(){
  group("Users", () {
    //users
    // String? getAllUsersResponse;
    // test("test1: Get All Users", () async {
    //   getAllUsersResponse = await NetworkService.GET(NetworkService.API_UN_USER_ME, NetworkService.paramsEmpty());
    //   print(getAllUsersResponse);
    //   expect(getAllUsersResponse, isNotNull);
    // });

    String? userResponse;
    test("test1: User's public profile", () async {
      userResponse = await NetworkService.GET("${NetworkService.API_UN_USER_PROFILE}/bobur", NetworkService.paramsEmpty());
      print(userResponse);
      expect(userResponse, isNotNull);
    });
    
    //photos
    String? getAllPhotosResponse;
    test("test2: Get all photos", () async {
      getAllPhotosResponse = await NetworkService.GET(NetworkService.API_UN_ALL_PHOTO, NetworkService.paramsEmpty());
      expect(getAllPhotosResponse, isNotNull);
    });
    
    //search
    String? searchAllPhotosResponse;
    test("test3: search photos", () async {
      searchAllPhotosResponse = await NetworkService.GET(NetworkService.API_UN_SEARCH_PHOTO, NetworkService.paramsSearchPhoto('laptop'));
      expect(searchAllPhotosResponse, isNotNull);
    });

    String? searchAllCollectionsResponse;
    test("test4: search collections", () async {
      searchAllCollectionsResponse = await NetworkService.GET(NetworkService.API_UN_SEARCH_COLLECTIONS, NetworkService.paramsSearchPhoto('chevrolet'));
      expect(searchAllCollectionsResponse, isNotNull);
    });

    String? searchAllUsersResponse;
    test("test5: search Users", () async {
      searchAllUsersResponse = await NetworkService.GET(NetworkService.API_UN_SEARCH_USERS, NetworkService.paramsSearchPhoto('dog'));
      expect(searchAllUsersResponse, isNotNull);
    });
    
    //collections
    String? listCollectionsResponse;
    test("test6: List Collections", () async {
      listCollectionsResponse = await NetworkService.GET(NetworkService.API_UN_LIST_COLLECTIONS, NetworkService.paramsEmpty());
      expect(listCollectionsResponse, isNotNull);
    });
    
    String? getCollectionsResponse;
    test("test7: get Collections", () async {
      getCollectionsResponse = await NetworkService.GET("${NetworkService.API_UN_LIST_COLLECTIONS}/206", NetworkService.paramsEmpty());
      expect(getCollectionsResponse, isNotNull);
    });
  });
}