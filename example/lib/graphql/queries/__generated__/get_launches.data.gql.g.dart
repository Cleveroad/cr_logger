// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_launches.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetLaunchesData> _$gGetLaunchesDataSerializer =
    new _$GGetLaunchesDataSerializer();
Serializer<GGetLaunchesData_launches> _$gGetLaunchesDataLaunchesSerializer =
    new _$GGetLaunchesData_launchesSerializer();
Serializer<GGetLaunchesData_launches_rocket>
    _$gGetLaunchesDataLaunchesRocketSerializer =
    new _$GGetLaunchesData_launches_rocketSerializer();

class _$GGetLaunchesDataSerializer
    implements StructuredSerializer<GGetLaunchesData> {
  @override
  final Iterable<Type> types = const [GGetLaunchesData, _$GGetLaunchesData];
  @override
  final String wireName = 'GGetLaunchesData';

  @override
  Iterable<Object?> serialize(Serializers serializers, GGetLaunchesData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.launches;
    if (value != null) {
      result
        ..add('launches')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList,
                const [const FullType.nullable(GGetLaunchesData_launches)])));
    }
    return result;
  }

  @override
  GGetLaunchesData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetLaunchesDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'launches':
          result.launches.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType.nullable(GGetLaunchesData_launches)
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$GGetLaunchesData_launchesSerializer
    implements StructuredSerializer<GGetLaunchesData_launches> {
  @override
  final Iterable<Type> types = const [
    GGetLaunchesData_launches,
    _$GGetLaunchesData_launches
  ];
  @override
  final String wireName = 'GGetLaunchesData_launches';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GGetLaunchesData_launches object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.launch_date_local;
    if (value != null) {
      result
        ..add('launch_date_local')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(_i2.GDate)));
    }
    value = object.upcoming;
    if (value != null) {
      result
        ..add('upcoming')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.rocket;
    if (value != null) {
      result
        ..add('rocket')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(GGetLaunchesData_launches_rocket)));
    }
    return result;
  }

  @override
  GGetLaunchesData_launches deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetLaunchesData_launchesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'launch_date_local':
          result.launch_date_local.replace(serializers.deserialize(value,
              specifiedType: const FullType(_i2.GDate))! as _i2.GDate);
          break;
        case 'upcoming':
          result.upcoming = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'rocket':
          result.rocket.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(GGetLaunchesData_launches_rocket))!
              as GGetLaunchesData_launches_rocket);
          break;
      }
    }

    return result.build();
  }
}

class _$GGetLaunchesData_launches_rocketSerializer
    implements StructuredSerializer<GGetLaunchesData_launches_rocket> {
  @override
  final Iterable<Type> types = const [
    GGetLaunchesData_launches_rocket,
    _$GGetLaunchesData_launches_rocket
  ];
  @override
  final String wireName = 'GGetLaunchesData_launches_rocket';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GGetLaunchesData_launches_rocket object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.rocket_name;
    if (value != null) {
      result
        ..add('rocket_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.rocket_type;
    if (value != null) {
      result
        ..add('rocket_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  GGetLaunchesData_launches_rocket deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetLaunchesData_launches_rocketBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'rocket_name':
          result.rocket_name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'rocket_type':
          result.rocket_type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetLaunchesData extends GGetLaunchesData {
  @override
  final String G__typename;
  @override
  final BuiltList<GGetLaunchesData_launches?>? launches;

  factory _$GGetLaunchesData(
          [void Function(GGetLaunchesDataBuilder)? updates]) =>
      (new GGetLaunchesDataBuilder()..update(updates))._build();

  _$GGetLaunchesData._({required this.G__typename, this.launches}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GGetLaunchesData', 'G__typename');
  }

  @override
  GGetLaunchesData rebuild(void Function(GGetLaunchesDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetLaunchesDataBuilder toBuilder() =>
      new GGetLaunchesDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetLaunchesData &&
        G__typename == other.G__typename &&
        launches == other.launches;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, launches.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetLaunchesData')
          ..add('G__typename', G__typename)
          ..add('launches', launches))
        .toString();
  }
}

class GGetLaunchesDataBuilder
    implements Builder<GGetLaunchesData, GGetLaunchesDataBuilder> {
  _$GGetLaunchesData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  ListBuilder<GGetLaunchesData_launches?>? _launches;
  ListBuilder<GGetLaunchesData_launches?> get launches =>
      _$this._launches ??= new ListBuilder<GGetLaunchesData_launches?>();
  set launches(ListBuilder<GGetLaunchesData_launches?>? launches) =>
      _$this._launches = launches;

  GGetLaunchesDataBuilder() {
    GGetLaunchesData._initializeBuilder(this);
  }

  GGetLaunchesDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _launches = $v.launches?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetLaunchesData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetLaunchesData;
  }

  @override
  void update(void Function(GGetLaunchesDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetLaunchesData build() => _build();

  _$GGetLaunchesData _build() {
    _$GGetLaunchesData _$result;
    try {
      _$result = _$v ??
          new _$GGetLaunchesData._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
                G__typename, r'GGetLaunchesData', 'G__typename'),
            launches: _launches?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'launches';
        _launches?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GGetLaunchesData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetLaunchesData_launches extends GGetLaunchesData_launches {
  @override
  final String G__typename;
  @override
  final String? id;
  @override
  final _i2.GDate? launch_date_local;
  @override
  final bool? upcoming;
  @override
  final GGetLaunchesData_launches_rocket? rocket;

  factory _$GGetLaunchesData_launches(
          [void Function(GGetLaunchesData_launchesBuilder)? updates]) =>
      (new GGetLaunchesData_launchesBuilder()..update(updates))._build();

  _$GGetLaunchesData_launches._(
      {required this.G__typename,
      this.id,
      this.launch_date_local,
      this.upcoming,
      this.rocket})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GGetLaunchesData_launches', 'G__typename');
  }

  @override
  GGetLaunchesData_launches rebuild(
          void Function(GGetLaunchesData_launchesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetLaunchesData_launchesBuilder toBuilder() =>
      new GGetLaunchesData_launchesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetLaunchesData_launches &&
        G__typename == other.G__typename &&
        id == other.id &&
        launch_date_local == other.launch_date_local &&
        upcoming == other.upcoming &&
        rocket == other.rocket;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, launch_date_local.hashCode);
    _$hash = $jc(_$hash, upcoming.hashCode);
    _$hash = $jc(_$hash, rocket.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetLaunchesData_launches')
          ..add('G__typename', G__typename)
          ..add('id', id)
          ..add('launch_date_local', launch_date_local)
          ..add('upcoming', upcoming)
          ..add('rocket', rocket))
        .toString();
  }
}

class GGetLaunchesData_launchesBuilder
    implements
        Builder<GGetLaunchesData_launches, GGetLaunchesData_launchesBuilder> {
  _$GGetLaunchesData_launches? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  _i2.GDateBuilder? _launch_date_local;
  _i2.GDateBuilder get launch_date_local =>
      _$this._launch_date_local ??= new _i2.GDateBuilder();
  set launch_date_local(_i2.GDateBuilder? launch_date_local) =>
      _$this._launch_date_local = launch_date_local;

  bool? _upcoming;
  bool? get upcoming => _$this._upcoming;
  set upcoming(bool? upcoming) => _$this._upcoming = upcoming;

  GGetLaunchesData_launches_rocketBuilder? _rocket;
  GGetLaunchesData_launches_rocketBuilder get rocket =>
      _$this._rocket ??= new GGetLaunchesData_launches_rocketBuilder();
  set rocket(GGetLaunchesData_launches_rocketBuilder? rocket) =>
      _$this._rocket = rocket;

  GGetLaunchesData_launchesBuilder() {
    GGetLaunchesData_launches._initializeBuilder(this);
  }

  GGetLaunchesData_launchesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _id = $v.id;
      _launch_date_local = $v.launch_date_local?.toBuilder();
      _upcoming = $v.upcoming;
      _rocket = $v.rocket?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetLaunchesData_launches other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetLaunchesData_launches;
  }

  @override
  void update(void Function(GGetLaunchesData_launchesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetLaunchesData_launches build() => _build();

  _$GGetLaunchesData_launches _build() {
    _$GGetLaunchesData_launches _$result;
    try {
      _$result = _$v ??
          new _$GGetLaunchesData_launches._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
                G__typename, r'GGetLaunchesData_launches', 'G__typename'),
            id: id,
            launch_date_local: _launch_date_local?.build(),
            upcoming: upcoming,
            rocket: _rocket?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'launch_date_local';
        _launch_date_local?.build();

        _$failedField = 'rocket';
        _rocket?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GGetLaunchesData_launches', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetLaunchesData_launches_rocket
    extends GGetLaunchesData_launches_rocket {
  @override
  final String G__typename;
  @override
  final String? rocket_name;
  @override
  final String? rocket_type;

  factory _$GGetLaunchesData_launches_rocket(
          [void Function(GGetLaunchesData_launches_rocketBuilder)? updates]) =>
      (new GGetLaunchesData_launches_rocketBuilder()..update(updates))._build();

  _$GGetLaunchesData_launches_rocket._(
      {required this.G__typename, this.rocket_name, this.rocket_type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GGetLaunchesData_launches_rocket', 'G__typename');
  }

  @override
  GGetLaunchesData_launches_rocket rebuild(
          void Function(GGetLaunchesData_launches_rocketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetLaunchesData_launches_rocketBuilder toBuilder() =>
      new GGetLaunchesData_launches_rocketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetLaunchesData_launches_rocket &&
        G__typename == other.G__typename &&
        rocket_name == other.rocket_name &&
        rocket_type == other.rocket_type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, rocket_name.hashCode);
    _$hash = $jc(_$hash, rocket_type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetLaunchesData_launches_rocket')
          ..add('G__typename', G__typename)
          ..add('rocket_name', rocket_name)
          ..add('rocket_type', rocket_type))
        .toString();
  }
}

class GGetLaunchesData_launches_rocketBuilder
    implements
        Builder<GGetLaunchesData_launches_rocket,
            GGetLaunchesData_launches_rocketBuilder> {
  _$GGetLaunchesData_launches_rocket? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  String? _rocket_name;
  String? get rocket_name => _$this._rocket_name;
  set rocket_name(String? rocket_name) => _$this._rocket_name = rocket_name;

  String? _rocket_type;
  String? get rocket_type => _$this._rocket_type;
  set rocket_type(String? rocket_type) => _$this._rocket_type = rocket_type;

  GGetLaunchesData_launches_rocketBuilder() {
    GGetLaunchesData_launches_rocket._initializeBuilder(this);
  }

  GGetLaunchesData_launches_rocketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _rocket_name = $v.rocket_name;
      _rocket_type = $v.rocket_type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetLaunchesData_launches_rocket other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetLaunchesData_launches_rocket;
  }

  @override
  void update(void Function(GGetLaunchesData_launches_rocketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetLaunchesData_launches_rocket build() => _build();

  _$GGetLaunchesData_launches_rocket _build() {
    final _$result = _$v ??
        new _$GGetLaunchesData_launches_rocket._(
          G__typename: BuiltValueNullFieldError.checkNotNull(
              G__typename, r'GGetLaunchesData_launches_rocket', 'G__typename'),
          rocket_name: rocket_name,
          rocket_type: rocket_type,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
