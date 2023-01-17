<cfif not isdefined('is_paid')>
	<cfset is_paid = 0>
</cfif>
<cfif not isdefined('sirket_gun')>
	<cfset sirket_gun = 0>
</cfif>
<cfquery name="GET_MAX" datasource="#DSN#">
	SELECT
		MAX(OFFTIMECAT_ID) MAX_ID
	FROM
		SETUP_OFFTIME
</cfquery>
<cfquery name="ADD_SETUP_OFFTIME" datasource="#DSN#">
	INSERT INTO 
    	SETUP_OFFTIME
    (
        OFFTIMECAT_ID,
        OFFTIMECAT,
        IS_PAID,
        IS_YEARLY,
        EBILDIRGE_TYPE_ID,
        SIRKET_GUN,
        IS_KIDEM,
        IS_ACTIVE,
        IS_REQUESTED,
        IS_PUANTAJ_OFF,
        IS_RD_SSK,
        UPPER_OFFTIMECAT_ID,
        SHOW_ENTITLEMENTS,
        IS_DOCUMENT_REQUIRED,
        IS_REPEATABLE_APP,
        IS_PERMISSION_TYPE,
        WEEKING_WORKING_DAY,
        MAX_PERMISSION_TIME,
        IS_FREE_TIME,
        IS_OFFDAY_DELAY,
        CALC_CALENDAR_DAY,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE,
        PAID_A_DAY,
		INCLUDED_IN_TAX
    ) 
	VALUES 
    (
        <cfif len(get_max.max_id)>#get_max.max_id+1#<cfelse>1</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#offtimecat#">,
        #is_paid#,
        <cfif isdefined("attributes.yillik_izin")>1<cfelse>0</cfif>,
        #ebildirge_type_id#,
        #sirket_gun#,
        <cfif isdefined("attributes.is_kidem")>1<cfelse>0</cfif>,
        1,
        <cfif isdefined("attributes.is_requested")>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_puantaj_off")>1<cfelse>0</cfif>,
        <cfif isDefined("attributes.is_rd_ssk")>1<cfelse>0</cfif>,
        <cfqueryparam value = "#attributes.upper_offtime_cat_id#" CFSQLType = "cf_sql_integer">,
        <cfif isdefined("attributes.show_entitlements") and attributes.show_entitlements eq 1>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_document") and attributes.is_document eq 1>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.is_explain") and attributes.is_explain eq 1>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.permission_type") and len(attributes.permission_type)><cfqueryparam value = "#attributes.permission_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.day_") and len(attributes.day_)><cfqueryparam value = "#attributes.day_#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.max_permission_time") and len(attributes.max_permission_time)><cfqueryparam value = "#attributes.max_permission_time#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.is_free_time") and attributes.is_free_time eq 1>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.IS_OFFDAY_DELAY") and attributes.IS_OFFDAY_DELAY eq 1>1<cfelse>0</cfif>,
        <cfif isdefined("attributes.CALC_CALENDAR_DAY") and attributes.CALC_CALENDAR_DAY eq 1>1<cfelse>0</cfif>,
        #session.ep.userid#,
        '#cgi.remote_addr#',
        #now()#,
        <cfif isdefined("attributes.paid_a_day") and attributes.paid_a_day eq 1>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.included_in_tax") and len(attributes.included_in_tax)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.included_in_tax#"><cfelse>NULL</cfif>
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_offtime" addtoken="no">
