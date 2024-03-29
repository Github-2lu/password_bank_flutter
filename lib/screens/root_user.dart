import 'package:flutter/material.dart';
import 'package:password_bank_flutter/models/data_models.dart';
import 'package:password_bank_flutter/screens/log_in.dart';
import 'package:password_bank_flutter/services/database_helper.dart';
import 'package:password_bank_flutter/services/hash_encr_dcr.dart';
import 'package:password_bank_flutter/widgets/user_edit_form.dart';

class RootUserScreen extends StatefulWidget {
  const RootUserScreen({super.key});

  @override
  State<RootUserScreen> createState() {
    return _RootUserScreenState();
  }
}

class _RootUserScreenState extends State<RootUserScreen> {
  UserInfo? selectedUser;

  void _saveEditedUser(String name, String password) {
    if (selectedUser != null) {
      selectedUser!.name = name;
      selectedUser!.password = getPasswordHash(password);

      setState(() {
        UserDatabaseHelper.updateUser(selectedUser!);
      });
    }
  }

  void _deleteUser() {
    if (selectedUser != null) {
      setState(() {
        PasswordDatabaseHelper.deletePasswordUsingUserId(selectedUser!);
        UserDatabaseHelper.deleteUser(selectedUser!);
      });
    }
  }

  void _showUserEditForm() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (ctx) => UserEditForm(
            user: selectedUser!,
            onSaveUser: _saveEditedUser,
            onDeleteUser: _deleteUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Users",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (ctx) => const LogInScreen()));
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: UserDatabaseHelper.getAllUsers(),
        builder: (context, AsyncSnapshot<List<UserInfo>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No User in Database"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Card(
                child: Row(
                  children: [
                    Text(snapshot.data![index].name),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          selectedUser = snapshot.data![index];
                          _showUserEditForm();
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
