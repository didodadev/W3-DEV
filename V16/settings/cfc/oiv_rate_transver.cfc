
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <cffunction  name="get_hedef_period"  access="remote" returntype="any">
        <cfargument   name="hedef_period_1" default="">
        <cfquery name="get_hedef_period" datasource="#dsn#">
            SELECT 
                PERIOD_ID, 
                PERIOD, 
                PERIOD_YEAR, 
                IS_INTEGRATED, 
                OUR_COMPANY_ID, 
                PERIOD_DATE, 
                OTHER_MONEY, 
                STANDART_PROCESS_MONEY, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP, 
                IS_LOCKED, 
                PROCESS_DATE 
            FROM 
                SETUP_PERIOD 
            WHERE 
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hedef_period_1#">
        </cfquery>
        <cfreturn get_hedef_period>
    </cffunction>   
    <cffunction  name="get_kaynak_period"  access="remote" returntype="any">
        <cfargument   name="OUR_COMPANY_ID" default="">
        <cfargument   name="PERIOD_YEAR" default="">
        <cfquery name="get_kaynak_period" datasource="#dsn#">
            SELECT 
                PERIOD_ID, 
                PERIOD, 
                PERIOD_YEAR, 
                IS_INTEGRATED, 
                OUR_COMPANY_ID, 
                PERIOD_DATE, 
                OTHER_MONEY, 
                STANDART_PROCESS_MONEY, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP, 
                IS_LOCKED, 
                PROCESS_DATE 
            FROM 
                SETUP_PERIOD 
            WHERE 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OUR_COMPANY_ID#"> AND
                PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PERIOD_YEAR-1#">
        </cfquery>
        <cfreturn get_kaynak_period> 
    </cffunction>
    <cffunction  name="get_companies" access="remote" returntype="any">
        <cfquery name="get_companies" datasource="#dsn#">
            SELECT 
                COMP_ID, 
                COMPANY_NAME
            FROM 
                OUR_COMPANY 
        </cfquery>
        <cfreturn get_companies>
    </cffunction>  
    <cffunction  name="get_periods" access="remote" returntype="any">
        <cfargument  name="item_company_id" default="">
        <cfquery Name="get_periods"  datasource="#dsn#">
          SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.item_company_id#"> ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
        </cfquery>
        <cfreturn get_periods>
    </cffunction>

    <cffunction  name="select_oiv_hedef" access="remote" returntype="any">
        <cfargument  name="hedef_period_1"default="">
       <cfquery name="select_oiv_hedef" datasource="#dsn#_#get_hedef_period.OUR_COMPANY_ID#">
			SELECT * FROM SETUP_OIV where PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hedef_period_1#">
        </cfquery>
        <cfreturn select_oiv_hedef>
    </cffunction>
    <cffunction  name="oiv_aktarim" access="remote"  returnFormat="json" returntype="any">  
        <cftry>
            <cfset get_hedef_period = get_hedef_period(hedef_period_1 : arguments.hedef_period_1)/>
            <cfset get_kaynak_period = get_kaynak_period( OUR_COMPANY_ID: get_hedef_period.OUR_COMPANY_ID, PERIOD_YEAR: 
            get_hedef_period.PERIOD_YEAR)/>
            <cfset select_oiv_hedef=select_oiv_hedef(hedef_period_1 : arguments.hedef_period_1)/>
            <cfset result = StructNew()>
            <cflock name="#CREATEUUID()#" timeout="70">
                <cftransaction> 
                    <cfif select_oiv_hedef.recordcount or (not get_kaynak_period.recordcount)>
                        <cfset result.STATUS = false>
                        <cfset result.data.PERIOD_ID = -1>
                        <cfif not get_kaynak_period.recordcount>
                            <cfset result.data.PERIOD_ID = get_kaynak_period.recordcount>
                        </cfif>
                        <cfelse>
                        <cfset result.STATUS = true>
                        <cfquery name="oiv_aktarim" datasource="#dsn#_#get_hedef_period.OUR_COMPANY_ID#">    
                            INSERT INTO 
                            SETUP_OIV
                                (
                                    TAX
                                    ,DETAIL
                                    ,ACCOUNT_CODE
                                    ,PURCHASE_CODE
                                    ,ACCOUNT_CODE_IADE
                                    ,PURCHASE_CODE_IADE
                                    ,PERIOD_ID
                                    ,TAX_CODE
                                    ,RECORD_DATE
                                    ,RECORD_EMP
                                    ,RECORD_IP
                                    ,UPDATE_DATE
                                    ,UPDATE_EMP
                                    ,UPDATE_IP
                                    ,TAX_CODE_NAME
                                )
                            SELECT 
                                    TAX
                                    ,DETAIL
                                    ,ACCOUNT_CODE
                                    ,PURCHASE_CODE
                                    ,ACCOUNT_CODE_IADE
                                    ,PURCHASE_CODE_IADE
                                    ,#arguments.hedef_period_1#
                                    ,TAX_CODE
                                    ,RECORD_DATE
                                    ,RECORD_EMP
                                    ,RECORD_IP
                                    ,UPDATE_DATE
                                    ,UPDATE_EMP
                                    ,UPDATE_IP
                                    ,TAX_CODE_NAME
                                FROM 
                                    SETUP_OIV
                                WHERE
                                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_kaynak_period.period_id#">
                        </cfquery> 
                    </cfif>
                </cftransaction>	
            </cflock>
            <cfcatch type = "any">
                <cfdump  var="#cfcatch#">
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>     
    </cffunction>
</cfcomponent>