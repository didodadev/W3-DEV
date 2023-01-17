<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script language="JavaScript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script language="javascript">
		alert("Dosya Okunamadı ! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>

<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
	satir_say =0;
</cfscript>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS=1
</cfquery>
<cfif len(session.ep.money2)>
	<cfquery name="get_rate" dbtype="query">
		SELECT * FROM get_money WHERE MONEY = '#session.ep.money2#'
	</cfquery>
	<cfset currency_multiplier = get_rate.rate2/get_rate.rate1>
<cfelse>
	<cfset currency_multiplier = ''>
</cfif>
<cf_date tarih='attributes.fis_date'>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
					satir_say=satir_say+1;				
					
					inventory_no = Listgetat(dosya[i],j,";");//Demirbaş No
					inventory_no = trim(inventory_no);
					j=j+1;
					
					inventory_cat = Listgetat(dosya[i],j,";");//Demirbaş Kategorisi
					inventory_cat = trim(inventory_cat);
					j=j+1;
					
					inventory_detail = Listgetat(dosya[i],j,";");//Açıklama
					inventory_detail = trim(inventory_detail);
					j=j+1;
					
					entry_date = Listgetat(dosya[i],j,";");//Giriş Tarihi
					entry_date = trim(entry_date);
					entry_date = replace(entry_date,' ','','all');
					j=j+1;
					
					quantity = Listgetat(dosya[i],j,";");//Miktar
					quantity = trim(quantity);
					j=j+1;
					
					period_invent_value = Listgetat(dosya[i],j,";");//Dönem başı değer
					period_invent_value = trim(period_invent_value);
					period_invent_value=Replace(period_invent_value,',','.');
					j=j+1;
					
					period_invent_value_2 = Listgetat(dosya[i],j,";");//Dönem başı değer 2. döviz değeri
					period_invent_value_2 = trim(period_invent_value_2);
					period_invent_value_2=Replace(period_invent_value_2,',','.');
					j=j+1;
					
					period_amort_value = Listgetat(dosya[i],j,";");//Dönem amortismanı
					period_amort_value = trim(period_amort_value);
					period_amort_value=Replace(period_amort_value,',','.');
					j=j+1;
					
					period_amort_value_2 = Listgetat(dosya[i],j,";");//Dönem amortismanı 2. döviz değeri
					period_amort_value_2 = trim(period_amort_value_2);
					period_amort_value_2=Replace(period_amort_value_2,',','.');
					j=j+1;
					
					money_type = Listgetat(dosya[i],j,";");//İşlem  para birimi
					money_type = trim(money_type);
					j=j+1;
					
					amortization_duration = Listgetat(dosya[i],j,";");//Faydali Omur
					amortization_duration = trim(amortization_duration);
					amortization_duration=Replace(amortization_duration,',','.');
					j=j+1;
					
					amortization_rate = Listgetat(dosya[i],j,";");//Amortisman oranı
					amortization_rate = trim(amortization_rate);
					amortization_rate=Replace(amortization_rate,',','.');
					j=j+1;
					
					amortization_type = Listgetat(dosya[i],j,";");//Amortisman türü
					amortization_type = trim(amortization_type);
					j=j+1;
			
					account_code = Listgetat(dosya[i],j,";");//Demirbaş Muhasebe Kodu 
					account_code = trim(account_code);
					j=j+1;
					
					expense_center_id = Listgetat(dosya[i],j,";");//Demirbaş Masraf Merkezi
					expense_center_id = trim(expense_center_id);
					j=j+1;
					
					expense_item_id = Listgetat(dosya[i],j,";");//Demirbaş Bütçe Kalemi
					expense_item_id = trim(expense_item_id);
					j=j+1;
					
					period = Listgetat(dosya[i],j,";");//Demirbaş hesaplama dönemi
					period = trim(period);
					j=j+1;
					
					debt_account_code = Listgetat(dosya[i],j,";");//Demirbaş Borç Muhasebe Kodu 
					debt_account_code = trim(debt_account_code);
					j=j+1;
					
					claim_account_code = Listgetat(dosya[i],j,";");//Demirbaş Alacak Muhasebe Kodu 
					claim_account_code = trim(claim_account_code);
					j=j+1;
					
					stock_id = Listgetat(dosya[i],j,";");//Stok Id
					stock_id = trim(stock_id);
					j=j+1;
					
					if(listlen(dosya[i],';') gte j)
					{
						sub_id = Listgetat(dosya[i],j,";");//Sistem Id
						sub_id = trim(sub_id);
					}				
					else
						sub_id = '';
				</cfscript>
				<cfcatch type="Any">
					<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
			<cfif error_flag neq 1>
				<cfif not len(inventory_no)or not len(inventory_detail) or not len(entry_date) or not len(period_invent_value) or not len(amortization_rate) or not len(account_code) or not len(amortization_type)>
					<cfoutput>
						<script language="JavaScript">
							alert("#i#. <cf_get_lang no ='2513.satırdaki zorunlu alanlarda eksik değerler var Lütfen dosyanızı kontrol ediniz'> !");
							window.close();
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
				<cftry>
					<cfif len(period_amort_value)>
						<cfset row_total = period_invent_value - period_amort_value>
					<cfelse>
						<cfset row_total = period_invent_value>
					</cfif>
					<cfif row_total lt 0><cfset row_total = 0></cfif>
                    <cfif len(period_invent_value_2)>
                    	<cfif len(period_amort_value_2)>
                        	<cfset row_total_2 = period_invent_value_2 - period_amort_value_2>
                        <cfelse>
                        	<cfset row_total_2 = period_invent_value_2>
                        </cfif>
                        <cfif row_total_2 lt 0><cfset row_total_2 = 0></cfif>
                    </cfif>
					<cf_date tarih='entry_date'>
					<cfset satir_no = satir_no + 1>
					<cfif len(stock_id)>
						<cfquery name="GET_PRODUCT_NAME" datasource="#dsn2#">
							SELECT S.PRODUCT_NAME,S.STOCK_ID,S.PRODUCT_ID,PU.MAIN_UNIT UNIT,UNIT_ID FROM #dsn3_alias#.STOCKS S,#dsn3_alias#.PRODUCT_UNIT PU WHERE PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND S.STOCK_ID = #stock_id#
						</cfquery>
					</cfif>
					<cfquery name="get_gen_paper_" datasource="#dsn2#">
						SELECT 
                        	* 
                        FROM 
                        	#dsn3_alias#.GENERAL_PAPERS 
                        WHERE 
                        	ZONE_TYPE = 0
					</cfquery>
					<cfif isdefined("attributes.is_stock_fis") and len(stock_id) and get_product_name.recordcount><!--- Stok fişi kaydedilsin seçilmiş ise --->
						<cfset paper_code = evaluate('get_gen_paper_.STOCK_FIS_NO')>
						<cfset system_paper_no_add = evaluate('get_gen_paper_.STOCK_FIS_NUMBER') +1>
						<cfset attributes.FIS_NO = '#paper_code#-#system_paper_no_add#'>
						<cfquery name="get_inventory_type" datasource="#dsn2#">
							SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_COST FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 118 AND IS_DEFAULT = 1
						</cfquery>
						<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
							SELECT MONEY MONEY_TYPE,* FROM SETUP_MONEY WHERE MONEY_STATUS = 1
						</cfquery>
						<cfquery name="GET_PROCESS_MONEY" datasource="#dsn2#">
							SELECT ISNULL(STANDART_PROCESS_MONEY,OTHER_MONEY) MONEY_TYPE FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
						</cfquery>
						<cfquery name="GET_BRANCH" datasource="#dsn2#">
							SELECT * FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = #attributes.department_id_2#
						</cfquery>
						<cfscript>
							if(len(money_type)) row_other_money = money_type; else row_other_money=GET_PROCESS_MONEY.MONEY_TYPE;
							attributes.start_date = attributes.fis_date;
							rd_money_value =row_other_money;
							form.process_cat = "#get_inventory_type.PROCESS_CAT_ID#";
							attributes.process_cat = "#get_inventory_type.PROCESS_CAT_ID#";
							attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
							for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
							{
								if(row_other_money eq GET_MONEY_INFO.MONEY[stp_mny])
									attributes.rd_money = "#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#,#stp_mny#,#GET_MONEY_INFO.RATE1[stp_mny]#,#GET_MONEY_INFO.RATE2[stp_mny]#";
								if(row_other_money eq GET_MONEY_INFO.MONEY[stp_mny])
									currency_mult_other = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);
					
								'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY_TYPE[stp_mny];
								'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
								'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
								'attributes.t_txt_rate1_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE1[stp_mny];	
								'attributes.t_txt_rate2_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE2[stp_mny];
							}
							attributes.department_id_2 = attributes.department_id_2;
							attributes.location_id_2 = attributes.location_id_2;
							attributes.department_id = "";
							attributes.location_id = "";
							branch_id_2 = GET_BRANCH.BRANCH_ID;
							branch_id = "";
							deliver_get_id = session.ep.userid;
					
							attributes.ref_no = '';
							attributes.project_id = '';
							attributes.project_head = '';
							attributes.detail = '';
							attributes.subscription_id = sub_id;
							attributes.record_num = 1;
							
							row_gross_total = row_total;
							row_tax_total = 0;
							row_rate_1 = evaluate('attributes.t_txt_rate1_#row_other_money#');
							row_rate_2 = evaluate('attributes.t_txt_rate2_#row_other_money#');
							row_currency_mult = row_rate_2 / row_rate_1;
							if(len(period_invent_value_2) && len(period_amort_value_2)) row_other_gross_total = row_total_2;
							row_other_gross_total = row_total/row_currency_mult;
							row_info = 1;
							'attributes.row_kontrol#row_info#' = 1;
							'attributes.invent_no#row_info#' = inventory_no;
							'attributes.invent_name#row_info#' = inventory_detail;
							'attributes.quantity#row_info#' = quantity;
							'attributes.row_total#row_info#' = row_gross_total;
							'attributes.amortization_rate#row_info#' = amortization_rate;
							'attributes.amortization_method#row_info#' = attributes.amor_method;
							'attributes.account_id#row_info#' = account_code;
							'attributes.period#row_info#' = period;
							'attributes.expense_center_id#row_info#' = expense_center_id;
							'attributes.expense_item_id#row_info#' = expense_item_id;
							'attributes.debt_account_id#row_info#' = debt_account_code;
							'attributes.claim_account_id#row_info#' = claim_account_code;								
							'attributes.expense_item_name#row_info#' = "Gider Kalemi";
							'attributes.inventory_cat_id#row_info#' = inventory_cat;
							'attributes.inventory_cat#row_info#' = 'Sabit Kiymet Kategorisi';
							'attributes.inventory_duration#row_info#' = amortization_duration;
							'attributes.amortization_type#row_info#' = amortization_type;
							'attributes.subscription_id#row_info#' = sub_id;
							'attributes.stock_id#row_info#' = GET_PRODUCT_NAME.STOCK_ID;
							'attributes.product_id#row_info#' = GET_PRODUCT_NAME.PRODUCT_ID;
							'attributes.stock_unit#row_info#' = GET_PRODUCT_NAME.UNIT;
							'attributes.stock_unit_id#row_info#' = GET_PRODUCT_NAME.UNIT_ID;
							'attributes.row_other_total#row_info#' = row_other_gross_total;
							'attributes.tax_rate#row_info#' = 0;
							'attributes.kdv_total#row_info#' = row_tax_total;
							'attributes.money_id#row_info#' = row_other_money;
						</cfscript>
						<cfquery name="ADD_STOCK_FIS" datasource="#DSN2#">
							INSERT INTO
								STOCK_FIS
							(
								FIS_TYPE,
								PROCESS_CAT,
								DEPARTMENT_OUT,
								LOCATION_OUT,
								<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
								DEPARTMENT_IN,
								LOCATION_IN,
								</cfif>
								FIS_NUMBER,
								EMPLOYEE_ID,
								FIS_DATE,
								REF_NO,
								PROJECT_ID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								FIS_DETAIL,
								SUBSCRIPTION_ID,
								RELATED_SHIP_ID
							)
							VALUES
							(
								118,
								#attributes.PROCESS_CAT#,
								#attributes.department_id_2#,
								#attributes.location_id_2#,	
								<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
								#attributes.department_id#,
								#attributes.location_id#,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
								#DELIVER_GET_ID#,
								#attributes.start_date#,
								<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
								#now()#,
								#session.ep.userid#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
								<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
								<cfif isDefined("related_ship_id") and len(related_ship_id)>#related_ship_id#<cfelse>NULL</cfif>
							)
						</cfquery>
						<cfquery name="GET_S_ID" datasource="#DSN2#">
							SELECT MAX(FIS_ID) MAX_ID FROM STOCK_FIS
						</cfquery>
						<cfloop from="1" to="#attributes.kur_say#" index="i">
							<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
								INSERT INTO STOCK_FIS_MONEY 
								(
									ACTION_ID,
									MONEY_TYPE,
									RATE2,
									RATE1,
									IS_SELECTED
								)
								VALUES
								(
									#GET_S_ID.MAX_ID#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.hidden_rd_money_#i#")#'>,
									#evaluate("attributes.txt_rate2_#i#")#,
									#evaluate("attributes.txt_rate1_#i#")#,
									<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
								)
							</cfquery>
						</cfloop>
						<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
							UPDATE 
								#dsn3_alias#.GENERAL_PAPERS
							SET
								STOCK_FIS_NUMBER = #system_paper_no_add#
							WHERE
								STOCK_FIS_NUMBER IS NOT NULL
						</cfquery>
					</cfif>
					<cfquery name="add_invent" datasource="#dsn2#">
						INSERT INTO 
							#dsn3_alias#.INVENTORY
						(
							INVENTORY_NUMBER,
							INVENTORY_NAME,
							QUANTITY,
							AMOUNT,
							AMOUNT_2,
							AMORTIZATON_ESTIMATE,
							AMORTIZATON_METHOD,
							LAST_INVENTORY_VALUE,
							LAST_INVENTORY_VALUE_2,
							AMORT_LAST_VALUE,
							ACCOUNT_ID,
							CLAIM_ACCOUNT_ID,
							DEBT_ACCOUNT_ID,
							ACCOUNT_PERIOD,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							ENTRY_DATE,
							INVENTORY_CATID,
							INVENTORY_DURATION,
							AMORTIZATION_TYPE,
							SUBSCRIPTION_ID,
							INVENTORY_TYPE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#inventory_no#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#inventory_detail#">,
							<cfif len(quantity)>#quantity#<cfelse>1</cfif>,
							#period_invent_value#,
                            <cfif len(period_invent_value_2)>#wrk_round(period_invent_value_2)#<cfelseif len(currency_multiplier)>#wrk_round(period_invent_value/currency_multiplier)#<cfelse>NULL</cfif>, <!---2. döviz değeri girilmişse onu kaydet, girilmemişse hesaplayıp kaydet--->
							#amortization_rate#,
							#attributes.amor_method#,
							#row_total#,
                            <cfif len(period_invent_value_2) and len(period_amort_value_2)>#wrk_round(row_total_2)#<cfelseif len(currency_multiplier)>#wrk_round(row_total/currency_multiplier)#<cfelse>NULL</cfif>,
							#row_total#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#account_code#">,
							<cfif len(claim_account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#claim_account_code#"><cfelse>NULL</cfif>,
							<cfif len(debt_account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#debt_account_code#"><cfelse>NULL</cfif>,
							<cfif len(period)>#period#<cfelse>1</cfif>,
							<cfif len(expense_center_id)>#expense_center_id#<cfelse>NULL</cfif>,
							<cfif len(expense_item_id)>#expense_item_id#<cfelse>NULL</cfif>,
							#entry_date#,
							<cfif len(inventory_cat)>#inventory_cat#<cfelse>NULL</cfif>,
							<cfif len(amortization_duration)>#amortization_duration#<cfelse>NULL</cfif>,
							#amortization_type#,
							<cfif len(sub_id)>#sub_id#<cfelse>NULL</cfif>,
							#attributes.inventory_type#,
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
						</cfquery>
						<cfquery name="get_inventory_id" datasource="#dsn2#">
							SELECT MAX(INVENTORY_ID) AS MAX_ID FROM #dsn3_alias#.INVENTORY
						</cfquery>
						<cfquery name="add_invent_row" datasource="#dsn2#">
							INSERT INTO 
								#dsn3_alias#.INVENTORY_ROW
							(
								INVENTORY_ID,
								PERIOD_ID,
								ACTION_ID,
								PAPER_NO,
								PROCESS_TYPE,
								QUANTITY,
								STOCK_IN,
								SUBSCRIPTION_ID,
								ACTION_DATE,
								STOCK_ID,
								PRODUCT_ID
							)
							VALUES
							(
								#get_inventory_id.max_id#,
								#session.ep.period_id#,
								<cfif isdefined("attributes.is_stock_fis") and len(stock_id) and get_product_name.recordcount>#GET_S_ID.MAX_ID#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.is_stock_fis") and len(stock_id) and get_product_name.recordcount><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.is_stock_fis") and len(stock_id) and get_product_name.recordcount>118<cfelse>1181</cfif>,
								<cfif len(quantity)>#quantity#<cfelse>1</cfif>,
								<cfif len(quantity)>#quantity#<cfelse>1</cfif>,
								<cfif len(sub_id)>#sub_id#<cfelse>NULL</cfif>,
								#entry_date#,
								<cfif isdefined("attributes.is_stock_fis") and len(stock_id)>#stock_id#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.is_stock_fis") and len(stock_id)>#get_product_name.product_id#<cfelse>NULL</cfif>
							)
						</cfquery>
						<cfif isdefined("attributes.is_stock_fis") and len(stock_id) and get_product_name.recordcount>
							<cfset act_id_ = GET_S_ID.MAX_ID>
							<cfset act_type_ = 118>
						<cfelse>
							<cfset act_id_ = ''>
							<cfset act_type_ = 1181>
						</cfif>
						<!--- demirbasa ait history kaydi --->
						<cfset cmp = createObject("component","V16.inventory.cfc.inventory_history") />
						<cfset cmp.add_inventory_history(
								inventory_id : get_inventory_id.max_id,
								action_id :  act_id_,
								action_type : act_type_,
								action_date : entry_date,
								expense_center_id : expense_center_id,
								expense_item_id : expense_item_id,
								claim_account_code : claim_account_code,
								debt_account_code : debt_account_code,
								account_code : account_code,
								inventory_duration : amortization_duration,
								amortization_rate : amortization_rate
						) />
						
						<cfif isdefined("attributes.is_stock_fis") and len(stock_id) and get_product_name.recordcount><!--- Stok fişi kaydedilsin seçilmiş ise --->
							<cfset kk = 1>
							<cfquery name="ADD_STOCK_FIS_ROW" datasource="#DSN2#">
								INSERT INTO 
									STOCK_FIS_ROW
									(
										FIS_ID,
										FIS_NUMBER,
										STOCK_ID,
										AMOUNT,
										UNIT,
										UNIT_ID,							
										PRICE,
										PRICE_OTHER,
										TAX,
										DISCOUNT1,
										DISCOUNT2,
										DISCOUNT3,
										DISCOUNT4,
										DISCOUNT5,
										TOTAL,
										TOTAL_TAX,
										NET_TOTAL,
										OTHER_MONEY,
										INVENTORY_ID
									)
								VALUES
									(
										#GET_S_ID.MAX_ID#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,							
										#evaluate("attributes.stock_id#kk#")#,
										#evaluate("attributes.quantity#kk#")#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.stock_unit#kk#")#'>,
										#evaluate("attributes.stock_unit_id#kk#")#,							
										#evaluate("attributes.row_total#kk#")#,
										#(evaluate("attributes.row_other_total#kk#")/evaluate("attributes.quantity#kk#"))#,
										#evaluate("attributes.tax_rate#kk#")#,
										0,
										0,
										0,
										0,
										0,
										#evaluate("attributes.row_total#kk#") * evaluate("attributes.quantity#kk#")#,
										#evaluate("attributes.kdv_total#kk#")#,
										#(evaluate("attributes.row_total#kk#") * evaluate("attributes.quantity#kk#")) + evaluate("attributes.kdv_total#kk#")#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.money_id#kk#'),1,',')#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_inventory_id.max_id#">
									)
							</cfquery>
						</cfif>
					<cfcatch type="Any">
						<cfoutput>#i#</cfoutput>. satır 2. adımda sorun oluştu.<br/>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfoutput><cf_get_lang no='2664.İmport edilen satır sayısı'>: #satir_no# !!!</cfoutput><br/>
<cfoutput><cf_get_lang no='2655.Toplam belge satır sayısı'>: #satir_say# !!!</cfoutput>

