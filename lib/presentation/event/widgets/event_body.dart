import 'package:va_monitoring/domain/alarm/event_list_point.dart';
import 'package:va_monitoring/domain/event/event_list.dart';
import 'package:va_monitoring/infrastructure/event/event_list_data_source.dart';
import 'package:va_monitoring/presentation/event/widgets/event_list_row_widget.dart';
import 'package:va_monitoring/presentation/event/widgets/position_controller.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class EventBody extends StatefulWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  // final DsClient _dsClient;
  final bool _reverse;
  final void Function(OperationState state)? _onState;
  /// 
  /// Builds event body using current user
  const EventBody({
    Key? key,
    // required AppUserStacked users,
    // required DsClient dsClient,
    bool? reverse,
    void Function(OperationState state)? onState,
  }) : 
    // _users = users,
    // _dsClient = dsClient,
    _reverse = reverse ?? false,
    _onState = onState,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<EventBody> createState() => _EventBodyState(
    // dsClient: _dsClient,
    reverse: _reverse,
    onState: _onState,
  );
}

///
class _EventBodyState extends State<EventBody> {
  // static const _debug = true;
  static const _listCount = 100;
  static const _cacheExtent = 500.0;
  // final DsClient _dsClient;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();
  final bool _reverse;
  final void Function(OperationState state)? _onState;
  late EventListDataSource<DsDataPoint> _listData;
  bool isLoading = false;
  bool isLoaded = false;
  ///
  _EventBodyState({
    // required DsClient dsClient,
    required bool reverse,
    required void Function(OperationState state)? onState,
  }) :
    // _dsClient = dsClient,
    _reverse = reverse,
    _onState = onState,
    super();
  //
  @override
  void initState() {
    super.initState();
    _listData = EventListDataSource<DsDataPoint>(
      context: context,
      newEventsReadDelay: 3000,
      listCount: _listCount,
      cacheExtent: _cacheExtent,
      positionController: PositionController(controller: _scrollController),
      eventList: EventList<EventListPoint>(
        remote: DataSource.dataSet('event'),
        dataMaper: (row) {
          return EventListPoint.fromRow(row);
        },
      ),
    );
    _listData.stateStream.listen((event) {
      final onState = _onState;
      if (onState != null) {
        onState(event);
      }      
      if (event == OperationState.success) {
        setState(() {return;});
      }      
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    log(EventBody._debug, '[$EventBody.build]');
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox.shrink()),
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
                  label: const Localized('To').v,
                  onComplete: (value) {
                    _listData.onDateToSubmitted(value);
                  },
                ),
              ),
              const SizedBox(width: 32.0),
              Image.asset(
                'assets/img/brand_icon.png',
                scale: 9.0,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
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
          child: _buildListView(context, _listData.list),
        ),
      ],
    );
  }
  ///
  Widget _buildListView(BuildContext context, List<DsDataPoint<dynamic>> list) {
    if (list.isNotEmpty) {
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
              return EventListRowWidget(
                key: UniqueKey(),
                point: _listData.list[index],
                highlite: highlite,
              );
            },
          ),
        ),
      );
    } else {
      return Center(child: Text(const Localized('No events').v));
    }
  }
  //
  @override
  void dispose() {
    _listData.dispose();
    _filterController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
