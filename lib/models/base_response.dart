class BaseResponse {
  String? msg;
  bool success;


  BaseResponse(
      {this.msg, required this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
        success: json["success"],
        msg: json["msg"]);
  }
}

class SingleResponse<T> extends BaseResponse {
  T? data;
  int? statusCode;

  SingleResponse({
    String? msg,
    required bool success,
    this.statusCode,
    this.data,
  }) : super(msg: msg, success: success);

  factory SingleResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create, int? statusCode) {
    return SingleResponse<T>(
        success: json["success"],
        msg: json["msg"]!=null?json["msg"]:"",
        data: json["data"]!= null? create(json["data"]) : null,
        statusCode: statusCode
    );
  }

  Map<String, dynamic> toJson() => {
    "success": this.success,
    "msg": this.msg,
    "data": this.data,
  };

}


class ListResponse<T> extends BaseResponse {
  List<T>? data;
  int? statusCode;

  ListResponse({
    String? msg,
    required bool success,
    this.statusCode,
    this.data,
  }) : super(msg: msg, success: success);
  factory ListResponse.fromJson(Map<String, dynamic> json, List<dynamic> list, Function(Map<String, dynamic>) create, int? statusCode) {

    List<T> data = List.empty(growable: true);

    list.forEach((v){
      final Map<String, dynamic> map = Map.from(v);
      data.add(create(map));
    });

    return ListResponse<T>(
        success: json["success"],
        msg: json["msg"],
        data: json["data"]!= null? data : null,
        statusCode: statusCode
    );
  }

}

class PListResponse extends BaseResponse {
  List<dynamic>? data;
  int? statusCode;

  PListResponse({
    String? msg,
    required bool success,
    this.statusCode,
    this.data,
  }) : super(msg: msg, success: success);

  factory PListResponse.fromJson(Map<String, dynamic> json, List<dynamic> list, int? statusCode) {

    List<dynamic> data = List.empty(growable: true);

    list.forEach((v){
      data.add(v);
    });

    return PListResponse(
        success: json["success"],
        msg: json["msg"],
        data: json["data"]!= null? data : null,
        statusCode: statusCode
    );
  }

}