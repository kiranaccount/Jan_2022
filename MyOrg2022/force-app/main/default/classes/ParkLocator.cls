public class ParkLocator {
    public static String[] country(String country){
      ParkService.ParksImplPort park = new ParkService.ParksImplPort();
        String[] parksname = park.byCountry(country);
        return parksname;
    }
}