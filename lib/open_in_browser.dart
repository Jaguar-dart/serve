import "dart:io";

void openInBrowser(String url) {
  bool fail = false;
  switch (Platform.operatingSystem) {
    case "linux":
      Process.run("xdg-open", [url]);
      break;
    case "macos":
      Process.run("open", [url]);
      break;
    case "windows":
      Process.run("explorer", [url]);
      break;
    default:
      fail = true;
      break;
  }

  if (!fail) {
    print("Opening default browser to $url");
  } else {
    print("Failed to open default browser.");
  }
}
