import 'package:csv/csv.dart';

void main() {
  const csvString = 'id,name,email,age,role\n1,Alice,alice@example.com,28,Developer';
  final List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);
  print('Rows: ${csvData.length}');
  for (var i = 0; i < csvData.length; i++) {
    print('Row $i (${csvData[i].length} columns): ${csvData[i]}');
  }
  
  // Skip header
  final dataRows = csvData.skip(1).toList();
  print('Data rows after skip: ${dataRows.length}');
}
