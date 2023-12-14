import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:snehal_chavan/Location/model/Data.dart';
class LocationPage extends StatefulWidget {

  const LocationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationPage> createState() => MyLocationPageState();
}


class MyLocationPageState extends State<LocationPage>{
  String? lat;
  String? long;
  @override
  void initState() {
    handleLocationPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Location Tracker"),),
     body: Padding(
       padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
         child: Center(
     child: Column(
     children: [
         Text("LATTITUDE :$lat"),
     Text("LONGITUDE :$long"),
     ElevatedButton(onPressed: () async {
       print("api call");
       apiCall(lat: "18.5204", long:"73.8567");
       await BackgroundLocation.stopLocationService();

     }, child: Text("Get Positions"))

     ],
   ),
    ),

     ),

     );

  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled= await Geolocator.isLocationServiceEnabled();
    getCurrentPositions();
    backgroundLocation();
    if(!serviceEnabled){
      await Geolocator.requestPermission();
      // EasyLoading.showToast("Location Services are disabled , please enable the services.. ");
      return false;
    }
    permission= await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        EasyLoading.showToast("Location Permission Denied..");
        return false;
      }
    }
    if(permission==LocationPermission.deniedForever){
      EasyLoading.showToast("Location permissions are denied permanently , we cannot request the permissions ..");
      return false;
    }
    return true;

  }

  void getCurrentPositions()async{

    final hasPermissions =await handleLocationPermission();

    if(!hasPermissions)return;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  setState(() {
    lat= position.latitude.toString();
    long= position.longitude.toString();
    print("Lattitude:$lat");
    print("Longitude:$long");


  });
  }

  void backgroundLocation(){
    BackgroundLocation.setAndroidNotification(title: 'Location Update',message:'your location is being updated at background : $lat,$long ');
    BackgroundLocation.setAndroidConfiguration(1000);
    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      print("Updating lat --->${location.latitude}");
      print("Updating long --->${location.longitude}");
      setState(() {
        lat=location.latitude.toString();
        long=location.longitude.toString();
      });
    });
  }

  Future<Data> apiCall ({
    required String lat ,required String long,
  }) async {
    Dio dio = Dio();
    var url = "https://machinetest.encureit.com/locationapi.php";
    final String message;
    try {
      var formData=FormData.fromMap({
        'latitude':lat.toString(),
        'longitude':long.toString()});

      var response =await dio.post(url,data: formData);

      message= response.statusMessage!;
      print("message ----?${response}");
      print("formData ----?$formData");

      return Data.fromJson(response);
    } catch (e) {
      print("exc===>$e");
      rethrow;
    }
  }


}

