// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cr_logger_example/graphql/__generated__/serializers.gql.dart'
    as _i1;

part 'get_launches.var.gql.g.dart';

abstract class GGetLaunchesVars
    implements Built<GGetLaunchesVars, GGetLaunchesVarsBuilder> {
  GGetLaunchesVars._();

  factory GGetLaunchesVars([void Function(GGetLaunchesVarsBuilder b) updates]) =
      _$GGetLaunchesVars;

  int get limit;
  int get offset;
  static Serializer<GGetLaunchesVars> get serializer =>
      _$gGetLaunchesVarsSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetLaunchesVars.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetLaunchesVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetLaunchesVars.serializer,
        json,
      );
}
