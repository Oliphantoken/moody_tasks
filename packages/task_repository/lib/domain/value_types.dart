enum Priority{ low, medium, high }

enum Complexity{ easy, moderate, complex }

enum TaskStatus{todo, inprogress, inreview, completed, blocked, backlog }

enum TaskCompletionRating { incomplete, technicallydone, goodenough, awesomeenough }

enum Mood { sad, neutral, happy, content, excited, angry, stressed, determined, panicking, relaxed, upset, restless, drained, aimless }


enum DueBy { overdue, today, thisWeek, thisMonth }

enum CategoryType { body, mindAndSpirit, professional, finance, social, fun, environment }

//--------------------------------------------
// Extensions for Enums
//--------------------------------------------

/// Convert from enum type to String
extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.backlog: return "Backlog";
      case TaskStatus.todo: return "To Do";
      case TaskStatus.inprogress: return "In Progress";
      case TaskStatus.inreview: return "In Review";
      case TaskStatus.completed: return "Completed";
      case TaskStatus.blocked: return "Blocked";
    }
  }
  /// Convert from String to enum type
  static TaskStatus fromString(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.displayName == status,
      orElse:() => TaskStatus.backlog
    );
  }

}

/// Convert from enum type to String
extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low: return "Low";
      case Priority.medium: return "Medium";
      case Priority.high: return "High";
    }
  }
  /// Convert from String to enum type
  static Priority fromString(String priority) {
    return Priority.values.firstWhere(
      (e) => e.displayName == priority,
      orElse: () => Priority.low
    );
  }
}

/// Convert from enum type to String
extension ComplexityExtension on Complexity {
  String get displayName {
    switch (this) {
      case Complexity.easy: return "Easy";
      case Complexity.moderate: return "Moderate";
      case Complexity.complex: return "Complex";
    }
  }
  /// Convert from String to enum type
  static Complexity fromString(String complexity) {
    return Complexity.values.firstWhere(
      (e) => e.displayName == complexity,
      orElse: () => Complexity.easy
    );
  }
}

/// Convert from enum type to String
extension TaskCompletionRatingExtension on TaskCompletionRating {
  String get displayName {
    switch (this) {
      case TaskCompletionRating.incomplete: return "Incomplete";
      case TaskCompletionRating.technicallydone: return "Technically Done";
      case TaskCompletionRating.goodenough: return "Good Enough";
      case TaskCompletionRating.awesomeenough: return "Awesome Enough";
    }
  }
  /// Convert from String to enum type
  static TaskCompletionRating fromString(String rating) {
    return TaskCompletionRating.values.firstWhere(
      (e) => e.displayName == rating,
      orElse:() => TaskCompletionRating.incomplete,);
  }
}

/// Convert from enum type to String
extension MoodExtension on Mood {
  String get displayName {
    switch (this) {
      case Mood.sad: return "Sad";
      case Mood.neutral: return "Neutral";
      case Mood.happy: return "Happy";
      case Mood.content: return "Content";
      case Mood.excited: return "Excited";
      case Mood.angry: return "Angry";
      case Mood.stressed: return "Stressed";
      case Mood.determined: return "Determined";
      case Mood.panicking: return "Panicking";
      case Mood.relaxed: return "Relaxed";
      case Mood.aimless: return "Aimless";
      case Mood.drained: return "Drained";
      case Mood.restless: return "Restless";
      case Mood.upset: return "Upset";
    }
  }
  /// Convert from String to enum type
  static Mood fromString(String mood) {
    return Mood.values.firstWhere(
      (e) => e.displayName == mood,
      orElse: () => Mood.content
    );
  }
}

extension CategoryTypeExtension on CategoryType {
  String get displayName{
    switch(this){
      case CategoryType.body: return "Body";
      case CategoryType.mindAndSpirit: return "Mind & Spirit";
      case CategoryType.professional: return "Professional";
      case CategoryType.finance: return "Finance";
      case CategoryType.fun: return "Fun";
      case CategoryType.social: return "Social";
      case CategoryType.environment: return "Environment";
    }
  }

  static CategoryType fromString(String type){
    return CategoryType.values.firstWhere(
      (e) => e.displayName == type,
      orElse: ()=> CategoryType.environment
    );
  }
}

extension DueByExtension on DueBy {
  String get displayName{
    switch(this){
      case DueBy.today: return "Today";
      case DueBy.thisWeek: return "This week";
      case DueBy.thisMonth: return "This month";
      case DueBy.overdue: return "Overdue";
    }
  }

  static DueBy fromString(String due){
    return DueBy.values.firstWhere(
      (e) => e.displayName == due,
      orElse: ()=> DueBy.thisMonth
    );
  }

}


//--------------------------------------------
// Can be dynamically extended in the future
//--------------------------------------------
final List<String> projectData = [
  "House Chores",
  "Health",
  "Errands",
  "Work",
  "Travel",
];

final List<String> tagsData = [
  "chores",
  "home",
  "health",
  "exercise",
  "shopping",
  "errands",
  "meeting",
  "work",
  "travel",
  "vacation"
];

