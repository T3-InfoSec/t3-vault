import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/models/profile_model.dart';

sealed class ProfileSetEvent extends Equatable {
  const ProfileSetEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileSetLoadRequested extends ProfileSetEvent {}

final class ProfileSetUnchanged extends ProfileSetEvent {}

final class ProfileSetAdded extends ProfileSetEvent {
  final Profile profile;

  const ProfileSetAdded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

final class MemoProfileSetMemoCardRemoved extends ProfileSetEvent {
  final MemoCard memoCard;

  const MemoProfileSetMemoCardRemoved({required this.memoCard});

  @override
  List<Object?> get props => [memoCard];
}
