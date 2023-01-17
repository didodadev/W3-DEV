<!--- Islemi Olmayan Muhasebe Fislerini Goruntuler, Silme Imkani Saglar FBS 20130215
	Standarda aldım. Durgan20150817
 --->
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.card_id") and len(attributes.card_id)>
    <cflock timeout="60">
        <cftransaction>
            <cfif isdefined("attributes.new_dsn2")>
                <cfset new_dsn2 = attributes.new_dsn2>
            <cfelse>
                <cfset new_dsn2 = dsn2>
            </cfif>
            <!--- e-defter islem kontrolu FA --->
            <cfif session.ep.our_company_info.is_edefter eq 1>
                <cfquery name="getCardControl" datasource="#new_dsn2#">
                    SELECT ACTION_DATE FROM ACCOUNT_CARD WHERE CARD_ID IN (#attributes.CARD_ID#)
                </cfquery>
                <cfif getCardControl.recordcount>
                    <cfloop query="getCardControl">
                        <cfstoredproc procedure="GET_NETBOOK" datasource="#new_dsn2#">
                            <cfprocparam cfsqltype="cf_sql_timestamp" value="#getCardControl.action_date#">
                            <cfprocparam cfsqltype="cf_sql_timestamp" value="#getCardControl.action_date#">
                            <cfprocparam cfsqltype="cf_sql_varchar" value="">
                            <cfprocresult name="getNetbook">
                        </cfstoredproc>
                        <cfif getNetbook.recordcount>
                            <script language="javascript">
                                alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
                                window.close();
                            </script>
                            <cfabort>
                        </cfif>
                     </cfloop>
                </cfif>
            </cfif>
            <!--- e-defter islem kontrolu FA --->
            <cfinclude template="../../account/query/upd_del_card_process.cfm">
            <cfquery name="del_card" datasource="#new_dsn2#">
                DELETE FROM ACCOUNT_CARD WHERE CARD_ID IN(#attributes.CARD_ID#)
            </cfquery>
            <cfquery name="DEL_ACCOUNT_CARD" datasource="#new_dsn2#">
                DELETE FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID IN(#attributes.CARD_ID#)
            </cfquery>
            <cfquery name="del_card" datasource="#new_dsn2#">
                DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID IN(#attributes.CARD_ID#)
            </cfquery>
            <cfset action_name_ = ''>
            <cfset paper_no=''>
            <cfif len(get_card.paper_no)>
                <cfset action_name_ = get_card.paper_no>
                <cfset paper_no=get_card.paper_no>
            <cfelse>
                <cfset action_name_ = 'YEVMİYE NO : ' & get_card.bill_no>
            </cfif>
            <cf_add_log log_type="-1" action_id="#listfirst(attributes.CARD_ID)#" action_name="#action_name_#" process_type="#get_card.card_type#" paper_no="#get_card.paper_no#" data_source="#new_dsn2#">
			<script type="text/javascript">
                alert("Silme İşlemi Tamamlandı!");
            </script>
        </cftransaction>
    </cflock>
</cfif>
<cfif isDefined("attributes.kontrol_form")>
    <cfquery name="get_all_account" datasource="#dsn2#">
    	WITH CTE1 AS (
			<!--- ACTION_TABLE='INVOICE' --->
            SELECT
                'FATURA' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE	
                ACTION_TYPE IN (48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,561,601,690,691,591,592,531,532)
                AND ACTION_ID NOT IN(SELECT INVOICE_ID FROM INVOICE WITH (NOLOCK))
            UNION ALL
            <!--- SHIP --->
            SELECT
                'IRSALIYE' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE	
                ACTION_TYPE IN (70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,811,761)
                AND ACTION_ID NOT IN(SELECT SHIP_ID FROM SHIP WITH (NOLOCK))
            UNION ALL
            <!--- STOCK_FIS --->
            SELECT
                'STOK_FISI' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE	
                ACTION_TYPE IN (110,111,112,113,114,115,117,118,119,1131,1161,1182,1183,1184,1181,1190,1191,1192,1193,1194)
                AND ACTION_ID NOT IN(SELECT FIS_ID FROM STOCK_FIS WITH (NOLOCK))
			UNION ALL
			<!--- STOCK_VIRMAN --->
			SELECT
				'STOK_VIRMAN' AS TYPE,
				PAPER_NO,
				ACTION_ID,
				CARD_ID,
				CARD_TYPE
			FROM
				ACCOUNT_CARD WITH (NOLOCK)
			WHERE	
				ACTION_TYPE IN (116)
				AND ACTION_ID NOT IN(SELECT STOCK_EXCHANGE_ID FROM STOCK_EXCHANGE WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='CASH_ACTIONS' --->
            SELECT
                'KASA İŞLEMİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE	
                ACTION_TYPE IN (30,32,33,34,35,37,38,39,31)
                AND ACTION_ID NOT IN(SELECT CASH_ACTIONS.ACTION_ID FROM CASH_ACTIONS WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='CASH_ACTIONS_MULTI' --->
            SELECT
                'TOPLU KASA İŞLEMİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE	
                ACTION_TYPE IN (320,310,311)
                AND ACTION_ID NOT IN(SELECT CASH_ACTIONS_MULTI.MULTI_ACTION_ID FROM CASH_ACTIONS_MULTI WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='BANK_ACTIONS' --->
            SELECT
                'BANKA İŞLEMİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (24,25)	
                AND ACTION_ID NOT IN(SELECT BANK_ACTIONS.ACTION_ID FROM BANK_ACTIONS WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='BANK_ACTIONS_MULTI' --->
            SELECT
                'TOPLU BANKA İŞLEMİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (230,240,253,254)	
                AND ACTION_ID NOT IN(SELECT BANK_ACTIONS_MULTI.MULTI_ACTION_ID FROM BANK_ACTIONS_MULTI WITH (NOLOCK))    
            <!--- ACTION_TABLE='PAYROLL' --->    
            UNION ALL
            SELECT
                'ÇEK BORDROSU' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE	
                ACTION_TYPE IN (90,91,92,93,94,95,105,106,133,134,135)
                AND ACTION_ID NOT IN(SELECT PAYROLL.ACTION_ID FROM PAYROLL WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='VOUCHER_PAYROLL' --->
            SELECT
                'SENET BORDROSU' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (97,98,99,100,101,104,107,108,109,136,137,1057)
                AND ACTION_ID NOT IN(SELECT VOUCHER_PAYROLL.ACTION_ID FROM VOUCHER_PAYROLL WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='BUDGET_PLAN_ROW' --->
            SELECT
                'BÜTÇE FİŞİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (160,161)
                AND ACTION_ID NOT IN(SELECT BUDGET_PLAN.BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN BUDGET_PLAN WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='CARI_ACTIONS' --->
            SELECT
                'CARİ HAREKET' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (41,43,42,45,46)
                AND ACTION_ID NOT IN(SELECT CARI_ACTIONS.ACTION_ID FROM CARI_ACTIONS WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='CREDIT_CARD_BANK_EXPENSE' --->
            SELECT
                'KREDİ KARTI ÖDEME' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (242,246)
                AND ACTION_ID NOT IN(SELECT CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CREDIT_CARD_BANK_EXPENSE WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='CREDIT_CARD_BANK_PAYMENTS' --->
            SELECT
                'KREDİ KARTI TAHSİLAT' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (52,69,241,245,2410)
                AND ACTION_ID NOT IN(SELECT CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='CREDIT_CONTRACT_PAYMENT_INCOME' --->
            SELECT
                'KREDİ ÖDEME - TAHSİLAT' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (291,292)
                AND ACTION_ID NOT IN(SELECT CREDIT_CONTRACT_PAYMENT_INCOME.CREDIT_CONTRACT_PAYMENT_ID FROM CREDIT_CONTRACT_PAYMENT_INCOME WITH (NOLOCK))
            UNION ALL
            <!--- ACTION_TABLE='EXPENSE_ITEM_PLANS' --->
            SELECT
                'MASRAF - GELİR FİŞİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (120,121,122)
                AND ACTION_ID NOT IN(SELECT EXPENSE_ITEM_PLANS.EXPENSE_ID FROM EXPENSE_ITEM_PLANS WITH (NOLOCK))
            UNION ALL
            <!--- PRODUCTION_ORDER_RESULTS --->
            SELECT
                'ÜRETİM SONUCU' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (171)
                AND ACTION_ID NOT IN(SELECT PRODUCTION_ORDER_RESULTS.PR_ORDER_ID FROM #dsn3_alias#.PRODUCTION_ORDER_RESULTS WITH (NOLOCK))
                AND ACTION_ID <> 0	
            UNION ALL
            <!--- COMPANY_SECUREFUND --->
            SELECT
                'TEMİNAT İŞLEMİ' AS TYPE,
                PAPER_NO,
                ACTION_ID,
                CARD_ID,
                CARD_TYPE
            FROM
                ACCOUNT_CARD WITH (NOLOCK)
            WHERE
                ACTION_TYPE IN (300,301)
                AND ACTION_ID NOT IN(SELECT COMPANY_SECUREFUND.SECUREFUND_ID FROM #dsn_alias#.COMPANY_SECUREFUND WITH (NOLOCK))
        )
        SELECT
        	CTE1.*
        FROM
        	CTE1
        WHERE
        	1 = 1
            <cfif len(attributes.keyword)>
            	AND ( PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                	OR TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfif isNumeric(attributes.keyword)>
                        OR ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
                        OR CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
                    </cfif>
                    )
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_all_account.RecordCount = 0>
</cfif>
<cfset attributes.totalrecords=get_all_account.recordcount>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <cfform name="rapor" action="#request.self#?fuseaction=settings.bills_without_action" method="post">
            <input type="hidden" name="kontrol_form" id="form_varmi" value="0">
            <input name="card_id" id="card_id" value="" type="hidden">
            <cf_box_search more="0"> 
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#message#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" message="#message#">
                </div>
                <div class="form-group">
					<cf_wrk_search_button button_type="4">	
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>  
				</div>
            </cf_box_search>
        </cfform>
    </cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='43349.İşlemi Olmayan Muhasebe Fişleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='30066.Fiş'><cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='57692.İşlem'><cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='58772.İşlem No'></th>
                    <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                    <th width="20"></th>
                    <th width="20"></th>
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.kontrol_form") and get_all_account.recordcount>
                    <cfoutput query="get_all_account" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif card_type eq 10>
                            <cfset send='form_add_bill_opening&event=upd&var_=opening_card'>
                        <cfelseif card_type eq 11>
                            <cfset send='form_add_bill_collecting&event=upd&bill_type=2&var_=collecting_card'>
                        <cfelseif card_type eq 12>
                            <cfset send='form_add_bill_payment&event=upd&var_=payment_card'>
                        <cfelseif listfind('13,14,19',card_type)>
                            <cfset send='form_add_bill_cash2cash&event=upd'>
                        <cfelseif card_type eq 40>
                            <cfset send='popup_upd_bill_ch_opening&var_=ch_opening_card'>
                        </cfif>
                        <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                            <td>#currentrow#</td>
                            <td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#card_id#','page_horizantal');">#card_id#</a></td>
                            <td>#action_id#</td>
                            <td>#paper_no#</td>
                            <td>#type#</td>
                            <td>
                                <a href="#request.self#?fuseaction=account.#send#&card_id=#card_id#" target="_blank"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>
                            <td>
                                <a href="javascript://" onClick="sil(#CARD_ID#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="15"><cfif isdefined("attributes.kontrol_form")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>	 
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<cfset adres="settings.#listlast(attributes.fuseaction,'.')#">
<cfif isdefined("attributes.keyword")>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.kontrol_form")>
	<cfset adres = "#adres#&kontrol_form=#attributes.kontrol_form#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#adres#"> 
<br />
<script language="javascript">
	function sil(card_id)
	{
		if(confirm("İşleme Ait Muhasebe Hareketi Silinecektir. Emin misiniz?"))
		{
			document.all.kontrol_form.value = 1;
			document.all.card_id.value = card_id;
			document.rapor.submit();
			document.all.kontrol_form.value = 0;
		}
	}
</script>
