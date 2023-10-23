import 'package:petbook/common/modelss/user_model.dart';
import 'package:petbook/feature/contact/repository/contacts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsControllerProvider = FutureProvider<List<UserModel>>(
      (ref) async {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return await contactsRepository.getFirebaseContacts();
  },
);
