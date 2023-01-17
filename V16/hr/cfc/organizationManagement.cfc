<!---
File: organization_management.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Organzasyonl Planlamanın cfc'lerini içerir.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
    <cfset get_xml = get_fuseaction_property.get_fuseaction_property(
        company_id : session.ep.company_id,
        fuseaction_name : 'hr.organization_management',
        property_name : 'x_is_active'
        )
    >
    <cfif get_xml.recordcount>
        <cfset x_is_active = get_xml.property_value>
    <cfelse>
        <cfset x_is_active = 1>
    </cfif>
    <cffunction name = "GetObjectsName"><!--- Obje İsimleri --->
        <cfargument name="full_fuseaction" default="">        
    	<cfquery name="GetObjectsName" datasource="#dsn#">     
            SELECT
                ISNULL(S.ITEM_#UCase(session.ep.language)#,WO.HEAD) AS HEAD
            FROM 
                WRK_OBJECTS WO
                    LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = WO.DICTIONARY_ID
            WHERE
                FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value = "#arguments.full_fuseaction#">           
        </cfquery>
        <cfreturn GetObjectsName>
    </cffunction>
	<cffunction name = "getHeadQuarters"><!--- Gruplar --->
    	<cfquery name="getHeadQuarters" datasource="#dsn#">
        	SELECT 
                HEADQUARTERS_ID,
                NAME 
            FROM 
                SETUP_HEADQUARTERS 
            WHERE 
                UPPER_HEADQUARTERS_ID IS NULL 
                <cfif x_is_active eq 0>
                    AND IS_ORGANIZATION = 1
                </cfif>
            ORDER BY 
                NAME	
        </cfquery>
        <cfreturn getHeadQuarters>
    </cffunction>
    <cffunction name = "headQuarters_alt"><!--- Alt Gruplar --->
        <cfargument name="head_id" default="">
        <cfquery name="headQuarters_alt" datasource="#dsn#">
            SELECT 
                HEADQUARTERS_ID,
                NAME,
                UPPER_HEADQUARTERS_ID 
            FROM 
                SETUP_HEADQUARTERS
            WHERE   
                UPPER_HEADQUARTERS_ID IS NOT NULL AND
                UPPER_HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.head_id#">
            ORDER BY NAME
        </cfquery>
        <cfreturn headQuarters_alt>
    </cffunction>
    <cffunction name = "getAllCompany">
        <cfargument name="head_id" default="">        
        <cfquery name="getAllCompany" datasource="#dsn#"><!--- Sirketler --->
            SELECT
                NICK_NAME,
                COMP_ID,
                HEADQUARTERS_ID 
            FROM 
                OUR_COMPANY 
            WHERE 
                HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.head_id#">
                <cfif x_is_active eq 0>
                    AND IS_ORGANIZATION = 1
                </cfif>
        </cfquery>
        <cfreturn getAllCompany>
    </cffunction>
    <cffunction name = "getCompanyBranches">
        <cfargument name="comp_id" default="">    
        <cfquery name="getCompanyBranches" datasource="#dsn#"><!--- Şubeler --->
            SELECT
                BRANCH_ID,
                BRANCH_NAME,
                COMPANY_ID 
            FROM 
                BRANCH 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.comp_id#">
                <cfif x_is_active eq 0>
                    AND BRANCH_STATUS = 1
                </cfif>
        </cfquery>
        <cfreturn getCompanyBranches>
    </cffunction>
    <cffunction name = "getBranchDepartments">
        <cfargument name="branch_id" default="">    
        <cfargument name="department_id" default="">   
        <cfquery name="getBranchDepartments" datasource="#dsn#"><!--- Departmanlar --->  
            SELECT 
                BRANCH_ID,
                DEPARTMENT_ID,
                DEPARTMENT_HEAD,
                HIERARCHY_DEP_ID, 
                CAST(DEPARTMENT_ID AS NVARCHAR(10)) AS DEPARTMENT_ID2                
            FROM 
                DEPARTMENT 
            WHERE 
                IS_STORE = 2 AND
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.branch_id#"> 
                <cfif x_is_active eq 0>
                    AND DEPARTMENT_STATUS = 1
                </cfif>
        </cfquery>
        <cfreturn getBranchDepartments>
    </cffunction>
    <cffunction name = "getDepartmentsPositions"><!--- Pozisyonlar --->
        <cfargument name="comp_id" default=""> 
        <cfargument name="branch_id" default="">
        <cfargument name="employee_id" default="">   
        <cfargument name="department_id" default="">      
        <cfargument name="position_catid" default="">  
        <cfquery name="getDepartmentsPositions" datasource="#dsn#">            
            SELECT
                DISTINCT
                SPC.POSITION_CAT,
                SPC.POSITION_CAT_ID                    
            FROM
                EMPLOYEE_POSITIONS EP
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                    INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID,
                DEPARTMENT,
                BRANCH,		
                ZONE
            WHERE
                EP.IS_ORG_VIEW = 1 AND
                EP.EMPLOYEE_ID > 0 AND
                EP.POSITION_STATUS = 1 AND
                EP.POSITION_NAME <> '' AND
                BRANCH.ZONE_ID=ZONE.ZONE_ID AND
                DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
                EP.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND  
                BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.comp_id#"> AND
                BRANCH.BRANCH_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.branch_id#"> AND
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.department_id#">  AND
                POSITION_CAT_STATUS = 1 AND
                E.EMPLOYEE_STATUS = 1
        </cfquery>
        <cfreturn getDepartmentsPositions>
    </cffunction>
    <cffunction name = "getPositionsEmployee"><!--- Pozisyonlar --->  
        <cfargument name="comp_id" default=""> 
        <cfargument name="branch_id" default="">
        <cfargument name="employee_id" default="">   
        <cfargument name="department_id" default="">      
        <cfargument name="position_catid" default="">        
        <cfquery name="getPositionsEmployee" datasource="#dsn#">          
            SELECT
                E.PHOTO,
                EP.EMPLOYEE_ID,
                EP.EMPLOYEE_NAME,
                EP.EMPLOYEE_EMAIL,
                EP.EMPLOYEE_SURNAME,
                EP.UPPER_POSITION_CODE,
                EP.UPPER_POSITION_CODE2                      
            FROM
                EMPLOYEE_POSITIONS EP
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID,
                DEPARTMENT,
                BRANCH,		
                ZONE
            WHERE
                EP.IS_ORG_VIEW = 1 AND
                EP.EMPLOYEE_ID > 0 AND
                EP.POSITION_STATUS = 1 AND
                EP.POSITION_NAME <> '' AND
                BRANCH.ZONE_ID=ZONE.ZONE_ID AND
                DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
                EP.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND  
                BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.comp_id#"> AND
                BRANCH.BRANCH_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.branch_id#"> AND
                <cfif len(arguments.employee_id)>
                    EP.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.employee_id#"> AND
                </cfif> 
                EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.position_catid#"> AND		
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.department_id#">    
                AND E.EMPLOYEE_STATUS = 1
        </cfquery>
        <cfreturn getPositionsEmployee>        
    </cffunction>
    <cffunction name = "GetEmployeeContract"><!--- Çalışan Sözleşme --->  
        <cfargument name="employee_id" default="">   
        <cfquery name="GetEmployeeContract" datasource="#DSN#">
            SELECT
                EC.CONTRACT_ID,
                EC.contract_head
            FROM
                EMPLOYEES_CONTRACT EC,
                EMPLOYEES E
            WHERE
                EC.RECORD_EMP = E.EMPLOYEE_ID AND
                EC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value = "#arguments.employee_id#">
        </cfquery>
        <cfreturn GetEmployeeContract>        
    </cffunction>
</cfcomponent>