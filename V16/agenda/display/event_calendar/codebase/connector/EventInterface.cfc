<cfcomponent namespace="EventInterface">
	<cfscript>
		variables._request = ""; ////!< DataRequestConfig instance
		this.rules = ArrayNew(1); //!< array of sorting rules
	</cfscript>
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="_request" type="any" required="yes">
		<cfset variables._request = ARGUMENTS._request>
		<cfreturn this>
	</cffunction>
	<cffunction name="clear" access="public" returntype="void">
		<cfset ArrayClear(this.Rules)>
	</cffunction>
	<cffunction name="index" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfreturn array_search(this.Rules,ARGUMENTS.name)>
	</cffunction>
	<cffunction name="array_search" access="public" returntype="numeric">
		<cfargument name="ar" type="array" required="yes">
		<cfargument name="value" type="string" required="yes">
		<Cfset var i = 0>
		<cfloop from="1" to="#ArratyLen(ARGUMENTS.ar)#" index="i">
			<cfif ARGUMENTS.ar[i] eq  ARGUMENTS.value>
				<cfreturn i>
			</cfif>
		</cfloop>
		<cfreturn 0>
	</cffunction>
</cfcomponent>

	
