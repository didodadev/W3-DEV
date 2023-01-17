<cfcomponent namespace="LogMaster" hint="Controls error and debug logging.">
	<cfscript>
		variables.lineBreak = "#chr(13)##chr(10)#";
		variables._logFile = "";
		variables._output = false;
		variables._session = "";
	</cfscript>
	
	<cffunction name="init" access="public" returntype="any" hint="Constructor">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="log_details" access="public" returntype="string" hint="convert array to string representation ( it is a bit more readable than var_dump ). Return: string with array description">
		<cfargument name="data" type="any" required="yes" hint="data object">
		<cfargument name="pref" type="string" required="no" default="" hint="Prefix string, used for formating, optional">
		<cfset var str = "">
		<cfset var k = "">
		<cfif isArray(ARGUMENTS.data)>
			<cfset str = ArrayNew(1)>
			<cfloop from="1" to="#ArrayLen(ARGUMENTS.data)#" index="k">
				<cfset arrayAppend(str,ARGUMENTS.pref & k & " => " & log_details(ARGUMENTS.data[k],ARGUMENTS.pref & "#chr(9)#"))>
			</cfloop>
			<cfreturn ArrayToList(str,variables.lineBreak)>
   		</cfif>
		<cfif isObject(ARGUMENTS.data)>
			<cfif isDefined("ARGUMENTS.data.__toString") AND IsCustomFunction(ARGUMENTS.data.__toString)>
				<cfreturn ARGUMENTS.data.__toString()>
			<cfelse>
				<cfreturn "<Object>">
			</cfif>	
		<cfelseif isStruct(ARGUMENTS.data)>
			<cfset str = ArrayNew(1)>
			<cfloop collection="#ARGUMENTS.data#" item="k">
				<cfset arrayAppend(str,ARGUMENTS.pref & k & " => " & log_details(ARGUMENTS.data[k],ARGUMENTS.pref & "#chr(9)#"))>
			</cfloop>
			<cfreturn ArrayToList(str,variables.lineBreak)>
   		</cfif>
   		<cfreturn ARGUMENTS.data>
	</cffunction>
	
	<cffunction name="do_log" access="public" returntype="void" hint="put record in log">
		<cfargument name="str" type="any" required="no" default="" hint="string with log info, optional">
		<cfargument name="data" type="any" required="no" default="" hint="data object, which will be added to log, optional">
		<cfset var message = "">
		<cfif isObject(ARGUMENTS.str) AND isDefined("ARGUMENTS.str.__toString") AND isCustomFunction(ARGUMENTS.str.__toString)>
			<cfset ARGUMENTS.str = ARGUMENTS.str.__toString()>
		</cfif>
		<cfif len(variables._logFile)>
			<cfset message = ARGUMENTS.str & variables.lineBreak & log_details(ARGUMENTS.data) & "#variables.lineBreak##variables.lineBreak#">
			<cfset variables._session = variables._session & message>
			<cfif not fileExists(variables._logFile)>
				<cffile action="write" file="#variables._logFile#" output="" addnewline="no">
			</cfif> 
			<cffile action="append" file="#variables._logFile#" output="#message#" addnewline="no">
   		</cfif>
	</cffunction>
	
	<cffunction name="get_session_log" access="public" returntype="string" hint="get logs for current request. Return: string, which contains all log messages generated for current request">
		<cfreturn variables._session>
	</cffunction>
	
	<cffunction name="exception_log" access="remote" returntype="void" hint="exception handler, used as default reaction on any error - show execution log and stop processing">
		<cfargument name="error" type="struct" required="yes" hint="error data from CF server">
		<cftry>
			<cfif isDefined("ARGUMENTS.error.RootCause.ErrNumber")>
				<!--- exception --->
				<cfset do_log("!!!Uncaught Exception#variables.lineBreak#Code: " & ARGUMENTS.error.RootCause.ErrNumber & "#variables.lineBreak#Message: " & ARGUMENTS.error.RootCause.Message& " " & ARGUMENTS.error.RootCause.Detail)>		
			<cfelse>
				<!--- error --->	
				<cfset do_log(ARGUMENTS.error.message & ": " & ARGUMENTS.error.TagContext[1].Template & " on line " & ARGUMENTS.error.TagContext[1].Line)>
			</cfif>
			<cfcontent reset="yes" type="text/html">
			<cfif variables._output>
				<cfoutput><pre><xmp>#variables.lineBreak##xmlFormat(get_session_log())##variables.lineBreak#</xmp></pre></cfoutput>
			<Cfelse>
				<cfoutput>#ARGUMENTS.error.message##variables.lineBreak##ARGUMENTS.error.RootCause.Description#</cfoutput>	
			</cfif>
		<cfcatch></cfcatch>
		</cftry>
		<Cfabort>
	</cffunction>
	
	<cffunction name="enable_log" access="public" returntype="void" hint="enable logging">
		<cfargument name="name" type="string" required="yes" hint="path to the log file, if boolean false provided as value - logging will be disabled">
		<cfargument name="output" type="boolean" required="no" default="False">
		<cfset variables._logFile = ARGUMENTS.name>
		<cfset variables._output = ARGUMENTS.output>
		<cfif Len(variables._logFile)>
			<cferror type="exception" exception="any" template="#CGI.SCRIPT_NAME#"> 
			<cferror type="request" exception="any" template="#CGI.SCRIPT_NAME#"> 
			<cfset do_log("#variables.lineBreak#====================================#variables.lineBreak#Log started, " & DateFormat(now(),dateformat_style)&" " & TimeFormat(now(),"hh:mm:sstt") & "#variables.lineBreak#====================================")>
		</cfif>
	</cffunction>
</cfcomponent>

