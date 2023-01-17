<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.GROUP_NAME=replacelist(attributes.GROUP_NAME,list,list2)>

<cfset POS = "">
<cfset PARS = "">
<cfset CONS = "">
<cfloop LIST="#FORM.TARGET_LIST#" INDEX="I">
	<cfif I CONTAINS "POS">
		<cfset POS = LISTAPPEND(POS,LISTGETAT(I,2,"-"))>
	<cfelseif I CONTAINS "PAR">
		<cfset PARS = LISTAPPEND(PARS,LISTGETAT(I,2,"-"))>
	<cfelseif I CONTAINS "CON">
		<cfset CONS = LISTAPPEND(CONS,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop> 

<cfquery name="UPD_USERS" datasource="#dsn#">
	UPDATE 
		USERS
	SET
		GROUP_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.GROUP_NAME#">,
	<cfif POS IS "">
		POSITIONS = NULL,
	<cfelse>
		POSITIONS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#POS#,">,
	</cfif>
	<cfif PARS IS "">
		PARTNERS = NULL,
	<cfelse>
		PARTNERS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#PARS#,">,
	</cfif>
	<cfif CONS IS "">
		CONSUMERS = NULL,
	<cfelse>
		CONSUMERS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#CONS#,">,
	</cfif>
		TO_ALL = <cfif isdefined("form.to_all")>1<cfelse>0</cfif>,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE
		GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.group_id#">
</cfquery>
<cfif attributes.process eq "">
<cflocation url="#request.self#?fuseaction=settings.form_add_users" addtoken="No">
<cfelse>
<script type="text/javascript">
window.opener.location.reload();
window.close();
</script>
</cfif>
