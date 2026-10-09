import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lms_data.dart';
import '../../theme/app_theme.dart';

class StudentDashboardProfileScreen extends StatefulWidget {
  const StudentDashboardProfileScreen({super.key});

  @override
  State<StudentDashboardProfileScreen> createState() => _StudentDashboardProfileScreenState();
}

class _StudentDashboardProfileScreenState extends State<StudentDashboardProfileScreen> {
  late StudentProfileData _profile;
  bool _isEditing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _fatherCtrl;
  late TextEditingController _contactCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _qualCtrl;
  late TextEditingController _cnicCtrl;
  late TextEditingController _passportCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _profile = LMSMockData.profile;
    _nameCtrl = TextEditingController(text: _profile.name);
    _fatherCtrl = TextEditingController(text: _profile.fatherName);
    _contactCtrl = TextEditingController(text: _profile.contact);
    _emailCtrl = TextEditingController(text: _profile.email);
    _qualCtrl = TextEditingController(text: _profile.qualification);
    _cnicCtrl = TextEditingController(text: _profile.cnic);
    _passportCtrl = TextEditingController(text: _profile.passport);
    _countryCtrl = TextEditingController(text: _profile.country);
    _addressCtrl = TextEditingController(text: _profile.address);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _fatherCtrl.dispose();
    _contactCtrl.dispose();
    _emailCtrl.dispose();
    _qualCtrl.dispose();
    _cnicCtrl.dispose();
    _passportCtrl.dispose();
    _countryCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      _profile.name = _nameCtrl.text;
      _profile.fatherName = _fatherCtrl.text;
      _profile.contact = _contactCtrl.text;
      _profile.email = _emailCtrl.text;
      _profile.qualification = _qualCtrl.text;
      _profile.cnic = _cnicCtrl.text;
      _profile.passport = _passportCtrl.text;
      _profile.country = _countryCtrl.text;
      _profile.address = _addressCtrl.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile details updated successfully!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Student Dashboard',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit, size: 20),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F44B8).withAlpha(isDark ? 60 : 30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 40,
                          color: Color(0xFF0F44B8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WELCOME ${_profile.name} |',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _profile.email,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Enrolled Student',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_isEditing) ...[
                // Edit Form
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile Information',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Full Name', _nameCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Father Name', _fatherCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Contact Number', _contactCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Email ID', _emailCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Qualification', _qualCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('CNIC / B-Form', _cnicCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Passport No', _passportCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Country', _countryCtrl, isDark),
                      const SizedBox(height: 12),
                      _buildTextField('Address', _addressCtrl, isDark),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F44B8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Info Grid (same as LMS web portal)
                Text(
                  'Personal & Academic Details',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _buildInfoCard('FATHER NAME', _profile.fatherName, isDark),
                    _buildInfoCard('GENDER', _profile.gender, isDark),
                    _buildInfoCard('DATE OF BIRTH', _profile.dob, isDark),
                    _buildInfoCard('CONTACT', _profile.contact, isDark),
                    _buildInfoCard('EMERGENCY CONTACT', _profile.emergencyContact, isDark),
                    _buildInfoCard('EMAIL', _profile.email, isDark),
                    _buildInfoCard('QUALIFICATION', _profile.qualification, isDark),
                    _buildInfoCard('CNIC / B-FORM', _profile.cnic, isDark),
                    _buildInfoCard('PASSPORT NO', _profile.passport, isDark),
                    _buildInfoCard('COUNTRY', _profile.country, isDark),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADDRESS',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _profile.address,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
