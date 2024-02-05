import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/widgets/new_password.dart';
import 'package:password_bank_flutter/screens/user.dart';
import 'package:password_bank_flutter/screens/log_in.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';
import 'package:flutter/services.dart';

class PasswordsScreen extends StatefulWidget {
  final UserInfo user;
  final String originalUserPassword;

  const PasswordsScreen(
      {super.key, required this.user, required this.originalUserPassword});
  @override
  State<PasswordsScreen> createState() {
    return _PasswordsScreenState();
  }
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  PasswordInfo? selectedPassword;
  late final UserInfo currentUser;
  late String currentUserPassword;

  void _onAddPasswordOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewPassword(
            onSavePassword: _saveNewPassword,
            onDeletePassword: _deletePassword,
          );
        });
  }

  void _onEditPasswordOverlay(PasswordInfo password) {
    // print(currentUserPassword);
    final passwordInfoMap = {
      "title": password.title,
      "password": decryptPassword(currentUserPassword, password.password),
      "about": password.about
    };

    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewPassword(
            onSavePassword: _saveNewPassword,
            onDeletePassword: _deletePassword,
            oldPasswordInfo: passwordInfoMap,
          );
        });
  }

  void _saveNewPassword(
      String title, String password, String about, bool isNewPassword) {
    final encryptedPasssword = encryptPassword(currentUserPassword, password);
    // print(encryptedPasssword);
    // so some password is edited
    // print(selectedPassword!.id);
    if (selectedPassword != null && !isNewPassword) {
      // print("edit password");
      selectedPassword!.title = title;
      selectedPassword!.password = encryptedPasssword;
      selectedPassword!.about = about;
      setState(() {
        PasswordDatabaseHelper.updatePassword(selectedPassword!);
      });
      return;
    }

    final newPassword = PasswordInfo(
        title: title,
        password: encryptedPasssword,
        about: about,
        userId: currentUser.id);
    setState(() {
      PasswordDatabaseHelper.addPassword(newPassword);
    });
  }

  void _deletePassword() {
    // print("delete password");
    setState(() {
      PasswordDatabaseHelper.deletePassword(selectedPassword!);
    });
  }

  // void _changeallPasswords() async {
  //   final all_passwords = await passwordDatabase.getAllPasswords();
  //   if (all_passwords != null) {
  //     // final user_passwords =
  //     //     all_passwords.where((pass) => pass.userId == currentUser.id).toList();

  //     for (final pass in all_passwords) {
  //       if (pass.userId == currentUser.id) {
  //         print(currentUserPassword);
  //         pass.password = encryptPassword(currentUserPassword, pass.password);
  //         setState() {
  //           passwordDatabase.updatePassword(pass);
  //         }
  //       }
  //     }
  //   }
  // }

  void _saveEditedUser(String name) {
    // final userDB = UserDatabaseHelper();
    setState(() {
      currentUser.name = name;
      // currentUserPassword = password;
    });
    // currentUser.password = getPasswordHash(password);
    UserDatabaseHelper.updateUser(currentUser);

    // if (currentUser.password != widget.originalUserPassword) {
    //   _changeallPasswords();
    // }
  }

  void _deleteCurrentUser() {
    // final userDB = UserDatabaseHelper();
    setState(() {
      PasswordDatabaseHelper.deletePasswordUsingUserId(currentUser);
      UserDatabaseHelper.deleteUser(currentUser);
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const LogInScreen()));
  }

  void _showCopySnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2), content: Text("Password Copied")));
  }

  void _copyPassword() async {
    final origPassword =
        decryptPassword(currentUserPassword, selectedPassword!.password);
    await Clipboard.setData(ClipboardData(text: origPassword));
    _showCopySnackbar();
  }

  @override
  void initState() {
    currentUser = widget.user;
    currentUserPassword = widget.originalUserPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Passwords",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: _onAddPasswordOverlay,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const LogInScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary,
              ))
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => UserScreen(
                          user: currentUser,
                          onSaveEditedUser: _saveEditedUser,
                          onDeleteUser: _deleteCurrentUser,
                        )));
          },
          icon: Icon(
            Icons.supervised_user_circle,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: FutureBuilder(
          future: PasswordDatabaseHelper.getAllPasswords(),
          builder: (context, AsyncSnapshot<List<PasswordInfo>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                // print(snapshot.data!.length);
                final userPasswords = snapshot.data!
                    .where((element) => element.userId == currentUser.id)
                    .toList();
                // print(userPasswords.length);
                return ListView.builder(
                  itemCount: userPasswords.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () async {
                        selectedPassword = userPasswords[index];
                        _onEditPasswordOverlay(selectedPassword!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              userPasswords[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  selectedPassword = userPasswords[index];
                                  _copyPassword();
                                },
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
            return const Center(
              child: Text("No Password Saved"),
            );
          }),
    );
  }
}
