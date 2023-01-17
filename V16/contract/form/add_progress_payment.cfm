<cfprocessingdirective suppresswhitespace="yes">
<!--- <cfif isdefined('attributes.id') and len(attributes.id)>
	<script language="javascript">
		<cfoutput>
			window.open('#request.self#?fuseaction=contract.popup_detail_progress&id=#attributes.id#','list'); 
		</cfoutput>
	</script>
</cfif> --->
<cf_xml_page_edit fuseact="contract.add_progress_payment">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.contract_id" default="">
<cfparam name="attributes.contract_no" default="">
<cfparam name="attributes.contract_type" default="1">
<cfif isdefined('attributes.form_submited')>
	<cfquery name="get_contracts" datasource="#dsn3#">
		SELECT 
			COMPANY_ID,
            CONSUMER_ID,
			CONTRACT_ID,
			CONTRACT_NO,
			CONTRACT_MONEY,
            ISNULL(CONTRACT_TAX,0) CONTRACT_TAX,
			CONTRACT_CALCULATION,
			ISNULL(GUARANTEE_RATE,0) GUARANTEE_RATE,
			ISNULL(ADVANCE_RATE,0) ADVANCE_RATE,
			ISNULL(TEVKIFAT_RATE,0) TEVKIFAT_RATE,
            ISNULL(STOPPAGE_RATE,0) STOPPAGE_RATE,
            ISNULL(DISCOUNT_RATE,0) DISCOUNT_RATE
		FROM 
			RELATED_CONTRACT
		WHERE 
			STATUS = 1 AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			CONTRACT_TYPE = #attributes.contract_type# 
			<cfif len(attributes.contract_id) and len(attributes.contract_no)>
				AND CONTRACT_ID = #attributes.contract_id# 
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)>
				AND PROJECT_ID = #attributes.project_id# 
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.member_name)>
				AND COMPANY_ID = #attributes.company_id#
			</cfif>
            <cfif len(attributes.consumer_id) and len(attributes.member_name)>
				AND CONSUMER_ID = #attributes.consumer_id#
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_contracts.recordcount = 0>
</cfif>
<cfset contract_id_list = ''>
<cfif get_contracts.recordcount>
	<!--- bir önceki kayıtlı hakedisler --->
	<cfset contract_id_list = valuelist(get_contracts.CONTRACT_ID,',')>
	<cfquery name="getProgress" datasource="#dsn3#">
		SELECT CONTRACT_ID,PROGRESS_VALUE FROM PROGRESS_PAYMENT WHERE CONTRACT_ID IN (#contract_id_list#)
	</cfquery>
	<!---sözlesme ile ilişkili isler 
		CONTRACT_CALCULATION = 1 %
		CONTRACT_CALCULATION = 2 Süre
		CONTRACT_CALCULATION = 3 Miktar
	--->
	<cfquery name="getContractWorks" datasource="#dsn3#">
		SELECT 
			RC.CONTRACT_ID,
			RC.CONTRACT_CALCULATION,
			RC.CONTRACT_AMOUNT,
			PW.WORK_ID,
			PW.ESTIMATED_TIME,
			PW.TO_COMPLETE,
			PW.SALE_CONTRACT_AMOUNT,
			PW.PURCHASE_CONTRACT_AMOUNT,
			PW.COMPLETED_AMOUNT,
			ISNULL((
			CASE 
			<cfif attributes.contract_type eq 1>
				WHEN (RC.CONTRACT_CALCULATION = 1) THEN ((ISNULL(RC.CONTRACT_AMOUNT,0)/#dsn_alias#.IS_ZERO(ISNULL((SELECT SUM(CAST(ESTIMATED_TIME AS FLOAT))/60 FROM #dsn_alias#.PRO_WORKS WHERE PURCHASE_CONTRACT_ID = RC.CONTRACT_ID),0),1))*(ISNULL(CAST(ESTIMATED_TIME AS FLOAT),0)/60)*(ISNULL(CAST(TO_COMPLETE AS FLOAT),0)/100))
			<cfelse>
				WHEN (RC.CONTRACT_CALCULATION = 1) THEN ((ISNULL(RC.CONTRACT_AMOUNT,0)/#dsn_alias#.IS_ZERO(ISNULL((SELECT SUM(CAST(ESTIMATED_TIME AS FLOAT))/60 FROM #dsn_alias#.PRO_WORKS WHERE SALE_CONTRACT_ID = RC.CONTRACT_ID),0),1))*(ISNULL(CAST(ESTIMATED_TIME AS FLOAT),0)/60)*(ISNULL(CAST(TO_COMPLETE AS FLOAT),0)/100))
			</cfif>
				WHEN (RC.CONTRACT_CALCULATION = 2) THEN ((SELECT SUM(((ISNULL(CAST(TOTAL_TIME_HOUR AS FLOAT),0)*60) + ISNULL(CAST(TOTAL_TIME_MINUTE AS FLOAT),0))/60) AS HARCANAN_ZAMAN FROM #dsn_alias#.PRO_WORKS_HISTORY PWH WHERE PWH.WORK_ID = PW.WORK_ID)* CASE WHEN (RC.CONTRACT_TYPE =1) THEN ISNULL(PW.PURCHASE_CONTRACT_AMOUNT,0) WHEN (RC.CONTRACT_TYPE =2) THEN ISNULL(PW.SALE_CONTRACT_AMOUNT,0) ELSE 0 END )
				WHEN (RC.CONTRACT_CALCULATION = 3) THEN ((ISNULL(PW.COMPLETED_AMOUNT,0)*CASE WHEN (RC.CONTRACT_TYPE =1) THEN ISNULL(PW.PURCHASE_CONTRACT_AMOUNT,0) WHEN (RC.CONTRACT_TYPE =2) THEN ISNULL(PW.SALE_CONTRACT_AMOUNT,0) ELSE 0 END ))
			ELSE 0
			END),0) AS PROGRESS
		FROM	
			RELATED_CONTRACT RC,
			#dsn_alias#.PRO_WORKS PW
		WHERE
			<cfif attributes.contract_type eq 1>
				PW.PURCHASE_CONTRACT_ID = RC.CONTRACT_ID AND	
			<cfelse>
				PW.SALE_CONTRACT_ID = RC.CONTRACT_ID AND	
			</cfif>
			RC.STATUS = 1 AND
			RC.CONTRACT_ID IN (#contract_id_list#)
		ORDER BY
			CONTRACT_ID
	</cfquery>
    
	<!--- dekontlu dönemsel kesintiler sözlesme taseron tipli ise borc dekontları isveren tipli ise alacak dekontları gelir --->
	<cfquery name="getContractReceipt" datasource="#dsn2#">
		SELECT 
			ACTION_ID,
			CASE WHEN (ACTION_CURRENCY_ID = '#session.ep.money#') 
			THEN 
				ACTION_VALUE 
			ELSE 
				(ACTION_VALUE*(SELECT (RATE2/RATE1) FROM CARI_ACTION_MONEY CM WHERE CM.ACTION_ID = CARI_ACTIONS.ACTION_ID AND CM.MONEY_TYPE = ACTION_CURRENCY_ID))
			END AS ACTION_VALUE,
			'#session.ep.money#' ACTION_CURRENCY_ID,
			CONTRACT_ID,
			MULTI_ACTION_ID
		FROM
			CARI_ACTIONS
		WHERE
			ACTION_VALUE > 0
			AND CONTRACT_ID IN (#contract_id_list#)
			--AND (TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id# )
			AND PROGRESS_ID IS NULL
			<cfif attributes.contract_type eq 1> AND ACTION_TYPE_ID = 41<cfelse> AND ACTION_TYPE_ID = 42</cfif>
	</cfquery>
	<!--- Faturalı Dönemsel Kesintiler sözlesme taseron tipli ise satıs faturaları isveren tipli ise alıs faturaları gelir--->
	<cfquery name="getContractInvoice" datasource="#dsn2#">
		SELECT 
			INVOICE_ID,
			GROSSTOTAL ACTION_VALUE,
			'#session.ep.money#' ACTION_CURRENCY_ID,
			CONTRACT_ID
		FROM 
			INVOICE
		WHERE
			INVOICE_ID > 0
			<cfif attributes.contract_type eq 1>
				AND PURCHASE_SALES = 1 
				AND INVOICE_CAT NOT IN(67,69)
			<cfelse>
				AND PURCHASE_SALES = 0
			</cfif>
			AND IS_IPTAL = 0 
			AND CONTRACT_ID IN (#contract_id_list#)
			AND PROGRESS_ID IS NULL
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_contracts.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="progress_report" action="#request.self#?fuseaction=contract.add_progress_payment" method="post">
			<input type="hidden" name="form_submited" id="form_submited" value="1" />	
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
						<input type="hidden" name="consumer_id" id="consumer_id"  value="<cfoutput>#attributes.consumer_id#</cfoutput>">
						<input name="member_name" type="text" id="member_name" placeholder=<cfoutput>"#getLang('main',107)#"</cfoutput> style="width:110px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off">
						<cfset str_linke_ait="&field_consumer=progress_report.consumer_id&field_comp_id=progress_report.company_id&field_member_name=progress_report.member_name">
						<span class="input-group-addon icon-ellipsis btnPointer"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3&keyword='+encodeURIComponent(document.progress_report.member_name.value),'list');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#attributes.contract_id#</cfoutput>"> 
						<input type="text" name="contract_no" id="contract_no" placeholder=<cfoutput>"#getLang('main',1725)#"</cfoutput> value="<cfoutput>#attributes.contract_no#</cfoutput>" style="width:125px;">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=progress_report.contract_id&field_name=progress_report.contract_no'</cfoutput>,'large');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
						<input type="text" name="project_head"  id="project_head" placeholder=<cfoutput>"#getLang('main',4)#"</cfoutput> style="width:110px;"value="<cfoutput>#UrlDecode(attributes.project_head)#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=progress_report.project_id&project_head=progress_report.project_head');"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="contract_type" id="contract_type" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id='51040.Contract Type'></option>
						<option value="1" <cfif attributes.contract_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58176.Purchase'></option>
						<option value="2" <cfif attributes.contract_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57448.Sales'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="control()" >
				</div>					
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title='#getLang('contract',7)#'>
		<cfform name="add_hakedis_fatura" action="" method="post">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th width="120"><cf_get_lang dictionary_id='57519.Current Account'></th>
						<th width="40"><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='50768.Bir Önceki Kümülatif Hakediş'></th>
						<th><cf_get_lang dictionary_id='50775.Bugünkü Kümülatif Hakediş'></th>
						<!---<th>İskonto Oranı</th>
						<th>İskonto Tutarı</th>--->
						<th><cf_get_lang dictionary_id='50777.Brüt Hakediş'></th>
						<th><cf_get_lang dictionary_id='50824.Teminat Oranı'></th>
						<th><cf_get_lang dictionary_id='50851.Teminat Kesinti Tutarı'></th>
						<th><cf_get_lang dictionary_id='50858.Avans Oranı'></th>
						<th><cf_get_lang dictionary_id='50881.Avans Kesinti Tutarı'></th>
						<th><cf_get_lang dictionary_id='50734.Tevkifat Oranı'></th>
						<th><cf_get_lang dictionary_id='50897.Tevkifat Kesinti Tutarı'></th>
						<th><cf_get_lang dictionary_id="50036.Stopaj Oranı"></th>
						<th><cf_get_lang dictionary_id="54746.Stopaj Kesinti Tutarı"></th>
						<th><cf_get_lang dictionary_id='50902.Dekontlu Dönemsel Kesintiler'></th>
						<th><cf_get_lang dictionary_id='50904.Faturalı Dönemsel Kesintiler'></th>
						<th><cf_get_lang dictionary_id='50799.Dönemsel Kesinti Toplam'></th>
						<th><cf_get_lang dictionary_id='50804.Net Hakediş'></th>
						<th class="header_icn_none"></th>
					</tr>
				</thead>				
				<cfif get_contracts.recordcount>
					<tbody>
						<cfoutput query="get_contracts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">					
							<!--- bir önceki kayıtlı hakedisler --->
							<cfquery name="getContractProgress" dbtype="query">
								SELECT SUM(PROGRESS_VALUE) AS PROGRESS_PREVIOUS FROM getProgress WHERE CONTRACT_ID = #contract_id#
							</cfquery>
							<cfif len(getContractProgress.PROGRESS_PREVIOUS)>
								<cfset progress_previous = getContractProgress.PROGRESS_PREVIOUS>
							<cfelse>
								<cfset progress_previous = 0>
							</cfif>
							<!---bugunkü kumulatif hakedisler--->
							<cfquery name="getTodayProgress" dbtype="query">
								SELECT SUM(PROGRESS) TODAY_PROGRESS FROM getContractWorks WHERE CONTRACT_ID = #contract_id#
							</cfquery>
							<cfif len(getTodayProgress.today_progress)>
								<cfset today_progress_ = getTodayProgress.today_progress>
							<cfelse>
								<cfset today_progress_ = 0> 
							</cfif>
							<cfset discount_amount = (today_progress_*discount_rate)/100><!--- indirim Tutarı --->
							<cfset gross_progress = wrk_round(today_progress_,8) - wrk_round(progress_previous,8)- wrk_round(discount_amount,8)><!--- Brut hakedis --->
							<cfset guarantee_amount = (gross_progress*guarantee_rate)/100><!--- Teminat Kesinti Tutarı --->
							<cfset advance_amount = (gross_progress*advance_rate)/100><!--- Avans Kesinti Tutarı --->
							<cfset stoppage_amount = (gross_progress*stoppage_rate)/100><!--- stopaj Kesinti Tutarı --->
							<cfif tevkifat_rate eq 0>
								<cfset tevkifat_amount = 0><!--- Tevkifat Kesinti Tutarı --->
							<cfelse>
								<cfset tevkifat_amount = (gross_progress*contract_tax/100)*(1-tevkifat_rate)><!--- Tevkifat Kesinti Tutarı --->
							</cfif>
							<!--- dekontlu dönemsel kesintiler --->
							<cfset receipt_total = 0>
							<cfquery name="get_Contract_Receipt" dbtype="query">
								SELECT 
									ACTION_ID,
									MULTI_ACTION_ID,
									ACTION_VALUE,
									ACTION_CURRENCY_ID
								FROM 
									getContractReceipt 
								WHERE 
									CONTRACT_ID = #contract_id#
							</cfquery>
							<cfloop query="get_Contract_Receipt">
								<cfif get_Contract_Receipt.ACTION_CURRENCY_ID is get_contracts.contract_money>
									<cfset receipt_total = receipt_total+get_Contract_Receipt.ACTION_VALUE>
								<cfelse>
									<cfquery name="getCariActionMoney" datasource="#dsn2#">
										SELECT
											(RATE2/RATE1) RATE
										FROM
										<cfif len(MULTI_ACTION_ID)>
											CARI_ACTION_MULTI_MONEY
										<cfelse>
											CARI_ACTION_MONEY
										</cfif>
										WHERE
											ACTION_ID = <cfif len(MULTI_ACTION_ID)>#get_Contract_Receipt.MULTI_ACTION_ID#<cfelse>#get_Contract_Receipt.action_id#</cfif> AND
											MONEY_TYPE = '#get_contracts.contract_money#'
									</cfquery>
									<cfset receipt_total = receipt_total+(get_Contract_Receipt.action_value/getCariActionMoney.rate)>
								</cfif>
							</cfloop>
							<!--- faturalı donemsel kesintiler--->
							<cfquery name="get_Contract_Invoice" dbtype="query">
								SELECT 
									INVOICE_ID,
									ACTION_VALUE,
									ACTION_CURRENCY_ID
								FROM 
									getContractInvoice 
								WHERE 
									CONTRACT_ID = #contract_id#
							</cfquery>
							<cfset invoice_total = 0>
							<cfloop query="get_Contract_Invoice">
								<cfif get_Contract_Invoice.ACTION_CURRENCY_ID is get_contracts.contract_money>
									<cfset invoice_total = invoice_total+get_Contract_Invoice.ACTION_VALUE>
								<cfelse>
									<cfquery name="getInvoiceMoney" datasource="#dsn2#">
										SELECT
											(RATE2/RATE1) RATE
										FROM
											INVOICE_MONEY
										WHERE
											ACTION_ID = #get_Contract_Invoice.invoice_id#AND
											MONEY_TYPE = '#get_contracts.contract_money#'
									</cfquery>
									<cfset invoice_total = invoice_total+(get_Contract_Invoice.action_value/getInvoiceMoney.rate)>
								</cfif>
							</cfloop>
							<!--- donemsel kesinti toplamı--->
							<cfset periodic_interruption = guarantee_amount+advance_amount+tevkifat_amount+stoppage_amount+receipt_total+invoice_total>
							<!--- net hakedis --->
							<cfset net_progress = wrk_round(gross_progress,8) -  wrk_round(periodic_interruption,8)>
							<tr>
								<td>#currentrow#</td>
								<td>
									<cfif len(consumer_id)>
										<cfquery name="get_consumer" datasource="#DSN#">
											SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
										</cfquery>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#get_consumer.consumer_name# #get_consumer.consumer_surname#</a>
									<cfelseif len(company_id)>
										<cfquery name="getCompName" datasource="#dsn#">
											SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #company_id#
										</cfquery>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">#getCompName.NICKNAME#</a>
									</cfif>
								</td>
								<td>#contract_id#</td>
								<td>#TLFormat(progress_previous,2)# #contract_money#</td>
								<td>#TLFormat(today_progress_-discount_amount,2)# #contract_money#</td>
								<!---<td>#discount_rate# %</td>
								<td>#TLFormat(discount_amount,2)# #contract_money#</td>--->
								<td>#TLFormat(gross_progress,2)# #contract_money#</td>
								<td>#guarantee_rate# %</td>
								<td>#TLFormat(guarantee_amount,2)# #contract_money#</td>
								<td>#advance_rate# %</td>
								<td>#TLFormat(advance_amount,2)# #contract_money#</td>
								<td>#tevkifat_rate# %</td>
								<td>#TLFormat(tevkifat_amount,2)# #contract_money#</td>
								<td>#stoppage_rate# %</td>
								<td>#TLFormat(stoppage_amount,2)# #contract_money#</td>
								<td>#TLFormat(receipt_total,2)# #contract_money#</td>
								<td>#TLFormat(invoice_total,2)# #contract_money#</td>
								<td>#TLFormat(periodic_interruption,2)# #contract_money#</td>
								<td>#TLFormat(net_progress,2)# #contract_money#</td>
								<td><input type="radio" id="line_id" value="#currentrow#" name="line_id" onclick="degeriata(this.value);" <cfif gross_progress lte 0>disabled</cfif>></td>
							</tr>
							<input type="hidden" name="gross_total_#currentrow#" id="gross_total_#currentrow#" value="#gross_progress#" />
							<input type="hidden" name="today_total_#currentrow#" id="today_total_#currentrow#" value="#today_progress_#" />
							<input type="hidden" name="tevkifat_amount_#currentrow#" id="tevkifat_amount_#currentrow#" value="#tevkifat_amount#" />
							<input type="hidden" name="net_total_money_#currentrow#" id="net_total_money_#currentrow#" value="#contract_money#" />
							<input type="hidden" name="net_progress_#currentrow#" id="net_progress_#currentrow#" value="#net_progress#" />
							<input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#company_id#" />
							<input type="hidden" name="consumer_id_#currentrow#" id="consumer_id_#currentrow#" value="#consumer_id#" />
							<input type="hidden" name="contract_id_#currentrow#" id="contract_id_#currentrow#" value="#contract_id#" />
						</cfoutput>
						<cfif len(x_stock_id)>
							<cfquery name="getProduct" datasource="#dsn3#">
								SELECT PRODUCT_NAME,PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #x_stock_id#
							</cfquery>
							<cfset product_name = getProduct.PRODUCT_NAME>
							<cfset product_id = getProduct.product_id>
							<cfset stock_id = x_stock_id>
						<cfelse>
							<cfset product_name = ''>
							<cfset product_id = ''>
							<cfset stock_id = ''>
						</cfif>
					</tbody>					
				<cfelse>
					<tbody>
						<tr>
							<td colspan="21"><cfif isdefined('attributes.form_submited')><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</tbody>    
				</cfif>
			</cf_grid_list>
			<cfif get_contracts.recordcount>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12 ui-info-bottom flex-end">
					<cf_box_search more="0">
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#product_id#</cfoutput>">
								<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#stock_id#</cfoutput>">
								<input type="text" name="stock_name" id="stock_name"  style="width:140px;" onFocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','stock_id,product_id','add_hakedis_fatura','3','200');" value="<cfoutput>#product_name#</cfoutput>" autocomplete="off" placeholder="<cf_get_lang dictionary_id='57657.Product'>*">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_hakedis_fatura.stock_id&product_id=add_hakedis_fatura.product_id&field_name=add_hakedis_fatura.stock_name&','list');"></span>
							</div>
						</div>
						<div class="form-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='50707.Hakediş Ekle'></cfsavecontent>
							<input type="button" value="<cfoutput>#message#</cfoutput>" onClick="KontrolEt_Gonder();" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left">
						</div>
					</cf_box_search>
				</div>
			</cfif>
			<input type="hidden" name="action_currency_id" id="action_currency_id" value="" />
			<input type="hidden" name="action_value" id="action_value" value="" />
			<input type="hidden" name="gross_progress_value" id="gross_progress_value" value="" />
			<input type="hidden" name="today_progress_value" id="today_progress_value" value="" />
			<input type="hidden" name="net_progress_value" id="net_progress_value" value="" />
			<input type="hidden" name="tevkifat_amount_value" id="tevkifat_amount_value" value="" />
			<input type="hidden" name="company_id" id="company_id" value="" />
			<input type="hidden" name="consumer_id" id="consumer_id" value="" />
			<input type="hidden" name="contract_id" id="contract_id" value="" />
			<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#x_expense_center_id#</cfoutput>" />
			<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#x_expense_item_id#</cfoutput>" />
		</cfform>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = ''>
			<cfif len(attributes.company_id) and len(attributes.member_name)>
				<cfset url_str = url_str & "&company_id=#attributes.company_id#&member_name=#URLEncodedFormat(attributes.member_name)#">
			</cfif>
			<cfif len(attributes.consumer_id) and len(attributes.member_name)>
				<cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#&member_name=#URLEncodedFormat(attributes.member_name)#">
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)>
				<cfset url_str = url_str & "&project_id=#attributes.project_id#&project_head=#URLEncodedFormat(attributes.project_head)#">
			</cfif>
			<cfif len(attributes.contract_id) and len(attributes.contract_no)>
				<cfset url_str = url_str & "&contract_id=#attributes.contract_id#&contract_no=#URLEncodedFormat(attributes.contract_no)#">
			</cfif>
			<cfif len(attributes.contract_type) and len(attributes.contract_type)>
				<cfset url_str = url_str & "&contract_type=#attributes.contract_type#">
			</cfif>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction##url_str#&form_submited=1">
		</cfif>
	</cf_box>
</div>	
<script language="javascript">
		function control()
		{
			if((document.all.company_id.value == '' || document.all.member_name.value == '') && (document.all.consumer_id.value == '' || document.all.member_name.value == '') && (document.all.contract_id.value == '' || document.all.contract_no.value == ''))
			{
				alert('<cf_get_lang dictionary_id='57471.Missing Data'> : <cf_get_lang dictionary_id='57519.Current Account'> <cf_get_lang dictionary_id='57998.or'> <cf_get_lang dictionary_id='29522.Contract'>');
				return false;
			}
			document.progress_report.submit();
		}
		
		function degeriata(satir_no)
		{	
			document.add_hakedis_fatura.contract_id.value = eval('add_hakedis_fatura.contract_id_' + satir_no).value;
			document.add_hakedis_fatura.company_id.value = eval('add_hakedis_fatura.company_id_' + satir_no).value;
			document.add_hakedis_fatura.consumer_id.value = eval('add_hakedis_fatura.consumer_id_' + satir_no).value;
			document.add_hakedis_fatura.action_value.value = eval('add_hakedis_fatura.gross_total_' + satir_no).value;
			document.add_hakedis_fatura.gross_progress_value.value = eval('add_hakedis_fatura.gross_total_' + satir_no).value;
			document.add_hakedis_fatura.today_progress_value.value = eval('add_hakedis_fatura.today_total_' + satir_no).value;
			document.add_hakedis_fatura.net_progress_value.value = eval('add_hakedis_fatura.net_progress_' + satir_no).value;
			document.add_hakedis_fatura.tevkifat_amount_value.value = eval('add_hakedis_fatura.tevkifat_amount_' + satir_no).value;
			document.add_hakedis_fatura.action_currency_id.value = eval('add_hakedis_fatura.net_total_money_' + satir_no).value;
		}
		function KontrolEt_Gonder()
		{
			var kontrol_ = 0;
			for (var i=0; i < <cfoutput>#get_contracts.recordcount#</cfoutput>; i++)
			{
				if((document.add_hakedis_fatura.line_id[i]!=undefined && document.add_hakedis_fatura.line_id[i].checked == true) || (document.add_hakedis_fatura.line_id!=undefined && document.add_hakedis_fatura.line_id.checked == true))
					var kontrol_ = 1;
			}
			if(kontrol_ == 0)
			{
				alert('<cf_get_lang dictionary_id='57471.Missing Data'> : <cf_get_lang dictionary_id='58508.Line'>!');
				return false;
			}
			if(document.add_hakedis_fatura.company_id.value == '' && document.add_hakedis_fatura.consumer_id.value == '')
			{
				alert('<cf_get_lang dictionary_id='57471.Missing Data'> : <cf_get_lang dictionary_id='57519.Current Account'>!');
				return false;
			}
			
			if(add_hakedis_fatura.stock_id.value=="" || add_hakedis_fatura.stock_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Missing Data'> : <cf_get_lang dictionary_id='57657.Product'>");
				return false;
			}
			
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=contract.emptypopup_add_progress_payment</cfoutput>";
			add_hakedis_fatura.submit();
		}
</script>
</cfprocessingdirective>
