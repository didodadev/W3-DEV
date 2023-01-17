<cfcomponent>

    <cfproperty name="queryJSONConverter">

    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="init">
        <cfset this.queryJSONConverter = createObject("component","workcube.cfc.queryJSONConverter") />
        <cfreturn this />
    </cffunction>

    <cffunction name="list" access="public">
        <cfargument name="wexdata">
        <cfquery name="query_get_consumer" datasource="#DSN#">
            SELECT
                CONSUMER.CONSUMER_ID,
                CONSUMER.MEMBER_CODE,
                CONSUMER.CONSUMER_ID,
                CONSUMER.CONSUMER_NAME,
                CONSUMER.CONSUMER_SURNAME,
                CONSUMER.COMPANY,
                CONSUMER.MOBIL_CODE,
                CONSUMER.MOBILTEL,
                CONSUMER_WORKTEL AS COMPANY_TEL1,
                CONSUMER_WORKTELCODE AS COMPANY_TELCODE,
                CONSUMER.TC_IDENTY_NO,
                CONSUMER.WORK_DOOR_NO AS ADDRESS,
                CONSUMER.TAX_COUNTRY_ID AS COUNTRY_ID,
                CONSUMER.TAX_CITY_ID AS CITY_ID,
                CONSUMER.TAX_COUNTY_ID AS COUNTY_ID
            FROM
                CONSUMER
            WHERE
                CONSUMER.CONSUMER_STATUS = 1 
                <cfif isDefined("arguments.wexdata.keyword") and len(arguments.wexdata.keyword)>
                AND
                (
                    CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>
                    OR (CONSUMER.MEMBER_CODE IS NOT NULL AND CONSUMER.MEMBER_CODE LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
                    OR (CONSUMER.MOBIL_CODE IS NOT NULL AND CONSUMER.MOBILTEL IS NOT NULL AND ISNULL(CONSUMER.MOBIL_CODE, '') + ISNULL(CONSUMER.MOBILTEL, '') LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
                    OR (CONSUMER.TC_IDENTY_NO IS NOT NULL AND CONSUMER.TC_IDENTY_NO LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
                )
                </cfif>
                <cfif isDefined("arguments.wexdata.consumer_id") and len(arguments.wexdata.consumer_id)>
                    AND CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wexdata.consumer_id#"> 
                </cfif>
        </cfquery>
        <cfquery name="query_get_company" datasource="#dsn#">
            SELECT
                C.COMPANY_ID
                ,C.FULLNAME
                ,C.TAXNO
                ,C.TAXOFFICE
                ,C.COMPANY_ADDRESS AS ADDRESS
                ,C.COMPANY_TELCODE
                ,C.COMPANY_TEL1
                ,C.MEMBER_CODE
                ,C.MOBIL_CODE
                ,C.MOBILTEL
                ,C.COUNTRY AS COUNTRY_ID
                ,C.CITY AS CITY_ID
                ,C.COUNTY AS COUNTY_ID
                ,P.COMPANY_PARTNER_NAME
                ,P.COMPANY_PARTNER_SURNAME
            FROM COMPANY C
            INNER JOIN COMPANY_PARTNER P ON C.COMPANY_ID = P.COMPANY_ID
            WHERE C.COMPANY_STATUS = 1
            <cfif isDefined("arguments.wexdata.consumer_id") and len(arguments.wexdata.consumer_id)>
                AND 1=2
            </cfif>
            <cfif isDefined("arguments.wexdata.keyword") and len(arguments.wexdata.keyword)>
            AND
            (
                C.FULLNAME LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>
                OR (C.MEMBER_CODE IS NOT NULL AND C.MEMBER_CODE LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
                OR (C.TAXNO IS NULL AND C.TAXNO LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
                OR (C.COMPANY_TELCODE IS NOT NULL AND C.COMPANY_TEL1 IS NOT NULL AND ISNULL(C.COMPANY_TELCODE, '') +  ISNULL(C.COMPANY_TEL1, '') LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
                OR (P.COMPANY_PARTNER_NAME IS NOT NULL AND P.COMPANY_PARTNER_SURNAME IS NOT NULL AND ISNULL(P.COMPANY_PARTNER_NAME, '') + ISNULL(P.COMPANY_PARTNER_SURNAME, '') LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.wexdata.keyword#%'>)
            )
            </cfif>
        </cfquery>
        <cfset result = "">
        <cfset result = '{ "consumer":' & Replace(serializeJson(this.queryJSONConverter.returnData(Replace(serializeJson(query_get_consumer),"//",""))),"//","") & ', "company":' & Replace(serializeJson(this.queryJSONConverter.returnData(Replace(serializeJson(query_get_company),"//",""))),"//","") & '}'>
        <cfreturn result>
    </cffunction>

    <cffunction name="country" access="public">

        <cfquery name="query_get_country" datasource="#dsn#">
            SELECT COUNTRY_ID, COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY ISNULL(IS_DEFAULT, 0) DESC
        </cfquery>

        <cfset result = Replace(serializeJson(this.queryJSONConverter.returnData(Replace(serializeJson(query_get_country),"//",""))),"//","")>
        <cfreturn result>

    </cffunction>

    <cffunction name="city" access="public">
        <cfargument name="wexdata">
        
        <cfquery name="query_get_country" datasource="#dsn#">
            SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wexdata.country#'> ORDER BY ISNULL(PRIORITY, 0)
        </cfquery>

        <cfset result = Replace(serializeJson(this.queryJSONConverter.returnData(Replace(serializeJson(query_get_country),"//",""))),"//","")>
        <cfreturn result>

    </cffunction>

    <cffunction name="county" access="public">
        <cfargument name="wexdata">
        
        <cfquery name="query_get_country" datasource="#dsn#">
            SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wexdata.city#'> ORDER BY COUNTY_ID
        </cfquery>

        <cfset result = Replace(serializeJson(this.queryJSONConverter.returnData(Replace(serializeJson(query_get_country),"//",""))),"//","")>
        <cfreturn result>

    </cffunction>

</cfcomponent>