<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("Sayfa diğer şirkette açıldığı için  için güncelleme işlemi yapılamaktadır !");
		window.location.href="<cfoutput>#request.self#?fuseaction=bank.list_bank_account</cfoutput>";
	</script>
	<cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_ACCOUNT" datasource="#dsn3#">
			DELETE FROM
				ACCOUNTS
			WHERE
				ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
		</cfquery>
		<cfquery name="DEL_ACCOUNT_OPEN_CONTROL" datasource="#dsn3#">
			DELETE FROM
				ACCOUNTS_OPEN_CONTROL
			WHERE
				ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
		<cfquery name="DEL_ACCOUNT_BRANCH" datasource="#dsn3#">
			DELETE FROM 
				ACCOUNTS_BRANCH 
			WHERE 
				ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_account</cfoutput>";
</script>
