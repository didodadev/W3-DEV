<cfcomponent namespace="DataItem" hint="base class for component item representation">
	<cfscript>
		variables.data = structNew(); //!< hash of data
		variables.config = ""; 		//!< DataConfig instance
		variables.index = 0;			//!< index of element
		variables.skip = false;		//!< flag , which set if element need to be skiped during rendering
	</cfscript>
	
	<cffunction name="init" access="public" returntype="any" hint="constructor">
		<cfargument name="data" type="any" required="yes" hint="Data Object">
		<cfargument name="config" type="any" required="yes" hint="Config Object">
		<cfargument name="index" type="numeric" required="yes" hint="index of element">
			<cfset variables.config=ARGUMENTS.config>
			<cfset variables.data=ARGUMENTS.data>
			<cfset variables.index=ARGUMENTS.index>
			<cfset variables.skip=false>
			<cfreturn this>
	</cffunction>

	<cffunction name="get_value" access="public" returntype="string" hint="get named value. Return: value from field with provided name or alias">
		<cfargument name="name" type="string" required="yes" hint="name or alias of field">
		<cfreturn variables.data[ARGUMENTS.name]>
	</cffunction>

	<cffunction name="set_value" access="public" returntype="string" hint="set named value">
		<cfargument name="name" type="string" required="yes" hint="name or alias of field">
		<cfargument name="value" type="string" required="yes" hint="value for field with provided name or alias">
		<cfset variables.data[ARGUMENTS.name] = ARGUMENTS.value>
		<cfreturn variables.data[ARGUMENTS.name]>
	</cffunction>

	<cffunction name="get_id" access="public" returntype="any" hint="get id of element. Return: id of element">
		<cfset var id = variables.config["id"]["name"]>
		<cfif structKeyExists(variables.data,id)>
			<cfreturn variables.data[id]>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="set_id" access="public" returntype="void" hint="change id of element">
		<cfargument name="value" type="string" required="yes" hint="new id value">
		<cfset var id = variables.config["id"]["name"]>
		<cfset variables.data[id] = ARGUMENTS.value>
	</cffunction>

	<cffunction name="get_index" access="public" returntype="numeric" hint="get index of element. Return: index of element">
		<cfreturn variables.index>
	</cffunction>

	<cffunction name="skip" access="public" returntype="void" hint="mark element for skiping ( such element will not be rendered )">
		<cfset variables.skip = true>
	</cffunction>

	<cffunction name="to_xml" access="public" returntype="string" hint="return self as XML string">
		<cfset var xml = to_xml_start() & to_xml_end()>
		<cfreturn xml>
	</cffunction>

	<cffunction name="to_xml_start" access="public" returntype="string" hint="return end tag for self as XML string ">
		<cfset var str = "<item">
		<cfset var i = 0>
		<cfset var name = 0>
		<cfloop from="1" to="#ArrayLen(variables.config.data)#" index="i">
			<cfset name=variables.config.data[i]["name"]>
			<cfset str = str & " " & name & "='" & variables.data[name] & "'">
		</cfloop>
		<cfreturn str & ">">
	</cffunction>

	<cffunction name="to_xml_end" access="public" returntype="string" hint="return self as XML string">
		<cfreturn "</item>">
	</cffunction>
</cfcomponent>

