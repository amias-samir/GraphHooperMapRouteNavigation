import 'package:dartz/dartz.dart';
import 'package:graphhooper_route_navigation/core/exceptions/app_exception.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';

typedef EitherDirectionResponseOrException
    = Either<AppException, DirectionRouteResponse>;
