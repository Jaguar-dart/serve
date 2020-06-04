# serve

CLI to serves static files in a directory. Simpler to Python's `python -m SimpleHTTPServer`.

# Installing

```bash
pub global activate serve
```

# Serve files in current directory

```bash
serve
```

This command by default serves content of current directory on port `8080` and host `0.0.0.0`.

# Configure host and port

Use `--host` (abbreviation `-h`) and `--port` (abbreviation `-p`) to serve on desired host and port.

```bash
serve -h localhost -p 8081
```

# Serve content of specific directory

Use `--dir` (abbreviated as `-d`) to serve contents of a desired directory.

```bash
serve -d /home/myname/mysite
```

# Serve at a given base path

Use `--base-path` (abbreviated as `-b`) to serve contents with desired base path.

```bash
serve -b /myblog
```

# More features to come!

+ [ ] Support CORS
+ [ ] Support reverse proxy