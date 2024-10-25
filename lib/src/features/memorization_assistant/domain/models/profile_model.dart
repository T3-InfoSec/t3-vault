import 'package:t3_memassist/memory_assistant.dart';

/// The [Profile] encapsulates the information to be stored for the operation of the storage assistant.
/// 
/// Encapsulates the set of all the seeds ([_seedPA0], passwords, salts, keys)
/// and [_memoCard] to be used in the memoisation assistant. It can be deleted once the memorisation is completed.
class Profile {
  MemoCard memoCard; // TODO: change this to store list of cards representing each level.
  String seedPA0;

  /// Constructs a Profile with required [memoCard] and [seedPA0] values.
  ///
  /// - [memoCard] represents a [MemoCard].
  /// - The [seedPA0] is a secure, encrypted seed value used as input of the protocol (SA0).
  Profile({required this.memoCard, required this.seedPA0});

}
