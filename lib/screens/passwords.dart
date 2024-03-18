import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/widgets/new_password.dart';
import 'package:password_bank_flutter/screens/user.dart';
import 'package:password_bank_flutter/screens/log_in.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';
import 'package:flutter/services.dart';
import 'package:password_bank_flutter/widgets/search_field.dart';

class PasswordsScreen extends StatefulWidget {
  final UserInfo user;
  const PasswordsScreen({super.key, required this.user});
  @override
  State<PasswordsScreen> createState() {
    return _PasswordsScreenState();
  }
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  PasswordInfo? selectedPassword;
  late final UserInfo currentUser;
  bool _showSearchField = false;
  List<PasswordInfo> _allPasswords = [];
  String _initSearchText = "";

  void _onAddPasswordOverlay() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    final passwordInfoMap = {
      "title": password.title,
      "password": password.password,
      "about": password.about
    };

    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    if (selectedPassword != null && !isNewPassword) {
      selectedPassword!.title = title;
      selectedPassword!.password = password;
      selectedPassword!.about = about;
      setState(() {
        PasswordDatabaseHelper.updatePassword(selectedPassword!);
      });
      return;
    }

    final newPassword = PasswordInfo(
        title: title, password: password, about: about, userId: currentUser.id);
    setState(() {
      PasswordDatabaseHelper.addPassword(newPassword);
    });
  }

  void _deletePassword() {
    setState(() {
      PasswordDatabaseHelper.deletePassword(selectedPassword!);
    });
  }

  void _saveEditedUser(String name, String password) {
    setState(() {
      currentUser.name = name;
    });
    currentUser.password = getPasswordHash(password);
    UserDatabaseHelper.updateUser(currentUser);
  }

  void _deleteCurrentUser() {
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
    await Clipboard.setData(ClipboardData(text: selectedPassword!.password));
    _showCopySnackbar();
  }

  List<PasswordInfo> _searchPasswords() {
    List<PasswordInfo> searchedPasswords = [];
    searchedPasswords = _allPasswords
        .where((password) => password.title.contains(_initSearchText))
        .toList();

    return searchedPasswords;
  }

  void _changeSearchText(String searchText) {
    setState(() {
      _initSearchText = searchText;
    });
  }

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearchField
            ? SearchField(
                onSearchPassword: _changeSearchText,
              )
            : Text(
                "Passwords",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
        actions: _showSearchField
            ? null
            : [
                IconButton(
                    onPressed: _onAddPasswordOverlay,
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _showSearchField = true;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LogInScreen()));
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ))
              ],
        leading: _showSearchField
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showSearchField = false;
                    _initSearchText = "";
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                ))
            : IconButton(
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
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              _allPasswords = snapshot.data!
                  .where((element) => element.userId == currentUser.id)
                  .toList();

              _allPasswords = _searchPasswords();

              if (_allPasswords.isNotEmpty) {
                return ListView.builder(
                  itemCount: _allPasswords.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () async {
                        selectedPassword = _allPasswords[index];
                        _onEditPasswordOverlay(selectedPassword!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              _allPasswords[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  selectedPassword = _allPasswords[index];
                                  _copyPassword();
                                },
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("No Password Found"),
                );
              }
            }
            return const Center(child: Text("No Password Found"));
          }),
    );
  }
}
