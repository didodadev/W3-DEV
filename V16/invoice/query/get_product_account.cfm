<!--- alis ve satis faturasi icin  kontrol --->
<cfset attributes.ACCOUNT_CODE_PUR="">
<cfset attributes.ACCOUNT_CODE_PRO="">
<cfquery name="get_pro_acc" datasource="#DSN2#" >
	SELECT
		ACCOUNT_CODE_PUR,
		ACCOUNT_CODE
	FROM
		#dsn3_alias#.PRODUCT
	WHERE
		PRODUCT_ID=#attributes.pid#
</cfquery>
<cfif len(get_pro_acc.ACCOUNT_CODE_PUR)>
	<cfset attributes.ACCOUNT_CODE_PUR = get_pro_acc.ACCOUNT_CODE_PUR >
</cfif>
<cfif len(get_pro_acc.ACCOUNT_CODE)>
	<cfset attributes.ACCOUNT_CODE_PRO = get_pro_acc.ACCOUNT_CODE >
</cfif>
