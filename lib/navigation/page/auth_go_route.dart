import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/presentation/home/screen/add_employee_attendence_screen.dart';
import 'package:supabase_demo/presentation/home/screen/add_employee_screen.dart';
import 'package:supabase_demo/presentation/home/screen/employee_attendance_screen.dart';
import 'package:supabase_demo/presentation/home/screen/employees_list_screen.dart';
import 'package:supabase_demo/navigation/route.dart';
import 'package:supabase_demo/navigation/route_name_constant.dart';
import 'package:supabase_demo/presentation/auth/screen/auth_screen.dart';

class AppRoute {
  /// auth

  static final auth = GoRoute(
    path: RouteNameConstant.auth,
    redirect: Routes.redirect(),
    pageBuilder: (context, state) {
      return const CupertinoPage(
        key: ValueKey("Auth-Page"),
        child: AuthScreen(),
      );
    },
  );

  static final employeeList = GoRoute(
    path: RouteNameConstant.employeeList,
    redirect: Routes.redirectIfLoggedOut(),
    pageBuilder: (context, state) {
      return const CupertinoPage(
        key: ValueKey("EmployeeListScreen-Page"),
        child: EmployeeListScreen(),
      );
    },
  );

  static final employeeAttendance = GoRoute(
    path: RouteNameConstant.employeeAttendance,
    redirect: Routes.redirectIfLoggedOut(),
    pageBuilder: (context, state) {
      final employeeID = state.pathParameters['employeeID'] ?? "";
      final employeeName = state.extra as String;

      return CupertinoPage(
        key: const ValueKey("EmployeeAttendanceScreen-Page"),
        child: EmployeeAttendanceScreen(
          employeeId: employeeID,
          employeeName: employeeName,
        ),
      );
    },
  );

  static final addEmployeeAttendance = GoRoute(
    path: RouteNameConstant.addEmployeeAttendance,
    redirect: Routes.redirectIfLoggedOut(),
    pageBuilder: (context, state) {
      final employeeID = state.pathParameters['employeeID'] ?? "";
      final employeeName = state.extra as String;

      return CupertinoPage(
        key: const ValueKey("AddEditAttendanceScreen-Page"),
        child: AddEditAttendanceScreen(
          employeeId: employeeID,
          employeeName: employeeName,
        ),
      );
    },
  );

  static final addEmployee = GoRoute(
    path: RouteNameConstant.addEmployee,
    redirect: Routes.redirectIfLoggedOut(),
    pageBuilder: (context, state) {
      return const CupertinoPage(
        key: ValueKey("AddEmployeeScreen-Page"),
        child: AddEmployeeScreen(),
      );
    },
  );
}
