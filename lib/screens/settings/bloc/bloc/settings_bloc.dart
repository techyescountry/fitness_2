import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_2/core/service/auth_service.dart';
import 'package:fitness_2/core/service/user_storage_service.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc {
  SettingsBloc() : super(SettingsInitial());

  @override
  Stream mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsReloadImageEvent) {
      String? photoURL = await UserStorageService.readSecureData('image');
      if (photoURL == null) {
        photoURL = AuthService.auth.currentUser?.photoURL;
        photoURL != null
            ? await UserStorageService.writeSecureData('image', photoURL)
            : print('no image');
        yield SettingsReloadImageState(photoURL: photoURL);
      }
    } else if (event is SettingsReloadDisplayNameEvent) {
      final displayName = await UserStorageService.readSecureData('name');
      yield SettingsReloadDisplayNameState(displayName: displayName);
    }
  }
}
