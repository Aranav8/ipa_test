import 'package:fpdart/fpdart.dart';
import 'package:ridobiko/core/type_defs.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
