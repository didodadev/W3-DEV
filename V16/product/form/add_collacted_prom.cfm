<cfparam name="attributes.product_id" default="">
<cfquery name="get_price_cats" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<cfquery name="get_camp_info" datasource="#dsn3#">
		SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
	<cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
	<cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
	<cfset camp_id = get_camp_info.camp_id>
	<cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,'dd/mm/yyyy')#-#dateformat(camp_finish,'dd/mm/yyyy')#)'>
<cfelse>
	<cfset camp_start = ''>
	<cfset camp_finish = ''>
	<cfset camp_id = ''>
	<cfset camp_head = ''>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37642.Toplu Promosyon Ekle'></cfsavecontent>
<cfset pageHead= #message#>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_prom" method="post" action="#request.self#?fuseaction=product.emptypopup_add_collacted_prom">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-prom_status">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="prom_status" id="prom_status">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="camp_id" id="camp_id" value="<cfif len(camp_id)><cfoutput>#camp_id#</cfoutput></cfif>">
								<input type="text" name="camp_name" id="camp_name" value="<cfif len(camp_head)><cfoutput>#camp_head#</cfoutput></cfif>" style="width:200px;">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=add_prom.camp_id&field_name=add_prom.camp_name','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-prom_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="prom_detail" id="prom_detail" style="width:200px;height:45px;"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</div>
			</cf_box_footer>
			<cf_grid_list id="table1" name="table1" class="detail_basket_list">
				
				<cf_basket id="collected_prom_bask_"><thead>
					<tr>
						<th width="20" >&nbsp;</th>
						<th width="145" >&nbsp;</th>
						<th><input type="text" name="prom_head" id="prom_head" style="width:120px;" maxlength="100" value="" onkeyup="order_copy(this.name);"></th>
						<th><select name="price_cat" id="price_cat" style="width:200px;" onchange="order_copy(this.name);">
								<option value="-2" selected><cf_get_lang dictionary_id="58721.Standart Satış"></option>
								<cfoutput query="get_price_cats">
									<option value="#price_catid#">#price_cat#</option>
								</cfoutput>
							</select>
						</th>
						<th width="100">
							<div class="form-group">
								<div class="input-group"><input type="text" name="start_date" id="start_date" maxlength="10" style="width:100px;" value="" onblur="order_copy(this.name);">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date" call_function="copy_startdate"></span>
								</div>
							</div>
						</th>
						<th width="100" >
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="finish_date" id="finish_date" class="text" maxlength="10" style="width:100px;" value="" onblur="order_copy(this.name);">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" call_function="copy_finishdate"></span>
								</div>
							</div>
						</th>
						<th><input type="text" style="text-align:right;width:60px;" name="amount" id="amount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="width:70px;"></th>
						<th  width="160"  nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="free_product_id" id="free_product_id" value="" onkeyup="order_copy(this.name);">
									<input type="hidden" name="free_stock_id" id="free_stock_id" value="" onkeyup="order_copy(this.name);">
									<input type="text" name="free_product_name" id="free_product_name" value="" onfocus="order_copy(this.name);">
									<span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_prom.free_stock_id&field_name=add_prom.free_product_name&product_id=add_prom.free_product_id&field_calistir=1');"></span>
								</div>
							</div>
						</th>
						<th><input type="text" style="text-align:right;width:60px;" name="free_amount" id="free_amount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);" style="text-align:right;"></th>
						<th><input type="text" style="text-align:right;width:70px;" name="invoice_value" id="invoice_value" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="text-align:right;"></th>
						<th><input type="text" style="text-align:right;width:70px;" name="cost_value" id="cost_value" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="text-align:right;"></th>
						<th><input type="text" style="text-align:right;width:70px;" name="percent_discount" id="percent_discount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="text-align:right;"></th>
						<th><input type="text" style="text-align:right;width:70px;" name="value_discount" id="value_discount" value="" onkeyup="FormatCurrency(this,event);order_copy(this.name);"  style="text-align:right;"></th>
					</tr>
					<tr>
						<th style="text-align:center;">
							<input type="hidden" name="record_num" id="record_num" value="0">
							<a style="cursor:pointer" onclick="pencere_ac_product();" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>"><i class="fa fa-plus"></i></a>
						</th>
						<th width="140" nowrap><cf_get_lang dictionary_id='57657.Ürün'> *</th>
							<th width="120" nowrap><cf_get_lang dictionary_id='37592.Promosyon Başlığı'> *</th>
							<th width="150" nowrap><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
							<th  width="100" nowrap><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
							<th width="100" nowrap><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
							<th width="70" nowrap><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="160" nowrap><cf_get_lang dictionary_id='37492.Anında Ürün Kazan'></th>
							<th width="70" nowrap><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="85" nowrap><cf_get_lang dictionary_id='37643.Fatura Fiyatı'></th>
							<th width="85" nowrap><cf_get_lang dictionary_id='58258.Maliyet'></th>
							<th width="85" nowrap>%<cf_get_lang dictionary_id='58560.İndirim'></th>
							<th width="85" nowrap><cf_get_lang dictionary_id='37598.Tutar İndirimi'></th>
					</tr>
				</thead>
				<tbody></tbody>
				
			</cf_basket>
			</cf_grid_list>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		
	function kontrol()
	{
		for(r=1;r<=add_prom.record_num.value;r++)
		{
			if(eval("document.add_prom.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_prom.product_id"+r).value == "" || eval("document.add_prom.product_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='57725.Lütfen Ürün Seçiniz'> !");
					return false;
				}
				if (eval("document.add_prom.prom_head"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='37831.Lütfen Promosyon Başlığı Giriniz'> !");
					return false;
				}
				if (eval("document.add_prom.start_date"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='57738.Lütfen Başlangıç Tarihi Giriniz '>!");
					return false;
				}
				if (eval("document.add_prom.finish_date"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='57739.Lütfen Bitiş Tarihi Giriniz'> !");
					return false;
				}			
				if (eval("document.add_prom.amount"+r).value == 0)
				{ 
					alert ("<cf_get_lang dictionary_id='37413.Lütfen Miktar Giriniz'>!");
					return false;
				}
				if(eval("document.add_prom.percent_discount"+r).value == 0 && eval("document.add_prom.value_discount"+r).value == 0)
				{
					if (eval("document.add_prom.free_product_id"+r).value == "" || eval("document.add_prom.free_product_name"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id ='37832.Lütfen Promosyon Ürünü Seçiniz veya İndirim Giriniz'>!");
						return false;
					}
					if (eval("document.add_prom.free_amount"+r).value == 0)
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
	function sil(sy)
	{
		var my_element=eval("add_prom.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}

	function copy_row(no)
	{
		row_count = document.add_prom.record_num.value;
		
		stock_id = eval('add_prom.stock_id' + no).value;
		product_id = eval('add_prom.product_id' + no).value;
		product_name = eval('add_prom.product_name' + no).value;
		prom_head = eval('add_prom.prom_head' + no).value;
		price_cat = eval('add_prom.price_cat' + no).value;
		start_date = eval('add_prom.start_date' + no).value;
		finish_date = eval('add_prom.finish_date' + no).value;
		amount = eval('add_prom.amount' + no).value;
		free_stock_id = eval('add_prom.free_stock_id' + no).value;
		free_product_id = eval('add_prom.free_product_id' + no).value;
		free_product_name = eval('add_prom.free_product_name' + no).value;
		free_amount = eval('add_prom.free_amount' + no).value;
		invoice_value = eval('add_prom.invoice_value' + no).value;
		cost_value = eval('add_prom.cost_value' + no).value;
		percent_discount = eval('add_prom.percent_discount' + no).value;
		value_discount = eval('add_prom.value_discount' + no).value;
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.add_prom.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');" title="<cf_get_lang dictionary_id="58971.Satır Sil">"><i class="fa fa-minus" ></i></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="product_id' + row_count +'" value="' + product_id + '"><input type="hidden" name="stock_id' + row_count +'" value="' + stock_id + '"><input type="text"  name="product_name' + row_count +'" value="' + product_name + '"><span class="input-group-addon icon-ellipsis"  onclick="pencere_ac_product_detail('+ row_count +');" align="absmiddle" ></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
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
		
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="start_date' + row_count +'" maxlength="10"   value="'+start_date+'"><span class="input-group-addon" id="start_date' + row_count + '_td"></span></div></div>';
		wrk_date_image('start_date' + row_count);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="finish_date' + row_count +'" maxlength="10"  value="'+finish_date+'"><span class="input-group-addon" id="finish_date' + row_count + '_td"></span></div></div>';
		wrk_date_image('finish_date' + row_count);
		

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text"  name="amount' + row_count +'" value="' + amount + '" onkeyup="return(FormatCurrency(this,event));" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';" style="text-align:right;width:60px;"">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="free_product_id' + row_count +'" value="' + free_product_id + '"><input type="hidden" name="free_stock_id' + row_count +'" value="' + free_stock_id + '"> <input type="text" style="width:140px;" name="free_product_name' + row_count +'" value="' + free_product_name + '"><span class="input-group-addon icon-ellipsis"  onclick="pencere_ac_free_product('+ row_count +');" align="absmiddle" ></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="free_amount' + row_count +'" value="' + free_amount + '" onkeyup="return(FormatCurrency(this,event));"  onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';" style="text-align:right;width:60px;"">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="invoice_value' + row_count +'" value="' + invoice_value + '" onkeyup="return(FormatCurrency(this,event));"  onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';" style="text-align:right;width:70px;"">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_value' + row_count +'" value="' + cost_value + '" onkeyup="return(FormatCurrency(this,event));" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';" style="text-align:right;width:70px;"">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="percent_discount' + row_count +'" value="' + percent_discount + '" onkeyup="return(FormatCurrency(this,event));"  onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';" style="text-align:right;width:70px;"">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value_discount' + row_count +'" value="' + value_discount + '" onkeyup="return(FormatCurrency(this,event));"  onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';" style="text-align:right;width:70px;"">';
	}
	function pencere_ac_product_detail(no)
	{
		pid = eval('add_prom.product_id'+no).value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pid,'list');
	}
	//ust kisimdan secilen- girilen degerlerin satirlara kopyalanmasini saglar
	function order_copy(nesne)
	{
		if(document.add_prom.record_num.value > 0)
		{
			var number = document.add_prom.record_num.value;
			for(var k=1;k<=number;k++)
				eval("document.add_prom."+nesne+k).value = eval("document.add_prom."+nesne).value;
				
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
	
	function pencere_ac_product(no)
	{
		if(document.add_prom.camp_id.value!='')
			camp_ = '&camp_id='+document.add_prom.camp_id.value;
		else
			camp_ = '';
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&is_collacted_prom=1&is_form_submitted=1</cfoutput>&record_num='+document.add_prom.record_num.value + camp_,'list');
	}	
	
	function pencere_ac_free_product(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_prom.free_stock_id' + no +'&field_name=add_prom.free_product_name' + no +'&product_id=add_prom.free_product_id' + no +'&field_calistir=1','list');
	}
	
	function add_free_product(no)
	{
		
		eval('add_prom.free_stock_id' + no).value = eval('add_prom.stock_id' + no).value;
		eval('add_prom.free_product_id' + no).value = eval('add_prom.product_id' + no).value;
		eval('add_prom.free_product_name' + no).value = eval('add_prom.product_name' + no).value;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=add_prom.record_num.value;r++)
		{
			deger_miktar = eval("document.add_prom.amount"+r);
			deger_pro_miktar= eval("document.add_prom.free_amount"+r);
			deger_value = eval("document.add_prom.invoice_value"+r);
			deger_cost_value = eval("document.add_prom.cost_value"+r);
			deger_percent_discount = eval("document.add_prom.percent_discount"+r);
			deger_value_discount = eval("document.add_prom.value_discount"+r);
			
			deger_miktar.value = filterNum(deger_miktar.value);
			deger_pro_miktar.value = filterNum(deger_pro_miktar.value);
			deger_value.value = filterNum(deger_value.value);
			deger_cost_value.value = filterNum(deger_cost_value.value);
			deger_percent_discount.value = filterNum(deger_percent_discount.value);
			deger_value_discount.value = filterNum(deger_value_discount.value);
		}
	}
</script>
