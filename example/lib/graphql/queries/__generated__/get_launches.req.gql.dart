// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cr_logger_example/graphql/__generated__/serializers.gql.dart'
    as _i6;
import 'package:cr_logger_example/graphql/queries/__generated__/get_launches.ast.gql.dart'
    as _i5;
import 'package:cr_logger_example/graphql/queries/__generated__/get_launches.data.gql.dart'
    as _i2;
import 'package:cr_logger_example/graphql/queries/__generated__/get_launches.var.gql.dart'
    as _i3;
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gql_exec/gql_exec.dart' as _i4;

part 'get_launches.req.gql.g.dart';

abstract class GGetLaunchesReq
    implements
        Built<GGetLaunchesReq, GGetLaunchesReqBuilder>,
        _i1.OperationRequest<_i2.GGetLaunchesData, _i3.GGetLaunchesVars> {
  GGetLaunchesReq._();

  factory GGetLaunchesReq([void Function(GGetLaunchesReqBuilder b) updates]) =
      _$GGetLaunchesReq;

  static void _initializeBuilder(GGetLaunchesReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'GetLaunches',
    )
    ..executeOnListen = true;

  @override
  _i3.GGetLaunchesVars get vars;
  @override
  _i4.Operation get operation;
  @override
  _i4.Request get execRequest => _i4.Request(
        operation: operation,
        variables: vars.toJson(),
        context: context ?? const _i4.Context(),
      );

  @override
  String? get requestId;
  @override
  @BuiltValueField(serialize: false)
  _i2.GGetLaunchesData? Function(
    _i2.GGetLaunchesData?,
    _i2.GGetLaunchesData?,
  )? get updateResult;
  @override
  _i2.GGetLaunchesData? get optimisticResponse;
  @override
  String? get updateCacheHandlerKey;
  @override
  Map<String, dynamic>? get updateCacheHandlerContext;
  @override
  _i1.FetchPolicy? get fetchPolicy;
  @override
  bool get executeOnListen;
  @override
  @BuiltValueField(serialize: false)
  _i4.Context? get context;
  @override
  _i2.GGetLaunchesData? parseData(Map<String, dynamic> json) =>
      _i2.GGetLaunchesData.fromJson(json);

  @override
  Map<String, dynamic> varsToJson() => vars.toJson();

  @override
  Map<String, dynamic> dataToJson(_i2.GGetLaunchesData data) => data.toJson();

  @override
  _i1.OperationRequest<_i2.GGetLaunchesData, _i3.GGetLaunchesVars>
      transformOperation(_i4.Operation Function(_i4.Operation) transform) =>
          this.rebuild((b) => b..operation = transform(operation));

  static Serializer<GGetLaunchesReq> get serializer =>
      _$gGetLaunchesReqSerializer;

  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GGetLaunchesReq.serializer,
        this,
      ) as Map<String, dynamic>);

  static GGetLaunchesReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GGetLaunchesReq.serializer,
        json,
      );
}
