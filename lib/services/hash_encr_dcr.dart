import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'dart:convert';

String getPasswordHash(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

String encryptPassword(String userPassword, String password) {
  final keyString = userPassword.padRight(16, 'a').substring(0, 16);
  // print(keyString);
  final key = encryption.Key.fromUtf8(keyString);
  final encryptor =
      encryption.Encrypter(encryption.AES(key, mode: encryption.AESMode.cbc));
  final initVector = encryption.IV.fromUtf8(keyString);
  final encryptedData = encryptor.encrypt(password, iv: initVector);
  return encryptedData.base16;
}

String decryptPassword(String userPassword, String encryptedPasssword) {
  final keyString = userPassword.padRight(16, 'a').substring(0, 16);
  final key = encryption.Key.fromUtf8(keyString);
  final encryptor =
      encryption.Encrypter(encryption.AES(key, mode: encryption.AESMode.cbc));
  final initVector = encryption.IV.fromUtf8(keyString);
  return encryptor.decrypt16(encryptedPasssword, iv: initVector);
}
