<cfset select_list="">
<cfoutput>
	<cfloop from="1" to="#attributes.count#" index="i">
		<cfif isdefined("attributes.selected#i#")>
			<cfset select_list=listappend(select_list,evaluate("selected#i#"))>
		</cfif>
	</cfloop>
</cfoutput>
<!--- alan isimleri ve acc kodları güncellenecek--->
<cfloop from="1" to="#attributes.count#" index="i">
	<cfquery name="UPD_INCOME_TABLE" DATASOURCE="#DSN2#">
		UPDATE
			CASH_FLOW_TABLE
		SET
			ACCOUNT_CODE = <cfif isdefined("change_account#i#") and len(evaluate("change_account#i#"))>'#wrk_eval("change_account#i#")#'<cfelse>NULL</cfif>,
			BA=<cfif isdefined("bakiye#i#") and len(evaluate("bakiye#i#"))>#evaluate("bakiye#i#")#<cfelse>NULL</cfif>,
			SIGN=<cfif isdefined("sign#i#") and len(evaluate("sign#i#"))>'#wrk_eval("sign#i#")#'<cfelse>NULL</cfif>,
			<cfif session.ep.our_company_info.is_ifrs eq 1>
				IFRS_CODE =<cfif isdefined("change_ifrs_code#i#") and len(evaluate("change_ifrs_code#i#"))>'#wrk_eval("change_ifrs_code#i#")#'<cfelse>NULL</cfif>,
			</cfif>
			NAME=<cfif isdefined("change_name#i#") and len(evaluate("change_name#i#"))>'#wrk_eval("change_name#i#")#',<cfelse>NULL,</cfif>
			NAME_LANG_NO=<cfif isdefined("change_name_lang_no_#i#") and len(evaluate("change_name_lang_no_#i#"))>#evaluate("change_name_lang_no_#i#")#,<cfelse>NULL,</cfif>
			VIEW_AMOUNT_TYPE=<cfif isdefined("view_amount_type#i#") and len(evaluate("view_amount_type#i#"))>#evaluate("view_amount_type#i#")#<cfelse>2</cfif>
		WHERE
			CASH_FLOW_ID=#evaluate("selected#i#")#
	</cfquery>
</cfloop>
<cfquery name="GET_FORMER_DEF" datasource="#dsn2#">
	SELECT DEF_ID FROM ACCOUNT_DEFINITIONS WHERE DEF_TYPE_ID=10
</cfquery>
<cfset def_id=get_former_def.DEF_ID>
<cfif not len(def_id)>
	<cfquery name="ADD_DEF" datasource="#dsn2#">
		INSERT INTO
			ACCOUNT_DEFINITIONS(
				DEF_TYPE_ID,
				DEF_TYPE_NAME,
				DEF_SELECTED_ROWS,
				DEF_FORM_TABLE,
				IS_DEPT_CLAIM_DETAIL
			)
			VALUES(
				10,
				'NAKİT AKIM TABLOSU TANIMLARI',
				'#SELECT_LIST#',
				'CASH_FLOW_TABLE',
				<cfif isdefined('attributes.is_dept_claim_detail_') and len(attributes.is_dept_claim_detail_)>#attributes.is_dept_claim_detail_#<cfelse>0</cfif>
			)
	</cfquery>
<cfelse>
	<cfquery name="UPD_DEF" datasource="#dsn2#">
		UPDATE
			ACCOUNT_DEFINITIONS
		SET
			DEF_SELECTED_ROWS='#SELECT_LIST#',
			IS_DEPT_CLAIM_DETAIL=<cfif isdefined('attributes.is_dept_claim_detail_') and len(attributes.is_dept_claim_detail_)>#attributes.is_dept_claim_detail_#<cfelse>0</cfif>
		WHERE
			DEF_ID=#DEF_ID#			
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=account.form_add_cash_flow_def" addtoken="No">
