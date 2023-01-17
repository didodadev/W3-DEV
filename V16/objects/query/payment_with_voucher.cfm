<cfset rd_money_value = listfirst(attributes.rd_money, ',')>
<cfscript>
	currency_multiplier ='';
	other_currency_multiplier ='';
	attributes.cash_payment = filterNum(attributes.cash_payment);
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				other_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cfset all_total =0 >
<cf_date tarih="attributes.paper_action_date">
<cfif isdefined ("attributes.paper_table_") and (attributes.paper_table_ is 'ORDERS')>
	<cfinclude template="add_order_payment_plan.cfm">
<cfelse>
	<cfscript>
		if(attributes.paper_table_ is 'INVOICE')//faturalar icin
		{
			if(attributes.paper_process_type eq 50)
				DETAIL_='VERİLEN VADE FARKI FATURASI';
			else if(attributes.paper_process_type eq 51)
				DETAIL_='ALINAN VADE FARKI FATURASI';
			else if(attributes.paper_process_type eq 52)
				DETAIL_='PERAKENDE SATIŞ FATURASI';
			else if(attributes.paper_process_type eq 53)
				DETAIL_= 'TOPTAN SATIŞ FATURASI';
			else if(attributes.paper_process_type eq 54)
				DETAIL_='PERAKENDE SATIS IADE FATURASI';
			else if(attributes.paper_process_type eq 55)
				DETAIL_='TOPTAN SATIS IADE FATURASI';
			else if(attributes.paper_process_type eq 56)
				DETAIL_='VERİLEN HIZMET FATURASI';
			else if(attributes.paper_process_type eq 57)
				DETAIL_='VERİLEN PROFORMA FATURASI';
			else if(attributes.paper_process_type eq 58)
				DETAIL_='VERİLEN FIYAT FARKI FATURASI';
			else if(attributes.paper_process_type eq 59)
				DETAIL_='MAL ALIM FATURASI';
			else if(attributes.paper_process_type eq 60)
				DETAIL_='ALINAN HIZMET FATURASI';
			else if(attributes.paper_process_type eq 61)
				DETAIL_='ALINAN PROFORMA FATURASI';
			else if(attributes.paper_process_type eq 62)
				DETAIL_='ALIM IADE FATURASI';
			else if(attributes.paper_process_type eq 63)
				DETAIL_='ALINAN FIYAT FARKI FATURASI';
			else if(attributes.paper_process_type eq 64)
				DETAIL_='MÜSTAHSIL MAKBUZU';
			else if(attributes.paper_process_type eq 65)
				DETAIL_='SABIT KIYMET ALIŞ MAKBUZU';
			else if(attributes.paper_process_type eq 66)
				DETAIL_='SABIT KIYMET SATIŞ MAKBUZU';
			else if(attributes.paper_process_type eq 531)
				DETAIL_='IHRACAT FATURASI';
			else if(attributes.paper_process_type eq 532)
				DETAIL_='KONSİNYE SATIŞ FATURASI';
			else if(attributes.paper_process_type eq 561)
				DETAIL_='VERILEN HAK EDİŞ FATURASI';
			else if(attributes.paper_process_type eq 591)
				DETAIL_='ITHALAT FATURASI';
			else if(attributes.paper_process_type eq 592)
				DETAIL_='HAL FATURASI';
			else if(attributes.paper_process_type eq 601)
				DETAIL_='ALINAN HAK EDİŞ FATURASI';
			else if(attributes.paper_process_type eq 48)
				DETAIL_='VERİLEN KUR FARKI FATURASI';
			else if(attributes.paper_process_type eq 49)
				DETAIL_='ALINAN KUR FARKI FATURASI';
			else if(attributes.paper_process_type eq 69)
				DETAIL_='Z RAPORU';
		}
		else //masraf ve gelir fisinde 
			DETAIL_=UCase(get_process_name(attributes.paper_process_type));
	</cfscript>
	<cflock name="#createUUID()#" timeout="60">
		<cftransaction>
			<cfscript>
				//oncelikle faturaya ait cari hareketler ve fatura kapamalar siliniyor, ardından yeni cari hareketler olusturulacak
				if(attributes.db_type neq 2)
					cari_sil(action_id:attributes.paper_action_id,process_type:attributes.paper_process_type);
			</cfscript>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
					<cf_date tarih='attributes.due_date#i#'>
					<cfscript>
						if(len(evaluate('attributes.voucher_name#i#')))
							temp_action_detail='#evaluate("attributes.voucher_name#i#")#';
						else
							temp_action_detail='#attributes.paper_no#';
					</cfscript>
					<cfif attributes.db_type neq 2>
						<cfscript>
							if(evaluate("attributes.voucher_value#i#") gt 0)//her bir taksit için ayrı cari hareket olusturuluyor
							{
								if( attributes.is_purchase_ eq 1) 
								{//alış faturaları ve masraf fişleri bu bolumde
									carici(
										action_id :attributes.paper_action_id,
										action_table : '#attributes.paper_table_#',
										workcube_process_type :attributes.paper_process_type,
										account_card_type : 13,
										islem_tarihi : attributes.paper_action_date,
										due_date : evaluate("attributes.due_date#i#"),
										islem_tutari :evaluate("attributes.voucher_system_value#i#"),
										islem_belge_no :attributes.paper_no,
										from_cmp_id : attributes.company_id,
										from_consumer_id : attributes.consumer_id,
										from_employee_id : attributes.employee_id,
										islem_detay : DETAIL_,
										action_detail : paper_detail,
										from_branch_id :iif(len(attributes.paper_branch_id),de('#attributes.paper_branch_id#'),de('')),
										other_money_value :evaluate("attributes.voucher_value#i#"),
										other_money : rd_money_value,
										action_detail : temp_action_detail,
										action_currency : session.ep.money,
										process_cat : attributes.paper_process_cat,
										currency_multiplier : currency_multiplier,
										project_id : attributes.paper_project_id,
										is_cash_payment:iif(evaluate("attributes.is_cash_row#i#") eq 1,1,0), //peşinat satırı ise 1 degilse 0 gönderiliyor
										rate2:other_currency_multiplier,
										payment_value:evaluate("attributes.voucher_value_hd#i#")
									);
								}
								else 
								{//satış faturaları ve gider fişleri bu bolumde
									carici(
										action_id :attributes.paper_action_id,
										action_table : '#attributes.paper_table_#',
										workcube_process_type :attributes.paper_process_type,
										account_card_type : 13,
										islem_tarihi : attributes.paper_action_date,
										due_date : evaluate("attributes.due_date#i#"),
										islem_tutari :evaluate("attributes.voucher_system_value#i#"),
										islem_belge_no :attributes.paper_no,
										to_cmp_id : attributes.company_id,
										to_consumer_id : attributes.consumer_id,
										islem_detay :DETAIL_,
										action_detail : paper_detail,
										to_branch_id :iif(len(attributes.paper_branch_id),de('#attributes.paper_branch_id#'),de('')),
										other_money_value :evaluate("attributes.voucher_value#i#"),
										other_money : rd_money_value,
										action_detail : temp_action_detail,
										action_currency : session.ep.money,
										process_cat : attributes.paper_process_cat,
										currency_multiplier : currency_multiplier,
										project_id : attributes.paper_project_id,
										is_cash_payment:iif(evaluate("attributes.is_cash_row#i#") eq 1,1,0), //peşinat satırı ise 1 degilse 0 gönderiliyor
										rate2:other_currency_multiplier,
										payment_value:evaluate("attributes.voucher_value_hd#i#")
									);
								}
							}
						</cfscript>
					</cfif>
					<cfif attributes.db_type neq 1 and not isdefined("attributes.act_row_id#i#")>
						<cfquery name="add_invoice_payment_plan" datasource="#dsn2#">
							INSERT INTO
								#dsn3_alias#.INVOICE_PAYMENT_PLAN
							(
								INVOICE_ID,
								PERIOD_ID,
								COMPANY_ID,
                                CONSUMER_ID,
                                EMPLOYEE_ID,
								ACTION_DETAIL,
								INVOICE_NUMBER,
								INVOICE_DATE,
								DUE_DATE,
								ACTION_VALUE,
								OTHER_ACTION_VALUE,
								PAYMENT_VALUE,
								OTHER_MONEY,
								PAYMENT_METHOD_ROW,
								IS_CASH_PAYMENT,
								IS_ACTIVE,
								IS_BANK,
								IS_BANK_IPTAL,
								IS_PAID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								#attributes.paper_action_id#,
								#session.ep.period_id#,
								<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                                <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                                <cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								<cfif len(temp_action_detail)>'#temp_action_detail#'<cfelse>NULL</cfif>,
								<cfif len(attributes.paper_no)>'#attributes.paper_no#'<cfelse>NULL</cfif>,
								<cfif len(attributes.paper_action_date)>#attributes.paper_action_date#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.due_date#i#") and len(evaluate("attributes.due_date#i#"))>#evaluate("attributes.due_date#i#")#<cfelse>NULL</cfif>,
								#evaluate("attributes.voucher_system_value#i#")#,
								#evaluate("attributes.voucher_value#i#")#,
								#evaluate("attributes.voucher_value_hd#i#")#,
								'#evaluate("attributes.money_type#i#")#',
								<cfif isdefined("attributes.paymethod_row_id#i#") and len(evaluate("attributes.paymethod_row_id#i#"))>#evaluate("attributes.paymethod_row_id#i#")#<cfelse>NULL</cfif>,
								<cfif evaluate("attributes.is_cash_row#i#") eq 1>1<cfelse>0</cfif>,
								<cfif isdefined("attributes.is_active#i#") and evaluate("attributes.is_active#i#") eq 1>1<cfelse>0</cfif>,
								0,
								0,
								0,
								#now()#,
								#session.ep.userid#,
								'#cgi.remote_addr#'
							)
						</cfquery>
                    <cfelseif attributes.db_type neq 1 and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))>
                    	<cfquery name="upd_invoice_payment_plan" datasource="#dsn2#">
                        	UPDATE
                            	#dsn3_alias#.INVOICE_PAYMENT_PLAN
                            SET
                            	PERIOD_ID = #session.ep.period_id#,
								COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                                CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                                EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
								ACTION_DETAIL = <cfif len(temp_action_detail)>'#temp_action_detail#'<cfelse>NULL</cfif>,
								INVOICE_NUMBER = <cfif len(attributes.paper_no)>'#attributes.paper_no#'<cfelse>NULL</cfif>,
								INVOICE_DATE = <cfif len(attributes.paper_action_date)>#attributes.paper_action_date#<cfelse>NULL</cfif>,
								DUE_DATE = <cfif isdefined("attributes.due_date#i#") and len(evaluate("attributes.due_date#i#"))>#evaluate("attributes.due_date#i#")#<cfelse>NULL</cfif>,
								ACTION_VALUE = #evaluate("attributes.voucher_system_value#i#")#,
								OTHER_ACTION_VALUE = #evaluate("attributes.voucher_value#i#")#,
								PAYMENT_VALUE = #evaluate("attributes.voucher_value_hd#i#")#,
								OTHER_MONEY = '#evaluate("attributes.money_type#i#")#',
								PAYMENT_METHOD_ROW = <cfif isdefined("attributes.paymethod_row_id#i#") and len(evaluate("attributes.paymethod_row_id#i#"))>#evaluate("attributes.paymethod_row_id#i#")#<cfelse>NULL</cfif>,
								IS_CASH_PAYMENT = <cfif evaluate("attributes.is_cash_row#i#") eq 1>1<cfelse>0</cfif>,
								IS_ACTIVE = <cfif isdefined("attributes.is_active#i#") and evaluate("attributes.is_active#i#") eq 1>1<cfelse>0</cfif>,
								IS_BANK = <cfif isdefined("attributes.is_bank_#i#") and evaluate("attributes.is_bank_#i#") eq 1>1<cfelse>0</cfif>,
								IS_PAID = <cfif isdefined("attributes.is_paid#i#") and evaluate("attributes.is_paid#i#") eq 1>1<cfelse>0</cfif>,
								UPDATE_DATE = #now()#,
								UPDATE_EMP = #session.ep.userid#,
								UPDATE_IP = '#cgi.remote_addr#'
                        	WHERE
                            	INVOICE_PAYMENT_PLAN_ID = #evaluate("attributes.act_row_id#i#")#
                        </cfquery>
                    </cfif>
                <cfelseif isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))>
                    <cfquery name="del_invoice_payment_plan" datasource="#dsn2#">
                        DELETE FROM #dsn3_alias#.INVOICE_PAYMENT_PLAN WHERE INVOICE_PAYMENT_PLAN_ID = #evaluate("attributes.act_row_id#i#")#
                    </cfquery>
				</cfif>
			</cfloop>
			
			<cfif attributes.paper_table_ is 'INVOICE'>
				<cfif isdefined("attributes.average_due_date") and isdate(attributes.average_due_date)>
                    <cf_date tarih="attributes.average_due_date">
                </cfif>
            
				<cfquery name="UPD_INV" datasource="#dsn2#"> <!--- faturada parcalı cari işlem yapıldıgı tutuluyor --->
					UPDATE 
                    	INVOICE 
                    SET 
                    	CARI_ACTION_TYPE=5,
                        DUE_DATE = #attributes.average_due_date#<!--- faturadaki vade ortalama vade ile update ediliyor --->
                    WHERE 
                    	INVOICE_ID=#attributes.paper_action_id#
				</cfquery>
                
                <cfquery name="UPD_INV_ROW" datasource="#dsn2#"> <!--- satirlardaki vade günü update ediliyor --->
					UPDATE 
                    	INVOICE_ROW
                    SET 
                        DUE_DATE = #abs(datediff('d',attributes.paper_action_date,attributes.average_due_date))#<!--- faturadaki vade ortalama vade ile update ediliyor --->
                    WHERE 
                    	INVOICE_ID=#attributes.paper_action_id#
				</cfquery>
			<cfelseif attributes.paper_table_ is 'EXPENSE_ITEM_PLANS'>
				<cfquery name="UPD_INV" datasource="#dsn2#"> <!--- masrafta parcalı cari işlem yapıldıgı tutuluyor --->
					UPDATE EXPENSE_ITEM_PLANS SET CARI_ACTION_TYPE=5 WHERE EXPENSE_ID=#attributes.paper_action_id#
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
