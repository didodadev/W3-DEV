<cfscript>
		get_county_action = createObject("component", "V16.settings.cfc.setupCounty");
		get_county_action.dsn = dsn;
		
		ADD_COUNTY = get_county_action.ADD_COUNTY_FNC
		(
			county_name :  '#iif(isdefined("attributes.county_name"),"attributes.county_name",DE(""))#',
			city_id :  '#iif(isdefined("attributes.city_id"),"attributes.city_id",DE(""))#',
			special_state :  '#iif(isdefined("attributes.special_state"),"attributes.special_state",DE(""))#');
</cfscript>
<script type="text/javascript">
	location.href = document.referrer;
</script>
