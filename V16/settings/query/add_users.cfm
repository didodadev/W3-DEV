<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.GROUP_NAME=replacelist(attributes.GROUP_NAME,list,list2)>

<cfset POS = "">
<cfset PARS = "">
<cfset CONS = "">
<cfloop LIST="#attributes.TARGET_LIST#" INDEX="I">
	<cfif I CONTAINS "POS">
		<cfset POS = LISTAPPEND(POS,LISTGETAT(I,2,"-"))>
	<cfelseif I CONTAINS "PAR">
		<cfset PARS = LISTAPPEND(PARS,LISTGETAT(I,2,"-"))>
	<cfelseif I CONTAINS "CON">
		<cfset CONS = LISTAPPEND(CONS,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop> 

<cfif not isDefined("TO_ALL")>
	<cfset TO_ALL = 0>
</cfif>

<cfquery name="ADD_USERS" datasource="#dsn#">
	INSERT INTO 
		USERS
	(
		GROUP_NAME,
	<cfif len(POS)>
		POSITIONS,
	</cfif>
	<cfif len(PARS)>
		PARTNERS,
	</cfif>
	<cfif len(CONS)>
		CONSUMERS,
	</cfif>
		TO_ALL,
		RECORD_DATE,
		RECORD_MEMBER,
		RECORD_IP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.GROUP_NAME#">,
	<cfif len(POS)>
		<cfqueryparam cfsqltype="cf_sql_varchar" value=",#POS#,">,
	</cfif>
	<cfif len(PARS)>
		<cfqueryparam cfsqltype="cf_sql_varchar" value=",#PARS#,">,
	</cfif>
	<cfif len(CONS)>
		<cfqueryparam cfsqltype="cf_sql_varchar" value=",#CONS#,">,
	</cfif>
		<cfqueryparam cfsqltype="cf_sql_bit" value="#to_all#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	)
</cfquery>	
<cfif not isdefined("attributes.draggable")>
	<cfif attributes.process eq "">
	<cflocation url="#request.self#?fuseaction=settings.form_add_users" addtoken="No">
	<cfelse>
		<script type="text/javascript">
			window.opener.location.reload();
			window.close();
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>