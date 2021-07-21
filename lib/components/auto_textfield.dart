import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef void OnSuggestionSelected(String suggestion);

class AutoCompTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String labelText;
  final Iterable<String> options;
  final OnSuggestionSelected onSuggestionSelected;
  AutoCompTextField(
      {this.options,
      this.hintText,
      this.labelText,
      this.textEditingController,
      this.onSuggestionSelected});
  @override
  _AutoCompTextFieldState createState() => _AutoCompTextFieldState();
}

class _AutoCompTextFieldState extends State<AutoCompTextField> {
  Iterable<String> matchingWords(Iterable<String> stringList, String query) {
    return List.of(stringList).where((String string) {
      String stringLower = string.toLowerCase();
      String queryLower = query.toLowerCase();
      return stringLower.contains(queryLower);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      onSuggestionSelected: (String suggestion) {
        widget.textEditingController.text = suggestion;
        widget.onSuggestionSelected(suggestion);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      suggestionsCallback: (String keyword) {
        return matchingWords(widget.options, keyword);
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.textEditingController,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }
}
