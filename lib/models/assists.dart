import 'package:acservermanager/models/enums/assists_enum.dart';

class Assists {
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
}
