<cfcomponent namespace="ComboConnector" extends="Connector">
	<cfscript>
		variables.filter = "";
		variables.position = "";
	</cfscript>
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="res" type="string" required="yes">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="item_type" type="string" required="no" default="">
		<cfargument name="data_type" type="string" required="no" default="">
		<cfset var ar = "">
		<cfif not len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type="ComboDataItem">	
		</cfif>
		<cfset super.init(ARGUMENTS.res,ARGUMENTS.type,ARGUMENTS.item_type,ARGUMENTS.data_type)>
		<cfreturn this>
	</cffunction>

	<cffunction name="parse_request" access="public" returntype="any" hint="parse GET scoope, all operations with incoming request must be done here">
		<cfset super.parse_request()>
		<cfif isDefined("URL.pos")>
			<!--- //not critical, so just write a log message --->
			<cfif NOT variables.dload>	
				<cfset request.dhtmlXLogMaster.do_log("Dyn loading request received, but server side was not configured to process dyn. loading. ")>
			<cfelse>
				<cfset variables._request.set_limit(URL.pos,variables.dload)>
			</cfif>	
		</cfif>
		<cfif isDefined("URL.mask")>
			<cfset variables._request.set_filter(variables.config.text[1]["name"],URL.mask & "%","LIKE")>
		</cfif>
		<cfset request.dhtmlXLogMaster.do_log(variables._request)>
	</cffunction>
	
	<cffunction name="xml_start" access="public" returntype="string">
		<cfif variables._request.get_start()>
			<cfreturn "<complete add='true'>">
		<cfelse>
			<cfreturn "<complete>">
		</cfif>		
	</cffunction>
	<cffunction name="xml_end" access="public" returntype="string">
		<cfreturn "</complete>">
	</cffunction>
</cfcomponent>
	
