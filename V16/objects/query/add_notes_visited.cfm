<cfif attributes.MEMBER_VISITED_TYPE is 'employee'>
	<cfset visited_tpye = 1>
<cfelseif attributes.MEMBER_VISITED_TYPE is 'partner'>
	<cfset visited_tpye = 2>
<cfelseif attributes.MEMBER_VISITED_TYPE is 'consumer'>
	<cfset visited_tpye = 3>
<cfelse>
	<cfset visited_tpye = 1>
</cfif>
<cfquery name="ADD_NOTES_VISITED" datasource="#DSN#">
	INSERT INTO 
		VISITING_NOTES
	(
		NOTE_GIVEN,
		NOTE_TAKEN_TYPE,
		NOTE_TAKEN_ID,
		DETAIL,
		TEL,
		EMAIL,
		IS_HOMEPAGE,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_CON,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		<cfif len(attributes.member)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.MEMBER#">,<cfelse>NULL,</cfif>
		#visited_tpye#,
		<cfif len(attributes.MEMBER_VISITED_ID)>#ATTRIBUTES.MEMBER_VISITED_ID#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.DETAIL#">,<cfelse>NULL,</cfif>
		<cfif len(attributes.tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.TEL#">,<cfelse>NULL,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.EMAIL#">,
		<cfif isdefined("attributes.IS_HOMEPAGE")>1,<cfelse>0,</cfif>
		<cfif isdefined("session.ep.userid") and len(session.ep.userid)>#SESSION.EP.USERID#,<cfelse>NULL,</cfif>
		<cfif isdefined("session.pp.userid") and len(session.pp.userid)>#SESSION.PP.USERID#,<cfelse>NULL,</cfif>
		<cfif isdefined("session.ww.userid") and len(session.ww.userid)>#SESSION.WW.USERID#,<cfelse>NULL,</cfif>
		#NOW()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	)
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>', 'homebox_notes' );
	<cfelse>
		window.close();
	</cfif>
</script>
