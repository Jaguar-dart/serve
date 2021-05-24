import 'package:jaguar/jaguar.dart';

class Conf {
  final String host;

  final int port;

  final List<String> basePaths;

  final List<String> dirs;

  final SecurityContext? securityContext;

  Conf(this.dirs, this.basePaths,
      {required this.host, required this.port, this.securityContext});
}

Future<void> serve(Conf config, {bool log: false}) async {
  final server = Jaguar(
      address: config.host,
      port: config.port,
      securityContext: config.securityContext);

  for (int i = 0; i < config.basePaths.length; i++) {
    server.staticFiles(config.basePaths[i] + '/*', config.dirs[i]);
  }

  if (log) {
    server.log.onRecord.listen(print);
  }

  await server.serve(logRequests: log);
}
