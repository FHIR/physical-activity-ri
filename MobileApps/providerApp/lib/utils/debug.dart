class Debug {
  static const debug = true;
  static const sandboxApiUrl = true;
  static const sandboxVerifyReceiptUrl = false;

  static printLog(String str) {
    if (debug) print(str);
  }
}