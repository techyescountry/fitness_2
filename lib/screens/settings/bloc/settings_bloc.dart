import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_2/core/service/auth_service.dart';
import 'package:fitness_2/core/service/user_storage_service.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsReloadImageEvent>(
        (SettingsReloadImageEvent event, Emitter<SettingsState> emit) async {
      String? photoURL = await UserStorageService.readSecureData('image');
      if (photoURL == null) {
        photoURL = AuthService.auth.currentUser?.photoURL;
        photoURL != null
            ? await UserStorageService.writeSecureData('image', photoURL)
            : print('no image');
        emit(SettingsReloadImageState(photoURL: photoURL));
      }
    });

    on<SettingsReloadDisplayNameEvent>((SettingsReloadDisplayNameEvent event,
        Emitter<SettingsState> emit) async {
      final User? user = FirebaseAuth.instance.currentUser;
      final displayName = user?.displayName ?? "No Username";
      //NOTE: ORIGINAL CODE HERE, REMOVE 2 LINES ABOVE final displayName = await UserStorageService.readSecureData('name');
      print('this is the $displayName'); //NOTE: no print here
      emit(SettingsReloadDisplayNameState(displayName: displayName));
    });
  }
}
