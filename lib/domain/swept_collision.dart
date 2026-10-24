/// Returns true when a downward-moving, centered rectangle crosses the top of
/// a target rectangle during one update. Horizontal overlap is checked at the
/// target's current x position, so a large frame cannot tunnel through it.
bool sweptVerticalCatch({
  required double previousY,
  required double nextY,
  required double objectHeight,
  required double objectX,
  required double objectWidth,
  required double targetY,
  required double targetHeight,
  required double targetX,
  required double targetWidth,
}) {
  if (nextY < previousY) return false;
  final horizontalOverlap =
      (objectX - objectWidth / 2) <= (targetX + targetWidth / 2) &&
      (objectX + objectWidth / 2) >= (targetX - targetWidth / 2);
  if (!horizontalOverlap) return false;

  final previousBottom = previousY + objectHeight / 2;
  final nextBottom = nextY + objectHeight / 2;
  final targetTop = targetY - targetHeight / 2;
  return previousBottom <= targetTop && nextBottom >= targetTop;
}
