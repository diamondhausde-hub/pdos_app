with open('lib/features/shared/screens/client_form_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

original = '''        final client = ClientModel(
          id: _existingClient?.id ?? const Uuid().v4(),
          clientType: _clientType,
          status: 'active', // Automatically mark as active on full save
          repId: user.id,
          doctorName: _doctorNameCtrl.text.isNotEmpty ? _doctorNameCtrl.text : null,
          facilityName: _facilityNameCtrl.text.isNotEmpty ? _facilityNameCtrl.text : null,
          specialty: _specialty,
          birthDate: _birthDate,
          classTier: _classTier,
          pharmacyType: _pharmacyType,
          institutionType: _institutionType,
          relationshipType: _relationshipType,
          scientificInterests: _scientificInterestsCtrl.text.isNotEmpty ? _scientificInterestsCtrl.text : null,
          productInterests: _productInterestsCtrl.text.isNotEmpty ? _productInterestsCtrl.text : null,
          keyContactName: _keyContactNameCtrl.text.isNotEmpty ? _keyContactNameCtrl.text : null,
          keyContactPosition: _keyContactPositionCtrl.text.isNotEmpty ? _keyContactPositionCtrl.text : null,
          keyContactPhone: _keyContactPhoneCtrl.text.isNotEmpty ? _keyContactPhoneCtrl.text : null,
          departments: _departmentsCtrl.text.isNotEmpty ? _departmentsCtrl.text : null,
          description: _descriptionCtrl.text.isNotEmpty ? _descriptionCtrl.text : null,
          phoneNumber: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : null,
          region: _regionCtrl.text.isNotEmpty ? _regionCtrl.text : null,
          area: _areaCtrl.text.isNotEmpty ? _areaCtrl.text : null,
          street: _streetCtrl.text.isNotEmpty ? _streetCtrl.text : null,
          nearbyLandmark: _landmarkCtrl.text.isNotEmpty ? _landmarkCtrl.text : null,
          photoUrl: _photoFile?.path,
          createdAt: _existingClient?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          synced: false,
        );'''

new_client = '''        final client = ClientModel(
          id: _existingClient?.id ?? const Uuid().v4(),
          clientType: _clientType,
          status: 'active', // Automatically mark as active on full save
          repId: user.id,
          doctorName: _doctorNameCtrl.text.isNotEmpty ? _doctorNameCtrl.text : null,
          facilityName: _facilityNameCtrl.text.isNotEmpty ? _facilityNameCtrl.text : null,
          specialty: _specialty,
          birthDate: _birthDate,
          classTier: _classTier,
          pharmacyType: _pharmacyType,
          institutionType: _institutionType,
          relationshipType: _relationshipType,
          scientificInterests: _scientificInterestsCtrl.text.isNotEmpty ? _scientificInterestsCtrl.text : null,
          productInterests: _productInterestsCtrl.text.isNotEmpty ? _productInterestsCtrl.text : null,
          keyContactName: _keyContactNameCtrl.text.isNotEmpty ? _keyContactNameCtrl.text : null,
          keyContactPosition: _keyContactPositionCtrl.text.isNotEmpty ? _keyContactPositionCtrl.text : null,
          keyContactPhone: _keyContactPhoneCtrl.text.isNotEmpty ? _keyContactPhoneCtrl.text : null,
          departments: _departmentsCtrl.text.isNotEmpty ? _departmentsCtrl.text : null,
          description: _descriptionCtrl.text.isNotEmpty ? _descriptionCtrl.text : null,
          phoneNumber: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : null,
          region: _regionCtrl.text.isNotEmpty ? _regionCtrl.text : null,
          area: _areaCtrl.text.isNotEmpty ? _areaCtrl.text : null,
          street: _streetCtrl.text.isNotEmpty ? _streetCtrl.text : null,
          nearbyLandmark: _landmarkCtrl.text.isNotEmpty ? _landmarkCtrl.text : null,
          photoUrl: _photoFile?.path ?? _existingClient?.photoUrl,
          latitude: _existingClient?.latitude,
          longitude: _existingClient?.longitude,
          gender: _existingClient?.gender,
          rating: _existingClient?.rating,
          treatmentQuality: _existingClient?.treatmentQuality,
          createdAt: _existingClient?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          synced: false,
        );'''

text = text.replace(original, new_client)

with open('lib/features/shared/screens/client_form_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
