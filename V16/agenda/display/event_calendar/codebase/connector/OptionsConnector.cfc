<cfcomponent namespace="OptionsConnector" extends="Connector" hint="wrapper around options collection, used for comboboxes and filters">
	<cfscript>
		variables.init_flag=false;	//!< used to prevent rendering while initialization
	</cfscript>
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="res" type="any" required="yes">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="item_type" type="string" required="no" default="">
		<cfargument name="data_type" type="string" required="no" default="">
		<cfif NOT Len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type="DataItem">
		</cfif>	
		<cfif NOT Len(ARGUMENTS.data_type)>
			<!--- has not sense, options not editable--->
			<cfset ARGUMENTS.data_type="">
		</cfif>	
		<cfset super.init(ARGUMENTS.res,ARGUMENTS.type,ARGUMENTS.item_type,ARGUMENTS.data_type)>
		<cfreturn this>
	</cffunction>

	<cffunction name="render" access="public" returntype="any" hint="render self, process commands, return data as XML, not output data to stdout, ignore parameters in incoming request. Return: data as XML string">
		<cfset var res = "">
		<cfif variables.init_flag>
			<cfset variables.init_flag=true>
			<cfreturn "">
		</cfif>
		<cfset res = this.sql.do_select(variables._request)>
		<cfreturn render_set(res)>
	</cffunction>
</cfcomponent>


