<cfif isDefined("attributes.active_period")><cfset form.active_period = attributes.active_period></cfif>
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cari_to_cari&event=addMulti</cfoutput>';
	</script>
	<cfabort>
</cfif>
<!--- guncellemede ve silmede cari ve muhasebe hareketleri silinir --->
<cfif isdefined("attributes.upd_id") and len(attributes.upd_id)>
	<cfquery name="get_all_action" datasource="#dsn2#">
		SELECT ACTION_ID,ACTION_TYPE_ID FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #attributes.upd_id#
	</cfquery>
    <cfset recordnum=get_all_action.recordcount>
	<cfscript>
		for (k = 1; k lte get_all_action.recordcount;k=k+1)
			cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);

		muhasebe_sil(action_id:attributes.upd_id,process_type:430);
	</cfscript>
</cfif>
<cfif isdefined("attributes.is_del")>
	<cfset attributes.del_id = attributes.upd_id>
</cfif>
<cfif isDefined("attributes.del_id") and len(attributes.del_id)>
	<cfquery name="get_all_action" datasource="#dsn2#">
		SELECT ACTION_ID,ACTION_TYPE_ID FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #attributes.del_id#
	</cfquery>
	<cfscript>
		for (k = 1; k lte get_all_action.recordcount;k=k+1)
			cari_sil(action_id:get_all_action.action_id[k],process_type:get_all_action.action_type_id[k]);

		muhasebe_sil(action_id:attributes.del_id,process_type:430);
	</cfscript>
	<cfquery name="del_action" datasource="#dsn2#">
		DELETE FROM CARI_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.del_id#
		DELETE FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.del_id#
		DELETE FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #attributes.del_id#
	</cfquery>
	<script type="text/javascript">
        window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent#</cfoutput>';
    </script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
    SELECT 
        PROCESS_TYPE,
        IS_ACCOUNT,
        IS_BUDGET,
        IS_CARI,
        ACTION_FILE_NAME,
        ACTION_FILE_FROM_TEMPLATE,
        MULTI_TYPE
    FROM 
        SETUP_PROCESS_CAT 
    WHERE 
        PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
    process_type = get_process_type.PROCESS_TYPE;
	multi_type = get_process_type.MULTI_TYPE;
    is_account = get_process_type.IS_ACCOUNT;
    is_cari = get_process_type.IS_CARI;
	to_branch = "";
	from_branch = "";
    for(r=1; r lte attributes.record_num; r=r+1)
        if(evaluate('attributes.row_kontrol#r#') eq 1)
        {
            'attributes.action_value_#r#' = filterNum(evaluate('attributes.action_value_#r#'));
            'attributes.action_value2_#r#' = filterNum(evaluate('attributes.action_value2_#r#'));
        }
    for(k=1; k lte attributes.kur_say; k=k+1)
    {
        'attributes.txt_rate2_#k#' = filterNum(evaluate('attributes.txt_rate2_#k#'),session.ep.our_company_info.rate_round_num);
        'attributes.txt_rate1_#k#' = filterNum(evaluate('attributes.txt_rate1_#k#'),session.ep.our_company_info.rate_round_num);
    }
</cfscript>
<cfloop from="1" to="#attributes.record_num#" index="i">
    <cfif isDate(evaluate("attributes.DUE_DATE#i#"))>
        <cfset temp_date = evaluate("attributes.DUE_DATE#i#")>
        <cf_date tarih="temp_date">
        <cfset 'attributes.DUE_DATE#i#' = temp_date>
    <cfelse>
        <cfset temp_date = evaluate("attributes.DUE_DATE")>
        <cf_date tarih="temp_date">
    	<cfset 'attributes.DUE_DATE#i#' = temp_date>
    </cfif>
</cfloop>
<cfloop from="1" to="#attributes.record_num#" index="i">
    <cfif isdefined("attributes.from_due_date#i#") and isDate(evaluate("attributes.from_due_date#i#"))>
        <cfset temp_date = evaluate("attributes.from_due_date#i#")>
        <cf_date tarih="temp_date">
        <cfset 'attributes.from_due_date#i#' = temp_date>
	<cfelseif isdefined("attributes.from_due_date") and len(evaluate("attributes.from_due_date"))>
        <cfset temp_date = evaluate("attributes.from_due_date")>
        <cf_date tarih="temp_date">
    	<cfset 'attributes.from_due_date#i#' = temp_date>
    </cfif>
</cfloop>
<cf_date tarih="attributes.ACTION_DATE">
<cf_papers paper_type="cari_to_cari">
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
    	<cfif len(attributes.upd_id)>
            <cfquery name="upd_cari_actions_multi" datasource="#dsn2#">
                UPDATE
                    CARI_ACTIONS_MULTI
                SET				
                    PROCESS_CAT = #form.process_cat#,
                    ACTION_TYPE_ID = #process_type#,
                    ACTION_DATE = #attributes.action_date#,
                    IS_ACCOUNT = <cfif get_process_type.is_account eq 1>1<cfelse>0</cfif>,
                    IS_ACCOUNT_TYPE = 13,
                    UPDATE_EMP = #SESSION.EP.USERID#,
                    UPDATE_IP = '#CGI.REMOTE_ADDR#',
                    UPDATE_DATE = #NOW()#
                WHERE
                    MULTI_ACTION_ID = #attributes.upd_id#					
            </cfquery>
            <cfset get_multi_id.MULTI_ID = #attributes.upd_id#>
            <cfquery name="del_rows" datasource="#dsn2#">
                DELETE FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #attributes.upd_id#
            </cfquery>
            <cfscript>
				cari_sil(action_id:attributes.upd_id,process_type:430);
				muhasebe_sil(action_id:attributes.upd_id,process_type:430);
            </cfscript>
        <cfelse>
            <cfquery name="add_cari_actions_multi" datasource="#dsn2#">
                INSERT INTO
                    CARI_ACTIONS_MULTI
                    (
                        PROCESS_CAT,
                        ACTION_TYPE_ID,
                        ACTION_DATE,
                        IS_ACCOUNT,
                        IS_ACCOUNT_TYPE,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE				
                    )
                    VALUES
                    (
                        #form.process_cat#,
                        #process_type#,
                        #attributes.action_date#,
                        <cfif get_process_type.is_account eq 1>1,13,<cfelse>0,13,</cfif>
                        #SESSION.EP.USERID#,
                        '#CGI.REMOTE_ADDR#',
                        #NOW()#				
                    )
            </cfquery>
            <cfquery name="get_multi_id" datasource="#dsn2#">
                SELECT MAX(MULTI_ACTION_ID) AS MULTI_ID FROM CARI_ACTIONS_MULTI
            </cfquery>
        </cfif>
        <cfscript>
			str_alacakli_hesaplar = '';
			from_branch = '';
			to_branch = '';
			str_alacakli_tutarlar = '';
			str_alacakli_other_amount_tutar = '';
			str_alacakli_other_currency = '';
			str_borclu_hesaplar = '';
			str_borclu_tutarlar = '';
			str_borclu_other_amount_tutar = '';
			str_borclu_other_currency = '';
			
			acc_project_list_alacak = '';
			acc_project_list_borc = '';
			
			
			paper_currency_multiplier = '';
			paper_currency_multiplier2 = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money)
						paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						paper_currency_multiplier2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
	
			currency_multiplier = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
					if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		</cfscript>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
            
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfif len(paper_number)>
                    	<cfif not (isdefined("attributes.upd_id") and len(attributes.upd_id))>
							<cfset paper_number = paper_number + 1>
                        </cfif>
                    </cfif>
                    <cfscript>
						attributes.to_acc_type_id = '';
						attributes.from_acc_type_id = '';
						if(listlen(evaluate('attributes.to_employee_id#i#'),'_') eq 2)
						{
							attributes.to_acc_type_id = listlast(evaluate('attributes.to_employee_id#i#'),'_');
							attributes.to_employee_id = listfirst(evaluate('attributes.to_employee_id#i#'),'_');
						}
						else
						{
							attributes.to_employee_id = evaluate('attributes.to_employee_id#i#');
						}
						if(listlen(evaluate('attributes.from_employee_id#i#'),'_') eq 2)
						{
							attributes.from_acc_type_id = listlast(evaluate('attributes.from_employee_id#i#'),'_');
							attributes.from_employee_id = listfirst(evaluate('attributes.from_employee_id#i#'),'_');
						}
						else
						{
							attributes.from_employee_id = evaluate('attributes.from_employee_id#i#');
						}
						if(listlen(evaluate('attributes.to_company_id#i#'),'_') eq 2)
						{
							attributes.to_acc_type_id = listlast(evaluate('attributes.to_company_id#i#'),'_');
							attributes.to_company_id = listfirst(evaluate('attributes.to_company_id#i#'),'_');
						}
						else{
							attributes.to_company_id = evaluate('attributes.to_company_id#i#');
						}
						if(listlen(evaluate('attributes.from_company_id#i#'),'_') eq 2)
						{
							attributes.from_acc_type_id = listlast(evaluate('attributes.from_company_id#i#'),'_');
							attributes.from_company_id = listfirst(evaluate('attributes.from_company_id#i#'),'_');
						}
						else{
							attributes.from_company_id = evaluate('attributes.from_company_id#i#');
						}
						if(listlen(evaluate('attributes.to_consumer_id#i#'),'_') eq 2)
						{
							attributes.to_acc_type_id = listlast(evaluate('attributes.to_consumer_id#i#'),'_');
							attributes.to_consumer_id = listfirst(evaluate('attributes.to_consumer_id#i#'),'_');
						}
						else{
							attributes.to_consumer_id = evaluate('attributes.to_consumer_id#i#');
						}
						if(listlen(evaluate('attributes.from_consumer_id#i#'),'_') eq 2)
						{
							attributes.from_acc_type_id = listlast(evaluate('attributes.from_consumer_id#i#'),'_');
							attributes.from_consumer_id = listfirst(evaluate('attributes.from_consumer_id#i#'),'_');
						}
						else{
							attributes.from_consumer_id = evaluate('attributes.from_consumer_id#i#');
						}
						if(isdefined("attributes.subscription_id2#i#") and len(evaluate('attributes.subscription_id2#i#')))
						{
							attributes.subscription_id2 = evaluate('attributes.subscription_id2#i#');
							attributes.subscription_no2 = evaluate('attributes.subscription_no2#i#');
						}
						if(isdefined("attributes.subscription_id#i#") and len(evaluate('attributes.subscription_id#i#')))
						{
							attributes.subscription_id = evaluate('attributes.subscription_id#i#');
							attributes.subscription_no = evaluate('attributes.subscription_no#i#');
						}
						rowRate = listGetAt(evaluate('attributes.money_id#i#'),3,';')/listGetAt(evaluate('attributes.money_id#i#'),2,';');
					</cfscript>
                    <cfquery name="ADD_CARI_TO_CARI" datasource="#DSN2#" result="MAX_ID">
                        INSERT INTO
                            CARI_ACTIONS
                        (
                        	PROCESS_CAT,
                        	MULTI_ACTION_ID,
                            ACTION_NAME,
                            ACTION_TYPE_ID,	
                            ACTION_VALUE,
                            ACTION_CURRENCY_ID,
                            TO_CMP_ID,
                            TO_CONSUMER_ID,
                            TO_EMPLOYEE_ID,
                            FROM_CMP_ID,
                            FROM_CONSUMER_ID,
                            FROM_EMPLOYEE_ID,
                            OTHER_CASH_ACT_VALUE,
                            OTHER_MONEY,
                            PROJECT_ID,
                            PROJECT_ID_2,
                            ACTION_DETAIL,
                            ACTION_DATE,
							DUE_DATE,
                            PAPER_NO,
                            ASSETP_ID,
                            ASSETP_ID_2,
                            ACC_TYPE_ID,
                            FROM_ACC_TYPE_ID,
                            TO_BRANCH_ID,
                            FROM_BRANCH_ID,     
							TO_SUBSCRIPTION_ID,
							SUBSCRIPTION_ID,         
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
							FROM_DUE_DATE		
                        )
                        VALUES
                        (
                        	#form.process_cat#,
                        	#get_multi_id.multi_id#,
                            'CARİ VİRMAN',
                            43,
                            #evaluate('attributes.action_value_#i#')#,
                            <cfif len(evaluate('attributes.money_id#i#'))>'#ListFirst(evaluate('attributes.money_id#i#'),';')#'<cfelse>NULL</cfif>,
                            <cfif len(attributes.to_company_id)>#attributes.to_company_id#<cfelse>NULL</cfif>,
                            <cfif len(attributes.to_consumer_id)>#attributes.to_consumer_id#<cfelse>NULL</cfif>,
                            <cfif len(attributes.to_employee_id)>#attributes.to_employee_id#<cfelse>NULL</cfif>,
                            <cfif len(attributes.from_company_id)>#attributes.from_company_id#<cfelse>NULL</cfif>,
                            <cfif len(attributes.from_consumer_id)>#attributes.from_consumer_id#<cfelse>NULL</cfif>,
                            <cfif len(attributes.from_employee_id)>#attributes.from_employee_id#<cfelse>NULL</cfif>,
                            #evaluate('attributes.action_value2_#i#')#,
                            <cfif len(attributes.rd_money)>'#ListFirst(attributes.rd_money,',')#'<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.from_project_id#i#')) and len(evaluate('attributes.from_project_head#i#'))>#evaluate('attributes.from_project_id#i#')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.to_project_id#i#')) and len(evaluate('attributes.to_project_head#i#'))>#evaluate('attributes.to_project_id#i#')#<cfelse>NULL</cfif>,
                            '#evaluate('attributes.action_detail#i#')#',
                            #evaluate('attributes.action_date')#,
							#evaluate('attributes.due_date#i#')#,
                            <cfif len(evaluate('attributes.paper_number#i#'))>'#evaluate('attributes.paper_number#i#')#'<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.from_asset_id#i#')) and len(evaluate('attributes.from_asset_name#i#'))>#evaluate('attributes.from_asset_id#i#')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.to_asset_id#i#')) and len(evaluate('attributes.to_asset_name#i#'))>#evaluate('attributes.to_asset_id#i#')#<cfelse>NULL</cfif>,
                            <cfif len(attributes.to_acc_type_id)>#attributes.to_acc_type_id#<cfelse>NULL</cfif>,
                            <cfif len(attributes.from_acc_type_id)>#attributes.from_acc_type_id#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.to_branch_id#i#'))>#evaluate('attributes.to_branch_id#i#')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.from_branch_id#i#'))>#evaluate('attributes.from_branch_id#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.subscription_id2") and len(attributes.subscription_id2)and len(attributes.subscription_no2)>#attributes.subscription_id2#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#',
							<cfif len(evaluate('attributes.from_due_date#i#'))>#evaluate('attributes.from_due_date#i#')#<cfelse>NULL</cfif>		
                        )					
                    </cfquery>
					<cfscript>
						system_action_value = evaluate("attributes.action_value_#i#")*rowRate; //sistem para birimi karşılığı
						system_action_value2 = system_action_value / paper_currency_multiplier2;
						if(is_account eq 1)
						{
							if(len(evaluate("from_company_id#i#")))
								account_acc_code = get_company_period(attributes.from_company_id,session.ep.period_id,dsn2,attributes.from_acc_type_id);
							else if(len(evaluate("from_consumer_id#i#")))
								account_acc_code = get_consumer_period(attributes.from_consumer_id,session.ep.period_id,dsn2,attributes.from_acc_type_id);
							else
								account_acc_code = GET_EMPLOYEE_PERIOD(attributes.from_employee_id,attributes.from_acc_type_id);
							
							str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,account_acc_code,",");
							str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,system_action_value,",");
							str_alacakli_other_amount_tutar = ListAppend(str_alacakli_other_amount_tutar,evaluate("attributes.action_value2_#i#"),",");
							str_alacakli_other_currency = ListAppend(str_alacakli_other_currency,'#listfirst(attributes.rd_money,',')#');
							if(isdefined("attributes.to_branch_id#i#") and len(evaluate('attributes.to_branch_id#i#')))
								to_branch = ListAppend(to_branch,#evaluate('attributes.to_branch_id#i#')#);
							else
								to_branch = ListAppend(to_branch,listgetat(session.ep.user_location,2,'-'));
							if(isdefined("attributes.from_branch_id#i#") and len(evaluate('attributes.from_branch_id#i#')))
								from_branch = ListAppend(from_branch,#evaluate('attributes.from_branch_id#i#')#);
							else
								from_branch = ListAppend(from_branch,listgetat(session.ep.user_location,2,'-'));
							if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
								satir_detay_list[1][listlen(str_alacakli_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
							else if(evaluate("attributes.money_id#i#") is session.ep.money)
								satir_detay_list[1][listlen(str_alacakli_tutarlar)] = 'TOPLU CARİ VİRMAN İŞLEMİ';
							else
								satir_detay_list[1][listlen(str_alacakli_tutarlar)] = 'DÖVİZLİ TOPLU CARİ VİRMAN İŞLEMİ';
							
							if(len(evaluate("to_company_id#i#")))
								account_acc_code2 = get_company_period(attributes.to_company_id,session.ep.period_id,dsn2,attributes.to_acc_type_id);
							else if(len(evaluate("to_consumer_id#i#")))
								account_acc_code2 =  get_consumer_period(attributes.to_consumer_id,session.ep.period_id,dsn2,attributes.to_acc_type_id);
							else
								account_acc_code2 = GET_EMPLOYEE_PERIOD(attributes.to_employee_id,attributes.to_acc_type_id);
							
							str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,account_acc_code2,",");
							str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,system_action_value,",");
							str_borclu_other_amount_tutar = ListAppend(str_borclu_other_amount_tutar,evaluate("attributes.action_value_#i#"),",");
							str_borclu_other_currency = ListAppend(str_borclu_other_currency,'#ListFirst(evaluate('attributes.money_id#i#'),";")#');
							if(isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#")))
								satir_detay_list[2][listlen(str_borclu_tutarlar)] = '#evaluate("attributes.action_detail#i#")#';
							else if(evaluate("attributes.money_id#i#") is session.ep.money)
								satir_detay_list[2][listlen(str_borclu_tutarlar)] = 'TOPLU CARİ VİRMAN İŞLEMİ';
							else
								satir_detay_list[2][listlen(str_borclu_tutarlar)] = 'DÖVİZLİ TOPLU CARİ VİRMAN İŞLEMİ';
							
                            if(isdefined("attributes.to_project_id#i#") and len(evaluate("attributes.to_project_id#i#")) and isdefined("attributes.to_project_head#i#") and len(evaluate("attributes.to_project_head#i#")))
                            {
                                acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.to_project_id#i#"),',');
                            }
                            else
                            {
                                acc_project_list_borc = listappend(acc_project_list_borc,'0',',');
                            }
                            if(isdefined("attributes.from_project_id#i#") and len(evaluate("attributes.from_project_id#i#")) and isdefined("attributes.from_project_head#i#") and len(evaluate("attributes.from_project_head#i#")))
                            {
                                acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.from_project_id#i#"),',');
                            }
                            else
                            {
                                acc_project_list_alacak = listappend(acc_project_list_alacak,'0',',');
                            }
						}	
						if(is_cari eq 1)
						{
							carici(
								action_id : MAX_ID.IDENTITYCOL,
								islem_belge_no : evaluate("attributes.paper_number#i#"),
								process_cat : form.process_cat,
								workcube_process_type : 43,
								action_table : 'CARI_ACTIONS',
								islem_tutari : system_action_value,
								action_currency : session.ep.money,
								other_money_value : evaluate("attributes.action_value2_#i#"),
								other_money : listfirst(attributes.rd_money,','),
								islem_tarihi : evaluate("attributes.action_date"),
								due_date : evaluate("attributes.from_due_date#i#"),
								islem_detay : 'TOPLU CARİ VİRMAN',
								action_detail : evaluate("attributes.action_detail#i#"),
								from_cmp_id : attributes.from_company_id,
								from_consumer_id : attributes.from_consumer_id,
								from_employee_id : attributes.from_employee_id,		
								currency_multiplier : currency_multiplier,
								account_card_type : 13,
								acc_type_id : attributes.from_acc_type_id,
								subscription_id : isdefined("attributes.subscription_id2") and len(attributes.subscription_id2) ? attributes.subscription_id2 : '',
								project_id : iif(len(evaluate("attributes.from_project_id#i#")) and len(evaluate("attributes.from_project_head#i#")),evaluate("attributes.from_project_id#i#"),de('')),
								from_branch_id : evaluate("attributes.from_branch_id#i#"),
								action_value2 : system_action_value2,
								assetp_id : evaluate("attributes.from_asset_id#i#")
								);
								
							carici(
								action_id : MAX_ID.IDENTITYCOL,
								islem_belge_no : evaluate("attributes.paper_number#i#"),
								process_cat : form.process_cat,
								workcube_process_type : 43,
								action_table : 'CARI_ACTIONS',
								islem_tutari : system_action_value,
								action_currency : session.ep.money,
								other_money_value : evaluate("attributes.action_value_#i#"),
								other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
								islem_tarihi : evaluate("attributes.action_date"),
								due_date : evaluate("attributes.due_date#i#"),
								islem_detay : 'TOPLU CARİ VİRMAN',
								action_detail : evaluate("attributes.action_detail#i#"),
								to_cmp_id : attributes.to_company_id,
								to_consumer_id : attributes.to_consumer_id,
								to_employee_id : attributes.to_employee_id,		
								currency_multiplier : currency_multiplier,
								account_card_type : 13,
								acc_type_id : attributes.to_acc_type_id,
								subscription_id : isdefined("attributes.subscription_id") and len(attributes.subscription_id) ? attributes.subscription_id : '',
								project_id : iif(len(evaluate("attributes.to_project_id#i#")) and len(evaluate("attributes.to_project_head#i#")),evaluate("attributes.to_project_id#i#"),de('')),
								to_branch_id : evaluate("attributes.to_branch_id#i#"),
								action_value2 : system_action_value2,
								assetp_id : evaluate("attributes.to_asset_id#i#")
								);
						}
					</cfscript>
				</cfif>
			</cfloop>
			<cfscript>
				if(is_account eq 1)
				{
					muhasebeci(
						action_id : get_multi_id.multi_id,
						workcube_process_type: multi_type,
						workcube_process_cat : form.process_cat,
						account_card_type : 13,
						islem_tarihi : attributes.action_date,
						fis_satir_detay : satir_detay_list,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borclu_tutarlar,
						other_amount_borc : str_borclu_other_amount_tutar,
						other_currency_borc : str_borclu_other_currency,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						other_amount_alacak : str_alacakli_other_amount_tutar,
						other_currency_alacak : str_alacakli_other_currency,
						currency_multiplier : currency_multiplier,
						fis_detay:'TOPLU CARİ VİRMAN İŞLEMİ',
                        acc_project_list_alacak : acc_project_list_alacak,
                        acc_project_list_borc : acc_project_list_borc,
						acc_branch_list_borc : to_branch,
						acc_branch_list_alacak : from_branch
					);
				}
			</cfscript>
		</cfif>
        <cfquery name="del_action_money" datasource="#dsn2#">
        	DELETE FROM CARI_ACTION_MULTI_MONEY WHERE ACTION_ID = #get_multi_id.MULTI_ID#
        </cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="add_action_money" datasource="#dsn2#">
				INSERT INTO 
					CARI_ACTION_MULTI_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_multi_id.MULTI_ID#,
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						#evaluate("attributes.txt_rate2_#i#")#,
						#evaluate("attributes.txt_rate1_#i#")#,
						<cfif evaluate("attributes.hidden_rd_money_#i#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<!--- Belge No update ediliyor --->
		<cfif Len(paper_number)>
        	<cfif isdefined("attributes.upd_id") and len(attributes.upd_id) and attributes.record_num gt recordnum>
            	<cfset paper_number = paper_number+attributes.record_num-recordnum-1>
            <cfelse>
            	<cfset paper_number = paper_number-1>
            </cfif>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					CARI_TO_CARI_NUMBER = #paper_number#
				WHERE
					CARI_TO_CARI_NUMBER IS NOT NULL
			</cfquery>	
		</cfif>
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #get_multi_id.multi_id#
            is_action_file = 1
            action_file_name='#get_process_type.action_file_name#'
            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cari_to_cari&event=updMulti&upd_id=#get_multi_id.multi_id#'
            action_db_type = '#dsn2#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId=get_multi_id.multi_id>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_cari_to_cari&event=updMulti&upd_id=#get_multi_id.multi_id#</cfoutput>';
</script>