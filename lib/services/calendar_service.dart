import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:medstar_appointment/model/appointment.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/services/user_management.dart';

enum CalendarView {
  WEEK,
  DAY;
}

class CalendarViewService extends ChangeNotifier {
  CalendarView _currentView = CalendarView.DAY;
  void changeView(CalendarView view) {
    if (_currentView != view) {
      _currentView = view;
      notifyListeners();
    }
  }

  bool get isWeekView => _currentView == CalendarView.WEEK;
  bool get isDayView => _currentView == CalendarView.DAY;
}

abstract class CalenderBaseService extends ChangeNotifier {
  void gotoToday();
  void gotoNext();
  void gotoPrevious();
  String get headerMonth;
  bool get isFetching;
  DateTime get date;
  List<AppointmentModel> get appointments;
}

class CalendarDayService extends CalenderBaseService {
  DateTime _date = DateTime.now();
  bool _isFetching = false;
  List<AppointmentModel> _appointments = [];
  late final AppointmentService _appointmentService;

  @override
  void gotoToday() {
    final today = DateFormat.yMd().format(DateTime.now());
    if (today != DateFormat.yMd().format(_date)) {
      _date = DateTime.now();
      notifyListeners();
      updateAppointments();
    }
  }

  @override
  void gotoNext() {
    _date = _date.add(const Duration(days: 1));
    notifyListeners();
    updateAppointments();
  }

  @override
  void gotoPrevious() {
    _date = _date.subtract(const Duration(days: 1));
    notifyListeners();
    updateAppointments();
  }

  void updateAppointments() async {
    _isFetching = true;
    notifyListeners();
    final start = DateTime(_date.year, _date.month, _date.day);
    final end = start.add(const Duration(days: 1));
    _appointments = await _appointmentService.getAppointmentBetween(start, end);
    _isFetching = false;
    notifyListeners();
  }

  @override
  DateTime get date => _date;
  @override
  bool get isFetching => _isFetching;
  @override
  String get headerMonth => DateFormat.yMMMM().format(_date);
  @override
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
}

class CalendarWeekService extends CalenderBaseService {
  DateTime _date = DateTime.now();
  late DateTime _firstDayOfWeek;
  late DateTime _lastDayOfWeek;
  List<AppointmentModel> _appointments = [];
  bool _isFetching = false;
  late final AppointmentService _appointmentService;

  CalendarWeekService() {
    _firstDateOfWeek();
    _lastDateOfWeek();
  }

  @override
  void gotoToday() {
    final today = DateFormat.yMd().format(DateTime.now());
    if (today != DateFormat.yMd().format(_date)) {
      _date = DateTime.now();
      _firstDateOfWeek();
      _lastDateOfWeek();
      notifyListeners();
    }
  }

  @override
  void gotoNext() {
    _date = _date.add(const Duration(days: 7));
    _firstDateOfWeek();
    _lastDateOfWeek();
    notifyListeners();
  }

  @override
  void gotoPrevious() {
    _date = _date.subtract(const Duration(days: 7));
    _firstDateOfWeek();
    _lastDateOfWeek();
    notifyListeners();
  }

  void _firstDateOfWeek() {
    int dateDay = _date.weekday - 1;
    _firstDayOfWeek = _date.subtract(Duration(days: dateDay));
  }

  void _lastDateOfWeek() {
    int dateDay = DateTime.daysPerWeek - _date.weekday;
    _lastDayOfWeek = _date.add(Duration(days: dateDay));
  }

  void updateAppointments() async {
    _isFetching = true;
    notifyListeners();
    final start = DateTime(
        _firstDayOfWeek.year, _firstDayOfWeek.month, _firstDayOfWeek.day);
    final end =
        DateTime(_lastDayOfWeek.year, _lastDayOfWeek.month, _lastDayOfWeek.day)
            .add(const Duration(days: 1));
    _appointments = await _appointmentService.getAppointmentBetween(start, end);
    _isFetching = false;
    notifyListeners();
  }

  @override
  DateTime get date => _date;
  @override
  bool get isFetching => _isFetching;
  DateTime get firstDayOfWeek => _firstDayOfWeek;
  DateTime get lastDayOfWeek => _lastDayOfWeek;
  @override
  String get headerMonth {
    if (_firstDayOfWeek.day > _lastDayOfWeek.day) {
      return '${DateFormat.MMM().format(_firstDayOfWeek)} - ${DateFormat.MMM().format(_lastDayOfWeek)} ${DateFormat.y().format(_lastDayOfWeek)}';
    } else {
      return DateFormat.yMMMM().format(_date);
    }
  }

  @override
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
}
