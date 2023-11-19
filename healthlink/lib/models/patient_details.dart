// ignore_for_file: unnecessary_this

class CustomForm {
  String? name;
  String? age;
  String? number;
  String? gender;
  String? height;
  String? weight;
  bool? hasMedicalConditions;
  String? medicalConditions;
  String? medications;
  bool? hasHadRecentSurgeryOrProcedure;
  String? recentSurgeryOrProcedure;
  bool? isAllergicToAnyMedications;
  String? allergies;
  bool? doesSmokeCigarettes;
  String? smokingFrequency;
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
    drugsUsedAndFrequency = null;
  }

  void setValues(
    String name,
    String age,
    String number,
    String height,
    String weight,
    String medicalConditions,
    String medications,
    String recentSurgeryOrProcedure,
    String allergies,
    String smokingFrequency,
    String drinkingFrequency,
    String drugsUsedAndFrequency,
  ) {
    this.name = name;
    this.age = age;
    this.number = number;
    this.height = height;
    this.weight = weight;
    this.medicalConditions = medicalConditions;
    this.medications = medications;
    this.recentSurgeryOrProcedure = recentSurgeryOrProcedure;
    this.allergies = allergies;
    this.drinkingFrequency = drinkingFrequency;
    this.drugsUsedAndFrequency = drugsUsedAndFrequency;
    this.smokingFrequency = smokingFrequency;

    if (this.hasMedicalConditions == false) {
      this.medicalConditions = 'None';
      this.medications = 'None';
    }
    if (this.isAllergicToAnyMedications == false) {
      this.allergies = 'None';
    }
    if (this.doesSmokeCigarettes == false) {
      this.smokingFrequency = 'None';
    }
    if (this.doesDrinkAlcohol == false) {
      this.drinkingFrequency = 'None';
    }
    if (this.doesUseDrugs == false) {
      this.drugsUsedAndFrequency = 'None';
    }
  }

  bool validate() {
    print(this);
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

  // factory CustomForm.fromJson(Map<String, dynamic> json) {
  //   return CustomForm(
  //     name: json['name'],
  //     age: json['age'],
  //     number: json['number'],
  //     gender: json['gender'],
  //     height: json['height'],
  //     weight: json['weight'],
  //     medicalConditions: json['medicalConditions'],
  //     medications: json['medications'],
  //     recentSurgeryOrProcedure: json['recentSurgeryOrProcedure'],
  //     allergies: json['allergies'],
  //     doesSmokeCigarettes: json['doesSmokeCigarettes'],
  //     smokingFrequency: json['smokingFrequency'],
  //     drinkingFrequency: json['drinkingFrequency'],
  //     drugsUsedAndFrequency: json['drugsUsedAndFrequency'],
  //   );
  // }

  CustomForm.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    number = json['phoneNumber'];
    gender = json['gender'];
    height = json['height'];
    weight = json['weight'];
    medicalConditions = json['medicalCondition'];
    medications = json['medication'];
    recentSurgeryOrProcedure = json['surgeries'];
    smokingFrequency = json['smokingFrequency'];
    drinkingFrequency = json['drinkingFrequency'];
    drugsUsedAndFrequency = json['drugsUseFrequency'];
  }

  @override
  String toString() {
    return 'CustomForm{name: $name, age: $age, number: $number, gender: $gender, height: $height, weight: $weight, '
        'hasMedicalConditions: $hasMedicalConditions, medicalConditions: $medicalConditions, medications: $medications, '
        'hasHadRecentSurgeryOrProcedure: $hasHadRecentSurgeryOrProcedure, recentSurgeryOrProcedure: $recentSurgeryOrProcedure, '
        'isAllergicToAnyMedications: $isAllergicToAnyMedications, allergies: $allergies, doesSmokeCigarettes: $doesSmokeCigarettes, '
        'smokingFrequency: $smokingFrequency, doesDrinkAlcohol: $doesDrinkAlcohol, drinkingFrequency: $drinkingFrequency, '
        'doesUseDrugs: $doesUseDrugs, drugsUsedAndFrequency: $drugsUsedAndFrequency}';
  }
}
