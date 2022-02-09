import 'package:acservermanager/models/enums/jump_start_enum.dart';
import 'package:equatable/equatable.dart';

class Realism extends Equatable {
  final int fuelRate;
  final int damageRate;
  final int tyreWearRate;
  final int allowedTyresOut;
  final int maxBallast;
  final bool disableGasCutPenalty;
  final JumpStartEnum jumpStartType;

  const Realism({
    this.fuelRate = 100,
    this.damageRate = 50,
    this.tyreWearRate = 100,
    this.allowedTyresOut = 2,
    this.maxBallast = 150,
    this.disableGasCutPenalty = false,
    this.jumpStartType = JumpStartEnum.teleportToPit,
  });

  @override
  List<Object?> get props => [
        fuelRate,
        damageRate,
        tyreWearRate,
        allowedTyresOut,
        maxBallast,
        disableGasCutPenalty,
        jumpStartType,
      ];
}
