<cfquery name="ADD_PARTNER" datasource="#DSN#">
	UPDATE  
		COMPANY_PARTNER 
	SET
		COMPANY_PARTNER_NAME = '#attributes.name#',
		COMPANY_PARTNER_SURNAME = '#attributes.soyad#',
		TITLE = '#attributes.title#',
		SEX = #attributes.sex#,
		DEPARTMENT = <cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
		COMPANY_PARTNER_EMAIL = '#attributes.company_partner_email#',
		COMPANY_PARTNER_ADDRESS = <cfif isdefined('attributes.part_adres') and len(attributes.part_adres)>'#attributes.part_adres#'<cfelse>NULL</cfif>,
		MOBIL_CODE = <cfif isdefined('attributes.part_mobilcat_id') and len(attributes.part_mobilcat_id)>#attributes.part_mobilcat_id#<cfelse>NULL</cfif>,
		MOBILTEL= <cfif isdefined('attributes.part_mobiltel') and len(attributes.part_mobiltel)>#attributes.part_mobiltel#<cfelse>NULL</cfif>,
		COMPANY_PARTNER_TELCODE= <cfif isdefined('attributes.part_telcod') and len(attributes.part_telcod)>#attributes.part_telcod#<cfelse>NULL</cfif>,						
		COMPANY_PARTNER_TEL= <cfif isdefined('attributes.part_tel1') and len(attributes.part_tel1)>#attributes.part_tel1#<cfelse>NULL</cfif>,
		COMPANY_PARTNER_FAX= <cfif isdefined('attributes.part_fax') and len(attributes.part_fax)>#attributes.part_fax#<cfelse>NULL</cfif>,
		HOMEPAGE= <cfif isdefined('attributes.part_homepage') and len(attributes.part_homepage)>'#attributes.part_homepage#'<cfelse>NULL</cfif>,
		COUNTRY= <cfif isdefined('attributes.part_country') and len(attributes.part_country)>#attributes.part_country#<cfelse>NULL</cfif>,
		CITY= <cfif isdefined('attributes.part_city_id') and len(attributes.part_city_id)>#attributes.part_city_id#<cfelse>NULL</cfif>,
		COUNTY= <cfif isdefined('attributes.part_county_id') and len(attributes.part_county_id)>#attributes.part_county_id#<cfelse>NULL</cfif>,
		COMPANY_PARTNER_TEL_EXT = '#attributes.tel_local#',
		MISSION = <cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_PAR = <cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
        UPDATE_MEMBER = NULL,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.upd_my_partner&partner_id=#attributes.partner_id#&comp_id=#attributes.comp_id#" addtoken="no">
