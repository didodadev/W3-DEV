<cfsetting showdebugoutput="yes">
<cfset value = '0'>
<cfif isdefined('attributes.is_form_submitted')>
	<cfquery name="GET_INVENTORIES" datasource="#DSN3#">
		SELECT
			SUM(IR.STOCK_IN-IR.STOCK_OUT) MIKTAR,
			I.INVENTORY_ID,
			I.INVENTORY_NUMBER,
			I.INVENTORY_NAME,
			I.QUANTITY,
			I.ACCOUNT_ID,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.AMOUNT,
			I.LAST_INVENTORY_VALUE,
			I.AMORTIZATON_METHOD,
			I.RECORD_DATE,
			I.AMORTIZATON_ESTIMATE,
			I.EXPENSE_ITEM_ID,
			(SELECT EXPENSE_ITEM_NAME FROM #dsn2_alias#.EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = I.EXPENSE_ITEM_ID) EXPENSE_ITEM_NAME,
			I.EXPENSE_CENTER_ID,
			(SELECT EXPENSE FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE_ID = I.EXPENSE_CENTER_ID) EXPENSE_CENTER_NAME,
			I.DEBT_ACCOUNT_ID,
			I.CLAIM_ACCOUNT_ID,
			I.SUBSCRIPTION_ID,
			ISNULL((SELECT SC.SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT SC WHERE SC.SUBSCRIPTION_ID = I.SUBSCRIPTION_ID),'') SUBSCRIPTION_HEAD,
			ISNULL((SELECT SC.SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT SC WHERE SC.SUBSCRIPTION_ID = I.SUBSCRIPTION_ID),'') SUBSCRIPTION_NO,
			(SELECT TOP 1 IRR.STOCK_ID FROM INVENTORY_ROW IRR WHERE IRR.INVENTORY_ID = I.INVENTORY_ID AND IRR.STOCK_ID IS NOT NULL ORDER BY IRR.INVENTORY_ROW_ID) STOCK_ID,
			(SELECT S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID = (SELECT TOP 1 IRR.STOCK_ID FROM INVENTORY_ROW IRR WHERE IRR.INVENTORY_ID = I.INVENTORY_ID AND IRR.STOCK_ID IS NOT NULL ORDER BY IRR.INVENTORY_ROW_ID)) PRODUCT_NAME,
			(SELECT S.PRODUCT_ID FROM STOCKS S WHERE S.STOCK_ID = (SELECT TOP 1 IRR.STOCK_ID FROM INVENTORY_ROW IRR WHERE IRR.INVENTORY_ID = I.INVENTORY_ID AND IRR.STOCK_ID IS NOT NULL ORDER BY IRR.INVENTORY_ROW_ID)) PRODUCT_ID,
			(SELECT S.PRODUCT_UNIT_ID FROM STOCKS S WHERE S.STOCK_ID = (SELECT TOP 1 IRR.STOCK_ID FROM INVENTORY_ROW IRR WHERE IRR.INVENTORY_ID = I.INVENTORY_ID AND IRR.STOCK_ID IS NOT NULL ORDER BY IRR.INVENTORY_ROW_ID)) PRODUCT_UNIT_ID,
			(SELECT TOP 1 PU.ADD_UNIT FROM PRODUCT_UNIT PU WHERE PRODUCT_UNIT_ID = (SELECT S.PRODUCT_UNIT_ID FROM STOCKS S WHERE S.STOCK_ID = (SELECT TOP 1 IRR.STOCK_ID FROM INVENTORY_ROW IRR WHERE IRR.INVENTORY_ID = I.INVENTORY_ID AND IRR.STOCK_ID IS NOT NULL ORDER BY IRR.INVENTORY_ROW_ID))) PRODUCT_UNIT,
			(SELECT TOP 1 REASON_CODE FROM PRODUCT_PERIOD WHERE PRODUCT_PERIOD.PRODUCT_ID = IR.PRODUCT_ID AND PRODUCT_PERIOD.PERIOD_ID= #session.ep.period_id#) AS REASON_CODE
		FROM
			INVENTORY I,
			INVENTORY_ROW IR
		WHERE
			I.INVENTORY_ID = IR.INVENTORY_ID
            <!--- AND I.LAST_INVENTORY_VALUE > <cfqueryparam cfsqltype="cf_sql_float" value="#value#"> ---> <!--- Degeri sifir olsa bile miktari sifirdan buyuk olan sabit kiymetlerin listelenmesi gerekir --->
			AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
            <cfif isDefined("attributes.inventory_no") and len(attributes.inventory_no)>
				AND INVENTORY_NUMBER LIKE '%#attributes.inventory_no#%'
			</cfif>
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
				AND I.SUBSCRIPTION_ID = #attributes.subscription_id#
			</cfif>
			<cfif isdefined("attributes.ch_company_id") and  len(attributes.ch_company_id) and isdefined("attributes.ch_company") and len(attributes.ch_company)>
				AND I.COMP_ID IN(#attributes.ch_company_id#)
			</cfif>
			<cfif isdefined("attributes.ch_consumer_id") and len(attributes.ch_consumer_id) and len(attributes.ch_company) and isdefined("attributes.ch_company")>
				AND I.COMP_ID IN(#attributes.ch_consumer_id#)
			</cfif>
		GROUP BY
			I.INVENTORY_ID,
			I.INVENTORY_NUMBER,
			I.INVENTORY_NAME,
			I.QUANTITY,
			I.ACCOUNT_ID,
			I.RECORD_DATE,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.AMOUNT,
			I.LAST_INVENTORY_VALUE,
			I.AMORTIZATON_METHOD,
			I.AMORTIZATON_ESTIMATE,
			I.EXPENSE_ITEM_ID,
			I.EXPENSE_CENTER_ID,
			I.DEBT_ACCOUNT_ID,
			I.CLAIM_ACCOUNT_ID,
			I.SUBSCRIPTION_ID,
			IR.PRODUCT_ID
		HAVING SUM(ISNULL(IR.STOCK_IN,0) - ISNULL(IR.STOCK_OUT,0)) > 0
		ORDER BY I.RECORD_DATE DESC
	</cfquery>
	<cfif attributes.invent_list_type eq 0>	
		<cfoutput query="get_inventories">
			<cfset row_value = "#inventory_id#;#replace(replace(inventory_name,"'",""),'"','','all')#;#inventory_number#;#miktar#;#account_id#;#Tlformat(amortizaton_estimate)#;#amortizaton_method#;#Tlformat(last_inventory_value,8)#;#Tlformat(last_inventory_value*miktar)#;#Tlformat(amount,8)#;#Tlformat(amount*miktar)#;#Tlformat(0-(last_inventory_value*miktar))#;#expense_center_id#;#expense_center_name#;#expense_item_id#;#expense_item_name#;#debt_account_id#;#claim_account_id#;#stock_id#;#product_id#;#product_name#;#product_unit_id#;#product_unit#;#expense_center_name#">			
			<cfif isdefined("inventory_list_#SUBSCRIPTION_ID#")>
				<cfset "inventory_list_#SUBSCRIPTION_ID#" = listappend(evaluate("inventory_list_#SUBSCRIPTION_ID#"),row_value,'&')>
			<cfelse>
				<cfset "inventory_list_#SUBSCRIPTION_ID#" = row_value>
			</cfif>
		</cfoutput>
		<cfquery name="get_inventory_main" dbtype="query">
			SELECT DISTINCT
				SUBSCRIPTION_ID,
				SUBSCRIPTION_NO,
				SUBSCRIPTION_HEAD
			FROM
				GET_INVENTORIES
			WHERE
				SUBSCRIPTION_ID IS NOT NULL
			ORDER BY
				SUBSCRIPTION_HEAD
		</cfquery>
	<cfelse>
		<cfset get_inventory_main.recordcount = 0>        
	</cfif>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_inventory_main.recordcount = 0>
	<cfset get_inventories.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfparam name="attributes.type" default="0"><!---Değer düşürmeli tipi için type 1 --->
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.inventory_no" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.invent_list_type" default="1">
<cfif attributes.invent_list_type eq 0>
<cfparam name="attributes.totalrecords" default=#get_inventory_main.recordcount#>
<cfelse>
<cfparam name="attributes.totalrecords" default=#get_inventories.recordcount#>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = '&is_form_submitted=1'>
<cfif isdefined("attributes.field_id")>
  <cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
  <cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("attributes.field_number")>
  <cfset url_string = "#url_string#&field_number=#field_number#">
</cfif>
<cfif isdefined("attributes.field_quantity")>
  <cfset url_string = "#url_string#&field_quantity=#field_quantity#">
</cfif>
<cfif isdefined("attributes.field_acc")>
  <cfset url_string = "#url_string#&field_acc=#field_acc#">
</cfif>
<cfif isdefined("attributes.is_sale")>
  <cfset url_string = "#url_string#&is_sale=#is_sale#">
</cfif>
<cfif isdefined("attributes.amort_rate")>
  <cfset url_string = "#url_string#&amort_rate=#amort_rate#">
</cfif>
<cfif isdefined("attributes.type")>
  <cfset url_string = "#url_string#&type=#attributes.type#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Demirbaş Listesi','33468')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_product" action="#request.self#?fuseaction=objects.popup_list_inventory#url_string#" method="post">
			<cf_box_search more="0">
				<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
				<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>" />
				<input type="hidden" name="ch_consumer_id" id="ch_consumer_id"  value="<cfif len(attributes.ch_consumer_id)><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
				<input type="hidden" name="ch_company_id" id="ch_company_id"  value="<cfif len(attributes.ch_company_id)><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
				<div class="form-group">
					<cfinput type="text" name="inventory_no" placeholder="#getLang('','Demirbaş No','58878')#" value="#attributes.inventory_no#" maxlength="255">
				</div>
				<div class="form-group" id="ch_company">
					<div class="input-group">
						<cfinput type="text" name="ch_company" id="ch_company" placeholder="#getLang('','Cari Hesap','57519')#" value="#attributes.ch_company#" onFocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','ch_consumer_id,ch_company_id','','3','250');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=search_product.ch_company_id&field_member_name=search_product.ch_company&field_name=search_product.ch_company&field_consumer=search_product.ch_consumer_id</cfoutput>&keyword='+encodeURIComponent(document.search_product.ch_company.value))"></span>
					</div>
				</div>
				<div class="form-group" id="subscription_no">
					<div class="input-group">
						<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
						<cfinput type="text" name="subscription_no" id="subscription_no" placeholder="#getLang('','Abone No','29502')#"  value="#attributes.subscription_no#">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=search_product.subscription_id&field_no=search_product.subscription_no</cfoutput>');"></span>
					</div>
				</div>
				<div class="form-group" id="invent_list_type">
					<select name="invent_list_type" id="invent_list_type">
						<option value="1" <cfif attributes.invent_list_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29539.Satır Bazında"></option>
						<option value="0" <cfif attributes.invent_list_type eq 0>selected</cfif>><cf_get_lang dictionary_id="39250.Sistem Bazında"></option>
					</select>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<cfif attributes.invent_list_type eq 0>
				<thead>
					<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='29502.Sistem No'></th>
					<th><cf_get_lang dictionary_id='58832.Abone'></th>
					<th width="15"><input type="checkbox" name="allSelectInv" id="allSelectInv" onClick="wrk_select_all('allSelectInv','subscription_id');"></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_inventory_main.recordcount>
						<form action="" method="post" name="form_name">
							<cfoutput query="get_inventory_main" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr>
									<td>#currentrow#</td>
									<td>#subscription_no#</td>
									<td>#subscription_head#</td>
									<td>
										<input type="hidden" name="inventory_id_list" id="inventory_id_list" value="#evaluate("inventory_list_#SUBSCRIPTION_ID#")#">
										<input type="checkbox" value="#subscription_id#" name="subscription_id" id="subscription_id">
									</td>
								</tr>
							</cfoutput>
						</form>
						<tr>
							<td style="text-align:right;" colspan="4"><input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onClick="add_checked(0);"></td>
						</tr>
					<cfelse>
						<tr>
							<td colspan="4"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
						</tr>
					</cfif>
				</tbody>
			<cfelse>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th><cf_get_lang dictionary_id='57452.Stok'></th>
						<th><cf_get_lang dictionary_id='33496.İlk Değer'></th>
						<th><cf_get_lang dictionary_id='33497.Aktif Değer'></th>
						<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th><cf_get_lang dictionary_id='32619.Alım Tarihi'></th>
						<th><cf_get_lang dictionary_id='32618.Alınan Şirket'></th>
						<cfif attributes.type eq 0>
						<th width="15"><input type="checkbox" name="allSelectInv" id="allSelectInv" onClick="wrk_select_all('allSelectInv','inventory_id');"></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfif get_inventories.recordcount>
						<cfset item_id_list=''>
						<cfset comp_id_list=''>
						<cfoutput query="get_inventories" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<cfif len(COMP_ID) and not listfind(comp_id_list,COMP_ID)>
								<cfset comp_id_list = listappend(comp_id_list,COMP_ID)>
							</cfif>
							<cfif len(expense_item_id) and not listfind(item_id_list,expense_item_id)>
								<cfset item_id_list=listappend(item_id_list,expense_item_id)>
							</cfif>
						</cfoutput>
						<cfif len(comp_id_list)>
							<cfset comp_id_list=listsort(comp_id_list,"numeric","ASC",",")>
							<cfquery name="get_company_detail" datasource="#dsn#">
								SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#comp_id_list#) ORDER BY COMPANY_ID
							</cfquery>
						</cfif>
						<form action="" method="post" name="form_name">
							<cfoutput query="get_inventories" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr>
									<td>#currentrow#</td>
									<td>
										<cfif attributes.type eq 0>
											<a href="javascript://" class="tableyazi" onclick="opener.gonder('#inventory_id#','#replace(replace(inventory_name,"'",""),'"','','all')#','#inventory_number#','#miktar#','#account_id#','#Tlformat(amortizaton_estimate)#', '#amortizaton_method#','#Tlformat(last_inventory_value,8)#','#Tlformat(last_inventory_value*quantity)#','#Tlformat(amount,8)#','#Tlformat(amount*quantity)#','#Tlformat(0-(last_inventory_value*quantity))#','#expense_center_id#','#expense_center_name#','#expense_item_id#','#expense_item_name#','#debt_account_id#','#claim_account_id#','#product_id#','#product_name#','#product_unit_id#','#stock_id#','#product_unit#','#entry_date#');">#inventory_number#</a>
										<cfelse>
											<a href="javascript://" class="tableyazi" onclick="send('#inventory_id#','#replace(replace(inventory_name,"'",""),'"','','all')#','#inventory_number#');">#inventory_number#</a>
										</cfif>
									</td>
									<td>
										<cfif attributes.type eq 0>
											<a href="javascript://" class="tableyazi" onclick="opener.gonder('#inventory_id#','#replace(replace(inventory_name,"'",""),'"','','all')#','#inventory_number#','#miktar#','#account_id#','#Tlformat(amortizaton_estimate)#', '#amortizaton_method#','#Tlformat(last_inventory_value,8)#','#Tlformat(last_inventory_value*quantity)#','#Tlformat(amount,8)#','#Tlformat(amount*quantity)#','#Tlformat(0-(last_inventory_value*quantity))#','#expense_center_id#','#expense_center_name#','#expense_item_id#','#expense_item_name#','#debt_account_id#','#claim_account_id#','#product_id#','#product_name#','#product_unit_id#','#stock_id#','#product_unit#','#entry_date#');">#inventory_name#</a>
										<cfelse>
											<a href="javascript://" class="tableyazi" onclick="send('#inventory_id#','#replace(replace(inventory_name,"'",""),'"','','all')#','#inventory_number#');">#inventory_name#</a>
										</cfif>
									</td>
									<td>#quantity#</td>
									<td>#miktar#</td>
									<td>#TLFormat(amount)#</td>
									<td>#TLFormat(last_inventory_value)#</td>
									<td>#account_id#</td>
									<td>#dateformat(entry_date,dateformat_style)#</td>
									<td>
										<cfif len(comp_id)>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMP_ID#','medium');" class="tableyazi">#get_company_detail.nickname[listfind(comp_id_list,comp_id,',')]#</a>
										</cfif>
									</td>
									<cfif attributes.type eq 0>
										<td>
											<input type="checkbox" value="#inventory_id#" name="inventory_id" id="inventory_id">
											<input type="hidden" name="inventory_name" id="inventory_name" value="#replace(replace(inventory_name,"'",""),'"','','all')#">
											<input type="hidden" name="inventory_number" id="inventory_number" value="#inventory_number#">
											<input type="hidden" name="entry_date" id="entry_date" value="#dateformat(entry_date,dateformat_style)#">
											<input type="hidden" name="miktar" id="miktar" value="#miktar#">
											<input type="hidden" name="account_id" id="account_id" value="#account_id#">
											<input type="hidden" name="amortizaton_estimate" id="amortizaton_estimate" value="#Tlformat(amortizaton_estimate)#">
											<input type="hidden" name="amortizaton_method" id="amortizaton_method" value="#amortizaton_method#">
											<input type="hidden" name="last_inventory_value" id="last_inventory_value" value="#Tlformat(last_inventory_value,8)#">
											<input type="hidden" name="last_total_value" id="last_total_value" value="#Tlformat(last_inventory_value*quantity)#">
											<input type="hidden" name="amount" id="amount" value="#Tlformat(amount,8)#">
											<input type="hidden" name="all_amount" id="all_amount" value="#Tlformat(amount*quantity)#">
											<input type="hidden" name="remain_amount" id="remain_amount" value="#Tlformat(0-(last_inventory_value*quantity))#">
											<input type="hidden" name="expense_center_id" id="expense_center_id" value="#expense_center_id#">
											<input type="hidden" name="expense_center_name" id="expense_center_name" value="#expense_center_name#">
											<input type="hidden" name="expense_item_id" id="expense_item_id" value="#expense_item_id#">
											<input type="hidden" name="expense_item_name" id="expense_item_name" value="#expense_item_name#">
											<input type="hidden" name="debt_account_id" id="debt_account_id" value="#debt_account_id#">
											<input type="hidden" name="claim_account_id" id="claim_account_id" value="#claim_account_id#">
											<input type="hidden" name="stock_id" id="stock_id" value="<cfif len(stock_id)>#stock_id#</cfif>">
											<input type="hidden" name="product_name" id="product_name" value="<cfif len(product_name)>#product_name#</cfif>">
											<input type="hidden" name="product_id" id="product_id" value="<cfif len(product_id)>#product_id#</cfif>">
											<input type="hidden" name="product_unit_id" id="product_unit_id" value="<cfif len(product_unit_id)>#product_unit_id#</cfif>">
											<input type="hidden" name="product_unit" id="product_unit" value="<cfif len(product_unit)>#product_unit#</cfif>">
											<input type="hidden" name="reason_code" id="reason_code" value="<cfif len(reason_code)>#reason_code#</cfif>">
										</td>
									</cfif>
								</tr>
							</cfoutput>
				</tbody>
						</form>
				<cfif attributes.type eq 0>
				<tfoot>
					<tr>
						<td colspan="11" style="text-align:right"><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#getLang('','Kaydet',57461)#' insert_alert='' add_function='add_checked(1)'></td>
					</tr>
				</tfoot>
				</cfif>
				<cfelse>
					<tr>
						<td colspan="11"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</cfif>
		</cf_grid_list>
		<cfif len(attributes.inventory_no)>
			<cfset url_string = "#url_string#&inventory_no=#attributes.inventory_no#">
		</cfif>
		<cfif len(attributes.subscription_no)>
			<cfset url_string = "#url_string#&subscription_no=#attributes.subscription_no#" >
		</cfif>
		<cfif len(attributes.subscription_no)>
			<cfset url_string = "#url_string#&subscription_id=#attributes.subscription_id#" >
		</cfif>
		<cfif len(attributes.ch_company)>
			<cfset url_string = "#url_string#&ch_company=#attributes.ch_company#" >
		</cfif>
		<cfif len(attributes.ch_company_id)>
			<cfset url_string = "#url_string#&ch_company_id=#attributes.ch_company_id#" >
		</cfif>
		<cfif len(attributes.ch_consumer_id)>
			<cfset url_string = "#url_string#&ch_consumer_id=#attributes.ch_consumer_id#" >
		</cfif>
		<cfif len(attributes.invent_list_type)>
			<cfset url_string = "#url_string#&invent_list_type=#attributes.invent_list_type#" >
		</cfif>
		<cfif get_inventories.recordcount and (attributes.maxrows lt attributes.totalrecords)>
			<table width="99%" align="center">
				<tr>
				<td><cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#" 
						adres="objects.popup_list_inventory#url_string#"></td>
				<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>

<script type="text/javascript">
document.getElementById('inventory_no').focus();
	function send(inventory_id,inventory_name,inventory_number)
	{
		<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=inventory_id;
		</cfif>
		<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=inventory_number;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>		
	}
	function add_checked(type)
	{
		if(type == 1)
		{
			var counter = 0;
			<cfif get_inventories.recordcount gt 1  and attributes.maxrows neq 1>	
				for(i=0;i<form_name.inventory_id.length;i++) 
					if (form_name.inventory_id[i].checked == true) 
					{
						counter = counter + 1;
					}
					if (counter == 0)
					{
						alert("<cf_get_lang dictionary_id='36430.Demirbaş Seçmelisiniz'> !");
						return false;
					}
			<cfelseif get_inventories.recordcount eq 1 or  attributes.maxrows eq 1>
				if (form_name.inventory_id.checked == true) 
				{
					counter = counter + 1;
				}
				if (counter == 0)
				{
					alert("<cf_get_lang dictionary_id='36430.Demirbaş Seçmelisiniz'> !");
					return false;
				}
			</cfif>
			<cfif get_inventories.recordcount gt 1  and attributes.maxrows neq 1>
				for(i=0;i<form_name.inventory_id.length;i++) 
					if (form_name.inventory_id[i].checked == true) 
					{
						inventory_id = form_name.inventory_id[i].value;
						inventory_name = form_name.inventory_name[i].value;
						inventory_number = form_name.inventory_number[i].value;
						miktar = form_name.miktar[i].value;
						account_id = form_name.account_id[i].value;
						amortizaton_estimate = form_name.amortizaton_estimate[i].value;
						amortizaton_method = form_name.amortizaton_method[i].value;
						last_inventory_value = form_name.last_inventory_value[i].value;
						last_total_value = form_name.last_total_value[i].value;
						amount = form_name.amount[i].value;
						all_amount = form_name.all_amount[i].value;
						remain_amount = form_name.remain_amount[i].value;
						expense_center_id = form_name.expense_center_id[i].value;
						expense_center_name = form_name.expense_center_name[i].value;
						expense_item_id = form_name.expense_item_id[i].value;
						expense_item_name = form_name.expense_item_name[i].value;
						debt_account_id = form_name.debt_account_id[i].value;
						claim_account_id = form_name.claim_account_id[i].value;
						product_id = form_name.product_id[i].value;
						product_name = form_name.product_name[i].value;
						product_unit_id = form_name.product_unit_id[i].value;
						stock_id = form_name.stock_id[i].value;
						product_unit = form_name.product_unit[i].value;
						reason_code = form_name.reason_code[i].value;
						entry_date = form_name.entry_date[i].value;
						opener.gonder(inventory_id,inventory_name,inventory_number,miktar,account_id,amortizaton_estimate,amortizaton_method,last_inventory_value,last_total_value,amount,all_amount,remain_amount,expense_center_id,expense_center_name,expense_item_id,expense_item_name,debt_account_id,claim_account_id,product_id,product_name,product_unit_id,stock_id,product_unit,reason_code,entry_date);
					}
			<cfelseif get_inventories.recordcount eq 1 or  attributes.maxrows eq 1>
				if (form_name.inventory_id.checked == true) 
				{
					inventory_id = form_name.inventory_id.value;
					inventory_name = form_name.inventory_name.value;
					inventory_number = form_name.inventory_number.value;
					miktar = form_name.miktar.value;
					account_id = form_name.account_id.value;
					amortizaton_estimate = form_name.amortizaton_estimate.value;
					amortizaton_method = form_name.amortizaton_method.value;
					last_inventory_value = form_name.last_inventory_value.value;
					last_total_value = form_name.last_total_value.value;
					amount = form_name.amount.value;
					all_amount = form_name.all_amount.value;
					remain_amount = form_name.remain_amount.value;
					expense_center_id = form_name.expense_center_id.value;
					expense_center_name = form_name.expense_center_name.value;
					expense_item_id = form_name.expense_item_id.value;
					expense_item_name = form_name.expense_item_name.value;
					debt_account_id = form_name.debt_account_id.value;
					claim_account_id = form_name.claim_account_id.value;
					product_id = form_name.product_id.value;
					product_name = form_name.product_name.value;
					product_unit_id = form_name.product_unit_id.value;
					stock_id = form_name.stock_id.value;
					product_unit = form_name.product_unit.value;
					reason_code = form_name.reason_code[i].value;
					entry_date = form_name.entry_date[i].value;
					opener.gonder(inventory_id,inventory_name,inventory_number,miktar,account_id,amortizaton_estimate,amortizaton_method,last_inventory_value,last_total_value,amount,all_amount,remain_amount,expense_center_id,expense_center_name,expense_item_id,expense_item_name,debt_account_id,claim_account_id,product_id,product_name,product_unit_id,stock_id,product_unit,reason_code,entry_date);
				}
			</cfif>
		}
		else
		{
			var counter = 0;
			<cfif get_inventory_main.recordcount gt 1 and attributes.maxrows neq 1>	
				for(i=0;i<form_name.subscription_id.length;i++) 
					if (form_name.subscription_id[i].checked == true) 
					{
						counter = counter + 1;
					}
					if (counter == 0)
					{
						alert("<cf_get_lang dictionary_id='32382.Sistem Seçmelisiniz'> !");
						return false;
					}
			<cfelseif get_inventory_main.recordcount eq 1 or attributes.maxrows eq 1>
				if (form_name.subscription_id.checked == true) 
				{
					counter = counter + 1;
				}
				if (counter == 0)
				{
					alert("<cf_get_lang dictionary_id='32382.Sistem Seçmelisiniz'> !");
					return false;
				}
			</cfif>
			<cfif get_inventory_main.recordcount gt 1 and attributes.maxrows neq 1>	
				for(i=0;i<form_name.subscription_id.length;i++) 
					if (form_name.subscription_id[i].checked == true) 
					{
						inventory_id_list = form_name.inventory_id_list[i].value;
						for(kk=1;kk<=list_len(inventory_id_list,'&');kk++)
						{
							inventory_value = list_getat(inventory_id_list,kk,'&');
							inventory_id = list_getat(inventory_value,1,';');
							inventory_name = list_getat(inventory_value,2,';');
							inventory_number = list_getat(inventory_value,3,';');
							miktar = list_getat(inventory_value,4,';');
							account_id = list_getat(inventory_value,5,';');
							amortizaton_estimate = list_getat(inventory_value,6,';');
							amortizaton_method = list_getat(inventory_value,7,';');
							last_inventory_value = list_getat(inventory_value,8,';');
							last_total_value = list_getat(inventory_value,9,';');
							amount = list_getat(inventory_value,10,';');
							all_amount = list_getat(inventory_value,11,';');
							remain_amount = list_getat(inventory_value,12,';');
							expense_center_id = list_getat(inventory_value,13,';');
							expense_item_id = list_getat(inventory_value,14,';');
							expense_item_name = list_getat(inventory_value,15,';');
							debt_account_id = list_getat(inventory_value,16,';');
							claim_account_id = list_getat(inventory_value,17,';');
							entry_date = list_getat(entry_date,24,';');
							if(list_len(inventory_value) > 17)
							{
								product_id = list_getat(inventory_value,18,';');
								product_name = list_getat(inventory_value,19,';');
								product_unit_id = list_getat(inventory_value,20,';');
								stock_id = list_getat(inventory_value,21,';');
								product_unit = list_getat(inventory_value,22,';');
								reason_code = list_getat(inventory_value,23,';');
							}
							else
							{
								product_id = '';
								product_name = '';
								product_unit_id = '';
								stock_id = '';
								product_unit='';
								reason_code = '';
							}
							expense_center_name = list_getat(inventory_value,23,';');
							opener.gonder(inventory_id,inventory_name,inventory_number,miktar,account_id,amortizaton_estimate,amortizaton_method,last_inventory_value,last_total_value,amount,all_amount,remain_amount,expense_center_id,expense_center_name,expense_item_id,expense_item_name,debt_account_id,claim_account_id,product_id,product_name,product_unit_id,stock_id,product_unit,reason_code,entry_date);
						}
					}
			<cfelseif get_inventory_main.recordcount eq 1 or attributes.maxrows eq 1>
				if (form_name.subscription_id.checked == true) 
				{
					inventory_id_list = form_name.inventory_id_list.value;
					for(kk=1;kk<=list_len(inventory_id_list,'&');kk++)
					{
						inventory_value = list_getat(inventory_id_list,kk,'&');
						inventory_id = list_getat(inventory_value,1,';');
						inventory_name = list_getat(inventory_value,2,';');
						inventory_number = list_getat(inventory_value,3,';');
						miktar = list_getat(inventory_value,4,';');
						account_id = list_getat(inventory_value,5,';');
						amortizaton_estimate = list_getat(inventory_value,6,';');
						amortizaton_method = list_getat(inventory_value,7,';');
						last_inventory_value = list_getat(inventory_value,8,';');
						last_total_value = list_getat(inventory_value,9,';');
						amount = list_getat(inventory_value,10,';');
						all_amount = list_getat(inventory_value,11,';');
						remain_amount = list_getat(inventory_value,12,';');
						expense_center_id = list_getat(inventory_value,13,';');
						expense_item_id = list_getat(inventory_value,14,';');
						expense_item_name = list_getat(inventory_value,15,';');
						debt_account_id = list_getat(inventory_value,16,';');
						claim_account_id = list_getat(inventory_value,17,';');
						entry_date = list_getat(entry_date,24,';');
						if(list_len(inventory_value) > 17)
						{
							product_id = list_getat(inventory_value,18,';');
							product_name = list_getat(inventory_value,19,';');
							product_unit_id = list_getat(inventory_value,20,';');
							stock_id = list_getat(inventory_value,21,';');
							product_unit = list_getat(inventory_value,22,';');
							reason_code = list_getat(inventory_value,23,';');
						}
						else
						{
							product_id = '';
							product_name = '';
							product_unit_id = '';
							stock_id = '';
							product_unit = '';
							reason_code ='';
						}
						expense_center_name = list_getat(inventory_value,23,';');
						opener.gonder(inventory_id,inventory_name,inventory_number,miktar,account_id,amortizaton_estimate,amortizaton_method,last_inventory_value,last_total_value,amount,all_amount,remain_amount,expense_center_id,expense_center_name,expense_item_id,expense_item_name,debt_account_id,claim_account_id,product_id,product_name,product_unit_id,stock_id,product_unit,reason_code,entry_date);
					}				
				}
			</cfif>
		}
	}
</script>
