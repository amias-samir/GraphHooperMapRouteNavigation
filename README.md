# graphhooper_route_navigation
A new plugin for map route navigation.


## Getting Started

## Introduction
A new plugin for map route navigation. Use Mapbox Map as a base layer & map styles and Graphhooper Map route navigation data for polyline, duration and time and Getx for state managemet. 

## Setting up
### Android
You have to include your mapbox map secret token and access token in order to use the mapbox map.

#### Mapbox Map Secret Token
Include your Mapbox Map Secret token to your gradle.properties. You can get your Mapbox Map secret token from your mapbox account page. It starts with sk.

    MAPBOX_SECRET_TOKEN= YOUR_MAPBOX_SECRET_TOKEN
Also include this line of code in your project level build.gradle file

allprojects {
    repositories {
        google()
        mavenCentral()
        
        // Add this line
        maven {
            url 'https://api.mapbox.com/downloads/v2/releases/maven'
            authentication {
                basic(BasicAuthentication)
            }
            credentials {
                username = "mapbox"
                password = project.hasProperty('MAPBOX_DOWNLOADS_TOKEN') ? project.property('MAPBOX_DOWNLOADS_TOKEN') : System.getenv('MAPBOX_DOWNLOADS_TOKEN')
                if (password == null || password == "") {
                    throw new GradleException("MAPBOX_DOWNLOADS_TOKEN isn't set. Set it to the project properties or to the enviroment variables.")
                }
            }
        }
    }
}
#### Mapbox Map Access Token
Include your Mapbox Map access token to string.xml file of the app/src/main/res/values/ directory of android section It starts with pk.

    <string name="mapbox_access_token">YOUR_MAPBOX_PUBLIC_TOKEN</string>
    
    
  #### And add these permissions to the AndroidManifest.xml and grant location permission 

    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

IOS
This plugin is not available in IOS yet.

## How to use?

## Import package:
```
 import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';
 import 'package:get/get.dart';
 ```


```
MaterialButton(onPressed: () async{
                    ApiRequest apiRequest = ApiRequest();

    DirectionRouteResponse directionRouteResponse = await apiRequest.getDrivingRouteUsingGraphHooper(originLatLng, destinationLatLng, NavigationProfile.car);
    Get.to(MapRouteNavigationScreenPage(directionRouteResponse, mapAccessToken));
              },
                child: Text('Navigate'),
              )
              

