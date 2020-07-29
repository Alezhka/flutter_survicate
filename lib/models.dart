
abstract class SurvicateEvent { }

class SurveyDisplayed extends SurvicateEvent {

  final String surveyId;

  SurveyDisplayed(this.surveyId);

  @override
  String toString() =>
      'SurveyDisplayed { surveyId: $surveyId }';

}

class QuestionAnswered extends SurvicateEvent {

  final String surveyId;
  final int questionId;
  final SurvicateAnswer answer;

  QuestionAnswered(this.surveyId, this.questionId, this.answer);

  @override
  String toString() =>
      'QuestionAnswered { surveyId: $surveyId, questionId: $questionId, answer: $answer }';

}

class SurveyClosed extends SurvicateEvent {

  final String surveyId;

  SurveyClosed(this.surveyId);

  @override
  String toString() =>
      'SurveyClosed { surveyId: $surveyId }';

}

class SurveyCompleted extends SurvicateEvent {

  final String surveyId;

  SurveyCompleted(this.surveyId);

  @override
  String toString() =>
      'SurveyCompleted { surveyId: $surveyId }';

}

class SurvicateAnswer extends SurvicateEvent {

  final String type;
  final int id;
  final Set<int> ids;
  final String value;

  SurvicateAnswer(this.type, this.id, this.ids, this.value);

  @override
  String toString() =>
      'SurvicateAnswer { id: $id, type: $type, ids: $ids, value: $value }';

}

class UserTrait {

  final String key;
  final String value;

  UserTrait(this.key, this.value);

  factory UserTrait.website(String value) => UserTrait("website", value);

  factory UserTrait.phone(String value) => UserTrait("phone", value);

  factory UserTrait.jobTitle(String value) => UserTrait("job_title", value);

  factory UserTrait.department(String value) => UserTrait("department", value);

  factory UserTrait.organization(String value) => UserTrait("organization", value);

  factory UserTrait.email(String value) => UserTrait("email", value);

  factory UserTrait.lastName(String value) => UserTrait("last_name", value);

  factory UserTrait.firstName(String value) => UserTrait("first_name", value);

  factory UserTrait.userId(String value) => UserTrait("user_id", value);

  factory UserTrait.industry(String value) => UserTrait("industry", value);

  factory UserTrait.employees(String value) => UserTrait("employees", value);

  factory UserTrait.annualRevenue(String value) => UserTrait("annual_revenue", value);

  factory UserTrait.fax(String value) => UserTrait("fax", value);

  factory UserTrait.zipCode(String value) => UserTrait("zip", value);

  factory UserTrait.state(String value) => UserTrait("state", value);

  factory UserTrait.city(String value) => UserTrait("city", value);

  factory UserTrait.addressTwo(String value) => UserTrait("address_two", value);

  factory UserTrait.addressOne(String value) => UserTrait("address_one", value);

}
