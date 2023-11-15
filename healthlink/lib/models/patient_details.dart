// ignore_for_file: unnecessary_this

class CustomForm {
  String? name;
  int? age;
  String? number;
  String? gender;
  double? height;
  double? weight;
  bool? hasMedicalConditions;
  String? medicalConditions;
  String? medications;
  bool? hasHadRecentSurgeryOrProcedure;
  String? recentSurgeryOrProcedure;
  bool? isAllergicToAnyMedications;
  String? allergies;
  bool? doesSmokeCigarettes;
  String? smokingFrequency;
  int? yearsSmoked;
  bool? doesDrinkAlcohol;
  String? drinkingFrequency;
  bool? doesUseDrugs;
  String? drugsUsedAndFrequency;

  String? get getName => this.name;

  set setName(String? name) => this.name = name;

  get getAge => this.age;

  set setAge(age) => this.age = age;

  String? get getNumber => this.number;

  set setNumber(String? number) => this.number = number;

  get getGender => this.gender;

  set setGender(gender) => this.gender = gender;

  get getHeight => this.height;

  set setHeight(height) => this.height = height;

  get getWeight => this.weight;

  set setWeight(weight) => this.weight = weight;

  bool? get getHasMedicalConditions => this.hasMedicalConditions;

  set setHasMedicalConditions(bool? hasMedicalConditions) =>
      this.hasMedicalConditions = hasMedicalConditions;

  get getMedicalConditions => this.medicalConditions;

  set setMedicalConditions(medicalConditions) =>
      this.medicalConditions = medicalConditions;

  get getMedications => this.medications;

  set setMedications(medications) => this.medications = medications;

  get getHasHadRecentSurgeryOrProcedure => this.hasHadRecentSurgeryOrProcedure;

  set setHasHadRecentSurgeryOrProcedure(hasHadRecentSurgeryOrProcedure) =>
      this.hasHadRecentSurgeryOrProcedure = hasHadRecentSurgeryOrProcedure;

  get getRecentSurgeryOrProcedure => this.recentSurgeryOrProcedure;

  set setRecentSurgeryOrProcedure(recentSurgeryOrProcedure) =>
      this.recentSurgeryOrProcedure = recentSurgeryOrProcedure;

  get getIsAllergicToAnyMedications => this.isAllergicToAnyMedications;

  set setIsAllergicToAnyMedications(isAllergicToAnyMedications) =>
      this.isAllergicToAnyMedications = isAllergicToAnyMedications;

  get getAllergies => this.allergies;

  set setAllergies(allergies) => this.allergies = allergies;

  get getDoesSmokeCigarettes => this.doesSmokeCigarettes;

  set setDoesSmokeCigarettes(doesSmokeCigarettes) =>
      this.doesSmokeCigarettes = doesSmokeCigarettes;

  get getSmokingFrequency => this.smokingFrequency;

  set setSmokingFrequency(smokingFrequency) =>
      this.smokingFrequency = smokingFrequency;

  get getYearsSmoked => this.yearsSmoked;

  set setYearsSmoked(yearsSmoked) => this.yearsSmoked = yearsSmoked;

  get getDoesDrinkAlcohol => this.doesDrinkAlcohol;

  set setDoesDrinkAlcohol(doesDrinkAlcohol) =>
      this.doesDrinkAlcohol = doesDrinkAlcohol;

  get getDrinkingFrequency => this.drinkingFrequency;

  set setDrinkingFrequency(drinkingFrequency) =>
      this.drinkingFrequency = drinkingFrequency;

  get getDoesUseDrugs => this.doesUseDrugs;

  set setDoesUseDrugs(doesUseDrugs) => this.doesUseDrugs = doesUseDrugs;

  get getDrugsUsedAndFrequency => this.drugsUsedAndFrequency;

  set setDrugsUsedAndFrequency(drugsUsedAndFrequency) =>
      this.drugsUsedAndFrequency = drugsUsedAndFrequency;

  CustomForm() {
    name = null;
    age = null;
    number = null;
    gender = null;
    height = null;
    weight = null;
    hasMedicalConditions = null;
    medicalConditions = null;
    medications = null;
    hasHadRecentSurgeryOrProcedure = null;
    recentSurgeryOrProcedure = null;
    isAllergicToAnyMedications = null;
    allergies = null;
    doesSmokeCigarettes = null;
    smokingFrequency = null;
    doesDrinkAlcohol = null;
    drinkingFrequency = null;
    doesUseDrugs = null;
  }

  bool? validate() {
    return name != null &&
        age != null &&
        number != null &&
        gender != null &&
        height != null &&
        weight != null &&
        hasMedicalConditions != null &&
        hasHadRecentSurgeryOrProcedure != null &&
        recentSurgeryOrProcedure != null &&
        isAllergicToAnyMedications != null &&
        allergies != null &&
        doesSmokeCigarettes != null &&
        smokingFrequency != null &&
        doesDrinkAlcohol != null &&
        drinkingFrequency != null &&
        doesUseDrugs != null &&
        drugsUsedAndFrequency != null;
  }

  void reset() {
    name = null;
    age = null;
    number = null;
    gender = null;
    height = null;
    weight = null;
    medicalConditions = null;
    medications = null;
    hasHadRecentSurgeryOrProcedure = null;
    recentSurgeryOrProcedure = null;
    isAllergicToAnyMedications = null;
    allergies = null;
    doesSmokeCigarettes = null;
    smokingFrequency = null;
    doesDrinkAlcohol = null;
    drinkingFrequency = null;
    doesUseDrugs = null;
    drugsUsedAndFrequency = null;
  }
}
