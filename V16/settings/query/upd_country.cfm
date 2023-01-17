<cfif isdefined("attributes.is_default")><cfset is_default = 1><cfelse><cfset is_default =0></cfif>

<cfset createObject("component","V16.settings.cfc.setupCountry").updCountry(
		country_id:attributes.country_id,
		country_name:attributes.country_name,
		country_phone_code:attributes.country_phone_code,
		country_code:attributes.country_code,
		is_default:is_default
	) />
	
	<script type="text/javascript">
		location.href = document.referrer;
	</script>
