<cf_date tarih='attributes.process_date'>
    <cfquery name="get_process_type" datasource="#dsn3#">
        SELECT 
            PROCESS_CAT_ID,
            PROCESS_TYPE,
            IS_CARI,
            IS_ACCOUNT,
            IS_ACCOUNT_GROUP,
            ACTION_FILE_NAME,
            ACTION_FILE_FROM_TEMPLATE
         FROM 
            SETUP_PROCESS_CAT 
        WHERE 
            PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="Mahsup Fişi">
    </cfquery>
    <cflock name="#CreateUUID()#" timeout="60">
        <cftransaction>
        <cfscript>
            process_cat = get_process_type.PROCESS_CAT_ID;
            process_type = get_process_type.PROCESS_TYPE;
        
            debt_accounts_list1 = '';
            debt_amounts_list1 = '';
            claim_accounts_list1 = '';
            claim_amounts_list1 = '';	
        
            for(i=1 ; i<=attributes.totalrecords_refl ; i++)
            {
                debt_accounts_list1 = listAppend(debt_accounts_list1, attributes['debt_acc_code_refl_'&i]);	
                debt_amounts_list1 = listAppend(debt_amounts_list1, filterNum(attributes['amount_debt_refl_'&i]));	
                claim_accounts_list1 = listAppend(claim_accounts_list1, attributes['claim_acc_code_refl_'&i]);	
                claim_amounts_list1 = listAppend(claim_amounts_list1, filterNum(attributes['amount_claim_refl_'&i]));	
            }
            
            //gider hesaplarının yansıtılması
            
            yev1 = muhasebeci(
                action_id: 0,
                workcube_process_type: process_type,
                workcube_process_cat: process_cat,
                account_card_type: attributes.card_type,
                islem_tarihi : attributes.process_date,
                fis_satir_detay : 'Gider Hesabı Yansıtma',
                borc_hesaplar : debt_accounts_list1,
                borc_tutarlar : debt_amounts_list1,
                //other_amount_borc : str_borclu_other_amount_tutar,
                //other_currency_borc : str_borclu_other_currency,
                alacak_hesaplar : claim_accounts_list1,
                alacak_tutarlar : claim_amounts_list1,
                //other_amount_alacak : str_alacakli_other_amount_tutar,
                //other_currency_alacak : str_alacakli_other_currency,
                fis_detay:'Gider Hesabı Yansıtma'
            );	
        
            
            debt_accounts_list2 = '';
            debt_amounts_list2 = '';
            claim_accounts_list2 = '';
            claim_amounts_list2 = '';	
            
            for(j=1 ; j<=attributes.totalrecords_closed ; j++)
            {
                debt_accounts_list2 = listAppend(debt_accounts_list2, attributes['debt_acc_code_closed_'&j]);	
                debt_amounts_list2 = listAppend(debt_amounts_list2, filterNum(attributes['amount_debt_closed_'&j]));	
                claim_accounts_list2 = listAppend(claim_accounts_list2, attributes['claim_acc_code_closed_'&j]);	
                claim_amounts_list2 = listAppend(claim_amounts_list2, filterNum(attributes['amount_claim_closed_'&j]));			
            }
            
            //yansıtmaların kapatılması
            yev2 = muhasebeci(
                action_id: 0,
                workcube_process_type: process_type,
                workcube_process_cat: process_cat,
                account_card_type: attributes.card_type,
                islem_tarihi : attributes.process_date,
                fis_satir_detay : 'Yansıtma hesabının kapatılması',
                borc_hesaplar : debt_accounts_list2,
                borc_tutarlar : debt_amounts_list2,
                //other_amount_borc : str_borclu_other_amount_tutar,
                //other_currency_borc : str_borclu_other_currency,
                alacak_hesaplar : claim_accounts_list2,
                alacak_tutarlar : claim_amounts_list2,
                //other_amount_alacak : str_alacakli_other_amount_tutar,
                //other_currency_alacak : str_alacakli_other_currency,
                fis_detay:'Yansıtma hesabının kapatılması'
            );		
            
            
            debt_accounts_list3 = '';
            debt_amounts_list3 = '';
            claim_accounts_list3 = '';
            claim_amounts_list3 = '';	
            
            for(j=1 ; j<=attributes.totalrecords_income_closed ; j++)
            {
                debt_accounts_list3 = listAppend(debt_accounts_list3, attributes['debt_income_acc_code_closed_'&j]);	
                debt_amounts_list3 = listAppend(debt_amounts_list3, filterNum(attributes['amount_income_debt_closed_'&j]));	
                claim_accounts_list3 = listAppend(claim_accounts_list3, attributes['claim_income_acc_code_closed_'&j]);	
                claim_amounts_list3 = listAppend(claim_amounts_list3, filterNum(attributes['amount_income_claim_closed_'&j]));			
            }
            
            //Gelir Tablosu Hesaplarının Kapatılması
            yev3 = muhasebeci(
                action_id: 0,
                workcube_process_type: process_type,
                workcube_process_cat: process_cat,
                account_card_type: attributes.card_type,
                islem_tarihi : attributes.process_date,
                fis_satir_detay : 'Gelir Tablosu Hesaplarının Kapatılması',
                borc_hesaplar : debt_accounts_list3,
                borc_tutarlar : debt_amounts_list3,
                //other_amount_borc : str_borclu_other_amount_tutar,
                //other_currency_borc : str_borclu_other_currency,
                alacak_hesaplar : claim_accounts_list3,
                alacak_tutarlar : claim_amounts_list3,
                //other_amount_alacak : str_alacakli_other_amount_tutar,
                //other_currency_alacak : str_alacakli_other_currency,
                fis_detay:'Gelir Tablosu Hesaplarının Kapatılması'
            );		
        </cfscript>
        
        <cfif Len(#yev1#) and #yev1# neq 0>
                <cfquery name="get_refl_acc" datasource="#dsn2#">
                UPDATE 
                    ACCOUNT_CLOSED_DEFINITION
                SET 
                    INCOME=1
                WHERE
                    CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">   
                    AND CLOSED_ACCOUNT_CODE IS NOT NULL
                    AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            </cfquery>
        </cfif>
        
    
        <script type="text/javascript">
            
                if(confirm("<cfoutput>#yev1# ve #yev2# ve #yev3#</cfoutput> <cf_get_lang dictionary_id='65468.yevmiye numaralı fişler oluşturuldu'>."))
                {
                    window.location.href='<cfoutput>#request.self#?fuseaction=account.form_add_reflecting_account&form_is_submitted=1<cfif isdefined("attributes.start_date") and len(attributes.start_date)>&start_date=#attributes.start_date#</cfif><cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>&finish_date=#attributes.finish_date#</cfif></cfoutput>';	 		
                }	
        </script>
        </cftransaction>
    </cflock>
    