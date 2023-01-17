<!---  ----------------------------------------------------------------------------
	Inner classes, which do common tasks. No one of them is purposed for direct usage. 
 ----------------------------------------------------------------------------  --->
<cfcomponent namespace="EventMaster" hint="Class which allows to assign|fire events.">
	<!--- hash of event handlers --->
	<cfscript>
		variables.Events = structNew();
	</cfscript>	
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="exist" access="public" returntype="boolean" hint="Method check if event with such name already exists. Return: true if event with such name registered, false otherwise">
		<cfargument name="name" type="string" required="yes" hint="name of event, case non-sensitive">
		<cfif structKeyExists(variables.Events,ARGUMENTS.name) AND ArrayLen(variables.Events[ARGUMENTS.name])>
			<cfreturn true>
		<cfelse>
			<Cfreturn false>	
		</cfif>
	</cffunction>
	
	<cffunction name="attach" access="public" returntype="void" hint="Attach custom code to event. Only on event handler can be attached in the same time. If new event handler attached - old will be detached.">
		<cfargument name="name" type="string" required="yes" hint="name of event, case non-sensitive">
		<cfargument name="method" type="any" required="yes" hint="function which will be attached. You can use array(class, method) if you want to attach the method of the class.">
		<cfif NOT structKeyExists(variables.Events,ARGUMENTS.name)>
			<cfset variables.Events[ARGUMENTS.name] = ArrayNew(1)>
		</cfif>
		<cfset ArrayAppend(variables.Events[ARGUMENTS.name],ARGUMENTS.method)>
	</cffunction>
	
	<cffunction name="detach" access="public" returntype="void" hint="Detach code from event">
		<cfargument name="name" type="string" required="yes" hint="name of event, case non-sensitive">
		<cfif structKeyExists(variables.Events,ARGUMENTS.name)>
			<cfset structDelete(variables.Events,ARGUMENTS.name)>
		</cfif>	
	</cffunction>

	<!--- value which will be provided as argument for event function, you can provide multiple data arguments, method accepts variable number of parameters--->
	<cffunction name="trigger" access="public" returntype="boolean" hint="Trigger event. Return: true if event handler was not assigned , result of event hangler otherwise">
		<cfargument name="name" type="string" required="yes" hint="name of event, case non-sensitive">
		<cfset var args = "">
		
		<cfif structKeyExists(variables.Events,ARGUMENTS.name)>
			<cfset args = "">
			<cfloop collection="#arguments#" item="arg">
				<cfif arg neq "name" AND isNumeric(arg)>
					<cfset args = ListAppend(args,"ARGUMENTS[#arg#]")>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#ArrayLen(Events[ARGUMENTS.name])#"  index="i">
				<cfset method = Events[ARGUMENTS.name][i]>
				
				<cfif isArray(method) AND NOT IsCustomFunction(evaluate('method[1].#method[2]#'))>
					<cfthrow message="Incorrect method assigned to event: #method[2]#" errorcode="99">
				</cfif>
				<cfif NOT isArray(method) AND NOT IsCustomFunction(method)>
					<cfthrow message="Incorrect function assigned to event: #method#" errorcode="99">
				</cfif>
				<cfif isArray(method)>
					<cfset evaluate("method[1].#method[2]#(#args#)")>
				<cfelse>
					<cfset evaluate("method(#args#)")>
				</cfif>		
			</cfloop>
		</cfif>	
		
		<cfreturn true>
	</cffunction>
</cfcomponent>
