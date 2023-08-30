import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';



class NavigationInstructionsType{
    static const int keepRight = 7;
    static const int roundAbout = 6;
    static const int arrivedAtDestination = 4;
    static const int startFromOrigin = 10;
    static const int turnSharpRight = 3;
    static const int turnRight = 2;
    static const int turnSlightRight = 1;
    static const int continueStraight = 0;
    static const int keepLeft = -7;
    static const int turnSharpLeft = -3;
    static const int turnLeft = -2;
    static const int turnSlightLeft = -1;
}

getDirectionIconByInstructionType({required int instructionType}){
    Widget  directionIcon = const SizedBox();
    switch(instructionType){
        case NavigationInstructionsType.arrivedAtDestination:
            directionIcon =  getIconWidget(Icons.location_on, iconColor: NavigationColors.red);
            break;
        case NavigationInstructionsType.startFromOrigin:
            directionIcon =  getIconWidget(Icons.location_on, iconColor: NavigationColors.green);
            break;
        case NavigationInstructionsType.roundAbout:
            directionIcon =  getIconWidget(Icons.circle_outlined, size: 35);
            break;
        case NavigationInstructionsType.continueStraight:
            directionIcon =  getIconWidget(Icons.swipe_up_alt_outlined);
            break;

        case NavigationInstructionsType.turnSlightLeft:
            directionIcon =  getIconWidget(Icons.turn_slight_left);
            break;
        case NavigationInstructionsType.turnLeft:
            directionIcon =  getIconWidget(Icons.turn_left);
            break;
        case NavigationInstructionsType.turnSharpLeft:
            directionIcon =  getIconWidget(Icons.turn_sharp_left);
            break;
        case NavigationInstructionsType.keepLeft:
            directionIcon =  getKeepMovingWidget(isKeepMovingLeft: true);
            break;

        case NavigationInstructionsType.turnSlightRight:
            directionIcon =  getIconWidget(Icons.turn_slight_right);
            break;
        case NavigationInstructionsType.turnRight:
            directionIcon =  getIconWidget(Icons.turn_right);
            break;
        case NavigationInstructionsType.turnSharpRight:
            directionIcon =  getIconWidget(Icons.turn_sharp_right);
            break;
        case NavigationInstructionsType.keepRight:
            directionIcon = getKeepMovingWidget(isKeepMovingLeft: false);
            break;
        default:
            directionIcon =  getIconWidget(Icons.swipe_up_alt_outlined);

    }

    return directionIcon;
}

getKeepMovingWidget({bool isKeepMovingLeft = true}){

    if(isKeepMovingLeft){
        return Stack(
            children:  [

                Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 12),
                    child: Icon(Icons.turn_slight_right, color: Colors.grey.shade400, size: 35,),
                ),
                Icon(Icons.turn_slight_left_outlined, color: Colors.grey.shade700, size: 45,),
            ],
        );
    }

    return Stack(
        children:  [
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(Icons.turn_slight_left, color: Colors.grey.shade400, size: 35,),
            ),
            Padding(
                padding: const EdgeInsets.only( left: 2.0),
                child: Icon(Icons.turn_slight_right_outlined, color: Colors.grey.shade700, size: 45,),
            ),
        ],
    );
}

getIconWidget(IconData icon, {Color? iconColor, double size = 45}){

    return Padding(
                padding: const EdgeInsets.only( left: 2.0),
                child: Icon(icon, color: iconColor ?? Colors.grey.shade700, size: size,),
            );
}

final NavigationInstructionsType navigationInstructionsType = NavigationInstructionsType();
