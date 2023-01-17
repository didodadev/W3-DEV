<CFSETTING enablecfoutputonly="yes">
	<cfquery name="get_class_application" datasource="#dsn#">
		SELECT
			CLASS_ID
		FROM
			TRAINING_CLASS
		WHERE
			CLASS_ID = #attributes.CLASS_ID#
	</cfquery>

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
			CLASS_ID = #attributes.CLASS_ID#
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
				CLASS_ID = #attributes.CLASS_ID#
		</cfquery>
	
	<cfelse>
		<cfset check_trainers.recordcount = 0>
	</cfif>
	
<cfoutput>&attender=<cfif check_attenders.recordcount>1<cfelse>0</cfif>&trainer=<cfif check_trainers.recordcount>1<cfelse>0</cfif>&result=1&end</cfoutput>

<CFSETTING enablecfoutputonly="no">
