import 'dart:io';

import 'package:args/args.dart';
import 'package:jaguar/jaguar.dart';
import 'package:path/path.dart' as p;
import 'package:serve/serve.dart';

main(List<String> arguments) async {
  final args = ArgParser();
  args.addOption('host',
      abbr: 'h',
      help: 'Host address at which files shall be served.',
      valueHelp: '-h 0.0.0.0',
      defaultsTo: '0.0.0.0');
  args.addOption('port',
      abbr: 'p',
      help: 'Port at which files shall be served.',
      valueHelp: '-p 80',
      defaultsTo: '8080');
  args.addFlag('log',
      abbr: 'l',
      help: 'If set, all requests will be logged to the stdout.',
      defaultsTo: true);
  args.addOption('https',
      abbr: 's',
      help: 'Directory where certificate.pem and keys.pem are stored.',
      valueHelp: '-s /home/myname/ssl',
      defaultsTo: null);
  args.addMultiOption('base',
      abbr: 'b',
      help: 'Base path to serve the contents at',
      valueHelp: '-b /v1/app',
      defaultsTo: ["/"]);
  args.addMultiOption('dir',
      abbr: 'd',
      help: 'Contents of the directory to serve',
      valueHelp: '-h /var/local/www/',
      defaultsTo: ["./"]);

  final ArgResults parsed = args.parse(arguments);

  final int port = int.tryParse(parsed['port']);

  if (port == null) {
    print('Invalid port specified!');
    print(args.usage);
    exit(-1);
  }

  List<String> contentDirs = parsed['dir'];

  for (final contentDir in contentDirs) {
    final dir = Directory(contentDir);
    if (!await dir.exists()) {
      print('Content directory "$contentDir" does not exist!');
      print(args.usage);
      exit(-1);
    }
  }

  List<String> basePaths = parsed['base'];
  if (basePaths.length != contentDirs.length) {
    if (basePaths.length > contentDirs.length) {
      print('Number of base paths must not be greater than number of dirs!');
      print(args.usage);
      exit(-1);
    }

    basePaths.addAll(
        List<String>.filled(contentDirs.length - basePaths.length, "/"));
  }

  SecurityContext secContext;

  if (parsed['https'] != null) {
    final dir = Directory(parsed['https']);
    if (!await dir.exists()) {
      print('HTTPS configuration directory does not exist!');
      print(args.usage);
      exit(-1);
    }

    secContext = SecurityContext()
      ..useCertificateChain(p.join(dir.path, 'certificate.pem'))
      ..usePrivateKey(p.join(dir.path, 'keys.pem'));
  }

  final config = Conf(contentDirs, basePaths,
      host: parsed['host'], port: port, securityContext: secContext);

  bool log = parsed['log'];

  await serve(config, log: log);
}
