sealed class AddReviewState {}

class AddReviewIdle extends AddReviewState {}

class AddReviewSubmitting extends AddReviewState {}

class AddReviewSuccess extends AddReviewState {}

class AddReviewError extends AddReviewState {
  final String errorMessage;

  AddReviewError(this.errorMessage);
}
