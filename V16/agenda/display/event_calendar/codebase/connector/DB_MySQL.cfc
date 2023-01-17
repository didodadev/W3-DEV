<cfcomponent namespace="DB_MySQL" extends="DBDataWrapper">
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
					SELECT LAST_INSERT_ID() as id;
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
		<cfset sql="SELECT " & ARGUMENTS.select & " FROM " & ARGUMENTS.from>
		<cfif len(ARGUMENTS.where)>
			<cfset sql = sql & " WHERE " & ARGUMENTS.where>
		</cfif>
		<cfif len(ARGUMENTS.sort)>
			<cfset sql = sql & " ORDER BY " & ARGUMENTS.sort>
		</cfif>
		<cfif ARGUMENTS.start OR ARGUMENTS.count>
			<cfset sql = sql & " LIMIT " & ARGUMENTS.start & "," & ARGUMENTS.count>
		</cfif>
		<cfreturn sql>
	</cffunction>	
	<cffunction name="begin_transaction" access="public" returntype="any">
		<cfset do_query("BEGIN")>
	</cffunction>
	<cffunction name="commit_transaction" access="public" returntype="any">
		<cfset do_query("COMMIT")>
	</cffunction>
	<cffunction name="rollback_transaction" access="public" returntype="any">
		<cfset do_query("ROLLBACK")>
	</cffunction>
</cfcomponent>

