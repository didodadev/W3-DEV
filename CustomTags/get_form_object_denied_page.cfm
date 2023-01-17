<!---
<cfif caller.workcube_mode><!--- sadece development modda 5 dak bir query calissin --->
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,1,0,0)>
<cfelse>
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,5,0)><!--- CreateTimeSpan(0,0,5,0) --->
</cfif>
--->
<!--- cachedwithin="#caller.get_denied_page_cached_time#" --->
<cfquery name="GET_FORM_OBJECT_NO_VIEWS" datasource="#caller.dsn#">
    SELECT DISTINCT 
        FORM_DEFINE+'_'+CAST(ISNULL(TYPE_ID,0) AS NVARCHAR) FORM_DEFINE
    FROM
        EMPLOYEE_POSITIONS_DENIED_FORM
    WHERE
        IS_VIEW = 1 AND
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
        ( 
            EMPLOYEE_POSITIONS_DENIED_FORM.POSITION_CAT_ID = 0 OR
            (
                EMPLOYEE_POSITIONS_DENIED_FORM.POSITION_CAT_ID <> 0 AND
                FORM_DEFINE	NOT IN
                ( 
                    SELECT 
                        FORM_DEFINE
                    FROM 
                        EMPLOYEE_POSITIONS_DENIED_FORM EPD,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                        EPD.IS_VIEW = 1 AND
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.position_code#"> AND
						(EPD.POSITION_CODE = EP.POSITION_CODE OR EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID) AND
                       	EPD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						<cfif isdefined("URL.TYPE_ID") and len(URL.TYPE_ID)>
							AND EPD.TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.TYPE_ID#">
						</cfif>
                )
             )
        )
</cfquery>
<cfif get_form_object_no_views.recordcount>
    <cfset caller.no_view_form_uls = valuelist(get_form_object_no_views.form_define)>
</cfif>
<!--- cachedwithin="#caller.get_denied_page_cached_time#" --->
<cfquery name="GET_FORM_OBJECT_NO_EDITS" datasource="#caller.dsn#">
    SELECT
    	DISTINCT 
        FORM_DEFINE+'_'+CAST(ISNULL(TYPE_ID,0) AS NVARCHAR) FORM_DEFINE
    FROM
        EMPLOYEE_POSITIONS_DENIED_FORM
    WHERE
        IS_UPDATE = 1 AND
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
        ( 
            EMPLOYEE_POSITIONS_DENIED_FORM.POSITION_CAT_ID = 0 OR
            (
                EMPLOYEE_POSITIONS_DENIED_FORM.POSITION_CAT_ID <> 0 AND
                FORM_DEFINE	NOT IN 
                ( 
                    SELECT 
                        FORM_DEFINE
                    FROM 
                        EMPLOYEE_POSITIONS_DENIED_FORM EPD,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                        EPD.IS_UPDATE = 1 AND
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.position_code#"> AND
                        (EPD.POSITION_CODE = EP.POSITION_CODE OR EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID) AND
						EPD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						<cfif isdefined("URL.TYPE_ID") and len(URL.TYPE_ID)>
							AND EPD.TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.TYPE_ID#">
						</cfif>
                )
             )
        )
</cfquery>

<cfif get_form_object_no_edits.recordcount>
    <cfset caller.no_edit_form_uls = valuelist(get_form_object_no_edits.form_define)>
</cfif>
