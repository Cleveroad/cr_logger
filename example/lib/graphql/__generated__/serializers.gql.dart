// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' show StandardJsonPlugin;
import 'package:cr_logger_example/graphql/__generated__/schema.schema.gql.dart'
    show
        GCapsulesFind,
        GCoresFind,
        GDate,
        GHistoryFind,
        GLaunchFind,
        GMissionsFind,
        GObjectID,
        GPayloadsFind,
        GShipsFind,
        GString_comparison_exp,
        G_Any,
        Gconflict_action,
        Gfederation__FieldSet,
        Glink__Import,
        Glink__Purpose,
        Gorder_by,
        Gtimestamptz,
        Gtimestamptz_comparison_exp,
        Gusers_aggregate_order_by,
        Gusers_arr_rel_insert_input,
        Gusers_bool_exp,
        Gusers_constraint,
        Gusers_insert_input,
        Gusers_max_order_by,
        Gusers_min_order_by,
        Gusers_obj_rel_insert_input,
        Gusers_on_conflict,
        Gusers_order_by,
        Gusers_select_column,
        Gusers_set_input,
        Gusers_update_column,
        Guuid,
        Guuid_comparison_exp;
import 'package:cr_logger_example/graphql/queries/__generated__/get_launches.data.gql.dart'
    show
        GGetLaunchesData,
        GGetLaunchesData_launches,
        GGetLaunchesData_launches_rocket;
import 'package:cr_logger_example/graphql/queries/__generated__/get_launches.req.gql.dart'
    show GGetLaunchesReq;
import 'package:cr_logger_example/graphql/queries/__generated__/get_launches.var.gql.dart'
    show GGetLaunchesVars;
import 'package:ferry_exec/ferry_exec.dart';
import 'package:gql_code_builder_serializers/gql_code_builder_serializers.dart'
    show OperationSerializer;

part 'serializers.gql.g.dart';

final SerializersBuilder _serializersBuilder = _$serializers.toBuilder()
  ..add(OperationSerializer())
  ..addPlugin(StandardJsonPlugin());
@SerializersFor([
  GCapsulesFind,
  GCoresFind,
  GDate,
  GGetLaunchesData,
  GGetLaunchesData_launches,
  GGetLaunchesData_launches_rocket,
  GGetLaunchesReq,
  GGetLaunchesVars,
  GHistoryFind,
  GLaunchFind,
  GMissionsFind,
  GObjectID,
  GPayloadsFind,
  GShipsFind,
  GString_comparison_exp,
  G_Any,
  Gconflict_action,
  Gfederation__FieldSet,
  Glink__Import,
  Glink__Purpose,
  Gorder_by,
  Gtimestamptz,
  Gtimestamptz_comparison_exp,
  Gusers_aggregate_order_by,
  Gusers_arr_rel_insert_input,
  Gusers_bool_exp,
  Gusers_constraint,
  Gusers_insert_input,
  Gusers_max_order_by,
  Gusers_min_order_by,
  Gusers_obj_rel_insert_input,
  Gusers_on_conflict,
  Gusers_order_by,
  Gusers_select_column,
  Gusers_set_input,
  Gusers_update_column,
  Guuid,
  Guuid_comparison_exp,
])
final Serializers serializers = _serializersBuilder.build();
