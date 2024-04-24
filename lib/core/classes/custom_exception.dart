
class CustomException implements Exception {
  final String message;
  CustomException(this.message);

  static CustomException? fromStatus(int status) {
    if (status == 404) {
      return CustomException('Not Found');
    } else if(status == 403) {
      return CustomException('Forbidden');
    } else  if (status == 401) {
      return CustomException('Unauthorized');
    } else if (status == 400) {
      return CustomException('Bad Request');
    }

    return null;
  }
}