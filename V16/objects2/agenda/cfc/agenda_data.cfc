<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>  

    <cffunction  name="GET_RELATED_EVENTS" access="remote" returntype="any" >
        <cfargument  name="action_section" default="">
        <cfargument  name="action_id" default="">
        <cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
            SELECT
                ER.EVENT_ID,
                ER.RELATED_ID,
                E.EVENT_HEAD,
                E.STARTDATE,
                E.FINISHDATE,
                ISNULL(ER.EVENT_TYPE,1) TYPE,
                '' EVENT_ROW_ID,
                EC.EVENTCAT,
                EC.COLOUR
            FROM
                EVENTS_RELATED ER,
                EVENT E,
                EVENT_CAT EC
            WHERE
                E.EVENT_ID = ER.EVENT_ID AND	
                E.EVENTCAT_ID = EC.EVENTCAT_ID AND    
                <cfif (isdefined('arguments.action_id') and len(arguments.action_id)) and (isdefined('arguments.action_section') and len(arguments.action_section))>           
                ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.action_section)#"> AND               
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND     
                <cfelseif (isdefined('url.action_id') and len(url.action_id)) and (isdefined('url.action_section') and len(url.action_section))>            
                ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.action_section)#"> AND               
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.action_id#"> AND              
                </cfif>	
                IS_INTERNET = 1 AND
                ISNULL(ER.EVENT_TYPE,1) = 1 AND 
                PROJECT_ID <> -1              
                
            UNION ALL	
            SELECT
                ER.EVENT_ID,
                ER.RELATED_ID,
                E.EVENT_PLAN_HEAD EVENT_HEAD,
                EVENT_PLAN_ROW.START_DATE STARTDATE,
                EVENT_PLAN_ROW.FINISH_DATE FINISHDATE,
                ISNULL(ER.EVENT_TYPE,1) TYPE,
                ER.EVENT_ROW_ID,
                '' EVENTCAT,
                '##89d3d9' COLOUR
            FROM
                EVENTS_RELATED ER,
                EVENT_PLAN E,
                EVENT_PLAN_ROW
            WHERE
                E.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
                E.EVENT_PLAN_ID = ER.EVENT_ID AND	
                <cfif (isdefined('arguments.action_id') and len(arguments.action_id)) and (isdefined('arguments.action_section') and len(arguments.action_section))>           
                ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.action_section)#"> AND               
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND     
                <cfelseif (isdefined('url.action_id') and len(url.action_id)) and (isdefined('url.action_section') and len(url.action_section))> 
                ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.action_section)#"> AND
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.action_id#"> AND                
                </cfif>	
                ISNULL(ER.EVENT_TYPE,1) = 2 
                               
            ORDER BY 
                E.STARTDATE DESC
        </cfquery>
        <cfreturn GET_RELATED_EVENTS>
    </cffunction>

    <cffunction  name="GET_PAR" access="remote" returntype="any" >
        
        <cfquery name="GET_PAR" datasource="#DSN#">
            SELECT 
                COMPANY_PARTNER.*,
                NICKNAME
            FROM
                COMPANY_PARTNER,
                COMPANY
            WHERE
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
            <cfif isdefined("url.par_id") and len(url.PAR_ID)>
                COMPANY_PARTNER.PARTNER_ID = #url.PAR_ID#            
            <cfelse>
                COMPANY_PARTNER.PARTNER_ID = #session.pp.userid#
            </cfif>
        </cfquery>
          <cfreturn GET_PAR>
    </cffunction>

    <cffunction  name="PAR_EVENTS" access="remote" returntype="any" >  
        <cfquery name="get_part_id" datasource="#dsn#">    
            SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
        </cfquery>   
        <cfquery name="PAR_EVENTS" datasource="#dsn#">
            SELECT                
                E.EVENT_ID,
                E.EVENT_HEAD,
                E.STARTDATE,
                E.FINISHDATE,
                E.PROJECT_ID,
                E.ONLINE_MEET_LINK,
                E.CREATED_GOOGLE_EVENT_ID,
                E.IS_GOOGLE_CAL,
                EC.EVENTCAT,
                EC.COLOUR,
                EVENT_TO_PAR,
                EVENT_CC_PAR,
                RECORD_PAR
            FROM
                EVENT E,
                EVENT_CAT EC
            WHERE
                E.EVENTCAT_ID = EC.EVENTCAT_ID AND 
                <cfif isdefined('url.par_id') and len(url.par_id)>          
                (RECORD_PAR = #url.par_id#
                OR EVENT_TO_PAR LIKE '%,#url.par_id#,%'
                OR EVENT_CC_PAR LIKE '%,#url.par_id#,%') AND
                </cfif>   
                <cfif isdefined('arguments.action_id') and len(arguments.action_id) and isdefined('arguments.action_section') and arguments.action_section eq 'PROJECT_ID'>
                    E.PROJECT_ID IS NOT NULL AND
                </cfif>             
                (
                    <cfoutput query="get_part_id">
                        EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value='%,#partner_id#,%'> OR
                        EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value='%,#partner_id#,%'> OR
                    </cfoutput>                    
                    RECORD_PAR IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(get_part_id.PARTNER_ID)#" list="yes">)
                )
           
        </cfquery>        
        <cfreturn PAR_EVENTS>
    </cffunction>

    <cffunction  name="GET_EMPLOYEES" access="remote" returntype="any" >      
        <cfquery name="GET_EMPLOYEES" datasource="#DSN#">
            SELECT 
                *
            FROM 
                EMPLOYEES
            WHERE
                EMPLOYEE_ID <> 0
                <cfif isdefined("url.emp_id") and len(url.emp_id)>
                    AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value='#url.emp_id#'>
                <cfelseif isdefined("arguments.emp_id") and len(arguments.emp_id)>
                    AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value='#arguments.emp_id#'>
                </cfif>               
        </cfquery>        
        <cfreturn GET_EMPLOYEES>
    </cffunction>
    
    <cffunction  name="MY_SETTINGS" access="remote" returntype="any" >      
        <cfquery name="MY_SETTINGS" datasource="#dsn#">
            SELECT                
                *
            FROM
                MY_SETTINGS
            WHERE
                1=1
            <cfif isdefined('url.emp_id') and len(url.emp_id)>          
                AND EMPLOYEE_ID = #url.emp_id#
            <cfelseif isdefined('session.ep.userid')>
                AND EMPLOYEE_ID = #session.ep.userid#
            </cfif>
                
        </cfquery>        
        <cfreturn MY_SETTINGS>
    </cffunction>

    <cffunction  name="EMP_EVENTS" access="remote" returntype="any" >      
        <cfquery name="EMP_EVENTS" datasource="#dsn#">
            SELECT                
                E.EVENT_ID,
                E.EVENT_HEAD,
                E.STARTDATE,
                E.FINISHDATE,
                EC.EVENTCAT,
                EC.COLOUR
            FROM
                EVENT E,
                EVENT_CAT EC
            WHERE
                E.EVENTCAT_ID = EC.EVENTCAT_ID AND 
                <cfif isdefined('url.emp_id') and len(url.emp_id)>          
                    (E.RECORD_EMP = #url.emp_id#
                    OR EVENT_TO_POS LIKE '%,#url.emp_id#,%') AND
                </cfif>                
                (IS_INTERNET = 1 OR
                VIEW_TO_ALL = 1)
        </cfquery>        
        <cfreturn EMP_EVENTS>
    </cffunction>

    <!--- Training Agenda --->
    <cffunction  name="GET_TR" access="remote" returntype="any" > 
        <cfargument  name="site" default="">
        <cfquery name="get_tr" datasource="#DSN#">
            SELECT DISTINCT
                TC.CLASS_ID,
                TC.FINISH_DATE,
                TC.START_DATE,
                TC.CLASS_NAME,
                TC.IS_ACTIVE,
                UFU.USER_FRIENDLY_URL
            FROM
                TRAINING_CLASS TC
                <cfif isdefined('arguments.site')>OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'CLASS_ID' 
                    AND UFU.ACTION_ID = TC.CLASS_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#) UFU</cfif>
                WHERE 
                    (IS_INTERNET = 1 OR VIEW_TO_ALL = 1)            
        </cfquery>
        <cfreturn GET_TR>
    </cffunction>

    <cffunction name="GET_PROCESS_TYPES" returntype="query" access="public">
        <cfargument name="x_show_authorized_stage" type="any" default="">
        <cfargument name="process_rowid_list" type="any" default="">
        <cfargument name="faction" type="any" default="">
        <cfquery name="get_process_types" datasource="#DSN#">
            SELECT
                 CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE STAGE
                END AS STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = ptr.PROCESS_ROW_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
                ,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.faction#,%">
                <cfif isDefined('arguments.x_show_authorized_stage') and arguments.x_show_authorized_stage eq 1 and isDefined("arguments.process_rowid_list") and ListLen(arguments.process_rowid_list)>
                    AND PTR.PROCESS_ROW_ID IN (#arguments.process_rowid_list#)
                </cfif>
        </cfquery>
        <cfreturn get_process_types>
    </cffunction>

</cfcomponent>