import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/vendor_profile.dart';

class ProfileController extends Notifier<VendorProfile> {
  @override
  VendorProfile build() =>
      VendorProfile.fromJson(ref.read(localStoreProvider).readProfile() ?? {});

  Future<void> save(VendorProfile next) async {
    state = next;
    await guardWrite(
        ref, () => ref.read(localStoreProvider).writeProfile(next.toJson()));
  }
}

final profileProvider =
    NotifierProvider<ProfileController, VendorProfile>(ProfileController.new);
