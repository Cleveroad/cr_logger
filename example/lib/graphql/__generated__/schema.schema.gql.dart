// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cr_logger_example/graphql/__generated__/serializers.gql.dart'
    as _i1;
import 'package:gql_code_builder_serializers/gql_code_builder_serializers.dart'
    as _i2;

part 'schema.schema.gql.g.dart';

abstract class GCapsulesFind
    implements Built<GCapsulesFind, GCapsulesFindBuilder> {
  GCapsulesFind._();

  factory GCapsulesFind([void Function(GCapsulesFindBuilder b) updates]) =
      _$GCapsulesFind;

  String? get id;
  int? get landings;
  String? get mission;
  GDate? get original_launch;
  int? get reuse_count;
  String? get status;
  String? get type;
  static Serializer<GCapsulesFind> get serializer => _$gCapsulesFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GCapsulesFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GCapsulesFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GCapsulesFind.serializer,
        json,
      );
}

abstract class GCoresFind implements Built<GCoresFind, GCoresFindBuilder> {
  GCoresFind._();

  factory GCoresFind([void Function(GCoresFindBuilder b) updates]) =
      _$GCoresFind;

  int? get asds_attempts;
  int? get asds_landings;
  int? get block;
  String? get id;
  String? get missions;
  GDate? get original_launch;
  int? get reuse_count;
  int? get rtls_attempts;
  int? get rtls_landings;
  String? get status;
  bool? get water_landing;
  static Serializer<GCoresFind> get serializer => _$gCoresFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GCoresFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GCoresFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GCoresFind.serializer,
        json,
      );
}

abstract class GDate implements Built<GDate, GDateBuilder> {
  GDate._();

  factory GDate([String? value]) =>
      _$GDate((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<GDate> get serializer => _i2.DefaultScalarSerializer<GDate>(
      (Object serialized) => GDate((serialized as String?)));
}

abstract class GHistoryFind
    implements Built<GHistoryFind, GHistoryFindBuilder> {
  GHistoryFind._();

  factory GHistoryFind([void Function(GHistoryFindBuilder b) updates]) =
      _$GHistoryFind;

  GDate? get end;
  int? get flight_number;
  String? get id;
  GDate? get start;
  static Serializer<GHistoryFind> get serializer => _$gHistoryFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GHistoryFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GHistoryFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GHistoryFind.serializer,
        json,
      );
}

abstract class GLaunchFind implements Built<GLaunchFind, GLaunchFindBuilder> {
  GLaunchFind._();

  factory GLaunchFind([void Function(GLaunchFindBuilder b) updates]) =
      _$GLaunchFind;

  double? get apoapsis_km;
  int? get block;
  String? get cap_serial;
  String? get capsule_reuse;
  int? get core_flight;
  String? get core_reuse;
  String? get core_serial;
  String? get customer;
  double? get eccentricity;
  GDate? get end;
  GDate? get epoch;
  String? get fairings_recovered;
  String? get fairings_recovery_attempt;
  String? get fairings_reuse;
  String? get fairings_reused;
  String? get fairings_ship;
  String? get gridfins;
  String? get id;
  double? get inclination_deg;
  String? get land_success;
  String? get landing_intent;
  String? get landing_type;
  String? get landing_vehicle;
  GDate? get launch_date_local;
  GDate? get launch_date_utc;
  String? get launch_success;
  String? get launch_year;
  String? get legs;
  double? get lifespan_years;
  double? get longitude;
  String? get manufacturer;
  double? get mean_motion;
  String? get mission_id;
  String? get mission_name;
  String? get nationality;
  int? get norad_id;
  String? get orbit;
  String? get payload_id;
  String? get payload_type;
  double? get periapsis_km;
  double? get period_min;
  double? get raan;
  String? get reference_system;
  String? get regime;
  String? get reused;
  String? get rocket_id;
  String? get rocket_name;
  String? get rocket_type;
  String? get second_stage_block;
  double? get semi_major_axis_km;
  String? get ship;
  String? get side_core1_reuse;
  String? get side_core2_reuse;
  String? get site_id;
  String? get site_name_long;
  String? get site_name;
  GDate? get start;
  String? get tbd;
  String? get tentative_max_precision;
  String? get tentative;
  static Serializer<GLaunchFind> get serializer => _$gLaunchFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GLaunchFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GLaunchFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GLaunchFind.serializer,
        json,
      );
}

abstract class GMissionsFind
    implements Built<GMissionsFind, GMissionsFindBuilder> {
  GMissionsFind._();

  factory GMissionsFind([void Function(GMissionsFindBuilder b) updates]) =
      _$GMissionsFind;

  String? get id;
  String? get manufacturer;
  String? get name;
  String? get payload_id;
  static Serializer<GMissionsFind> get serializer => _$gMissionsFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GMissionsFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GMissionsFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GMissionsFind.serializer,
        json,
      );
}

abstract class GObjectID implements Built<GObjectID, GObjectIDBuilder> {
  GObjectID._();

  factory GObjectID([String? value]) =>
      _$GObjectID((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<GObjectID> get serializer =>
      _i2.DefaultScalarSerializer<GObjectID>(
          (Object serialized) => GObjectID((serialized as String?)));
}

abstract class GPayloadsFind
    implements Built<GPayloadsFind, GPayloadsFindBuilder> {
  GPayloadsFind._();

  factory GPayloadsFind([void Function(GPayloadsFindBuilder b) updates]) =
      _$GPayloadsFind;

  double? get apoapsis_km;
  String? get customer;
  double? get eccentricity;
  GDate? get epoch;
  double? get inclination_deg;
  double? get lifespan_years;
  double? get longitude;
  String? get manufacturer;
  double? get mean_motion;
  String? get nationality;
  int? get norad_id;
  String? get orbit;
  String? get payload_id;
  String? get payload_type;
  double? get periapsis_km;
  double? get period_min;
  double? get raan;
  String? get reference_system;
  String? get regime;
  bool? get reused;
  double? get semi_major_axis_km;
  static Serializer<GPayloadsFind> get serializer => _$gPayloadsFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GPayloadsFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GPayloadsFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GPayloadsFind.serializer,
        json,
      );
}

abstract class GShipsFind implements Built<GShipsFind, GShipsFindBuilder> {
  GShipsFind._();

  factory GShipsFind([void Function(GShipsFindBuilder b) updates]) =
      _$GShipsFind;

  String? get id;
  String? get name;
  String? get model;
  String? get type;
  String? get role;
  bool? get active;
  int? get imo;
  int? get mmsi;
  int? get abs;
  @BuiltValueField(wireName: 'class')
  int? get Gclass;
  int? get weight_lbs;
  int? get weight_kg;
  int? get year_built;
  String? get home_port;
  String? get status;
  int? get speed_kn;
  int? get course_deg;
  double? get latitude;
  double? get longitude;
  int? get successful_landings;
  int? get attempted_landings;
  String? get mission;
  static Serializer<GShipsFind> get serializer => _$gShipsFindSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GShipsFind.serializer,
        this,
      ) as Map<String, dynamic>);

  static GShipsFind? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GShipsFind.serializer,
        json,
      );
}

abstract class GString_comparison_exp
    implements Built<GString_comparison_exp, GString_comparison_expBuilder> {
  GString_comparison_exp._();

  factory GString_comparison_exp(
          [void Function(GString_comparison_expBuilder b) updates]) =
      _$GString_comparison_exp;

  @BuiltValueField(wireName: '_eq')
  String? get G_eq;
  @BuiltValueField(wireName: '_gt')
  String? get G_gt;
  @BuiltValueField(wireName: '_gte')
  String? get G_gte;
  @BuiltValueField(wireName: '_ilike')
  String? get G_ilike;
  @BuiltValueField(wireName: '_in')
  BuiltList<String>? get G_in;
  @BuiltValueField(wireName: '_is_null')
  bool? get G_is_null;
  @BuiltValueField(wireName: '_like')
  String? get G_like;
  @BuiltValueField(wireName: '_lt')
  String? get G_lt;
  @BuiltValueField(wireName: '_lte')
  String? get G_lte;
  @BuiltValueField(wireName: '_neq')
  String? get G_neq;
  @BuiltValueField(wireName: '_nilike')
  String? get G_nilike;
  @BuiltValueField(wireName: '_nin')
  BuiltList<String>? get G_nin;
  @BuiltValueField(wireName: '_nlike')
  String? get G_nlike;
  @BuiltValueField(wireName: '_nsimilar')
  String? get G_nsimilar;
  @BuiltValueField(wireName: '_similar')
  String? get G_similar;
  static Serializer<GString_comparison_exp> get serializer =>
      _$gStringComparisonExpSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GString_comparison_exp.serializer,
        this,
      ) as Map<String, dynamic>);

  static GString_comparison_exp? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GString_comparison_exp.serializer,
        json,
      );
}

class Gconflict_action extends EnumClass {
  const Gconflict_action._(String name) : super(name);

  static const Gconflict_action ignore = _$gconflictActionignore;

  @BuiltValueEnumConst(wireName: 'update')
  static const Gconflict_action Gupdate = _$gconflictActionGupdate;

  static Serializer<Gconflict_action> get serializer =>
      _$gconflictActionSerializer;

  static BuiltSet<Gconflict_action> get values => _$gconflictActionValues;

  static Gconflict_action valueOf(String name) =>
      _$gconflictActionValueOf(name);
}

class Gorder_by extends EnumClass {
  const Gorder_by._(String name) : super(name);

  static const Gorder_by asc = _$gorderByasc;

  static const Gorder_by asc_nulls_first = _$gorderByasc_nulls_first;

  static const Gorder_by asc_nulls_last = _$gorderByasc_nulls_last;

  static const Gorder_by desc = _$gorderBydesc;

  static const Gorder_by desc_nulls_first = _$gorderBydesc_nulls_first;

  static const Gorder_by desc_nulls_last = _$gorderBydesc_nulls_last;

  static Serializer<Gorder_by> get serializer => _$gorderBySerializer;

  static BuiltSet<Gorder_by> get values => _$gorderByValues;

  static Gorder_by valueOf(String name) => _$gorderByValueOf(name);
}

abstract class Gtimestamptz
    implements Built<Gtimestamptz, GtimestamptzBuilder> {
  Gtimestamptz._();

  factory Gtimestamptz([String? value]) =>
      _$Gtimestamptz((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<Gtimestamptz> get serializer =>
      _i2.DefaultScalarSerializer<Gtimestamptz>(
          (Object serialized) => Gtimestamptz((serialized as String?)));
}

abstract class Gtimestamptz_comparison_exp
    implements
        Built<Gtimestamptz_comparison_exp, Gtimestamptz_comparison_expBuilder> {
  Gtimestamptz_comparison_exp._();

  factory Gtimestamptz_comparison_exp(
          [void Function(Gtimestamptz_comparison_expBuilder b) updates]) =
      _$Gtimestamptz_comparison_exp;

  @BuiltValueField(wireName: '_eq')
  Gtimestamptz? get G_eq;
  @BuiltValueField(wireName: '_gt')
  Gtimestamptz? get G_gt;
  @BuiltValueField(wireName: '_gte')
  Gtimestamptz? get G_gte;
  @BuiltValueField(wireName: '_in')
  BuiltList<Gtimestamptz>? get G_in;
  @BuiltValueField(wireName: '_is_null')
  bool? get G_is_null;
  @BuiltValueField(wireName: '_lt')
  Gtimestamptz? get G_lt;
  @BuiltValueField(wireName: '_lte')
  Gtimestamptz? get G_lte;
  @BuiltValueField(wireName: '_neq')
  Gtimestamptz? get G_neq;
  @BuiltValueField(wireName: '_nin')
  BuiltList<Gtimestamptz>? get G_nin;
  static Serializer<Gtimestamptz_comparison_exp> get serializer =>
      _$gtimestamptzComparisonExpSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gtimestamptz_comparison_exp.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gtimestamptz_comparison_exp? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gtimestamptz_comparison_exp.serializer,
        json,
      );
}

abstract class Gusers_aggregate_order_by
    implements
        Built<Gusers_aggregate_order_by, Gusers_aggregate_order_byBuilder> {
  Gusers_aggregate_order_by._();

  factory Gusers_aggregate_order_by(
          [void Function(Gusers_aggregate_order_byBuilder b) updates]) =
      _$Gusers_aggregate_order_by;

  Gorder_by? get count;
  Gusers_max_order_by? get max;
  Gusers_min_order_by? get min;
  static Serializer<Gusers_aggregate_order_by> get serializer =>
      _$gusersAggregateOrderBySerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_aggregate_order_by.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_aggregate_order_by? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_aggregate_order_by.serializer,
        json,
      );
}

abstract class Gusers_arr_rel_insert_input
    implements
        Built<Gusers_arr_rel_insert_input, Gusers_arr_rel_insert_inputBuilder> {
  Gusers_arr_rel_insert_input._();

  factory Gusers_arr_rel_insert_input(
          [void Function(Gusers_arr_rel_insert_inputBuilder b) updates]) =
      _$Gusers_arr_rel_insert_input;

  BuiltList<Gusers_insert_input> get data;
  Gusers_on_conflict? get on_conflict;
  static Serializer<Gusers_arr_rel_insert_input> get serializer =>
      _$gusersArrRelInsertInputSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_arr_rel_insert_input.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_arr_rel_insert_input? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_arr_rel_insert_input.serializer,
        json,
      );
}

abstract class Gusers_bool_exp
    implements Built<Gusers_bool_exp, Gusers_bool_expBuilder> {
  Gusers_bool_exp._();

  factory Gusers_bool_exp([void Function(Gusers_bool_expBuilder b) updates]) =
      _$Gusers_bool_exp;

  @BuiltValueField(wireName: '_and')
  BuiltList<Gusers_bool_exp?>? get G_and;
  @BuiltValueField(wireName: '_not')
  Gusers_bool_exp? get G_not;
  @BuiltValueField(wireName: '_or')
  BuiltList<Gusers_bool_exp?>? get G_or;
  Guuid_comparison_exp? get id;
  GString_comparison_exp? get name;
  GString_comparison_exp? get rocket;
  Gtimestamptz_comparison_exp? get timestamp;
  GString_comparison_exp? get twitter;
  static Serializer<Gusers_bool_exp> get serializer =>
      _$gusersBoolExpSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_bool_exp.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_bool_exp? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_bool_exp.serializer,
        json,
      );
}

class Gusers_constraint extends EnumClass {
  const Gusers_constraint._(String name) : super(name);

  static const Gusers_constraint unique = _$gusersConstraintunique;

  static const Gusers_constraint or = _$gusersConstraintor;

  static const Gusers_constraint primary = _$gusersConstraintprimary;

  static const Gusers_constraint key = _$gusersConstraintkey;

  static const Gusers_constraint constraint = _$gusersConstraintconstraint;

  static const Gusers_constraint users_pkey = _$gusersConstraintusers_pkey;

  static Serializer<Gusers_constraint> get serializer =>
      _$gusersConstraintSerializer;

  static BuiltSet<Gusers_constraint> get values => _$gusersConstraintValues;

  static Gusers_constraint valueOf(String name) =>
      _$gusersConstraintValueOf(name);
}

abstract class Gusers_insert_input
    implements Built<Gusers_insert_input, Gusers_insert_inputBuilder> {
  Gusers_insert_input._();

  factory Gusers_insert_input(
          [void Function(Gusers_insert_inputBuilder b) updates]) =
      _$Gusers_insert_input;

  Guuid? get id;
  String? get name;
  String? get rocket;
  Gtimestamptz? get timestamp;
  String? get twitter;
  static Serializer<Gusers_insert_input> get serializer =>
      _$gusersInsertInputSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_insert_input.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_insert_input? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_insert_input.serializer,
        json,
      );
}

abstract class Gusers_max_order_by
    implements Built<Gusers_max_order_by, Gusers_max_order_byBuilder> {
  Gusers_max_order_by._();

  factory Gusers_max_order_by(
          [void Function(Gusers_max_order_byBuilder b) updates]) =
      _$Gusers_max_order_by;

  Gorder_by? get name;
  Gorder_by? get rocket;
  Gorder_by? get timestamp;
  Gorder_by? get twitter;
  static Serializer<Gusers_max_order_by> get serializer =>
      _$gusersMaxOrderBySerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_max_order_by.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_max_order_by? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_max_order_by.serializer,
        json,
      );
}

abstract class Gusers_min_order_by
    implements Built<Gusers_min_order_by, Gusers_min_order_byBuilder> {
  Gusers_min_order_by._();

  factory Gusers_min_order_by(
          [void Function(Gusers_min_order_byBuilder b) updates]) =
      _$Gusers_min_order_by;

  Gorder_by? get name;
  Gorder_by? get rocket;
  Gorder_by? get timestamp;
  Gorder_by? get twitter;
  static Serializer<Gusers_min_order_by> get serializer =>
      _$gusersMinOrderBySerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_min_order_by.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_min_order_by? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_min_order_by.serializer,
        json,
      );
}

abstract class Gusers_obj_rel_insert_input
    implements
        Built<Gusers_obj_rel_insert_input, Gusers_obj_rel_insert_inputBuilder> {
  Gusers_obj_rel_insert_input._();

  factory Gusers_obj_rel_insert_input(
          [void Function(Gusers_obj_rel_insert_inputBuilder b) updates]) =
      _$Gusers_obj_rel_insert_input;

  Gusers_insert_input get data;
  Gusers_on_conflict? get on_conflict;
  static Serializer<Gusers_obj_rel_insert_input> get serializer =>
      _$gusersObjRelInsertInputSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_obj_rel_insert_input.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_obj_rel_insert_input? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_obj_rel_insert_input.serializer,
        json,
      );
}

abstract class Gusers_on_conflict
    implements Built<Gusers_on_conflict, Gusers_on_conflictBuilder> {
  Gusers_on_conflict._();

  factory Gusers_on_conflict(
          [void Function(Gusers_on_conflictBuilder b) updates]) =
      _$Gusers_on_conflict;

  Gusers_constraint get constraint;
  BuiltList<Gusers_update_column> get update_columns;
  static Serializer<Gusers_on_conflict> get serializer =>
      _$gusersOnConflictSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_on_conflict.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_on_conflict? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_on_conflict.serializer,
        json,
      );
}

abstract class Gusers_order_by
    implements Built<Gusers_order_by, Gusers_order_byBuilder> {
  Gusers_order_by._();

  factory Gusers_order_by([void Function(Gusers_order_byBuilder b) updates]) =
      _$Gusers_order_by;

  Gorder_by? get id;
  Gorder_by? get name;
  Gorder_by? get rocket;
  Gorder_by? get timestamp;
  Gorder_by? get twitter;
  static Serializer<Gusers_order_by> get serializer =>
      _$gusersOrderBySerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_order_by.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_order_by? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_order_by.serializer,
        json,
      );
}

class Gusers_select_column extends EnumClass {
  const Gusers_select_column._(String name) : super(name);

  static const Gusers_select_column column = _$gusersSelectColumncolumn;

  @BuiltValueEnumConst(wireName: 'name')
  static const Gusers_select_column Gname = _$gusersSelectColumnGname;

  static const Gusers_select_column id = _$gusersSelectColumnid;

  static const Gusers_select_column rocket = _$gusersSelectColumnrocket;

  static const Gusers_select_column timestamp = _$gusersSelectColumntimestamp;

  static const Gusers_select_column twitter = _$gusersSelectColumntwitter;

  static Serializer<Gusers_select_column> get serializer =>
      _$gusersSelectColumnSerializer;

  static BuiltSet<Gusers_select_column> get values =>
      _$gusersSelectColumnValues;

  static Gusers_select_column valueOf(String name) =>
      _$gusersSelectColumnValueOf(name);
}

abstract class Gusers_set_input
    implements Built<Gusers_set_input, Gusers_set_inputBuilder> {
  Gusers_set_input._();

  factory Gusers_set_input([void Function(Gusers_set_inputBuilder b) updates]) =
      _$Gusers_set_input;

  Guuid? get id;
  String? get name;
  String? get rocket;
  Gtimestamptz? get timestamp;
  String? get twitter;
  static Serializer<Gusers_set_input> get serializer =>
      _$gusersSetInputSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Gusers_set_input.serializer,
        this,
      ) as Map<String, dynamic>);

  static Gusers_set_input? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Gusers_set_input.serializer,
        json,
      );
}

class Gusers_update_column extends EnumClass {
  const Gusers_update_column._(String name) : super(name);

  static const Gusers_update_column column = _$gusersUpdateColumncolumn;

  @BuiltValueEnumConst(wireName: 'name')
  static const Gusers_update_column Gname = _$gusersUpdateColumnGname;

  static const Gusers_update_column id = _$gusersUpdateColumnid;

  static const Gusers_update_column rocket = _$gusersUpdateColumnrocket;

  static const Gusers_update_column timestamp = _$gusersUpdateColumntimestamp;

  static const Gusers_update_column twitter = _$gusersUpdateColumntwitter;

  static Serializer<Gusers_update_column> get serializer =>
      _$gusersUpdateColumnSerializer;

  static BuiltSet<Gusers_update_column> get values =>
      _$gusersUpdateColumnValues;

  static Gusers_update_column valueOf(String name) =>
      _$gusersUpdateColumnValueOf(name);
}

abstract class Guuid implements Built<Guuid, GuuidBuilder> {
  Guuid._();

  factory Guuid([String? value]) =>
      _$Guuid((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<Guuid> get serializer => _i2.DefaultScalarSerializer<Guuid>(
      (Object serialized) => Guuid((serialized as String?)));
}

abstract class Guuid_comparison_exp
    implements Built<Guuid_comparison_exp, Guuid_comparison_expBuilder> {
  Guuid_comparison_exp._();

  factory Guuid_comparison_exp(
          [void Function(Guuid_comparison_expBuilder b) updates]) =
      _$Guuid_comparison_exp;

  @BuiltValueField(wireName: '_eq')
  Guuid? get G_eq;
  @BuiltValueField(wireName: '_gt')
  Guuid? get G_gt;
  @BuiltValueField(wireName: '_gte')
  Guuid? get G_gte;
  @BuiltValueField(wireName: '_in')
  BuiltList<Guuid>? get G_in;
  @BuiltValueField(wireName: '_is_null')
  bool? get G_is_null;
  @BuiltValueField(wireName: '_lt')
  Guuid? get G_lt;
  @BuiltValueField(wireName: '_lte')
  Guuid? get G_lte;
  @BuiltValueField(wireName: '_neq')
  Guuid? get G_neq;
  @BuiltValueField(wireName: '_nin')
  BuiltList<Guuid>? get G_nin;
  static Serializer<Guuid_comparison_exp> get serializer =>
      _$guuidComparisonExpSerializer;

  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        Guuid_comparison_exp.serializer,
        this,
      ) as Map<String, dynamic>);

  static Guuid_comparison_exp? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        Guuid_comparison_exp.serializer,
        json,
      );
}

class Glink__Purpose extends EnumClass {
  const Glink__Purpose._(String name) : super(name);

  static const Glink__Purpose SECURITY = _$glinkPurposeSECURITY;

  static const Glink__Purpose EXECUTION = _$glinkPurposeEXECUTION;

  static Serializer<Glink__Purpose> get serializer => _$glinkPurposeSerializer;

  static BuiltSet<Glink__Purpose> get values => _$glinkPurposeValues;

  static Glink__Purpose valueOf(String name) => _$glinkPurposeValueOf(name);
}

abstract class Glink__Import
    implements Built<Glink__Import, Glink__ImportBuilder> {
  Glink__Import._();

  factory Glink__Import([String? value]) =>
      _$Glink__Import((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<Glink__Import> get serializer =>
      _i2.DefaultScalarSerializer<Glink__Import>(
          (Object serialized) => Glink__Import((serialized as String?)));
}

abstract class Gfederation__FieldSet
    implements Built<Gfederation__FieldSet, Gfederation__FieldSetBuilder> {
  Gfederation__FieldSet._();

  factory Gfederation__FieldSet([String? value]) =>
      _$Gfederation__FieldSet((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<Gfederation__FieldSet> get serializer =>
      _i2.DefaultScalarSerializer<Gfederation__FieldSet>((Object serialized) =>
          Gfederation__FieldSet((serialized as String?)));
}

abstract class G_Any implements Built<G_Any, G_AnyBuilder> {
  G_Any._();

  factory G_Any([String? value]) =>
      _$G_Any((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<G_Any> get serializer => _i2.DefaultScalarSerializer<G_Any>(
      (Object serialized) => G_Any((serialized as String?)));
}

const Map<String, Set<String>> possibleTypesMap = {};
