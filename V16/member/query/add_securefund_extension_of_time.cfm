<cfif len(attributes.extension_time_finish_date)><cf_date tarih="attributes.extension_time_finish_date"></cfif>
<cflock timeout="60" name="#CreateUUID()#">
    <cftransaction>
        <cfscript>
            extension_time = createObject("component","V16.member.cfc.securefund_extension_time");
            extension_time.dsn = dsn;
            extension_time.dsn2 = dsn2;
            rd_money = listfirst(attributes.rd_money,',');
            add_securefund_extension_time= extension_time.ADD_SECUREFUND_EXTENSION_TIME(
                                            securefund_id : '#IIf(IsDefined("attributes.securefund_id"),"attributes.securefund_id",DE(""))#',
                                            process_cat : attributes.process_cat,
                                            detail :'#IIf(IsDefined("attributes.detail"),"attributes.detail",DE(""))#',
                                            rd_money : rd_money,
                                            expense_total :'#IIf(IsDefined("attributes.expense_total"),"attributes.expense_total",DE(""))#',
                                            money_cat_expense :'#IIf(IsDefined("attributes.money_cat_expense"),"attributes.money_cat_expense",DE(""))#',
                                            commission_rate :'#IIf(IsDefined("attributes.commission_rate"),"attributes.commission_rate",DE(""))#',
                                            extension_time_finish_date :'#IIf(IsDefined("attributes.extension_time_finish_date"),"attributes.extension_time_finish_date",DE(""))#'
                                        );
            UPD_SECUREFUND= extension_time.UPD_SECUREFUND(
                securefund_id : '#attributes.securefund_id#',
                extension_time_finish_date :'#IIf(IsDefined("attributes.extension_time_finish_date"),"attributes.extension_time_finish_date",DE(""))#'
            );
            currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
            if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                    if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                        currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
            get_process_type = extension_time.GET_PROCESS_TYPE(process_cat : attributes.process_cat);
            process_type = get_process_type.PROCESS_TYPE;
            is_account = get_process_type.IS_ACCOUNT;
            is_cari = get_process_type.IS_CARI;
            is_account_group = get_process_type.IS_ACCOUNT_GROUP;
            get_company_securefund = extension_time.GET_COMPANY_SECUREFUND(securefund_id : attributes.securefund_id);
        </cfscript>
        <cfscript>
            if(is_cari eq 1 and get_company_securefund.give_take eq 1)
            {
                carici(
                    action_id : attributes.SECUREFUND_ID,
                    action_table : 'COMPANY_SECUREFUND',
                    workcube_process_type : process_type,
                    workcube_old_process_type: get_company_securefund.action_type_id,		
                    process_cat : attributes.process_cat,
                    islem_tarihi : attributes.extension_time_finish_date,
                    account_card_type: 13,
                    action_detail : get_company_securefund.REALESTATE_DETAIL,
                    islem_detay : 'TEMİNAT İŞLEMİ',
                    project_id : get_company_securefund.project_id,
                    from_cmp_id : get_company_securefund.company_id,
                    from_consumer_id : get_company_securefund.consumer_id,
                    acc_type_id : get_company_securefund.action_type_id,
                    currency_multiplier : currency_multiplier,
                    islem_tutari : get_company_securefund.action_value,
                    action_currency : session.ep.money,
                    other_money_value : iif(len(get_company_securefund.action_value2),'get_company_securefund.action_value2',de('')),
                    other_money : rd_money,
                    islem_belge_no : get_company_securefund.paper_no,
                    from_branch_id : iif(len(get_company_securefund.OURCOMP_BRANCH),'get_company_securefund.OURCOMP_BRANCH',de('')),
                    cari_db : dsn,
                    cari_db_alias : dsn2_alias
                );
            }
            else if(is_cari eq 1 and get_company_securefund.give_take eq 0)
            {
                carici(
                    action_id : get_company_securefund.SECUREFUND_ID,
                    action_table : 'COMPANY_SECUREFUND',
                    workcube_process_type : process_type,
                    workcube_old_process_type: get_company_securefund.action_type_id,		
                    process_cat : attributes.process_cat,
                    islem_tarihi : attributes.extension_time_finish_date,
                    account_card_type: 13,
                    action_detail : get_company_securefund.REALESTATE_DETAIL,
                    islem_detay : 'TEMİNAT İŞLEMİ',
                    project_id : get_company_securefund.project_id,
                    to_cmp_id : get_company_securefund.company_id,
                    to_consumer_id : get_company_securefund.consumer_id,
                    acc_type_id : get_company_securefund.action_type_id,
                    currency_multiplier : currency_multiplier,
                    islem_tutari : get_company_securefund.action_value,
                    action_currency : session.ep.money,
                    other_money_value : iif(len(get_company_securefund.action_value2),'get_company_securefund.action_value2',de('')),
                    other_money : rd_money,
                    islem_belge_no : get_company_securefund.paper_no,
                    to_branch_id : iif(len(get_company_securefund.OURCOMP_BRANCH),'get_company_securefund.OURCOMP_BRANCH',de('')),
                    cari_db : dsn,
                    cari_db_alias : dsn2_alias
                );
            }
            else
                cari_sil(action_id:attributes.SECUREFUND_ID,process_type:get_company_securefund.action_type_id,cari_db:dsn,cari_db_alias : dsn2_alias);
            
            if(is_account and len(get_company_securefund.given_acc_code) and len(get_company_securefund.taken_acc_code))
            {
                if(isDefined("get_company_securefund.REALESTATE_DETAIL") and len(get_company_securefund.REALESTATE_DETAIL))
                    str_detail = '#get_company_securefund.REALESTATE_DETAIL# - TEMİNAT İŞLEMİ';
                else
                    str_detail = 'TEMİNAT İŞLEMİ';
                    
                muhasebeci (
                    action_id: attributes.SECUREFUND_ID,
                    belge_no : get_company_securefund.paper_no,
                    workcube_process_type: process_type,
                    workcube_old_process_type: get_company_securefund.action_type_id,
                    workcube_process_cat:attributes.process_cat,
                    account_card_type: 13,
                    company_id: get_company_securefund.company_id,
                    consumer_id:get_company_securefund.consumer_id,
                    islem_tarihi: attributes.extension_time_finish_date,
                    fis_satir_detay: str_detail,
                    borc_hesaplar: get_company_securefund.taken_acc_code,
                    borc_tutarlar: get_company_securefund.action_value,
                    other_amount_borc : iif(len(get_company_securefund.action_value2),'get_company_securefund.action_value2',de('')),
                    other_currency_borc : rd_money,
                    alacak_hesaplar: get_company_securefund.given_acc_code,
                    alacak_tutarlar: get_company_securefund.action_value,
                    other_amount_alacak : iif(len(get_company_securefund.action_value2),'get_company_securefund.action_value2',de('')),
                    other_currency_alacak : rd_money,
                    currency_multiplier : currency_multiplier,
                    fis_detay : 'TEMİNAT İŞLEMİ',
                    to_branch_id : listgetat(session.ep.user_location,2,'-'),
                    acc_project_id : iif((isdefined("get_company_securefund.project_id") and len(get_company_securefund.project_id)),get_company_securefund.project_id,de('')),
                    muhasebe_db : dsn,
                    muhasebe_db_alias : dsn2_alias,
                    is_acc_type : 1
                );
            }
            else
                muhasebe_sil (action_id:attributes.SECUREFUND_ID,process_type:get_company_securefund.action_type_id,muhasebe_db : dsn,muhasebe_db_alias : dsn2_alias);
        </cfscript>
        <cf_workcube_process_cat 
			process_cat="#attributes.process_cat#"
			action_id = "#attributes.securefund_id#"
			action_table="COMPANY_SECUREFUND"
			action_column="SECUREFUND_ID"
			action_page='#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_securefund&event=upd&securefund_id=#attributes.securefund_id#'
			action_db_type = "#dsn#"
			is_action_file = "1"
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
    </cftransaction>	
</cflock>
<script>
    window.location.href = '<cfoutput>#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#attributes.securefund_id#</cfoutput>';
</script>
