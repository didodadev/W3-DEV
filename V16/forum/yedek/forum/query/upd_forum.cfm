<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<!---
<cfset TO_POS = "">
<cfset TO_PARS = "">
<cfset TO_CONS = "">
<cfloop LIST="#admins#" INDEX="I">
	<cfif I CONTAINS "POS">
		<cfset TO_POS = LISTAPPEND(TO_POS,LISTGETAT(I,2,"-"))>
	<cfelseif I CONTAINS "PAR">
		<cfset TO_PARS = LISTAPPEND(TO_PARS,LISTGETAT(I,2,"-"))>
	<cfelseif I CONTAINS "CON">
		<cfset TO_CONS = LISTAPPEND(TO_CONS,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop>  --->
<cfscript>
	if(isdefined("to_par_ids")) TO_PARS = ListSort(to_par_ids,"Numeric", "Desc") ; else TO_PARS = "";
	if(isdefined("to_pos_ids")) TO_POS = ListSort(to_pos_ids,"Numeric", "Desc"); else TO_POS = "";
	if(isdefined("to_cons_ids")) TO_CONS = ListSort(to_cons_ids,"Numeric", "Desc"); else TO_CONS ='';
</cfscript>
<cfif not isdefined("status")>
	<cfset status = 0>
<cfelse>
	<cfset status = 1>
</cfif>
<cfif not isdefined("forum_emps")>
	<cfset forum_emps = 0>
<cfelse>
	<cfset forum_emps = 1>
</cfif>
<cfquery name="UPD_FORUM" datasource="#dsn#">
	UPDATE
		FORUM_MAIN
	SET
		FORUMNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORUMNAME#">,
		DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DESCRIPTION#">,
		STATUS = #STATUS#,
		ADMIN_PARS = <cfif len(TO_PARS)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#TO_PARS#,">,<cfelse>NULL,</cfif>
		ADMIN_POS = <cfif len(to_pos)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#TO_POS#,">,<cfelse>NULL,</cfif>
		ADMIN_CONS = <cfif len(TO_CONS)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#TO_CONS#,">,<cfelse>NULL,</cfif>
		FORUM_COMP_CATS = <cfif isDefined("FORUM_COMP_CATS")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#FORUM_COMP_CATS#,">,<cfelse>NULL,</cfif>
		FORUM_CONS_CATS = <cfif isDefined("FORUM_CONS_CATS")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#FORUM_CONS_CATS#,">,<cfelse>NULL,</cfif>
		FORUM_EMPS = #FORUM_EMPS#,
		IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		FORUMID = #FORUMID#
</cfquery>	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
