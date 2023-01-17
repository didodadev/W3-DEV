
<cfquery name="CONTROL_EINVOICE" datasource="#DSN2#">
    SELECT STATUS,PROFILE_ID FROM EINVOICE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND ACTION_TYPE = 'INVOICE'
</cfquery>

<cfif control_einvoice.profile_id eq 'TICARIFATURA' and control_einvoice.status neq 0>
	<script>
		alert("Red edilmemiş Ticari Faturanın İptal İşlemini Yapamazsınız !");
		this.close();
	</script>
    <cfabort>
</cfif>

<cflock name="#CreateUUID()#" timeout="20">
    <cftransaction>
    	<cf_date tarih = "attributes.invoice_date">
    	<cfquery name="get_inv_det" datasource="#dsn2#">
        	SELECT INVOICE_CAT,CASH_ID,INVOICE_DATE,PROCESS_CAT FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
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
                INV_S.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
                INV_S.IS_WITH_SHIP = 1 
        </cfquery>
    	<cfquery name="upd_invoice" datasource="#dsn2#">
            UPDATE 
                INVOICE 
            SET
                IS_IPTAL = 1,
                IS_PROCESSED = 0,
                IS_ACCOUNTED = 0,
                CASH_ID = NULL,
                KASA_ID = NULL,
                IS_CASH = 0,
                IS_COST = 0,
                CANCEL_TYPE_ID = <cfif isdefined("attributes.cancel_type_id") and len(attributes.cancel_type_id)>#attributes.cancel_type_id#<cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_DATE = #NOW()#
            WHERE
                INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
        </cfquery>
        <cfif len(get_inv_det.CASH_ID)>
            <cfquery name="delete_cash_actions" datasource="#DSN2#">
                DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #get_inv_det.CASH_ID#
            </cfquery>
        </cfif>
        <cfif get_ship_id.recordcount and get_ship_id.is_with_ship>
            <cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#">
                UPDATE SHIP SET IS_SHIP_IPTAL = 1 WHERE SHIP_ID = #get_ship_id.ship_id#
            </cfquery>
            <cfquery name="UPD_SHIP_IPTAL" datasource="#dsn2#">
                UPDATE SHIP_ROW SET ROW_ORDER_ID = 0 WHERE SHIP_ID = #get_ship_id.ship_id#
            </cfquery>
        </cfif>
        <cfquery name="UPD_INVENTORY_ROW" datasource="#dsn2#">
            UPDATE #dsn3_alias#.INVENTORY_ROW SET STOCK_OUT = 0 WHERE ACTION_ID = #attributes.invoice_id#
        </cfquery>
        <cfscript>
            butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2,process_type:66);
            if(len(get_inv_det.cash_id))
            {
                cari_sil(action_id:get_inv_det.cash_id, process_type:35);
                muhasebe_sil(action_id:get_inv_det.cash_id, process_type:35);
            }
        </cfscript>
        <!--- Muhasebe için ters kayıt atılıyor --->
        <cfquery name="get_acc_card" datasource="#dsn2#">
        	SELECT * FROM ACCOUNT_CARD WHERE ACTION_ID = #form.invoice_id# AND ACTION_TYPE = #get_inv_det.invoice_cat#
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
        	SELECT * FROM CARI_ROWS WHERE ACTION_ID = #form.invoice_id# AND ACTION_TYPE_ID = #get_inv_det.invoice_cat#
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

<script type="text/javascript">
    location.reload();
</script>
