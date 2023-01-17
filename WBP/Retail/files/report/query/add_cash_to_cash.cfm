<cf_get_lang_set module_name="cash">
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>
<cf_date tarih='attributes.ACTION_DATE'>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari = get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	FROM_CASH_ID = listfirst(attributes.FROM_CASH_ID,';');
	ACTION_CURRENCY_ID = listgetat(attributes.FROM_CASH_ID,2,';');
	TO_CURRENCY_ID = listgetat(attributes.TO_CASH_ID,2,';');
	TO_CASH_ID = listfirst(attributes.TO_CASH_ID,';');
	to_branch_id = listlast(attributes.TO_CASH_ID,';');
	from_branch_id = listlast(attributes.FROM_CASH_ID,';');
	currency_multiplier = '1';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is ACTION_CURRENCY_ID)
				dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is TO_CURRENCY_ID)
				dovizli_islem_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cf_papers paper_type="cash_to_cash">
<cflock name="#createUUID()#" timeout="60">
<cftransaction>
	<cfquery name="ADD_CASH_TO_CASH" datasource="#DSN2#">
		INSERT INTO
			CASH_ACTIONS
		(
			PROCESS_CAT,
			ACTION_TYPE,
			ACTION_TYPE_ID,
			CASH_ACTION_FROM_CASH_ID,
			ACTION_DATE,
			CASH_ACTION_VALUE,
			CASH_ACTION_CURRENCY_ID,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,
			ACTION_DETAIL,
			PAPER_NO,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			WITH_NEXT_ROW,
			ACTION_VALUE,
			ACTION_CURRENCY_ID
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2
				,ACTION_CURRENCY_ID_2
			</cfif>
		)
		VALUES
		(
			#form.process_cat#,
			'VİRMAN',
			#process_type#,
			#FROM_CASH_ID#,
			#attributes.ACTION_DATE#,
			#attributes.CASH_ACTION_VALUE#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#">,
			<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#,<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.ACTION_DETAIL") AND len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
			<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
			#SESSION.EP.USERID#,
			#NOW()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			1,
			#attributes.CASH_ACTION_VALUE*dovizli_islem_multiplier#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
			<cfif len(session.ep.money2)>
				,#wrk_round(attributes.CASH_ACTION_VALUE*dovizli_islem_multiplier/currency_multiplier,4)#
				,'#session.ep.money2#'
			</cfif>
		)
	</cfquery>
	<cfquery name="ADD_CASH_FROM_CASH" datasource="#DSN2#">
		INSERT INTO
			CASH_ACTIONS
		(
			PROCESS_CAT,
			ACTION_TYPE,
			ACTION_TYPE_ID,
			CASH_ACTION_TO_CASH_ID,
			ACTION_DATE,
			CASH_ACTION_VALUE,
			CASH_ACTION_CURRENCY_ID,
			OTHER_CASH_ACT_VALUE,
			OTHER_MONEY,
			ACTION_DETAIL,
			PAPER_NO,
			IS_ACCOUNT,
			IS_ACCOUNT_TYPE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			WITH_NEXT_ROW,
			ACTION_VALUE,
			ACTION_CURRENCY_ID
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2
				,ACTION_CURRENCY_ID_2
			</cfif>
		)
		VALUES
		(
			#form.process_cat#,
			'VİRMAN',
			#process_type#,
			#TO_CASH_ID#,
			#attributes.ACTION_DATE#,
			#attributes.OTHER_CASH_ACT_VALUE#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
			<cfif isDefined("attributes.CASH_ACTION_VALUE") and len(attributes.CASH_ACTION_VALUE)>#attributes.CASH_ACTION_VALUE#,<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#">,<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.ACTION_DETAIL") AND len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
			<cfif is_account eq 1>1,13,<cfelse>0,13,</cfif>
			#SESSION.EP.USERID#,
			#NOW()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			0,
			#attributes.system_amount#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
			<cfif len(session.ep.money2)>
				,#wrk_round(attributes.system_amount/currency_multiplier,4)#
				,'#session.ep.money2#'
			</cfif>
		)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#DSN2#">
		SELECT	MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
	</cfquery>
	<cfset CASH_ACT_ID = GET_ACT_ID.ACT_ID-1>
	<cfscript>
		if(is_account eq 1)
		{
			GET_CASH1_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#FROM_CASH_ID#");
			GET_CASH2_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#TO_CASH_ID#");
			
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else
				str_card_detail = 'VİRMAN(KASADAN KASAYA) İŞLEMİ';	
			
			muhasebeci (
				action_id : CASH_ACT_ID,
				workcube_process_type : process_type,
				workcube_process_cat : form.process_cat,
				account_card_type : 13,
				islem_tarihi : attributes.ACTION_DATE,
				borc_hesaplar : get_cash2_acc_code.CASH_ACC_CODE,
				borc_tutarlar : attributes.system_amount,
				other_amount_borc : wrk_round(attributes.system_amount/dovizli_islem_multiplier_2),
				other_currency_borc : TO_CURRENCY_ID,
				alacak_hesaplar : get_cash1_acc_code.CASH_ACC_CODE,
				alacak_tutarlar : attributes.system_amount,
				other_amount_alacak : attributes.CASH_ACTION_VALUE,
				other_currency_alacak : ACTION_CURRENCY_ID,
				currency_multiplier : currency_multiplier,
				fis_satir_detay : str_card_detail,
				fis_detay : 'VİRMAN(KASADAN KASAYA) İŞLEMİ',
				belge_no : attributes.paper_number,
				from_branch_id : from_branch_id,
				to_branch_id : to_branch_id
				);
		}
		f_kur_ekle_action(action_id:CASH_ACT_ID,process_type:0,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
	</cfscript>
	<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
		UPDATE 
			#dsn3_alias#.GENERAL_PAPERS
		SET
			CASH_TO_CASH_NUMBER = #paper_number#
		WHERE
			CASH_TO_CASH_NUMBER IS NOT NULL
	</cfquery>
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = "#CASH_ACT_ID#"
		is_action_file = 1
		action_file_name='#get_process_type.action_file_name#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_cash_to_cash&id=#CASH_ACT_ID#'
		action_db_type = '#dsn2#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">