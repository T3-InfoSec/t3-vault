import 'package:equatable/equatable.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/models/profile_model.dart';

sealed class ProfileSetState extends Equatable {
  final List<Profile> profiles;

  const ProfileSetState({required this.profiles});

  @override
  List<Object?> get props => [profiles];
}

final class ProfileSetEmpty extends ProfileSetState {
  ProfileSetEmpty() : super(profiles: []);
}

final class ProfileSetChangeNothing extends ProfileSetState {
  const ProfileSetChangeNothing({required super.profiles});
}

final class ProfileSetAddSuccess extends ProfileSetState {
  const ProfileSetAddSuccess({required super.profiles});
}

final class ProfileSetRemoveSuccess extends ProfileSetState {
  const ProfileSetRemoveSuccess({required super.profiles});
}
