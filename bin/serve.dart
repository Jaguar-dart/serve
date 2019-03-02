import 'dart:io';
import 'package:serve/serve.dart';
import 'package:jaguar/jaguar.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

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

  final ArgResults parsed = args.parse(arguments);

  final int port = int.tryParse(parsed['port']);

  if (port == null) {
    print('Invalid port specified!');
    print(args.usage);
    exit(-1);
  }

  String contentDir = './';

  if (parsed.rest.isNotEmpty) {
    contentDir = parsed.rest.first;
  }

  {
    final dir = Directory(contentDir);
    if (!await dir.exists()) {
      print('Content directory "$contentDir" does not exist!');
      print(args.usage);
      exit(-1);
    }
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

  /* TODO
  String basePath = (parsed['base-path'] as String)
      .split('/')
      .where((s) => s.isNotEmpty)
      .join('/');

  if (basePath.isNotEmpty) basePath = '/$basePath';
      */

  final config = Conf(
      host: parsed['host'],
      port: port,
      dir: contentDir,
      securityContext: secContext);

  bool log = parsed['log'];

  await serve(config, log: log);
}
