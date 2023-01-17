<cfif not isdefined("attributes.contact_address")>
	<cfif len(attributes.door_no)>
		<cfset door_no = '#attributes.door_no#'>
	<cfelse>
		<cfset door_no = ''>
	</cfif>
	<cfif isdefined("attributes.district")>
		<cfset attributes.contact_address = '#attributes.district# #attributes.main_street# #attributes.street# #door_no#'>
	<cfelse>
		<cfset attributes.contact_address = '#attributes.main_street# #attributes.street# #door_no#'>
	</cfif>
</cfif>
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
		CONTACT_ADDRESS = <cfif len(attributes.contact_address)>'#attributes.contact_address#'<cfelse>NULL</cfif>,
		CONTACT_POSTCODE = '#attributes.contact_postcode#',
		CONTACT_COUNTY_ID = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		CONTACT_CITY_ID = <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		CONTACT_COUNTRY_ID = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		CONTACT_SEMT = <cfif len(attributes.contact_semt)>'#attributes.contact_semt#'<cfelse>NULL</cfif>,
		CONTACT_DISTRICT = <cfif isdefined("attributes.district") and len(attributes.district)>'#attributes.district#'<cfelse>NULL</cfif>,
		CONTACT_DISTRICT_ID = <cfif isdefined("attributes.district_id") and len(attributes.district_id)>#attributes.district_id#<cfelse>NULL</cfif>,
		CONTACT_MAIN_STREET = <cfif isdefined("attributes.main_street") and len(attributes.main_street)>'#attributes.main_street#'<cfelse>NULL</cfif>,
		CONTACT_STREET = <cfif isdefined("attributes.street") and len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
		CONTACT_DOOR_NO = <cfif isdefined("attributes.door_no") and len(attributes.door_no)>'#attributes.door_no#'<cfelse>NULL</cfif>,
		CONTACT_DELIVERY_NAME = <cfif isdefined("attributes.contact_delivery_name") and len(attributes.contact_delivery_name)>'#attributes.contact_delivery_name#'<cfelse>NULL</cfif>,
		CONTACT_DETAIL = <cfif isdefined("attributes.contact_detail") and len(attributes.contact_detail)>'#attributes.contact_detail#'<cfelse>NULL</cfif>,
		COMPANY_NAME = <cfif isdefined("attributes.company_name") and len(attributes.company_name)>'#attributes.company_name#'<cfelse>NULL</cfif>,
		IS_COMPANY = <cfif isdefined("attributes.is_company")>1<cfelse>0</cfif>,	
		TAX_NO = <cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
		TAX_OFFICE = <cfif isdefined("attributes.tax_office") and len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		CONTACT_ID = #attributes.contact_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.consumer_list&event=det&cid=#attributes.consumer_id#" addtoken="no">
