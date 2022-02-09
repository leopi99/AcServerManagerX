import 'package:acservermanager/models/enums/assists_enum.dart';
import 'package:equatable/equatable.dart';

class Assists extends Equatable {
  final AssistsEnum abs;
  final AssistsEnum tractionControl;
  final bool stabilityAid;
  final bool tyreBlankets;
  final bool forceVirtualMirror;

  const Assists({
    this.abs = AssistsEnum.denied,
    this.tractionControl = AssistsEnum.factory,
    this.forceVirtualMirror = true,
    this.stabilityAid = true,
    this.tyreBlankets = true,
  });

  Assists copyWith({
    AssistsEnum? abs,
    AssistsEnum? tractionControl,
    bool? stabilityAid,
    bool? tyreBlankets,
    bool? forceVirtualMirror,
  }) {
    return Assists(
      abs: abs ?? this.abs,
      tractionControl: tractionControl ?? this.tractionControl,
      forceVirtualMirror: forceVirtualMirror ?? this.forceVirtualMirror,
      stabilityAid: stabilityAid ?? this.stabilityAid,
      tyreBlankets: tyreBlankets ?? this.tyreBlankets,
    );
  }

  @override
  List<Object?> get props => [
        abs,
        tractionControl,
        forceVirtualMirror,
        stabilityAid,
        tyreBlankets,
      ];
}
