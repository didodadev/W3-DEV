<cfcomponent namespace="TreeDataItem" extends="DataItem">
	<cfscript>
		variables.im0="";			//!< image of closed folder
		variables.im1="";			//!< image of opened folder
		variables.im2="";			//!< image of leaf item
		variables.check=0;		//!< checked state
		variables.kids=-1;		//!< checked state
	</cfscript>
	
	<cffunction name="init" access="public" returntype="any" hint="constructor">
		<cfargument name="data" type="any" required="yes" hint="Data object">
		<cfargument name="config" type="any" required="yes" hint="Config Object">
		<cfargument name="index" type="numeric" required="yes" hint="Index of an element">	
		<cfset super.init(ARGUMENTS.data,ARGUMENTS.config,ARGUMENTS.index)>
		<cfset variables.im0="">
		<cfset variables.im1="">
		<cfset variables.im2="">
		<cfset variables.check=0>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_parent_id" access="public" returntype="string" hint="get id of parent record. Return: id of parent record ">
		<cfreturn variables.data[variables.config.relation_id["name"]]>
	</cffunction>

	<cffunction name="get_check_state" access="public" returntype="boolean" hint="get state of items checkbox. Return: state of item's checkbox as int value, false if state was not defined">
		<cfreturn variables.check>
	</cffunction>

	<cffunction name="set_check_state" access="public" returntype="void" hint="set state of item's checkbox">
		<cfargument name="value" type="numeric" required="yes" hint="int value, 1 - checked, 0 - unchecked, -1 - third state">
		<cfset variables.check=ARGUMENTS.value>
	</cffunction>
	
	<cffunction name="has_kids" access="public" returntype="boolean">
		<cfreturn variables.kids>
	</cffunction>
	<cffunction name="set_kids" access="public" returntype="void">
		<cfargument name="value" type="numeric" required="yes">
		<cfset variables.kids=ARGUMENTS.value>
	</cffunction>

	<cffunction name="set_image" access="public" returntype="void" hint="assign image for tree's item">
		<cfargument name="img_folder_closed" type="string" required="yes" hint="image for item, which represents folder in closed state">
		<cfargument name="img_folder_open" type="string" required="no" default="" hint="image for item, which represents folder in opened state, optional">
		<cfargument name="img_leaf" type="string" required="no" default="" hint="image for item, which represents leaf item, optional">
		<cfset variables.im0 = ARGUMENTS.img_folder_closed>
		<cfset variables.im1 = iif(Len(ARGUMENTs.img_folder_open),"#DE(ARGUMENTs.img_folder_open)#","#DE(ARGUMENTS.img_folder_closed)#")>
		<cfset variables.im2 = iif(Len(ARGUMENTs.img_leaf),"#DE(ARGUMENTs.img_leaf)#","#DE(ARGUMENTS.img_folder_closed)#")>
	</cffunction>
	
	<cffunction name="to_xml_start" access="public" returntype="string" hint="return self as XML string without ending tag">
		<cfset var str1 = "">
		<cfif variables.skip>
			<cfreturn "">
		</cfif>
		<cfset str1 = "<item id='" & get_id() & "' text='" & variables.data[variables.config.text[1]["name"]] & "' ">
		<cfif has_kids()>
			<cfset str1 = str1 & "child='" & has_kids() & "' ">
		</cfif>
		<cfif Len(variables.im0)>
			<cfset str1 = str1 & "im0='" & variables.im0 & "' ">
		</cfif>
		<cfif Len(variables.im1)>
			<cfset str1 = str1 & "im1='" & variables.im1 & "' ">
		</cfif>
		<cfif Len(variables.im2)>
			<cfset str1 = str1 & "im2='" & variables.im2 & "' ">
		</cfif>
		<cfif variables.check>
			<cfset str1 = str1 & "checked='" & variables.check & "' ">
		</cfif>
		<cfset str1 = str1 & ">">
		<cfreturn str1>
	</cffunction>
	
	<cffunction name="to_xml_end" access="public" returntype="string">
		<cfreturn "</item>">
	</cffunction>
</cfcomponent>

