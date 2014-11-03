'use strict';

/* Services */


angular.module('travel-maps-services', [])

// ------------------------------------------------------------------------
// 
// ------------------------------------------------------------------------
.service('MapService', ['$log', function($log) {
	
	this.initMap = function() {
		// Enable the new Google Maps visuals until it gets enabled by default.
		// See http://googlegeodevelopers.blogspot.ca/2013/05/a-fresh-new-look-for-maps-api-for-all.html
	    // As we celebrate your maps, we’re also introducing the largest visible change in our eight year history: 
	    // a fresh new look and feel for the JavaScript and Static Maps APIs, in line with the launch of the new Google Maps.
	    // The new look is available for opt-in today, and is a simple one line code change: google.maps.visualRefresh=true;.
	    google.maps.visualRefresh = true;
	};
	
	// Return map data (map + markers) from position, zoom and markers.
	this.getMapData = function(position, zoom, markers) {
		var map = {};
		map.center =  {
		        latitude: position.coords.latitude,
		        longitude: position.coords.longitude
	    };
		map.zoom = (typeof zoom === "undefined") ? 8 : zoom;
		return {map:map, markers: markers};
	};
	
	// Return default map data (map + markers).
	this.getDefaultMapData = function() {
		// TODO: think about geolocalization.
	    /*
		if(navigator.geolocation) {
            navigator.geolocation.getCurrentPosition($scope.setMap);
		} else {
		    $scope.setMapData({coords: {latitude:47, longitude:-122}}, 2);  
		}
		*/

		return this.getMapData({coords: {latitude:0, longitude:0}}, 2, []);  
	};
	
	// Return map data (map + markers) from an array of stops.
	this.getMapFromStops = function(stops) {
		var map = {};
		
    	if (stops.length >= 1) {
    		map.markers = stops;
    		
    		var bounds = {
    			    southwest: {
    				    latitude: 0,
    					longitude: 0
    				},
    				northeast: {
    				    latitude: 0,
    				    longitude: 0
    				}
    			};
    		map.bounds = bounds;
    		map.center = {
	    	    latitude: 0,
	    		longitude: 0
	    	};
    		map.zoom = 9;    		    		
	    } else {
	    	map = this.getDefaultMapData().map;
	    	map.markers = [];
	    }
		return map;
	};
	
	// Update stops with id, icon, show, options, onMarkerClick.
	this.updateStops = function(stops) {
		for (var stopIndex=0; stopIndex < stops.length; stopIndex++) {
		    var currentStop = stops[stopIndex];
		    currentStop.id = stopIndex;
		    var stopLetter = String.fromCharCode(65 + (stopIndex%26));
			currentStop.icon = "img/static/blue_Marker" + stopLetter + ".png";
			currentStop.options = {
				labelContent: currentStop.title,
				labelClass: "marker-labels",
				draggable: true
			};
//			currentStop.events = {
//				dragend: function (marker, eventName, model, args) {
//			    	var dropLatitude = args[0].latLng.lat();
//		    		var dropLongitude =  args[0].latLng.lng();
//		    		$log.info("Dragend! latitude: " + dropLatitude + " longitude: " + dropLongitude);
//		    		marker.onDrop(dropLatitude, dropLongitude);
//				}
//			};
			currentStop.onStopClicked = function(){
				$log.info("onStopClicked " + stopLetter);
				
			};
    	}
	};
	
	// Reset stops.
	this.resetStops = function(stops) {
		for (var stopIndex=0; stopIndex < stops.length; stopIndex++) {
		    var currentStop = stops[stopIndex];
		    delete currentStop.id;
		    delete currentStop.icon;
		    delete currentStop.onMarkerClick;
		    delete currentStop.options;
    	}
	};
    
}])

// ------------------------------------------------------------------------
//
//------------------------------------------------------------------------
.service('PlacesService', ['$log', function($log) {
	
	// List of countries: code and name.
    var codesAndCountries = [
                      	      {code: 'AF', name:  'AFGHANISTAN'},
                      	      {code: 'AX', name:  'ÅLAND ISLANDS'},
                      	      {code: 'AL', name:  'ALBANIA'},
                      	      {code: 'DZ', name:  'ALGERIA'},
                      	      {code: 'AS', name:  'AMERICAN SAMOA'},
                      	      {code: 'AD', name:  'ANDORRA'},
                      	      {code: 'AO', name:  'ANGOLA'},
                      	      {code: 'AI', name:  'ANGUILLA'},
                      	      {code: 'AQ', name:  'ANTARCTICA'},
                      	      {code: 'AG', name:  'ANTIGUA AND BARBUDA'},
                      	      {code: 'AR', name:  'ARGENTINA'},
                      	      {code: 'AM', name:  'ARMENIA'},
                      	      {code: 'AW', name:  'ARUBA'},
                      	      {code: 'AU', name:  'AUSTRALIA'},
                      	      {code: 'AT', name:  'AUSTRIA'},
                      	      {code: 'AZ', name:  'AZERBAIJAN'},
                      	      {code: 'BS', name:  'BAHAMAS'},
                      	      {code: 'BH', name:  'BAHRAIN'},
                      	      {code: 'BD', name:  'BANGLADESH'},
                      	      {code: 'BB', name:  'BARBADOS'},
                      	      {code: 'BY', name:  'BELARUS'},
                      	      {code: 'BE', name:  'BELGIUM'},
                      	      {code: 'BZ', name:  'BELIZE'},
                      	      {code: 'BJ', name:  'BENIN'},
                      	      {code: 'BM', name:  'BERMUDA'},
                      	      {code: 'BT', name:  'BHUTAN'},
                      	      {code: 'BO', name:  'BOLIVIA, PLURINATIONAL STATE OF'},
                      	      {code: 'BQ', name:  'BONAIRE, SINT EUSTATIUS AND SABA'},
                      	      {code: 'BA', name:  'BOSNIA AND HERZEGOVINA'},
                      	      {code: 'BW', name:  'BOTSWANA'},
                      	      {code: 'BV', name:  'BOUVET ISLAND'},
                      	      {code: 'BR', name:  'BRAZIL'},
                      	      {code: 'IO', name:  'BRITISH INDIAN OCEAN TERRITORY'},
                      	      {code: 'BN', name:  'BRUNEI DARUSSALAM'},
                      	      {code: 'BG', name:  'BULGARIA'},
                      	      {code: 'BF', name:  'BURKINA FASO'},
                      	      {code: 'BI', name:  'BURUNDI'},
                      	      {code: 'KH', name:  'CAMBODIA'},
                      	      {code: 'CM', name:  'CAMEROON'},
                      	      {code: 'CA', name:  'CANADA'},
                      	      {code: 'CV', name:  'CAPE VERDE'},
                      	      {code: 'KY', name:  'CAYMAN ISLANDS'},
                      	      {code: 'CF', name:  'CENTRAL AFRICAN REPUBLIC'},
                      	      {code: 'TD', name:  'CHAD'},
                      	      {code: 'CL', name:  'CHILE'},
                      	      {code: 'CN', name:  'CHINA'},
                      	      {code: 'CX', name:  'CHRISTMAS ISLAND'},
                      	      {code: 'CC', name:  'COCOS (KEELING) ISLANDS'},
                      	      {code: 'CO', name:  'COLOMBIA'},
                      	      {code: 'KM', name:  'COMOROS'},
                      	      {code: 'CG', name:  'CONGO'},
                      	      {code: 'CD', name:  'CONGO, THE DEMOCRATIC REPUBLIC OF THE'},
                      	      {code: 'CK', name:  'COOK ISLANDS'},
                      	      {code: 'CR', name:  'COSTA RICA'},
                      	      {code: 'CI', name:  'CÔTE D\'IVOIRE'},
                      	      {code: 'HR', name:  'CROATIA'},
                      	      {code: 'CU', name:  'CUBA'},
                      	      {code: 'CW', name:  'CURAÇAO'},
                      	      {code: 'CY', name:  'CYPRUS'},
                      	      {code: 'CZ', name:  'CZECH REPUBLIC'},
                      	      {code: 'DK', name:  'DENMARK'},
                      	      {code: 'DJ', name:  'DJIBOUTI'},
                      	      {code: 'DM', name:  'DOMINICA'},
                      	      {code: 'DO', name:  'DOMINICAN REPUBLIC'},
                      	      {code: 'EC', name:  'ECUADOR'},
                      	      {code: 'EG', name:  'EGYPT'},
                      	      {code: 'SV', name:  'EL SALVADOR'},
                      	      {code: 'GQ', name:  'EQUATORIAL GUINEA'},
                      	      {code: 'ER', name:  'ERITREA'},
                      	      {code: 'EE', name:  'ESTONIA'},
                      	      {code: 'ET', name:  'ETHIOPIA'},
                      	      {code: 'FK', name:  'FALKLAND ISLANDS (MALVINAS)'},
                      	      {code: 'FO', name:  'FAROE ISLANDS'},
                      	      {code: 'FJ', name:  'FIJI'},
                      	      {code: 'FI', name:  'FINLAND'},
                      	      {code: 'FR', name:  'FRANCE'},
                      	      {code: 'GF', name:  'FRENCH GUIANA'},
                      	      {code: 'PF', name:  'FRENCH POLYNESIA'},
                      	      {code: 'TF', name:  'FRENCH SOUTHERN TERRITORIES'},
                      	      {code: 'GA', name:  'GABON'},
                      	      {code: 'GM', name:  'GAMBIA'},
                      	      {code: 'GE', name:  'GEORGIA'},
                      	      {code: 'DE', name:  'GERMANY'},
                      	      {code: 'GH', name:  'GHANA'},
                      	      {code: 'GI', name:  'GIBRALTAR'},
                      	      {code: 'GR', name:  'GREECE'},
                      	      {code: 'GL', name:  'GREENLAND'},
                      	      {code: 'GD', name:  'GRENADA'},
                      	      {code: 'GP', name:  'GUADELOUPE'},
                      	      {code: 'GU', name:  'GUAM'},
                      	      {code: 'GT', name:  'GUATEMALA'},
                      	      {code: 'GG', name:  'GUERNSEY'},
                      	      {code: 'GN', name:  'GUINEA'},
                      	      {code: 'GW', name:  'GUINEA-BISSAU'},
                      	      {code: 'GY', name:  'GUYANA'},
                      	      {code: 'HT', name:  'HAITI'},
                      	      {code: 'HM', name:  'HEARD ISLAND AND MCDONALD ISLANDS'},
                      	      {code: 'VA', name:  'HOLY SEE (VATICAN CITY STATE)'},
                      	      {code: 'HN', name:  'HONDURAS'},
                      	      {code: 'HK', name:  'HONG KONG'},
                      	      {code: 'HU', name:  'HUNGARY'},
                      	      {code: 'IS', name:  'ICELAND'},
                      	      {code: 'IN', name:  'INDIA'},
                      	      {code: 'ID', name:  'INDONESIA'},
                      	      {code: 'IR', name:  'IRAN, ISLAMIC REPUBLIC OF'},
                      	      {code: 'IQ', name:  'IRAQ'},
                      	      {code: 'IE', name:  'IRELAND'},
                      	      {code: 'IM', name:  'ISLE OF MAN'},
                      	      {code: 'IL', name:  'ISRAEL'},
                      	      {code: 'IT', name:  'ITALY'},
                      	      {code: 'JM', name:  'JAMAICA'},
                      	      {code: 'JP', name:  'JAPAN'},
                      	      {code: 'JE', name:  'JERSEY'},
                      	      {code: 'JO', name:  'JORDAN'},
                      	      {code: 'KZ', name:  'KAZAKHSTAN'},
                      	      {code: 'KE', name:  'KENYA'},
                      	      {code: 'KI', name:  'KIRIBATI'},
                      	      {code: 'KP', name:  'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF'},
                      	      {code: 'KR', name:  'KOREA, REPUBLIC OF'},
                      	      {code: 'KW', name:  'KUWAIT'},
                      	      {code: 'KG', name:  'KYRGYZSTAN'},
                      	      {code: 'LA', name:  'LAO PEOPLE\'S DEMOCRATIC REPUBLIC'},
                      	      {code: 'LV', name:  'LATVIA'},
                      	      {code: 'LB', name:  'LEBANON'},
                      	      {code: 'LS', name:  'LESOTHO'},
                      	      {code: 'LR', name:  'LIBERIA'},
                      	      {code: 'LY', name:  'LIBYA'},
                      	      {code: 'LI', name:  'LIECHTENSTEIN'},
                      	      {code: 'LT', name:  'LITHUANIA'},
                      	      {code: 'LU', name:  'LUXEMBOURG'},
                      	      {code: 'MO', name:  'MACAO'},
                      	      {code: 'MK', name:  'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF'},
                      	      {code: 'MG', name:  'MADAGASCAR'},
                      	      {code: 'MW', name:  'MALAWI'},
                      	      {code: 'MY', name:  'MALAYSIA'},
                      	      {code: 'MV', name:  'MALDIVES'},
                      	      {code: 'ML', name:  'MALI'},
                      	      {code: 'MT', name:  'MALTA'},
                      	      {code: 'MH', name:  'MARSHALL ISLANDS'},
                      	      {code: 'MQ', name:  'MARTINIQUE'},
                      	      {code: 'MR', name:  'MAURITANIA'},
                      	      {code: 'MU', name:  'MAURITIUS'},
                      	      {code: 'YT', name:  'MAYOTTE'},
                      	      {code: 'MX', name:  'MEXICO'},
                      	      {code: 'FM', name:  'MICRONESIA, FEDERATED STATES OF'},
                      	      {code: 'MD', name:  'MOLDOVA, REPUBLIC OF'},
                      	      {code: 'MC', name:  'MONACO'},
                      	      {code: 'MN', name:  'MONGOLIA'},
                      	      {code: 'ME', name:  'MONTENEGRO'},
                      	      {code: 'MS', name:  'MONTSERRAT'},
                      	      {code: 'MA', name:  'MOROCCO'},
                      	      {code: 'MZ', name:  'MOZAMBIQUE'},
                      	      {code: 'MM', name:  'MYANMAR'},
                      	      {code: 'NA', name:  'NAMIBIA'},
                      	      {code: 'NR', name:  'NAURU'},
                      	      {code: 'NP', name:  'NEPAL'},
                      	      {code: 'NL', name:  'NETHERLANDS'},
                      	      {code: 'NC', name:  'NEW CALEDONIA'},
                      	      {code: 'NZ', name:  'NEW ZEALAND'},
                      	      {code: 'NI', name:  'NICARAGUA'},
                      	      {code: 'NE', name:  'NIGER'},
                      	      {code: 'NG', name:  'NIGERIA'},
                      	      {code: 'NU', name:  'NIUE'},
                      	      {code: 'NF', name:  'NORFOLK ISLAND'},
                      	      {code: 'MP', name:  'NORTHERN MARIANA ISLANDS'},
                      	      {code: 'NO', name:  'NORWAY'},
                      	      {code: 'OM', name:  'OMAN'},
                      	      {code: 'PK', name:  'PAKISTAN'},
                      	      {code: 'PW', name:  'PALAU'},
                      	      {code: 'PS', name:  'PALESTINE, STATE OF'},
                      	      {code: 'PA', name:  'PANAMA'},
                      	      {code: 'PG', name:  'PAPUA NEW GUINEA'},
                      	      {code: 'PY', name:  'PARAGUAY'},
                      	      {code: 'PE', name:  'PERU'},
                      	      {code: 'PH', name:  'PHILIPPINES'},
                      	      {code: 'PN', name:  'PITCAIRN'},
                      	      {code: 'PL', name:  'POLAND'},
                      	      {code: 'PT', name:  'PORTUGAL'},
                      	      {code: 'PR', name:  'PUERTO RICO'},
                      	      {code: 'QA', name:  'QATAR'},
                      	      {code: 'RE', name:  'RÉUNION'},
                      	      {code: 'RO', name:  'ROMANIA'},
                      	      {code: 'RU', name:  'RUSSIAN FEDERATION'},
                      	      {code: 'RW', name:  'RWANDA'},
                      	      {code: 'BL', name:  'SAINT BARTHÉLEMY'},
                      	      {code: 'SH', name:  'SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA'},
                      	      {code: 'KN', name:  'SAINT KITTS AND NEVIS'},
                      	      {code: 'LC', name:  'SAINT LUCIA'},
                      	      {code: 'MF', name:  'SAINT MARTIN (FRENCH PART)'},
                      	      {code: 'PM', name:  'SAINT PIERRE AND MIQUELON'},
                      	      {code: 'VC', name:  'SAINT VINCENT AND THE GRENADINES'},
                      	      {code: 'WS', name:  'SAMOA'},
                      	      {code: 'SM', name:  'SAN MARINO'},
                      	      {code: 'ST', name:  'SAO TOME AND PRINCIPE'},
                      	      {code: 'SA', name:  'SAUDI ARABIA'},
                      	      {code: 'SN', name:  'SENEGAL'},
                      	      {code: 'RS', name:  'SERBIA'},
                      	      {code: 'SC', name:  'SEYCHELLES'},
                      	      {code: 'SL', name:  'SIERRA LEONE'},
                      	      {code: 'SG', name:  'SINGAPORE'},
                      	      {code: 'SX', name:  'SINT MAARTEN (DUTCH PART)'},
                      	      {code: 'SK', name:  'SLOVAKIA'},
                      	      {code: 'SI', name:  'SLOVENIA'},
                      	      {code: 'SB', name:  'SOLOMON ISLANDS'},
                      	      {code: 'SO', name:  'SOMALIA'},
                      	      {code: 'ZA', name:  'SOUTH AFRICA'},
                      	      {code: 'GS', name:  'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS'},
                      	      {code: 'SS', name:  'SOUTH SUDAN'},
                      	      {code: 'ES', name:  'SPAIN'},
                      	      {code: 'LK', name:  'SRI LANKA'},
                      	      {code: 'SD', name:  'SUDAN'},
                      	      {code: 'SR', name:  'SURINAME'},
                      	      {code: 'SJ', name:  'SVALBARD AND JAN MAYEN'},
                      	      {code: 'SZ', name:  'SWAZILAND'},
                      	      {code: 'SE', name:  'SWEDEN'},
                      	      {code: 'CH', name:  'SWITZERLAND'},
                      	      {code: 'SY', name:  'SYRIAN ARAB REPUBLIC'},
                      	      {code: 'TW', name:  'TAIWAN, PROVINCE OF CHINA'},
                      	      {code: 'TJ', name:  'TAJIKISTAN'},
                      	      {code: 'TZ', name:  'TANZANIA, UNITED REPUBLIC OF'},
                      	      {code: 'TH', name:  'THAILAND'},
                      	      {code: 'TL', name:  'TIMOR-LESTE'},
                      	      {code: 'TG', name:  'TOGO'},
                      	      {code: 'TK', name:  'TOKELAU'},
                      	      {code: 'TO', name:  'TONGA'},
                      	      {code: 'TT', name:  'TRINIDAD AND TOBAGO'},
                      	      {code: 'TN', name:  'TUNISIA'},
                      	      {code: 'TR', name:  'TURKEY'},
                      	      {code: 'TM', name:  'TURKMENISTAN'},
                      	      {code: 'TC', name:  'TURKS AND CAICOS ISLANDS'},
                      	      {code: 'TV', name:  'TUVALU'},
                      	      {code: 'UG', name:  'UGANDA'},
                      	      {code: 'UA', name:  'UKRAINE'},
                      	      {code: 'AE', name:  'UNITED ARAB EMIRATES'},
                      	      {code: 'GB', name:  'UNITED KINGDOM'},
                      	      {code: 'US', name:  'UNITED STATES'},
                      	      {code: 'UM', name:  'UNITED STATES MINOR OUTLYING ISLANDS'},
                      	      {code: 'UY', name:  'URUGUAY'},
                      	      {code: 'UZ', name:  'UZBEKISTAN'},
                      	      {code: 'VU', name:  'VANUATU'},
                      	      {code: 'VE', name:  'VENEZUELA, BOLIVARIAN REPUBLIC OF'},
                      	      {code: 'VN', name:  'VIET NAM'},
                      	      {code: 'VG', name:  'VIRGIN ISLANDS, BRITISH'},
                      	      {code: 'VI', name:  'VIRGIN ISLANDS, U.S.'},
                      	      {code: 'WF', name:  'WALLIS AND FUTUNA'},
                      	      {code: 'EH', name:  'WESTERN SAHARA'},
                      	      {code: 'YE', name:  'YEMEN'},
                      	      {code: 'ZM', name:  'ZAMBIA'},
                      	      {code: 'ZW', name:  'ZIMBABWE'}
                      	    ];
    
    this.getCountryCount = function() {
    	return codesAndCountries.length;
    };
  
    this.getCountryCode = function(index) {
    	return codesAndCountries[index].code;
    };
    
    this.getCountryName = function(index) {
    	return codesAndCountries[index].name;
    };
}]);