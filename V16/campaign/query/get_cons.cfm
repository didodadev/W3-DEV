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
<cfquery name="GET_CONS" datasource="#dsn#">
	SELECT DISTINCT
		1 TYPE,
		WANT_EMAIL,
		CONSUMER.CONSUMER_ID,
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		CONSUMER.CONSUMER_EMAIL,
		CONSUMER.CONSUMER_FAX,
		CONSUMER.CONSUMER_FAXCODE,
		CONSUMER.MOBIL_CODE MOBIL_CODE,
		CONSUMER.COMPANY,
		CONSUMER.CONSUMER_CAT_ID,
		CONSUMER.TITLE,
		CONSUMER.DEPARTMENT,
		CONSUMER.MOBILTEL,
		CONSUMER.HOMEADDRESS,
		CONSUMER.CONSUMER_WORKTELCODE,
		CONSUMER.CONSUMER_WORKTEL,
		CONSUMER.CONSUMER_TEL_EXT,
		CONSUMER.WORKADDRESS,
		CONSUMER_CAT.CONSCAT,
		CAMPAIGN_TARGET_PEOPLE.CON_ID,
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CAMPAIGN_TARGET_PEOPLE.RECORD_EMP) RECORD_EMP_NAME,
		CAMPAIGNS.CAMP_ID
	FROM
		CONSUMER,
		CONSUMER_CAT,
		#DSN3_ALIAS#.CAMPAIGN_TARGET_PEOPLE CAMPAIGN_TARGET_PEOPLE,
		#DSN3_ALIAS#.CAMPAIGNS CAMPAIGNS
		<cfif isdefined('attributes.content_subject') and len(attributes.content_subject)>
		,SEND_CONTENTS
		</cfif>
	WHERE
		CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND 
		CAMPAIGN_TARGET_PEOPLE.CON_ID = CONSUMER.CONSUMER_ID AND 
		CAMPAIGNS.CAMP_ID = CAMPAIGN_TARGET_PEOPLE.CAMP_ID AND 
		CAMPAIGN_TARGET_PEOPLE.CAMP_ID = #attributes.CAMP_ID#
		<cfif isdefined('attributes.content_subject') and len(attributes.content_subject)>
			AND SEND_CONTENTS.SEND_CON = CAMPAIGN_TARGET_PEOPLE.CON_ID 
			AND SEND_CONTENTS.CONT_ID = #attributes.content_subject# 
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND 
			(
				CONSUMER.CONSUMER_NAME LIKE '%#attributes.keyword#%' OR
				CONSUMER.CONSUMER_SURNAME LIKE '%#attributes.keyword#%' OR 
				CONSUMER.CONSUMER_EMAIL LIKE '%#attributes.keyword#%' OR 
				CONSUMER.TITLE LIKE '%#attributes.keyword#%'
		  	<cfif control_record_emp.recordcount>
		    	OR CAMPAIGN_TARGET_PEOPLE.RECORD_EMP = #control_record_emp.employee_id#
		  </cfif>
			)
		</cfif>
		<cfif isdefined("attributes.date1") and len(attributes.date1)>
		  AND CAMPAIGN_TARGET_PEOPLE.RECORD_DATE >= #attributes.date1# 
		</cfif> 
		<cfif  isdefined("attributes.date2") and len(attributes.date2)>
            AND CAMPAIGN_TARGET_PEOPLE.RECORD_DATE <= #DATEADD("d",1,attributes.date2)#  
        </cfif> 
		<cfif isdefined("attributes.employee") and len(attributes.employee) and isdefined("attributes.employee_id") and len(attributes.employee_id)>
			AND CAMPAIGN_TARGET_PEOPLE.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif isdefined('attributes.m_type') and len(attributes.m_type)>
			AND 1= #attributes.m_type#
		</cfif>
		<cfif isdefined('attributes.want_email') and len(attributes.want_email)>
			AND WANT_EMAIL = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.want_email#">
		</cfif>
		AND CONSUMER.CONSUMER_ID IS NOT NULL
        AND PAR_ID IS NULL
	ORDER BY
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME
</cfquery>
