<cfinclude template = "../../objects/query/session_base.cfm">
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.member_name=replacelist(form.member_name,list,list2)>
<cfset attributes.member_surname=replacelist(form.member_surname,list,list2)>
<cfquery name="UPD_CONSUMER" datasource="#DSN2#">
	UPDATE
		#dsn_alias#.CONSUMER 
	SET
		COMPANY = <cfif len(attributes.comp_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.cons_member_cat") and len(attributes.cons_member_cat)>
        	CONSUMER_CAT_ID = #cons_member_cat#,
        </cfif>
        <cfif isdefined("attributes.email") and len(attributes.email)>CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">,</cfif>
		CONSUMER_FAX = <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
		CONSUMER_FAXCODE = <cfif isdefined("attributes.faxcode") and  len(attributes.faxcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.faxcode#"><cfelse>NULL</cfif>,
		CONSUMER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_name#">,
		CONSUMER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_surname#">,
		MOBIL_CODE = <cfif isdefined("attributes.mobil_code") and len(attributes.mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code#"><cfelse>NULL</cfif>,
		MOBILTEL = <cfif isdefined("attributes.mobil_tel") and len(attributes.mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel#"><cfelse>NULL</cfif>,
		TAX_OFFICE = <cfif len(attributes.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_office#"><cfelse>NULL</cfif>,	
		TAX_NO = <cfif len(attributes.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_num#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.adres_type") and len(attributes.adres_type)>
			CONSUMER_HOMETEL = <cfif len(attributes.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#"><cfelse>NULL</cfif>,
			CONSUMER_HOMETELCODE = <cfif len(attributes.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
			HOMEADDRESS = <cfif len(attributes.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#"><cfelse>NULL</cfif>,
			HOME_COUNTY_ID = <cfif isdefined('attributes.county_id') and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
			HOME_CITY_ID = <cfif isdefined("attributes.city") and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
		<cfelse>
			CONSUMER_WORKTEL = <cfif len(attributes.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#"><cfelse>NULL</cfif>,
			CONSUMER_WORKTELCODE = <cfif len(attributes.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
			TAX_ADRESS = <cfif len(attributes.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#"><cfelse>NULL</cfif>,
			TAX_COUNTY_ID = <cfif isdefined('attributes.county_id') and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
			TAX_CITY_ID = <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
			TAX_COUNTRY_ID = <cfif isdefined('attributes.country') and len(attributes.country)>#attributes.country#<cfelse>1</cfif>,
		</cfif>
		MEMBER_CODE=<cfif len(attributes.member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.member_code)#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.ozel_kod") and len(attributes.ozel_kod)>
			OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">,
		</cfif>
		<cfif isdefined("attributes.mobil_code_2")>
			MOBIL_CODE_2 = <cfif len(attributes.mobil_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code_2#"><cfelse>NULL</cfif>,
		</cfif>
		<cfif isdefined("attributes.mobil_tel_2")>
			MOBILTEL_2 = <cfif len(attributes.mobil_tel_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel_2#"><cfelse>NULL</cfif>,
		</cfif>
		TC_IDENTY_NO = <cfif len(attributes.tc_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_num#"><cfelse>NULL</cfif>,
		VOCATION_TYPE_ID= <cfif isdefined("attributes.vocation_type") and len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
		IMS_CODE_ID = <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
		PERIOD_ID = #session_base.period_id#,
		UPDATE_DATE = #now()#,
	    UPDATE_EMP = #session_base.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		CONSUMER_ID = #attributes.consumer_id#
</cfquery>
<cfif isdefined("acc") and len(acc)>
	<cfquery name="UPD_COMP_PERIOD" datasource="#dsn2#">
		UPDATE
			#dsn_alias#.CONSUMER_PERIOD
		SET
			ACCOUNT_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#acc#">
		WHERE	
			CONSUMER_ID = #attributes.consumer_id#
			AND PERIOD_ID=#session_base.period_id#
	</cfquery>		
</cfif>

