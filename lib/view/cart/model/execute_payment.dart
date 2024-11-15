// {
//     "PaymentMethodId": 2,
//     "InvoiceValue": 100,
//     "type": "DEPOSIT", // 'DEPOSIT' or 'PAYMENT'
//     "successURL": "https://example.com/success",
//     "errorURL": "https://example.com/error"
// }

class PaymentType {
  final String value;

  PaymentType._(this.value);

  static final DEPOSIT = PaymentType._('DEPOSIT');
  static final PAYMENT = PaymentType._('PAYMENT');
}

class ExecutePaymentRequest {
  final int paymentMethodId;
  final double? invoiceValue;
  final String? cardId;
  final PaymentType type;
  final String successURL;
  String? errorURL;

  ExecutePaymentRequest({
    required this.paymentMethodId,
    this.invoiceValue,
    this.cardId,
    required this.type,
    required this.successURL,
    this.errorURL,
  });

  Map<String, dynamic> toJson() {
    return {
      "PaymentMethodId": paymentMethodId,
      "InvoiceValue": invoiceValue,
      if(cardId != null) "cardId": cardId,
      "type": type.value,
      "successUrl": successURL,
      if(errorURL != null) "errorUrl": errorURL,
    };
  }
}

class ExecutePaymentResponse {
  final String status;
  final String? message;
  final ExecutePaymentResponseData? data;

  bool get isSuccess => status == 'success';

  ExecutePaymentResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory ExecutePaymentResponse.fromJson(Map<String, dynamic> json) {
    return ExecutePaymentResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? null
          : ExecutePaymentResponseData.fromJson(json['data']),
    );
  }
}

class ExecutePaymentResponseData {
  final bool isSuccess;
  final String message;
  final dynamic validationErrors;
  final ExecutePaymentData data;

  ExecutePaymentResponseData({
    required this.isSuccess,
    required this.message,
    required this.validationErrors,
    required this.data,
  });

  factory ExecutePaymentResponseData.fromJson(Map<String, dynamic> json) {
    return ExecutePaymentResponseData(
      isSuccess: json['IsSuccess'],
      message: json['Message'],
      validationErrors: json['ValidationErrors'],
      data: ExecutePaymentData.fromJson(json['Data']),
    );
  }
}

class ExecutePaymentData {
  final int invoiceId;
  final bool isDirectPayment;
  final String paymentURL;
  final String? customerReference;
  final String userDefinedField;
  final String recurringId;

  ExecutePaymentData({
    required this.invoiceId,
    required this.isDirectPayment,
    required this.paymentURL,
    this.customerReference,
    required this.userDefinedField,
    required this.recurringId,
  });

  factory ExecutePaymentData.fromJson(Map<String, dynamic> json) {
    return ExecutePaymentData(
      invoiceId: json['InvoiceId'],
      isDirectPayment: json['IsDirectPayment'],
      paymentURL: json['PaymentURL'],
      customerReference: json['CustomerReference'],
      userDefinedField: json['UserDefinedField'],
      recurringId: json['RecurringId'],
    );
  }
}
