<cf_date tarih='attributes.open_date'>
<cfset company_id = "">
<cfset branch_id = "">
<cfloop from="1" to="#listlen(attributes.comp_branch,',')#" index="dgr">
	<cfset company_branch = listgetat(attributes.comp_branch,dgr,',')>
	<cfset company_id = listappend(company_id,listfirst(company_branch,'-'),',')>
	<cfset branch_id = listappend(branch_id,listlast(company_branch,'-'),',')>
</cfloop>
<cfloop from="1" to="#listlen(attributes.comp_branch,',')#" index="i">
	<cfquery name="add_comp_branch_related" datasource="#dsn#">
		INSERT INTO
			COMPANY_BRANCH_RELATED
		(
			OUR_COMPANY_ID,
			COMPANY_ID,
			CONSUMER_ID,
			BRANCH_ID,
			MUSTERIDURUM,
			OPEN_DATE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			#listgetat(company_id,i,',')#,
			<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">,
				<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">,
			<cfelseif isdefined("attributes.cid") and len(attributes.cid)>
				<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">,
			</cfif>
			#listgetat(branch_id,i,',')#,
			<cfif isdefined("attributes.cat_status") and len(attributes.cat_status)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_status#">
			<cfelse>
				<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
			</cfif>,
			<cfif isDate(attributes.open_date) and len(attributes.open_date)>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.open_date#">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_timestamp" null="yes" value="">
			</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
	</cfquery>
</cfloop>
<script type="text/javascript">
	<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>
