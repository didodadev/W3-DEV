<cfcomponent displayname="Workcube_Chat_Functions">
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cffunction name="wrkCheckUser" access="remote" returnType="struct" output="false">

		<!--- <cfargument name="class_id" type="numeric" required="true">--->
		<cfset arguments.class_id = 23> 
	
		<cfquery name="check_attenders" datasource="#dsn#">
			SELECT
			<cfif isdefined("SESSION.EP")>
				EMP_ID
			<cfelseif isdefined("SESSION.PP")>
				PAR_ID
			<cfelseif isdefined("SESSION.WW")>
				<cfif listgetat(session.ww.userkey,1,"-") is "p">
				PAR_ID
				<cfelseif listgetat(session.ww.userkey,1,"-") is "c">
				CON_ID
				</cfif>
			</cfif>
			FROM
				TRAINING_CLASS_ATTENDER
			WHERE
			<cfif isdefined("SESSION.EP")>
				EMP_ID = #SESSION.EP.USERID#
			<cfelseif isdefined("SESSION.PP")>
				PAR_ID = #SESSION.PP.USERID#
			<cfelseif isdefined("SESSION.WW")>
				<cfif listgetat(session.ww.userkey,1,"-") is "p">
				PAR_ID = #SESSION.WW.USERID#
				<cfelseif listgetat(session.ww.userkey,1,"-") is "c">
				CON_ID = #SESSION.WW.USERID#
				</cfif>
			</cfif>
				AND
				CLASS_ID = #arguments.CLASS_ID#
		</cfquery>
	
		<cfif isdefined("session.ep") or isdefined("session.pp")>
			<cfquery name="check_trainers" datasource="#dsn#">
				SELECT
				<cfif isdefined("session.ep")>
					TRAINER_EMP
				<cfelseif isdefined("session.pp")>
					TRAINER_PAR
				</cfif>
				FROM
					TRAINING_CLASS
				WHERE
				<cfif isdefined("SESSION.EP")>
					TRAINER_EMP = #SESSION.EP.USERID#
				<cfelseif isdefined("SESSION.PP")>
					TRAINER_PAR = #SESSION.PP.USERID#
				</cfif>
					AND
					CLASS_ID = #arguments.CLASS_ID#
			</cfquery>
		
		<cfelse>
			<cfset check_trainers.recordcount = 0>
		</cfif>
		
		<cfset user_info = structNew()>
		<cfif check_attenders.recordcount>
			<cfset user_info.attender = 1>
		<cfelse>
			<cfset user_info.attender = 0>
		</cfif>
		<cfif check_trainers.recordcount>
			<cfset user_info.trainer = 1>
		<cfelse>
			<cfset user_info.trainer = 0>
		</cfif>
	
		<cfreturn user_info>
	</cffunction>
	<cffunction name="wrkGetCurrentUser" access="remote" returnType="struct" output="false">
		<cfscript>
		user_info = StructNew();
		if (isdefined("session.ep"))
			{
			user_info.username = "#session.ep.name# #session.ep.surname#";
			user_info.userid = session.ep.userid;
			user_info.portal = 0;
			user_info.user_level = 1;
			}
		else if (isdefined("session.pp"))
			{
			user_info.username = "#session.pp.name# #session.pp.surname#";
			user_info.userid = session.pp.userid;
			user_info.portal = 1;
			user_info.user_level = 0;
			}
		else if (isdefined("session.ww.userkey"))
			{
			user_info.username = "#session.ww.name# #session.ww.surname#";
			user_info.userid = session.ww.userid;
			user_info.portal = 2;
			user_info.user_level = 0;
			}
		else
			{
			user_info.username = "Misafir_#cgi.remote_addr#";
			user_info.userid = 0;
			user_info.portal = 3;
			user_info.user_level = 0;
			}		
		</cfscript>
		<cfreturn user_info>
	</cffunction>
</cfcomponent>
