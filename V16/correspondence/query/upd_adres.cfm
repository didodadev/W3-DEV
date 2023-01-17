<cfif isDefined ("url.id")>
	<cfif isDefined("attributes.special_emp")><cfset attributes.special_emp = session.ep.userid><cfelse><cfset attributes.special_emp = ""></cfif>
	<cf_addressbook
		design		= "2"
		id			= "#attributes.id#"
		name		= "#attributes.ab_name#"
		surname		= "#attributes.ab_surname#"
		sector_id	= "#attributes.ab_sector_id#"
		company_name= "#attributes.ab_company#"
		title		= "#attributes.ab_title#"
		email		= "#attributes.ab_email#"
		telcode		= "#attributes.ab_telcode#"
		telno		= "#attributes.ab_tel1#"
		telno2		= "#attributes.ab_tel2#"
		faxno		= "#attributes.ab_fax#"
		mobilcode	= "#attributes.ab_mobilcode#"
		mobilno		= "#attributes.ab_mobil#"
		web			= "#attributes.ab_web#"
		postcode	= "#attributes.ab_postcode#"
		address		= "#attributes.ab_address#"
		semt		= "#attributes.ab_semt#"
		county_id	= "#attributes.county_id#"
		city_id		= "#attributes.city_id#"
		country_id	= "#attributes.country_id#"
		info		= "#attributes.ab_info#"
		special_emp	= "#attributes.special_emp#">
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.addressbook" addtoken="No">
