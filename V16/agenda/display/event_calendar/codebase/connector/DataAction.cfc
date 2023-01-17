<cfcomponent namespace="DataAction" hint="contain all info related to action and controls customizaton">
	<cfscript>
		variables.status=""; //!< cuurent status of record
		variables.id="";//!< id of record
		variables.data=structNew();//!< data hash of record
		variables.userdata="";//!< hash of extra data , attached to record
		variables.nid="";//!< new id value , after operation executed
		variables.output="";//!< custom output to client side code
		variables.attrs="";//!< hash of custtom attributes
		variables.ready="";//!< flag of operation's execution
		variables.addf="";//!< array of added fields
		variables.delf="";//!< array of deleted fields
	</cfscript>
	 
	<cffunction name="init" access="public" returntype="any" hint="constructor">
		<cfargument name="status" type="string" required="yes" hint="current operation status">
		<cfargument name="id" type="string" required="yes" hint="record id">
		<cfargument name="data" type="struct" required="yes" hint="hash of data">
		<cfset variables.status=ARGUMENTS.status>
		<cfset variables.id=ARGUMENTs.id>
		<cfset variables.data=ARGUMENTS.data>
		<cfset variables.nid=ARGUMENTS.id>
		<cfset variables.output="">
		<cfset variables.attrs=structNew()>
		<cfset variables.ready=false>
		<cfset variables.addf=ArrayNew(1)>
		<cfset variables.delf=ArrayNew(1)>
		<cfreturn this>
	</cffunction>
	<cffunction name="dump" access="public" returntype="any" hint="dump. Debug function to get object private properties.">
		<cfset var tmp = "">
		<cfsavecontent variable="tmp">
			<Cfdump var="#variables#">
		</cfsavecontent>
		<cfreturn tmp>
	</cffunction>
	<cffunction name="add_field" access="public" returntype="void" hint="add custom field and value to DB operation">
		<cfargument name="name" type="string" required="yes" hint="name of field which will be added to DB operation">
		<cfargument name="value" type="string" required="yes" hint="value which will be used for related field in DB operation">
		<cfset request.dhtmlXLogMaster.do_log("adding field: " & ARGUMENTS.name & ", with value: " & ARGUMENTS.value)>
		<cfset variables.data[ARGUMENTS.name]=ARGUMENTS.value>
		<cfset ArrayAppend(variables.addf,ARGUMENTS.name)>
	</cffunction>
	
	<cffunction name="remove_field" access="public" returntype="void" hint="remove field from DB operation">
		<cfargument name="name" type="string" required="yes" hint="name of field which will be removed from DB operation">
		<cfset request.dhtmlXLogMaster.do_log("removing field: " & ARGUMENTS.name)>
		<cfset ArrayAppend(variables.delf,ARGUMENTs.name)>
	</cffunction>	
	<!--- ----------------------------------------------------------------------------
		@todo 
			check , if all fields removed then cancel action
	---------------------------------------------------------------------------- ---> 
	<cffunction name="sync_config" access="public" returntype="void" hint="sync field configuration with external object">
		<cfargument name="slave" type="any" required="yes" hint="SQLMaster object">
		<Cfset var i = 0>
		<cfloop from="1" to="#ArrayLen(variables.addf)#" index="i">
			<cfset ARGUMENTS.slave.add_field(variables.addf[i])>
		</cfloop>
		<cfloop from="1" to="#ArrayLen(variables.delf)#" index="i">
			<cfset ARGUMENTS.slave.remove_field(variables.delf[i])>
		</cfloop>
	</cffunction>
	
	<cffunction name="get_value" access="public" returntype="string" hint="get value of some record's propery. Return: value of related property">
		<cfargument name="name" type="string" required="yes" hint="name of record's property ( name of db field or alias )">
		<cfif NOT structKeyExists(variables.data,ARGUMENTs.name)>
			<cfset request.dhtmlXLogMaster.do_log("Incorrect field name used: " & ARGUMENTS.name)>
			<cfset request.dhtmlXLogMaster.do_log("data",variables.data)>
			<cfreturn "">
		</cfif>
		<cfreturn variables.data[ARGUMENTS.name]>
	</cffunction>	
	
	<cffunction name="set_value" access="public" returntype="void" hint="set value of some record's propery">
		<cfargument name="name" type="string" required="yes" hint="name of record's property ( name of db field or alias )">
		<cfargument name="value" type="string" required="yes" hint="value of related property">
		<cfset request.dhtmlXLogMaster.do_log("change value of: " & ARGUMENTS.name & " as: " & ARGUMENTS.value)>
		<cfset variables.data[ARGUMENTs.name]=ARGUMENTs.value>
	</cffunction>
	
	<cffunction name="get_data" access="public" returntype="struct" hint="get hash of data properties. Return: hash of data properties">
		<cfreturn variables.data>	
	</cffunction>
	
	<cffunction name="get_userdata_value" access="public" returntype="string" hint="get some extra info attached to record, deprecated, exists just for backward compatibility, you can use set_value instead of it. Return: value of related userdata property">
		<cfargument name="name" type="string" required="yes" hint="name of userdata property">
		<cfreturn get_value(ARGUMENTS.name)>
	</cffunction>
	
	<cffunction name="set_userdata_value" access="public" returntype="void" hint="set some extra info attached to record, deprecated, exists just for backward compatibility, you can use get_value instead of it">
		<cfargument name="name" type="string" required="yes" hint="name of userdata property">
		<cfargument name="value" type="string" required="yes" hint="value of userdata property">
		<cfset set_value(ARGUMENTS.name,ARGUMENTS.value)>
	</cffunction>

	<cffunction name="get_status" access="public" returntype="string" hint="get current status of record. Return: string with status value">
		<cfreturn variables.status>
	</cffunction>
	
	<cffunction name="set_status" access="public" returntype="void" hint="assign new status to the record">
		<cfargument name="status" type="string" required="yes" hint="new status value">
		<cfset variables.status = ARGUMENTS.status>
	</cffunction>
	
	<cffunction name="get_id" access="public" returntype="string" hint="get id of current record. Return: id of record">
		<cfreturn variables.id>
	</cffunction>

	<cffunction name="set_response_text" access="public" returntype="void" hint="sets custom response text, can be accessed through defineAction on client side. Text wrapped in CDATA, so no extra escaping necessary">
		<cfargument name="text" type="string" required="yes" hint="custom response text">
		<cfset set_response_xml("<![CDATA[" & ARGUMENTS.text & "]]>")>
	</cffunction>

	<cffunction name="set_response_xml" access="public" returntype="void" hint="sets custom response xml, can be accessed through defineAction on client side">
		<cfargument name="text" type="string" required="yes" hint="string with XML data">
		<cfset variables.output=ARGUMENTS.text>
	</cffunction>

	<cffunction name="set_response_attribute" access="public" returntype="void" hint="sets custom response attributes, can be accessed through defineAction on client side">
		<cfargument name="name" type="string" required="yes" hint="name of custom attribute">
		<cfargument name="value" type="string" required="yes" hint="value of custom attribute">
		<cfset attrs[ARGUMENTS.name]=ARGUMENTS.value>	
	</cffunction>

	<cffunction name="is_ready" access="public" returntype="boolean" hint="check if action finished. Return: true if action finished, false otherwise">
		<cfreturn variables.ready>
	</cffunction>	
	
	<cffunction name="get_new_id" access="public" returntype="string" hint="return new id value, equal to original ID normally, after insert operation - value assigned for new DB record. Return: new id value">
		<cfreturn variables.nid>
	</cffunction>

	<cffunction name="error" access="public" returntype="void" hint="set result of operation as error">
		<cfset variables.status="error">
		<cfset variables.ready=true>
	</cffunction>
	
	<cffunction name="invalid" access="public" returntype="void" hint="set result of operation as invalid">
		<cfset variables.status="invalid">
		<cfset variables.ready=true>
	</cffunction>

	<cffunction name="success" access="public" returntype="void" hint="confirm successful opeation execution">
		<cfargument name="id" type="string" required="no" default="" hint="new id value, optional">
		<cfif len(ARGUMENTS.id)>
			<cfset variables.nid = ARGUMENTS.id>
		</cfif>	
		<cfset variables.ready=true>
	</cffunction>

	<cffunction name="to_xml" access="public" returntype="string" hint="convert DataAction to xml format compatible with client side dataProcessor. Return: DataAction operation report as XML string">
		<cfset var str = "">
		<cfset var k = "">
		<cfset var v = "">
		<cfset str="<action type='#variables.status#' sid='#variables.id#' tid='#variables.nid#' ">
		<cfloop collection="#variables.attrs#" item="k">
			<cfset v = variables.attrs[k]>
			<cfset str = str & k & "='" & v & "' ">
		</cfloop>
		<cfset str = str & ">#variables.output#</action>">
		<cfreturn str>
	</cffunction>

	<cffunction name="__toString" access="public" returntype="string" hint="convert self to string ( for logs ). Return: DataAction operation report as plain string">
		<cfreturn "action:#variables.status#; sid:#variables.id#; tid:#variables.nid#;">	
	</cffunction>
</cfcomponent>
	
