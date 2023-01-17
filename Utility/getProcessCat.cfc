<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility İşlem Kategorilerine ait bilgileri getirir applicationStart methodunda create edilir.
	
Patameters :
		process_cat :  default olarak 0 gelir . Değer girildiği zaman SETUP_PROCESS_CAT tablosundandan verileri getirir

Used : getProcessCat.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="process_cat" type="numeric" default="0" required="yes">
    	
        <cfquery name="get" datasource="#dsn3#">
            SELECT 
                PROCESS_TYPE,
                IS_CARI,
                IS_ACCOUNT,
                IS_BUDGET,
                MULTI_TYPE
             FROM 
             	SETUP_PROCESS_CAT 
             WHERE 
                PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.process_cat#">
        </cfquery>
        
        <cfreturn get>
    </cffunction>
</cfcomponent>