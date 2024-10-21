import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class StepperInscricao extends StatelessWidget {
  final int step;
  const StepperInscricao({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: step,
      showLoadingAnimation: false,
      stepShape: StepShape.rRectangle,
      stepBorderRadius: 5,
      defaultStepBorderType: BorderType.normal,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      stepRadius: 20,
      lineStyle: const LineStyle(
        lineLength: 100,
        lineType: LineType.normal,
        lineThickness: 3,
        lineSpace: 1,
        lineWidth: 10,
        unreachedLineType: LineType.dashed,
      ),
      steps: const [
          EasyStep(
            icon: Icon(Icons.calendar_today_rounded),
            title: 'Nascimento',
            enabled: false,
          ),
          EasyStep(
            icon: Icon(Icons.group_rounded),
            title: 'Nomes',
            enabled: false,
          ),
          EasyStep(
            icon: Icon(Icons.map_rounded),
            title: 'Endereço',
            enabled: false,
          ),
          EasyStep(
            icon: Icon(Icons.contact_mail_rounded),
            title: 'Contato',
            enabled: false,
          ),
          EasyStep(
            icon: Icon(Icons.file_present_rounded),
            title: 'Batismo | Eucaristia',
            enabled: false,
          ),
          EasyStep(
            icon: Icon(Icons.pin_drop_rounded),
            title: 'Local',
            enabled: false,
          ),
        ],
    );
  }
}