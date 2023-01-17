<cf_get_lang_set module_name="cash">
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
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
		PROCESS_CAT_ID = #form.process_cat#
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
	currency_multiplier = '';
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
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_CASH_FROM_CASH" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				CASH_ACTION_FROM_CASH_ID = #FROM_CASH_ID#,
				ACTION_DATE = #attributes.ACTION_DATE#,
				CASH_ACTION_VALUE = #attributes.CASH_ACTION_VALUE#,
				CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#">,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				ACTION_VALUE = #attributes.CASH_ACTION_VALUE*dovizli_islem_multiplier#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.CASH_ACTION_VALUE*dovizli_islem_multiplier/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>	
                <cfif len(attributes.project_id)>
                    ,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
			WHERE
				ACTION_ID = #listfirst(ATTRIBUTES.IDS,',')#
		</cfquery>
		<cfquery name="UPD_CASH_TO_CASH" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				CASH_ACTION_TO_CASH_ID = #TO_CASH_ID#,
				ACTION_DATE = #attributes.ACTION_DATE#,
				CASH_ACTION_VALUE = #attributes.OTHER_CASH_ACT_VALUE#,
				CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.CASH_ACTION_VALUE)>#attributes.CASH_ACTION_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#"><cfelse>NULL</cfif>,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				ACTION_VALUE = #attributes.system_amount#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>	
                <cfif len(attributes.project_id)>
                    ,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
			WHERE
				ACTION_ID = #listlast(ATTRIBUTES.IDS,',')#
		</cfquery>
		<cfscript>
		if(is_account eq 1)
		{
			GET_CASH1_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#FROM_CASH_ID#");
			GET_CASH2_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#TO_CASH_ID#");
			
			if (isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
				str_card_detail = '#attributes.ACTION_DETAIL#';
			else
				str_card_detail = UCase(getLang('main',2744));//VİRMAN(KASADAN KASAYA) İŞLEMİ	
						
			muhasebeci (
				action_id : listfirst(ATTRIBUTES.IDS,','),
				workcube_process_type : process_type,
				workcube_old_process_type :form.old_process_type,
				workcube_process_cat:form.process_cat,
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
				fis_detay : UCase(getLang('main',2744)),//VİRMAN(KASADAN KASAYA) İŞLEMİ	
				belge_no : attributes.paper_number,
				from_branch_id : from_branch_id,
                to_branch_id : to_branch_id,
                acc_project_id : attributes.project_id
			);
		}
		else
			muhasebe_sil(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:form.old_process_type);
		f_kur_ekle_action(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:1,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #listfirst(ATTRIBUTES.IDS,',')#
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_to_cash&event=upd&id=#listfirst(ATTRIBUTES.IDS,',')#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
    <cf_add_log log_type="0" action_id="#listfirst(ATTRIBUTES.IDS,',')#" action_name="#attributes.paper_number# Güncellendi" paper_no="#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.process_type#" data_source="#dsn2#">
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_to_cash&event=upd&id=#listfirst(ATTRIBUTES.IDS,',')#</cfoutput>';
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

