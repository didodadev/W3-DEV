<cfif not isdefined('is_paid')>
	<cfset is_paid = 0>
</cfif>
<cfif not isdefined('sirket_gun')>
	<cfset sirket_gun = 0>
</cfif>
<cfquery name="UPDOFFTIME" datasource="#DSN#">
	UPDATE 
		SETUP_OFFTIME 
	SET 
		OFFTIMECAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#offtimecat#">, 
		IS_PAID = #is_paid#,
		IS_YEARLY = <cfif isdefined("attributes.yillik_izin")>1<cfelse>0</cfif>,
		IS_KIDEM = <cfif isdefined("attributes.is_kidem")>1<cfelse>0</cfif>,
        IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
        IS_REQUESTED = <cfif isdefined("attributes.is_requested")>1<cfelse>0</cfif>,
        IS_PUANTAJ_OFF = <cfif isdefined("attributes.is_puantaj_off")>1<cfelse>0</cfif>,
		EBILDIRGE_TYPE_ID = #ebildirge_type_id#,
		SIRKET_GUN = #sirket_gun#,
		IS_RD_SSK  = <cfif isDefined("attributes.is_rd_ssk")>1<cfelse>0</cfif>,
		UPPER_OFFTIMECAT_ID = <cfqueryparam value = "#attributes.upper_offtime_cat_id#" CFSQLType = "cf_sql_integer">,
		SHOW_ENTITLEMENTS = <cfif isdefined("attributes.show_entitlements") and attributes.show_entitlements eq 1>1<cfelse>0</cfif>,
		 IS_DOCUMENT_REQUIRED = <cfif isdefined("attributes.is_document") and attributes.is_document eq 1>1<cfelse>0</cfif>,
        IS_REPEATABLE_APP = <cfif isdefined("attributes.IS_REPEATABLE_APP") and attributes.IS_REPEATABLE_APP eq 1>1<cfelse>0</cfif>,
		IS_PERMISSION_TYPE = <cfif isdefined("attributes.permission_type") and len(attributes.permission_type)><cfqueryparam value = "#attributes.permission_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
        WEEKING_WORKING_DAY = <cfif isdefined("attributes.day_") and len(attributes.day_)><cfqueryparam value = "#attributes.day_#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
        MAX_PERMISSION_TIME = <cfif isdefined("attributes.max_permission_time") and len(attributes.max_permission_time)><cfqueryparam value = "#attributes.max_permission_time#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
		IS_FREE_TIME = <cfif isdefined("attributes.is_free_time") and attributes.is_free_time eq 1>1<cfelse>0</cfif>,
		IS_OFFDAY_DELAY = <cfif isdefined("attributes.IS_OFFDAY_DELAY") and attributes.IS_OFFDAY_DELAY eq 1>1<cfelse>0</cfif>,
		CALC_CALENDAR_DAY = <cfif isdefined("attributes.CALC_CALENDAR_DAY") and attributes.CALC_CALENDAR_DAY eq 1>1<cfelse>0</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		PAID_A_DAY =  <cfif isdefined("attributes.paid_a_day") and attributes.paid_a_day eq 1>1<cfelse>0</cfif>,
		INCLUDED_IN_TAX = <cfif isdefined("attributes.included_in_tax") and len(attributes.included_in_tax)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.included_in_tax#"><cfelse>NULL</cfif> 
	WHERE 
		OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#offtimecat_id#">
</cfquery>
<script>
	location.href = document.referrer;
</script>