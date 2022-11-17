class PaginationService{
  final int limit;
  int currentOffset = 0;
  int count = 0;

  PaginationService({required this.limit});

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