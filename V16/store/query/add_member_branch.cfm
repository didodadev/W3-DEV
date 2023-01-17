<cfquery name="GET_COMPANY_CONTROL" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		COMPANY_BRANCH_RELATED
	WHERE
		DEPOT_DAK IS NULL AND
		<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
		<cfelseif isdefined("attributes.cid") and len(attributes.cid)>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND
		</cfif>
		BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfif get_company_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='58.İlgili Müşteri Şube İle İlişkilendirilmiş'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="ADD_COMPANY_BRANCH_RELATED" datasource="#DSN#">
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
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
		<cfif isdefined("attributes.cpid")>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">,
			<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">,
		<cfelse>
			<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">,
		</cfif>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
			<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>

<script type="text/javascript">
	alert("<cf_get_lang no='59.Üye ile Şube İlişkilendirildi'> !");	
	wrk_opener_reload();
	window.close();
</script>
