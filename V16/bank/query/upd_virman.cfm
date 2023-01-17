<cf_get_lang_set module_name="bank">
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_bank_actions</cfoutput>';
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
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	attributes.ACTION_VALUE = filterNum(attributes.ACTION_VALUE);
	attributes.OTHER_CASH_ACT_VALUE= filterNum(attributes.OTHER_CASH_ACT_VALUE);
	attributes.system_amount = filterNum(attributes.system_amount);
	attributes.masraf = filterNum(attributes.masraf);
	for(t=1;t lte attributes.kur_say;t=t+1)
	{
		'attributes.txt_rate1_#t#' = filterNum(evaluate("attributes.txt_rate1_#t#"),session.ep.our_company_info.rate_round_num) ;
		'attributes.txt_rate2_#t#' = filterNum(evaluate("attributes.txt_rate2_#t#"),session.ep.our_company_info.rate_round_num) ;
	}
	//borclu sube
	if(isdefined("attributes.branch_id_borc") and len(attributes.branch_id_borc))
		to_branch_id_info = attributes.branch_id_borc;
	else
		to_branch_id_info = listgetat(session.ep.user_location,2,'-');	
	//alacakli sube	
	if(isdefined("attributes.branch_id_alacak") and len(attributes.branch_id_alacak))
		from_branch_id_info = attributes.branch_id_alacak;
	else
		from_branch_id_info = listgetat(session.ep.user_location,2,'-');	
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				masraf_curr_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id)
				dovizli_islem_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.currency_id2)
				dovizli_islem_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		 }
</cfscript>
<cfquery name="control_paper_no" datasource="#dsn2#">
	SELECT PAPER_NO FROM BANK_ACTIONS WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"> AND ACTION_ID NOT IN (#attributes.IDS#)
</cfquery>
<cfif control_paper_no.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='348.Girdiginiz Belge Numarası Kullanılmaktadır'>!");
		history.back();	
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.ACTION_DATE'>
<cfif not len(attributes.masraf)>
	<cfset attributes.masraf = 0>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_VIRMAN" datasource="#dsn2#">
			UPDATE 
				BANK_ACTIONS
			SET
				PROCESS_CAT= #form.process_cat#,
				ACTION_VALUE=<cfif len(attributes.masraf)>#attributes.ACTION_VALUE + attributes.masraf#,<cfelse>#attributes.ACTION_VALUE#,</cfif>
				ACTION_DATE=#attributes.ACTION_DATE#,
				ACTION_CURRENCY_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				ACTION_FROM_ACCOUNT_ID=#attributes.from_account_id#,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				OTHER_CASH_ACT_VALUE= <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				IS_ACCOUNT = <cfif is_account eq 1>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				MASRAF = <cfif len(attributes.masraf) and  attributes.masraf gt 0>#attributes.masraf#,<cfelse>0,</cfif>
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #NOW()#,
				FROM_BRANCH_ID = #from_branch_id_info#,
				SYSTEM_ACTION_VALUE = #wrk_round((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)#,
				SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(((attributes.ACTION_VALUE + attributes.masraf)*dovizli_islem_multiplier)/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
                <cfif len(attributes.project_id)>
                    ,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
			WHERE
				ACTION_ID = #listfirst(ATTRIBUTES.IDS,',')#
		</cfquery>
		<cfquery name="UPD_VIRMAN2" datasource="#dsn2#">
			UPDATE 
				BANK_ACTIONS
			SET
				PROCESS_CAT= #form.process_cat#,
				ACTION_VALUE=#attributes.OTHER_CASH_ACT_VALUE#,
				ACTION_DATE=#attributes.ACTION_DATE#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,
				ACTION_TO_ACCOUNT_ID = #attributes.to_account_id#,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				OTHER_CASH_ACT_VALUE= #attributes.ACTION_VALUE#,
				OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				IS_ACCOUNT = <cfif is_account eq 1>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 13,
				PAPER_NO = <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
				MASRAF = 0,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#,
				TO_BRANCH_ID = #to_branch_id_info#,
				SYSTEM_ACTION_VALUE = #wrk_round(attributes.system_amount)#,
				SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round((attributes.OTHER_CASH_ACT_VALUE*masraf_curr_multiplier)/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
                <cfif len(attributes.project_id)>
                    ,PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
			WHERE
				ACTION_ID = #listlast(ATTRIBUTES.IDS,',')#
		</cfquery>
		<cfscript>
			butce_sil(action_id:attributes.id,process_type:form.old_process_type);
			if(len(attributes.expense_item_id) and len(attributes.expense_item_name) and len (attributes.masraf) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center_name))
			{
				if(attributes.currency_id is session.ep.money)
				{
					butceci(
						action_id : listfirst(ATTRIBUTES.IDS,','),
						muhasebe_db : dsn2,
						is_income_expense : false,
						process_type : process_type,
						nettotal : attributes.masraf,
						other_money_value : wrk_round(attributes.masraf/masraf_curr_multiplier),
						action_currency : form.money_type,
						currency_multiplier : currency_multiplier,
						expense_date : attributes.action_date,
						expense_center_id : attributes.expense_center_id,
						expense_item_id : attributes.expense_item_id,
						detail : UCase(getLang('main',2700)), //VİRMAN MASRAFI
						paper_no : attributes.paper_number,
						branch_id : from_branch_id_info,
                        insert_type : 1,
                        project_id : attributes.project_id
					);
				}
				else
				{
					butceci(
						action_id : listfirst(ATTRIBUTES.IDS,','),
						muhasebe_db : dsn2,
						is_income_expense : false,
						process_type : process_type,
						nettotal : wrk_round(attributes.masraf*dovizli_islem_multiplier),
						other_money_value : attributes.masraf,
						action_currency : attributes.currency_id,
						currency_multiplier : currency_multiplier,
						expense_date : attributes.action_date,
						expense_center_id : attributes.expense_center_id,
						expense_item_id : attributes.expense_item_id,
						detail : UCase(getLang('main',2700)), //VİRMAN MASRAFI
						paper_no : attributes.paper_number,
						branch_id : from_branch_id_info,
                        insert_type : 1,
                        project_id : attributes.project_id
					);
				}
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
			}
			if(is_account eq 1)
			{
				acc_branch_list_borc = '';
				acc_branch_list_alacak = '';
				acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
				acc_branch_list_borc = listappend(acc_branch_list_borc,to_branch_id_info,',');
				if(isDefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL))
					str_card_detail = '#attributes.ACTION_DETAIL#';
				else if(attributes.currency_id is session.ep.money)
					str_card_detail = UCase(getLang('main',2724)); //VİRMAN HESAP İŞLEMİ
				else
					str_card_detail = UCase(getLang('main',2725));//DÖVİZLİ VİRMAN HESAP İŞLEMİ
			
				str_borclu_hesaplar = attributes.account_acc_code2;
				str_alacakli_hesaplar = attributes.account_acc_code;
				str_tutarlar = attributes.system_amount;
			
				str_borclu_other_amount_tutar = wrk_round(attributes.system_amount/dovizli_islem_multiplier_2);
				str_borclu_other_currency = attributes.currency_id2;
				str_alacakli_other_amount_tutar = attributes.ACTION_VALUE;
				str_alacakli_other_currency = attributes.currency_id;
						
				if(len(attributes.masraf) and attributes.masraf gt 0 and len(GET_EXP_ACC.ACCOUNT_CODE))
				{
					acc_branch_list_alacak = listappend(acc_branch_list_alacak,from_branch_id_info,',');
					acc_branch_list_borc = listappend(acc_branch_list_borc,from_branch_id_info,',');
					str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,GET_EXP_ACC.ACCOUNT_CODE,",");	
					str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,attributes.account_acc_code,",");	
					
					if(attributes.currency_id is session.ep.money)
					{
						masraf_doviz = wrk_round(attributes.masraf/masraf_curr_multiplier);
						str_tutarlar = ListAppend(str_tutarlar,attributes.masraf,",");
					}
					else
					{
						masraf_doviz = wrk_round(attributes.masraf*dovizli_islem_multiplier);
						str_tutarlar = ListAppend(str_tutarlar,masraf_doviz,",");
					}
					str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,attributes.masraf,",");
					str_borclu_other_currency = ListAppend(str_borclu_other_currency,attributes.currency_id,",");
					str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,attributes.masraf,",");
					str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,attributes.currency_id,",");
				}
				muhasebeci(
					action_id:listfirst(ATTRIBUTES.IDS,','),
					workcube_process_type:process_type,
					workcube_old_process_type:form.old_process_type,
					workcube_process_cat:form.process_cat,
					account_card_type:13,
					islem_tarihi: attributes.ACTION_DATE,
					fis_satir_detay:str_card_detail,
					borc_hesaplar:str_borclu_hesaplar,
					borc_tutarlar:str_tutarlar,
					other_amount_borc : str_borclu_other_amount_tutar,
					other_currency_borc : str_borclu_other_currency,
					alacak_hesaplar:str_alacakli_hesaplar,
					alacak_tutarlar:str_tutarlar,
					other_amount_alacak : str_alacakli_other_amount_tutar,
					other_currency_alacak : str_alacakli_other_currency,
					currency_multiplier : currency_multiplier,
					fis_detay : UCase(getLang('main',2724)),
					acc_branch_list_borc : acc_branch_list_borc,
					acc_branch_list_alacak : acc_branch_list_alacak,
                    belge_no : attributes.paper_number,
                    acc_project_id : attributes.project_id
				);
			}
			else
				muhasebe_sil(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:form.old_process_type);
	
			f_kur_ekle_action(action_id:listfirst(ATTRIBUTES.IDS,','),process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi DT20141001 --->
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #listfirst(ATTRIBUTES.IDS,',')#
            is_action_file = 1
            action_file_name='#get_process_type.action_file_name#'
            action_db_type = '#dsn2#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_virman&event=upd&id=#listfirst(ATTRIBUTES.IDS,',')#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
            <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#listfirst(ATTRIBUTES.IDS,',')#" action_name= "#attributes.paper_number# Güncellendi" paper_no= "#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_virman&event=upd&id=#listfirst(ATTRIBUTES.IDS,',')#</cfoutput>';
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
