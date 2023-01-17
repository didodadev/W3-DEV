<!---
    Author : Uğur Hamurpet
    Date : 04.08.2020
    Desc : Vekalet edilen ve süreçteki kişileri getirmek için kullanılır.
    Methods : {
        get_mandate : Vekalet edilen kullanıcıları getirir,
        get_process_sender : Süreçlerde bildirimi oluşturan kişiyi getirir
    }
--->

<cfcomponent>

    <cfproperty name="data_source" type="string" default="">
    <cfproperty name="process_db" type="string" default="">

    <cffunction name = "init" access = "public">
        <cfargument name="data_source" type="string" default="">
        <cfargument name="process_db" type="string" default="">
        
        <cfset this.data_source = Len( arguments.data_source ) ? arguments.data_source : application.SystemParam.SystemParam().dsn />
        <cfset this.process_db = arguments.process_db />

        <cfreturn this>
    </cffunction>

    <cffunction  name="get_mandate" access="public" returnType="query">

        <cfquery name="get_mandate" datasource="#this.data_source#">
            SELECT
                EMPM.MASTER_EMPLOYEE_ID,
                EMPPOS.POSITION_CODE,
                CONCAT( EMPPOS.EMPLOYEE_NAME, ' ', EMPPOS.EMPLOYEE_SURNAME ) AS NAMESURNAME
            FROM 
                #this.process_db#EMPLOYEE_MANDATE AS EMPM
                JOIN #this.process_db#EMPLOYEE_POSITIONS AS EMPPOS ON EMPM.MASTER_EMPLOYEE_ID = EMPPOS.EMPLOYEE_ID
            WHERE 
                EMPM.MANDATE_EMPLOYEE_ID = #session.ep.userid#
                AND EMPM.MANDATE_STARTDATE <= #now()# AND EMPM.MANDATE_FINISHDATE >= #now()#
                AND EMPM.IS_APPROVE = 1
        </cfquery>

        <cfreturn get_mandate>

    </cffunction>

    <cffunction name = "get_process_sender" access="public" returnType = "query">
        <cfargument name="fuseaction" type="string" required="yes" default="">
        <cfargument name="pathinfo" type="string" required="yes" default="">
        <cfargument name="wrkflow" type="numeric" required="no" default="0">

        <cfset get_mandate = this.get_mandate() />
        <cfset mandate_positioncode = get_mandate.recordcount ? ValueList(get_mandate.POSITION_CODE) : "" />

        <cfquery name = "get_process_sender" datasource = "#this.data_source#">
            SELECT
                PGW.SENDER_POSITION_CODE
            FROM 
                #this.process_db#PAGE_WARNINGS PGW
            WHERE 
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wrkflow#'> = 1 AND
                (
                    SELECT TOP 1 1 FROM #this.process_db#WRK_OBJECTS 
                    WHERE 
                        FULL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'> AND 
                        TYPE <> 10 AND TYPE <> 11
                ) IS NOT NULL AND
                PGW.URL_LINK LIKE '%#left(reReplace(reReplace(replaceNoCase(arguments.pathinfo, '&wrkflow=1', ''), '&event=[upd|det|add]+', '%'),'&wsr_code=[0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{16}',''),250)#%' AND
                PGW.OUR_COMPANY_ID = #session.ep.company_id# AND 
                ( 
                    PGW.POSITION_CODE = #session.ep.position_code# 
                    <cfif len(mandate_positioncode)>
                    OR PGW.POSITION_CODE IN (#mandate_positioncode#) 
                    </cfif>
                )
        </cfquery>

        <cfreturn get_process_sender />

    </cffunction>

</cfcomponent>