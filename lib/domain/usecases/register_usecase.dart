import 'package:first_application/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:first_application/data/network/request.dart';
import 'package:first_application/domain/model/authentication.dart';
import 'package:first_application/domain/repository/repository.dart';
import 'package:first_application/domain/usecases/base_usecase.dart';


class RegisterUseCase implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  Repository _repository;
  RegisterUseCase(this._repository);




  @override
  Future<Either<Failure, Authentication>> execute(RegisterUseCaseInput input) {
    return _repository.register(RegisterRequest(input.password, input.sign,input.languageId));
  }
}




class RegisterUseCaseInput {
  String sign;
  String password;
  int languageId;


  RegisterUseCaseInput(this.sign, this.password,this.languageId);
}
