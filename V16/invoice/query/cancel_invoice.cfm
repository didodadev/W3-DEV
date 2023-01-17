<cfif isdefined("attributes.expense_id")>
	<cfquery name="CONTROL_EINVOICE" datasource="#DSN2#">
        SELECT STATUS,PROFILE_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
    </cfquery>
<cfelse>
	<cfquery name="CONTROL_EINVOICE" datasource="#DSN2#">
        SELECT STATUS,PROFILE_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND ACTION_TYPE = 'INVOICE'
    </cfquery>
</cfif>

<cfif control_einvoice.profile_id eq 'TICARIFATURA' and control_einvoice.status neq 0>
	<script>
		alert("Red edilmemiş Ticari Faturanın İptal İşlemini Yapamazsınız !");
		this.close();
	</script>
    <cfabort>
</cfif>

<cfif isdefined("attributes.invoice_id")>
    <cfset form.invoice_id=attributes.invoice_id>
	<cflock name="#CreateUUID()#" timeout="20">
    <cftransaction>
    	<cf_date tarih = "attributes.invoice_date">
    	<cfquery name="get_inv_det" datasource="#dsn2#">
        	SELECT INVOICE_CAT,CASH_ID,INVOICE_DATE,PROCESS_CAT FROM INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
        </cfquery>
        <cfquery name="get_ship_id" datasource="#dsn2#">
            SELECT 
                INV_S.SHIP_ID,
                INV_S.INVOICE_NUMBER,
                INV_S.SHIP_NUMBER,
                INV_S.IS_WITH_SHIP,
                S.SHIP_TYPE
            FROM 
                INVOICE_SHIPS INV_S,
                SHIP S
            WHERE 
                INV_S.SHIP_ID=S.SHIP_ID AND
                INV_S.INVOICE_ID = #attributes.invoice_id# AND
                INV_S.IS_WITH_SHIP=1 
        </cfquery>
    	<cfquery name="upd_invoice" datasource="#dsn2#">
            UPDATE 
                INVOICE 
            SET
                IS_IPTAL = 1,
                IS_PROCESSED = 0,
                IS_ACCOUNTED = 0,
                CASH_ID=NULL,
                KASA_ID=NULL,
                IS_CASH=0,
                IS_COST=0,
                CANCEL_TYPE_ID = <cfif isdefined("attributes.cancel_type_id") and len(attributes.cancel_type_id)>#attributes.cancel_type_id#<cfelse>NULL</cfif>,
                UPDATE_EMP=#SESSION.EP.USERID#,
                UPDATE_DATE = #NOW()#
            WHERE
                INVOICE_ID=#attributes.invoice_id#
        </cfquery>
        <cfquery name="DEL_INVOICE_MLM_SALES" datasource="#dsn2#">
            DELETE FROM INVOICE_MULTILEVEL_SALES WHERE INVOICE_ID=#attributes.invoice_id#
        </cfquery>
        <cfquery name="DEL_INVOICE_MLM_PREMIUM" datasource="#dsn2#">
            DELETE FROM INVOICE_MULTILEVEL_PREMIUM WHERE INVOICE_ID=#attributes.invoice_id#
        </cfquery>
        <cfif len(get_inv_det.CASH_ID)>
            <cfquery name="delete_cash_actions" datasource="#DSN2#">
                DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #get_inv_det.CASH_ID#
            </cfquery>
        </cfif>
        <cfif get_ship_id.recordcount and get_ship_id.is_with_ship> <!--- faturanın kendi irsaliyesi iptal edilip, irsaliyeye baglı hareketler siliniyor --->
             <cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
                DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #get_ship_id.ship_id#
            </cfquery>	
            <cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#">
                UPDATE SHIP SET IS_SHIP_IPTAL=1 WHERE SHIP_ID = #get_ship_id.ship_id#
            </cfquery>
            <cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#">
                UPDATE SHIP_ROW SET ROW_ORDER_ID=0 WHERE SHIP_ID = #get_ship_id.ship_id#
            </cfquery>
            <cfscript>
                del_serial_no(
					process_id : get_ship_id.ship_id,
					process_cat : get_ship_id.ship_type, 
					period_id : session_base.period_id
					);
            </cfscript>
            <cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
                DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_ship_id.ship_id# AND PROCESS_TYPE = #get_ship_id.ship_type#
            </cfquery>
            <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
                <cfquery name="DEL_ORD_SHIPS" datasource="#dsn2#">
                    DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship_id.ship_id# AND PERIOD_ID=#session_base.period_id# AND ORDER_ID=#attributes.order_id# 
                </cfquery>
            </cfif>
        <cfelse><!--- faturaya cekilmis irsaliye varsa, satırlardaki baglantılar siliniyor --->
            <cfquery name="UPD_INV_ROWS" datasource="#dsn2#">
                UPDATE INVOICE_ROW SET SHIP_ID = NULL WHERE INVOICE_ID= #attributes.invoice_id#
            </cfquery>
            <cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
                DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #attributes.invoice_id# AND IS_WITH_SHIP=0
            </cfquery>
        </cfif>
        <cfscript>
            butce_sil(action_id:attributes.invoice_id,muhasebe_db:dsn2);
            if(len(get_inv_det.cash_id))
            {
                cari_sil(action_id:get_inv_det.cash_id, process_type:35);
                muhasebe_sil(action_id:get_inv_det.cash_id, process_type:35);
            }
			add_ship_row_relation(
				to_related_process_id : attributes.invoice_id,
				to_related_process_type : get_inv_det.process_cat,
				old_related_process_type : get_inv_det.invoice_cat,
				is_invoice_ship : 0,
				ship_related_action_type:2,
				process_db :dsn2
				);
            add_reserve_row(
                related_process_id : attributes.invoice_id,
                reserve_action_type:1,
                reserve_action_iptal : 1,
                is_order_process:2,
                is_purchase_sales:1,
                process_db :dsn2
                );
        </cfscript>
        <!---Sistem ödeme planı faturasına iptal bilgisi set edilir,o tarafta gösterimi yapılmadı çokfazla işlem gerekiyordu burdan set edildi--->
        <cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
            UPDATE
                #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
            SET
                IS_INVOICE_IPTAL = 1,
                INVOICE_ID = NULL,
                IS_BILLED = 0,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session_base.userid#
            WHERE
                INVOICE_ID = #attributes.invoice_id# AND 
                PERIOD_ID = #session_base.period_id#
        </cfquery>
        <!--- Fatura Ödeme Plani Satirlari Iptal Ediliyor --->
        <cfquery name="UPD_INVOICE_PAYMENT_ROWS" datasource="#dsn2#">
            UPDATE
                #dsn3_alias#.INVOICE_PAYMENT_PLAN
            SET
                IS_ACTIVE = 0,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = #session_base.userid#
            WHERE
                INVOICE_ID = #attributes.invoice_id# AND 
                PERIOD_ID = #session_base.period_id#
        </cfquery>
        
        <!--- İlgili Servis Başvurusu' nun Fatura Bilgisi Set Ediliyor --->
        <cfquery name="UPD_SERVICE" datasource="#dsn2#">
            UPDATE
                #dsn3_alias#.SERVICE
            SET
                INVOICE_ID = NULL
            WHERE
                INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
        </cfquery>

        <!--- Muhasebe için ters kayıt atılıyor --->
        <cfquery name="get_acc_card" datasource="#dsn2#">
        	SELECT * FROM ACCOUNT_CARD WHERE ACTION_ID = #attributes.invoice_id# AND ACTION_TYPE = #get_inv_det.invoice_cat#
        </cfquery>
     	<cfif get_acc_card.recordcount>
			<cfif session.ep.our_company_info.is_edefter eq 1>
				<cfif get_acc_card.RECORDCOUNT>
                    <cfset netbook_date = get_acc_card.ACTION_DATE>
                <cfelse>
                    <cfset netbook_date = ''>
                </cfif>
                <cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_date#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#DSN2#.">
                    <cfprocresult name="getNetbook">
                </cfstoredproc>
                <cfscript>
                    if(getNetbook.recordcount)
                        abort('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                </cfscript>
            </cfif>
            <cfquery name="get_acc_rows" datasource="#dsn2#">
            	SELECT * FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #get_acc_card.card_id#
            </cfquery>
            <cfquery name="get_process_cat" datasource="#dsn2#">
            	SELECT IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_acc_card.action_cat_id#
            </cfquery>
            <cfquery name="GET_NO_" datasource="#dsn2#">
                SELECT * FROM #dsn3_alias#.SETUP_INVOICE SETUP_INVOICE
            </cfquery>
            <cfscript>
				if(get_acc_rows.amount gt 0 and get_acc_rows.amount_2 gt 0)
					currency_multiplier = get_acc_rows.amount/get_acc_rows.amount_2;
				else
					currency_multiplier = 1;
            	str_borclu_hesaplar="";
            	str_borclu_tutarlar="";
            	str_dovizli_borclar="";
            	str_other_currency_borc="";
				acc_project_list_borc="";
            	str_alacakli_hesaplar="";
            	str_alacakli_tutarlar="";
            	str_dovizli_alacaklar="";
            	str_other_currency_alacak="";
				acc_project_list_alacak="";
				satir_detay_list = ArrayNew(2);
				str_borc_miktar = ArrayNew(1);
				str_borc_tutar = ArrayNew(1);
            </cfscript>
            <cfoutput query="get_acc_rows">
				<cfscript>
                	if(get_acc_rows.ba eq 1)
					{
						str_borclu_hesaplar=listappend(str_borclu_hesaplar,account_id);
						str_borclu_tutarlar=listappend(str_borclu_tutarlar,amount);
						str_dovizli_borclar=listappend(str_dovizli_borclar,other_amount);
						str_other_currency_borc=listappend(str_other_currency_borc,other_currency);
						str_borc_miktar[listlen(str_borclu_tutarlar)]=quantity;
						str_borc_tutar[listlen(str_borclu_tutarlar)]=price;
						acc_project_list_borc=listappend(acc_project_list_borc,acc_project_id);
						satir_detay_list[1][listlen(str_borclu_tutarlar)] = "#detail#-İPTAL";
					}
					else
					{
						str_alacakli_hesaplar=listappend(str_alacakli_hesaplar,account_id);
						str_alacakli_tutarlar=listappend(str_alacakli_tutarlar,amount);
						str_dovizli_alacaklar=listappend(str_dovizli_alacaklar,other_amount);
						str_other_currency_alacak=listappend(str_other_currency_alacak,other_currency);
						acc_project_list_alacak=listappend(acc_project_list_alacak,acc_project_id);
						satir_detay_list[2][listlen(str_alacakli_tutarlar)] = "#detail#-İPTAL";
					}
                </cfscript>
			</cfoutput>
            <cfscript>
				str_fark_gelir =GET_NO_.FARK_GELIR;
				str_fark_gider =GET_NO_.FARK_GIDER;
				str_max_round = 0.5;
				str_round_detail = get_acc_rows.detail;
            	muhasebeci(
					wrk_id : get_acc_card.wrk_id,
					action_id : get_acc_card.action_id,
					workcube_process_type : get_acc_card.action_type,
					workcube_process_cat:get_acc_card.action_cat_id,
					account_card_type : 13,
					company_id : get_acc_card.acc_company_id,
					consumer_id : get_acc_card.acc_consumer_id,
					islem_tarihi : attributes.invoice_date,
					borc_hesaplar : str_borclu_hesaplar,
					action_currency : session_base.money,
					action_currency_2 : session_base.money2,
					base_period_year : session_base.period_year,
					borc_tutarlar : str_borclu_tutarlar,
					other_amount_borc : str_dovizli_borclar,
					other_currency_borc : str_other_currency_borc,
					alacak_hesaplar : str_alacakli_hesaplar,
					alacak_tutarlar : str_alacakli_tutarlar,
					other_amount_alacak : str_dovizli_alacaklar,
					other_currency_alacak :str_other_currency_alacak,
					borc_miktarlar : str_borc_miktar,
					borc_birim_tutar : str_borc_tutar,
					from_branch_id : get_acc_rows.acc_branch_id,
					acc_department_id : get_acc_rows.acc_department_id,
					fis_detay : "#get_acc_card.CARD_DETAIL# - İPTAL",
					fis_satir_detay : satir_detay_list,
					belge_no : get_acc_card.paper_no,
					is_account_group : get_process_cat.is_account_group,
					currency_multiplier : currency_multiplier,
					dept_round_account :str_fark_gider,
					claim_round_account : str_fark_gelir,
					max_round_amount :str_max_round,
					round_row_detail:str_round_detail,
					is_abort : 1,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc,
					is_cancel : 1
				);
            </cfscript>
        </cfif>
        <!--- Cari için ters kayıt atılıyor --->
        <cfquery name="get_cari_rows" datasource="#dsn2#">
        	SELECT * FROM CARI_ROWS WHERE ACTION_ID = #attributes.invoice_id# AND ACTION_TYPE_ID = #get_inv_det.invoice_cat#
        </cfquery>
     	<cfif get_cari_rows.recordcount>
        	<cfoutput query="get_cari_rows">
            	<cfscript>
                	carici(
						action_id :get_cari_rows.action_id,
						action_table : 'INVOICE',
						workcube_process_type : get_cari_rows.action_type_id,
						account_card_type : 13,
						islem_tarihi : attributes.invoice_date,
						due_date : createodbcdate(get_cari_rows.due_date),
						islem_tutari :get_cari_rows.action_value,
						islem_belge_no :get_cari_rows.paper_no,
						from_cmp_id : get_cari_rows.to_cmp_id,
						from_consumer_id : get_cari_rows.to_consumer_id,
						from_employee_id : get_cari_rows.to_employee_id,
						from_branch_id : get_cari_rows.to_branch_id,
						islem_detay : "#get_cari_rows.action_name# - İPTAL",
						acc_type_id : get_cari_rows.acc_type_id,
						action_detail : get_cari_rows.action_detail,
						other_money_value : get_cari_rows.other_cash_act_value,
						other_money : get_cari_rows.other_money,
						action_currency : session_base.money,
						action_currency_2 : session_base.money2,
						action_value2 : get_cari_rows.action_value_2,
						process_cat : get_cari_rows.process_cat,
						period_is_integrated : session.ep.period_is_integrated,
						project_id : get_cari_rows.project_id,
						assetp_id : get_cari_rows.assetp_id,
						rate2:get_cari_rows.rate2,
						is_cancel:1
						);
                </cfscript>
            </cfoutput>
        </cfif>
    </cftransaction>
	</cflock>
<cfelse>
	<cflock name="#CreateUUID()#" timeout="20">
    	<cftransaction>
            <cf_date tarih = "attributes.expense_date">
            <cfquery name="GET_EXPENSE_DET" datasource="#DSN2#">
                SELECT ACTION_TYPE, EXPENSE_DATE FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #attributes.expense_id#
            </cfquery>
            <cfquery name="UPD_INVOICE" datasource="#DSN2#">
                UPDATE 
                    EXPENSE_ITEM_PLANS
                SET
                    IS_IPTAL = 1,
                    IS_CASH = 0,
                    CANCEL_TYPE_ID = <cfif isdefined("attributes.cancel_type_id") and len(attributes.cancel_type_id)>#attributes.cancel_type_id#<cfelse>NULL</cfif>,
                    UPDATE_EMP= #session.ep.userid#,
                    UPDATE_DATE = #now()#
                WHERE
                    EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
            </cfquery>
            <!--- Muhasebe için ters kayıt atılıyor --->
            <cfquery name="GET_ACC_CARD" datasource="#DSN2#">
                SELECT * FROM ACCOUNT_CARD WHERE ACTION_ID = #attributes.expense_id# AND ACTION_TYPE = #get_expense_det.action_type#
            </cfquery>
            <cfif get_acc_card.recordcount>
                <cfif session.ep.our_company_info.is_edefter eq 1>
                    <cfif get_acc_card.recordcount>
                        <cfset netbook_date = get_acc_card.action_date>
                    <cfelse>
                        <cfset netbook_date = ''>
                    </cfif>
                    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
                        <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#DSN2#.">
                        <cfprocresult name="getNetbook">
                    </cfstoredproc>
                    <cfscript>
                        if(getNetbook.recordcount)
                            abort('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                    </cfscript>
                </cfif>
                <cfquery name="GET_ACC_ROWS" datasource="#DSN2#">
                    SELECT * FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #get_acc_card.card_id#
                </cfquery>
                <cfquery name="GET_PROCESS_CAT" datasource="#DSN2#">
                    SELECT IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_acc_card.action_cat_id#
                </cfquery>
                <cfquery name="GET_NO_" datasource="#DSN2#">
                    SELECT * FROM #dsn3_alias#.SETUP_INVOICE SETUP_INVOICE
                </cfquery>
                <cfscript>
                    if(get_acc_rows.amount gt 0 and get_acc_rows.amount_2 gt 0)
                        currency_multiplier = get_acc_rows.amount/get_acc_rows.amount_2;
                    else
                        currency_multiplier = 1;
                    str_borclu_hesaplar="";
                    str_borclu_tutarlar="";
                    str_dovizli_borclar="";
                    str_other_currency_borc="";
                    acc_project_list_borc="";
                    str_alacakli_hesaplar="";
                    str_alacakli_tutarlar="";
                    str_dovizli_alacaklar="";
                    str_other_currency_alacak="";
                    acc_project_list_alacak="";
                    satir_detay_list = ArrayNew(2);
                    str_borc_miktar = ArrayNew(1);
                    str_borc_tutar = ArrayNew(1);
                </cfscript>
                <cfoutput query="get_acc_rows">
                    <cfscript>
                        if(get_acc_rows.ba eq 1)
                        {
                            str_borclu_hesaplar=listappend(str_borclu_hesaplar,account_id);
                            str_borclu_tutarlar=listappend(str_borclu_tutarlar,amount);
                            str_dovizli_borclar=listappend(str_dovizli_borclar,other_amount);
                            str_other_currency_borc=listappend(str_other_currency_borc,other_currency);
                            str_borc_miktar[listlen(str_borclu_tutarlar)]=quantity;
                            str_borc_tutar[listlen(str_borclu_tutarlar)]=price;
                            acc_project_list_borc=listappend(acc_project_list_borc,acc_project_id);
                            satir_detay_list[1][listlen(str_borclu_tutarlar)] = "#detail#-İPTAL";
                        }
                        else
                        {
                            str_alacakli_hesaplar=listappend(str_alacakli_hesaplar,account_id);
                            str_alacakli_tutarlar=listappend(str_alacakli_tutarlar,amount);
                            str_dovizli_alacaklar=listappend(str_dovizli_alacaklar,other_amount);
                            str_other_currency_alacak=listappend(str_other_currency_alacak,other_currency);
                            acc_project_list_alacak=listappend(acc_project_list_alacak,acc_project_id);
                            satir_detay_list[2][listlen(str_alacakli_tutarlar)] = "#detail#-İPTAL";
                        }
                    </cfscript>
                </cfoutput>
                <cfscript>
                    str_fark_gelir =GET_NO_.FARK_GELIR;
                    str_fark_gider =GET_NO_.FARK_GIDER;
                    str_max_round = 0.5;
                    str_round_detail = get_acc_rows.detail;
                    muhasebeci(
                        wrk_id : get_acc_card.wrk_id,
                        action_id : get_acc_card.action_id,
                        workcube_process_type : get_acc_card.action_type,
                        workcube_process_cat:get_acc_card.action_cat_id,
                        account_card_type : 13,
                        company_id : get_acc_card.acc_company_id,
                        consumer_id : get_acc_card.acc_consumer_id,
                        islem_tarihi : attributes.expense_date,
                        borc_hesaplar : str_borclu_hesaplar,
                        action_currency : session_base.money,
                        action_currency_2 : session_base.money2,
                        base_period_year : session.ep.period_year,
                        borc_tutarlar : str_borclu_tutarlar,
                        other_amount_borc : str_dovizli_borclar,
                        other_currency_borc : str_other_currency_borc,
                        alacak_hesaplar : str_alacakli_hesaplar,
                        alacak_tutarlar : str_alacakli_tutarlar,
                        other_amount_alacak : str_dovizli_alacaklar,
                        other_currency_alacak :str_other_currency_alacak,
                        borc_miktarlar : str_borc_miktar,
                        borc_birim_tutar : str_borc_tutar,
                        from_branch_id : get_acc_rows.acc_branch_id,
                        acc_department_id : get_acc_rows.acc_department_id,
                        fis_detay : "#get_acc_card.card_detail# - İPTAL",
                        fis_satir_detay : satir_detay_list,
                        belge_no : get_acc_card.paper_no,
                        is_account_group : get_process_cat.is_account_group,
                        currency_multiplier : currency_multiplier,
                        dept_round_account :str_fark_gider,
                        claim_round_account : str_fark_gelir,
                        max_round_amount :str_max_round,
                        round_row_detail:str_round_detail,
                        is_abort : 1,
                        acc_project_list_alacak : acc_project_list_alacak,
                        acc_project_list_borc : acc_project_list_borc,
                        is_cancel : 1
                    );
                </cfscript>
            </cfif>
            <!--- Cari için ters kayıt atılıyor --->
            <cfquery name="GET_CARI_ROWS" datasource="#DSN2#">
                SELECT * FROM CARI_ROWS WHERE ACTION_ID = #attributes.expense_id# AND ACTION_TYPE_ID = #get_expense_det.action_type#
            </cfquery>
            <cfif get_cari_rows.recordcount>
                <cfoutput query="get_cari_rows">
                    <cfscript>
                        carici(
                            action_id :get_cari_rows.action_id,
                            action_table : 'EXPENSE_ITEM_PLANS',
                            workcube_process_type : get_cari_rows.action_type_id,
                            account_card_type : 13,
                            islem_tarihi : attributes.expense_date,
                            due_date : createodbcdate(get_cari_rows.due_date),
                            islem_tutari :get_cari_rows.action_value,
                            islem_belge_no :get_cari_rows.paper_no,
                            from_cmp_id : get_cari_rows.to_cmp_id,
                            from_consumer_id : get_cari_rows.to_consumer_id,
                            from_employee_id : get_cari_rows.to_employee_id,
                            from_branch_id : get_cari_rows.to_branch_id,
                            islem_detay : "#get_cari_rows.action_name# - İPTAL",
                            acc_type_id : get_cari_rows.acc_type_id,
                            action_detail : get_cari_rows.action_detail,
                            other_money_value : get_cari_rows.other_cash_act_value,
                            other_money : get_cari_rows.other_money,
                            action_currency : session.ep.money,
                            action_currency_2 : session.ep.money2,
                            action_value2 : get_cari_rows.action_value_2,
                            process_cat : get_cari_rows.process_cat,
                            period_is_integrated : session.ep.period_is_integrated,
                            project_id : get_cari_rows.project_id,
                            assetp_id : get_cari_rows.assetp_id,
                            rate2:get_cari_rows.rate2,
                            is_cancel:1
                            );
                    </cfscript>
                </cfoutput>
            </cfif>
    	</cftransaction>
    </cflock>
</cfif>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
        window.opener.location.reload(true);
	    window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        location.reload();
    </cfif>
</script>
