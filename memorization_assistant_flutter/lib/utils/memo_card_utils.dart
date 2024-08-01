import 'package:intl/intl.dart';

/// Provides helper methods related to memory cards.
///
/// This class contains static methods for common operations 
/// needed in the context of handling memory cards, such as formatting due dates 
/// and mapping status codes to human-readable labels.
class MemoCardUtils {
  
  /// Formats the given due date into a readable string.
  ///
  /// This method takes a [dueDate] as input and returns it as 
  /// a formatted string in the 'yyyy-MM-dd HH:mm' format, converted to the 
  /// local time zone. If the [dueDate] is null, it returns 'Not scheduled'. 
  /// This method uses the `intl` package to handle date formatting.
  static String formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return 'Not scheduled';
    return DateFormat('yyyy-MM-dd HH:mm').format(dueDate.toLocal());
  }

  /// Maps a status code to its corresponding label.
  ///
  /// This method takes an integer [status] code and returns 
  /// a corresponding string label that represents the status. The status codes 
  /// are mapped as follows:
  /// 
  /// - 0: "new"
  /// - 1: "learning"
  /// - 2: "review"
  /// - 3: "relearning"
  /// 
  /// If the status code does not match any of the predefined cases, the method 
  /// returns "unknown".
  static String mapStatusToLabel(int status) {
    switch (status) {
      case 0:
        return "new";
      case 1:
        return "learning";
      case 2:
        return "review";
      case 3:
        return "relearning";
      default:
        return "unknown";
    }
  }
}
