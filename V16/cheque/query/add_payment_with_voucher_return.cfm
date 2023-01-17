<cfquery name="get_process_type_return" datasource="#dsn2#" maxrows="1">
	SELECT
		PROCESS_CAT_ID,
		IS_CARI,
		IS_ACCOUNT,
		IS_CHEQUE_BASED_ACTION
	FROM
		#dsn3_alias#.SETUP_PROCESS_CAT
	WHERE
		PROCESS_TYPE = 101
</cfquery>
<cfset process_type_return = 101>
<cfquery name="get_voucher_" datasource="#dsn2#">
	SELECT SUM(OTHER_MONEY_VALUE) AS TOTAL_VALUE FROM VOUCHER WHERE VOUCHER_ID IN (#attributes.voucher_list#)
</cfquery>
<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>	
<cfset my_payroll_no = belge_no>
<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
	INSERT INTO
		VOUCHER_PAYROLL
		(
			PROCESS_CAT,
			PAYROLL_TYPE,
			PAYROLL_TOTAL_VALUE,
			PAYROLL_OTHER_MONEY,
			PAYROLL_OTHER_MONEY_VALUE,
			NUMBER_OF_VOUCHER,
			COMPANY_ID,
			CONSUMER_ID,
			CURRENCY_ID,
			PAYROLL_REVENUE_DATE,
			PAYROLL_REV_MEMBER,
			PAYROLL_NO,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			VOUCHER_BASED_ACC_CARI
		)
		VALUES
		(
			#get_process_type_return.process_cat_id#,
			#process_type_return#,
			#get_voucher_.total_value#,
			'#session.ep.money#',
			#get_voucher_.total_value#,
			#listlen(attributes.voucher_list)#,
			<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
			'#session.ep.money#',
			#attributes.payroll_revenue_date#,
			#session.ep.userid#,
			'#my_payroll_no#',
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>
		)
</cfquery>
<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
	SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
</cfquery>
<cfset p_id=get_bordro_id.P_ID> 
<cfoutput query="get_moneys">
	<cfquery name="add_money_obj_bskt" datasource="#dsn2#">
		INSERT INTO VOUCHER_PAYROLL_MONEY 
		(
			ACTION_ID,
			MONEY_TYPE,
			RATE2,
			RATE1,
			IS_SELECTED
		)
		VALUES
		(
			#P_ID#,
			'#get_moneys.money#',
			#get_moneys.rate2#,
			#get_moneys.rate1#,
		<cfif get_moneys.money is session.ep.money>
			1
		<cfelse>
			0
		</cfif>					
		)
	</cfquery>
</cfoutput>	
<cfquery name="get_vouchers_all_" datasource="#dsn2#">
	SELECT * FROM VOUCHER WHERE VOUCHER_ID IN (#attributes.voucher_list#)				
</cfquery>	
<cfoutput query="get_vouchers_all_">
	<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
		UPDATE VOUCHER SET VOUCHER_STATUS_ID=9 WHERE VOUCHER_ID= #get_vouchers_all_.voucher_id#
	</cfquery>
	<!--- Bordroya girilen senetler için voucher_history tablosuna giris yapiliyor...--->
	<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#">
		INSERT INTO
			VOUCHER_HISTORY
			(
				VOUCHER_ID,
				PAYROLL_ID,
				STATUS,
				ACT_DATE,
				OTHER_MONEY_VALUE,
				OTHER_MONEY,
				OTHER_MONEY_VALUE2,
				OTHER_MONEY2,
				RECORD_DATE
			)
			VALUES
			(
				#get_vouchers_all_.voucher_id#,
				#p_id#,
				9,
				#attributes.payroll_revenue_date#,
				#get_vouchers_all_.OTHER_MONEY_VALUE#,
				'#get_vouchers_all_.OTHER_MONEY#',
				#get_vouchers_all_.OTHER_MONEY_VALUE2#,
				'#get_vouchers_all_.OTHER_MONEY2#',
				#now()#
			)
	</cfquery>
</cfoutput>
<!--- add cari --->
<cfscript>
	if(is_cari eq 1)
	{
		if(is_voucher_based eq 1) /*cari hareket senet bazında yapılıyor.senet bazında carici calıstırılırken ACTION_TABLE parametresine dikkat plz...*/
		{
			for(ind_cari=1; ind_cari lte get_vouchers_all_.recordcount; ind_cari=ind_cari+1)
			{
				if(get_vouchers_all_.currency_id[ind_cari] is not session.ep.money)
				{
					other_money =get_vouchers_all_.currency_id[ind_cari];
					other_money_value =get_vouchers_all_.voucher_value[ind_cari];
				}
				else
				{
					other_money = get_vouchers_all_.other_money[ind_cari];
					other_money_value = get_vouchers_all_.other_money_value[ind_cari];
				}
				carici(
					action_id :get_vouchers_all_.voucher_id[ind_cari],
					workcube_process_type :process_type_return,		
					process_cat : get_process_type_return.process_cat_id,
					account_card_type :13,
					action_table :'VOUCHER',
					islem_tarihi :attributes.payroll_revenue_date,
					islem_tutari :get_vouchers_all_.other_money_value[ind_cari],
					other_money_value : other_money_value,
					other_money : other_money,
					islem_belge_no : get_vouchers_all_.voucher_no[ind_cari],
					action_currency : session.ep.money,
					payer_id :session.ep.userid,
					to_cmp_id :attributes.company_id,
					to_consumer_id:attributes.consumer_id,
					due_date : createodbcdatetime(get_vouchers_all_.voucher_duedate[ind_cari]),
					currency_multiplier : currency_multiplier,
					payroll_id :P_ID, 
					islem_detay : 'SENET İADE ÇIKIŞ BORDROSU(Senet Bazında)',
					to_branch_id : ListGetAt(session.ep.user_location,2,"-")
					);
			}
		}
		else
		{
			carici(
				action_id :P_ID,
				workcube_process_type :process_type_return,		
				process_cat : get_process_type_return.process_cat_id,
				account_card_type :13,
				action_table :'VOUCHER_PAYROLL',
				islem_tarihi :attributes.payroll_revenue_date,
				islem_tutari :get_voucher_.total_value,
				other_money_value : get_voucher_.total_value,
				other_money : session.ep.money,
				islem_belge_no : my_payroll_no,
				action_currency : session.ep.money,
				payer_id :session.ep.userid,
				to_cmp_id :form.company_id,
				to_consumer_id:form.consumer_id,
				due_date : average_due_date,
				currency_multiplier : currency_multiplier,
				islem_detay : 'SENET İADE ÇIKIŞ BORDROSU',
				to_branch_id : ListGetAt(session.ep.user_location,2,"-")
				);
		}
	}
	if (is_account eq 1)
	{
		alacakli_hesaplar = '';
		alacakli_tutarlar = '';
		other_amount_alacak_list = '';
		other_currency_alacak_list = '';
		GET_NO_=cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE");
		for(ind_cari=1; ind_cari lte get_vouchers_all_.recordcount; ind_cari=ind_cari+1)
		{
			if(get_vouchers_all_.currency_id[ind_cari] is session.ep.money)
				alacakli_tutarlar=listappend(alacakli_tutarlar,get_vouchers_all_.voucher_value[ind_cari],',');
			else
				alacakli_tutarlar=listappend(alacakli_tutarlar,get_vouchers_all_.other_money_value[ind_cari],',');
			if(get_vouchers_all_.currency_id[ind_cari] is not session.ep.money)
			{
				other_currency_alacak_list =listappend(other_currency_alacak_list,get_vouchers_all_.currency_id[ind_cari],',');
				other_amount_alacak_list =listappend(other_amount_alacak_list,get_vouchers_all_.voucher_value[ind_cari],',');
			}
			else
			{
			other_currency_alacak_list = listappend(other_currency_alacak_list,get_vouchers_all_.other_money[ind_cari],',');
			other_amount_alacak_list =  listappend(other_amount_alacak_list,get_vouchers_all_.other_money_value[ind_cari],',');
			}
			if(len(get_vouchers_all_.account_code[ind_cari]))
				alacakli_hesaplar=listappend(alacakli_hesaplar,get_vouchers_all_.account_code[ind_cari],',');
			else if(get_vouchers_all_.voucher_status_id[ind_cari] eq 5)
			{
				GET_ACC_CODE=cfquery(datasource:"#dsn2#",sqlstring:"
					SELECT
						A.ACCOUNT_ACC_CODE
					FROM
						VOUCHER_PAYROLL AS P,
						VOUCHER_HISTORY AS CH,
						#dsn3_alias#.ACCOUNTS AS A
					WHERE
						P.PAYROLL_ACCOUNT_ID = A.ACCOUNT_ID AND
						P.PAYROLL_TYPE=100 AND
						P.ACTION_ID= CH.PAYROLL_ID AND
						CH.VOUCHER_ID=#get_vouchers_all_.voucher_id[ind_cari]#");
				if (GET_ACC_CODE.recordcount)
					alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE.ACCOUNT_ACC_CODE, ',');
				else// karsılıksız senet açılış bordrosuyla gelmişse, açılış bordrosundaki banka hesabı alınıyor 
				{	
					GET_ACC_CODE_1=cfquery(datasource:"#dsn2#",sqlstring:"
						SELECT
							C.A_VOUCHER_ACC_CODE
						FROM
							VOUCHER_PAYROLL AS P,
							VOUCHER_HISTORY AS CH,
							CASH AS C
						WHERE
							P.PAYROLL_CASH_ID = C.CASH_ID AND
							P.PAYROLL_TYPE=97 AND
							P.ACTION_ID= CH.PAYROLL_ID AND
							CH.VOUCHER_ID=#get_vouchers_all_.voucher_id[ind_cari]#");
					if (GET_ACC_CODE_1.recordcount)
						alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE_1.A_VOUCHER_ACC_CODE, ',');
					else
					{
						GET_ACC_CODE_2=cfquery(datasource:"#dsn2#",sqlstring:"
							SELECT
								A.ACCOUNT_ACC_CODE
							FROM
								VOUCHER_PAYROLL AS P,
								VOUCHER_HISTORY AS CH,
								#dsn3_alias#.ACCOUNTS AS A
							WHERE
								P.PAYROLL_ACCOUNT_ID = A.ACCOUNT_ID AND
								P.PAYROLL_TYPE = 107 AND
								P.PAYROLL_NO = '-1' AND
								P.ACTION_ID= CH.PAYROLL_ID AND
								CH.VOUCHER_ID = #get_vouchers_all_.voucher_id[ind_cari]#");
						 alacakli_hesaplar=listappend(alacakli_hesaplar,GET_ACC_CODE_2.ACCOUNT_ACC_CODE, ',');
					}
				}
			}	
			else if(get_vouchers_all_.voucher_status_id[ind_cari] eq 1)
			{
					GET_ACC_CODE_3=cfquery(datasource:"#dsn2#",sqlstring:"
						SELECT
							C.A_VOUCHER_ACC_CODE
						FROM
							VOUCHER_PAYROLL AS P,
							VOUCHER_HISTORY AS CH,
							CASH AS C
						WHERE
							P.PAYROLL_CASH_ID = C.CASH_ID AND
							P.PAYROLL_TYPE=97 AND
							P.ACTION_ID= CH.PAYROLL_ID AND
							CH.VOUCHER_ID=#get_vouchers_all_.voucher_id[ind_cari]#");
				if (GET_ACC_CODE_3.recordcount)
					alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE_3.A_VOUCHER_ACC_CODE, ',');
				else
				{
					GET_ACC_CODE_4=cfquery(datasource:"#dsn2#",sqlstring:"
						SELECT
							C.A_VOUCHER_ACC_CODE
						FROM
							VOUCHER_PAYROLL AS P,
							VOUCHER_HISTORY AS CH,
							CASH AS C
						WHERE
							P.PAYROLL_CASH_ID = C.CASH_ID AND
							P.PAYROLL_TYPE = 107 AND
							P.PAYROLL_NO = '-1' AND
							P.ACTION_ID= CH.PAYROLL_ID AND
							CH.VOUCHER_ID=#get_vouchers_all_.voucher_id[ind_cari]#");
					alacakli_hesaplar=listappend(alacakli_hesaplar, GET_ACC_CODE_4.A_VOUCHER_ACC_CODE, ',');
				}
			}
		}
		muhasebeci (
			action_id:p_id,
			workcube_process_type:process_type_return,
			account_card_type:13,
			action_table :'VOUCHER_PAYROLL',
			islem_tarihi:attributes.payroll_revenue_date,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			borc_hesaplar: acc,
			borc_tutarlar: get_voucher_.total_value,
			other_amount_borc : get_voucher_.total_value,
			other_currency_borc : session.ep.money,
			alacak_hesaplar: alacakli_hesaplar,
			alacak_tutarlar: alacakli_tutarlar,
			other_amount_alacak : other_amount_alacak_list,
			other_currency_alacak : other_currency_alacak_list,
			currency_multiplier : currency_multiplier,
			fis_detay:'SENET İADE ÇIKIŞ İŞLEMİ',
			fis_satir_detay:'SENET İADE ÇIKIŞ İŞLEMİ',
			belge_no : my_payroll_no,
			from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
			dept_round_account :GET_NO_.FARK_GIDER,
			claim_round_account : GET_NO_.FARK_GELIR,
			max_round_amount :0.09,
			round_row_detail:'SENET İADE ÇIKIŞ İŞLEMİ',
			workcube_process_cat : get_process_type_return.process_cat_id
			);
	}
</cfscript> 
