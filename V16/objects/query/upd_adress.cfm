<cfquery name="UPD_CONSUMER_CONTACT" datasource="#DSN#">
	UPDATE
		CONSUMER_BRANCH
	SET
		CONSUMER_ID = #attributes.consumer_id#,
		STATUS = <cfif isdefined("attributes.contact_status")>1<cfelse>0</cfif>,
		CONTACT_NAME = '#attributes.contact_name#',
		CONTACT_EMAIL = '#attributes.contact_email#',
		CONTACT_TELCODE = '#attributes.contact_telcode#',
		CONTACT_TEL1 = '#attributes.contact_tel1#',
		CONTACT_TEL2 = '#attributes.contact_tel2#',
		CONTACT_TEL3 = '#attributes.contact_tel3#',
		CONTACT_FAX = '#attributes.contact_fax#',
		CONTACT_ADDRESS = '#attributes.contact_address#',
		CONTACT_POSTCODE = '#attributes.contact_postcode#',
		CONTACT_COUNTY_ID = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		CONTACT_CITY_ID = <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		CONTACT_COUNTRY_ID = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		CONTACT_SEMT = <cfif len(attributes.contact_semt)>'#attributes.contact_semt#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		CONTACT_ID = #attributes.contact_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
