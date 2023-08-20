import 'package:bonfire/bonfire.dart';

class RotationPlayer extends Player with UseSpriteAnimation, UseAssetsLoader {
  SpriteAnimation? animIdle;
  SpriteAnimation? animRun;

  RotationPlayer({
    required Vector2 position,
    required Vector2 size,
    required Future<SpriteAnimation> animIdle,
    required Future<SpriteAnimation> animRun,
    double? speed,
    double currentRadAngle = -1.55,
    double life = 100,
  }) : super(
          position: position,
          size: size,
          life: life,
          speed: speed,
        ) {
    setupMovementByJoystick(
      moveType: MovementByJoystickType.angle,
    );
    movementByJoystickRadAngle = currentRadAngle;
    loader?.add(AssetToLoad(animIdle, (value) => this.animIdle = value));
    loader?.add(AssetToLoad(animRun, (value) => this.animRun = value));
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    super.joystickChangeDirectional(event);
    if (event.directional != JoystickMoveDirectional.IDLE && !isDead) {
      setAnimation(animRun);
    } else {
      setAnimation(animIdle);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle = movementByJoystickRadAngle;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    setAnimation(animIdle);
  }

  @override
  void onMount() {
    anchor = Anchor.center;
    super.onMount();
  }
}
