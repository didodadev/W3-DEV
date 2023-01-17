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
	<cfquery name="UPD_BALANCE_SHEET" DATASOURCE="#DSN2#" TIMEOUT="3">
		UPDATE
			BALANCE_SHEET_TABLE
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
			BALANCE_ID=#evaluate("balance_id#i#")#
	</cfquery>
</cfloop>
<cfquery name="GET_FORMER_DEF" datasource="#dsn2#">
	SELECT DEF_ID FROM ACCOUNT_DEFINITIONS WHERE DEF_TYPE_ID=8
</cfquery>
<cfif not len(GET_FORMER_DEF.DEF_ID)>
	<cfquery name="ADD_DEF" datasource="#dsn2#">
		INSERT INTO
			ACCOUNT_DEFINITIONS(
				DEF_TYPE_ID,
				DEF_TYPE_NAME,
				DEF_SELECTED_ROWS,
				DEF_FORM_TABLE,
				INVERSE_REMAINDER
			)
			VALUES(
				8,
				'BILANÇO TABLOSU TANIMLARI',
				'#SELECT_LIST#',
				'BALANCE_SHEET_TABLE',
				<cfif isdefined('attributes.is_inverse_acc')>1<cfelse>0</cfif>
			)
	</cfquery>
<cfelse>
	<cfquery name="UPD_DEF" datasource="#dsn2#">
		UPDATE
			ACCOUNT_DEFINITIONS
		SET
			DEF_SELECTED_ROWS='#SELECT_LIST#',
			INVERSE_REMAINDER=<cfif isdefined('attributes.is_inverse_acc')>1<cfelse>0</cfif>
		WHERE
			DEF_ID=#GET_FORMER_DEF.DEF_ID#			
	</cfquery>
</cfif>
<cfinclude template="get_balance_setup.cfm">
<cfif get_setup_balance.recordcount>
	<cfquery name="upd_setup_bal" datasource="#DSN2#">
		UPDATE
			SETUP_BALANCE_SHEET_LIST
		SET
			ACCOUNT_CODE=<cfif isdefined('attributes.dsp_acc_code')>1<cfelse>0</cfif>,
			ACCOUNT_CODE_NO=<cfif isdefined('attributes.dsp_acc_code_no')>1<cfelse>0</cfif>
	</cfquery>
<cfelse>
	<cfquery name="add_setup_bal" datasource="#DSN2#">
		INSERT INTO
			SETUP_BALANCE_SHEET_LIST
			(
				ACCOUNT_CODE,
				ACCOUNT_CODE_NO
			)
		VALUES
		(
			<cfif isdefined('attributes.dsp_acc_code') >1<cfelse>0</cfif>,
			<cfif isdefined('attributes.dsp_acc_code_no') >1<cfelse>0</cfif>					
		)
	</cfquery>
</cfif>
<cflocation url="#cgi.referer#" addtoken="No"> 
