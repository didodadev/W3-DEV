<cfquery name="TAXS" datasource="#dsn2#">
	SELECT 
    	TAX_ID, 
        TAX, 
        PURCHASE_CODE
    FROM 
	    SETUP_TAX
</cfquery>	
<cfquery name="get_branches" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfquery name="DEL_BRANCH_SALES" datasource="#dsn3#">
	DELETE FROM SETUP_BRANCH_SALES
</cfquery>
<cfoutput query="get_branches">
	<cfset branch_id_ = BRANCH_ID>
	<cfloop query="TAXS">
		<cfset tax_id_ = TAX_ID>
		<cfif (isdefined("attributes.accountcode_#branch_id_#_#tax_id_#") and len(evaluate("attributes.accountcode_#branch_id_#_#tax_id_#"))) OR (isdefined("attributes.accountcode2_#branch_id_#_#tax_id_#") and len(evaluate("attributes.accountcode2_#branch_id_#_#tax_id_#")))>
			<cfset deger = evaluate("attributes.accountcode_#branch_id_#_#tax_id_#")>
			<cfset deger2 = evaluate("attributes.accountcode2_#branch_id_#_#tax_id_#")>
			<cfset deger3 = evaluate("attributes.accountcode3_#branch_id_#_#tax_id_#")>
			<cfquery name="add_br_sales" datasource="#dsn3#">
				INSERT INTO 
					SETUP_BRANCH_SALES
				(
				<cfif len(deger)>
					ACCOUNT_CODE,
				</cfif>	
				<cfif len(deger2)>
					ACCOUNT_CODE_IADE,
				</cfif>
				<cfif len(deger3)>
					ACCOUNT_CODE_INDIRIM,
				</cfif>
					PERIOD_ID,
					BRANCH_ID,
					TAX_ID,
					IS_ACC_DISCOUNT
				)
				VALUES
				(
				<cfif len(deger)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#deger#">,
				</cfif>
				<cfif len(deger2)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#deger2#">,
				</cfif>
				<cfif len(deger3)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#deger3#">,
				</cfif>
					#session.ep.period_id#,
					#branch_id_#,
					#tax_id_#,
				<cfif isdefined('iss_acc_d_#branch_id_#') and len(evaluate('iss_acc_d_#branch_id_#'))>1<cfelse>0</cfif>	
				)
			</cfquery>
		</cfif>
	</cfloop> 
</cfoutput>
<cflocation url="#request.self#?fuseaction=settings.form_add_branch_sales" addtoken="no">
