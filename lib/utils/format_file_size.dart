String formatFileSize(int bytes) {
  const int kb = 1024;
  const int mb = 1024 * kb;
  const int gb = 1024 * mb;

  if (bytes < kb) {
    return '$bytes B';
  } else if (bytes < mb) {
    return '${(bytes / kb).toStringAsFixed(2)} KB';
  } else if (bytes < gb) {
    return '${(bytes / mb).toStringAsFixed(2)} MB';
  } else {
    return '${(bytes / gb).toStringAsFixed(2)} GB';
  }
}
