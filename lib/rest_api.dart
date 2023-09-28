//import 'package:rest_client/rest_client.dart' as rc;
//
//class RestApi{
//  var client = rc.Client();
//  Future<rc.Response> login(){
//    var client = rc.Client();
//
//    var request = rc.Request(
//      url: 'https://google.com',
//    );
//
//    var response = client.execute(
//      authorizer: rc.TokenAuthorizer(token: 'my_token_goes_here'),
//      request: request,
//    );
//
//    return response;
//  }
//
//}