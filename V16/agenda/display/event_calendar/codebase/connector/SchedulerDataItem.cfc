<cfcomponent namespace="SchedulerDataItem" extends="DataItem">
	<cffunction name="init" access="public" returntype="any" hint="constructor">
		<cfargument name="data" type="any" required="yes" hint="Data object">
		<cfargument name="config" type="any" required="yes" hint="Config object">
		<cfargument name="index" type="numeric" required="no" default="0" hint="Index of an element">
		<cfset super.init(ARGUMENTS.data,ARGUMENTS.config,ARGUMENTS.index)>
		<cfreturn this>
	</cffunction>

	<cffunction name="to_xml" access="public" returntype="string">
		<cfset var str = "">
		<cfset var extra = "">
		<cfset var i = 0>
		<cfif variables.skip>
			<cfreturn "">
		</cfif>	
		
		<cfset str="<event id='" & get_id() & "' >">
		<cfset str = str & "<start_date><![CDATA[" & variables.data[variables.config.text[1]["name"]] & "]]></start_date>">
		<cfset str = str & "<end_date><![CDATA[" & variables.data[variables.config.text[2]["name"]] & "]]></end_date>">
		<cfset str = str & "<text><![CDATA[" & variables.data[variables.config.text[3]["name"]] & "]]></text>">
		<cfloop from="3" to="#ArrayLen(variables.config.text)#" index="i">
			<cfset extra = variables.config.text[i]["name"]>
			<cfset str = str & "<" & extra & "><![CDATA[" & variables.data[extra] & "]]></" & extra & ">">
		</cfloop>
		<cfreturn str & "</event>">
	</cffunction>
</cfcomponent>
	
