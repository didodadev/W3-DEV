<cfcomponent namespace="DataProcessor" hint="Base DataProcessor handling">
	<cfscript>
		variables.connector = "";//!< Connector instance
		variables.config = "";//!< DataConfig instance
		variables._request = "";//!< DataRequestConfig instance
	</cfscript>
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor">
		<cfargument name="connector" type="any" required="yes" hint="Connector object">
		<cfargument name="config" type="any" required="yes" hint="DataConfig object">
		<cfargument name="_request" type="any" required="yes" hint="DataRequestConfig object">	
		<cfset variables.connector = ARGUMENTS.connector>
		<cfset variables.config = ARGUMENTS.config>
		<cfset variables._request = ARGUMENTS._request>
		<cfreturn this>
	</cffunction>
	<cffunction name="name_data" access="public" returntype="string" hint="Convert incoming data name to valid db name. Redirect to Connector.name_data by default. Return related db_name">
		<cfargument name="data" type="string" required="yes" hint="data name from incoming request">
		<cfreturn variables.connector.name_data(ARGUMNETS.data)>
	</cffunction>
	<cffunction name="first_loop_form_fields" returntype="string" hint="Get the list of the form fields names that will be first in the loop. The order is different at evey call so it is required.">
		<Cfreturn "">
	</cffunction>
	<!----------------------- ---------------------- -------------------------------->
	<!----------------------- ---------------------- -------------------------------->
	<!----------------------- ---------------------- -------------------------------->

	<cffunction name="get_post_values" access="public" returntype="struct" hint="retrieve data from incoming request and normalize it. Return hash of data">
		<cfargument name="ids" type="array" required="yes" hint="array of extected IDs">
		<cfset var data = structNew()>
		<cfset var i = 0>
		<cfset var key = "">
		<cfset var value = "">
		<cfset var details = "">
		<cfset var name = "">
		<cfset var name2 = "">
		<cfset var flds = "">
		
		<!--- first order loop --->
		<cfset flds = first_loop_form_fields()>
		<cfset tm = ArrayNew(1)>
		<cfloop from="1" to="#ArrayLen(ARGUMENTS.ids)#" index="i">
			<cfset data[ARGUMENTS.ids[i]]=structNew()>
		</cfloop>
		<cfloop from="1" to="2" index="i">
			<cfloop collection="#FORM#" item="key">
					<cfset value = FORM[key]>
					<cfset details=ListToArray(key,"_")>
					<cfif ArrayLen(details) gt  1>
						<cfset name2 = details[1]>
						<cfset ArrayDeleteAt(details,1)>
						<cfif (i eq 1 AND ListFindNoCase(flds,ArrayToList(details,"_"))) OR (i eq 2 AND NOT ListFindNoCase(flds,ArrayToList(details,"_")))>
							<cfset name=name_data(ArrayToList(details,"_"))>
							<cfset data[name2][name]=value>
						</cfif>	
					</cfif>
			</cfloop> 
		</cfloop>		
		<cfreturn data>
	</cffunction>
	
	<cffunction name="process" access="public" returntype="void" hint="process incoming request ( save|update|delete )">
		<cfset var results = "">
		<cfset var ids = "">
		<cfset var rows_data = "">
		<Cfset var failed = "">
		<cfset var i = 0>
		<cfset var rid = "">
		<cfset var status  = "">
		<cfset var action  = "">
		<cfset request.dhtmlXLogMaster.do_log("DataProcessor object initialized",FORM)>
		<cfset results=ArrayNew(1)>
		<cfif NOT isDefined("FORM.ids")>
			<cfthrow errorcode="99" message="Incorrect incoming data, ID of incoming records not recognized">
		</cfif>	
		<cfset ids=ListToArray(FORM.ids,",")>
		<cfset rows_data = get_post_values(ids)>
		<cfset failed=false>
		<cftry>
			<cfif variables.connector.sql.is_global_transaction()>
				<cfset variables.connector.sql.begin_transaction()>
			</cfif>
			<cfloop from="1" to="#ArrayLen(ids)#" index="i">
				<cfset rid = ids[i]>
				<cfset request.dhtmlXLogMaster.do_log("Row data [#rid#]",rows_data[rid])>
				<cfif NOT structKeyExists(FORM,"#rid#_!nativeeditor_status")>
					<cfthrow errorcode="99" message="Status of record [#rid#] not found in incoming request">
				</cfif>	
				<cfset status = FORM["#rid#_!nativeeditor_status"]>
				<cfset action=CreateObject("component","DataAction").init(status,rid,rows_data[rid])>
				<cfset ArrayAppend(results,action)>
				<cfset inner_process(action)>
			</cfloop>
		<cfcatch>
			<cfif isDefined("request.dhtmlxDebug")>
					<cfsavecontent variable="tmp">
						<Cfdump var="#cfcatch#">
					</cfsavecontent>
					<cffile action="append" file="#expandPath('debug.htm')#" output="#tmp#" nameconflict="overwrite">
			</cfif>
			<cfset failed=true>
		</cfcatch>	
		</cftry>
		
		<cfif variables.connector.sql.is_global_transaction()>
			<cfif NOT failed>
				<cfloop from="1" to="#ArrayLen(results)#" index="i">
					<cfif results[i].get_status() eq "error" OR results[i].get_status() eq "invalid">
						<cfset failed=true>
						<cfbreak>
					</cfif>
				</cfloop>	
			</cfif>
			<cfif failed>
				<cfloop from="1" to="#ArrayLen(results)#" index="i">
					<cfset results[i].error()>
				</cfloop>
				<cfset variables.connector.sql.rollback_transaction()>
			<cfelse>
				<cfset variables.connector.sql.commit_transaction()>
			</cfif>	
		</cfif>
		<cfset output_as_xml(results)>
	</cffunction>
	
	<cffunction name="status_to_mode" access="public" returntype="string" hint="converts status string to the inner mode name. Return inner mode name">
		<cfargument name="status" type="string" required="yes" hint="external status string"> 
		<cfswitch expression="#ARGUMENTS.status#">
			<cfcase value="updated">
				<cfreturn "do_update">
			</cfcase>	
			<cfcase value="inserted">
				<cfreturn "do_insert">
			</cfcase>	
			<cfcase value="deleted">
				<cfreturn "do_delete">
			</cfcase>	
			<cfdefaultcase>
				<cfreturn ARGUMENTS.status>
			</cfdefaultcase>		
		</cfswitch>	
	</cffunction>
	
	<cffunction name="inner_process" access="public" returntype="any" hint="process data updated request received. Return DataAction object with details of processing">
		<cfargument name="action" type="any" required="yes" hint="DataAction object">  
		<cfset var mode = "">
		<cfset var check = "">
		
		<cfif variables.connector.sql.is_record_transaction()>
			<cfset variables.connector.sql.begin_transaction()>
		</cfif>
		<cftry>	
			<cfset mode = status_to_mode(ARGUMENTS.action.get_status())>
			<cfif NOT variables.connector.access.check(mode)>
				<cfset request.dhtmlXLogMaster.do_log("Access control: #operation# operation blocked")>
				<cfset ARGUMEBNTS.action.error()>
			<cfelse>
				<cfset check = variables.connector.event.trigger("beforeProcessing",ARGUMENTS.action)>
				<cfif NOT ARGUMENTS.action.is_ready()>
					<cfset check_exts(ARGUMENTS.action,mode)>
				</cfif>	
				<cfset check = variables.connector.event.trigger("afterProcessing",ARGUMENTS.action)>
			</cfif>
			<cfcatch>
				<cfif isDefined("request.dhtmlxDebug")>
					<cfsavecontent variable="tmp">
						<Cfdump var="#cfcatch#">
					</cfsavecontent>
					<cffile action="append" file="#expandPath('debug.htm')#" output="#tmp#" nameconflict="overwrite">
				</cfif>
				<cfset action.set_status("error")>
			</cfcatch>
		</cftry>
		<cfif variables.connector.sql.is_record_transaction()>
			<cfif ARGUMENTS.action.get_status() eq "error" OR  ARGUMENTS.action.get_status() eq "invalid">
				<cfset variables.connector.sql.rollback_transaction()>
			<cfelse>
				<cfset variables.connector.sql.commit_transaction()>
			</cfif>	
		</cfif>
		<cfreturn ARGUMENTS.action>
	</cffunction>

	<cffunction name="check_exts" access="public" returntype="void" hint="check if some event intercepts processing, send data to DataWrapper in other case">
		<cfargument name="action" type="any" required="yes" hint="DataAction object"> 
		<cfargument name="mode" type="string" required="yes" hint="name of inner mode ( will be used to generate event names )">  
	
		<cfset var sql = "">
		<cfset method=ArrayNew(1)>
		<cfset variables.connector.event.trigger("before"& ARGUMENTS.mode,ARGUMENTS.action)>
		<cfif ARGUMENTS.action.is_ready()>
			<cfset request.dhtmlXLogMaster.do_log("Event code for " & ARGUMENTS.mode & " processed")>
		<cfelse>
			<!--- check if custom sql defined --->
			<cfset sql = variables.connector.sql.get_sql(ARGUMENTS.mode,ARGUMENTS.action)>
			<cfif len(sql)>
				<cfset variables.connector.sql.query(sql)>
			<cfelse>
				<cfset ARGUMENTS.action.sync_config(variables.config)>
				<cfset ArrayAppend(method,variables.connector.sql)>
				<cfset ArrayAppend(method,ARGUMENTS.mode)>
				<cfif NOT IsCustomFunction(evaluate('method[1].#method[2]#'))>
					<cfthrow errorcode="99" message="Unknown dataprocessing action: #ARGUMENTS.mode#">
				</cfif>	
				<cfset evaluate("method[1].#method[2]#(ARGUMENTS.action,variables._request)")>
			</cfif>
		</cfif>
		<cfset variables.connector.event.trigger("after" & ARGUMENTS.mode,ARGUMENTs.action)>
	</cffunction>	
	
	<cffunction name="output_as_xml" access="public" returntype="void" hint="output xml response for dataprocessor">
		<cfargument name="results" type="array" required="yes" hint="array of DataAction objects">
		<cfset var i="">
		<cfset request.dhtmlXLogMaster.do_log("Edit operation finished",ARGUMENTS.results)>
		<cfcontent type="text/xml;charset=UTF-8"><cfoutput><?xml version='1.0' ?><data>
		<cfloop from="1" to="#ArrayLen(ARGUMENTs.results)#" index="i">
			#ARGUMENTS.results[i].to_xml()#
		</cfloop>
		</data>
		</cfoutput>
	</cffunction>
</cfcomponent>

