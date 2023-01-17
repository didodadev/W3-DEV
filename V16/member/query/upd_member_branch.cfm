<cf_date tarih='attributes.open_date'>
<cfif len(attributes.related_id)>
	<cfquery name="upd_comp_branch_related" datasource="#dsn#">
		UPDATE
			COMPANY_BRANCH_RELATED
		SET
			MUSTERIDURUM = <cfif len(attributes.cat_status)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_status#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
			OPEN_DATE = <cfif isDate(attributes.open_date) and len(attributes.open_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.open_date#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_timestamp"></cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#">
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not (isDefined('attributes.draggable') and len(attributes.draggable))>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	</cfif>
</script>
