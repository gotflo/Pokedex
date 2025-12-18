import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pokedex/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              color: whiteColor,
              image: AssetImage(
                'assets/icons/pokeball_black.png',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'P O K E D E X',
              style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.w900, color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
