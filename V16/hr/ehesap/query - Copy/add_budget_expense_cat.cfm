
<cfquery name="ADD_EXPENSE_CAT" datasource="#dsn2#">
	INSERT INTO 
		EXPENSE_CATEGORY
	(
		EXPENSE_CAT_NAME,
		EXPENSE_CAT_DETAIL,
		EXPENCE_IS_HR,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#attributes.expense_cat_name#',
		'#attributes.expense_cat_detail#',
		1,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		self.close();
	</cfif>	
</script>
