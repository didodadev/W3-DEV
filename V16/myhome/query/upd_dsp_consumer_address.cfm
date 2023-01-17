<cfif isdefined("attributes.contact_name") and len(attributes.contact_name)>
	<cfset attributes.contact_address = '#attributes.contact_main_street# #attributes.contact_street# #attributes.contact_door_no#'>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("attributes.contact_address") and len(attributes.contact_address)>
			<cfquery name="ADD_CONSUMER_CONTACT" datasource="#DSN#">
				INSERT INTO
					CONSUMER_BRANCH
				(
					CONSUMER_ID,
					STATUS,
					CONTACT_NAME,
					CONTACT_TELCODE,
					CONTACT_TEL1,
					CONTACT_ADDRESS,
					CONTACT_COUNTY_ID,
					CONTACT_CITY_ID,
					CONTACT_COUNTRY_ID,
					CONTACT_SEMT,		
					CONTACT_DISTRICT_ID,
					CONTACT_MAIN_STREET,
					CONTACT_STREET,
					CONTACT_DOOR_NO,
					RECORD_DATE,	
					RECORD_EMP,
					RECORD_IP
				)
					VALUES
				(
					#attributes.cons_id#,
					1,
					'#attributes.contact_name#',
					'#attributes.contact_telcode#',
					'#attributes.contact_tel#',
					<cfif len(attributes.contact_address)>'#attributes.contact_address#'<cfelse>NULL</cfif>,
					<cfif len(attributes.contact_county_id)>#attributes.contact_county_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.contact_city_id)>#attributes.contact_city_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.contact_country)>#attributes.contact_country#<cfelse>NULL</cfif>,
					<cfif len(attributes.contact_semt)>'#attributes.contact_semt#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contact_district_id") and len(attributes.contact_district_id)>#attributes.contact_district_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contact_main_street") and len(attributes.contact_main_street)>'#attributes.contact_main_street#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contact_street") and len(attributes.contact_street)>'#attributes.contact_street#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contact_door_no") and len(attributes.contact_door_no)>'#attributes.contact_door_no#'<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=myhome.my_consumer_details&cid=#attributes.cons_id#" addtoken="no">
