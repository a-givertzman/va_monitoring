import 'package:va_monitoring/domain/alarm/alarm_list_point.dart';
import 'package:va_monitoring/domain/event/event_list_data.dart';
import 'package:va_monitoring/domain/event/event_list_data_filterd_by_date.dart';
import 'package:va_monitoring/domain/event/event_list_data_filterd_by_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:va_monitoring/presentation/alarm/widgets/alarm_list_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class AlarmListWidget extends StatefulWidget {
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  final bool _reverse;
  ///
  const AlarmListWidget({
    Key? key,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    bool reverse = false,
  }) : 
    _dsClient = dsClient,
    _listData = listData,
    _reverse = reverse,
    super(key: key);
  //
  @override
  State<AlarmListWidget> createState() => _AlarmListWidgetState(
    dsClient: _dsClient,
    listData: _listData,
    reverse: _reverse,
  );
}

///
class _AlarmListWidgetState extends State<AlarmListWidget> {
  final _log = const Log('_AlarmListWidgetState')..level = LogLevel.debug;
  final DsClient _dsClient;
  final AlarmListDataFilteredByText _listData;
  final bool _reverse;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _fromDateControlle = TextEditingController();
  final TextEditingController _untilDateControlle = TextEditingController();
  ///
  _AlarmListWidgetState({
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    required bool reverse,
  }) : 
    // _dsClient = dsClient,
    _listData = AlarmListDataFilteredByText<AlarmListPoint>(
      listData: AlarmListDataFilteredByDate<AlarmListPoint>(
        listData: listData,
      ),
    ),
    _reverse = reverse,
    _dsClient = dsClient,
    super();
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    const dateFieldWidth = 185.0;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('')),
              SizedBox(
                width: dateFieldWidth, 
                height: 48, 
                child: DateEditField(
                  label: const Localized('Date from').v,
                  onComplete: (value) {
                    _listData.onDateFromSubmitted(value);
                  },
                ),
              ),
              SizedBox(width: blockPadding),
              SizedBox(
                width: dateFieldWidth, 
                height: 48, 
                child: DateEditField(
                  label:  const Localized('To').v,
                  onComplete: (value) {
                    _listData.onDateToSubmitted(value);
                  },
                ),
              ),
              const SizedBox(width: 32.0),
              IconButton(
                tooltip: const Localized('Reset alarms').v,
                icon: Icon(
                  CupertinoIcons.refresh_thin,
                  color: Theme.of(context).colorScheme.primary,
                  size: const Setting('floatingActionIconSize').toDouble * 0.6,
                ), 
                onPressed: () {
                  DsSend<int>(
                    dsClient: _dsClient, 
                    pointName: DsPointName('/line1/ied12/db902_panel_controls/Control.Common.ResetAlarms'),
                  ).exec(1).then((result) {
                    if (result.hasError) {
                      _log.debug('reset command result has error:\n\t${result.error}');
                    }
                  });
                },
              ),
              const SizedBox(width: 32.0),
              SizedBox(
                width: dateFieldWidth * 2 + blockPadding,
                height: 48,
                child: TextFormField(
                  controller: _filterController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search),
                    labelText: const Localized('Find').v,
                  ),
                  onChanged: (value) {
                    _listData.onTextFilterSubmitted(_filterController.text);
                  },
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<OperationState>(
            stream: _listData.stateStream,
            builder: (context, snapshot) {
              if (_listData.list.isNotEmpty) {
                return Scrollbar(
                  thickness: 20.0,
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: _reverse,
                      physics: const AlwaysScrollableScrollPhysics(),
                      // cacheExtent: _cacheExtent,
                      itemCount: _listData.list.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        bool highlite = false;
                        // _log.debug('[.build.ListView.builder] point: ${_listData.list[index]}');
                        return AlarmListRowWidget(
                          key: UniqueKey(),
                          point: _listData.list[index],
                          onAcknowledgment: _listData.onAcknowledged,
                          highlite: highlite,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Center(child: Text(const Localized('No alarms').v));
              }
            },
          ),
        ),
      ],
    );
  }
  //
  @override
  void dispose() {
    _filterController.dispose();
    _fromDateControlle.dispose();
    _untilDateControlle.dispose();
    _listData.dispose();
    super.dispose();
  }
}