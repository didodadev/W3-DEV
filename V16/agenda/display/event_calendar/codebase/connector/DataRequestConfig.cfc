<cfcomponent namespace="DataRequestConfig" hint="Manager of data request">
	<cfscript>
		variables.lineBreak = "#chr(13)##chr(10)#";
		variables.filters = ArrayNew(1);	//!< array of filtering rules
		variables.relation="";			//!< ID or other element used for linking hierarchy
		variables.sort_by = ArrayNew(1);	//!< sorting field 
		variables.start=0;					//!< start of requested data
		variables.count=0;					//!< length of requested data
		
		//for render_sql
		variables.source="";					//!< souce table or another source destination
		variables.fieldset="";				//!< set of data, which need to be retrieved from source
	</cfscript>
	
	<cffunction name="init" access="public" returntype="any" hint="constructor">
		<cfargument name="proto" type="any" required="no" hint="DataRequestConfig object, optional, if provided then new request object will copy all properties from provided one">
		<cfif isDefined("ARGUMENTS.proto")>
			<cfset copy(ARGUMENTS.proto)>
		<cfelse>
			<cfset variables.filters = ArrayNew(1)>
			<cfset variables.sort_by = ArrayNew(1)>
		</cfif>
		<cfreturn this>
	</cffunction>	
	<cffunction name="copy" access="public" returntype="void">
		<cfargument name="proto" type="any" required="yes">
		<cfset variables.filters	= ARGUMENTS.proto.get_filters()>
		<cfset variables.sort_by	= ARGUMENTS.proto.get_sort_by()>
		<cfset variables.count	= ARGUMENTS.proto.get_count()>
		<cfset variables.start	= ARGUMENTS.proto.get_start()>
		<cfset variables.source	= ARGUMENTS.proto.get_source()>
		<cfset variables.fieldset	= ARGUMENTS.proto.get_fieldset()>
		<cfset variables.relation	= ARGUMENTS.proto.get_relation()>
	</cffunction>
	
	<cffunction name="__toString" access="public" returntype="string" hint="Convert self to string ( for logs ). Return self as plain string">
		<cfset var str = "">
		<cfset var i = "">
		<cfset str="Source:#source##variables.lineBreak#Fieldset:#fieldset##variables.lineBreak#Where:">
		<cfloop from="1" to="#ArrayLen(filters)#" index="i">
			<cfset str = str & filters[i]["name"] & " " & filters[i]["operation"] & " " & filters[i]["value"] & ";">
		</cfloop>	
		<cfset str = str & "#variables.lineBreak#Start:#start##variables.lineBreak#Count:#count##variables.lineBreak#">
		<cfloop from="1" to="#ArrayLen(sort_by)#" index="i">
			<cfset str = str & sort_by[i]["name"] & "=" & filters[i]["direction"] & ";">
		</cfloop>
		<cfset str = str & "#variables.lineBreak#Relation:#relation#">
		<cfreturn str>
	</cffunction>
	
	<cffunction name="get_filters" access="public" returntype="any">
		<cfreturn variables.filters>
	</cffunction>
	<cffunction name="get_fieldset" access="public" returntype="any">
		<cfreturn variables.fieldset>
	</cffunction>
	<cffunction name="get_source" access="public" returntype="any">
		<cfreturn variables.source>
	</cffunction>
	<cffunction name="get_sort_by" access="public" returntype="any">
		<cfreturn variables.sort_by>
	</cffunction>
	<cffunction name="get_start" access="public" returntype="any">
		<cfreturn variables.start>
	</cffunction>
	<cffunction name="get_count" access="public" returntype="any">
		<cfreturn variables.count>
	</cffunction>
	<cffunction name="get_relation" access="public" returntype="any">
		<cfreturn variables.relation>
	</cffunction>
	<cffunction name="set_sort" access="public" returntype="void">
		<cfargument name="field" type="string" required="no" default="">
		<cfargument name="order" type="string" required="no" default="">
		<cfset var st="">
		<cfif NOT len(ARGUMENTS.field) AND NOT len(ARGUMENTS.order)>
			<cfset variables.sort_by=ArrayNew(1)>
		<cfelse>
			<cfif ARGUMENTS.order eq "asc">
				<cfset ARGUMENTS.order="ASC">
			<cfelse>	
				<cfset ARGUMENTS.order="DESC">
			</cfif>
			<cfset st = structNew()>
			<cfset st["name"]=ARGUMENTS.field>
			<cfset st["direction"] = ARGUMENTS.order>
			<cfset ArrayAppend(variables.sort_by,st)>
		</cfif>
	</cffunction>
	
	<cffunction name="set_filter" access="public" returntype="void">
		<cfargument name="field" type="string" required="yes">
		<cfargument name="value" type="string" required="yes">
		<cfargument name="operation" type="string" required="no" default="">
		<cfset var st = structNew()>
		<cfset st["name"] = ARGUMENTS.field>
		<cfset st["value"]=ARGUMENTS.value>
		<cfset st["operation"] = ARGUMENTS.operation>
		<cfset ArrayAppend(variables.filters,st)>
	</cffunction>
	<cffunction name="set_fieldset" access="public" returntype="void">
		<cfargument name="value" type="string" required="yes">
		<cfset variables.fieldset = ARGUMENTS.value>
	</cffunction>
	<cffunction name="set_source" access="public" returntype="void">
		<cfargument name="value" type="string" required="yes">
		<cfset variables.source = trim(ARGUMENTS.value)>
		<cfif NOT len(variables.source)>
			<cfthrow errorcode="99" message="Source of data can't be empty">
		</cfif> 
	</cffunction>
	<cffunction name="set_limit" access="public" returntype="void">
		<cfargument name="start" type="numeric" required="yes">
		<cfargument name="count" type="numeric" required="yes">
		<cfset variables.start = ARGUMENTS.start>
		<cfset variables.count = ARGUMENTS.count>
	</cffunction>
	<cffunction name="set_relation" access="public" returntype="void">
		<cfargument name="value" type="string" required="yes">
		<cfset variables.relation = ARGUMENTS.value>
	</cffunction>
	
	<cffunction name="parse_sql" access="public" returntype="void">
		<cfargument name="sql" type="string" required="yes">
		<cfset var data = "">
		<Cfset var table_data = "">
		<cfset var where_data = "">
		
		<cfset ARGUMENTS.sql = rereplaceNoCase(ARGUMENTS.sql,"[ #variables.lineBreak#]+limit[#variables.lineBreak# ,0-9]","","one")>
		<cfset data = split(ARGUMENTS.sql,"[ #variables.lineBreak#]+from",2)>
		<cfset variables.fieldset = rereplaceNoCase(data[1],"select","","one")>
	  	<cfset table_data = split(data[2],"[ #variables.lineBreak#]+where",2)>
		<cfif ArrayLen(table_data) gt 1>
			<!--- //where construction exists --->
			<cfset set_source(table_data[1])>
  			<cfset where_data = split(table_data[2],"[ #variables.lineBreak#]+order[ ]+by",2)>
  			<cfset ArrayAppend(variables.filters,where_data[1])>
  			<cfif ArrayLen(where_data) eq 1>
				<!--- //end of line detected--->
				<cfreturn> 
			</cfif> 
  			<cfset data = where_data[2]>
		<cfelse>
			<cfset table_data = split(table_data[1],"[ #variables.lineBreak#]+order[ ]+by",2)>
  			<cfset set_source(table_data[1])>
  			<cfif ArrayLen(table_data) eq 1>
				<!--- //end of line detected--->
				<cfreturn> 
			</cfif> 
			<cfset data = table_data[2]>
		</cfif>
      	<cfif len(trim(data))>
			<!--- //order by construction exists --->
			<cfset data = split(trim(data),"[ ]+",2)>
			<cfset set_sort(data[1],data[2])>
		</cfif>	
	</cffunction>
	<cffunction name="split" access="public" returntype="array">
		<cfargument name="str" type="string" required="yes">
		<cfargument name="regexp" type="string" required="yes">
		<cfargument name="limit" type="numeric" required="no" default="2">
		<cfset var ar = ArrayNew(1)>
		<cfset var match = "">
		<cfset var s = "">
		<cfset var start = 1>
		<cfloop from="1" to="10000" index="i">
			<cfset match = refindNoCase(ARGUMENTS.regexp,ARGUMENTS.str,start,true)>
			<cfif match.pos[1] AND (ARGUMENTS.limit eq -1 OR ARGUMENTS.limit gt ArrayLen(ar)+1)>
				<cfset s = mid(ARGUMENTS.str,start,match.pos[1]-start)>
				<cfset arrayAppend(ar,s)>
				<cfset start = match.pos[1]+match.len[1]>
			<cfelse>
				<cfset s = right(ARGUMENTS.str,len(ARGUMENTS.str)-start+1)>
				<cfset arrayAppend(ar,s)>
				<cfbreak>	
			</cfif>
		</cfloop>
		<Cfreturn ar>
	</cffunction>
</cfcomponent>
