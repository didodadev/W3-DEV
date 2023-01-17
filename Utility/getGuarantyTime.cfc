<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Emin Yaşartürk		Developer	: Emin Yaşartürk
Analys Date : 30/05/2016			Dev Date	: 30/05/2016
Description :
	Bu utility garanti kategorilerinden garanti sürelerini getirir applicationStart methodunda create edilir.

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="guarantyCatId" required="no" default="" type="string" hint="Garanti Kategorisi">
        
        <cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
            SELECT (SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.guarantyCatId#">
        </cfquery>
		<cfreturn GET_GUARANTY_CAT>
	</cffunction>
</cfcomponent>