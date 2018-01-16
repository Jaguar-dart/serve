import 'dart:io';
import 'package:serve/serve.dart' as serve;
import 'package:jaguar/jaguar.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

main(List<String> arguments) async {
  final args = new ArgParser();
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
  args.addOption('base-path',
      abbr: 'b',
      help: 'Base path at which files shall be served.',
      valueHelp: '-b /myblog',
      defaultsTo: '');
  args.addOption('dir',
      abbr: 'd',
      help: 'Directory from which files shall be served.',
      valueHelp: '-d /home/myname/mysite',
      defaultsTo: '.');
  args.addOption('https',
      abbr: 's',
      help: 'Directory where certificate.pem and keys.pem are stored.',
      valueHelp: '-s /home/myname/ssl',
      defaultsTo: null);

  final ArgResults parsed = args.parse(arguments);

  final int port = int.parse(parsed['port'], onError: (_) => null);

  if (port == null) {
    print('Invalid port specified!');
    print(args.usage);
    exit(-1);
  }

  SecurityContext secContext;

  if (parsed['https'] != null) {
    final dir = new Directory(parsed['https']);
    if (!await dir.exists()) {
      print('HTTPS configuration directory does not exist!');
      print(args.usage);
      exit(-1);
    }

    secContext = new SecurityContext()
      ..useCertificateChain(p.join(dir.path, 'certificate.pem'))
      ..usePrivateKey(p.join(dir.path, 'keys.pem'));
  }

  String basePath = (parsed['base-path'] as String)
      .split('/')
      .where((s) => s.isNotEmpty)
      .join('/');

  if (basePath.isNotEmpty) basePath = '/$basePath';

  final server = new Jaguar(
      address: parsed['host'],
      port: port,
      basePath: basePath,
      securityContext: secContext);
  server.staticFiles('*', parsed['dir']);
  await server.serve();
}
