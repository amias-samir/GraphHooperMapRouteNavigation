# graphhooper_route_navigation
A new plugin for map route navigation.


## Getting Started

## Introduction
A new plugin for map route navigation. Use Maplibre Map as a base layer & map styles and Graphhooper Map route navigation data for polyline, duration and time and Getx for state managemet. 

## Setting up
### Android 
  #### Add these permissions to the AndroidManifest.xml and grant location permission 
Add the ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION permission in the application manifest android/app/src/main/AndroidManifest.xml to enable location features in an Android application:

    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

IOS
This plugin is yet to test on iOS device.

## How to use?

## Import package:
```
 import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
 ```


```
MaterialButton(
    onPressed: () async{
        ApiRequest apiRequest = ApiRequest();

        DirectionRouteResponse directionRouteResponse = await apiRequest
                                                              .getDrivingRouteUsingGraphHooper(
                                                                source: userLocation!.position,
                                                                destination: latLng,
                                                                //optional [customBaseUrl]
                                                                customBaseUrl:dotenv.env["CUSTOM_BASE_URL"] ,
                                                                navigationType: NavigationProfile.car,
                                                                // api key is optional if you use your own custom url
                                                                // if you are using graphhooper map routing service then [graphHooperApiKey] is needed to fetch route data                                                                                    graphHooperApiKey: dotenv.env["API_KEY"] ?? "Your GraphHooper API key"
                                                            );
                   
                    Navigator.push(context, MaterialPageRoute( builder: (context) => NavigationWrapperScreen(
                            directionRouteResponse: directionRouteResponse),));
              },
   child: Text('Navigate'),
)
```
<p float="middle">  
<img src="https://user-images.githubusercontent.com/17323912/209923884-2c939623-a9f2-4572-a793-4d64b09664e6.jpg" width=20% height=20%>
<img src="https://user-images.githubusercontent.com/17323912/209923878-47670cb5-eb20-472c-b43f-4bab71358aa6.jpg" width=20% height=20%>
<img src="https://user-images.githubusercontent.com/17323912/209923880-393e4e23-f976-45bb-b37a-e893e30af802.jpg" width=20% height=20%>
    <img src="https://user-images.githubusercontent.com/17323912/209923874-a5d19b57-601e-4109-940c-69175e48c84e.jpg" width=20% height=20%>
</p>
