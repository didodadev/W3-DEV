<cfparam name="date_kontrol_degiskeni_1" default="0">
<cfparam name="date_kontrol_degiskeni_2" default="0">
<cfif isDefined("attributes.date1") and Len(attributes.date1) and date_kontrol_degiskeni_1 IS 0>
	<cfset url_str = "#url_str#&date1=#attributes.date1#">
	<cf_date tarih="attributes.date1">
	<cfset date_kontrol_degiskeni_1 = 1>
</cfif>
<cfif isDefined("attributes.date2") and Len(attributes.date2) and date_kontrol_degiskeni_2 IS 0>
	<cfset url_str = "#url_str#&date2=#attributes.date2#">
	<cf_date tarih="attributes.date2">
	<cfset date_kontrol_degiskeni_2 = 1>
</cfif>
<!--- <cfset all_pars_list = "">
<cfquery name="GET_PARS_IDS" datasource="#DSN3#">
	SELECT PAR_ID,TMARKET_ID FROM CAMPAIGN_TARGET_PEOPLE WHERE CAMP_ID = #attributes.camp_id# AND CON_ID IS NULL AND 
</cfquery>
<cfloop query="GET_PARS_IDS">
	<cfif len(all_pars_list)>
		<cfset all_pars_list = "#all_pars_list#,#PAR_ID#">
	<cfelse>
		<cfset all_pars_list = "#PAR_ID#">
	</cfif>
</cfloop> --->
<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
	<cfquery name="CONTROL_RECORD_EMP" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID 
		FROM 
			EMPLOYEES 
		WHERE 
			EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
			EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
	</cfquery>
</cfif>
<cfif isdefined("attributes.target_company_id") >
		<cfquery name="GET_PARS"  datasource="#dsn#">
			SELECT DISTINCT 2 
				TYPE,
				COMPANY.*,
				COMPANY_PARTNER.*,
				('#session.ep.name# #session.ep.surname#') as RECORD_EMP_NAME
			FROM
				COMPANY,
				COMPANY_PARTNER,
				#dsn3_alias#.CAMPAIGN_TARGET_PEOPLE  CAMPAIGN_TARGET_PEOPLE
			WHERE
				COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND 
				COMPANY_PARTNER.PARTNER_ID in (#attributes.target_company_id#) and 
				CAMPAIGN_TARGET_PEOPLE.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.camp_id#"> 
		</cfquery>
<cfelse>
<cfquery name="GET_PARS" datasource="#dsn#">
	SELECT 
	DISTINCT
		2 TYPE,
		WANT_EMAIL,
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.COMPANY_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER_FAX,
		COMPANY_PARTNER.MOBIL_CODE,
		COMPANY.NICKNAME,
		COMPANY.COMPANYCAT_ID,
		COMPANY.COUNTY,
		COMPANY.CITY,
		COMPANY.FULLNAME,
		COMPANY_PARTNER_ADDRESS,
		COMPANY_PARTNER_TELCODE,
		COMPANY_PARTNER_TEL,
		COMPANY_PARTNER_TEL_EXT,
		COMPANY_PARTNER.TITLE,
		COMPANY_PARTNER.MISSION,
		COMPANY_PARTNER.MEMBER_TYPE,
		COMPANY_PARTNER.DEPARTMENT,
		COMPANY_PARTNER.MOBILTEL,
		CAMPAIGN_TARGET_PEOPLE.CON_ID,
		(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CAMPAIGN_TARGET_PEOPLE.RECORD_EMP) RECORD_EMP_NAME,
		--CAMPAIGN_TARGET_PEOPLE.RECORD_DATE,
		COMPANYCAT
	FROM
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_CAT,
		#dsn3_alias#.CAMPAIGN_TARGET_PEOPLE  CAMPAIGN_TARGET_PEOPLE,
		#dsn3_alias#.CAMPAIGNS CAMPAIGNS
		<cfif isdefined('attributes.content_subject') and len(attributes.content_subject)>
		,SEND_CONTENTS
		</cfif>
	WHERE
		CAMPAIGN_TARGET_PEOPLE.CAMP_ID = #attributes.camp_id# AND
		<cfif isdefined('attributes.content_subject') and len(attributes.content_subject)>
			SEND_CONTENTS.SEND_PAR = CAMPAIGN_TARGET_PEOPLE.PAR_ID AND
			SEND_CONTENTS.CONT_ID = #attributes.content_subject# AND
		</cfif>
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
		CAMPAIGN_TARGET_PEOPLE.PAR_ID = COMPANY_PARTNER.PARTNER_ID AND
		CAMPAIGNS.CAMP_ID = CAMPAIGN_TARGET_PEOPLE.CAMP_ID
		 <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
			(
			COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR
			COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' OR
			COMPANY_PARTNER_EMAIL LIKE '%#attributes.keyword#%' OR
			TITLE LIKE '%#attributes.keyword#%' OR
			<!---COMPANY_PARTNER_ADDRESS LIKE '%#attributes.keyword#%' OR--->
			COMPANY.FULLNAME LIKE '%#attributes.keyword#%' OR
			COMPANY.NICKNAME LIKE '%#attributes.keyword#%'
		  <cfif CONTROL_RECORD_EMP.RECORDCOUNT>
		    OR CAMPAIGN_TARGET_PEOPLE.RECORD_EMP = #CONTROL_RECORD_EMP.EMPLOYEE_ID#
		  </cfif>
			)
		</cfif>
		<cfif isdefined("attributes.date1") and len(attributes.date1)>
			AND CAMPAIGN_TARGET_PEOPLE.RECORD_DATE >= #attributes.date1# 
		</cfif>
		<cfif isdefined("attributes.date2") and len(attributes.date2)>
			AND CAMPAIGN_TARGET_PEOPLE.RECORD_DATE <= #DATEADD("d",1,attributes.date2)#
		</cfif>
<!--- 		<cfif len(all_pars_list)>
			AND COMPANY_PARTNER.PARTNER_ID IN (#all_pars_list#)
		<cfelse>
			AND COMPANY_PARTNER.PARTNER_ID IN (0)
		</cfif> --->
		<cfif isdefined("attributes.employee") and len(attributes.employee) and isdefined("attributes.employee_id") and len(attributes.employee_id)>
			AND CAMPAIGN_TARGET_PEOPLE.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif isdefined('attributes.m_type') and len(attributes.m_type)>
			AND 2 = #attributes.m_type#
		</cfif>
		<cfif isdefined('attributes.want_email') and len(attributes.want_email)>
			AND WANT_EMAIL = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.want_email#">
		</cfif>
	ORDER BY
	<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 2>
		COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,
	</cfif>	
		NICKNAME,FULLNAME
</cfquery>
</cfif>

