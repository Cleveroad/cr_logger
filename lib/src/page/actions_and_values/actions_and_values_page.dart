import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/page/actions_and_values/actions_managed.dart';
import 'package:cr_logger/src/page/actions_and_values/notifiers_manager.dart';
import 'package:cr_logger/src/page/actions_and_values/widgets/action_item.dart';
import 'package:cr_logger/src/page/actions_and_values/widgets/value_notifier_item.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:flutter/material.dart';

/// Contains action buttons and value notifiers sections
/// The action buttons section calls defined callbacks
/// The value notifiers section display value of defined variables
class ActionsAndValuesPage extends StatelessWidget {
  const ActionsAndValuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        backgroundColor: CRLoggerColors.backgroundGrey,
        appBar: const CRAppBar(title: 'Actions and values'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Action buttons
              const Text(
                'Action buttons',
                style: CRStyle.subtitle1BlackSemiBold17,
              ),
              const SizedBox(height: 16),
              if (ActionsManager.actions.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ActionsManager.actions.length,
                  itemBuilder: (_, index) => ActionItem(
                    actionModel: ActionsManager.actions[index],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 40,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                )
              else
                const Center(
                  child: Text(
                    'There are no actions.\nAsk developer to add.',
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),

              /// Value notifiers
              const Text(
                'Value notifiers',
                style: CRStyle.subtitle1BlackSemiBold17,
              ),
              const SizedBox(height: 16),
              if (NotifiersManager.valueNotifiers.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: NotifiersManager.valueNotifiers.length,
                  itemBuilder: (_, index) => ValueNotifierItem(
                    notifierData: NotifiersManager.valueNotifiers[index],
                  ),
                  separatorBuilder: (_, __) => const Divider(),
                )
              else
                const Center(
                  child: Text(
                    'There are no values.\nAsk developer to add.',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
