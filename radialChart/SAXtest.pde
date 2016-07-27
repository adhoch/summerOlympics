

void getLatLon() throws ParserConfigurationException, SAXException,
 IOException, XPathExpressionException {

  try { //File Path 

   String filePath = ("/Users/adamhoch/Documents/processing2/radialChart/data/countriesLat.xml");
   String elName = null;
   String country = null;

   //Read XML file. 
   Reader fileReader = new FileReader(filePath);
   //Get XMLInputFactory instance. 
   XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
   //Create XMLStreamReader object. 
   XMLStreamReader xmlStreamReader = xmlInputFactory.createXMLStreamReader(fileReader); //Iterate through events.
   while (xmlStreamReader.hasNext()) {
    //Get integer value of current event. 
    int xmlEvent = xmlStreamReader.next();

// If it's the start of the element gets the element name
    if (xmlEvent == XMLStreamConstants.START_ELEMENT) {

     elName = xmlStreamReader.getLocalName();

    }
// If it's the end of the element resets the element name. Not sure why this is neccesary
    if (xmlEvent == XMLStreamConstants.END_ELEMENT) {

     elName = "";

    }

    // Gets the country iso2code, assigns it to a variable
    if (xmlEvent == XMLStreamConstants.CHARACTERS) {
     if (elName == "country") {
      country = xmlStreamReader.getText();



     }

// if the current element is latitude 
     if (elName == "latitude") {

// Goes through every country in the list of countries 
      for (Map.Entry < String, country > Countries: Countries.entrySet()) {
// Matches the country entry to the latitude based on iso2 code
       if (country.toLowerCase().equals(Countries.getValue().countryAbbre.toLowerCase())) {

        Countries.getValue().setLat(float(xmlStreamReader.getText()));
        break;
       }
      }
     }
     
// if the current element is longitude
     if (elName == "longitude") {
     // Goes through every country in the list of countries
      for (Map.Entry < String, country > Countries: Countries.entrySet()) {
      // Matches the country entry to the latitude based on iso2 code
       if (country.toLowerCase().equals(Countries.getValue().countryAbbre.toLowerCase())) {
        Countries.getValue().setLon(float(xmlStreamReader.getText()));
        break;
       }
      }
     }


    }
   }


  } catch (Exception e) {
   e.printStackTrace();
  }

 }




void continents() throws ParserConfigurationException, SAXException,
 IOException, XPathExpressionException {

  try { //File Path 

   String filePath = ("/Users/adamhoch/Documents/processing2/radialChart/data/continents.xml");
   String elName = null;
   String country = null;

   //Read XML file. 
   Reader fileReader = new FileReader(filePath);
   //Get XMLInputFactory instance. 
   XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
   //Create XMLStreamReader object. 
   XMLStreamReader xmlStreamReader = xmlInputFactory.createXMLStreamReader(fileReader); //Iterate through events.
   while (xmlStreamReader.hasNext()) {
    //Get integer value of current event. 
    int xmlEvent = xmlStreamReader.next();

    if (xmlEvent == XMLStreamConstants.START_ELEMENT) {

     elName = xmlStreamReader.getLocalName();
     if (elName.equals("country")) {
      country = xmlStreamReader.getAttributeValue(null, "countryCode");

      for (Map.Entry < String, country > Countries: Countries.entrySet()) {
       if (country.toLowerCase().equals(Countries.getValue().countryAbbre.toLowerCase())) {
        Countries.getValue().setContinent(xmlStreamReader.getAttributeValue(null, "continent"));
       }
      }

     }

    }


   }



  } catch (Exception e) {
   e.printStackTrace();
  }

  for (Map.Entry < String, country > Countries: Countries.entrySet()) {
   
   // A list of countries that aren't in the list of continents. Mostly because they no longer exists
   if (Countries.getValue().continent == null) {
    if (Countries.getValue().countryName.equals("Soviet Union") | Countries.getValue().countryName.equals("Bohemia") | Countries.getValue().countryName.equals("Yugoslavia") | Countries.getValue().countryName.equals("Czechoslovakia") | Countries.getValue().countryName.equals("West Germany") | Countries.getValue().countryName.equals("East Germany") | Countries.getValue().countryName.equals("Saar") | Countries.getValue().countryName.equals("Crete") | Countries.getValue().countryName.equals("Serbia and Montenegro")) {
     Countries.getValue().setContinent("EU");
    }
    
    else if (Countries.getValue().countryName.equals("South Yemen") | Countries.getValue().countryName.equals("North Yemen") | Countries.getValue().countryName.equals("Malaya") | Countries.getValue().countryName.equals("South Vietnam") | Countries.getValue().countryName.equals("North Borneo")) {
     Countries.getValue().setContinent("AS");
    } else if (Countries.getValue().countryName.equals("Netherlands Antilles") | Countries.getValue().countryName.equals("West Indies Federation") | Countries.getValue().countryName.equals("Newfoundland")) {
     Countries.getValue().setContinent("NA");
    } else if (Countries.getValue().countryName.equals("Rhodesia") | Countries.getValue().countryName.equals("United Arab Republic")) {
     Countries.getValue().setContinent("AF");
    } else if (Countries.getValue().countryName.equals("Australasia")) {
     Countries.getValue().setContinent("OC");
    } else if (Countries.getValue().countryName.equals("Unified Team") | Countries.getValue().countryName.equals("Individual Olympic Athletes")) {
     Countries.getValue().setContinent("Olympics");
    }

   }
  }

 }



public LinkedHashMap < String, country > sortByContinent(HashMap map) {
 Map < String, country > LinkedHashMap = new LinkedHashMap < String, country > (map);
 LinkedHashMap < String, country > sortedMap = new LinkedHashMap < String, country > ();
 LinkedHashMap asia = new LinkedHashMap < String, country > ();
 LinkedHashMap africa = new LinkedHashMap < String, country > ();
 LinkedHashMap northAmerica = new LinkedHashMap < String, country > ();
 LinkedHashMap southAmerica = new LinkedHashMap < String, country > ();
 LinkedHashMap europe = new LinkedHashMap < String, country > ();
 LinkedHashMap oceania = new LinkedHashMap < String, country > ();
 LinkedHashMap olympic = new LinkedHashMap < String, country > ();
 for (Map.Entry < String, country > entry: LinkedHashMap.entrySet()) {
  if (entry.getValue().continent.equals("AS")) {
   asia.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("AF")) {
   africa.put(entry.getKey(), entry.getValue());

  } else if (entry.getValue().continent.equals("NA")) {
   northAmerica.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("SA")) {
   southAmerica.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("EU")) {
   europe.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("OC")) {
   oceania.put(entry.getKey(), entry.getValue());


  } else if (entry.getValue().continent.equals("Olympics")) {
   olympic.put(entry.getKey(), entry.getValue());


  } 

 }
 sortedMap.putAll(africa);
 sortedMap.putAll(europe);
 sortedMap.putAll(asia);
 sortedMap.putAll(oceania);
 sortedMap.putAll(southAmerica);
 sortedMap.putAll(northAmerica);
 sortedMap.putAll(olympic);
 for (Map.Entry < String, country > entry: sortedMap.entrySet()) {
   //Creates the list of country names in the new order
  countryNames2.add(entry.getKey());
  print(entry.getKey() + ",");
 }


 return sortedMap;

}