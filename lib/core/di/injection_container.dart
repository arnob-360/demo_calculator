import 'package:get_it/get_it.dart';
import '../../features/calculator/data/data_source/calculator_local_data_source.dart';
import '../../features/calculator/data/repositories_impl/calculator_repository_impl.dart';
import '../../features/calculator/domain/repositories/calculator_repository.dart';
import '../../features/calculator/domain/usecases/calculate_expression_usecase.dart';
import '../../features/calculator/presentation/bloc/calculator_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Data source
  getIt.registerLazySingleton<CalculatorLocalDataSource>(
    () => CalculatorLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<CalculatorRepository>(
    () => CalculatorRepositoryImpl(
      localDataSource: getIt<CalculatorLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<CalculateExpressionUsecase>(
    () => CalculateExpressionUsecase(getIt<CalculatorRepository>()),
  );

  // Blocs
  getIt.registerFactory<CalculatorBloc>(
    () => CalculatorBloc(getIt<CalculateExpressionUsecase>()),
  );
}
