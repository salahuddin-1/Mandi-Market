import 'package:mandimarket/src/blocs/Master_BLOC/feed_entries_to_master.dart';

// Especially made for bloc
// This class just Holds the data
// The data can be anything (instance, String)
// And this data will be accessible to all the parent children
class MasterDataHolder {
  static FeedEntriesToMasterBLOC? _feedEntriesToMasterBLOC;

  static FeedEntriesToMasterBLOC get value => _feedEntriesToMasterBLOC!;

  MasterDataHolder.setValue(FeedEntriesToMasterBLOC value) {
    _feedEntriesToMasterBLOC = value;
  }
}
