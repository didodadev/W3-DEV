<!--- 
	amac            : NICKNAME,FULLNAME,MEMBER_CODE vererek COMPANY_ID,NICKNAME,MEMBER_CODE bilgisini getirmek
	parametre adi   : nickname
		ayirma isareti  : YOK
	kullanim        : get_company('Asu') 
	Yazan           : A.Selam Karatas
	Tarih           : 22.5.2007
	Guncelleme      : 22.5.2007
 --->
<cffunction name="get_company" access="public" returnType="query" output="no">
	<cfargument name="nickname" required="yes" type="string" default="">
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
			NICKNAME,
			MEMBER_CODE
		FROM 
			COMPANY
		WHERE 
			FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
			NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
			MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
		ORDER BY 
			FULLNAME
	</cfquery>
	<cfreturn get_company>
</cffunction>
