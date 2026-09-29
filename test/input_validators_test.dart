import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/utils/input_validators.dart';

// The shared form validators: each passes a valid value (null) and reports
// the LangKeys message for an invalid one, "required" first.
void main() {
  final required = LangKeys.validationRequired.tr;

  test('required rejects empty and blank values', () {
    expect(InputValidators.required(null), required);
    expect(InputValidators.required('  '), required);
    expect(InputValidators.required('Jenny'), isNull);
  });

  test('selection needs a choice', () {
    expect(InputValidators.selection<int>(null), required);
    expect(InputValidators.selection(3), isNull);
  });

  test('email checks the address format', () {
    expect(InputValidators.email(''), required);
    expect(InputValidators.email('jenny'), LangKeys.validationEmailInvalid.tr);
    expect(InputValidators.email(' jennyfrost@gmail.com '), isNull);
  });

  test('age accepts whole years from minAge to maxAge', () {
    final range = LangKeys.validationAgeRange.trParams({
      'min': '${InputValidators.minAge}',
      'max': '${InputValidators.maxAge}',
    });
    expect(InputValidators.age(''), required);
    expect(InputValidators.age('0'), range);
    expect(InputValidators.age('${InputValidators.maxAge + 1}'), range);
    expect(InputValidators.age('eight'), range);
    expect(InputValidators.age('${InputValidators.minAge}'), isNull);
    expect(InputValidators.age(' 8 '), isNull);
    expect(InputValidators.age('${InputValidators.maxAge}'), isNull);
    expect('${InputValidators.maxAge}'.length, InputValidators.ageMaxDigits);
  });
}
