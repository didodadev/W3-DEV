<!---
File: government_audit.cfm
Author: StartechBT <eminyasarturk@startechbt.com>
Controller: -
Description: Sayıştay Uyumluluk
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name = "getPositionCats">
    	<cfquery name="GetPositionType" datasource="#dsn#">
			SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT      
        </cfquery>
        <cfreturn GetPositionType>
    </cffunction>
	<cffunction name = "saveParams">
		<cfset fullData = UrlDecode(arguments.data,'utf-8') />
		<cfloop index = "ListElement" list = "#fullData#" delimiters = "&">
			<cfif listLen(ListElement,'=') eq 2>
				<cfset arguments['#listFirst(ListElement,"=")#'] = listLast(ListElement,"=")> 
			<cfelse>
				<cfset arguments['#listFirst(ListElement,"=")#'] = ''> 
			</cfif>
		</cfloop>
    	<cfquery name="GetPositionType" datasource="#dsn#">
			INSERT INTO GOVERNMENT_AUDIT_PARAMS
			(
				COMPANY_CODE,
            	COMPANY_NAME,
            	ACCOUNT_UNIT_NAME,
            	ACCOUNT_UNIT_CODE,
            	DEFAULT_BRACE,
            	RECORD_EMP,
            	RECORD_DATE,
            	RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_code#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_name#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_unit_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.account_unit_code#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_brace#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
			)
        </cfquery>
        <cfreturn 1>
    </cffunction>
	<cffunction name = "getPeriods">
		<cfquery name="GET_PERIODS" datasource="#dsn#">
			SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR DESC
		</cfquery>
		 <cfreturn GET_PERIODS>
	</cffunction>
</cfcomponent>