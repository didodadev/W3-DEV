<cfcomponent namespace="DB_MSSQL" extends="DBDataWrapper">
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="db" type="string" required="yes">
		<cfargument name="config" type="any" required="yes">
		<cfset super.init(ARGUMENTS.config,ARGUMENTS.db)>
		<cfreturn this>	
	</cffunction>
	
	<cffunction name="do_query" access="public" returntype="query">
		<cfargument name="sql" type="string" required="yes">
		<cfset var res = "">
		<cfset request.dhtmlXLogMaster.do_log(ARGUMENTS.sql)>
		
		<cfif findNoCase("INSERT INTO ",ARGUMENTS.sql)>
			<cflock name="dhtmlX_INSERT" timeout="10" type="readonly">
				<cfquery datasource="#variables.connectionDSN#" name="res">
					#preservesinglequotes(ARGUMENTS.sql)#
				</cfquery>
				<cfquery datasource="#variables.connectionDSN#" name="res">
					SELECT @@IDENTITY AS id
				</cfquery>		
			</cflock>	
		<Cfelse>
			<cfquery datasource="#variables.connectionDSN#" name="res">
				#preservesinglequotes(ARGUMENTS.sql)#
			</cfquery>
			<cfif NOT isDefined("res")>
				<cfset res = QueryNew("id")>
			</cfif>
		</cfif>	
		<cfreturn res>	
	</cffunction>
	
	<!------------ ----------->
	<cffunction name="select_query" access="public" returntype="string">
		<cfargument name="select" type="string" required="yes">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="where" type="string" required="no" default="">
		<cfargument name="sort" type="string" required="no" default="">
		<cfargument name="start" type="numeric" required="no" default="1">
		<cfargument name="count" type="numeric" required="no" default="0">
		<cfset var sql = "">
		<cfset var local = structNew()>
		<cfset local.id = getId()>

		<cfif ARGUMENTS.count>
			<cfset local.top = "TOP #ARGUMENTS.count#">	
		<Cfelse>
			<cfset local.top = "">		
		</cfif>
		<cfif len(ARGUMENTS.where)>
			<cfset local.where = "WHERE #ARGUMENTS.where#">
		<cfelse>	
			<cfset local.where = "">
		</cfif>
		<cfif len(ARGUMENTS.sort)>
			<cfset local.sort = "ORDER BY #ARGUMENTS.sort#">
		<cfelse>	
			<cfset local.sort = "">
		</cfif>

		<cfif ARGUMENTS.start gt 1>
			<cfif len(ARGUMENTS.sort)>
				<cfset local.sort_real = "#local.sort#, #local.id#">
			<cfelse>
				<cfset local.sort_real = "ORDER BY #local.id#">
			</cfif>
			<cfset sql = "SELECT TOP #evaluate(ARGUMENTS.start+ARGUMENTS.count-1)# #local.id# as dhx_custom_id, #ARGUMENTS.select# FROM #ARGUMENTS.from# #local.where# #local.sort_real#">
			<cfset sql = "SELECT #ARGUMENTS.select# FROM (#sql#) as tbl WHERE dhx_custom_id NOT IN (SELECT TOP #evaluate(ARGUMENTS.start-1)# #local.id# FROM #ARGUMENTS.from# #local.where# #local.sort_real#) #local.sort#">
		<cfelse>
			<cfset sql = "SELECT #local.top# #ARGUMENTS.select# FROM #ARGUMENTS.from# #local.where# #local.sort#">
		</cfif>
		<cfreturn sql>
	</cffunction>	
	<cffunction name="begin_transaction" access="public" returntype="any">
	</cffunction>
	<cffunction name="commit_transaction" access="public" returntype="any">
	</cffunction>
	<cffunction name="rollback_transaction" access="public" returntype="any">
	</cffunction>
</cfcomponent>

