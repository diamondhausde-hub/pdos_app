import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../models/user_model.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/set_password_screen.dart';
import '../../features/auth/screens/upload_photo_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/change_password_screen.dart';

import '../../features/admin/screens/admin_shell.dart';
import '../../features/admin/screens/create_user_screen.dart';
import '../../features/admin/screens/user_detail_screen.dart';
import '../../features/general_manager/screens/general_manager_shell.dart';
import '../../features/supervisor/screens/supervisor_shell.dart';
import '../../features/supervisor/screens/brand_activity_log_screen.dart';
import '../../features/supervisor/screens/task_management_screen.dart';
import '../../features/rep/screens/rep_shell.dart';
import '../../features/rep/screens/visit_wizard_screen.dart';
import '../../features/rep/screens/doctor_visit_wizard_screen.dart';
import '../../features/rep/screens/visit_detail_screen.dart';
import '../../features/rep/screens/center_detail_screen.dart';
import '../../features/rep/screens/start_unscheduled_visit_screen.dart';
import '../../features/rep/screens/quick_scan_screen.dart';
import '../../features/rep/screens/submit_report_screen.dart';
import '../../features/rep/screens/visit_history_screen.dart';
import '../../features/rep/screens/field_reports_list_screen.dart';
import '../../features/rep/screens/products_screen.dart';
import '../../features/rep/screens/rep_tasks_tab.dart';
import '../../features/shared/screens/profile_screen.dart';
import '../../features/shared/screens/edit_profile_screen.dart';
import '../../features/shared/screens/notifications_screen.dart';
import '../../features/shared/screens/notes_history_screen.dart';
import '../../features/shared/screens/notification_settings_screen.dart';
import '../../features/shared/screens/about_screen.dart';
import '../../features/shared/screens/clients_screen.dart';
import '../../features/shared/screens/client_form_screen.dart';
import '../../features/shared/screens/client_detail_screen.dart';
import '../../features/admin/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final isInviteLogin = ref.watch(isInviteLinkProvider);

  return GoRouter(
    initialLocation: '/auth/login',
    redirect: (context, state) {
      final status = authState.status;
      final isLoggedIn = status == AuthStateStatus.authenticated;
      final isOnAuthRoute = state.matchedLocation.startsWith('/auth');

      // Still loading (checking token + cached user) — don't redirect yet
      if (status == AuthStateStatus.initial) {
        return null;
      }

      // Unauthenticated users go to login
      if (!isLoggedIn && !isOnAuthRoute) {
        return '/auth/login';
      }

      // Authenticated users
      if (isLoggedIn) {
        final user = authState.user;
        if (user == null) return null;

        // Forced password change for newly created accounts (Admin creates user with temp password)
        if (user.mustChangePassword && state.matchedLocation != '/auth/set-password') {
          return '/auth/set-password';
        }
        
        // Check if missing profile photo
        if (user.profileImageUrl == null && state.matchedLocation != '/auth/upload-photo' && !isInviteLogin) {
          return '/auth/upload-photo';
        }

        // Check if hasn't completed onboarding
        if (!user.hasCompletedOnboarding && state.matchedLocation != '/auth/onboarding' && user.profileImageUrl != null) {
          return '/auth/onboarding';
        }

        // If on auth route but fully setup, redirect to correct role shell
        if (isOnAuthRoute && user.hasCompletedOnboarding && user.profileImageUrl != null) {
          switch (user.role) {
            case UserRole.admin:
              return '/admin/overview';
            case UserRole.generalManager:
              return '/general-manager/overview';
            case UserRole.overseer:
              return '/overseer/overview';
            case UserRole.supervisor:
              return '/supervisor/inventory';
            case UserRole.rep:
              return '/rep/my-day';
          }
        }
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/set-password',
        builder: (context, state) => const SetPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/upload-photo',
        builder: (context, state) => const UploadPhotoScreen(),
      ),
      GoRoute(
        path: '/auth/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      
      // Rep routes
      GoRoute(
        path: '/rep/my-day',
        builder: (context, state) => const RepShell(),
      ),
      GoRoute(
        path: '/rep/active_visit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VisitWizardScreen(
            appointmentId: id == 'unscheduled' ? null : id,
            centerId: state.uri.queryParameters['centerId'] ?? '',
            clientId: state.uri.queryParameters['clientId'],
            taskId: state.uri.queryParameters['taskId'],
          );
        },
      ),
      GoRoute(
        path: '/rep/doctor-visit',
        builder: (context, state) => DoctorVisitWizardScreen(
          taskId: state.uri.queryParameters['taskId'],
          clientId: state.uri.queryParameters['clientId'],
        ),
      ),
      GoRoute(
        path: '/rep/visit/new',
        builder: (context, state) => StartUnscheduledVisitScreen(
          taskId: state.uri.queryParameters['taskId'],
          clientId: state.uri.queryParameters['clientId'],
        ),
      ),
      GoRoute(
        path: '/rep/quick-scan',
        builder: (context, state) => const QuickScanScreen(),
      ),
      GoRoute(
        path: '/rep/submit-report',
        builder: (context, state) => const SubmitReportScreen(),
      ),
      GoRoute(
        path: '/rep/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/rep/visit/:id',
        builder: (context, state) => VisitDetailScreen(
          visitId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/center/:id',
        builder: (context, state) => CenterDetailScreen(
          centerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/rep/center/:id',
        builder: (context, state) => CenterDetailScreen(
          centerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/rep/visit-history',
        builder: (context, state) => const VisitHistoryScreen(),
      ),
      GoRoute(
        path: '/rep/field-reports',
        builder: (context, state) => const FieldReportsListScreen(),
      ),
      GoRoute(
        path: '/rep/tasks',
        builder: (context, state) => const RepTasksTab(),
      ),
      
      // Supervisor routes
      GoRoute(
        path: '/supervisor/inventory',
        builder: (context, state) => const SupervisorShell(),
      ),
      GoRoute(
        path: '/supervisor/task-assignment',
        builder: (context, state) => const TaskManagementScreen(),
      ),
      GoRoute(
        path: '/supervisor/brand-activity-log',
        builder: (context, state) => const BrandActivityLogScreen(),
      ),
      
      // General Manager routes
      GoRoute(
        path: '/general-manager/overview',
        builder: (context, state) => const GeneralManagerShell(),
      ),
      
      // Admin routes
      GoRoute(
        path: '/admin/overview',
        builder: (context, state) => const AdminShell(),
      ),
      GoRoute(
        path: '/admin/create_user',
        builder: (context, state) => const CreateUserScreen(),
      ),
      GoRoute(
        path: '/admin/user/:id',
        builder: (context, state) => UserDetailScreen(
          userId: state.pathParameters['id']!,
        ),
      ),
      
      // Shared Routes
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/notes-history',
        builder: (context, state) => const NotesHistoryScreen(),
      ),
      GoRoute(
        path: '/notifications/settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      // Client routes
      GoRoute(
        path: '/clients',
        builder: (context, state) => const ClientsScreen(),
      ),
      GoRoute(
        path: '/clients/new',
        builder: (context, state) => ClientFormScreen(
          initialType: state.uri.queryParameters['type'],
        ),
      ),
      GoRoute(
        path: '/clients/edit/:id',
        builder: (context, state) => ClientFormScreen(clientId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/clients/:id',
        builder: (context, state) => ClientDetailScreen(
          clientId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
