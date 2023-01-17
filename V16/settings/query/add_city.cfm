<cfscript>
		get_city_county_action = createObject("component", "V16.settings.cfc.setupCity");
		get_city_county_action.dsn = dsn;
		
		ADD_CITY = get_city_county_action.addCityFnc
		(
			country_id :  '#iif(isdefined("attributes.country"),"attributes.country",DE(""))#',
			city_name :  '#iif(isdefined("attributes.city_name"),"attributes.city_name",DE(""))#',
			phone_code :  '#iif(isdefined("attributes.phone_code"),"attributes.phone_code",DE(""))#',
			plate_code :  '#iif(isdefined("attributes.plate_code"),"attributes.plate_code",DE(""))#',
			priority :  '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#');
</cfscript>
<script type="text/javascript">
	location.href = document.referrer;
</script>
