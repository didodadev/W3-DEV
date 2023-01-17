<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>		
		<cfquery name="UPD_COMPANY" datasource="#DSN#">
			UPDATE 
				COMPANY 
			SET
				COMPANY_STATE = #attributes.process_stage#,
				COMPANYCAT_ID = #attributes.companycat_id#,
				FULLNAME = '#attributes.fullname#',
				TAXNO = <cfif len(attributes.taxno)>'#attributes.taxno#'<cfelse>NULL</cfif>,
				TAXOFFICE = <cfif len(attributes.taxoffice)>'#attributes.taxoffice#'<cfelse>NULL</cfif>,
				COMPANY_EMAIL = '#attributes.email#',
				COMPANY_TELCODE = <cfif len(attributes.telcode)>'#attributes.telcode#'<cfelse>NULL</cfif>,
				COMPANY_TEL1 = <cfif len(attributes.telno)>'#attributes.telno#'<cfelse>NULL</cfif>,
				COMPANY_ADDRESS = '#attributes.address#',
				COMPANY_VALUE_ID = <cfif isDefined('attributes.customer_value') and len(attributes.customer_value)>#attributes.customer_value#<cfelse>NULL</cfif>,
				COUNTY = <cfif len(attributes.county_id) and len(attributes.county)>#attributes.county_id#<cfelse>NULL</cfif>,
				CITY = <cfif len(attributes.city_id) and len(attributes.city)>#attributes.city_id#<cfelse>NULL</cfif>,
				COUNTRY = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				NICKNAME = <cfif len(attributes.nickname)>'#attributes.nickname#'<cfelse>NULL</cfif>,
				RESOURCE_ID = <cfif isDefined('attributes.resource') and len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
				SALES_COUNTY = <cfif isDefined('attributes.sales_county') and len(attributes.sales_county)>#attributes.sales_county#<cfelse>NULL</cfif>,
				IMS_CODE_ID = <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
				SEMT = <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_EMP = #session.pda.userid#,
				UPDATE_DATE = #now()#
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfquery name="UPD_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER 
			SET
				COMPANY_PARTNER_NAME = '#attributes.name#',
				COMPANY_PARTNER_SURNAME = '#attributes.surname#',
				MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				SEX= #attributes.sex#
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfquery>

	</cftransaction>
</cflock>
<cfif isdefined("session.ep")>
	<cfscript>
		StructDelete(session,'ep'); 
	</cfscript>
</cfif>
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#attributes.company_id#" addtoken="no">	
