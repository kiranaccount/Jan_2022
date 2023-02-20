@isTest
public class googleAddressLocatorTest {
    public static String INPUT_VALUE = 'Rutu Park';
    @isTest static void getSuggestionsTest() {
        Test.setMock(HttpCalloutMock.class, new googleAddressLocatorMockResponse());
        Test.startTest();
        String suggestions = googleAddressLocator.getSuggestions(INPUT_VALUE);
        Test.stopTest();
    }
    
    @isTest static void getPlaceDetailsTest() {
        Test.setMock(HttpCalloutMock.class, new googleAddressLocatorMockResponse());
        Test.startTest();
        String placesDetails = googleAddressLocator.getPlaceDetails(INPUT_VALUE);
        Test.stopTest();
    }
}