import '../../shared/models/user_model.dart';
import '../base_repository.dart';

abstract class AuthRepository extends BaseRepository {
  Future<Result<UserModel>> login(String email, String password);
  Future<Result<void>> logout();
  Future<Result<UserModel?>> getCurrentUser();
  Future<Result<bool>> isAuthenticated();
}
