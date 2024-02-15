abstract class SplashScreenEvent{}
class UpdateRotation extends SplashScreenEvent{
  final double angle;
  UpdateRotation(this.angle);
}