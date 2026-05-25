import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_providers.dart';

class ConfirmDeleteAccountScreen extends ConsumerStatefulWidget{
  const ConfirmDeleteAccountScreen({super.key});

  @override
  ConsumerState<ConfirmDeleteAccountScreen> createState() =>
      _ConfirmDeleteAccountScreenState();
}

class _ConfirmDeleteAccountScreenState
    extends ConsumerState<ConfirmDeleteAccountScreen>{
  int _currentIndex = 4;
  final TextEditingController _confirmController = TextEditingController();
  bool _isDeleteEnabled = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(() {
      setState(() {
        _isDeleteEnabled = _confirmController.text.trim() == "DELETE";
      });
    });
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async{
    if (!_isDeleteEnabled){
      return;
    } 
    try {
      await ref.read(authProvider.notifier).deleteAccount();
      if (mounted) {
        context.go('/account-deleted');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 247, 254, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 247, 254, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(15, 41, 66, 1)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Delete Account Verification',
          style: TextStyle(
            color: Color.fromRGBO(15, 41, 66, 1),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 20,
          right: 20,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Icon(
                Icons.delete_outline,
                size: 56,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(15, 41, 66, 1),
                ),
              ),
              const SizedBox(height: 14),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(100, 116, 139, 1),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                        text:
                            "We're sorry to see you go. If you delete your account, you will lose all access to the "),
                    TextSpan(
                      text: "ShareNest",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " community resources"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(239, 246, 255, 1),
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                    left: BorderSide(
                      color: Color.fromRGBO(239, 68, 68, 1),
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Color.fromRGBO(15, 41, 66, 1),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'What you will lose:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(15, 41, 66, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLossItem(
                      "Community Resources",
                      "All items you've shared and your active lending history will be permanently wiped",
                    ),
                    const SizedBox(height: 14),
                    _buildLossItem(
                      "Karma Points and Reputation",
                      "Your earned trust score and community contributions cannot be recovered",
                    ),
                    const SizedBox(height: 14),
                    _buildLossItem(
                      "Account Connections",
                      "Active chat logs and neighbor connections will be severed immediately",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(100, 116, 139, 1),
                      letterSpacing: 0.5,
                    ),
                    children: [
                      TextSpan(text: "TO CONFIRM, PLEASE TYPE "),
                      TextSpan(
                        text: "DELETE",
                        style: TextStyle(color: Color.fromRGBO(239, 68, 68, 1)),
                      ),
                      TextSpan(text: "\nBELOW"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(219, 234, 254, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _confirmController,
                  decoration: const InputDecoration(
                    hintText: 'Type DELETE here',
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(148, 163, 184, 1), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 14,
                      bottom: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isDeleteEnabled ? _handleDelete : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(185, 28, 28, 1),
                    disabledBackgroundColor:
                        const Color.fromRGBO(185, 28, 28, 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Delete My Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(219, 234, 254, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Keep My Account',
                    style: TextStyle(
                      color: Color.fromRGBO(30, 41, 59, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if(index ==0){
            context.go('/home');
          } else if (index == 1){
            context.go('/browse');
          } else if (index == 2){
            context.go('/add-resource');
          } else if (index == 3){
            context.go('/loans');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(16, 185, 129, 1),
        unselectedItemColor: const Color.fromRGBO(100, 116, 139, 1),
        selectedLabelStyle:
            const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 10
              ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'HOME',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'BROWSE',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'ADD',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            label: 'LOANS',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 4,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(222, 247, 230, 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person,
                  color: Color.fromRGBO(16, 185, 129, 1)),
            ),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }

  Widget _buildLossItem(String title, String description){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.circle,
            size: 6,
            color: Color.fromRGBO(239, 68, 68, 1),
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(15, 41, 66, 1),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(71, 85, 105, 1),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
