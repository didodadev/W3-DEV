<cfcomponent>
	<cfset this.dsn = application.systemParam.systemParam().dsn>
		<cffunction name="add_approve" access="remote" returntype="string" returnFormat="json">
		<cfargument name="IS_APPROVE" default="0">
		<cfargument name="IS_MAIL" default="0">
		<cfset result = StructNew()> 			
		<cftry>
			<cfset result.status = true>
			<cfset result.id = #arguments.ID#>
			<cfquery name="add_approve_query" datasource="#this.dsn#">
				INSERT INTO EMPLOYEES_OFFTIME_CONTRACT (
					EMPLOYEE_ID,
					SAL_YEAR,
					IS_APPROVE,
					IS_MAIL,
					OFFTIME_DATE_1,
					EX_SAL_YEAR_REMAINDER_DAY, --Önceki Dönemden Devredilen İzin Gün Sayısı
					EX_SAL_YEAR_OFTIME_DAY, --Önceki Dönemde kullanılan İzin Gün Sayısı
					SAL_YEAR_REMAINDER_DAY, --İlgili Dönem Hak edilen İzin Gün Sayısı,
					SAL_YEAR_OFTIME_DAY, --İlgili Dönemda Kullanılan İzin Gün Sayısı
					SYSTEM_PAPER_NO, --Mutabakat No - Sistem belge numarası
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				) VALUES(
					<cfif len(arguments.ID)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IS_APPROVE#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IS_MAIL#">,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.EX_SAL_YEAR_REMAINDER_DAY#">, --Önceki Dönemden Devredilen İzin Gün Sayısı
					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.EX_SAL_YEAR_OFTIME_DAY#">, --Önceki Dönemde kullanılan İzin Gün Sayısı
					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.SAL_YEAR_REMAINDER_DAY#">, --İlgili Dönem Hak edilen İzin Gün Sayısı,
					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.SAL_YEAR_OFTIME_DAY#">, --İlgili Dönemda Kullanılan İzin Gün Sayısı
					0, --Mutabakat No - Sistem belge numarası
					#now()#,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
				)
			</cfquery>
			<cfreturn Replace(serializeJSON(result),'//','')>
			<cfcatch type="any">
			<cfdump  var="#cfcatch#" abort>
				<cfset result.status = false>
				<cfset result.error = cfcatch.message >
				<cfreturn Replace(serializeJSON(result),'//','')>
			</cfcatch>
        </cftry>
	</cffunction>
</cfcomponent>
