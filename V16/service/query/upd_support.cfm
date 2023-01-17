<cf_date tarih='STARTDATE'>
<cf_date tarih='FINISHDATE'>

<cfquery name="ADD_SUPPORT" datasource="#dsn3#">
	UPDATE	 
		SERVICE_SUPPORT
	SET
			SUPPORT_CAT_ID=#SUPPORT_CAT_ID#,
			SERVICE_CONSUMER_ID=<cfif isdefined("member_type") and member_type is 'consumer'>#MEMBER_ID#,<cfelse>NULL,</cfif>
			SERVICE_PARTNER_ID= <cfif isdefined("member_type") and member_type is 'partner'>#MEMBER_ID#,<cfelse>NULL,</cfif>
			SERVICE_EMPLOYEE_ID=<cfif isdefined("member_type") and member_type is 'employee'>#MEMBER_ID#,<cfelse>NULL,</cfif>
			SALES_CONSUMER_ID=<cfif isdefined("sales_type") and sales_type is 'consumer'>#SALES_ID#,<cfelse>NULL,</cfif>
			SALES_PARTNER_ID= <cfif isdefined("sales_type") and sales_type is 'partner'>#SALES_ID#,<cfelse>NULL,</cfif>
			SALES_COMPANY_ID =  <cfif isdefined("sales_type") and sales_type is 'partner'>#COMPANY_ID#,<cfelse>NULL,</cfif>
			SALES_EMPLOYEE_ID= <cfif isdefined("sales_type") and sales_type is 'partner'>#SALES_ID#,<cfelse>NULL, </cfif>
			STARTDATE=#STARTDATE#,
			FINISHDATE=#FINISHDATE#,
			SUPPORT_DETAIL='#SUPPORT_DETAIL#',
			SUPPORT_HEAD='#SUPPORT_HEAD#',
			SUPPORT_NO='#SUPPORT_NO#',
			PRO_SERIAL_NO='#PRODUCT_SERIAL_NUMBER#',
			UPDATE_IP='#CGI.REMOTE_ADDR#',
			UPDATE_EMP=#SESSION.EP.USERID#,
			UPDATE_DATE=#NOW()#
		WHERE
			SUPPORT_ID = #URL.ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

