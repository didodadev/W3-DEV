<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 23/05/2016			Dev Date	: 23/05/2016		
Description :
	Bu utility banka hesapları selectboxı bulunan bazı sayfalarda kullanılır. applicationStart methodunda create edilir.
	
Patameters :
		moneyType					
		 değerlerini alır.

Used : bankAccounts = bankAccounts.get('TL');
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    
    <cffunction name="getCountry" hint="Ülkeleri Çeker" access="public" returntype="string">
        <cfquery name="GET_COUNTRY" datasource="#dsn#">
            SELECT
                COUNTRY_ID,
                COUNTRY_NAME,
                IS_DEFAULT
            FROM
                SETUP_COUNTRY
            ORDER BY
                COUNTRY_NAME
        </cfquery>
        <cfreturn serializeJson(GET_COUNTRY)>
    </cffunction>
    
    <cffunction name="multiSelectFirmType" hint="Firma Tiplerini Doldurur" access="public" returntype="string">
        <cfset firmType = StructNew()>
        <cfset firmType['tableName'] = 'SETUP_FIRM_TYPE'>
        <cfset firmType['optionName'] = 'firm_type'>
        <cfset firmType['optionValue'] = 'firm_type_id'>
        <cfreturn serializeJson(firmType)>
    </cffunction>
</cfcomponent>