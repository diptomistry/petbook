import 'package:petbook/feature/contact/repository/contacts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsControllerProvider = FutureProvider(
      (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return contactsRepository.getAllContacts();
  },
);
