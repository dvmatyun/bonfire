import 'dart:math';

import 'package:bonfire/bonfire.dart';

/// Mixin responsible for adding random movement like enemy walking through the scene
mixin AutomaticRandomMovement on Movement {
  Vector2 _targetRandomMovement = Vector2.zero();
  // ignore: constant_identifier_names
  static const _KEY_INTERVAL_KEEP_STOPPED = 'INTERVAL_RANDOM_MOVEMENT';

  late Random _random;

  bool get isVisibleReduction {
    // if (hasGameRef) {
    //   return gameRef.camera.cameraRect.overlapComponent(this);
    // }
    return false;
  }

  /// Method that bo used in [update] method.
  void runRandomMovement(
    double dt, {
    bool runOnlyVisibleInCamera = true,
    double speed = 20,
    int maxDistance = 50,
    int minDistance = 0,
    int timeKeepStopped = 2000,
    bool useAngle = false,

    /// milliseconds
  }) {
    if (runOnlyVisibleInCamera && !isVisibleReduction) {
      return;
    }

    if (_targetRandomMovement == Vector2.zero()) {
      if (checkInterval(_KEY_INTERVAL_KEEP_STOPPED, timeKeepStopped, dt)) {
        int randomX = _random.nextInt(maxDistance);
        randomX = randomX < minDistance ? minDistance : randomX;
        int randomY = _random.nextInt(maxDistance);
        randomY = randomY < minDistance ? minDistance : randomY;

        int randomNegativeX = _random.nextBool() ? -1 : 1;
        int randomNegativeY = _random.nextBool() ? -1 : 1;
        _targetRandomMovement = position.translated(
          randomX.toDouble() * randomNegativeX,
          randomY.toDouble() * randomNegativeY,
        );
        if (useAngle) {
          angle = BonfireUtil.angleBetweenPoints(
            rectConsideringCollision.center.toVector2(),
            _targetRandomMovement,
          );
        }
      }
    } else {
      bool canMoveX = (_targetRandomMovement.x - x).abs() > speed;
      bool canMoveY = (_targetRandomMovement.y - y).abs() > speed;

      bool canMoveLeft = false;
      bool canMoveRight = false;
      bool canMoveUp = false;
      bool canMoveDown = false;
      if (canMoveX) {
        if (_targetRandomMovement.x > x) {
          canMoveRight = true;
        } else {
          canMoveLeft = true;
        }
      }
      if (canMoveY) {
        if (_targetRandomMovement.y > y) {
          canMoveDown = true;
        } else {
          canMoveUp = true;
        }
      }
      if (useAngle) {
        if (canMoveX && canMoveY) {
          moveFromAngle(angle);
        } else {
          stopMove();
        }
      } else {
        if (canMoveLeft && canMoveUp) {
          moveUpLeft();
        } else if (canMoveLeft && canMoveDown) {
          moveDownLeft();
        } else if (canMoveRight && canMoveUp) {
          moveUpRight();
        } else if (canMoveRight && canMoveDown) {
          moveDownRight();
        } else if (canMoveRight) {
          moveRight();
        } else if (canMoveLeft) {
          moveLeft();
        } else if (canMoveUp) {
          moveUp();
        } else if (canMoveDown) {
          moveDown();
        } else {
          stopMove();
        }
      }
    }
  }

  @override
  void setZeroVelocity({bool isX = true, bool isY = true}) {
    _targetRandomMovement = Vector2.zero();
    idle();
    super.setZeroVelocity(isX: isX, isY: isY);
  }

  @override
  void onMount() {
    _random = Random(Random().nextInt(1000));
    super.onMount();
  }
}
