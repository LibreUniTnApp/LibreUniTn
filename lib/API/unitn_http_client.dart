import 'package:http/http.dart';

class UnitnHttpClient extends BaseClient {
  //Languages are seemingly specified with ISO 639-1 language codes
  //en for English, it for Italian, etc
  String language;
  final Client _inner;

  /* WARNING: This is not ok, language should always be specified.
   * since there's no easy way in the application to set a language, this
   * will have to do for now */
  //TODO: Make language a required positional parameter
  @deprecated
  UnitnHttpClient.withHttpClient(this._inner, [this.language = 'en']): super();
  UnitnHttpClient([String language = 'en']): this.withHttpClient(Client(), language);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    //Adding headers Accept and unitn-culture
    request.headers['Accept'] = 'application/json, text/plain, */*';
    request.headers['unitn-culture'] = language;
    return _inner.send(request);
  }
}