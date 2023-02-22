import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:medstar_appointment/model/appointment.dart';

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
  List<AppointmentModel> get appointments;
}

class CalendarDayService extends CalenderBaseService {
  DateTime _date = DateTime.now();
  List<AppointmentModel> _appointments = [];

  @override
  void gotoToday() {
    final today = DateFormat.yMd().format(DateTime.now());
    if (today != DateFormat.yMd().format(_date)) {
      _date = DateTime.now();
      notifyListeners();
    }
  }

  @override
  void gotoNext() {
    _date = _date.add(const Duration(days: 1));
    notifyListeners();
  }

  @override
  void gotoPrevious() {
    _date = _date.subtract(const Duration(days: 1));
    notifyListeners();
  }

  void updateAppointments({DateTime? forDay}) {}

  DateTime get date => _date;

  @override
  String get headerMonth => DateFormat.yMMMM().format(_date);

  @override
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
}

class CalendarWeekService extends CalenderBaseService {
  DateTime _date = DateTime.now();
  List<AppointmentModel> _appointments = [];

  @override
  void gotoToday() {
    final today = DateFormat.yMd().format(DateTime.now());
    if (today != DateFormat.yMd().format(_date)) {
      _date = DateTime.now();
      notifyListeners();
    }
  }

  @override
  void gotoNext() {
    _date = _date.add(const Duration(days: 7));
    notifyListeners();
  }

  @override
  void gotoPrevious() {
    _date = _date.subtract(const Duration(days: 7));
    notifyListeners();
  }

  DateTime firstDateOfWeek() {
    int dateDay = _date.weekday - 1;
    return _date.subtract(Duration(days: dateDay));
  }

  DateTime lastDateOfWeek() {
    int dateDay = DateTime.daysPerWeek - _date.weekday;
    return _date.add(Duration(days: dateDay));
  }

  void updateAppointments({DateTime? startDate, DateTime? endDate}) {}

  DateTime get date => _date;

  @override
  String get headerMonth {
    final firstDayOfWeek = firstDateOfWeek();
    final lastDayOfWeek = lastDateOfWeek();
    if (firstDayOfWeek.day > lastDayOfWeek.day) {
      return '${DateFormat.MMM().format(firstDayOfWeek)} - ${DateFormat.MMM().format(lastDayOfWeek)} ${DateFormat.y().format(lastDayOfWeek)}';
    } else {
      return DateFormat.yMMMM().format(_date);
    }
  }

  @override
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
}
