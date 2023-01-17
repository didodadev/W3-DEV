<cfcomponent namespace="SchedulerConnector" extends="Connector" hint="Connector class for Scheduler component">
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="res" type="string" required="yes">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="item_type" type="string" required="no" default="">
		<cfargument name="data_type" type="string" required="no" default="">
		<cfif not len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type="SchedulerDataItem">	
		</cfif>
		<cfif not len(ARGUMENTS.data_type)>
			<cfset ARGUMENTS.data_type="SchedulerDataProcessor">
		</cfif>
		<cfset super.init(ARGUMENTS.res,ARGUMENTS.type,ARGUMENTS.item_type,ARGUMENTS.data_type)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parse_request" access="public" returntype="any" hint="parse GET scoope, all operations with incoming request must be done here">
		<cfset super.parse_request()>
		<cfif isDefined("URL.to")>
			<cfset variables._request.set_filter(variables.config.text[1]["name"],URL.to,"<")>
		</cfif>	
		<cfif isDefined("URL.from")>
			<cfset variables._request.set_filter(variables.config.text[2]["name"],URL.from,"<")>
		</cfif>	
	</cffunction>
</cfcomponent>
