<!---  ----------------------------------------------------------------------------
	Inner classes, which do common tasks. No one of them is purposed for direct usage. 
 ----------------------------------------------------------------------------  --->
<cfcomponent namespace="AccessMaster" hint="Class which handles access rules.">
	<cfset variables.Rules = structNew()>
	<cfset variables.Local = True>
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor">
		<cfset variables.Rules["read"] = true>
		<cfset variables.Rules["do_insert"] = true>
		<cfset variables.Rules["do_update"] = true>
		<cfset variables.Rules["do_delete"] = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="allow" access="public" returntype="void" hint="change access rule to 'allow'">
		<cfargument name="name" type="string" required="yes" hint="name of access right">
		<cfset variables.Rules[ARGUMENTS.name]=true>
	</cffunction>
	<cffunction name="deny" access="public" returntype="void" hint="change access rule to 'deny'">
		<cfargument name="name" type="string" required="yes" hint="name of access right">
		<cfset variables.Rules[ARGUMENTS.name]=false>
	</cffunction>
	<cffunction name="deny_all" access="public" returntype="void" hint="change all access rules to 'deny'">
		<cfset variables.Rules=structNew()>
	</cffunction>
	
	<cffunction name="check" access="public" returntype="boolean" hint="check access rule. Return: true if access rule allowed, false otherwise">
		<cfargument name="name" type="string" required="yes" hint="name of access right">
		<cfif variables.Local>
			<!---
				todo
				add referrer check, to prevent access from remote points
			--->	
		</cfif>
		<cfif NOT structKeyExists(variables.Rules,ARGUMENTS.name) OR NOT variables.Rules[ARGUMENTS.name]>
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>
</cfcomponent>

