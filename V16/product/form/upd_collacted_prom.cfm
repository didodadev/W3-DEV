<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium,is_promotion,is_action_,is_camp_operation_rows,is_participation_time'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_upd_collacted_prom">
<cfquery name="get_price_cats" datasource="#DSN3#">
	SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>
<cfquery name="get_all_proms" datasource="#dsn3#">
	SELECT 
		PR.*,
		P.PROM_ID,
		P.CAMP_ID,
		P.PROM_NO,
		P.STOCK_ID,
		P.PRODUCT_ID,
		P.PROM_HEAD,
		P.PRICE_CATID PRICE_CAT_ID,
		P.STARTDATE,
		P.FINISHDATE,
		P.LIMIT_TYPE,
		P.LIMIT_VALUE,
		P.FREE_STOCK_ID,
		P.FREE_STOCK_AMOUNT,
		P.FREE_STOCK_PRICE,
		P.AMOUNT_1,
		P.DISCOUNT,
		P.AMOUNT_DISCOUNT
	FROM
		PROMOTIONS_RELATION PR,
		PROMOTIONS P
	WHERE 
		PR.PROM_RELATION_ID = P.PROM_RELATION_ID
		AND PR.PROM_RELATION_ID = #attributes.prom_rel_id#
</cfquery>
<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
	SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_FINISHDATE > #now()# ORDER BY CAMP_HEAD
</cfquery>
<cfset pageHead = #getLang('main',645)# & " " & #getLang('product',232)# & " " & #getLang('main',52)# & " : " & #attributes.prom_rel_id# > 
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
	<cf_box>
		<cfform name="upd_prom" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_collacted_prom">	
			<input type="hidden" name="prom_rel_id" id="prom_rel_id" value="<cfoutput>#attributes.prom_rel_id#</cfoutput>">
			<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delCollacted">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-prom_status">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="prom_status" id="prom_status" <cfif get_all_proms.prom_status eq 1>checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='1' select_value='#get_all_proms.process_stage#'>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_all_proms.camp_id)>
									<cfquery name="get_camp_name" datasource="#dsn3#">
										SELECT CAMP_HEAD,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_all_proms.camp_id#
									</cfquery>
									<cfset camp_start_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_startdate),'dd/mm/yyyy')>
									<cfset camp_finish_date=dateformat(date_add("H",session.ep.time_zone,get_camp_name.camp_finishdate),'dd/mm/yyyy')>
								</cfif>
								<input type="hidden" name="camp_id" id="camp_id" value="<cfif len(get_all_proms.camp_id)><cfoutput>#get_all_proms.camp_id#</cfoutput></cfif>">
								<input type="text" name="camp_name" id="camp_name" value="<cfif len(get_all_proms.camp_id)><cfoutput>#get_camp_name.camp_head#(#camp_start_date#-#camp_finish_date#)</cfoutput></cfif>" style="width:200px;">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=upd_prom.camp_id&field_name=upd_prom.camp_name','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-prom_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="prom_detail" id="prom_detail" style="width:200px;height:45px;"><cfoutput>#get_all_proms.prom_detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6 col-xs-12">
					<cf_record_info query_name="get_all_proms">
				</div>
				<div class="col col-6 col-xs-12">
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_collacted_prom&prom_rel_id=#attributes.prom_rel_id#' add_function='kontrol()'>
				</div>
			</cf_box_footer>
			<div class="row">
				<div class="col col-12 uniqueRow">
					<cf_basket id="cellacted_prom_bask_">
						<cf_grid_list name="table1" id="table1" class="detail_basket_list">
							<thead>
								<tr>
									<th width="20">&nbsp;</th>
									<th width="145">&nbsp;</th>
									<th><input type="text" name="prom_head" id="prom_head" style="width:120px;" maxlength="100" value="" onkeyup="order_copy(this.name);"></th>
									<th><select name="price_cat" id="price_cat" style="width:200px;" onchange="order_copy(this.name);">
											<option value="-2" selected><cf_get_lang dictionary_id="58721.Standart Satış"></option>
											<cfoutput query="get_price_cats">
												<option value="#price_catid#">#price_cat#</option>
											</cfoutput>
										</select>
									</th>
									<th nowrap="nowrap"  width="100">
										<div class="form-group">
											<div class="input-group">
											<input type="text" name="start_date" id="start_date" maxlength="10" style="width:80px;" value="" onblur="order_copy(this.name);">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date" call_function="copy_startdate"></span>
										</div>
									</div>
									</th>
									<th nowrap="nowrap"  width="100">
										<div class="form-group">
											<div class="input-group">
												<input type="text" name="finish_date" id="finish_date" class="text" maxlength="10" style="width:80px;" value="" onblur="order_copy(this.name);">
												<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" call_function="copy_finishdate"></span>
											</div>
										</div>
									</th>
									<th width="50"> <input type="text" style="text-align:right;width:60px;" name="amount" id="amount"  value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="width:70px;"></th>
									<th width="120">
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="free_product_id" id="free_product_id" value="" onkeyup="order_copy(this.name);">
												<input type="hidden" name="free_stock_id" id="free_stock_id" value="" onkeyup="order_copy(this.name);">
												<input type="text" style="width:138px;" name="free_product_name" id="free_product_name" value="" onkeyup="order_copy(this.name);" onfocus="order_copy(this.name);">
												<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_prom.free_stock_id&field_name=upd_prom.free_product_name&call_function=deneme&product_id=upd_prom.free_product_id&field_calistir=1','list');"></span>
											</div>
										</div>
									</th>
									<th style="text-align:right;"><input type="text" name="free_amount" id="free_amount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="text-align:right;width:50px;"></th>
									<th><input type="text" style="text-align:right;width:60px;" name="invoice_value" id="invoice_value" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"   style="text-align:right;width:60px;"></th>
									<th><input type="text" style="text-align:right;width:70px;" name="cost_value" id="cost_value" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="text-align:right;width:50px;"></th>
									<th><input type="text" style="text-align:right;width:70px;" name="percent_discount" id="percent_discount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"   style="text-align:right;width:50px;"></th>
									<th><input type="text" style="text-align:right;width:70px;" name="value_discount" id="value_discount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"   style="text-align:right;width:50px;"></th>
								</tr>
								<tr>
									<th style="text-align:center;">
										<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_all_proms.recordcount#</cfoutput>">
										<a style="cursor:pointer" onclick="pencere_ac_product();" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>"><i class="fa fa-plus"></i></a>
									</th>
									<th width="150" nowrap><cf_get_lang dictionary_id='57657.Ürün'> *</th>
									<th width="120" nowrap><cf_get_lang dictionary_id='37592.Promosyon Başlığı'> *</th>
									<th width="100" nowrap><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
									<th width="92" nowrap><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
									<th width="90" nowrap><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
									<th width="70" nowrap><cf_get_lang dictionary_id='57635.Miktar'></th>
									<th width="140" nowrap><cf_get_lang dictionary_id='37492.Anında Ürün Kazan'></th>
									<th width="70" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
									<th width="85" nowrap><cf_get_lang dictionary_id ='37643.Fatura Fiyatı'></th>
									<th width="85" nowrap><cf_get_lang dictionary_id='58258.Maliyet'></th>
									<th width="85" nowrap>% <cf_get_lang dictionary_id ='58560.İndirim'></th>
									<th width="85" nowrap><cf_get_lang dictionary_id ='37598.Tutar İndirimi'></th>
								</tr>
							</thead>
							<tbody>
								<cfset stock_id_list=''>
								<cfset free_stock_id_list=''>
								<cfoutput query="get_all_proms">
									<cfif len(stock_id) and not listfind(stock_id_list,stock_id)>
									<cfset stock_id_list=listappend(stock_id_list,stock_id)>
									</cfif>
									<cfif len(free_stock_id) and not listfind(free_stock_id_list,free_stock_id)>
									<cfset free_stock_id_list=listappend(free_stock_id_list,free_stock_id)>
									</cfif>
								</cfoutput>
								<cfif len(stock_id_list)>
									<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
									<cfquery name="get_pro_name" datasource="#DSN3#">
										SELECT STOCK_ID,PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#stock_id_list#) ORDER BY STOCK_ID
									</cfquery>	
									<cfset stock_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.STOCK_ID,',')),'numeric','ASC',',')>
								</cfif>
								<cfif len(free_stock_id_list)>
									<cfset free_stock_id_list=listsort(free_stock_id_list,"numeric","ASC",",")>
									<cfquery name="get_free_pro_name" datasource="#DSN3#">
										SELECT STOCK_ID,PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#free_stock_id_list#) ORDER BY STOCK_ID
									</cfquery>	
									<cfset free_stock_id_list = listsort(listdeleteduplicates(valuelist(get_free_pro_name.STOCK_ID,',')),'numeric','ASC',',')>
								</cfif>
								<cfoutput query="get_all_proms">
									<tr id="frm_row#currentrow#">
										<td nowrap="nowrap">
											<input type="hidden" value="#prom_id#" name="prom_id#currentrow#" id="prom_id#currentrow#">
											<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
											<a href="javascript://" onClick="sil('#currentrow#');" title="<cf_get_lang dictionary_id='58971.Satır Sil'>"><i class="fa fa-minus" border="0"></i></a>
											<a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" value="#get_pro_name.product_id[listfind(stock_id_list,stock_id,',')]#" name="product_id#currentrow#" id="product_id#currentrow#">
											<input type="hidden" value="#stock_id#" name="stock_id#currentrow#" id="stock_id#currentrow#">
											<input type="text" value="#get_pro_name.product_name[listfind(stock_id_list,stock_id,',')]#" name="product_name#currentrow#" id="product_name#currentrow#" style="width:140px;">
											<a href="javascript://" onclick="pencere_ac_product_detail(#currentrow#);"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
										</td>
										<td>
											<input type="text" name="prom_head#currentrow#" id="prom_head#currentrow#" style="width:120px;" value="#prom_head#">
										</td>
										<cfset new_price_cat = price_cat_id>
										<td>
											<select name="price_cat#currentrow#" id="price_cat#currentrow#" style="width:200px;">
												<option value="-2" <cfif new_price_cat eq -2>selected</cfif>><cf_get_lang dictionary_id ='58721.Standart Satış'></option>
												<cfloop query="get_price_cats">
													<option value="#get_price_cats.price_catid#" <cfif get_price_cats.price_catid eq new_price_cat>selected</cfif>>#get_price_cats.price_cat#</option>
												</cfloop>
											</select>
										</td>
										<td nowrap="nowrap">
											<input type="text" name="start_date#currentrow#" id="start_date#currentrow#" style="width:65px;" value="#dateformat(startdate,'dd/mm/yyyy')#"><cf_wrk_date_image date_field="start_date#currentrow#">
										</td>
										<td nowrap="nowrap">
											<input type="text" name="finish_date#currentrow#" id="finish_date#currentrow#" style="width:65px;" value="#dateformat(finishdate,'dd/mm/yyyy')#"><cf_wrk_date_image date_field="finish_date#currentrow#">
										</td>
										<td nowrap="nowrap"  >
											<input type="text" style="text-align:right;width:60px;" name="amount#currentrow#" id="amount#currentrow#" style="width:100%;" value="#limit_value#" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 1;">
										</td>
										<td nowrap="nowrap">
											<input type="hidden" value="<cfif len(free_stock_id)>#get_free_pro_name.product_id[listfind(free_stock_id_list,free_stock_id,',')]#</cfif>" name="free_product_id#currentrow#" id="free_product_id#currentrow#">
											<input type="hidden" value="#free_stock_id#" name="free_stock_id#currentrow#" id="free_stock_id#currentrow#">
											<input type="text" value="<cfif len(free_stock_id)>#get_free_pro_name.product_name[listfind(free_stock_id_list,free_stock_id,',')]#</cfif>" name="free_product_name#currentrow#" id="free_product_name#currentrow#" style="width:140px;">
											<a href="javascript://" onclick="pencere_ac_free_product(#currentrow#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
										</td>
										<td nowrap="nowrap" style="text-align:right;">
											<input type="text" style="text-align:right;width:60px;" name="free_amount#currentrow#" id="free_amount#currentrow#" style="width:100%;" value="#free_stock_amount#" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 1;">
										</td>
										<td nowrap="nowrap">
											<input type="text" style="text-align:right;width:70px;" name="invoice_value#currentrow#" id="invoice_value#currentrow#" style="width:100%;" value="#Tlformat(free_stock_price)#" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;">
										</td>
										<td nowrap="nowrap">
											<input type="text" style="text-align:right;width:70px;" name="cost_value#currentrow#" id="cost_value#currentrow#" style="width:100%;" value="#Tlformat(amount_1)#" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;">
										</td>
										<td nowrap="nowrap">
											<input type="text" style="text-align:right;width:70px;" name="percent_discount#currentrow#" id="percent_discount#currentrow#" style="width:100%;" value="#Tlformat(discount)#" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;">
										</td>
										<td nowrap="nowrap">
											<input type="text" style="text-align:right;width:70px;"style="text-align:right;"style="text-align:right;"style="text-align:right;"style="text-align:right;"style="text-align:right;"style="text-align:right;" name="value_discount#currentrow#" id="value_discount#currentrow#" style="width:50px;" value="#Tlformat(amount_discount)#" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;">
										</td>
									</tr>
								</cfoutput>
							</tbody>
							</cf_grid_list>
					</cf_basket>
				</div>
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function deneme(){
		row_count = document.upd_prom.record_num.value;		
		for(r=1;r<=row_count;r++){
		<!---$('#free_product_name'+r).val($('#free_product_name').val());--->
		$( "input[name$='free_product_name"+r+"']").val($('#free_product_name').val());	
		}
	}
	function kontrol()
	{
		for(r=1;r<=upd_prom.record_num.value;r++)
		{
			if(eval("document.upd_prom.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.upd_prom.product_id"+r).value == "" || eval("document.upd_prom.product_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='57725.Lütfen Ürün Seçiniz'> !");
					return false;
				}
				if (eval("document.upd_prom.prom_head"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='37831.Lütfen Promosyon Başlığı Giriniz'> !");
					return false;
				}
				if ((eval("document.upd_prom.start_date"+r).value == ""))
				{ 
					alert ("<cf_get_lang dictionary_id ='57738.Lütfen Başlangıç Tarihi Giriniz'> !");
					return false;
				}
				if ((eval("document.upd_prom.finish_date"+r).value == ""))
				{ 
					alert ("<cf_get_lang dictionary_id ='57739.Lütfen Bitiş Tarihi Giriniz'> !");
					return false;
				}			
				if (eval("document.upd_prom.amount"+r).value == 0)
				{ 
					alert ("<cf_get_lang dictionary_id ='37413.Lütfen Miktar Giriniz'>!");
					return false;
				}
				if(eval("document.upd_prom.percent_discount"+r).value == 0 && eval("document.upd_prom.value_discount"+r).value == 0)
				{
					if (eval("document.upd_prom.free_product_id"+r).value == "" || eval("document.upd_prom.free_product_name"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id ='37857.Lütfen Promosyon Ürünü Seçiniz'> !");
						return false;
					}
					if (eval("document.upd_prom.free_amount"+r).value == 0)
					{ 
						alert ("<cf_get_lang dictionary_id ='37836.Lütfen Promosyon Miktarı Giriniz'>!");
						return false;
					}
				}
			}
		}
		if (record_exist == 0) 
			{
				alert("<cf_get_lang dictionary_id ='37833.Lütfen Promosyon Giriniz'>!");
				return false;
			}
		
		unformat_fields();
		return process_cat_control();
	}
	function unformat_fields()
	{
		for(r=1;r<=upd_prom.record_num.value;r++)
		{
			deger_miktar = eval("document.upd_prom.amount"+r);
			deger_pro_miktar= eval("document.upd_prom.free_amount"+r);
			deger_value = eval("document.upd_prom.invoice_value"+r);
			deger_cost_value = eval("document.upd_prom.cost_value"+r);
			deger_percent_discount = eval("document.upd_prom.percent_discount"+r);


			deger_value_discount = eval("document.upd_prom.value_discount"+r);
			deger_miktar.value = filterNum(deger_miktar.value);
			deger_pro_miktar.value = filterNum(deger_pro_miktar.value);
			deger_value.value = filterNum(deger_value.value);
			deger_cost_value.value = filterNum(deger_cost_value.value);
			deger_percent_discount.value = filterNum(deger_percent_discount.value);
			deger_value_discount.value = filterNum(deger_value_discount.value);
		}
	}
	
	function sil(sy)
	{
		var my_element=eval("upd_prom.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function copy_row(no)
	{
		row_count = document.upd_prom.record_num.value;
		
		stock_id = eval('upd_prom.stock_id' + no).value;
		product_id = eval('upd_prom.product_id' + no).value;
		product_name = eval('upd_prom.product_name' + no).value;
		prom_head = eval('upd_prom.prom_head' + no).value;
		price_cat = eval('upd_prom.price_cat' + no).value;
		start_date = eval('upd_prom.start_date' + no).value;
		finish_date = eval('upd_prom.finish_date' + no).value;
		amount = eval('upd_prom.amount' + no).value;
		free_stock_id = eval('upd_prom.free_stock_id' + no).value;
		free_product_id = eval('upd_prom.free_product_id' + no).value;
		free_product_name = eval('upd_prom.free_product_name' + no).value;
		free_amount = eval('upd_prom.free_amount' + no).value;
		invoice_value = eval('upd_prom.invoice_value' + no).value;
		cost_value = eval('upd_prom.cost_value' + no).value;
		percent_discount = eval('upd_prom.percent_discount' + no).value;
		value_discount = eval('upd_prom.value_discount' + no).value;
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.upd_prom.record_num.value=row_count;
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="hidden" value="0" name="prom_id' + row_count +'"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');" title="<cf_get_lang dictionary_id='58971.Satır Sil'>"><i class="fa fa-minus" border="0"></i></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" value="' + product_id + '"><input type="hidden" name="stock_id' + row_count +'" value="' + stock_id + '"><input type="text" style="width:140px;" name="product_name' + row_count +'" value="' + product_name + '"><a href="javascript://"> <img src="/images/plus_thin.gif" onclick="pencere_ac_product_detail('+ row_count +');" align="absmiddle" border="0"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="prom_head' + row_count +'" style="width:120px;" maxlength="100" value="' + prom_head + '">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		c = '<select name="price_cat' + row_count +'" style="width:200px;"><option value="-2" selected><cf_get_lang dictionary_id="58721.Standart Satış"></option>';
		<cfoutput query="get_price_cats">
		if('#price_catid#' == price_cat)
			c += '<option value="#price_catid#" selected>#price_cat#</option>';
		else
			c += '<option value="#price_catid#">#price_cat#</option>';
		</cfoutput>
		newCell.innerHTML = c+ '</select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","start_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="start_date' + row_count +'" maxlength="10" style="width:70px;" value="'+start_date+'">&nbsp;';
		wrk_date_image('start_date' + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","finish_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="finish_date' + row_count +'" maxlength="10" style="width:70px;" value="'+finish_date+'">&nbsp;';
		wrk_date_image('finish_date' + row_count);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="text-align:right;width:60px;" name="amount' + row_count +'" value="' + amount + '" onkeyup="return(FormatCurrency(this,event));" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';" style="width:100%;" >';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="free_product_id' + row_count +'" name="free_product_id' + row_count +'" value="' + free_product_id + '"><input type="hidden" id="free_stock_id' + row_count +'" name="free_stock_id' + row_count +'" value="' + free_stock_id + '"><input type="text" style="width:140px;" id="free_product_name' + row_count +'" name="free_product_name' + row_count +'" value="' + free_product_name + '">&nbsp;<a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_free_product('+ row_count +');" align="absmiddle" border="0"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="text-align:right;width:60px;" name="free_amount' + row_count +'" value="' + free_amount + '" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="text-align:right;width:70px;" name="invoice_value' + row_count +'" value="' + invoice_value + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="text-align:right;width:70px;" name="cost_value' + row_count +'" value="' + cost_value + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="text-align:right;width:70px;" name="percent_discount' + row_count +'" value="' + percent_discount + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="text-align:right;width:70px;" name="value_discount' + row_count +'" value="' + value_discount + '" onkeyup="return(FormatCurrency(this,event));" style="width:85px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
	}
	function pencere_ac_product(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_prom.stock_id' + no +'&field_name=upd_prom.product_name' + no +'&product_id=upd_prom.product_id' + no +'&field_calistir=1&run_function=add_free_product&run_function_param=' + no +'','list');
	}
	function pencere_ac_product_detail(no)
	{
		pid = eval('upd_prom.product_id'+no).value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pid,'list');
	}
	function pencere_ac_free_product(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_prom.free_stock_id' + no +'&field_name=upd_prom.free_product_name' + no +'&product_id=upd_prom.free_product_id' + no +'&field_calistir=1','list');
	}
	function add_free_product(no)
	{
		eval('upd_prom.free_stock_id' + no).value = eval('upd_prom.stock_id' + no).value;
		eval('upd_prom.free_product_id' + no).value = eval('upd_prom.product_id' + no).value;
		eval('upd_prom.free_product_name' + no).value = eval('upd_prom.product_name' + no).value;
	}
	function pencere_ac_product(no)
	{
		if(document.upd_prom.camp_id.value!='')
			camp_ = '&camp_id='+document.upd_prom.camp_id.value;
		else
			camp_ = '';
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&is_collacted_prom=1&is_form_submitted=1&prom_rel_id=#attributes.prom_rel_id#&record_num='+document.upd_prom.record_num.value+'</cfoutput>'+camp_,'list');
	}
	function order_copy(nesne)
	{
		if(document.upd_prom.record_num.value > 0)
		{
			var number = document.upd_prom.record_num.value;
			for(var k=1;k<=number;k++)
				eval("document.upd_prom."+nesne+k).value = eval("document.upd_prom."+nesne).value;
				
			return false;
		}
	}
	function copy_startdate()
	{
		order_copy('start_date');
	}
	function copy_finishdate()
	{
		order_copy('finish_date');
	}
</script>

