import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:money_track/user_page/bloc/picture_bloc.dart';
import 'package:money_track/utils/secrets.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc() : super(AccountsInitial()) {
    on<UpdateAccountsEvent>(_updateAccounts);
  }
}

FutureOr<void> _updateAccounts(AccountsEvent event, Emitter emit) async {
  emit(AccountsLoadingState());
  await Future.delayed(
      Duration(seconds: 1)); //Simulate loading to see loading widget
  var url = Uri.parse(
      'https://api.sheety.co/e1fe88e8f736d61d2e86d70792ae7d1d/t4Api/users');

  try {
    var response = await get(url, headers: {'Authorization': API_AUTH});
    if (response.statusCode != 200) {
      throw Exception();
    }
    var decodedResponse = jsonDecode(response.body) as Map;
    if (decodedResponse['users'].length == 0) {
      emit(AccountsNoDataState());
    } else {
      emit(AccountsUpdatedState(decodedResponse));
    }
  } catch (e) {
    emit(AccountsErrorState('No se pudieron cargar las cuentas'));
  }
}
