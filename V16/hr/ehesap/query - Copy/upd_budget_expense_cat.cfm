<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="UPD_EXPENSE_CAT" datasource="#dsn2#">
		UPDATE
			EXPENSE_CATEGORY
		SET
			EXPENSE_CAT_NAME='#attributes.expense_cat_name#',
			EXPENSE_CAT_DETAIL='#attributes.expense_cat_detail#',
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_DATE = #now()#
		WHERE
			EXPENSE_CAT_ID = #attributes.expense_cat_id#
	</cfquery>
  </cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		self.close();
	</cfif>	
</script>

