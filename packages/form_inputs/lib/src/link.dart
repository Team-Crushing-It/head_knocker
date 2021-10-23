import 'package:formz/formz.dart';

enum LinkValidationError { invalid }

class Link extends FormzInput<String, LinkValidationError> {
  const Link.pure() : super.pure('');
  const Link.dirty([String value = '']) : super.dirty(value);

  @override
  LinkValidationError? validator(String? value) {
    return Uri.tryParse(value ?? '') == null
        ? LinkValidationError.invalid
        : null;
  }
}
