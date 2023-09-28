class SavePaymentParam {
  String? societyId;
  List<PaymentParam>? payments;

  SavePaymentParam({this.societyId, this.payments});

  SavePaymentParam.fromJson(Map<String, dynamic> json) {
    societyId = json['society_id'];
    if (json['payments'] != null) {
      payments = <PaymentParam>[];
      json['payments'].forEach((v) {
        payments?.add(new PaymentParam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['society_id'] = this.societyId;
    if (this.payments != null) {
      data['payments'] = this.payments?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SavePaymentResponse {
  List<Payment>? payments;
  int? total;
  int? amountToPay;
  PayGatewayGenData? payGatewayGenData;

  SavePaymentResponse(
      {this.payments, this.total, this.amountToPay, this.payGatewayGenData});

  SavePaymentResponse.fromJson(Map<String, dynamic> json) {
    if (json['payments'] != null) {
      payments = <Payment>[];
      json['payments'].forEach((v) {
        payments?.add(new Payment.fromJson(v));
      });
    }
    total = json['total'];
    amountToPay = json['amountToPay'];
    payGatewayGenData = json['payGatewayGenData'] != null
        ? new PayGatewayGenData.fromJson(json['payGatewayGenData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payments != null) {
      data['payments'] = this.payments?.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['amountToPay'] = this.amountToPay;
    if (this.payGatewayGenData != null) {
      data['payGatewayGenData'] = this.payGatewayGenData?.toJson();
    }
    return data;
  }
}

class Payment {
  int? id;
  String? name;
  int? amount;

  Payment({this.id, this.name, this.amount});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}

class PayGatewayGenData {
  int? amount;
  String? email;
  String? orderID;
  int? amountInKobo;
  int? quantity;
  String? reference;
  String? firstname;
  String? lastname;
  String? phone;
  Metadata? metadata;
  String? callbackUrl;
  String? paystackKey;

  PayGatewayGenData(
      {this.amount,
        this.email,
        this.orderID,
        this.amountInKobo,
        this.quantity,
        this.reference,
        this.firstname,
        this.lastname,
        this.phone,
        this.metadata,
        this.callbackUrl,
        this.paystackKey});

  PayGatewayGenData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    email = json['email'];
    orderID = json['orderID'];
    amountInKobo = json['amountInKobo'];
    quantity = json['quantity'];
    reference = json['reference'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    callbackUrl = json['callback_url'];
    paystackKey = json['paystack_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['email'] = this.email;
    data['orderID'] = this.orderID;
    data['amountInKobo'] = this.amountInKobo;
    data['quantity'] = this.quantity;
    data['reference'] = this.reference;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    if (this.metadata != null) {
      data['metadata'] = this.metadata?.toJson();
    }
    data['callback_url'] = this.callbackUrl;
    data['paystack_key'] = this.paystackKey;
    return data;
  }
}

class Metadata {
  List<CustomFields>? customFields;
  int? pId;

  Metadata({this.customFields, this.pId});

  Metadata.fromJson(Map<String, dynamic> json) {
    if (json['custom_fields'] != null) {
      customFields = <CustomFields>[];
      json['custom_fields'].forEach((v) {
        customFields?.add(new CustomFields.fromJson(v));
      });
    }
    pId = json['p_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields?.map((v) => v.toJson()).toList();
    }
    data['p_id'] = this.pId;
    return data;
  }
}

class CustomFields {
  String? displayName;
  String? variableName;
  String? value;

  CustomFields({this.displayName, this.variableName, this.value});

  CustomFields.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    variableName = json['variable_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['variable_name'] = this.variableName;
    data['value'] = this.value;
    return data;
  }
}


class PaymentParam {
  int? amountPaid;
  int? paymentTypeId;

  PaymentParam({this.amountPaid, this.paymentTypeId});

  PaymentParam.fromJson(Map<String, dynamic> json) {
    amountPaid = json['amount_paid'];
    paymentTypeId = json['payment_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount_paid'] = this.amountPaid;
    data['payment_type_id'] = this.paymentTypeId;
    return data;
  }
}


class MonthlyPaymentResponse {
  List<PaymentItem>? memberPaymentDueList;
  String? identifier;
  int? total;
  String? societyId;

  MonthlyPaymentResponse(
      {this.memberPaymentDueList, this.identifier, this.total, this.societyId});

  MonthlyPaymentResponse.fromJson(Map<String, dynamic> json) {
    if (json['memberPaymentDueList'] != null) {
      memberPaymentDueList = <PaymentItem>[];
      json['memberPaymentDueList'].forEach((v) {
        memberPaymentDueList?.add(new PaymentItem.fromJson(v));
      });
    }
    identifier = json['identifier'];
    total = json['total'];
    societyId = json['society_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.memberPaymentDueList != null) {
      data['memberPaymentDueList'] =
          this.memberPaymentDueList?.map((v) => v.toJson()).toList();
    }
    data['identifier'] = this.identifier;
    data['total'] = this.total;
    data['society_id'] = this.societyId;
    return data;
  }
}





class PaymentItem {
  String? name;
  int? id;
  int? minAmount;
  int? amountRemaining;

  PaymentItem({this.name, this.id, this.minAmount, this.amountRemaining});

  PaymentItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    minAmount = json['min_amount'];
    amountRemaining = json['amount_remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['min_amount'] = this.minAmount;
    data['amount_remaining'] = this.amountRemaining;
    return data;
  }
}