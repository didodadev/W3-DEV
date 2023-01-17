<cfcomponent namespace="Connector">
	<cfscript>
		variables.lineBreak = "#chr(13)##chr(10)#";
		// Private
		variables.config="";				 	//DataConfig instance
		variables._request="";				//DataRequestConfig instance
		variables.names = structNew();	//!< has of names for used classes
		variables.encoding = "utf-8";		//!< assigned encoding (UTF-8 by default) 
		variables.editing = false;		//!< flag of edit mode ( response for dataprocessor )
		variables.db="";		 				//!< db connection resource
		variables.dload = false;			//!< flag of dyn. loading mode
		variables.id_seed=0;
		variables.fieldTypes = structNew(); // field types: number,text. Format: [fieldName]:[fieldType]
		
		// Public
		this.access = "";		//!< AccessMaster instance
		this.sql = "";			//DataWrapper instance
		this.event = "";		//EventMaster instance
	</cfscript>

	<cffunction name="init" access="public" returntype="any" hint="constructor. Here initilization of all Masters occurs, execution timer initialized">
		<cfargument name="db" type="string" required="yes" hint="db connection resource">
		<cfargument name="type" type="string" required="no" default="" hint="string , which hold type of database ( MySQL or Postgre ), optional, instead of short DB name, full name of DataWrapper-based class can be provided">
		<cfargument name="item_type" type="string" required="no" default="" hint="name of class, which will be used for item rendering, optional, DataItem will be used by default">
		<cfargument name="data_type" type="string" required="no" default="" hint="name of class which will be used for dataprocessor calls handling, optional, DataProcessor class will be used by default. ">
		<cfset var filePath = "">
		
		<cfset this.exec_time=getTickCount()>
		<cfset request.dhtmlXLogMaster = CreateObject("component","LogMaster").init()>
		<cfif NOT Len(ARGUMENTS.type)>
			<cfset ARGUMENTS.type="MySQL">
		</cfif>
		<cfif not Len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type  = "DataItem">
		</cfif>
		<cfif not Len(ARGUMENTS.data_type)>
			<cfset ARGUMENTS.data_type  = "DataProcessor">
		</cfif>
		
		<cfset variables.names.db_class = "DB_"&ARGUMENTS.type>
		<cfset variables.names.item_class = ARGUMENTS.item_type>
		<cfset variables.names.data_class = ARGUMENTS.data_type>
		<cfset variables.config = CreateObject("component","DataConfig").init()>
		<cfset variables._request = CreateObject("component","DataRequestConfig").init()>
		<cfset this.event = CreateObject("component","EventMaster").init()>
		<cfset this.access = CreateObject("component","AccessMaster").init()>
		
		<cfset filePath = getDirectoryFromPAth(getCurrentTemplatePath()) & variables.names["db_class"] & ".cfc">
		<cfif NOT fileExists(filePath)>
			<cfthrow errorcode="99" message="DB class not found: #names['db_class']#">
		</cfif>
		<cfset this.sql = CreateObject("component",variables.names["db_class"]).init(ARGUMENTS.db,variables.config)>
		<cfset this.sql.setFieldTypes(variables.fieldTypes)>

		<!--- saved for options connectors, if any--->
		<cfset variables.db=ARGUMENTS.db>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_connection" access="public" returntype="string" hint="return db connection resource. nested class may neeed to access live connection object. Return: DB connection resource">
		<cfreturn variables.db>
	</cffunction>
	<cffunction name="field_types" access="public" returntype="void" hint="Sets the types to the used fields. Necessary if there is difference in usage of value with '' or without them. ">
		<cfargument name="data" type="string" required="no" default="">
		<cfset var local = structNew()>
		<cfif len(ARGUMENTs.data)>
			<cfloop list="#ARGUMENTS.data#" index="local.i">
				<cfif ListLen(local.i,":") eq 2>
					<cfset variables.fieldTypes[ListFirst(local.i,":")]  = ListLast(local.i,":")>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="render_table" access="public" returntype="string" hint="config connector based on table">
		<cfargument name="table" type="string" required="yes" hint="name of table in DB">
		<cfargument name="id" type="string" required="yes" hint="name of id field">
		<cfargument name="fields" type="string" required="yes" hint="list of fields names">
		<cfargument name="extra" type="string" required="no" default="" hint="list of extra fields, optional, such fields will not be included in data rendering, but will be accessible in all inner events">
		<cfargument name="relation_id" type="string" required="no" default="" hint="name of field used to define relations for hierarchical data organization, optional">

		<cfset variables.config.init().init2(ARGUMENTS.id,ARGUMENTS.fields,ARGUMENTS.extra,ARGUMENTS.relation_id)>
		<cfset variables._request.set_source(ARGUMENTS.table)>
		<cfreturn render()>
	</cffunction>
	<cffunction name="uuid" access="public" returntype="string">
		<cfset variables.id_seed = variables.id_seed+1>
		<cfreturn getTickCount() & "_" & (variables.id_seed-1)>
	</cffunction>

	<cffunction name="render_sql" access="public" returntype="string" hint="config connector based on table">
		<cfargument name="sql" type="string" required="yes" hint="sql query used as base of configuration">
		<cfargument name="id" type="string" required="yes" hint="name of id field">
		<cfargument name="fields" type="string" required="yes" hint="list of fields names">
		<cfargument name="extra" type="string" required="no" default="" hint="list of extra fields, optional, such fields will not be included in data rendering, but will be accessible in all inner events">
		<cfargument name="relation_id" type="string" required="no" default="" hint="name of field used to define relations for hierarchical data organization, optional">

		<cfset variables.config.init().init2(ARGUMENTS.id,ARGUMENTS.fields,ARGUMENTS.extra,ARGUMENTS.relation_id)>
		<cfset variables._request.parse_sql(ARGUMENTS.sql)>
		<cfreturn render()>
	</cffunction>
	
	<cffunction name="render_connector" access="public" returntype="string">
		<cfargument name="config" type="any" required="yes" hint="Config Object">
		<cfargument name="_request" type="any" required="yes" hint="Request object">
		
		<cfset variables.config.copy(ARGUMENTS.config)>
		<cfset variables._request.copy(ARGUMENTS._request)>
		<cfreturn render()>
	</cffunction>

	<cffunction name="render" access="public" returntype="void" hint="render self, process commands, output requested data as XML">
		<cfset var dp="">
		<cfset var si="">
		<cfset var fi="">
		<cfset parse_request()>
		<cfif variables.editing>
			<cfset dp = CreateObject("component",names["data_class"]).init(this,variables.config,variables._request)>
			<cfset dp.process(variables.config,variables._request)>
		<cfelse>
			<cfset si = CreateObject("component","SortInterface").init(variables._request)>
			<cfset fi = CreateObject("component","FilterInterface").init(variables._request)>
			<cfset this.event.trigger("beforeSort",si)>
			<cfset this.event.trigger("beforeFilter",fi)>
			<cfset this.output_as_xml(this.sql.do_select(variables._request))>
		</cfif>
	</cffunction>
	
	<cffunction name="safe_field_name" access="public" returntype="string">
		<cfargument name="str" type="string" required="yes">
		<cfreturn ListFirst(ARGUMENTS.str,"#variables.lineBreak##chr(9)#;',")>
	</cffunction>

	<cffunction name="parse_request" access="public" returntype="void" hint="parse incoming request, detects commands and modes">
		<cfset var k=""> 
		<cfset var v=""> 
		<cfset var urlVars = structNew()>
		<cfset var match = "">
		<cfset var tmpK = "">
		<cfset var tmpV = "">
		
		<!--- set default dyn. loading params, can be reset in child classes --->
		<cfif variables.dload>
			<cfset variables._request.set_limit(0,variables.dload)>
		</cfif>	
		<!---detect edit mode--->
		<cfif isDefined("URL.editing")>
			<cfset variables.editing=true>
		<cfelseif isDefined("FORM.ids")> 
			<cfset variables.editing=true>
			<cfset request.dhtmlXLogMaster.do_log('While there is no edit mode mark, POST parameters similar to edit mode detected. #variables.lineBreak#Switching to edit mode ( to disable behavior remove POST[ids]')>
		</cfif>
		<cfloop collection="#url#" item="k">
			<cfset v = URL[k]>
			<cfset match = ReFindNoCase("([^\[\]]+)\[([\d]+)\]",k,1,true)>
			<cfif match.pos[1]>
				<cfset tmpK = mid(k,match.pos[3],match.len[3])+1>
				<cfset tmpV = mid(k,match.pos[2],match.len[2])>
				<cfif not structKeyExists(urlVars,tmpV)>
					<cfset urlVars[tmpV] = structNew()>
				</cfif>
				<cfset urlVars[tmpV][tmpK] = v>
			</cfif>
		</cfloop>	
		<cfif structKeyExists(urlVars,"dhx_sort")>
			<cfloop collection="#urlVars.dhx_sort#" item="k">
				<cfset v = safe_field_name(urlVars.dhx_sort[k])>
				<cfset k = safe_field_name(k)>
				<cfset variables._request.set_sort(resolve_parameter(k),v)>
			</cfloop>
		</cfif>		
		<cfif structKeyExists(urlVars,"dhx_filter")>
			<cfloop collection="#urlVars.dhx_filter#" item="k">
				<cfset v = safe_field_name(urlVars.dhx_filter[k])>
				<cfset k = safe_field_name(k)>
				<cfset variables._request.set_filter(resolve_parameter(k),v)>
			</cfloop>
		</cfif>	
	</cffunction>

	<cffunction name="resolve_parameter" access="public" returntype="string" hint="convert incoming request name to the actual DB name. Return: name of related DB field">
		<cfargument name="name" type="string" required="yes" hint="incoming parameter name">
		<cfreturn ARGUMENTS.name>
	</cffunction>

	<cffunction name="render_set" access="public" returntype="string" hint="render from DB resultset, process commands, output requested data as XML">
		<cfargument name="res" type="query" required="yes" hint="DB resultset">
		<cfset var output="">
		<cfset var index=0>
		<cfset var data="">
		<cfloop query="ARGUMENTS.res">
			<cfset data=this.sql.get_next(ARGUMENTS.res,ARGUMENTS.res.currentRow)>
			<cfset data = CreateObject("component",names["item_class"]).init(data,variables.config,index)>
			<cfif NOT data.get_id()>
				<cfset data.set_id(uuid())>
			</cfif>	
			<cfset this.event.trigger("beforeRender",data)>
			<cfset output = output & data.to_xml()>
			<cfset index = index+1>
		</cfloop>
		<cfreturn output>
	</cffunction>
	
	<cffunction name="output_as_xml" access="public" returntype="string" hint="output fetched data as XML">
		<cfargument name="res" type="query" required="yes" hint="DB resultset ">
		<cfset var output="">
		<cfset var start="">
		<cfset var end="">
		
		<cfset output=render_set(ARGUMENTS.res)>
		<cfset start=xml_start()>
		<cfset end=xml_end()>
		<cfcontent type="text/xml;charset=UTF-8" reset="yes"><cfoutput>#start#</cfoutput>
		<cfset this.event.trigger("beforeOutput","")>
		<cfoutput>#output##end#</cfoutput>
		<cfset end_run()>
	</cffunction>
	
	<cffunction name="end_run" access="public" returntype="void" hint="end processing, stop execution timer, kill the process">
		<cfset var time=getTickCount()-this.exec_time>
		<cfset request.dhtmlXLogMaster.do_log("Done in #time#ms.")>
		<cfflush>
		<cfabort>
	</cffunction>	

	<cffunction name="set_encoding" access="public" returntype="void" hint="set xml encoding, methods sets only attribute in XML, no real encoding conversion occurs	">
		<cfargument name="encoding" type="string" required="yes" hint="value which will be used as XML encoding">
		<cfset variables.encoding = ARGUMENTS.encoding>
	</cffunction>
	
	<cffunction name="dynamic_loading" access="public" returntype="void" hint="enable or disable dynamic loading mode">
		<cfargument name="count" type="any" required="yes" hint="count of rows loaded from server, actual only for grid-connector, can be skiped in other cases. If value is a false or 0 - dyn. loading will be disabled">
		<cfset variables.dload=ARGUMENTS.count>
	</cffunction>

	<cffunction name="enable_log" access="public" returntype="void" hint="enable logging">
		<cfargument name="path" type="string" required="no" default="" hint="path to the log file. If set as false or empty strig - logging will be disabled">
		<cfargument name="client_log" type="boolean" required="no" default="false" hint="enable output of log data to the client side">
		<cfargument name="error" type="any" required="no" default="" hint="error struct created by CF">
		<cfset request.dhtmlXLogMaster.enable_log(ARGUMENTS.path,ARGUMENTS.client_log)>
		<!--- error occured --->
		<cfif isStruct(ARGUMENTS.error)>
			<cfset request.dhtmlXLogMaster.exception_log(ARGUMENTS.error)>
		</cfif>
	</cffunction>
	
	<cffunction name="is_select_mode" access="public" returntype="boolean" hint="provides infor about current processing mode. Return: true if processing dataprocessor command, false otherwise">
		<cfset parse_request()>
		<cfreturn NOT variables.editing>
	</cffunction>
	<cffunction name="xml_start" access="public" returntype="string">
		<cfreturn "<data>">
	</cffunction>
	<cffunction name="xml_end" access="public" returntype="string">
		<cfreturn "</data>">
	</cffunction>
</cfcomponent>

