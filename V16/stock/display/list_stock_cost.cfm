<cfsetting showdebugoutput="yes">
<cfparam name="attributes.inventory_calc_type" default="1">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company" default=""> 
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.is_zero_stock" default="0"><!--- Hareket görenler default --->
<cfparam name="attributes.cost_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.list_type" default="0">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.rate2_info" default="0">
<cf_date tarih = 'attributes.cost_date'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
<cfif attributes.fuseaction contains 'list_stock_cost'><!--- Excel alirken autoexcel ifadesi geliyordu. Bu yuzden is yerine contains daha güzel olur. EY20131107 --->
	<cfscript>
		get_product_list_action = createObject("component", "V16.stock.cfc.get_product");
		get_product_list_action.dsn3 = dsn3;
		get_product_list_action.dsn2_alias = dsn2_alias;
		get_product = get_product_list_action.get_product_fnc3(
		department_id : '#iif(isdefined("attributes.department_id"),"attributes.department_id",DE(""))#',
		keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
		employee_id : '#iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
		company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
		employee : '#iif(isdefined("attributes.employee"),"attributes.employee",DE(""))#',
		company : '#iif(isdefined("attributes.company"),"attributes.company",DE(""))#',
		search_product_catid : '#iif(isdefined("attributes.search_product_catid"),"attributes.search_product_catid",DE(""))#',
		product_id : '#iif(isdefined("attributes.product_id"),"attributes.product_id",DE(""))#',
		sort_type : '#iif(isdefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
		product_cat : '#iif(isdefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		product_name : '#iif(isdefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		cost_date : '#iif(isdefined("attributes.cost_date"),"attributes.cost_date",DE(""))#',
		list_type : '#iif(isdefined("attributes.list_type"),"attributes.list_type",DE(""))#',
		sql_unicode_func : sql_unicode(),
		startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#');
	</cfscript> 
<cfelse>
	<cfscript>
		get_product_list_action = createObject("component", "V16.stock.cfc.get_product");
		get_product_list_action.dsn3 = dsn3;
		get_product_list_action.dsn2_alias = dsn2_alias;
		get_product = get_product_list_action.get_product_fnc(
		department_id : '#iif(isdefined("attributes.department_id"),"attributes.department_id",DE(""))#',
		keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
		employee_id : '#iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
		company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
		employee : '#iif(isdefined("attributes.employee"),"attributes.employee",DE(""))#',
		company : '#iif(isdefined("attributes.company"),"attributes.company",DE(""))#',
		search_product_catid : '#iif(isdefined("attributes.search_product_catid"),"attributes.search_product_catid",DE(""))#',
		product_id : '#iif(isdefined("attributes.product_id"),"attributes.product_id",DE(""))#',
		sort_type : '#iif(isdefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
		product_cat : '#iif(isdefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		product_name : '#iif(isdefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		cost_date : '#iif(isdefined("attributes.cost_date"),"attributes.cost_date",DE(""))#',
		list_type : '#iif(isdefined("attributes.list_type"),"attributes.list_type",DE(""))#',
		sql_unicode_func : sql_unicode(),
		startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#');
	</cfscript> 
</cfif>
       
<cfelse>
	<cfset get_product.recordcount=0>
</cfif>
<cfinclude template="../query/get_product_cat.cfm">
<cfinclude template="../query/get_depos.cfm">
<cfif get_product.recordcount and attributes.fuseaction contains 'list_stock_cost'>
	<cfparam name="attributes.totalrecords" default="#get_product.recordcount#">
<cfelseif get_product.recordcount>
	<cfparam name="attributes.totalrecords" default="#get_product.query_count#">
<cfelse>	
	<cfparam name="attributes.totalrecords" default="0">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=stock.list_stock_cost&type=stocks" method="post" name="stock_search">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
					<select name="inventory_calc_type" id="inventory_calc_type"  style="width:110px;">
						<option value="3"<cfif attributes.inventory_calc_type eq 3> selected</cfif>><cf_get_lang dictionary_id='45380.Ağırlıklı Ortalama'></option>
						<option value="6"<cfif attributes.inventory_calc_type eq 6> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
						<option value="7"<cfif attributes.inventory_calc_type eq 7> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="list_type" id="list_type" style="width:75px;">
						<option value="0" <cfif attributes.list_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='45555.Stok Bazında'></option>
						<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='45556.Spec Bazında'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="sort_type" id="sort_type" style="width:110px;">
						<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='45553.Ürün Adına Göre'></option>
						<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='45554.Stok Koduna Göre'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group">
					<label><input type="checkbox" name="rate2_info" id="rate2_info" value="1"<cfif attributes.rate2_info eq 1>checked</cfif>><cfoutput>#session.ep.money2#</cfoutput> <cf_get_lang dictionary_id="58596.Göster"></label>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-employee">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
									<input type="text" name="employee" id="employee" style="width:135px;" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=stock_search.employee_id&field_name=stock_search.employee&select_list=1&keyword='+encodeURIComponent(document.stock_search.employee.value),'list');"></span>
								</div>
							</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
									<input type="text" name="company" id="company" style="width:135px;" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company#</cfoutput></cfif>">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=stock_search.company&field_comp_id=stock_search.company_id&select_list=2&keyword='+encodeURIComponent(document.stock_search.company.value),'list');"></span>
								</div>
							</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-product_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
									<input type="text" name="product_name" id="product_name" style="width:135px;" value="<cfif len(attributes.product_id)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=stock_search.product_id&field_name=stock_search.product_name&keyword='+encodeURIComponent(document.stock_search.product_name.value),'list');"></span>
								</div>
							</div>
					</div>
					<div class="form-group" id="item-product_cat">
						<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfoutput>#attributes.search_product_catid#</cfoutput>">
									<input type="text" name="product_cat" id="product_cat" style="width:135px;"  value="<cfif len(attributes.search_product_catid)><cfoutput>#attributes.product_cat#</cfoutput></cfif>">				
									<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='45755.Ürün Kategorisi Ekle'>!" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=stock_search.search_product_catid&field_name=stock_search.product_cat</cfoutput>&keyword='+encodeURIComponent(document.stock_search.product_cat.value));"></span>
								</div>
							</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-department_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
						<div class="col col-12">
							<select name="department_id" id="department_id" style="width:120px;">
								<option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
								<cfoutput query="get_depos">
									<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
								</cfoutput>
							</select>
							</div>
					</div>
					<div class="form-group" id="item-cost_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfinput required="Yes" validate="#validate_style#" maxlength="10" type="text" name="cost_date" style="width:63px;" value="#dateformat(attributes.cost_date,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="cost_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(197,'Stok Maliyetleri',45374)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<cfif attributes.list_type eq 1><th><cf_get_lang dictionary_id='45420.Main Spec ID'></th></cfif>
					<th><cf_get_lang dictionary_id='57635.Miktar'></tf>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<cfif ListFind("3",attributes.inventory_calc_type,",") and (isdefined("attributes.rate2_info") and attributes.rate2_info eq 1)><th><cf_get_lang dictionary_id='57673.Tutar'> (<cfoutput>#session.ep.money2#</cfoutput>)</th></cfif>
				</tr>
			</thead>
				<cfset gt_total = 0>
				<cfset all_total = 0>
				<cfset gt_other_total = 0>
				<cfset all_other_total = 0>
				<cfset NetTotal_ = 0>
				<cfset NetTotal_Page = 0>
				<cfset NetTotal_Other = 0>
				<cfset NetTotal_Page_Other = 0>
				<cfif get_product.recordcount>
					<cfset product_id_list = "">
					<cfset spect_id_list = "">
					<cfset product_id_list_page = "">
					<cfset spect_id_list_page = "">
					<cfoutput query="get_product" >
						<cfif Len(product_id) and not ListFind(product_id_list,product_id,',')>
							<cfset product_id_list = ListAppend(product_id_list,product_id,',')>
						</cfif>
						<cfif isdefined("spect_var_id") and Len(spect_var_id) and not ListFind(spect_id_list,'#product_id#;#spect_var_id#',',')>
							<cfset spect_id_list = ListAppend(spect_id_list,'#product_id#;#spect_var_id#',',')>
						</cfif>
					</cfoutput>
					<cfif ListLen(product_id_list) and ListFind("6,7",attributes.inventory_calc_type,",")>
						<cfset product_id_list = ListSort(product_id_list,'numeric','asc',',')>
						<cfquery name="Get_Price_Standart" datasource="#dsn3#">
							SELECT
								MAX(PRICE) AS PRICE,
								PRODUCT_ID,
								MONEY
							FROM
								PRICE_STANDART
							WHERE
								PRODUCT_ID IN (#product_id_list#) AND
								<cfif attributes.inventory_calc_type eq 6>
									PURCHASESALES = 0 AND
								<cfelse>
									PURCHASESALES = 1 AND
								</cfif>
								PRICESTANDART_STATUS = 1
							GROUP BY
								PRODUCT_ID,
								MONEY
							ORDER BY
								PRODUCT_ID
						</cfquery>
						<cfset product_id_list = ValueList(Get_Price_Standart.Product_Id,',')>
					<cfelseif ListLen(spect_id_list) and ListFind("3",attributes.inventory_calc_type,",")>
						<cfset spect_id_list = ListSort(spect_id_list,'text','asc',',')>
						<cfquery name="Get_Price_Standart" datasource="#dsn3#">
							SELECT
								PRICE,
								PRICE_OTHER,
								CAST(PRODUCT_ID AS NVARCHAR(6)) + '_' + CAST(ISNULL(SPECT_MAIN_ID,0) AS NVARCHAR(6)) PRODUCT_SPECT
							FROM
								(
									SELECT
										PURCHASE_NET_SYSTEM_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PRICE,
										PURCHASE_NET_SYSTEM_2_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PRICE_OTHER,
										PRODUCT_ID,
										SPECT_MAIN_ID
									FROM
										PRODUCT_COST
									WHERE
										CAST(PRODUCT_ID AS NVARCHAR(6)) + ';' + CAST(ISNULL(SPECT_MAIN_ID,0) AS NVARCHAR(6)) IN ('#replace(spect_id_list,",","','","all")#')
										AND PRODUCT_COST_ID = 
										(
											SELECT 
												TOP 1 PRODUCT_COST_ID 
											FROM 
												PRODUCT_COST PC
											WHERE
												PC.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID AND
												ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) AND
												PC.START_DATE <= #CreateODBCDateTime(dateadd('d',1,attributes.cost_date))#
											ORDER BY
												PC.START_DATE DESC, PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC
										)																
								)PC
							ORDER BY
								PRODUCT_SPECT
						</cfquery>
						<cfset product_id_list = ValueList(Get_Price_Standart.Product_Spect,',')>
					<cfelseif not isdefined("spect_var_id") and ListLen(product_id_list)>
						<cfset product_id_list = ListSort(product_id_list,'numeric','asc',',')>
						<cfquery name="Get_Price_Standart" datasource="#dsn3#">
							SELECT
								PRICE,
								PRICE_OTHER,
								PRODUCT_ID PRODUCT_SPECT
							FROM
								(
									SELECT
										PURCHASE_NET_SYSTEM_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PRICE,
										PURCHASE_NET_SYSTEM_2_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PRICE_OTHER,
										PRODUCT_ID,
										SPECT_MAIN_ID
									FROM
										PRODUCT_COST
									WHERE
										PRODUCT_COST.PRODUCT_ID IN (#product_id_list#) AND
										PRODUCT_COST_ID = 
										(
											SELECT 
												TOP 1 PRODUCT_COST_ID 
											FROM 
												PRODUCT_COST PC
											WHERE
												PC.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID AND
												ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) AND
												PC.START_DATE <= #CreateODBCDateTime(dateadd('d',1,attributes.cost_date))#
											ORDER BY
												PC.START_DATE DESC, PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC
										)																
								)PC
							ORDER BY
								PRODUCT_SPECT
						</cfquery>
						<cfset product_id_list = ValueList(Get_Price_Standart.Product_Spect,',')>
					</cfif>
					<cfif attributes.page neq 1>
						<!--- Genel Toplam Icin (Sayfalama- Satir Toplamlari) --->
						<cfoutput query="get_product" >
							<cfif Len(product_id) and not ListFind(product_id_list_page,product_id,',')>
								<cfset product_id_list_page = ListAppend(product_id_list_page,product_id,',')>
							</cfif>
							<cfif isdefined("spect_var_id") and Len(spect_var_id) and not ListFind(spect_id_list_page,'#product_id#;#spect_var_id#',',')>
								<cfset spect_id_list_page = ListAppend(spect_id_list_page,'#product_id#;#spect_var_id#',',')>
							</cfif>
						</cfoutput>
						<cfif ListLen(product_id_list_page) and ListFind("6,7",attributes.inventory_calc_type,",")>
							<cfset product_id_list_page = ListSort(product_id_list_page,'numeric','asc',',')>
							<cfquery name="Get_Price_Standart_Page" datasource="#dsn3#">
								SELECT
									MAX(PRICE) AS PRICE,
									PRODUCT_ID,
									MONEY
								FROM
									PRICE_STANDART
								WHERE
									PRODUCT_ID IN (#product_id_list_page#) AND
									<cfif attributes.inventory_calc_type eq 6>
										PURCHASESALES = 0 AND
									<cfelse>
										PURCHASESALES = 1 AND
									</cfif>
									PRICESTANDART_STATUS = 1
								GROUP BY
									PRODUCT_ID,
									MONEY
								ORDER BY
									PRODUCT_ID
							</cfquery>
							<cfset product_id_list_page = ValueList(Get_Price_Standart_Page.Product_Id,',')>
						<cfelseif ListLen(spect_id_list_page) and ListFind("3",attributes.inventory_calc_type,",")>
							<cfset spect_id_list_page = ListSort(spect_id_list_page,'text','asc',',')>
							<cfquery name="Get_Price_Standart_Page" datasource="#dsn3#">
								SELECT
									PRICE,
									PRICE_OTHER,
									CAST(PRODUCT_ID AS NVARCHAR(6)) + '_' + CAST(ISNULL(SPECT_MAIN_ID,0) AS NVARCHAR(6)) PRODUCT_SPECT
								FROM
									(
										SELECT
											PURCHASE_NET_SYSTEM_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PRICE,
											PURCHASE_NET_SYSTEM_2_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PRICE_OTHER,
											PRODUCT_ID,
											SPECT_MAIN_ID
										FROM
											PRODUCT_COST
										WHERE
											CAST(PRODUCT_ID AS NVARCHAR(6)) + ';' + CAST(ISNULL(SPECT_MAIN_ID,0) AS NVARCHAR(6)) IN ('#replace(spect_id_list_page,",","','","all")#')
											AND PRODUCT_COST_ID = 
											(
												SELECT 
													TOP 1 PRODUCT_COST_ID 
												FROM 
													PRODUCT_COST PC
												WHERE
													PC.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID AND
													ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) AND
													PC.START_DATE <= #CreateODBCDateTime(dateadd('d',1,attributes.cost_date))#
												ORDER BY
													PC.START_DATE DESC, PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC
											)																
									)PC
								ORDER BY
									PRODUCT_SPECT
							</cfquery>
							<cfset product_id_list_page = ValueList(Get_Price_Standart_Page.Product_Spect,',')>
						<cfelseif not isdefined("spect_var_id") and ListLen(product_id_list_page)>
							<cfset product_id_list_page = ListSort(product_id_list_page,'text','asc',',')>
							<cfquery name="Get_Price_Standart_Page" datasource="#dsn3#">
								SELECT
									PRICE,
									PRICE_OTHER,
									PRODUCT_ID PRODUCT_SPECT
								FROM
									(
										SELECT
											PURCHASE_NET_SYSTEM_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PRICE,
											PURCHASE_NET_SYSTEM_2_ALL+ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PRICE_OTHER,
											PRODUCT_ID,
											SPECT_MAIN_ID
										FROM
											PRODUCT_COST
										WHERE
											PRODUCT_COST.PRODUCT_ID IN (#product_id_list_page#)
											AND PRODUCT_COST_ID = 
											(
												SELECT 
													TOP 1 PRODUCT_COST_ID 
												FROM 
													PRODUCT_COST PC
												WHERE
													PC.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID AND
													ISNULL(PC.SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) AND
													PC.START_DATE <= #CreateODBCDateTime(dateadd('d',1,attributes.cost_date))#
												ORDER BY
													PC.START_DATE DESC, PC.RECORD_DATE DESC,PC.PRODUCT_COST_ID DESC
											)																
									)PC
								ORDER BY
									PRODUCT_SPECT
							</cfquery>
							<cfset product_id_list_page = ValueList(Get_Price_Standart_Page.Product_Spect,',')>
						</cfif>
						<cfoutput query="get_product" maxrows="#attributes.startrow-1#">
							<cfif ListFind("6,7",attributes.inventory_calc_type,",") and ListFind(product_id_list_page,product_id,',')>
								<cfset NetTotal_Page = NetTotal_Page + wrk_round(Get_Price_Standart_Page.Price[ListFind(product_id_list_page,product_id,',')] * total_stk,2)>
								<cfset NetTotal_Page_Other = 0>
							<cfelseif ListFind("3",attributes.inventory_calc_type,",")>
								<cfif isdefined("spect_var_id")>
									<cfset new_product_page = product_id & '_' & spect_var_id>
								<cfelse>
									<cfset new_product_page = product_id>
								</cfif>
								<cfif ListFind(product_id_list_page,new_product_page,',')>
									<cfset NetTotal_Page = NetTotal_Page + wrk_round(Get_Price_Standart_Page.Price[ListFind(product_id_list_page,new_product_page,',')] * total_stk,2)>
									<cfset NetTotal_Page_Other = NetTotal_Page_Other + wrk_round(Get_Price_Standart_Page.Price_Other[ListFind(product_id_list_page,new_product_page,',')] * total_stk,2)>
								</cfif>
							</cfif>
						</cfoutput>
						<!--- //Genel Toplam Icin --->
					</cfif>
					<tbody>
						<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif ListFind("6,7",attributes.inventory_calc_type,",") and ListFind(product_id_list,product_id,',')>
								<cfset NetTotal_ = wrk_round(Get_Price_Standart.Price[ListFind(product_id_list,product_id,',')] * total_stk,2)>
								<cfset NetTotal_Other = 0>
							<cfelseif ListFind("3",attributes.inventory_calc_type,",")>
								<cfif isdefined("spect_var_id")>
									<cfset new_product = product_id & '_' & spect_var_id>
								<cfelse>
									<cfset new_product = product_id>
								</cfif>
								<cfif ListFind(product_id_list,new_product,',')>
									<cfset NetTotal_ = wrk_round(Get_Price_Standart.Price[ListFind(product_id_list,new_product,',')] * total_stk,2)>
									<cfset NetTotal_Other = wrk_round(Get_Price_Standart.Price_Other[ListFind(product_id_list,new_product,',')] * total_stk,2)>
								<cfelse>
									<cfset NetTotal_ = 0>
									<cfset NetTotal_Other = 0>
								</cfif>
							</cfif>
							<cfset gt_total = gt_total + wrk_round(NetTotal_)>
							<cfset gt_other_total = gt_other_total + wrk_round(NetTotal_Other)>
							<tr> 
								<td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product.product_id#" class="tableyazi">#stock_code#</a></td>
								<td style="mso-number-format:'\@'">#barcod#</td>
								<td>#product_name#<cfif len(property) and property neq "-">- #property#</cfif><cfif isdefined("spect_var_id") and Len(spect_var_id) and spect_var_id neq 0> -#spect_var_id#</cfif></td>
								<cfif attributes.list_type eq 1><td><cfif SPECT_VAR_ID gt 0>#SPECT_VAR_ID#</cfif></td></cfif>
								<td align="right" style="text-align:right;"><cfif total_stk lt 0><font color="ff0000">#amountformat(total_stk)#</font><cfelse>#amountformat(total_stk)#</cfif></td>
								<td>#get_product.main_unit#</td>
								<td align="right" style="text-align:right;" <cfif total_stk lt 0>style="color:FF0000;"</cfif>>#TLFormat(NetTotal_)#</td>
								<cfif ListFind("3",attributes.inventory_calc_type,",") and (isdefined("attributes.rate2_info") and attributes.rate2_info eq 1)><td align="right" style="text-align:right;" <cfif total_stk lt 0>style="color:FF0000;"</cfif>>#TLFormat(NetTotal_Other)#</td></cfif>
							</tr>
						</cfoutput>
					</tbody>
					<cfset all_total = all_total + gt_total + NetTotal_Page>
					<cfset all_other_total = all_other_total + gt_other_total + NetTotal_Page_Other>
					<cfset colspan_1 = 6>
					<cfif attributes.list_type eq 1><cfset colspan_1 = colspan_1 + 1></cfif>
					<cfset colspan_2 = 5>
					<cfif attributes.list_type eq 1><cfset colspan_2 = colspan_2 + 1></cfif>
					<cfif attributes.inventory_calc_type neq 6>
						<tfoot>
							<tr> 
								<td colspan="<cfoutput>#colspan_1#</cfoutput>" class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(gt_total)# #session.ep.money#</cfoutput></td>
								<cfif ListFind("3",attributes.inventory_calc_type,",") and (isdefined("attributes.rate2_info") and attributes.rate2_info eq 1)><td height="20" align="right" class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(gt_other_total)# #session.ep.money2#</cfoutput></td></cfif>
							</tr>
							<tr>
								<td colspan="<cfoutput>#colspan_2#</cfoutput>" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;<cfoutput>#TLFormat(all_total)# #session.ep.money#</cfoutput></td>
								<cfif ListFind("3",attributes.inventory_calc_type,",") and (isdefined("attributes.rate2_info") and attributes.rate2_info eq 1)><td align="right" class="txtbold" style="text-align:right;">&nbsp;<cfoutput>#TLFormat(all_other_total)# #session.ep.money2#</cfoutput></td></cfif>
							</tr>
						</tfoot>
					</cfif>
				<cfelse>
					<tbody>
						<tr> 
							<td colspan="6"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
					</tbody>
				</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "stock.list_stock_cost&type=stocks&is_form_submitted=1">
			<cfif Len(attributes.keyword)><cfset adres = "#adres#&keyword=#attributes.keyword#"></cfif>
			<cfif Len(attributes.inventory_calc_type)><cfset adres = "#adres#&inventory_calc_type=#attributes.inventory_calc_type#"></cfif>
			<cfif Len(attributes.department_id)><cfset adres = "#adres#&department_id=#attributes.department_id#"></cfif>
			<cfif Len(attributes.is_zero_stock)><cfset adres = "#adres#&is_zero_stock=#attributes.is_zero_stock#"></cfif>
			<cfif Len(attributes.cost_date)><cfset adres = "#adres#&cost_date=#DateFormat(attributes.cost_date,dateformat_style)#"></cfif>
			<cfif Len(attributes.list_type)><cfset adres = "#adres#&list_type=#attributes.list_type#"></cfif>
			<cfif Len(attributes.sort_type)><cfset adres = "#adres#&sort_type=#attributes.sort_type#"></cfif>
			<cfif Len(attributes.rate2_info)><cfset adres = "#adres#&rate2_info=#attributes.rate2_info#"></cfif>
			<cfif Len(attributes.company) and Len(attributes.company_id)>
				<cfset adres = "#adres#&company=#attributes.company#&company_id=#attributes.company_id#">
			</cfif>
			<cfif Len(attributes.employee) and Len(attributes.employee_id)>
				<cfset adres = "#adres#&employee=#attributes.employee#&employee_id=#attributes.employee_id#">
			</cfif>
			<cfif Len(attributes.search_product_catid) and Len(attributes.product_cat)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#&search_product_catid=#attributes.search_product_catid#">
			</cfif>
			<cfif isdefined("attributes.product_id") and Len(attributes.product_id)>
				<cfset adres = "#adres#&product_id=#attributes.product_id#">
			</cfif>
			<cfif isdefined("attributes.product_name") and Len(attributes.product_name)>
				<cfset adres = "#adres#&product_name=#attributes.product_name#">
			</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
