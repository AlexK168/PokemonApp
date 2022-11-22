enum Mode{
  showFavoritesOnly,
  showAll
}

class ModeController{
  Mode mode = Mode.showAll;

  ModeController();

  void switchMode() {
    mode = mode == Mode.showAll ? Mode.showFavoritesOnly : Mode.showAll;
  }
}