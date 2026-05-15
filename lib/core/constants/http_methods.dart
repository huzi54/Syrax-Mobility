part of 'constants.dart';

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  update('UPDATE'),
  delete('DELETE'),
  patch('PATCH');

  final String value;

  const HttpMethod(this.value);
}
