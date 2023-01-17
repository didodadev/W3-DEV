<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    <cfelse>
        <cfset session_base = application.session_base>
    </cfif>    

    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn_alias = '#dsn#'>
    <cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />

    <cffunction name="GET_HR" access="remote"> 
        <cfargument name="keyword">   
        <cfargument name="position_cat_type">   
        <cfquery name="GET_HR" datasource="#dsn#">
            SELECT 
                E.EMPLOYEE_ID,
                E.PHOTO,
                ED.SEX,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_EMAIL,
                EP.POSITION_CAT_ID
                <cfif isdefined("arguments.certificate_filter") and arguments.certificate_filter gt 0>
                    ,TC.CERTIFICATE_ID
                </cfif>
            FROM 
                EMPLOYEES E
                LEFT JOIN EMPLOYEES_DETAIL ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID 
                LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_APP EA ON E.EMPLOYEE_ID = EA.EMPLOYEE_ID
                <cfif isdefined("arguments.certificate_filter") and arguments.certificate_filter gt 0>
                    LEFT JOIN TRAINING_CERTIFICATE TC ON E.EMPLOYEE_ID = TC.EMPLOYEE_ID
                </cfif>
            WHERE
                E.EMPLOYEE_STATUS = 1
                AND EP.POSITION_STATUS = 1
                <cfif isDefined("arguments.is_resume_empty") and arguments.is_resume_empty eq 1>
                AND EA.RESUME_TEXT IS NOT NULL
                </cfif>
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND (
                    E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> 
                    OR 
                    E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                    )
            </cfif>
            <cfif isDefined("arguments.position_cat_type") and len(arguments.position_cat_type)>
                AND EP.POSITION_CAT_ID IN (<cfqueryparam value="#arguments.position_cat_type#" cfsqltype="cf_sql_integer" list="true">)
            </cfif>
            <cfif isdefined("arguments.certificate_filter") and arguments.certificate_filter gt 0>
               AND TC.CERTIFICATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.certificate_filter#">                
            </cfif>
            ORDER BY E.EMPLOYEE_NAME ASC
          </cfquery>     
        <cfreturn GET_HR>
    </cffunction>  

    <cffunction name="GET_CERTIFICATES" access="remote"> 
        <cfargument name="emp_id">   
        <cfquery name="GET_CERTIFICATES" datasource="#DSN#">
            SELECT 
                EMPLOYEE_ID,
                TC.CERTIFICATE_ID,
                CERTIFICATE_NAME
            FROM 
                SETTINGS_CERTIFICATE SC 
                LEFT JOIN TRAINING_CERTIFICATE TC ON SC.CERTIFICATE_ID = TC.CERTIFICATE_ID 
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
        </cfquery>
        <cfreturn GET_CERTIFICATES>
    </cffunction> 

    <cffunction name="GET_ALL_CERTIFICATES" access="remote">            
        <cfquery name="GET_ALL_CERTIFICATES" datasource="#DSN#">
            SELECT 
                CERTIFICATE_ID,
                CERTIFICATE_NAME
            FROM 
                SETTINGS_CERTIFICATE SC                            
        </cfquery>
        <cfreturn GET_ALL_CERTIFICATES>
    </cffunction> 

    <cffunction name="GetPositions" access="public" returntype="query"> 
        <cfargument name="employee_list" default="">   
        <cfquery name="get_positions" datasource="#dsn#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                SETUP_POSITION_CAT.POSITION_CAT
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                SETUP_POSITION_CAT
            WHERE
                SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
            AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
            AND
                EMPLOYEE_POSITIONS.POSITION_STATUS = 1
            AND 
                EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#employee_list#">)
        </cfquery>
        <cfreturn get_positions>
    </cffunction>

    <cffunction name="GetPosition" access="public" returntype="query"> 
        <cfargument name="employee_id" default="">  
        <cfquery name="get_position" dbtype="query" maxrows="1">
            SELECT 
               DEPARTMENT_HEAD,
               POSITION_NAME,
               POSITION_CAT 
            FROM 
               GET_POSITIONS 
            WHERE  
               EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
        </cfquery>
        <cfreturn get_position>
    </cffunction>

    <cffunction name="GET_HR_DET" access="remote"> 
        <cfargument name="employee_id">   
        <cfquery name="GET_HR_DET" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                EMPLOYEES E
                LEFT JOIN EMPLOYEES_DETAIL ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID 
                LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
            WHERE
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
          </cfquery>     
        <cfreturn GET_HR_DET>
    </cffunction> 

</cfcomponent>