import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../data/models/reservation_item.dart';
import '../widgets/reservation_confirmation_modal.dart';

class ReservationFormScreen extends ConsumerStatefulWidget{
  const ReservationFormScreen({super.key});

  @override
  ConsumerState<ReservationFormScreen> createState() =>
      _ReservationFormScreenState();
}

class _ReservationFormScreenState extends ConsumerState<ReservationFormScreen>{
  DateTime _pickupDate = DateTime.now().add(const Duration(days: 1));
  DateTime _returnDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _pickupTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 16, minute: 0);

  String get _durationLabel {
    final pickup = _dateTime(_pickupDate, _pickupTime);
    final ret = _dateTime(_returnDate, _returnTime);
    if (!ret.isAfter(pickup)) return 'Select valid dates';
    final diff = ret.difference(pickup);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    if (days > 0 && hours > 0) return '$days Day(s), $hours Hour(s)';
    if (days > 0) return '$days Day(s)';
    return '$hours Hour(s)';
  }

  DateTime _dateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickDate({required bool isPickup}) async {
    final initial = isPickup ? _pickupDate : _returnDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isPickup) {
        _pickupDate = picked;
        if (!_returnDate.isAfter(_pickupDate)){
          _returnDate = _pickupDate.add(const Duration(days: 1));
        }
      } 
      else {
        _returnDate = picked;
      }
    });
  }

  Future<void> _pickTime({required bool isPickup}) async{
    final initial = isPickup ? _pickupTime : _returnTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      if (isPickup) {
        _pickupTime = picked;
      } 
      else {
        _returnTime = picked;
      }
    });
  }

  Future<void> _confirm() async {
    final draft = ref.read(reservationDraftProvider);
    if (draft == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No item selected for reservation')),
      );
      return;
    }

    final pickup = _dateTime(_pickupDate, _pickupTime);
    final ret = _dateTime(_returnDate, _returnTime);
    if (!ret.isAfter(pickup)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Return date must be after pick-up date'),
        ),
      );
      return;
    }

    final user = ref.read(authProvider).user;
    final timeFormat = DateFormat.jm();
    final reservation = ReservationItem(
      id: 'res-${DateTime.now().millisecondsSinceEpoch}',
      resourceId: draft.resourceId,
      title: draft.resourceTitle,
      ownerId: '',
      borrowerId: user?.id ?? '',
      pickupLocation: 'Pickup from community hub',
      pickupDate: pickup,
      returnDate: ret,
      pickupTime: timeFormat.format(pickup),
      returnTime: timeFormat.format(ret),
      imagePath: draft.imagePath,
    );

    try {
      await ref.read(reservationsProvider.notifier).addReservation(reservation);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.statusCode == 409
              ? 'This time slot conflicts with an existing reservation. Please choose different dates.'
              : e.message),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref.read(reservationDraftProvider.notifier).clear();

    if (!mounted) return;
    context.push('/reservation-confirmation');
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(reservationDraftProvider);
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat.jm();

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reserve Item',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            draft != null
                                ? draft.resourceTitle
                                : 'Check availability and confirm your slot',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textGrey.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textDark),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Select Duration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabel('PICK-UP DATE'),
                const SizedBox(height: 8),
                _buildPickerField(
                  dateFormat.format(_pickupDate),
                  Icons.calendar_today_outlined,
                  () => _pickDate(isPickup: true),
                ),
                const SizedBox(height: 16),
                _buildLabel('PICK-UP TIME'),
                const SizedBox(height: 8),
                _buildPickerField(
                  timeFormat.format(_dateTime(_pickupDate, _pickupTime)),
                  Icons.access_time,
                  () => _pickTime(isPickup: true),
                ),
                const SizedBox(height: 16),
                _buildLabel('RETURN DATE'),
                const SizedBox(height: 8),
                _buildPickerField(
                  dateFormat.format(_returnDate),
                  Icons.calendar_today_outlined,
                  () => _pickDate(isPickup: false),
                ),
                const SizedBox(height: 16),
                _buildLabel('RETURN TIME'),
                const SizedBox(height: 8),
                _buildPickerField(
                  timeFormat.format(_dateTime(_returnDate, _returnTime)),
                  Icons.access_time,
                  () => _pickTime(isPickup: false),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loan Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated Duration',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  AppColors.textGrey.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            _durationLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (draft == null) return;
                      final pickup = _dateTime(_pickupDate, _pickupTime);
                      final ret = _dateTime(_returnDate, _returnTime);
                      if (!ret.isAfter(pickup)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Return date must be after pick-up date'),
                          ),
                        );
                        return;
                      }
                      final existingReservations = ref.read(reservationsProvider).value ?? [];
                      final hasRealConflict = existingReservations.any((r) => 
                        r.resourceId == draft.resourceId && 
                        r.pickupDate.year == _pickupDate.year &&
                        r.pickupDate.month == _pickupDate.month &&
                        r.pickupDate.day == _pickupDate.day
                      );

                      showReservationModal(
                        context: context,
                        title: draft.resourceTitle,
                        imagePath: draft.imagePath,
                        date: DateFormat('dd/MM/yyyy').format(_pickupDate),
                        time: timeFormat.format(pickup),
                        hasConflict: hasRealConflict,
                        onConfirm: () {
                          Navigator.pop(context);
                          _confirm();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Confirm Reservation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Cancel and Go Back',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPickerField(String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              icon,
              color: AppColors.textDark.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
