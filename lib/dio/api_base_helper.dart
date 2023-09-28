import 'package:cooperativeapp/models/authorization.dart';
import 'package:cooperativeapp/models/base_response.dart';
import 'package:cooperativeapp/models/guarantor.dart';
import 'package:cooperativeapp/models/loan_payment_history.dart';
import 'package:cooperativeapp/models/loan_request.dart';
import 'package:cooperativeapp/models/loan_request_response.dart';
import 'package:cooperativeapp/models/login_response.dart';
import 'package:cooperativeapp/models/meeting_calender.dart';
import 'package:cooperativeapp/models/member.dart';
import 'package:cooperativeapp/models/payment.dart';
import 'package:cooperativeapp/models/society.dart';
import 'package:cooperativeapp/models/society_members.dart';
import 'package:cooperativeapp/params/auth_param.dart';
import 'package:cooperativeapp/params/change_password_param.dart';
import 'package:cooperativeapp/params/guarantor_resp_param.dart';
import 'package:cooperativeapp/params/loan_request_param.dart';
import 'package:cooperativeapp/payment_object.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'logging_interceptor.dart';

class ApiBaseHelper {
  static final String url =
      'https://dashboard.ogbomosooluwalosecicu.com.ng/api/v1';
//  static final String url = 'https://testserver.ogbomosooluwalosecicu.com.ng/api/v1';
  // static final String url = 'https://coopstaging.hds.com.ng/api/v1';
//  static final String url = 'http://192.168.137.228/api/v1';

  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  static String token = '';

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  static BuildContext createContext(BuildContext context) {
    return context;
  }

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    //String accessToken = '';
    return dio
      ..interceptors.add(
        InterceptorsWrapper(onRequest: (r, handler) async {
          await requestInterceptor(r);
          handler.next(r);
        }, onError: (e, handler) async {
          handler.next(e);
        }),
      )
      ..interceptors.add(LoggingInterceptor());
  }

  static dynamic requestInterceptor(RequestOptions options) async {
    // Get your JWT token
    LocalStorage().getAuthorization().then((value) =>
        options.headers['Authorization'] = 'Bearer ' + (value?.token ?? ''));
//    options.headers['Authorization'] = 'Bearer '+'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvb2dib21vc29vbHV3YWxvc2VjaWN1LmNvbS5uZ1wvYXBpXC92MVwvYXV0aFwvcmVmcmVzaCIsImlhdCI6MTYxNjQ5ODcxMiwiZXhwIjoxNjE2NTA5NTMxLCJuYmYiOjE2MTY0OTg3MzEsImp0aSI6InFxZ2FiRHo3OE9nUTB1dEMiLCJzdWIiOjIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.SeQ1Sdw_umz42Z5xuGSm6OxIjJ8Z-sSkiMqKpfeg2SI';
    return options;
  }

  Future<SingleResponse<Authorization>> refreshToken() async {
    try {
      Response response = await baseAPI.get("/auth/refresh");
      return SingleResponse<Authorization>.fromJson(response.data,
          (data) => Authorization.fromJson(data), response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<LoginResponse>> loginUser(AuthParam data) async {
    try {
      Response response = await baseAPI.post("/auth/login", data: data);
      return SingleResponse<LoginResponse>.fromJson(response.data,
          (data) => LoginResponse.fromJson(data), response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<SocietyMember>> getUserSocieties() async {
    try {
      Response response =
          await baseAPI.get("/my/society_members/my_societies/");
      return ListResponse<SocietyMember>.fromJson(
          response.data,
          response.data['data']['societyMembers'],
          (data) => SocietyMember.fromJson(data),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<Society>> getSociety(String societyId) async {
    try {
      Response response = await baseAPI.get("/admin/societies/" + societyId);
      return SingleResponse<Society>.fromJson(
          response.data, (data) => Society.fromJson(data), response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<int>> getTotalAsset(String societyId) async {
    try {
      Response response =
          await baseAPI.get("/my/member_payments/total_assets/" + societyId);
      return SingleResponse<int>.fromJson(
          response.data, (data) => data['totalAsset'], response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<int>> getCurrentLoanBal(
      String memberId, String societyId) async {
    try {
      Response response = await baseAPI
          .get("/dashboard/loan_balance/" + memberId + "/" + societyId);
      return SingleResponse<int>.fromJson(response.data,
          (data) => data['currentLoanBalance'], response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<Member>> getUserDetails(String id) async {
    try {
      Response response = await baseAPI.get("/admin/members/" + id);
      return SingleResponse<Member>.fromJson(response.data,
          (data) => Member.fromJson(data['member']), response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<SocietyMember>> getSocietyMembers(
      String societyId) async {
    try {
      Response response =
          await baseAPI.get("/my/society_members/guarantors/" + societyId);
      return ListResponse<SocietyMember>.fromJson(
          response.data,
          response.data['data']['societyMembers'],
          (data) => SocietyMember.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<LoanRequest>> getLoanRequests() async {
    try {
      Response response = await baseAPI.get("/my/loan_requests/get_all");
      return ListResponse<LoanRequest>.fromJson(
          response.data,
          response.data['data']['loanRequests'],
          (data) => LoanRequest.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
//      print('LoanRequestsCode:'+e.response.statusCode.toString());
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<LoanPaymentHistory>> getLoanPaymentHistory(
      String id) async {
    try {
      Response response =
          await baseAPI.get("/my/loan_requests/payment_history/" + id);
      return SingleResponse<LoanPaymentHistory>.fromJson(
          response.data,
          (data) => LoanPaymentHistory.fromJson(data['loanPaymentHistory']),
          response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<Guarantor>> getLoanGuarantors(String id) async {
    try {
      Response response =
          await baseAPI.get("/my/loan_requests/get_guarantors/" + id);
      return ListResponse<Guarantor>.fromJson(
          response.data,
          response.data['data']['guarantors'],
          (data) => Guarantor.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<GuarantorRequest>> getGuarantorRequests() async {
    try {
      Response response =
          await baseAPI.get("/my/get_all/loan_request/guarantors/");
      return ListResponse<GuarantorRequest>.fromJson(
          response.data,
          response.data['data']['guarantors'],
          (data) => GuarantorRequest.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<Member>> getManyMembers(List<int> ids) async {
    try {
      Response response = await baseAPI
          .post("/admin/members/fetch_many/by_id", data: {'paramIDs': ids});
      return ListResponse<Member>.fromJson(response.data, response.data['data'],
          (data) => Member.fromJson(data.cast()), response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<Society>> getManySocieties(List<int> ids) async {
    try {
      Response response = await baseAPI
          .post("/admin/societies/fetch_many", data: {'paramIDs': ids});
      return ListResponse<Society>.fromJson(
          response.data,
          response.data['data'],
          (data) => Society.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<LoanRequestResponse>> saveLoan(
      LoanRequestParam param) async {
    try {
      Response response =
          await baseAPI.post("/my/loan_requests/save", data: param);
      return SingleResponse<LoanRequestResponse>.fromJson(response.data,
          (data) => LoanRequestResponse.fromJson(data), response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<MeetingDate>> getMeetingCalender(
      String societyId, String year) async {
    try {
      Response response = await baseAPI
          .get("/admin/meeting_calendars/" + societyId + "/" + year);
      return ListResponse<MeetingDate>.fromJson(
          response.data,
          response.data['data']['meetingCalendars'],
          (data) => MeetingDate.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<PListResponse> getYears() async {
    try {
      Response response =
          await baseAPI.get("/admin/meeting_calendars/save/get/years");
      return PListResponse.fromJson(response.data,
          response.data['data']['meetingCalendarYears'], response.statusCode);
    } on DioError catch (e) {
      return PListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<Passbook>> getMemberPassbook(String societyId,
      {dynamic from = '', dynamic to = ''}) async {
    try {
      Response response = await baseAPI.get(
          "/my/member_payments/data/analysis/member_passbook/mobile/" +
              societyId +
              from +
              to);
      return ListResponse<Passbook>.fromJson(
          response.data,
          response.data['data'],
          (data) => Passbook.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<ListResponse<Passbook>> getMemberPassbookFromTo(String societyId,
      {dynamic from = '', dynamic to = ''}) async {
    try {
      Response response = await baseAPI.get(
          "/my/member_payments/data/analysis/member_passbook/mobile/" +
              societyId +
              "/?from=$from&to=$to");
      return ListResponse<Passbook>.fromJson(
          response.data,
          response.data['data'],
          (data) => Passbook.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return ListResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<bool>> changePassword(ChangePasswordParam param) async {
    try {
      Response response =
          await baseAPI.post("/auth/change_password", data: param);
      return SingleResponse.fromJson(
          response.data, (data) => null, response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<bool>> respondToGuarantorReq(
      GuarantorResponseParam param) async {
    try {
      Response response = await baseAPI
          .post("/my/loan_requests/respond_to_guarantor_request", data: param);
      return SingleResponse.fromJson(
          response.data, (data) => null, response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<MonthlyPaymentResponse>> getMonthlyPayment(
      String id) async {
    try {
      Response response =
          await baseAPI.get("/my/member_payments/monthly/payment/" + id);
      return SingleResponse<MonthlyPaymentResponse>.fromJson(
          response.data,
          (data) => MonthlyPaymentResponse.fromJson(data.cast()),
          response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse<SavePaymentResponse>> savePayment(
      SavePaymentParam param) async {
    try {
      Response response = await baseAPI
          .post("/my/member_payments/monthly/payment/save", data: param);
      print(response.toString());
      return SingleResponse<SavePaymentResponse>.fromJson(
          response.data,
          (data) => SavePaymentResponse.fromJson(data["data"]),
          response.statusCode);
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  Future<SingleResponse> verifyPayment(String refNo) async {
    try {
      Response response = await baseAPI
          .get("/my/member_payments/monthly/payment/callback/$refNo");
      return SingleResponse(success: true, msg: 'Successful');
    } on DioError catch (e) {
      return SingleResponse(
          msg: _handleError(e), success: false, data: null, statusCode: 0);
      // Handle error
    }
  }

  // Future<Response> getHTTP(String url) async {
  //   try {
  //     Response response = await baseAPI.get(url);
  //     return response;
  //   } on DioError catch(e) {
  //     // Handle error
  //   }
  // }
  //
  // Future<Response> postHTTP(String url, dynamic data) async {
  //   try {
  //     Response response = await baseAPI.post(url, data: data);
  //     return response;
  //   } on DioError catch(e) {
  //     // Handle error
  //   }
  // }
  //
  // Future<Response> putHTTP(String url, dynamic data) async {
  //   try {
  //     Response response = await baseAPI.put(url, data: data);
  //     return response;
  //   } on DioError catch(e) {
  //     // Handle error
  //   }
  // }
  //
  // Future<Response> deleteHTTP(String url) async {
  //   try {
  //     Response response = await baseAPI.delete(url);
  //     return response;
  //   } on DioError catch(e) {
  //     // Handle error
  //   }
  // }

  String _handleError(DioError dioError) {
    String errorDescription = "";
//    if (error is DioError) {
    //DioError dioError = error as DioError;

    if (dioError.response?.data['msg'] != null) {
      return dioError.response?.data["msg"];
    } else {
      switch (dioError.type) {
        case DioErrorType.cancel:
          errorDescription = "Request to server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout. Please try again!";
          break;
        case DioErrorType.other:
          errorDescription =
              "Connection to server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with server";
          break;
        case DioErrorType.response:
          errorDescription =
              "Received invalid status code: ${dioError.response?.statusCode ?? 0}";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with server";
          break;
      }
    }

    return errorDescription;
  }
}
