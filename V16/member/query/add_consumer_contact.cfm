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
<cfquery name="ADD_CONSUMER_CONTACT" datasource="#DSN#">
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
		CONTACT_DISTRICT,
		CONTACT_DISTRICT_ID,
		CONTACT_MAIN_STREET,
		CONTACT_STREET,
		CONTACT_DOOR_NO,
		CONTACT_DELIVERY_NAME,
		CONTACT_DETAIL,
		COMPANY_NAME,
		IS_COMPANY,
		TAX_NO,
		TAX_OFFICE,
		RECORD_DATE,	
		RECORD_EMP,
		RECORD_IP
	)
		VALUES
	(
		#attributes.consumer_id#,
		<cfif isdefined("attributes.contact_status")>1<cfelse>0</cfif>,
		'#attributes.contact_name#',
		<cfif len(attributes.contact_email)>'#attributes.contact_email#'<cfelse>NULL</cfif>,
		'#attributes.contact_telcode#',
		'#attributes.contact_tel1#',
		<cfif len(attributes.contact_tel2)>'#attributes.contact_tel2#'<cfelse>NULL</cfif>,
		<cfif len(attributes.contact_tel3)>'#attributes.contact_tel3#'<cfelse>NULL</cfif>,
		<cfif len(attributes.contact_fax)>'#attributes.contact_fax#'<cfelse>NULL</cfif>,
		<cfif len(attributes.contact_address)>'#attributes.contact_address#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.contact_postcode") and len(attributes.contact_postcode)>'#attributes.contact_postcode#'<cfelse>NULL</cfif>,
		<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.city_id') and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		<cfif len(attributes.contact_semt)>'#attributes.contact_semt#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.district") and len(attributes.district)>'#attributes.district#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.district_id") and len(attributes.district_id)>#attributes.district_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.main_street") and len(attributes.main_street)>'#attributes.main_street#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.street") and len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.door_no") and len(attributes.door_no)>'#attributes.door_no#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.contact_delivery_name") and len(attributes.contact_delivery_name)>'#attributes.contact_delivery_name#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.contact_detail") and len(attributes.contact_detail)>'#attributes.contact_detail#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.company_name") and len(attributes.company_name)>'#attributes.company_name#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_company")>1<cfelse>0</cfif>,	
		<cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.tax_office") and len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.consumer_list&event=det&cid=#attributes.consumer_id#" addtoken="no">

<script>
	<cfif  isDefined ("attributes.draggable")>
		CloseBoxDraggable();
	</cfif>
</script>

