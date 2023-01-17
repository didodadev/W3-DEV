<!--- ----------------------------------------------------------------------------
	Base abstraction class, used for data operations
	Class provides base set of methods to access and change data in DB, class used as a base for DB-specific wrappers
---------------------------------------------------------------------------- ---> 
<cfcomponent namespace="DBDataWrapper">
	<cfscript>
		variables.connectionDSN="";
		variables.config="";			//!< DataConfig instance
		variables.transaction = false;
		variables.sequence = false;
		variables.sqls = StructNew();
		variables.last_inserted_id = 0;
		
		//Public
		this.fieldTypes = structNew();
	</cfscript>
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="config" type="any" required="yes">
		<cfargument name="connectionDSN" type="any" required="yes">
		<cfset variables.config = ARGUMENTS.config>
		<cfset variables.connectionDSN = ARGUMENTS.connectionDSN>
		<cfreturn this>
	</cffunction>

	<cffunction name="getId" access="public" returntype="string" hint="get the ID of the current table">
		<cfreturn variables.config.id["db_name"]>
	</cffunction>
	<cffunction name="getTable" access="public" returntype="string" hint="get the Table of the current table">
		<cfreturn variables.config.id["db_name"]>
	</cffunction>
		
	<cffunction name="attach" access="public" returntype="void" hint="assign named sql query">
		<cfargument name="name" type="string" required="yes" hint="name of sql query">
		<cfargument name="data" type="string" required="yes" hint="sql query text">
		<cfset variables.sqls[ARGUMENTS.name]=ARGUMENTS.data>
	</cffunction>
	
	<cffunction name="setFieldTypes" access="public" returntype="void" hint="Set field types">
		<cfargument name="data" type="struct" required="yes">
		<cfset this.fieldTypes = ARGUMENTS.data>
	</cffunction>
	<cffunction name="getQuoteForField" access="public" returntype="string" hint="Do we need quote">
		<cfargument name="field_name" type="string" required="yes">
		<cfset var local = structNew()>
		<cfset local.quote = "'">
		<cfif structKeyExists(this.fieldTypes,ARGUMENTS.field_name)>
			<cfswitch expression="#this.fieldTypes[ARGUMENTS.field_name]#">
				<cfcase value="number">
					<cfset local.quote = "">
				</cfcase>
				<cfcase value="text">
					<cfset local.quote = "'">
				</cfcase>
			</cfswitch>
		</cfif>
		<cfreturn local.quote>			
	</cffunction>
						
	<cffunction name="get_sql" access="public" returntype="string">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="data" type="any" required="yes">
		<cfset var str = "">
		<cfset var match = "">
		<cfset var start = "">
		<cfset var matches = ArrayNew(1)>
		<cfset var i = "">
		<cfset var ind = "">
		
		<cfif NOT structKeyExists(variables.sqls,ARGUMENTS.name)>
			<cfreturn "">
		</cfif>
		<cfset str = variables.sqls[ARGUMENTS.name]>
		
		<cfset start = 1>
		<Cfloop from="1" to="1000" index="i">
			<cfset match = refindNoCase("\{([^}]+)\}",str,start,true)>
			<cfif match.pos[1]>
				<cfset ind = ArrayLen(matches)+1>
				<cfset matches[ind] = structNew()>
				<cfset matches[ind].from = mid(str,match.pos[1],match.len[1])>
				<cfset matches[ind].to = mid(str,match.pos[2],match.len[2])>
				<cfset start = match.pos[1]+match.len[1]>
			<cfelse>
				<cfbreak>	
			</cfif>
		</Cfloop>
		<cfloop from="1" to="#ArrayLen(matches)#" index="i">
			<cfset str = replaceNOCase(str,matches[i].from,escape(ARGUMENTS.data.get_value(matches[i].to)),"all")>	
		</cfloop>
		<cfreturn str>
	</cffunction>	
	
	
	<cffunction name="do_insert" access="public" returntype="void">
		<cfargument name="data" type="any" required="yes">
		<cfargument name="source" type="any" required="yes">
		<cfset var sql = "">
		<cfset sql = insert_query(ARGUMENTS.data, ARGUMENTS.source)>
		<cfset variables.last_inserted_id = do_query(sql,ARGUMENTS.source).id>
		<cfset ARGUMENTS.data.success(get_new_id())>
	</cffunction>
	<cffunction name="do_delete" access="public" returntype="void">
		<cfargument name="data" type="any" required="yes">
		<cfargument name="source" type="any" required="yes">
		<cfset var sql = "">
		<cfset sql = delete_query(ARGUMENTS.data, ARGUMENTS.source)>
		<cfset do_query(sql)>
		<cfset ARGUMENTS.data.success()>
	</cffunction>
	<cffunction name="do_update" access="public" returntype="void">
		<cfargument name="data" type="any" required="yes">
		<cfargument name="source" type="any" required="yes">
		<cfset var sql = "">
		<cfset sql = update_query(ARGUMENTS.data, ARGUMENTS.source)>
		<cfset do_query(sql)>
		<cfset ARGUMENTS.data.success()>
	</cffunction>
	<cffunction name="do_select" access="public" returntype="any">
		<cfargument name="source" type="any" required="yes">
		<cfset var select = "">
		<cfset var where = "">
		<cfset var sort = "">
		<cfset select=ARGUMENTS.source.get_fieldset()>
		<cfif NOT Len(select)>
			<cfset select=variables.config.db_names_list()>
		</cfif>
		<cfset where=build_where(ARGUMENTS.source.get_filters(),ARGUMENTS.source.get_relation())>
		<cfset sort=build_order(ARGUMENTS.source.get_sort_by())>
		<cfreturn do_query(select_query(select,ARGUMENTS.source.get_source(),where,sort,ARGUMENTS.source.get_start(),ARGUMENTS.source.get_count()))>
	</cffunction>
	<cffunction name="get_size" access="public" returntype="any">
		<cfargument name="source" type="any" required="yes">
		<cfset var count = "">
		<cfset var select = "">
		<cfset var res = "">
		<cfset var data = "">
		
		<cfset count = CreateObject("component","DataRequestConfig").init(ARGUMENTS.source)>
		<cfset select= ARGUMENTS.source.get_fieldset()>
		<cfif NOT len(select)>
			<cfset select=variables.config.db_names_list()>
		</cfif>	
			
		<cfset count.set_fieldset("COUNT(*) as DHX_COUNT ")>
		<cfset count.set_sort("")>
		<cfset count.set_limit(0,0)>
		
		<cfset res=do_select(count)>
		<cfset data=get_next(res,1)>
		<cfreturn data["dhx_count"]>
	</cffunction>
	<cffunction name="get_variants" access="public" returntype="any">
		<cfargument name="name" type="any" required="yes">
		<cfargument name="source" type="any" required="yes">
		<cfset var count = "">
		
		<cfset count = CreateObject("component","DataRequestConfig").init(ARGUMENTS.source)>
		<cfset count.set_fieldset("DISTINCT " & variables.config.db_names_list())>
		<cfset count.set_sort("")>
		<cfset count.set_limit(0,0)>
		<cfreturn do_select(count)>
	</cffunction>
	<cffunction name="sequence" access="public" returntype="any">
		<cfargument name="sec" type="any" required="yes">
		<cfset variables.sequence = ARGUMENTS.sec>
	</cffunction>
	<cffunction name="build_where" access="public" returntype="any">
		<cfargument name="rules" type="any" required="yes">
		<cfargument name="relation" type="any" required="no" default="">
		<cfset var sql = "">
		<cfset var i = "">
		<cfset var local = structNew()>
		<cfset sql=ArrayNew(1)>
		<cfloop from="1" to="#ArrayLen(ARGUMENTS.rules)#" index="i">
			<cfif NOt isStruct(ARGUMENTS.rules[i])>
				<cfset ArrayAppend(sql,ARGUMENTS.rules[i])>
			<cfelse>
				<cfif ARGUMENTS.rules[i]["value"] neq "">
					<cfset local.quote = getQuoteForField(ARGUMENTS.rules[i]["name"])>
					<cfif NOt len(ARGUMENTS.rules[i]["operation"])>
						<cfset ArrayAppend(sql,ARGUMENTS.rules[i]["name"] & " LIKE '%" & escape(ARGUMENTS.rules[i]["value"]) & "%'")>
					<cfelse>
						<cfset ArrayAppend(sql,ARGUMENTS.rules[i]["name"] & " " & ARGUMENTS.rules[i]["operation"] & " #local.quote#" & escape(ARGUMENTS.rules[i]["value"]) & "#local.quote#")>
					</cfif>	
				</cfif>
			</cfif>	
		</cfloop>	
		<cfif Len(ARGUMENTS.relation)>
			<cfset local.quote = getQuoteForField(variables.config.relation_id["db_name"])>
			<Cfset ArrayAppend(sql,variables.config.relation_id["db_name"] &  " = #local.quote#" & escape(ARGUMENTS.relation) & "#local.quote#")>
		</cfif>	
		<cfreturn ArrayToList(sql," AND ")>
	</cffunction>
	<cffunction name="build_order" access="public" returntype="any">
		<cfargument name="by" type="any" required="yes">
		<cfset var out = "">
		<cfset var i = "">
		<cfif NOt ArrayLen(ARGUMENTS.by)>
			<cfreturn  "">
		</cfif>
		<cfset out = ArrayNew(1)>
		<cfloop from="1" to="#ArrayLen(ARGUMENTS.by)#" index="i">
			<cfif Len(ARGUMENTS.by[i]["name"])>
				<cfset ArrayAppend(out,ARGUMENTS.by[i]["name"] & " " & ARGUMENTS.by[i]["direction"])>
			</cfif>	
		</cfloop>
		<cfreturn ArrayToList(out,",")>
	</cffunction>
	
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
			<!--- different actions --->
		</cfif>

		<!--- MY SQL sample: 
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
		--->
		<cfreturn sql>
	</cffunction>
	
	<cffunction name="update_query" access="public" returntype="string" hint="generates update sql. Return: sql string, which updates record with provided data">
		<cfargument name="data" type="any" required="yes">
		<cfargument name="_request" type="any" required="yes">
		<cfset var sql = "">
		<cfset var temp = "">
		<cfset var i = "">
		<cfset var where = "">
		<Cfset var step = "">
		<cfset var local = structNew()>
			
		<cfset sql="UPDATE " & ARGUMENTS._request.get_source() & " SET ">
		<cfset temp=ArrayNew(1)>
		<cfloop  from="1" to="#ArrayLen(variables.config.text)#" index="i">
			<cfset step=variables.config.text[i]>
			<cfset local.quote = getQuoteForField(step["db_name"])>
			<cfset temp[i] = step["db_name"] & "=#local.quote#" & escape(ARGUMENTS.data.get_value(step["name"])) & "#local.quote#">
		</cfloop>
		<cfset local.quote = getQuoteForField(variables.config.id["db_name"])>
		<cfset sql = sql & ArrayToList(temp,",") & " WHERE " & variables.config.id["db_name"] & "=#local.quote#" & escape(ARGUMENTS.data.get_id()) & "#local.quote#">
		
		<!--- if we have limited set - set constraints --->
		<cfset where=build_where(ARGUMENTS._request.get_filters(),ARGUMENTS._request.get_relation())>
		<cfif Len(where)>
			<cfset sql = sql & " AND (" & where & ")">
		</cfif> 
		<cfreturn sql>
	</cffunction>
	
	<cffunction name="delete_query" access="public" returntype="string" hint="generates delete sql. Return: sql string, which delete record">
		<cfargument name="data" type="any" required="yes">
		<cfargument name="_request" type="any" required="yes">
		<cfset var sql = "">
		<cfset var temp = "">
		<cfset var i = "">
		<cfset var where = "">
		<Cfset var step = "">
		<cfset var local = structNew()>
			
		<cfset sql="DELETE FROM " & ARGUMENTs._request.get_source()>
		<cfset local.quote = getQuoteForField(variables.config.id["db_name"])>
		<cfset sql = sql & " WHERE " & variables.config.id["db_name"] & "=#local.quote#" & escape(ARGUMENTS.data.get_id()) & "#local.quote#">
		
		<!--- if we have limited set - set constraints--->
		<cfset where=build_where(ARGUMENTS._request.get_filters(),ARGUMENTs._request.get_relation())>
		
		<cfif len(where) >
			<cfset sql = sql & " AND (" & where & ")">
		</cfif>
		<cfreturn sql>
	</cffunction>

	<cffunction name="insert_query" access="public" returntype="string" hint="generates insert sql. Return: sql string, which inserts new record with provided data">
		<cfargument name="data" type="any" required="yes">
		<cfargument name="_request" type="any" required="yes">
		<cfset var sql = "">
		<cfset var temp_n = "">
		<cfset var temp_v = "">
		<cfset var i = "">
		<cfset var v = "">
		<Cfset var relation = "">
		<cfset var local = structNew()>
		
		<cfset local.temp_n=ArrayNew(1)>
		<cfset local.temp_v=ArrayNew(1)>
		<cfloop from="1" to="#ArrayLen(variables.config.text)#" index="i">
			<cfset v = variables.config.text[i]>
			<cfset local.quote = getQuoteForField(v["db_name"])>
			<cfset local.temp_n[i]=v["db_name"]>
			<cfset local.temp_v[i]="#local.quote#" & escape(ARGUMENTS.data.get_value(v["name"]))&"#local.quote#">
		</cfloop>
		
		
		<cfset relation = variables.config.relation_id["db_name"]>
		<cfif len(relation)>
			<cfset local.quote = getQuoteForField(relation)>
			<cfset ArrayAppend(local.temp_n,relation)>
			<cfset ArrayAppend(local.temp_v,"#local.quote#" & escape(ARGUMENTS.data.get_value(relation)) & "#local.quote#")>
		</cfif>
		<cfif variables.sequence>
			<cfset ArrayAppend(local.temp_n,variables.config.id["db_name"])>
			<cfset ArrayAppend(local.temp_v,variables.sequence)>
		</cfif>
		
		<cfset sql="INSERT INTO " & ARGUMENTS._request.get_source() & "(" & ArrayToList(local.temp_n,",") & ") VALUES (" & ArrayToList(local.temp_v,",") & ")">
		<cfreturn sql>
	</cffunction>
	
	<cffunction name="set_transaction_mode" access="public" returntype="any">
		<cfargument name="mode" type="any" required="yes">
		<cfif ARGUMENTs.mode neq "none" AND  ARGUMENTs.mode neq "global" AND ARGUMENTS.mode neq "record">
			<Cfthrow errorcode="99" message="Unknown transaction mode">
		</cfif>	
		<cfset variables.transaction=ARGUMENTS.mode>
	</cffunction>	
	
	<cffunction name="is_global_transaction" access="public" returntype="any">
		<cfif variables.transaction eq "global">
			<cfreturn true>
		<cfelse>
			<cfreturn false>	
		</cfif>
	</cffunction>
	
	<cffunction name="is_record_transaction" access="public" returntype="any">
		<cfif variables.transaction eq "record">
			<cfreturn true>
		<cfelse>
			<cfreturn false>	
		</cfif>
	</cffunction>

	<cffunction name="begin_transaction" access="public" returntype="any">
	</cffunction>
	<cffunction name="commit_transaction" access="public" returntype="any">
	</cffunction>
	<cffunction name="rollback_transaction" access="public" returntype="any">
	</cffunction>
	
	<cffunction name="do_query" access="public" returntype="query">
		<cfargument name="sql" type="string" required="yes">
		<cfargument name="request" type="any" required="no">
		<cfset var res = "">
		<cfset request.dhtmlXLogMaster = log(ARGUMENTS.sql)>
		<!--- DEBUG 
		<cfcontent reset="yes" type="text/html"><Cfoutput>#preservesinglequotes(ARGUMENTS.sql)#<Cfabort></Cfoutput>
		<cfsavecontent variable="tmp">
			<Cfdump var="#ARGUMENTS#">
		</cfsavecontent>
		<cffile action="append" file="d:\dhtmlX\dhtmlxConnector_cfm\codebase\debug.htm" output="#tmp#" nameconflict="overwrite">
		--->
		<cfquery datasource="#variables.connectionDSN#" name="res">
			#preservesinglequotes(ARGUMENTS.sql)#
		</cfquery>
		<cfif NOT isDefined("res")>
			<cfset res = QueryNew("id")>
		</cfif>
		<cfreturn res>	
	</cffunction>
	<cffunction name="get_next" access="public" returntype="struct">
		<cfargument name="data" type="query" required="yes">
		<cfargument name="ind" type="numeric" required="yes">
		<cfset var res = structNew()>
		<cfset var fld = "">
		<cfloop list="#ARGUMENTS.data.columnList#" index="fld">
			<cfset res[fld] = ARGUMENTS.data[fld][ARGUMENTS.ind]>
		</cfloop>
		<cfreturn res>
	</cffunction>
	<cffunction name="escape" access="public" returntype="string">
		<cfargument name="c" type="string" required="yes">
		<cfset ARGUMENTS.c = replaceNOCase(ARGUMENTS.c,"'","''","all")>
		<cfreturn ARGUMENTS.c>
	</cffunction>
	<cffunction name="get_new_id" access="public" returntype="any">
		<cfset var res = "">
		<cfreturn variables.last_inserted_id>
	</cffunction>
</cfcomponent>

