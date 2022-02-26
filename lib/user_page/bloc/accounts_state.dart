part of 'accounts_bloc.dart';

abstract class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Object> get props => [];
}

class AccountsInitial extends AccountsState {}

class AccountsNoDataState extends AccountsState {}

class AccountsLoadingState extends AccountsState {}

class AccountsUpdatedState extends AccountsState {
  final Map decodedResult;

  AccountsUpdatedState(this.decodedResult);
  @override
  List<Object> get props => [decodedResult];
}

class AccountsErrorState extends AccountsState {
  final String errorMsg;

  AccountsErrorState(this.errorMsg);
  @override
  List<Object> get props => [errorMsg];
}
