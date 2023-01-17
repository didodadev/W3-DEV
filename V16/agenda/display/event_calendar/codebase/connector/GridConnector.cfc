<cfcomponent namespace="GridConnector" extends="Connector">
	<cfscript>
		variables.extra_output="";//!< extra info which need to be sent to client side
		variables.options=structNew();//!< hash of OptionsConnector 
	</cfscript>
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="res" type="string" required="yes">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="item_type" type="string" required="no" default="">
		<cfargument name="data_type" type="string" required="no" default="">
		
		<cfif not len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type="GridDataItem">	
		</cfif>
		<cfif not len(ARGUMENTS.data_type)>
			<cfset ARGUMENTS.data_type="GridDataProcessor">
		</cfif>
		<cfset super.init(ARGUMENTS.res,ARGUMENTS.type,ARGUMENTS.item_type,ARGUMENTS.data_type)>
		<cfreturn this>
	</cffunction>
	<cffunction name="parse_request" access="public" returntype="void">
		<cfset super.parse_request()>
		<cfif isDefined("URL.dhx_colls")>
			<cfset fill_collections(URL.dhx_colls)>
		</cfif>
		<cfif isDefined("URL.posStart") AND isDefined("URL.count")>
			<cfset variables._request.set_limit(URL.posStart,URL.count)>
		</cfif>	
	</cffunction>
	<cffunction name="resolve_parameter" access="public" returntype="any">
		<cfargument name="name" type="numeric" required="yes">
		<cfif int(ARGUMENTS.name) eq  ARGUMENTS.name>
			<cfreturn variables.config.text[int(ARGUMENTS.name)]["db_name"]>
		</cfif>
		<cfreturn ARGUMENTS.name>
	</cffunction>	
	<cffunction name="set_options" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="options" type="any" required="yes">
		<cfset var str = "">
		<cfset var k = "">
		<cfset var v = "">
		<cfif isArray(ARGUMENTS.options)>
			<cfset str="">
			<cfloop from="1" to="#ArrayLen(ARGUMENTS.options)#" index="k">
				<cfset v = ARGUMENTS.options[k]>
				<cfset str = str & "<item value='" & k & "' label='" & v & "' />">
			</cfloop>
			<cfset ARGUMENTS.options=str>
		</cfif>
		<cfif isStruct(ARGUMENTS.options) AND not isObject(ARGUMENTS.options)>
			<cfset str="">
			<cfloop collection="#ARGUMENTS.options#" item="k">
				<cfset v = ARGUMENTS.options[k]>
				<cfset str = str & "<item value='" & k & "' label='" & v & "' />">
			</cfloop>
			<cfset ARGUMENTS.options=str>
		</cfif>
		<cfset variables.options[ARGUMENTS.name]=ARGUMENTS.options>
	</cffunction>	
	
	<cffunction name="fill_collections" access="public" returntype="void" hint="generates xml description for options collections">
		<cfargument name="list" type="string" required="yes" hint="comma separated list of column names, for which options need to be generated">
		<cfset var name = "">
		<cfset var nameI = "">
		<cfset var names = "">
		<cfset var i = 0>
		<cfset var c = "">
		<cfset var r = "">

		<cfif not isDefined("this.DistinctOptionsConnectorO")>
			<cfset this.DistinctOptionsConnectorO = CreateObject("component","DistinctOptionsConnector")>
		</cfif>	
		<cfif not isDefined("this.DataConfigO")>
			<cfset this.DataConfigO = createObject("component","DataConfig")>	
		</cfif>
		<cfif not isDefined("this.DataRequestConfigO")>
			<cfset this.DataRequestConfigO = createObject("component","DataRequestConfig")>	
		</cfif>
		
		<cfset names=ListToArray(ARGUMENTS.list,",")>
		<cfloop from="1" to="#ArrayLen(names)#" index="i">
			<cfset name = resolve_parameter(names[i]+1)>
			<cfif NOT structKeyExists(variables.options,name)>
				<cfset variables.options[name] = this.DistinctOptionsConnectorO.init(get_connection(),variables.names["db_class"])>
				<cfset c = this.DataConfigO.init(variables.config)>
				<cfset r = this.DataRequestConfigO.init(variables._request)>
				<cfset c.minimize(name)>
				<cfset variables.options[name].render_connector(c,r)>
			</cfif> 
			<cfset nameI = names[i]>
			<cfset variables.extra_output = variables.extra_output & "<coll_options for='#nameI#'>">
			<cfif isObject(variables.options[name]) OR isStruct(variables.options[name]) OR isArray(variables.options[name])>
				<cfset variables.extra_output=variables.extra_output & variables.options[name].render()>
			<cfelse>
				<cfset variables.extra_output = variables.extra_output & variables.options[name]>
			</cfif>	
			<cfset variables.extra_output = variables.extra_output & "</coll_options>">
		</cfloop>
	</cffunction>	
	
	<cffunction name="xml_start" access="public" returntype="string">
		<cfset var pos = "">
		<cfif variables.dload>
			<cfset pos = variables._request.get_start()> 
			<cfif pos>
				<cfreturn "<rows pos='" & pos & "'>">
			<cfelse>
				<cfreturn "<rows total_count='" & this.sql.get_size(variables._request) & "'>">
			</cfif>	
		<cfelse>
			<cfreturn "<rows>">
		</cfif>	
	</cffunction>
	<cffunction name="xml_end" access="public" returntype="string">
		<cfreturn variables.extra_output & "</rows>">
	</cffunction>
</cfcomponent>

