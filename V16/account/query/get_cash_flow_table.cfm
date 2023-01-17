<cfquery name="GET_CASH_FLOW_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER,
		IS_DEPT_CLAIM_DETAIL
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=10
</cfquery>
<cfif get_cash_flow_def.recordcount>	
	<cfset SELECTED_LIST=GET_CASH_FLOW_DEF.DEF_SELECTED_ROWS>
	<cfquery name="GET_CASH_FLOW" datasource="#dsn2#">
		SELECT
			CASH_FLOW_ID,CODE,SIGN,
			NAME,NAME_LANG_NO,BA,
			<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
			IFRS_CODE AS ACCOUNT_CODE,
			<cfelse>
			ACCOUNT_CODE,
			</cfif>
			VIEW_AMOUNT_TYPE
		FROM
			CASH_FLOW_TABLE
		WHERE
			CASH_FLOW_ID IN (#SELECTED_LIST#) OR
			<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
				IFRS_CODE IS NULL
			<cfelse>
				ACCOUNT_CODE IS NULL
			</cfif>
		ORDER BY CODE
	</cfquery>
	<cfscript>
		inv_rem=GET_CASH_FLOW_DEF.INVERSE_REMAINDER;
		acc_list_=listdeleteduplicates(listsort(valuelist(GET_CASH_FLOW.ACCOUNT_CODE),'text','asc'));
		acc_list_ =listappend(acc_list_,'100,101,102,103'); //donem sonu-bası nakit durum bilgileri icin bu hesaplar eklendi
		//view_amount_type=GET_CASH_FLOW.VIEW_AMOUNT_TYPE;
		if(len(GET_CASH_FLOW_DEF.IS_DEPT_CLAIM_DETAIL)) //borc-alacak durumu detaylı gosterim, suanda sadece nakit akım tablosunda kullanılıyor
			dsp_dept_claim_ = GET_CASH_FLOW_DEF.IS_DEPT_CLAIM_DETAIL;
		else
			dsp_dept_claim_ =0;
	</cfscript>
</cfif>
