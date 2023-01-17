<cfcomponent>
	<cfscript>
		if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
		else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
		else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
		else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
		else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
		dsn = application.systemParam.systemParam().dsn;	
	</cfscript>
	<!--- GET PROCESS --->
	<cffunction name="getProcess" access="public" returntype="any">
		<cfargument name="fuseaction" type="string" default="">
		<cfargument name="process_row_id" type="string" default="">
		
		<cfquery name="GET_PROCESS" datasource="#dsn#">
			SELECT
				#dsn#.#dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.PROCESS_ROW_ID 
			FROM
				PROCESS_TYPE_ROWS PTR,
				PROCESS_TYPE_OUR_COMPANY PTO,
				PROCESS_TYPE PT
			WHERE
				PT.IS_ACTIVE = 1 AND
				PT.PROCESS_ID = PTR.PROCESS_ID AND
				PT.PROCESS_ID = PTO.PROCESS_ID
				<cfif isdefined('session.ep')>
					AND PTO.OUR_COMPANY_ID = #session.ep.company_id#
				<cfelseif isdefined('session.pp')>
					AND PTO.OUR_COMPANY_ID = #session.pp.our_company_id#
				<cfelseif isdefined('session.wp')>
					AND PTO.OUR_COMPANY_ID = #session.wp.our_company_id#
				</cfif>
				<cfif len(arguments.fuseaction)>
					AND PT.FACTION LIKE '%#arguments.fuseaction#%'
				</cfif>
				<cfif len(arguments.process_row_id)>
					AND PTR.PROCESS_ROW_ID  = #arguments.process_row_id#
				</cfif>
		</cfquery>
		<cfreturn GET_PROCESS>
	</cffunction>
</cfcomponent>
