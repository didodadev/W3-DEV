<cfset product_id_list = ''>
<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_BANK_INFO" datasource="#DSN2#">
	SELECT
    	A.ACCOUNT_NO,
        A.ACCOUNT_NAME,
        A.BRANCH_CODE,
        A.ACCOUNT_OWNER_CUSTOMER_NO,
        BANK_BRANCH.BANK_BRANCH_NAME,
		SETUP_BANK_TYPES.BANK_NAME
    FROM
    	BANK_ORDERS BO,
        #dsn3_alias#.ACCOUNTS A,
        #dsn3_alias#.BANK_BRANCH,
		#dsn_alias#.SETUP_BANK_TYPES
    WHERE
		BANK_BRANCH.BANK_ID = SETUP_BANK_TYPES.BANK_ID AND
		A.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
    	BO.ACCOUNT_ID = A.ACCOUNT_ID AND
    	BO.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>

<cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
    SELECT 
        OMC.IS_TYPE,
        OMCU.ORDER_CREDIT_ID,
        OMCU.USED_VALUE 
    FROM 
        ORDER_MONEY_CREDIT_USED OMCU,
        ORDER_MONEY_CREDITS OMC
    WHERE 
        OMC.ORDER_CREDIT_ID = OMCU.ORDER_CREDIT_ID AND
        OMCU.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>

<cfif isdefined("session.ww.userid")>
	<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
		SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfquery name="GET_CAMP_ID" datasource="#DSN3#">
		SELECT 
			CAMP_ID,
			CAMP_HEAD
		FROM 
			CAMPAIGNS 
		WHERE 
			CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	</cfquery>
	<cfif get_camp_id.recordcount>
		<cfquery name="GET_LEVEL" datasource="#DSN3#">
			SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
		</cfquery>
		<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
	<cfelse>
		<cfset ref_count = 0>
	</cfif>
	<cfquery name="GET_REF_MEMBER" datasource="#DSN#">
		SELECT 
			CONSUMER_ID 
		FROM 
			CONSUMER
		WHERE 
			REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR 
			(
				CONSUMER_REFERENCE_CODE IS NOT NULL AND
				'.'+CONSUMER_REFERENCE_CODE+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#session.ww.userid#.%"> AND
				(LEN(REPLACE(CONSUMER_REFERENCE_CODE,'.','..'))-LEN(CONSUMER_REFERENCE_CODE)+1) < = #ref_count#
			)
	</cfquery>
	<cfset list_ref_member = ''>
	<cfoutput query="get_ref_member">
		<cfif len(consumer_id) and not listfind(list_ref_member,consumer_id)>
			<cfset list_ref_member = Listappend(list_ref_member,consumer_id)>
		</cfif>
	</cfoutput>
</cfif>
<cfinclude template="../query/get_order_det.cfm">
<!--- SipariS iptal edilebilsin secenegi secilmisse bagli fatura kontrol ediliyor --->
<cfset control_cancel = 0>
<cfif isdefined("attributes.is_order_cancel") and attributes.is_order_cancel eq 1>
	<cfquery name="GET_INVOICE_DET" datasource="#DSN3#">
		SELECT INVOICE_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
	</cfquery>
	<cfif get_invoice_det.recordcount>
		<cfquery name="GET_PRINT_COUNT" datasource="#DSN2#">
			SELECT ISNULL(PRINT_COUNT,0) PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_det.invoice_id#"> 
		</cfquery>
		<cfif get_print_count.print_count gt 0>
			<cfset control_cancel = 1>
		<cfelse>
			<cfset control_cancel = 0>
		</cfif>
	<cfelse>
		<cfquery name="GET_INVOICE_DET" datasource="#DSN3#">
			SELECT INVOICE_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		</cfquery>
		<cfif get_invoice_det.recordcount>
			<cfset control_cancel = 1>
		</cfif>
	</cfif>
<cfelse>
	<cfset control_cancel = 0>
</cfif>
<cfif len(get_order_det.deliver_dept_id)>
	<cfquery name="GET_STORE" datasource="#DSN#">
		SELECT 
			DEPARTMENT_ID,
			DEPARTMENT_HEAD 
		FROM 
			DEPARTMENT 
		WHERE 
			DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.deliver_dept_id#">
	</cfquery>
</cfif>
<cfif len(get_order_det.ship_method)>
	<cfquery name="GET_METHOD" datasource="#DSN#">
		SELECT 
			SHIP_METHOD_ID,
			SHIP_METHOD 
		FROM 
			SHIP_METHOD 
		WHERE 
			SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.ship_method#">
	</cfquery>
</cfif>
<cfquery name="GET_ORDER_MONEY" datasource="#DSN3#">
	SELECT 
		IS_SELECTED,
		MONEY_TYPE,
        RATE2
	FROM 
		ORDER_MONEY
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND 
		<cfif isdefined("session.pp.money")>
			MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#">
		<cfelseif isdefined("session.ww.money")>
			MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.money#">
		<cfelse>
			MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
		</cfif>
</cfquery>

<cfif isdefined('attributes.is_order_risc_currency') and attributes.is_order_risc_currency eq 1>
	<cfquery name="GET_RISC_MONEY" datasource="#DSN#">
		SELECT 
			MONEY 
		FROM 
			COMPANY_CREDIT 
		WHERE 
			<cfif isdefined('session.pp.userid')> 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			<cfelseif isdefined('session.ww.userid')>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
	</cfquery>
</cfif>
<cfquery name="GET_SELECTED_MONEY" datasource="#DSN3#">
	SELECT 
		MONEY_TYPE, 
		RATE2
	FROM 
		ORDER_MONEY 
	WHERE 
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND 
		<cfif isdefined('get_risc_money') and get_risc_money.recordcount and len(get_risc_money.money)>
			MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_risc_money.money#">
		<cfelse>
			IS_SELECTED = 1
		</cfif>
</cfquery>
<cfquery name="GET_PROCESS" datasource="#DSN#">
	SELECT STAGE,DETAIL FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.order_stage#">
</cfquery>	
<div style="overflow:scroll;">							
<table style="width:100%">
	<cfoutput>
		<tr style="height:25px;">
			<td class="headbold"><cf_get_lang_main no='799.Siparis No'>: #get_order_det.order_number#</td>
			<!-- sil --> <td align="right" style="text-align:right;"><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'></td> <!-- sil -->
		</tr>
		<tr class="color-row" style="height:50px;">
			<td colspan="3" style="vertical-align:top">
				<table>
					<cfif (isdefined("attributes.is_order_head") and attributes.is_order_head eq 1)>
						<tr>
							<td class="txtbold" style="width:100px;"><cf_get_lang_main no='199.Sipariş'></td>
							<td colspan="3">:&nbsp;#get_order_det.order_head#</td>
						</tr>
					</cfif>
					<tr>
						<td class="txtbold" style="width:100px;"><cf_get_lang no='125.Üye Adı'></td>
						<td>: 
							<cfif isdefined("comp")>
								#get_order_det_comp.fullname#
							<cfelse>
								#get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#
							</cfif>
							<cfif isdefined("get_cons_name.consumer_name")> / 
								#get_cons_name.member_code#
							<cfelseif isdefined("get_order_det_cons.name")>
								#get_order_det_cons.name#
							</cfif>
						</td>
						<td class="txtbold"><cfif (isdefined("attributes.is_ship_method") and attributes.is_ship_method eq 1)><cf_get_lang_main no='1703.Sevk Yöntemi'></cfif></td>
						<td>
                      		: 
                        	<cfif (isdefined("attributes.is_ship_method") and attributes.is_ship_method eq 1)>
                            	<cfif len(get_order_det.ship_method)>
									<cfif session_base.language neq 'tr'>
                                        <cfquery name="GET_LANG_SHIP_METHOD" dbtype="query">
                                            SELECT 
                                            	* 
                                            FROM 
                                            	GET_ALL_FOR_LANGS 
                                            WHERE 
                                            	TABLE_NAME = 'SHIP_METHOD' AND 
                                                COLUMN_NAME = 'SHIP_METHOD' AND 
                                                UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.ship_method#">
                                        </cfquery>
                                        <cfif get_lang_ship_method.recordcount>
                                        	#get_lang_ship_method.item#
                                        <cfelse>
                                        	#get_method.ship_method#
                                        </cfif>
                                    <cfelse>									
                                    	#get_method.ship_method#
                                    </cfif>
                            	</cfif>
                            </cfif>	
                        </td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang_main no ='1181.Tarihi'></td>
						<td>: #dateformat(get_order_det.order_date,'dd/mm/yyyy')#</td>
						<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
						<td>: 
							<cfif isdefined('attributes.is_order_state') and attributes.is_order_state eq 1>
                            	<cfif session_base.language neq 'tr'>     
                                    <cfquery name="GET_ENG_STAGES" dbtype="query">
                                        SELECT * FROM GET_ALL_FOR_LANGS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'STAGE' AND UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.order_stage#">
                                    </cfquery> 
                                    <cfif get_eng_stages.recordcount>
                                    	#get_eng_stages.item#
                                    <cfelse>
										<cfif get_process.recordcount and len(get_process.stage)>
                                             #get_process.stage#
                                        </cfif>                                   
                                    </cfif>                               
                                <cfelse>
									<cfif get_process.recordcount and len(get_process.stage)>
                                         #get_process.stage#
                                    </cfif>
                               	</cfif>
                       	 	<cfelse>
								<cfif get_process.recordcount and len(get_process.detail)>
                                     #get_process.detail#
                                </cfif>
                        	</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
						<td>: 
							<cfif len(get_order_det.paymethod)>
								<cfset attributes.paymethod_id = get_order_det.paymethod>
								<cfinclude template="../../sales/query/get_paymethod.cfm">
								<cfif session_base.language neq 'tr'>
                                    <cfquery name="GET_FOR_PAYMETHOD" dbtype="query">
                                        SELECT 
                                        	* 
                                        FROM 
                                        	GET_ALL_FOR_LANGS 
                                        WHERE 
                                        	TABLE_NAME = 'SETUP_PAYMETHOD' AND 
                                            COLUMN_NAME = 'PAYMETHOD' AND 
                                            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
                                    </cfquery>
                                    <cfif get_for_paymethod.recordcount>
										#get_for_paymethod.item#
									<cfelse>
										#get_paymethod.paymethod#
									</cfif>
                                <cfelse>
									#get_paymethod.paymethod#
								</cfif>
							<cfelseif len(get_order_det.card_paymethod_id)>
								<cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
									SELECT 
										CARD_NO
										<cfif get_order_det.commethod_id eq 6><!--- WW den gelen siparişlerin guncellemesi --->
											,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
										<cfelse><!--- EP VE PP den gelen siparişlerin guncellemesi --->
											,COMMISSION_MULTIPLIER 
										</cfif>
									FROM 
										CREDITCARD_PAYMENT_TYPE
									WHERE 
										PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.card_paymethod_id#">
								</cfquery>
								#get_card_paymethod.card_no#
							</cfif>
						</td>
						<td class="txtbold"><cf_get_lang_main no='469.Vade Tarihi'></td>
						<td>: #dateformat(get_order_det.due_date,'dd/mm/yyyy')#</td>
					</tr>
					<cfif (isdefined("attributes.is_deliverdate") and attributes.is_deliverdate eq 1) or not isdefined("attributes.is_deliverdate")>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='233.Teslim Tarihi'></td>
							<td>: #dateformat(get_order_det.deliverdate,'dd/mm/yyyy')#</td>
						</tr>
					</cfif>
					<cfif isdefined("attributes.is_sales_zone") and attributes.is_sales_zone eq 1>
						<tr>
							<td class="txtbold"><cf_get_lang no='1575.Bölge Kodu'></td>
							<td>: <cfif isdefined("ims_code")>#ims_code#</cfif></td>
						</tr>
					</cfif>
					<tr>
						<td class="txtbold" style="vertical-align:top"><cf_get_lang_main no='1037.Teslim Yeri'></td>
						<td colspan="2" style="width:300px; vertical-align:top">: #get_order_det.ship_address#</td>
						<cfif isdefined("attributes.is_order_cancel") and attributes.is_order_cancel eq 1 and control_cancel eq 0 and get_order_det.order_status eq 1 and isdefined("session.ep")>
							<td>
								<input type="button" name="cancel_order" id="cancel_order" value="Siparişi İptal Et" onclick="if (confirm('Sipariş İptal Edilecek Emin misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_upd_order_status&order_id=#attributes.order_id#</cfoutput>'">
							</td>
						</cfif>
						<cfif isdefined("attributes.is_order_return") and attributes.is_order_return eq 1 and isdefined("session.ep")>
							<cfquery name="GET_INVOICE_DET_2" datasource="#DSN3#">
								SELECT INVOICE_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
							</cfquery>
							<cfif get_invoice_det_2.recordcount>
								<cfquery name="GET_INVOICE_NUMBER" datasource="#DSN2#">
									SELECT INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_det_2.invoice_id#">
								</cfquery>
								<td><input type="button" name="add_return" id="add_return" value="İade Talebi Ekle" onclick="windowopen('#request.self#?fuseaction=objects2.add_return&invoice_no=#get_invoice_number.invoice_number#&invoice_year=#year(now())#&consumer_id=#get_order_det.consumer_id#','wide');"></td>
							</cfif>
						</cfif>
					</tr>
					<cfif isdefined('attributes.is_order_project') and attributes.is_order_project eq 1 and len(get_order_det.project_id)>
						<cfquery name="GETPROJECT" datasource="#DSN#">
							SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.project_id#">
						</cfquery>
						<tr>
							<td class="txtbold" style="width:100px;"><cf_get_lang_main no='4.Proje'></td>
							<td>: #getProject.project_id# - #getProject.project_head#</td>
							<cfif isdefined('attributes.is_order_detail') and attributes.is_order_detail eq 1 and len(get_order_det.order_detail)>
								<td style="width:100px;" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
								<td>: #get_order_det.order_detail#</td>
							</cfif>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="3" style="vertical-align:top">
			<table border="0" cellspacing="1" cellpadding="2" style="width:100%">
				<tr class="color-header" style="height:20px;">
					<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
                    <cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td class="form-title" style="width:70px;"><cf_get_lang_main no='217.Açıklama'></td></cfif>
					<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1>
						<td class="form-title"><cf_get_lang_main no='106.Stok Kodu'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_special_code') and attributes.is_order_special_code eq 1>
						<td class="form-title"><cf_get_lang_main no='377.Özel Kod'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1>
						<td class="form-title" style="width:80px;"><cf_get_lang_main no='70.Aşama'></td>
					</cfif>
					<td class="form-title" style="width:45px;"><cf_get_lang_main no='224.Birim'></td>
					<td align="right" class="form-title" style="text-align:right;width:45px;"><cf_get_lang_main no='223.Miktar'></td>
					<cfif isdefined('attributes.is_order_prices_kdv') and attributes.is_order_prices_kdv eq 1>
						<td align="right" class="form-title" style="width:35px;text-align:right;"><cf_get_lang_main no='227.KDV'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_unit_prices') and attributes.is_order_unit_prices eq 1>
						<td align="right" class="form-title" style="width:110px;text-align:right;"><cf_get_lang_main no ='2227.KDVsiz'> <cf_get_lang_main no ='226.Birim Fiyat'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_prices_total') and attributes.is_order_prices_total eq 1>
						<td align="right" class="form-title" style="width:90px;text-align:right;"><cf_get_lang_main no ='2227.KDVsiz'> <cf_get_lang_main no ='80.Toplam'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_unit_prices_kdv') and attributes.is_order_unit_prices_kdv eq 1>
						<td align="right" class="form-title" style="width:70px;text-align:right;"><cf_get_lang_main no ='1304.KDVli'> <cf_get_lang_main no ='672.Fiyat'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_prices_total_kdv') and attributes.is_order_prices_total_kdv eq 1>
						<td align="right" class="form-title" style="width:80px;text-align:right;"><cf_get_lang_main no ='1304.KDVli'> <cf_get_lang_main no ='80.Toplam'></td>
					</cfif>
					<cfif isdefined('attributes.is_order_discount') and attributes.is_order_discount eq 1>
						<td align="center" class="form-title" style="width:30px;"><cf_get_lang no ='230.İsk'>-1</td>
						<td align="center" class="form-title" style="width:30px;"><cf_get_lang no ='230.İsk'>-2</td>
						<td align="center" class="form-title" style="width:30px;"><cf_get_lang no ='230.İsk'>-3</td>
						<td align="center" class="form-title" style="width:30px;"><cf_get_lang no ='230.İsk'>-4</td>
						<td align="center" class="form-title" style="width:30px;"><cf_get_lang no ='230.İsk'>-5</td>
					</cfif>
					<cfif isdefined('attributes.is_order_other_prices') and attributes.is_order_other_prices eq 1>
						<td align="right" class="form-title" style="text-align:right; width:70px;"><cf_get_lang no ='1233.Döviz Fiyat'></td>
						<cfif isdefined('attributes.is_order_other_money') and attributes.is_order_other_money eq 1>
							<td align="right" class="form-title" style="text-align:right; width:70px;"><cf_get_lang_main no='265.Döviz'></td>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.is_order_discount_total') and attributes.is_order_discount_total eq 1>
						<td align="right" class="form-title" style="text-align:right; width:90px;"><cf_get_lang_main no='237.Toplam İndirim'></td>
					</cfif> 
					<cfif isdefined('attributes.is_order_prices_nettotal') and attributes.is_order_prices_nettotal eq 1>
						<td align="right" class="form-title" style="text-align:right; width:80px;" ><cf_get_lang_main no='230.N Toplam'></td>
					</cfif>
				</tr>
				<cfinclude template="../query/show_order_basket.cfm">	
				<cfoutput query="get_order_row">
					<cfif len(product_id) and not listfind(product_id_list,product_id)>
						<cfset product_id_list = listappend(product_id_list,product_id)>
					</cfif>
				</cfoutput>
				<cfif len(product_id_list)>
					<cfquery name="GET_KARMA_PRODUCTS" datasource="#DSN1#">
						SELECT 
							PRODUCT_NAME,
							UNIT,
							PRODUCT_AMOUNT,
							KARMA_PRODUCT_ID
						FROM 
							KARMA_PRODUCTS
						WHERE
							KARMA_PRODUCT_ID IN (#product_id_list#)
					</cfquery>
				</cfif>
				<cfset toplam_indirim = 0>
				<cfset netTotal_ = 0>
				<cfoutput query="get_order_row">
					<cfset row_grosstotal = price * quantity>
					<cfset toplam_indirim = toplam_indirim+(row_grosstotal-nettotal)>
					<cfset price_kdv_ = (price+(price*tax/100))>
					<cfset price_kdv_total_ = (price+(price*tax/100))*quantity>
					<cfset netTotal_ = netTotal_+row_grosstotal>
					<tr class="color-row" style="background:F0F0F0; font:bold">
						<td nowrap>
							<cfif session_base.language neq 'tr'>
          						<cfquery name="GET_LANG_PRODUCT_NAME" dbtype="query">
                                	SELECT 
                                    	* 
                                    FROM 
                                    	GET_ALL_FOR_LANGS 
                                    WHERE 
                                    	TABLE_NAME = 'PRODUCT' AND 
                                        COLUMN_NAME = 'PRODUCT_NAME' AND 
                                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                </cfquery>  
                                <cfif get_lang_product_name.recordcount>
                                	#get_lang_product_name.item#
                                <cfelse>
                                	#product_name#
                                </cfif>                
                            <cfelse> 	
                            	#product_name# 
							</cfif>
							
							<cfif len(spect_var_name) and spect_var_name neq product_name>- #spect_var_name#</cfif>
							<cfif get_module_user(5)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#order_id#','medium');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no ='1352.Ürün Detayları'>" border="0" align="absmiddle"></a>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_std_sale&price_type=purc&pid=#product_id#','list');"><img src="/images/plus_thin_p.gif" title="<cf_get_lang_main no ='309.Ürün Fiyat Tarihçe'>" border="0" align="absmiddle"></a>
							</cfif>
							
						</td>
                        <cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td>#product_name2#</td></cfif>
						<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1>
							<td>
								<cfif isdefined('attributes.related_product_lists') and len(attributes.related_product_lists)>
									<cfif  not listfindnocase(attributes.related_product_lists,product_id)>
										#stock_code#
									</cfif>
								<cfelse>
									#stock_code#
								</cfif>
							</td>
						</cfif>
						<cfif isdefined('attributes.is_order_special_code') and attributes.is_order_special_code eq 1>
							<td>
								<cfif isdefined('attributes.related_product_lists') and len(attributes.related_product_lists)>
									<cfif  not listfindnocase(attributes.related_product_lists,product_id)>
										#stock_code_2#
									</cfif>
								<cfelse>
									#stock_code_2#
								</cfif>
							</td>
						</cfif>
						<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1>
							<td>&nbsp;
,								<cfif get_order_row.order_row_currency eq -1><cf_get_lang_main no='1305.Açık'>
								<cfelseif get_order_row.order_row_currency eq -2><cf_get_lang_main no='1948.Tedarik'>
								<cfelseif get_order_row.order_row_currency eq -3><cf_get_lang_main no='1949.Kapatıldı'>
								<cfelseif get_order_row.order_row_currency eq -4><cf_get_lang_main no='1950.Kısmi Üretim'>
								<cfelseif get_order_row.order_row_currency eq -5><cf_get_lang_main no='44.Üretim'>
								<cfelseif get_order_row.order_row_currency eq -6><cf_get_lang_main no='1349.Sevk'>
								<cfelseif get_order_row.order_row_currency eq -7><cf_get_lang_main no='1951.Eksik Teslimat'>
								<cfelseif get_order_row.order_row_currency eq -8><cf_get_lang_main no='1952.Fazla Teslimat'>
								<cfelseif get_order_row.order_row_currency eq -9><cf_get_lang_main no='1094.İptal'>
								<cfelseif get_order_row.order_row_currency eq -10><cf_get_lang_main no='1211.Kapatıldı(Manuel)'>
								</cfif>
							</td>
						</cfif>
						<td>&nbsp;#unit#</td>
						<td align="right" style="text-align:right;">#amountformat(quantity)#</td>
						<cfif isdefined('attributes.is_order_prices_kdv') and attributes.is_order_prices_kdv eq 1>
							<td align="right" style="text-align:right;">#TLFormat(tax,0)#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_unit_prices') and attributes.is_order_unit_prices eq 1>
							<td align="right" style="text-align:right;">#TLFormat(price)#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_prices_total') and attributes.is_order_prices_total eq 1>
							<td align="right" style="text-align:right;">#TLFormat(row_grosstotal)#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_unit_prices_kdv') and attributes.is_order_unit_prices_kdv eq 1>
							<td align="right" style="text-align:right;">#TLFormat(price_kdv_)#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_prices_total_kdv') and attributes.is_order_prices_total_kdv eq 1>
							<td align="right" style="text-align:right;">#TLFormat(price_kdv_total_)#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_discount') and attributes.is_order_discount eq 1>
							<td align="center">#discount_1#</td>
							<td align="center">#discount_2#</td>
							<td align="center">#discount_3#</td>
							<td align="center">#discount_4#</td>
							<td align="center">#discount_5#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_other_prices') and attributes.is_order_other_prices eq 1>
							<td align="right" style="text-align:right;">#TLFormat(price_other)#</td>
							<cfif isdefined('attributes.is_order_other_money') and attributes.is_order_other_money eq 1>
								<td align="right" style="text-align:right;">#other_money#</td>
							</cfif>
						</cfif>
						<cfif isdefined('attributes.is_order_discount_total') and attributes.is_order_discount_total eq 1>
							<td align="right" style="text-align:right;">#TLFormat(row_grosstotal-nettotal)#</td>
						</cfif>
						<cfif isdefined('attributes.is_order_prices_nettotal') and attributes.is_order_prices_nettotal eq 1>
							<td align="right" style="text-align:right;">#TLFormat(nettotal)#</td>
						</cfif>
					</tr>
						<cfif isdefined('attributes.is_show_product_detail') and attributes.is_show_product_detail eq 1 and is_karma eq 1>
							<cfquery name="GET_KARMA_PRODUCT_ROW" dbtype="query">
								SELECT PRODUCT_NAME,UNIT,PRODUCT_AMOUNT FROM GET_KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.product_id#">
							</cfquery>
							<cfloop query="get_karma_product_row">
								<tr  class="color-row" style="font-size:9px">
									<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_karma_product_row.product_name#</td>
									<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td ></td></cfif>
									<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1><td ></td></cfif>
									<cfif isdefined('attributes.is_order_special_code') and attributes.is_order_special_code eq 1><td></td></cfif>
									<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1><td></td></cfif>
									<!--- <td>&nbsp#unit#</td> Karma Koli ürün birimi 
									<td align="right">#amountformat(product_amount)#</td> Karma koli ürün adedi--->
									<td colspan="10"></td>
								</tr>
							</cfloop>
						</cfif>
					<tr>
						<cfif isdefined('attributes.is_spect_var_id') and attributes.is_spect_var_id eq 1>
							<td colspan="10">
								<cfif len(spect_var_id)>
									<a href="javascript://" onclick="gizle_goster(spect#spect_var_id#);"><b><font color="##FF0000"><cf_get_lang no ='139.Ürün Bileşenleri'></font></b></a>
									<cfquery name="GET_SPECT" datasource="#DSN3#">
										SELECT
											SPECTS.SPECT_VAR_NAME,
											SPECTS_ROW.AMOUNT_VALUE,
											SPECTS_ROW.PRODUCT_NAME,
											SPECTS_ROW.TOTAL_VALUE,
											SPECTS_ROW.MONEY_CURRENCY,
											SPECTS_ROW.IS_CONFIGURE,
											SPECTS_ROW.DIFF_PRICE,
											SPECTS.PRODUCT_AMOUNT,
											SPECTS.PRODUCT_AMOUNT_CURRENCY,
											SPECTS_ROW.IS_PROPERTY,
											STOCKS.PRODUCT_DETAIL
										FROM
											SPECTS,
											SPECTS_ROW,
											STOCKS
										WHERE
											SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
											SPECTS_ROW.SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_var_id#"> AND
											SPECTS_ROW.STOCK_ID = STOCKS.STOCK_ID 
									</cfquery>
									<table style="display:none;" id="spect#spect_var_id#">
										<tr>
											<td>#get_spect.spect_var_name#</td>
											<td align="right" style="width:40px;text-align:right;"></td>
										<tr> 
										<cfloop query='get_spect'>
											<tr>
												<td>#product_detail#</td>
												<td align="right" style="width:40px;text-align:right;">#amount_value#</td>
											</tr>
										</cfloop>
									</table>
								</cfif>
							</td>
						</cfif>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
	<br/>
	<tr>
		<td colspan="3">
			<table border="0" cellspacing="0" cellpadding="0" style="width:100%">
				<tr>
					<cfif isdefined('attributes.is_order_kur') and attributes.is_order_kur eq 1>
						<td style="vertical-align:top">
							<table>
								<tr>
									<td colspan="2" class="txtbold"><cf_get_lang no ='1454.Döviz Kurları'></td>
								</tr>
								<cfoutput query="get_order_money">
									<tr>
										<td <cfif is_selected eq 1>class="txtbold"</cfif> width="60">#money_type#</td>
										<td align="right" style="text-align:right;" <cfif is_selected eq 1>class="txtbold"</cfif>>#TLFormat(rate2,4)#</td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</cfif>
					<cfif get_bank_info.recordcount>
                    	<cfoutput>
                            <td style="vertical-align:middle">
                                <table>
                                    <tr>
                                        <td colspan="2"  class="txtbold"> 
                                            Havale / EFT Bilgileri
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="txtbold">Banka Adi ve Subesi :</td>
                                        <td>#get_bank_info.bank_name# - #get_bank_info.bank_branch_name#</td>
                                    </tr>
                                    <tr>
                                        <td class="txtbold">Sube No :</td>
                                        <td>#get_bank_info.branch_code#</td>
                                    </tr>
                                    <tr>
                                        <td class="txtbold">Hesap Numarasi :</td>
                                        <td>#get_bank_info.account_no#</td>
                                    </tr>
                                    <tr>
                                        <td class="txtbold">IBAN No :</td>
                                        <td>#get_bank_info.account_owner_customer_no#</td>
                                    </tr>  
                                    <tr>
                                    	<td class="txtbold">EFT Islemleri Için Alici Ünvani :</td> 										
										<td>
										<cfif isdefined('session.pp.userid')>
											#session.pp.our_name#
                                    	<cfelse>
											#session.ww.our_name#
                                        </cfif>
                                   		</td>
                                    </tr>
                                    <tr>
                                    	<td colspan="2"><b>Lütfen EFT/Havale Açiklamasini Siparis Numarasi - Ad Soyad Seklinde Belirtiniz</b></td>
                                    </tr>
                            	</table>
                            </td>
                        </cfoutput>
                    </cfif>
					<cfif isdefined('attributes.is_order_main_total') and attributes.is_order_main_total eq 1>
						<td align="right">
							<cfoutput>
								<table border="0">
								  	<tr>
										<td>&nbsp;</td>
										<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
											<td align="right" class="txtbold" style="text-align:right;">
												<cfoutput>#get_selected_money.money_type#</cfoutput>
											</td>
											<td align="right" class="txtbold" style="text-align:right;">
												<cfif isdefined("session.pp.money")>
													<cfoutput>#session.pp.money#</cfoutput>
												<cfelseif isdefined("session.ww.money")>
													<cfoutput>#session.ww.money#</cfoutput>
												<cfelse>
													<cfoutput>#session.ep.money#</cfoutput>
												</cfif>
											</td>
										</cfif>
								  	</tr>
								  	<tr>
										<td class="txtbold" style="width:100px;"><cf_get_lang_main no='80.Toplam'></td>
										<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
											<cfset doviz_total = get_order_det.grosstotal / get_selected_money.rate2>
											<td align="right" style="width:90px;text-align:right;">&nbsp;#TLFormat(doviz_total)#</td>
										</cfif>
										<td align="right" style="text-align:right;">&nbsp;#TLFormat(netTotal_)#</td>
								  	</tr>
									<cfif (isdefined("attributes.is_basket_discount") and attributes.is_basket_discount eq 1) or not isdefined("attributes.is_basket_discount")>			  
                                        <tr>
                                            <td class="txtbold" style="width:100px;"><cf_get_lang_main no ='1353.Satıraltı İndirim'></td>
                                            <cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
                                                <cfset doviz_indirim = get_order_det.sa_discount / get_selected_money.rate2>
                                                <td align="right" style="text-align:right;">&nbsp;#TLFormat(doviz_indirim)#</td>
                                            </cfif>
                                            <td align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.sa_discount)#</td>
                                        </tr>
                                    </cfif>
                                    <cfif (isdefined("attributes.is_total_discount") and attributes.is_total_discount eq 1) or not isdefined("attributes.is_total_discount")>			  
                                            <td class="txtbold" style="width:100px;"><cf_get_lang_main no='237.Toplam İndirim'></td>
                                            <cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
                                                <cfset doviz_indirim2= (toplam_indirim+get_order_det.sa_discount) / get_selected_money.rate2>
                                                <td align="right" style="text-align:right;">&nbsp;#TLFormat(doviz_indirim2)#</td>
                                            </cfif>
                                            <td align="right" style="text-align:right;">&nbsp;#TLFormat(toplam_indirim+get_order_det.sa_discount)#</td>
                                        </tr>	
                                    </cfif>	
                                    <tr>
                                        <td class="txtbold"><cf_get_lang_main no='231.Toplam KDV'></td>
                                        <cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
                                            <cfset doviz_kdv= get_order_det.taxtotal / get_selected_money.rate2>
                                            <td align="right" style="text-align:right;">&nbsp;#TLFormat(doviz_kdv)#</td>
                                        </cfif>
                                        <td align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.taxtotal)#</td>
                                    </tr>
                                    <tr>
                                        <td class="txtbold"><cf_get_lang_main no ='268.Genel Toplam'></td>
                                        <cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
                                            <td align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.other_money_value)#</td>
                                        </cfif>
                                        <td align="right" style="width:90px;text-align:right;">&nbsp;
                                        <!---#TLFormat(get_order_det.nettotal)#--->
                                        #TLFormat((netTotal_-(toplam_indirim+get_order_det.sa_discount))+get_order_det.taxtotal)#</td>
                                    </tr>
									<cfif get_money_credits.recordcount>
                                        <cfquery name="GET_GIFT_CREDIT" dbtype="query">
                                            SELECT SUM(USED_VALUE) AS TOTAL_USED_VALUE FROM GET_MONEY_CREDITS WHERE IS_TYPE = 1
                                        </cfquery>
                                        <cfif get_gift_credit.recordcount>
                                            <tr>
                                                <td class="txtbold"><cf_get_lang no='55.Hediye Kartı İndirimi'></td>
                                                <td style="text-align:right;"><cfif get_gift_credit.recordcount>#TLFormat(get_gift_credit.total_used_value,2)#<cfelse>0</cfif></td>
                                            </tr>                                     
                                        </cfif>
                                        <cfquery name="GET_MONEY_CREDIT" dbtype="query">
                                            SELECT SUM(USED_VALUE) AS  TOTAL_USED_VALUE FROM GET_MONEY_CREDITS WHERE IS_TYPE = 0
                                        </cfquery>
                                        <cfif get_money_credit.recordcount>
                                            <tr>
                                                <td class="txtbold">Kullanılan Parapuan</td>
                                                <td style="text-align:right;"><cfif get_money_credit.recordcount>#TLFormat(get_money_credit.total_used_value,2)#<cfelse>0</cfif></td>
                                            </tr> 
                                        </cfif>
										<tr>
											<cfset discount_total = get_order_det.nettotal>
                                            <cfif get_gift_credit.recordcount and len(get_gift_credit.total_used_value)>
                                                <cfset discount_total = discount_total - get_gift_credit.total_used_value>
                                            </cfif>     
                                            <cfif get_money_credit.recordcount and len(get_money_credit.total_used_value)>
                                                <cfset discount_total = discount_total - get_money_credit.total_used_value>
                                            </cfif>                       
                                            <td class="txtbold">İndirimli Genel Toplam</td>
                                            <td style="text-align:right;"><cfif len(discount_total)>#TLFormat(discount_total,2)#</cfif></td>
                                        </tr> 
                                    </cfif>
                                </table>
							</cfoutput>
						</td>
                    </cfif>
				</tr>
			</table>
		</td>
	</tr>
</table>
