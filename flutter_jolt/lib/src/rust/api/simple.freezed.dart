// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JoltError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? stack) evalError,
    required TResult Function(String field0) conversionError,
    required TResult Function(String field0) runtimeError,
    required TResult Function(String field0) functionNotFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? stack)? evalError,
    TResult? Function(String field0)? conversionError,
    TResult? Function(String field0)? runtimeError,
    TResult? Function(String field0)? functionNotFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? stack)? evalError,
    TResult Function(String field0)? conversionError,
    TResult Function(String field0)? runtimeError,
    TResult Function(String field0)? functionNotFound,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JoltError_EvalError value) evalError,
    required TResult Function(JoltError_ConversionError value) conversionError,
    required TResult Function(JoltError_RuntimeError value) runtimeError,
    required TResult Function(JoltError_FunctionNotFound value)
    functionNotFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JoltError_EvalError value)? evalError,
    TResult? Function(JoltError_ConversionError value)? conversionError,
    TResult? Function(JoltError_RuntimeError value)? runtimeError,
    TResult? Function(JoltError_FunctionNotFound value)? functionNotFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JoltError_EvalError value)? evalError,
    TResult Function(JoltError_ConversionError value)? conversionError,
    TResult Function(JoltError_RuntimeError value)? runtimeError,
    TResult Function(JoltError_FunctionNotFound value)? functionNotFound,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoltErrorCopyWith<$Res> {
  factory $JoltErrorCopyWith(JoltError value, $Res Function(JoltError) then) =
      _$JoltErrorCopyWithImpl<$Res, JoltError>;
}

/// @nodoc
class _$JoltErrorCopyWithImpl<$Res, $Val extends JoltError>
    implements $JoltErrorCopyWith<$Res> {
  _$JoltErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$JoltError_EvalErrorImplCopyWith<$Res> {
  factory _$$JoltError_EvalErrorImplCopyWith(
    _$JoltError_EvalErrorImpl value,
    $Res Function(_$JoltError_EvalErrorImpl) then,
  ) = __$$JoltError_EvalErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? stack});
}

/// @nodoc
class __$$JoltError_EvalErrorImplCopyWithImpl<$Res>
    extends _$JoltErrorCopyWithImpl<$Res, _$JoltError_EvalErrorImpl>
    implements _$$JoltError_EvalErrorImplCopyWith<$Res> {
  __$$JoltError_EvalErrorImplCopyWithImpl(
    _$JoltError_EvalErrorImpl _value,
    $Res Function(_$JoltError_EvalErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? stack = freezed}) {
    return _then(
      _$JoltError_EvalErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        stack: freezed == stack
            ? _value.stack
            : stack // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$JoltError_EvalErrorImpl extends JoltError_EvalError {
  const _$JoltError_EvalErrorImpl({required this.message, this.stack})
    : super._();

  @override
  final String message;
  @override
  final String? stack;

  @override
  String toString() {
    return 'JoltError.evalError(message: $message, stack: $stack)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoltError_EvalErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.stack, stack) || other.stack == stack));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, stack);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoltError_EvalErrorImplCopyWith<_$JoltError_EvalErrorImpl> get copyWith =>
      __$$JoltError_EvalErrorImplCopyWithImpl<_$JoltError_EvalErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? stack) evalError,
    required TResult Function(String field0) conversionError,
    required TResult Function(String field0) runtimeError,
    required TResult Function(String field0) functionNotFound,
  }) {
    return evalError(message, stack);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? stack)? evalError,
    TResult? Function(String field0)? conversionError,
    TResult? Function(String field0)? runtimeError,
    TResult? Function(String field0)? functionNotFound,
  }) {
    return evalError?.call(message, stack);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? stack)? evalError,
    TResult Function(String field0)? conversionError,
    TResult Function(String field0)? runtimeError,
    TResult Function(String field0)? functionNotFound,
    required TResult orElse(),
  }) {
    if (evalError != null) {
      return evalError(message, stack);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JoltError_EvalError value) evalError,
    required TResult Function(JoltError_ConversionError value) conversionError,
    required TResult Function(JoltError_RuntimeError value) runtimeError,
    required TResult Function(JoltError_FunctionNotFound value)
    functionNotFound,
  }) {
    return evalError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JoltError_EvalError value)? evalError,
    TResult? Function(JoltError_ConversionError value)? conversionError,
    TResult? Function(JoltError_RuntimeError value)? runtimeError,
    TResult? Function(JoltError_FunctionNotFound value)? functionNotFound,
  }) {
    return evalError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JoltError_EvalError value)? evalError,
    TResult Function(JoltError_ConversionError value)? conversionError,
    TResult Function(JoltError_RuntimeError value)? runtimeError,
    TResult Function(JoltError_FunctionNotFound value)? functionNotFound,
    required TResult orElse(),
  }) {
    if (evalError != null) {
      return evalError(this);
    }
    return orElse();
  }
}

abstract class JoltError_EvalError extends JoltError {
  const factory JoltError_EvalError({
    required final String message,
    final String? stack,
  }) = _$JoltError_EvalErrorImpl;
  const JoltError_EvalError._() : super._();

  String get message;
  String? get stack;

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoltError_EvalErrorImplCopyWith<_$JoltError_EvalErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JoltError_ConversionErrorImplCopyWith<$Res> {
  factory _$$JoltError_ConversionErrorImplCopyWith(
    _$JoltError_ConversionErrorImpl value,
    $Res Function(_$JoltError_ConversionErrorImpl) then,
  ) = __$$JoltError_ConversionErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$JoltError_ConversionErrorImplCopyWithImpl<$Res>
    extends _$JoltErrorCopyWithImpl<$Res, _$JoltError_ConversionErrorImpl>
    implements _$$JoltError_ConversionErrorImplCopyWith<$Res> {
  __$$JoltError_ConversionErrorImplCopyWithImpl(
    _$JoltError_ConversionErrorImpl _value,
    $Res Function(_$JoltError_ConversionErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JoltError_ConversionErrorImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JoltError_ConversionErrorImpl extends JoltError_ConversionError {
  const _$JoltError_ConversionErrorImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'JoltError.conversionError(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoltError_ConversionErrorImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoltError_ConversionErrorImplCopyWith<_$JoltError_ConversionErrorImpl>
  get copyWith =>
      __$$JoltError_ConversionErrorImplCopyWithImpl<
        _$JoltError_ConversionErrorImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? stack) evalError,
    required TResult Function(String field0) conversionError,
    required TResult Function(String field0) runtimeError,
    required TResult Function(String field0) functionNotFound,
  }) {
    return conversionError(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? stack)? evalError,
    TResult? Function(String field0)? conversionError,
    TResult? Function(String field0)? runtimeError,
    TResult? Function(String field0)? functionNotFound,
  }) {
    return conversionError?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? stack)? evalError,
    TResult Function(String field0)? conversionError,
    TResult Function(String field0)? runtimeError,
    TResult Function(String field0)? functionNotFound,
    required TResult orElse(),
  }) {
    if (conversionError != null) {
      return conversionError(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JoltError_EvalError value) evalError,
    required TResult Function(JoltError_ConversionError value) conversionError,
    required TResult Function(JoltError_RuntimeError value) runtimeError,
    required TResult Function(JoltError_FunctionNotFound value)
    functionNotFound,
  }) {
    return conversionError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JoltError_EvalError value)? evalError,
    TResult? Function(JoltError_ConversionError value)? conversionError,
    TResult? Function(JoltError_RuntimeError value)? runtimeError,
    TResult? Function(JoltError_FunctionNotFound value)? functionNotFound,
  }) {
    return conversionError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JoltError_EvalError value)? evalError,
    TResult Function(JoltError_ConversionError value)? conversionError,
    TResult Function(JoltError_RuntimeError value)? runtimeError,
    TResult Function(JoltError_FunctionNotFound value)? functionNotFound,
    required TResult orElse(),
  }) {
    if (conversionError != null) {
      return conversionError(this);
    }
    return orElse();
  }
}

abstract class JoltError_ConversionError extends JoltError {
  const factory JoltError_ConversionError(final String field0) =
      _$JoltError_ConversionErrorImpl;
  const JoltError_ConversionError._() : super._();

  String get field0;

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoltError_ConversionErrorImplCopyWith<_$JoltError_ConversionErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JoltError_RuntimeErrorImplCopyWith<$Res> {
  factory _$$JoltError_RuntimeErrorImplCopyWith(
    _$JoltError_RuntimeErrorImpl value,
    $Res Function(_$JoltError_RuntimeErrorImpl) then,
  ) = __$$JoltError_RuntimeErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$JoltError_RuntimeErrorImplCopyWithImpl<$Res>
    extends _$JoltErrorCopyWithImpl<$Res, _$JoltError_RuntimeErrorImpl>
    implements _$$JoltError_RuntimeErrorImplCopyWith<$Res> {
  __$$JoltError_RuntimeErrorImplCopyWithImpl(
    _$JoltError_RuntimeErrorImpl _value,
    $Res Function(_$JoltError_RuntimeErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JoltError_RuntimeErrorImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JoltError_RuntimeErrorImpl extends JoltError_RuntimeError {
  const _$JoltError_RuntimeErrorImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'JoltError.runtimeError(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoltError_RuntimeErrorImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoltError_RuntimeErrorImplCopyWith<_$JoltError_RuntimeErrorImpl>
  get copyWith =>
      __$$JoltError_RuntimeErrorImplCopyWithImpl<_$JoltError_RuntimeErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? stack) evalError,
    required TResult Function(String field0) conversionError,
    required TResult Function(String field0) runtimeError,
    required TResult Function(String field0) functionNotFound,
  }) {
    return runtimeError(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? stack)? evalError,
    TResult? Function(String field0)? conversionError,
    TResult? Function(String field0)? runtimeError,
    TResult? Function(String field0)? functionNotFound,
  }) {
    return runtimeError?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? stack)? evalError,
    TResult Function(String field0)? conversionError,
    TResult Function(String field0)? runtimeError,
    TResult Function(String field0)? functionNotFound,
    required TResult orElse(),
  }) {
    if (runtimeError != null) {
      return runtimeError(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JoltError_EvalError value) evalError,
    required TResult Function(JoltError_ConversionError value) conversionError,
    required TResult Function(JoltError_RuntimeError value) runtimeError,
    required TResult Function(JoltError_FunctionNotFound value)
    functionNotFound,
  }) {
    return runtimeError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JoltError_EvalError value)? evalError,
    TResult? Function(JoltError_ConversionError value)? conversionError,
    TResult? Function(JoltError_RuntimeError value)? runtimeError,
    TResult? Function(JoltError_FunctionNotFound value)? functionNotFound,
  }) {
    return runtimeError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JoltError_EvalError value)? evalError,
    TResult Function(JoltError_ConversionError value)? conversionError,
    TResult Function(JoltError_RuntimeError value)? runtimeError,
    TResult Function(JoltError_FunctionNotFound value)? functionNotFound,
    required TResult orElse(),
  }) {
    if (runtimeError != null) {
      return runtimeError(this);
    }
    return orElse();
  }
}

abstract class JoltError_RuntimeError extends JoltError {
  const factory JoltError_RuntimeError(final String field0) =
      _$JoltError_RuntimeErrorImpl;
  const JoltError_RuntimeError._() : super._();

  String get field0;

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoltError_RuntimeErrorImplCopyWith<_$JoltError_RuntimeErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JoltError_FunctionNotFoundImplCopyWith<$Res> {
  factory _$$JoltError_FunctionNotFoundImplCopyWith(
    _$JoltError_FunctionNotFoundImpl value,
    $Res Function(_$JoltError_FunctionNotFoundImpl) then,
  ) = __$$JoltError_FunctionNotFoundImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$JoltError_FunctionNotFoundImplCopyWithImpl<$Res>
    extends _$JoltErrorCopyWithImpl<$Res, _$JoltError_FunctionNotFoundImpl>
    implements _$$JoltError_FunctionNotFoundImplCopyWith<$Res> {
  __$$JoltError_FunctionNotFoundImplCopyWithImpl(
    _$JoltError_FunctionNotFoundImpl _value,
    $Res Function(_$JoltError_FunctionNotFoundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JoltError_FunctionNotFoundImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JoltError_FunctionNotFoundImpl extends JoltError_FunctionNotFound {
  const _$JoltError_FunctionNotFoundImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'JoltError.functionNotFound(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoltError_FunctionNotFoundImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoltError_FunctionNotFoundImplCopyWith<_$JoltError_FunctionNotFoundImpl>
  get copyWith =>
      __$$JoltError_FunctionNotFoundImplCopyWithImpl<
        _$JoltError_FunctionNotFoundImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? stack) evalError,
    required TResult Function(String field0) conversionError,
    required TResult Function(String field0) runtimeError,
    required TResult Function(String field0) functionNotFound,
  }) {
    return functionNotFound(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? stack)? evalError,
    TResult? Function(String field0)? conversionError,
    TResult? Function(String field0)? runtimeError,
    TResult? Function(String field0)? functionNotFound,
  }) {
    return functionNotFound?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? stack)? evalError,
    TResult Function(String field0)? conversionError,
    TResult Function(String field0)? runtimeError,
    TResult Function(String field0)? functionNotFound,
    required TResult orElse(),
  }) {
    if (functionNotFound != null) {
      return functionNotFound(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JoltError_EvalError value) evalError,
    required TResult Function(JoltError_ConversionError value) conversionError,
    required TResult Function(JoltError_RuntimeError value) runtimeError,
    required TResult Function(JoltError_FunctionNotFound value)
    functionNotFound,
  }) {
    return functionNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JoltError_EvalError value)? evalError,
    TResult? Function(JoltError_ConversionError value)? conversionError,
    TResult? Function(JoltError_RuntimeError value)? runtimeError,
    TResult? Function(JoltError_FunctionNotFound value)? functionNotFound,
  }) {
    return functionNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JoltError_EvalError value)? evalError,
    TResult Function(JoltError_ConversionError value)? conversionError,
    TResult Function(JoltError_RuntimeError value)? runtimeError,
    TResult Function(JoltError_FunctionNotFound value)? functionNotFound,
    required TResult orElse(),
  }) {
    if (functionNotFound != null) {
      return functionNotFound(this);
    }
    return orElse();
  }
}

abstract class JoltError_FunctionNotFound extends JoltError {
  const factory JoltError_FunctionNotFound(final String field0) =
      _$JoltError_FunctionNotFoundImpl;
  const JoltError_FunctionNotFound._() : super._();

  String get field0;

  /// Create a copy of JoltError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoltError_FunctionNotFoundImplCopyWith<_$JoltError_FunctionNotFoundImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$JsValue {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsValueCopyWith<$Res> {
  factory $JsValueCopyWith(JsValue value, $Res Function(JsValue) then) =
      _$JsValueCopyWithImpl<$Res, JsValue>;
}

/// @nodoc
class _$JsValueCopyWithImpl<$Res, $Val extends JsValue>
    implements $JsValueCopyWith<$Res> {
  _$JsValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$JsValue_UndefinedImplCopyWith<$Res> {
  factory _$$JsValue_UndefinedImplCopyWith(
    _$JsValue_UndefinedImpl value,
    $Res Function(_$JsValue_UndefinedImpl) then,
  ) = __$$JsValue_UndefinedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$JsValue_UndefinedImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_UndefinedImpl>
    implements _$$JsValue_UndefinedImplCopyWith<$Res> {
  __$$JsValue_UndefinedImplCopyWithImpl(
    _$JsValue_UndefinedImpl _value,
    $Res Function(_$JsValue_UndefinedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$JsValue_UndefinedImpl extends JsValue_Undefined {
  const _$JsValue_UndefinedImpl() : super._();

  @override
  String toString() {
    return 'JsValue.undefined()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$JsValue_UndefinedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return undefined();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return undefined?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (undefined != null) {
      return undefined();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return undefined(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return undefined?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (undefined != null) {
      return undefined(this);
    }
    return orElse();
  }
}

abstract class JsValue_Undefined extends JsValue {
  const factory JsValue_Undefined() = _$JsValue_UndefinedImpl;
  const JsValue_Undefined._() : super._();
}

/// @nodoc
abstract class _$$JsValue_NullImplCopyWith<$Res> {
  factory _$$JsValue_NullImplCopyWith(
    _$JsValue_NullImpl value,
    $Res Function(_$JsValue_NullImpl) then,
  ) = __$$JsValue_NullImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$JsValue_NullImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_NullImpl>
    implements _$$JsValue_NullImplCopyWith<$Res> {
  __$$JsValue_NullImplCopyWithImpl(
    _$JsValue_NullImpl _value,
    $Res Function(_$JsValue_NullImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$JsValue_NullImpl extends JsValue_Null {
  const _$JsValue_NullImpl() : super._();

  @override
  String toString() {
    return 'JsValue.null_()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$JsValue_NullImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return null_();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return null_?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (null_ != null) {
      return null_();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return null_(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return null_?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (null_ != null) {
      return null_(this);
    }
    return orElse();
  }
}

abstract class JsValue_Null extends JsValue {
  const factory JsValue_Null() = _$JsValue_NullImpl;
  const JsValue_Null._() : super._();
}

/// @nodoc
abstract class _$$JsValue_BoolImplCopyWith<$Res> {
  factory _$$JsValue_BoolImplCopyWith(
    _$JsValue_BoolImpl value,
    $Res Function(_$JsValue_BoolImpl) then,
  ) = __$$JsValue_BoolImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool field0});
}

/// @nodoc
class __$$JsValue_BoolImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_BoolImpl>
    implements _$$JsValue_BoolImplCopyWith<$Res> {
  __$$JsValue_BoolImplCopyWithImpl(
    _$JsValue_BoolImpl _value,
    $Res Function(_$JsValue_BoolImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_BoolImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_BoolImpl extends JsValue_Bool {
  const _$JsValue_BoolImpl(this.field0) : super._();

  @override
  final bool field0;

  @override
  String toString() {
    return 'JsValue.bool(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_BoolImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_BoolImplCopyWith<_$JsValue_BoolImpl> get copyWith =>
      __$$JsValue_BoolImplCopyWithImpl<_$JsValue_BoolImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return bool(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return bool?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (bool != null) {
      return bool(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return bool(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return bool?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (bool != null) {
      return bool(this);
    }
    return orElse();
  }
}

abstract class JsValue_Bool extends JsValue {
  const factory JsValue_Bool(final bool field0) = _$JsValue_BoolImpl;
  const JsValue_Bool._() : super._();

  bool get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_BoolImplCopyWith<_$JsValue_BoolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JsValue_IntImplCopyWith<$Res> {
  factory _$$JsValue_IntImplCopyWith(
    _$JsValue_IntImpl value,
    $Res Function(_$JsValue_IntImpl) then,
  ) = __$$JsValue_IntImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$JsValue_IntImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_IntImpl>
    implements _$$JsValue_IntImplCopyWith<$Res> {
  __$$JsValue_IntImplCopyWithImpl(
    _$JsValue_IntImpl _value,
    $Res Function(_$JsValue_IntImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_IntImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_IntImpl extends JsValue_Int {
  const _$JsValue_IntImpl(this.field0) : super._();

  @override
  final int field0;

  @override
  String toString() {
    return 'JsValue.int(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_IntImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_IntImplCopyWith<_$JsValue_IntImpl> get copyWith =>
      __$$JsValue_IntImplCopyWithImpl<_$JsValue_IntImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return int(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return int?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (int != null) {
      return int(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return int(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return int?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (int != null) {
      return int(this);
    }
    return orElse();
  }
}

abstract class JsValue_Int extends JsValue {
  const factory JsValue_Int(final int field0) = _$JsValue_IntImpl;
  const JsValue_Int._() : super._();

  int get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_IntImplCopyWith<_$JsValue_IntImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JsValue_FloatImplCopyWith<$Res> {
  factory _$$JsValue_FloatImplCopyWith(
    _$JsValue_FloatImpl value,
    $Res Function(_$JsValue_FloatImpl) then,
  ) = __$$JsValue_FloatImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$JsValue_FloatImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_FloatImpl>
    implements _$$JsValue_FloatImplCopyWith<$Res> {
  __$$JsValue_FloatImplCopyWithImpl(
    _$JsValue_FloatImpl _value,
    $Res Function(_$JsValue_FloatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_FloatImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_FloatImpl extends JsValue_Float {
  const _$JsValue_FloatImpl(this.field0) : super._();

  @override
  final double field0;

  @override
  String toString() {
    return 'JsValue.float(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_FloatImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_FloatImplCopyWith<_$JsValue_FloatImpl> get copyWith =>
      __$$JsValue_FloatImplCopyWithImpl<_$JsValue_FloatImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return float(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return float?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return float(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return float?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(this);
    }
    return orElse();
  }
}

abstract class JsValue_Float extends JsValue {
  const factory JsValue_Float(final double field0) = _$JsValue_FloatImpl;
  const JsValue_Float._() : super._();

  double get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_FloatImplCopyWith<_$JsValue_FloatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JsValue_StringImplCopyWith<$Res> {
  factory _$$JsValue_StringImplCopyWith(
    _$JsValue_StringImpl value,
    $Res Function(_$JsValue_StringImpl) then,
  ) = __$$JsValue_StringImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$JsValue_StringImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_StringImpl>
    implements _$$JsValue_StringImplCopyWith<$Res> {
  __$$JsValue_StringImplCopyWithImpl(
    _$JsValue_StringImpl _value,
    $Res Function(_$JsValue_StringImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_StringImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_StringImpl extends JsValue_String {
  const _$JsValue_StringImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'JsValue.string(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_StringImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_StringImplCopyWith<_$JsValue_StringImpl> get copyWith =>
      __$$JsValue_StringImplCopyWithImpl<_$JsValue_StringImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return string(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return string?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }
}

abstract class JsValue_String extends JsValue {
  const factory JsValue_String(final String field0) = _$JsValue_StringImpl;
  const JsValue_String._() : super._();

  String get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_StringImplCopyWith<_$JsValue_StringImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JsValue_ArrayImplCopyWith<$Res> {
  factory _$$JsValue_ArrayImplCopyWith(
    _$JsValue_ArrayImpl value,
    $Res Function(_$JsValue_ArrayImpl) then,
  ) = __$$JsValue_ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<JsValue> field0});
}

/// @nodoc
class __$$JsValue_ArrayImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_ArrayImpl>
    implements _$$JsValue_ArrayImplCopyWith<$Res> {
  __$$JsValue_ArrayImplCopyWithImpl(
    _$JsValue_ArrayImpl _value,
    $Res Function(_$JsValue_ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_ArrayImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<JsValue>,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_ArrayImpl extends JsValue_Array {
  const _$JsValue_ArrayImpl(final List<JsValue> field0)
    : _field0 = field0,
      super._();

  final List<JsValue> _field0;
  @override
  List<JsValue> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'JsValue.array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_ArrayImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_ArrayImplCopyWith<_$JsValue_ArrayImpl> get copyWith =>
      __$$JsValue_ArrayImplCopyWithImpl<_$JsValue_ArrayImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return array(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return array?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (array != null) {
      return array(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (array != null) {
      return array(this);
    }
    return orElse();
  }
}

abstract class JsValue_Array extends JsValue {
  const factory JsValue_Array(final List<JsValue> field0) = _$JsValue_ArrayImpl;
  const JsValue_Array._() : super._();

  List<JsValue> get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_ArrayImplCopyWith<_$JsValue_ArrayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JsValue_ObjectImplCopyWith<$Res> {
  factory _$$JsValue_ObjectImplCopyWith(
    _$JsValue_ObjectImpl value,
    $Res Function(_$JsValue_ObjectImpl) then,
  ) = __$$JsValue_ObjectImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<JsEntry> field0});
}

/// @nodoc
class __$$JsValue_ObjectImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_ObjectImpl>
    implements _$$JsValue_ObjectImplCopyWith<$Res> {
  __$$JsValue_ObjectImplCopyWithImpl(
    _$JsValue_ObjectImpl _value,
    $Res Function(_$JsValue_ObjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_ObjectImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<JsEntry>,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_ObjectImpl extends JsValue_Object {
  const _$JsValue_ObjectImpl(final List<JsEntry> field0)
    : _field0 = field0,
      super._();

  final List<JsEntry> _field0;
  @override
  List<JsEntry> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'JsValue.object(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_ObjectImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_ObjectImplCopyWith<_$JsValue_ObjectImpl> get copyWith =>
      __$$JsValue_ObjectImplCopyWithImpl<_$JsValue_ObjectImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return object(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return object?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (object != null) {
      return object(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return object(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return object?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (object != null) {
      return object(this);
    }
    return orElse();
  }
}

abstract class JsValue_Object extends JsValue {
  const factory JsValue_Object(final List<JsEntry> field0) =
      _$JsValue_ObjectImpl;
  const JsValue_Object._() : super._();

  List<JsEntry> get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_ObjectImplCopyWith<_$JsValue_ObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JsValue_BytesImplCopyWith<$Res> {
  factory _$$JsValue_BytesImplCopyWith(
    _$JsValue_BytesImpl value,
    $Res Function(_$JsValue_BytesImpl) then,
  ) = __$$JsValue_BytesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Uint8List field0});
}

/// @nodoc
class __$$JsValue_BytesImplCopyWithImpl<$Res>
    extends _$JsValueCopyWithImpl<$Res, _$JsValue_BytesImpl>
    implements _$$JsValue_BytesImplCopyWith<$Res> {
  __$$JsValue_BytesImplCopyWithImpl(
    _$JsValue_BytesImpl _value,
    $Res Function(_$JsValue_BytesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$JsValue_BytesImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$JsValue_BytesImpl extends JsValue_Bytes {
  const _$JsValue_BytesImpl(this.field0) : super._();

  @override
  final Uint8List field0;

  @override
  String toString() {
    return 'JsValue.bytes(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JsValue_BytesImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JsValue_BytesImplCopyWith<_$JsValue_BytesImpl> get copyWith =>
      __$$JsValue_BytesImplCopyWithImpl<_$JsValue_BytesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() undefined,
    required TResult Function() null_,
    required TResult Function(bool field0) bool,
    required TResult Function(int field0) int,
    required TResult Function(double field0) float,
    required TResult Function(String field0) string,
    required TResult Function(List<JsValue> field0) array,
    required TResult Function(List<JsEntry> field0) object,
    required TResult Function(Uint8List field0) bytes,
  }) {
    return bytes(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? undefined,
    TResult? Function()? null_,
    TResult? Function(bool field0)? bool,
    TResult? Function(int field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(String field0)? string,
    TResult? Function(List<JsValue> field0)? array,
    TResult? Function(List<JsEntry> field0)? object,
    TResult? Function(Uint8List field0)? bytes,
  }) {
    return bytes?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? undefined,
    TResult Function()? null_,
    TResult Function(bool field0)? bool,
    TResult Function(int field0)? int,
    TResult Function(double field0)? float,
    TResult Function(String field0)? string,
    TResult Function(List<JsValue> field0)? array,
    TResult Function(List<JsEntry> field0)? object,
    TResult Function(Uint8List field0)? bytes,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JsValue_Undefined value) undefined,
    required TResult Function(JsValue_Null value) null_,
    required TResult Function(JsValue_Bool value) bool,
    required TResult Function(JsValue_Int value) int,
    required TResult Function(JsValue_Float value) float,
    required TResult Function(JsValue_String value) string,
    required TResult Function(JsValue_Array value) array,
    required TResult Function(JsValue_Object value) object,
    required TResult Function(JsValue_Bytes value) bytes,
  }) {
    return bytes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JsValue_Undefined value)? undefined,
    TResult? Function(JsValue_Null value)? null_,
    TResult? Function(JsValue_Bool value)? bool,
    TResult? Function(JsValue_Int value)? int,
    TResult? Function(JsValue_Float value)? float,
    TResult? Function(JsValue_String value)? string,
    TResult? Function(JsValue_Array value)? array,
    TResult? Function(JsValue_Object value)? object,
    TResult? Function(JsValue_Bytes value)? bytes,
  }) {
    return bytes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JsValue_Undefined value)? undefined,
    TResult Function(JsValue_Null value)? null_,
    TResult Function(JsValue_Bool value)? bool,
    TResult Function(JsValue_Int value)? int,
    TResult Function(JsValue_Float value)? float,
    TResult Function(JsValue_String value)? string,
    TResult Function(JsValue_Array value)? array,
    TResult Function(JsValue_Object value)? object,
    TResult Function(JsValue_Bytes value)? bytes,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(this);
    }
    return orElse();
  }
}

abstract class JsValue_Bytes extends JsValue {
  const factory JsValue_Bytes(final Uint8List field0) = _$JsValue_BytesImpl;
  const JsValue_Bytes._() : super._();

  Uint8List get field0;

  /// Create a copy of JsValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JsValue_BytesImplCopyWith<_$JsValue_BytesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
