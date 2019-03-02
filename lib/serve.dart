import 'package:jaguar/jaguar.dart';

class Conf {
  final String host;

  final int port;

  final String dir;

  final SecurityContext securityContext;

  Conf({this.host, this.port, this.dir, this.securityContext});
}

Future<void> serve(Conf config, {bool log: false}) async {
  final server = Jaguar(
      address: config.host,
      port: config.port,
      securityContext: config.securityContext);
  server.staticFiles('*', config.dir);

  if (log) server.log.onRecord.listen(print);

  await server.serve(logRequests: log);
}
