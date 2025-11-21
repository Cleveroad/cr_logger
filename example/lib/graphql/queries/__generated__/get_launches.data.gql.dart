// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cr_logger_example/graphql/__generated__/schema.schema.gql.dart'
    as _i2;
import 'package:cr_logger_example/graphql/__generated__/serializers.gql.dart'
    as _i1;

part 'get_launches.data.gql.g.dart';

abstract class GGetLaunchesData
    implements Built<GGetLaunchesData, GGetLaunchesDataBuilder> {
  GGetLaunchesData._();

  factory GGetLaunchesData([void Function(GGetLaunchesDataBuilder b) updates]) =
      _$GGetLaunchesData;

  static void _initializeBuilder(GGetLaunchesDataBuilder b) =>
      b..G__typename = 'Query';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  BuiltList<GGetLaunchesData_launches?>? get launches;
  static Serializer<GGetLaunchesData> get serializer =>
      _$gGetLaunchesDataSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetLaunchesData.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetLaunchesData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetLaunchesData.serializer,
        json,
      );
}

abstract class GGetLaunchesData_launches
    implements
        Built<GGetLaunchesData_launches, GGetLaunchesData_launchesBuilder> {
  GGetLaunchesData_launches._();

  factory GGetLaunchesData_launches(
          [void Function(GGetLaunchesData_launchesBuilder b) updates]) =
      _$GGetLaunchesData_launches;

  static void _initializeBuilder(GGetLaunchesData_launchesBuilder b) =>
      b..G__typename = 'Launch';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  String? get id;
  _i2.GDate? get launch_date_local;
  bool? get upcoming;
  GGetLaunchesData_launches_rocket? get rocket;
  static Serializer<GGetLaunchesData_launches> get serializer =>
      _$gGetLaunchesDataLaunchesSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetLaunchesData_launches.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetLaunchesData_launches? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetLaunchesData_launches.serializer,
        json,
      );
}

abstract class GGetLaunchesData_launches_rocket
    implements
        Built<GGetLaunchesData_launches_rocket,
            GGetLaunchesData_launches_rocketBuilder> {
  GGetLaunchesData_launches_rocket._();

  factory GGetLaunchesData_launches_rocket(
          [void Function(GGetLaunchesData_launches_rocketBuilder b) updates]) =
      _$GGetLaunchesData_launches_rocket;

  static void _initializeBuilder(GGetLaunchesData_launches_rocketBuilder b) =>
      b..G__typename = 'LaunchRocket';

  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  String? get rocket_name;
  String? get rocket_type;
  static Serializer<GGetLaunchesData_launches_rocket> get serializer =>
      _$gGetLaunchesDataLaunchesRocketSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetLaunchesData_launches_rocket.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetLaunchesData_launches_rocket? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetLaunchesData_launches_rocket.serializer,
        json,
      );
}
