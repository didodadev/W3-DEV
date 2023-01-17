<!--- 
	amac            : NICKNAME,FULLNAME,MEMBER_CODE,'COMPANY_PARTNER_NAME COMPANY_PARTNER_SURNAME' vererek 
						COMPANY_ID,NICKNAME,FULLNAME,MEMBER_CODE,PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME bilgisini getirmek
	parametre adi   : nickname
		ayirma isareti  : YOK
	kullanim        : get_company('Asu') 
	Yazan           : A.Selam Karatas
	Tarih           : 5.6.2007
	Guncelleme      : 8.6.2007
 --->
<cffunction name="get_company_partner" access="public" returnType="query" output="no">
	<cfargument name="nickname" required="yes" type="string" default="">
	<cfquery name="get_company_partner" datasource="#dsn#">
		SELECT 
			C.COMPANY_ID,
			C.NICKNAME,
			C.FULLNAME FULLNAME,
			C.MEMBER_CODE,
			CP.PARTNER_ID PARTNER_ID,
			CP.COMPANY_PARTNER_NAME COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME COMPANY_PARTNER_SURNAME
		FROM 
			COMPANY C,
			COMPANY_PARTNER CP
		WHERE 
			C.COMPANY_ID = CP.COMPANY_ID AND
			C.COMPANY_STATUS = 1 AND
			CP.COMPANY_PARTNER_STATUS = 1 
			<cfif len(arguments.nickname)>
			AND
			(
				C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
				C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
				C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
				<cfif database_type is 'MSSQL'>
				COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
				<cfelseif database_type is 'DB2'>
				COMPANY_PARTNER_NAME || ' ' || COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
				</cfif>
			)
			</cfif>
		UNION ALL
		SELECT 
			C.COMPANY_ID,
			C.NICKNAME,
			C.FULLNAME FULLNAME,
			C.MEMBER_CODE,
			-1 PARTNER_ID,
			'' COMPANY_PARTNER_NAME,
			'' COMPANY_PARTNER_SURNAME
		FROM 
			COMPANY C
		WHERE 
			C.COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY_PARTNER) AND
			C.COMPANY_STATUS = 1 
			<cfif len(arguments.nickname)>
			AND
			(
				C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
				C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%"> OR
				C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#%">
			)	
			</cfif>	
		ORDER BY
			FULLNAME,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME
	</cfquery>
	<cfreturn get_company_partner>
</cffunction>
