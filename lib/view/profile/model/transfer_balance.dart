// {
//     "status": "fail",
//     "error": {
//         "statusCode": 400,
//         "status": "fail",
//         "isOperational": true
//     },
//     "message": "Insufficient balance",
//     "stack": "Error: Insufficient balance\n    at /root/backend/controllers/walletController.js:55:17\n    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)"
// }

class TransferBalanceModel {
  String? status;
  Error? error;
  String? message;
  String? stack;

  TransferBalanceModel({this.status, this.error, this.message, this.stack});

  TransferBalanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    message = json['message'];
    stack = json['stack'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    data['message'] = message;
    data['stack'] = stack;
    return data;
  }
}

class Error {
  int? statusCode;
  String? status;
  bool? isOperational;

  Error({this.statusCode, this.status, this.isOperational});

  Error.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    isOperational = json['isOperational'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['isOperational'] = isOperational;
    return data;
  }
}