class PaginationService{
  static const int _defaultLimit = 20;
  static const int _defaultOffset = 0;
  static const int _defaultCount = 0;

  int limit = _defaultLimit;
  int currentOffset = _defaultOffset;
  int count = _defaultCount;


  void updateCount(int newCount) {
    count = newCount;
    while(currentOffset >= count && currentOffset > limit) {
      currentOffset -= limit;
    }
  }

  void toNextPage() {
    if (currentOffset < count - limit) {
      currentOffset += limit;
    }
  }

  void toPrevPage() {
    if (currentOffset >= limit) {
      currentOffset -= limit;
    }
  }

  bool endOfList() {
    return currentOffset >= count - limit;
  }

  bool startOfList() {
    return currentOffset <= 0;
  }
}