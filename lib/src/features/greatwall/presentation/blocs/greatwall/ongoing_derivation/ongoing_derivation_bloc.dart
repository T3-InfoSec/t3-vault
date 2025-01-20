import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/greatwall/ongoing_derivation/ongoing_derivation_event.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/greatwall/ongoing_derivation/ongoing_derivation_state.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/profile_json_repository.dart';

class IntermediateStatesBloc
    extends Bloc<OngoingDerivationEvent, OngoingDerivationState> {
  final ProfileRepository profileRepository;
  
  IntermediateStatesBloc({required this.profileRepository}) : super(OngoingDerivationEmpty()) {
    on<OngoingDerivationLoadRequested>(_onOngoingDerivationEvent);
    on<OngoingDerivationAdded>(_onOngoingDerivationEvent);
    on<OngoingDerivationRemoved>(_onOngoingDerivationEvent);
  }

  Future<void> _onOngoingDerivationEvent(
    OngoingDerivationEvent event,
    Emitter<OngoingDerivationState> emit,
  ) async {

    if (event is OngoingDerivationLoadRequested) {
      await _loadIntermediateStatesFromRepository();
      return emit(OngoingDerivationAddSuccess(ongoingDerivationEntity: profileRepository.ongoingDerivation));
    }

    if (event is OngoingDerivationAdded) {
      await profileRepository.setOngoingDerivation(event.ongoingDerivationEntity);
      return emit(OngoingDerivationAddSuccess(ongoingDerivationEntity: profileRepository.ongoingDerivation));
    }
  }

  Future<void> _loadIntermediateStatesFromRepository() async {
      await profileRepository.readProfile();
  }
}