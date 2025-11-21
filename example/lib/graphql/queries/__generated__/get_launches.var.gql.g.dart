// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_launches.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetLaunchesVars> _$gGetLaunchesVarsSerializer =
    new _$GGetLaunchesVarsSerializer();

class _$GGetLaunchesVarsSerializer
    implements StructuredSerializer<GGetLaunchesVars> {
  @override
  final Iterable<Type> types = const [GGetLaunchesVars, _$GGetLaunchesVars];
  @override
  final String wireName = 'GGetLaunchesVars';

  @override
  Iterable<Object?> serialize(Serializers serializers, GGetLaunchesVars object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'limit',
      serializers.serialize(object.limit, specifiedType: const FullType(int)),
      'offset',
      serializers.serialize(object.offset, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  GGetLaunchesVars deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetLaunchesVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'limit':
          result.limit = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'offset':
          result.offset = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetLaunchesVars extends GGetLaunchesVars {
  @override
  final int limit;
  @override
  final int offset;

  factory _$GGetLaunchesVars(
          [void Function(GGetLaunchesVarsBuilder)? updates]) =>
      (new GGetLaunchesVarsBuilder()..update(updates))._build();

  _$GGetLaunchesVars._({required this.limit, required this.offset})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(limit, r'GGetLaunchesVars', 'limit');
    BuiltValueNullFieldError.checkNotNull(
        offset, r'GGetLaunchesVars', 'offset');
  }

  @override
  GGetLaunchesVars rebuild(void Function(GGetLaunchesVarsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetLaunchesVarsBuilder toBuilder() =>
      new GGetLaunchesVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetLaunchesVars &&
        limit == other.limit &&
        offset == other.offset;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetLaunchesVars')
          ..add('limit', limit)
          ..add('offset', offset))
        .toString();
  }
}

class GGetLaunchesVarsBuilder
    implements Builder<GGetLaunchesVars, GGetLaunchesVarsBuilder> {
  _$GGetLaunchesVars? _$v;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  int? _offset;
  int? get offset => _$this._offset;
  set offset(int? offset) => _$this._offset = offset;

  GGetLaunchesVarsBuilder();

  GGetLaunchesVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _limit = $v.limit;
      _offset = $v.offset;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetLaunchesVars other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetLaunchesVars;
  }

  @override
  void update(void Function(GGetLaunchesVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetLaunchesVars build() => _build();

  _$GGetLaunchesVars _build() {
    final _$result = _$v ??
        new _$GGetLaunchesVars._(
          limit: BuiltValueNullFieldError.checkNotNull(
              limit, r'GGetLaunchesVars', 'limit'),
          offset: BuiltValueNullFieldError.checkNotNull(
              offset, r'GGetLaunchesVars', 'offset'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
