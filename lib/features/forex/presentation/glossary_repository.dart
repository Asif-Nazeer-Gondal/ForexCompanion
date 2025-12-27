import '../../domain/models/glossary_term.dart';

class GlossaryRepository {
  Future<List<GlossaryTerm>> fetchTerms() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    return [
      const GlossaryTerm(
        id: '1',
        term: 'Ask Price',
        definition: 'The price at which the market is prepared to sell a specific currency pair.',
      ),
      const GlossaryTerm(
        id: '2',
        term: 'Bid Price',
        definition: 'The price at which the market is prepared to buy a specific currency pair.',
      ),
      const GlossaryTerm(
        id: '3',
        term: 'Spread',
        definition: 'The difference between the bid and the ask price of a currency pair.',
      ),
      const GlossaryTerm(
        id: '4',
        term: 'Pip',
        definition: 'The smallest price change that a given exchange rate can make.',
      ),
      const GlossaryTerm(
        id: '5',
        term: 'Leverage',
        definition: 'The use of borrowed capital to increase the potential return of an investment.',
      ),
    ];
  }
}