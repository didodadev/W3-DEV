<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfscript>
	if(isdefined("to_par_ids")) TO_PARS = ListSort(to_par_ids,"Numeric", "Desc") ; else TO_PARS = "";
	if(isdefined("to_pos_ids")) TO_POS = ListSort(to_pos_ids,"Numeric", "Desc"); else TO_POS = "";
	if(isdefined("to_cons_ids")) TO_CONS = ListSort(to_cons_ids,"Numeric", "Desc"); else TO_CONS ='';
</cfscript>
<cfif not isdefined("forum_emps")>
	<cfset forum_emps = 0>
<cfelse>
	<cfset forum_emps = 1>
</cfif>
<cfquery name="ADD_FORUM" datasource="#dsn#">
	INSERT INTO
		FORUM_MAIN
	(
		FORUMNAME,
		DESCRIPTION,
		STATUS,
		ADMIN_PARS,
		ADMIN_POS,
		ADMIN_CONS,
		FORUM_EMPS,
		FORUM_COMP_CATS,
		FORUM_CONS_CATS,
		IS_INTERNET,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORUMNAME#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#DESCRIPTION#">,
		<cfif isDefined("ATTRIBUTES.STATUS")>1,<cfelse>0,</cfif>
		<cfif len(TO_PARS)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#TO_PARS#,">,<cfelse>NULL,</cfif>
		<cfif len(to_pos)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#TO_POS#,">,<cfelse>NULL,</cfif>
		<cfif len(TO_CONS)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#TO_CONS#,">,<cfelse>NULL,</cfif>
		#FORUM_EMPS#,
		<cfif isDefined("FORUM_COMP_CATS") and len(FORUM_COMP_CATS)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#FORUM_COMP_CATS#,">,<cfelse>NULL,</cfif>
		<cfif isDefined("FORUM_CONS_CATS") and len(FORUM_CONS_CATS)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#FORUM_CONS_CATS#,">,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		#now()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		#SESSION.EP.USERID#
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
	
