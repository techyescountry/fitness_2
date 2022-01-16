import 'package:bloc/bloc.dart';
import 'package:fitness_2/core/service/auth_service.dart';
import 'package:fitness_2/core/service/user_storage_service.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsReloadImageEvent>((event, emit) async {
      String? photoURL = await UserStorageService.readSecureData('image');
      if (photoURL == null) {
        photoURL = AuthService.auth.currentUser?.photoURL;
        photoURL != null
            ? await UserStorageService.writeSecureData('image', photoURL)
            : print('no image');
        emit(SettingsReloadImageState(photoURL: photoURL));
      }
    });

    on<SettingsReloadDisplayNameEvent>((event, emit) async {
      final displayName = await UserStorageService.readSecureData('name');
      emit(SettingsReloadDisplayNameState(displayName: displayName));
    });
  }
}
