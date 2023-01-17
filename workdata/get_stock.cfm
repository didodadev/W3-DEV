<!--- 
	Ama�:Depo adini vererek Department ve comment bilgsini getirme --(Depolar ve Lokasyonlar sayfasina y�nlenen durumlar i�in)----
	Parametre adi:comment
	Kullanim:get_stock
	Yazan:S.T
	Tarih:25.08.2008
 --->
<cffunction name="get_stock" access="public" returnType="query" output="no">
	<cfargument name="comment" required="yes" type="string">
	<cfquery name="get_stock" datasource="#DSN#">
		SELECT
			ST.DEPARTMENT_ID,
			ST.LOCATION_ID,
			ST.COMMENT,
			D.DEPARTMENT_HEAD,
			<cfif database_type is "MSSQL">
				(D.DEPARTMENT_HEAD + ' - ' + ST.COMMENT) DEPARTMENT_COMMENT
			<cfelseif database_type is "DB2">
				(D.DEPARTMENT_HEAD || ' - ' || ST.COMMENT) DEPARTMENT_COMMENT
			</cfif>
		FROM
			STOCKS_LOCATION ST,
			DEPARTMENT D
		WHERE 
			ST.DEPARTMENT_ID=D.DEPARTMENT_ID AND
			(
				D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#%"> OR 
				ST.COMMENT LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#%">
			)
		ORDER BY 
			D.DEPARTMENT_HEAD
	</cfquery>
	<cfreturn get_stock>
</cffunction>
			
