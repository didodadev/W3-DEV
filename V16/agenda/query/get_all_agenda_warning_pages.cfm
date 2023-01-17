<!--- Gunluk, Haftalik, Aylik Ajandada Sayfa Uyarilarim --->
<cfquery name="get_all_agenda_warning_pages" datasource="#dsn#">
	SELECT 
		W_ID,
        WARNING_HEAD,
        WARNING_DESCRIPTION,
        LAST_RESPONSE_DATE,
        OUR_COMPANY_ID,
        PERIOD_ID,
        URL_LINK,
        PARENT_ID
	FROM 
		PAGE_WARNINGS 
	WHERE
		IS_ACTIVE = 1 AND
        IS_AGENDA = 1 AND
        POSITION_CODE = <cfif isdefined('session.agenda_position_code')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_position_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"></cfif> AND
        LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND 
        LAST_RESPONSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('#add_format_#',1,attributes.to_day)#">
</cfquery>
