<cfquery name="ADD_ADRESS_CONTACT" datasource="#DSN#">
	INSERT INTO
		CONSUMER_BRANCH
	(
		CONSUMER_ID,
		STATUS,
		CONTACT_NAME,
		CONTACT_EMAIL,
		CONTACT_TELCODE,
		CONTACT_TEL1,
		CONTACT_TEL2,
		CONTACT_TEL3,
		CONTACT_FAX,
		CONTACT_ADDRESS,
		CONTACT_POSTCODE,
		CONTACT_COUNTY_ID,
		CONTACT_CITY_ID,
		CONTACT_COUNTRY_ID,
		CONTACT_SEMT,
		RECORD_DATE,	
		RECORD_EMP,
		RECORD_IP
	)
		VALUES
	(
		#attributes.consumer_id#,
		<cfif isdefined("attributes.contact_status")>1<cfelse>0</cfif>,
		'#attributes.contact_name#',
		'#attributes.contact_email#',
		'#attributes.contact_telcode#',
		'#attributes.contact_tel1#',
		'#attributes.contact_tel2#',
		'#attributes.contact_tel3#',
		'#attributes.contact_fax#',
		'#attributes.contact_address#',
		'#attributes.contact_postcode#',
		<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		<cfif len(attributes.contact_semt)>'#attributes.contact_semt#'<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
