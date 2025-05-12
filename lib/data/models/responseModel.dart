class ResponseModel {
  bool isSuccess;
  String message;
  int statusCode;
  dynamic responseBody;

  ResponseModel(this.isSuccess, this.message, this.statusCode, this.responseBody);
}
