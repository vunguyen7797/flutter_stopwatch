import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/theme/color_palette.dart';
import 'package:flutter_stopwatch/utils/constants.dart';
import 'package:flutter_stopwatch/widgets/dub_button_widget.dart';
import 'package:provider/provider.dart';

import '../models/stopwatch_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: MediaQuery.of(context).size.width * 0.14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(kRadius),
                  ),

                  /// This one works but it will make the whole elapsed time text rebuilt for every update.
                  /// The width of the elapsed time text keeps redrawing due to the change of width of each digits.
                  /// This cause the shaking effect of the text when the millisecond running too fast.
                  // child: Center(
                  //   child: Text(
                  //     context.select((StopWatchModel watchModel) =>
                  //         watchModel.time.format()),
                  //     style: const TextStyle(
                  //       fontSize: 50,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  child: const _ElapsedTimeText(key: Key('ElapsedTimeText')),
                ),
              ),
              const SizedBox(height: 20),
              const _LapTimeList(key: Key('LapTimeList')),
              const SizedBox(height: 40),
              const _ButtonSlab(key: Key('ButtonSlab'))
            ],
          ),
        ),
      ),
    );
  }
}

class _ElapsedTimeText extends StatelessWidget {
  const _ElapsedTimeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 0,
          child: Text(
            context.select((StopWatchModel watchModel) =>
                '${watchModel.minute}:${watchModel.second}'),
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '.${context.select((StopWatchModel watchModel) => watchModel.millisecond)}',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ButtonSlab extends StatelessWidget {
  const _ButtonSlab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StopWatchModel>(
      builder: (context, model, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !model.isRunning &&
                      (model.time != Duration.zero || model.laps.isNotEmpty)
                  ? DubButton(
                      label: 'Reset',
                      onTap: model.onReset,
                    )
                  : DubButton(
                      label: 'Lap',
                      onTap: model.isRunning ? model.onLap : null),
              model.isRunning
                  ? DubButton(
                      label: 'Stop',
                      color: ColorPalette.kPink,
                      onTap: model.onStop,
                    )
                  : DubButton(
                      label: 'Start',
                      color: ColorPalette.kGreen,
                      onTap: model.onStart,
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _LapTimeList extends StatelessWidget {
  const _LapTimeList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var length =
        context.select((StopWatchModel watchModel) => watchModel.laps.length);
    return Expanded(
      flex: 2,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: length,
        itemBuilder: (context, index) {
          var item = context.read<StopWatchModel>().laps[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lap ${length - index}',
                  style: Theme.of(context).textTheme.labelLarge),
              Text(
                item,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey.withOpacity(0.1),
            thickness: 3,
          );
        },
      ),
    );
  }
}
