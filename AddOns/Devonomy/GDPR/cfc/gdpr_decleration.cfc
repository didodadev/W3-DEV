<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
	</cfscript>
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cffunction name="Get_Decleraion"  access="remote" returntype="any">
        <cfargument  name="GDPR_DECLERATION_ID" default="">
            <cfquery name="Get_Decleraion" datasource="#dsn#">
                SELECT * FROM GDPR_DECLERATION
                where GDPR_DECLERATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.GDPR_DECLERATION_ID#">
            </cfquery>
          <cfreturn Get_Decleraion>
    </cffunction>
    <cffunction name="data_officer" access="public" returntype="query">
        <cfargument name="data_officer_id" default="">
            <cfquery name="data_officer" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_OFFICER
            </cfquery>
        <cfreturn data_officer />
    </cffunction>
    <cffunction name="get_data_officer" access="public" returntype="query">
        <cfargument name="data_officer_id"default="">
            <cfquery name="get_data_officer" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_OFFICER
            WHERE 
                OUR_COMPANY_ID LIKE '%#session.ep.company_id#%'
            </cfquery>               
        <cfreturn get_data_officer />
    </cffunction>
    <cffunction name="get_committee" access="public" returntype="query">
        <cfargument name="data_officer_id"default="">
            <cfquery name="get_committee" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_OFFICER_COMMITTEE GDOC 
            WHERE 
                GDOC.DATA_OFFICER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_officer_id#">
            </cfquery>               
        <cfreturn get_committee />
    </cffunction>
    <cffunction name="GetContent" access="public" returntype="query">
        <cfargument name="action_type" default="">    
        <cfquery name="GET_CONTENT" datasource="#DSN#">
            
            SELECT DISTINCT
                        CR.CONTENT_ID,
                        CR.RECORD_EMP,
                        C.RECORD_DATE,
                        C.CONT_HEAD,
                        C.CONT_BODY,
                        C.CONT_SUMMARY,
                        C.CONTENT_PROPERTY_ID,
                        C.UPDATE_MEMBER,
                        PTR.STAGE,
                        C.WRITE_VERSION,
                        C.UPDATE_DATE,
                        CCH.CHAPTER,
                        CP.NAME,
                        CC.CONTENTCAT,
                        CR.ACTION_TYPE_ID 
                    
                    FROM 
                        CONTENT_RELATION CR,
                        CONTENT_CHAPTER CCH,
                        CONTENT_CAT CC,   
                        CONTENT C
                        LEFT JOIN CONTENT_PROPERTY CP ON C.CONTENT_PROPERTY_ID = CP.CONTENT_PROPERTY_ID
                        LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE
                    WHERE 
                        CR.CONTENT_ID = C.CONTENT_ID   
                        AND CR.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
                        AND CR.ACTION_TYPE_ID IN (SELECT DATA_OFFICER_ID FROM #dsn#.GDPR_DATA_OFFICER)
                        AND CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID
                        AND CCH.CHAPTER_ID = C.CHAPTER_ID
        </cfquery>
        <cfreturn GET_CONTENT />
    </cffunction>
    <cffunction name="GET_EMPS" access="remote" returntype="query">   
        <cfargument name="WORKGROUP_ID" default="">    
        <cfquery name="GET_EMPS" datasource="#dsn#">
            SELECT * FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WORKGROUP_ID#"> OR (OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfquery>
        <cfreturn GET_EMPS>                
    </cffunction>
      
    <cffunction  name="get" access="public">
        <cfargument  name="GDPR_DECLERATION_ID" default="">
         <cfreturn  Get_Decleraion(GDPR_DECLERATION_ID=arguments.GDPR_DECLERATION_ID)> 
    </cffunction> 
    <cffunction  name="MAX_DECLERATION" access="public">
        <cfquery name="MAX_DECLERATION" datasource="#dsn#">
            SELECT  Max(GDPR_DECLERATION_ID) AS max FROM GDPR_DECLERATION
        </cfquery>
      <cfreturn MAX_DECLERATION>
    </cffunction>
    <cffunction  name="GET_APPROVE" access="public">
        <cfquery name="GET_APPROVE" datasource="#dsn#">
            SELECT  * FROM GDPR_APPROVE
            <cfif  isdefined("arguments.GDPR_DECLERATION_ID") and len(arguments.GDPR_DECLERATION_ID)>
            WHERE GDPR_DECLERATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.GDPR_DECLERATION_ID#">
            <cfelse>
                WHERE GDPR_DECLERATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_DECLERATION.max#">
        </cfif> 
        </cfquery> 
      <cfreturn GET_APPROVE>
    </cffunction>
    <cffunction  name="ADD_GDPR_DECLERATION"  access="public" returntype="any" hint="Gdpr aydınlatma içeriği ekleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="ADD_GDPR_DECLERATION" datasource="#dsn#"  result="my_result">
                INSERT INTO GDPR_DECLERATION
                (
                GDPR_DECLERATION_TEXT
                ,RECORD_DATE
                ,RECORD_EMP
                ,RECORD_IP
                ,AUTHOR
                ,GDPR_DECLERATION_VERSION
                ,DECLERATION_DATE
                )
                VALUES(
                
                    <cfif isdefined("arguments.GDPR_DECLERATION_TEXT") and len(arguments.GDPR_DECLERATION_TEXT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GDPR_DECLERATION_TEXT#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfif isdefined("arguments.AUTHOR") and len(arguments.AUTHOR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AUTHOR#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.GDPR_DECLERATION_VERSION") and len(arguments.GDPR_DECLERATION_VERSION)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.GDPR_DECLERATION_VERSION#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.DECLERATION_DATE") and len(arguments.DECLERATION_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DECLERATION_DATE#"><cfelse>NULL</cfif>
                )
            </cfquery>
             <cfquery name="GET_MAX_GDPR" datasource="#dsn#" maxrows="1">
                SELECT * FROM GDPR_DECLERATION   
                ORDER BY 
                GDPR_DECLERATION_ID DESC
            </cfquery>
            <cfset attributes.is_upd = 0>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAX_GDPR.GDPR_DECLERATION_ID>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction  name="ADD_APPROVE"  access="remote" returntype="any" hint="Gdpr aydınlatma içeriği onaylama" >
        <cfset attributes = arguments>
        <cfquery name="ADD_APPROVE" datasource="#dsn#">
            INSERT INTO GDPR_APPROVE
                (
                EMPLOYEE_ID
                ,APPROVE_EMP_ID
                ,GDPR_DECLERATION_ID
                ,GDPR_APPROVE_DATE
                ,RECORD_DATE
                ,RECORD_EMP
                ,RECORD_IP
            
                    )
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.APPROVE_EMP_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gdpr_decleration_id#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
        </cfquery>
    </cffunction>
    <cffunction  name="list_approve"  access="remote" returntype="any">
        <cfargument  name="employee_id" default="">
        <cfargument  name="GDPR_DECLERATION_ID" default="">
        <cfargument  name="employee_name" default="">
        <cfargument  name="approve_emp_id" default="">
        <cfquery name="list_approve" datasource="#dsn#">
            SELECT
            E.EMPLOYEE_ID,
            GA.EMPLOYEE_ID,
            GA.APPROVE_EMP_ID,
            GD.GDPR_DECLERATION_ID,
            GA.GDPR_DECLERATION_ID,
            GDPR_APPROVE_DATE,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_STATUS
            FROM GDPR_APPROVE as GA
            RIGHT JOIN  EMPLOYEES as E   ON GA.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT join GDPR_DECLERATION as GD  on GD.GDPR_DECLERATION_ID=GA.GDPR_DECLERATION_ID
            LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = E.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND EMPLOYEE_POSITIONS.IS_MASTER = 1
              
                where E.EMPLOYEE_STATUS = 1 AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
                <cfif isdefined("arguments.GDPR_DECLERATION_ID") and len(arguments.GDPR_DECLERATION_ID)>
                    AND  GD.GDPR_DECLERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.GDPR_DECLERATION_ID#">
                </cfif>
                <cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
                    AND  E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                <cfif isdefined("arguments.approve_emp_id") and len(arguments.approve_emp_id) and arguments.approve_emp_id eq 1>
                    AND (ISNULL(GA.APPROVE_EMP_ID,0) <> 0 or ISNULL(GA.EMPLOYEE_ID,0) <>0)
                <cfelseif isdefined("arguments.approve_emp_id") and len(arguments.approve_emp_id) and arguments.approve_emp_id eq 0>
                    AND (ISNULL(GA.GDPR_DECLERATION_ID,0) = 0 )
                </cfif>
                ORDER BY EMPLOYEE_NAME ASC
        </cfquery>
        <cfreturn list_approve>
    </cffunction> 
   
 
    <cffunction  name="GET_GDPR" access="public">
        <cfargument  name="employee_id" default="">
        <cfargument  name="GDPR_DECLERATION_ID" default="">
        <cfquery name="GET_GDPR" datasource="#dsn#">
            SELECT  
            GA.GDPR_DECLERATION_ID,
            GA.APPROVE_EMP_ID ,
            GA.EMPLOYEE_ID,
            GD.GDPR_DECLERATION_TEXT,
            GD.DECLERATION_DATE,
            GA.GDPR_APPROVE_DATE
            FROM GDPR_APPROVE AS GA
            LEFT JOIN GDPR_DECLERATION AS GD ON GD.GDPR_DECLERATION_ID=GA.GDPR_DECLERATION_ID
            where GA.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            and GA.GDPR_DECLERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.GDPR_DECLERATION_ID#">
           
        </cfquery>
      <cfreturn GET_GDPR>
    </cffunction>
    <cffunction  name="Data_Decleration" access="public">
        <cfargument  name="GDPR_DECLERATION_ID" default="">
        <cfquery name="Data_Decleration" datasource="#dsn#">
            SELECT 
            GDPR_DECLERATION_ID
            ,GDPR_DECLERATION_TEXT
            ,GDPR_DECLERATION_VERSION
            ,RECORD_DATE
            ,RECORD_IP
            ,UPDATE_DATE
            ,UPDATE_EMP
            ,UPDATE_IP
            ,AUTHOR
            ,DECLERATION_DATE
            ,(SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=GDPR_DECLERATION.RECORD_EMP) AS record_name
            FROM GDPR_DECLERATION 
        </cfquery>
      <cfreturn Data_Decleration>
    </cffunction>
    <cffunction  name="Data_Decleration_" access="public">
        <cfargument  name="GDPR_DECLERATION_ID" default="">
        <cfquery name="Data_Decleration_" datasource="#dsn#" maxrows="1">
            SELECT 
            GDPR_DECLERATION_ID
            ,GDPR_DECLERATION_TEXT
            ,GDPR_DECLERATION_VERSION
            ,RECORD_DATE
            ,RECORD_IP
            ,UPDATE_DATE
            ,UPDATE_EMP
            ,UPDATE_IP
            ,AUTHOR
            ,DECLERATION_DATE
            FROM GDPR_DECLERATION 
            order by GDPR_DECLERATION_ID desc
        </cfquery>
      <cfreturn Data_Decleration_>
    </cffunction>
</cfcomponent>