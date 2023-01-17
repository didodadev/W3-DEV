<cfloop from="1" to="#attributes.row_count_#" index="i">
	<cfset account_code = evaluate('attributes.account_code#i#')>
	<cfset account_iade = evaluate('attributes.account_iade#i#')>
	<cfset account_code_pur = evaluate('attributes.account_code_pur#i#')>
	<cfset account_pur_iade = evaluate('attributes.account_pur_iade#i#')>
	<cfset product_id = evaluate('attributes.product_id#i#')>
	<cfquery name="GET_ACCOUNT_CODE" datasource="#DSN3#">
		SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #PRODUCT_ID# AND PERIOD_ID = #SESSION.EP.PERIOD_ID#
	</cfquery>
	<cfif get_account_code.recordcount>
		<cfquery name="UPD_PRODUCT" datasource="#DSN3#">
			UPDATE PRODUCT_PERIOD SET
				ACCOUNT_CODE = <cfif len(account_code)>'#account_code#',<cfelse>NULL,</cfif>
				ACCOUNT_IADE = <cfif len(account_iade)>'#account_iade#',<cfelse>NULL,</cfif>
				ACCOUNT_PUR_IADE = <cfif len(account_pur_iade)>'#account_pur_iade#',<cfelse>NULL,</cfif>
				ACCOUNT_CODE_PUR = <cfif len(account_code_pur)>'#account_code_pur#'<cfelse>NULL</cfif>
			WHERE PRODUCT_ID = #PRODUCT_ID# AND PERIOD_ID = #SESSION.EP.PERIOD_ID#	
		</cfquery>
	<cfelseif len(account_code) or len(account_code_pur) or len(account_iade) or len(account_pur_iade)>
		<cfquery name="ADD_PRODUCT" datasource="#DSN3#">
			INSERT INTO PRODUCT_PERIOD
				( 
				PRODUCT_ID,
				ACCOUNT_CODE,
				ACCOUNT_CODE_PUR,
				ACCOUNT_IADE,
				ACCOUNT_PUR_IADE,
				PERIOD_ID )
			VALUES
				(
				#PRODUCT_ID#,
				<cfif len(account_code)>'#account_code#',<cfelse>NULL,</cfif>
				<cfif len(account_code_pur)>'#account_code_pur#',<cfelse>NULL,</cfif>
				<cfif len(account_iade)>'#account_iade#',<cfelse>NULL,</cfif>
				<cfif len(account_pur_iade)>'#account_pur_iade#',<cfelse>NULL,</cfif>
				#SESSION.EP.PERIOD_ID#
				)
		</cfquery>
	</cfif>
</cfloop>

<!--- <script type="text/javascript">
	wrk_opener_reload();
	/*window.close();*/
</script> --->
<cfif isdefined("QRY_STR") and len(QRY_STR)>
	<cflocation url="#request.self#?#QRY_STR#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=product.popup_add_collacted_product_accounts" addtoken="no">
</cfif>

