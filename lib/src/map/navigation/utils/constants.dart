class ConstantValues{

   String markerStart = 'markerStart';
   String markerEnd = 'markerEnd';
   String markerTracking = 'markerTracking';

}

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

class NavigationInstructionsImage{
    String startPointImg = 'https://route.naxa.com.np/maps/img/marker-icon-green.png';
    String endPointImg = 'https://route.naxa.com.np/maps/img/marker-icon-red.png';
    String trackingImg = 'https://route.naxa.com.np/maps/img/roundabout.png';
    String keepRightImg = 'https://route.naxa.com.np/maps/img/keep_right.png';
    String roundAboutImg = 'https://route.naxa.com.np/maps/img/roundabout.png';
    String arrivedAtDestinationImg = 'https://route.naxa.com.np/maps/img/marker-icon-red.png';
    String turnSharpRightImg = 'https://route.naxa.com.np/maps/img/sharp_right.png';
    String turnRightImg = 'https://route.naxa.com.np/maps/img/right.png';
    String turnSlightRightImg = 'https://route.naxa.com.np/maps/img/slight_right.png';
    String continueStraightImg = '';
    String keepLeftImg = 'https://route.naxa.com.np/maps/img/keep_left.png';
    String turnSharpLeftImg = 'https://route.naxa.com.np/maps/img/sharp_left.png';
    String turnLeftImg = 'https://route.naxa.com.np/maps/img/left.png';
    String turnSlightLeftImg = 'https://route.naxa.com.np/maps/img/slight_left.png';

    getImageUrlByInstructionType({required int instructionType}){
        String imageUrl = '';
        switch(instructionType){
            case NavigationInstructionsType.arrivedAtDestination:
                imageUrl =  navigationInstructionsImage.arrivedAtDestinationImg;
                break;
            case NavigationInstructionsType.startFromOrigin:
                imageUrl =  navigationInstructionsImage.startPointImg;
                break;
            case NavigationInstructionsType.roundAbout:
                imageUrl =  navigationInstructionsImage.roundAboutImg;
                break;
            case NavigationInstructionsType.continueStraight:
                imageUrl =  navigationInstructionsImage.continueStraightImg;
                break;

            case NavigationInstructionsType.turnSlightLeft:
                imageUrl =  navigationInstructionsImage.turnSlightLeftImg;
                break;
            case NavigationInstructionsType.turnLeft:
                imageUrl =  navigationInstructionsImage.turnLeftImg;
                break;
            case NavigationInstructionsType.turnSharpLeft:
                imageUrl =  navigationInstructionsImage.turnSharpLeftImg;
                break;
            case NavigationInstructionsType.keepLeft:
                imageUrl =  navigationInstructionsImage.keepLeftImg;
                break;

            case NavigationInstructionsType.turnSlightRight:
                imageUrl =  navigationInstructionsImage.turnSlightRightImg;
                break;
            case NavigationInstructionsType.turnRight:
                imageUrl =  navigationInstructionsImage.turnRightImg;
                break;
            case NavigationInstructionsType.turnSharpRight:
                imageUrl =  navigationInstructionsImage.turnSharpRightImg;
                break;
            case NavigationInstructionsType.keepRight:
                imageUrl =  navigationInstructionsImage.keepRightImg;
                break;
            default:
                imageUrl =  navigationInstructionsImage.continueStraightImg;

        }

        return imageUrl;
    }
}

final ConstantValues constantValues = ConstantValues();
final NavigationInstructionsType navigationInstructionsType = NavigationInstructionsType();
final NavigationInstructionsImage navigationInstructionsImage = NavigationInstructionsImage();
