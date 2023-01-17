<!--- get_payment_method.cfm --->
<cfquery name="GET_PAYMENT_METHOD" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PAYMETHOD
	WHERE
		<cfif isDefined('PAY_ID') and len(PAY_ID)>
			PAYMETHOD_ID = #PAY_ID#
		<cfelse>
			PAYMETHOD_STATUS = 1
		</cfif>
</cfquery>
