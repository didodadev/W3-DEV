<cf_papers paper_type="stock_fis">
<cf_get_lang_set module_name="stock">
<cf_xml_page_edit fuseact="stock.form_add_stock_exchange">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset system_paper_no = "">
	<cfset system_paper_no_add = "">
</cfif>
<cfscript>
xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
</cfscript>
<cf_catalystHeader>
<cfform name="add_virman" action="#request.self#?fuseaction=#fusebox.circuit#.empytpopup_add_stock_exchange" method="post">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cf_basket_form id="detail_stock_exchange">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>"><!--- islem yapılırken donemi kontrol etmek icin --->
			<input type="hidden" name="stock_record_num" id="stock_record_num" value="0">
				<!-- sil -->
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-exchange_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fiş No'> *</label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="exchange_no_" id="exchange_no_" value="<cfoutput>#system_paper_no#</cfoutput>" readonly>
								</div>
							</div>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='45630.İşlem Kategorisi'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process_cat slct_width="150">
								</div>
							</div>
							
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-giris_depo">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='45273.Giriş Depo'> *</label>
								<div class="col col-8 col-xs-12">
									<cf_wrkdepartmentlocation
										returnInputValue="location_id,department_name,department_id,branch_id"
										returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="department_name"
										fieldid="location_id"
										xml_all_depo = "#xml_all_depo_entry#"
										department_fieldId="department_id"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 1
										width="150">
								</div>
							</div>
							<div class="form-group" id="item-cikis_depo">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'> *</label>
								<div class="col col-8 col-xs-12">
									<cf_wrkdepartmentlocation
										returnInputValue="exit_location_id,exit_department_name,exit_department_id,branch_id"
										returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="exit_department_name"
										fieldid="exit_location_id"
										xml_all_depo = "#xml_all_depo_outer#"
										department_fldId="exit_department_id"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 2
										width="150">
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-process_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="process_date" maxlength="10" value="#dateformat(now(),dateformat_style)#"  validate="#validate_style#" required="yes" message="#getLang('','Son Ödeme Tarihi Girmelisiniz',53330)#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Acıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="detail" id="detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#getLang('','250 Karakterden Fazla Yazmayınız',56883)#</cfoutput>"></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons class="mb-2" add_function='control()'>
					</cf_box_footer>
				<!-- sil -->
			</cf_basket_form>
			<cf_basket id="detail_stock_exchange_bask">
				<cf_grid_list>
					<thead>
						<tr>
							<cfset clspn =10>
							<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
								<cfset clspn = clspn + 1>
							</cfif>
							<cfif isdefined('is_lot_no') and is_lot_no eq 1>
								<cfset clspn = clspn + 1>
							</cfif>
							<th colspan="<cfoutput>#clspn#</cfoutput>"><cf_get_lang dictionary_id ='45632.Çıkan Stok'></th>
							<th></th>
							<cfset clspn2 = 8>
							<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
								<cfset clspn2 = clspn2 + 1>
							</cfif>
							<cfif isdefined('is_lot_no') and is_lot_no eq 1>
								<cfset clspn2 = clspn2 + 1>
							</cfif>
							<th colspan="<cfoutput>#clspn2#</cfoutput>"><cf_get_lang dictionary_id ='45633.Giren Stok'></th>
						</tr>
						<tr>
							<th width="20"></th>
							<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id='57657.Ürün Adı'></th>
							<th><cf_get_lang dictionary_id='57647.Spec'></th>
							<th><cf_get_lang dictionary_id="57637.seri no"></th>
							<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
								<th><cf_get_lang dictionary_id='45539.Raf Kodu'></th>
							</cfif>
							<th><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th><cf_get_lang dictionary_id='57636.Birim'></th>
							<th>2.<cf_get_lang dictionary_id='57635.Miktar'></th>
							<th>2.<cf_get_lang dictionary_id='57636.Birim'></th>
							<cfif isdefined('is_lot_no') and is_lot_no eq 1>
								<th><cf_get_lang dictionary_id='45498.Lot No'></th>
							</cfif>
							<th width="20"></th>
							<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id='57657.Ürün Adı'></th>
							<th><cf_get_lang dictionary_id='57647.Spec'></th>
							<th><cf_get_lang dictionary_id="57637.seri no"></th>
							<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
								<th><cf_get_lang dictionary_id='45539.Raf Kodu'></th>
							</cfif>
							<th><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th><cf_get_lang dictionary_id='57636.Birim'></th>
							<th>2.<cf_get_lang dictionary_id='57635.Miktar'></th>
							<th>2.<cf_get_lang dictionary_id='57636.Birim'></th>
							<cfif isdefined('is_lot_no') and is_lot_no eq 1>
								<th><cf_get_lang dictionary_id='45498.Lot No'></th>
							</cfif>
						</tr>
					</thead>
					<tbody id="table_old_stock">
					</tbody>
				</cf_grid_list>
			</cf_basket>
		</cf_box>
	</div>
</cfform>
<script type="text/javascript">

	var row_count=0;
	var silinen_satir_toplam = 0;
	
	function add_seri_no(row_no)
	{
		if(document.getElementById('stock_id'+row_no).value.length!=0)
		{
			amount = filterNum(document.getElementById('amount'+row_no).value);
			if(document.getElementById('amount2_'+row_no)!=null) amount2 = filterNum(document.getElementById('amount2_'+row_no).value);
			if(document.getElementById('exit_amount2_'+row_no)!=null) exit_amount2 = filterNum(document.getElementById('exit_amount2_'+row_no).value);
			product_id = document.getElementById('product_id'+row_no).value;
			stock_id = document.getElementById('stock_id'+row_no).value;
			//wrk_row_id = document.all.wrk_row_id[row_no-1].value;
			process_date = document.getElementById('process_date').value;
			process_id = 0;
			process_cat = 116;
			if(document.add_virman.location_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='51218.Giriş Depo Seçmelisiniz'>!");
				return false;
			}
			else{
			var location_id_ = document.add_virman.location_id.value;
			var department_id_ = document.add_virman.department_id.value;}
			var	paper_number_ = document.add_virman.exchange_no_.value;
			var	wrk_row_id = document.getElementById('wrk_row_id'+row_no).value;
			<cfoutput>
			windowopen('#request.self#?fuseaction=stock.list_serial_operations&event=det&popup_page=1&wrk_row_id='+wrk_row_id+'&process_id='+process_id+'&is_line=1&process_number='+paper_number_+'&product_amount='+amount+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date+'&process_cat='+process_cat+'&sale_product=0&company_id=&con_id=&location_out=&department_out=&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id=','list');
			</cfoutput>
		}
		else{
			alert("<cf_get_lang dictionary_id="57725.Önce Ürün Seçiniz">!");
			return false;	
		}
	}
	function table_clear()
	{
		if(row_count==0)
		{
			var oTable=document.getElementById("table_old_stock");
			while(oTable.rows.length>1)
				oTable.deleteRow(oTable.rows.length-1);
		}
	}
	function delete_row(sy)
	{
		var my_element=eval("add_virman.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("stock_row"+sy);
		my_element.style.display="none";
		silinen_satir_toplam++;
	}
	
	
	function open_serial_no(row,type)
	{
		if(document.getElementById('exit_stock_id'+row) != null && document.getElementById('exit_stock_id'+row).value.length!=0){
			if(eval('document.add_virman.stock_exchange_id'+row)!= null)
				var process_id = eval('document.add_virman.stock_exchange_id'+row).value;
			else
				var process_id = 0;
			if(document.getElementById('exit_wrk_row_id'+row)!=null)
				wrk_row_id = document.getElementById('exit_wrk_row_id'+row).value;
			else 
				wrk_row_id = 0;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no='+document.getElementById('exchange_no_').value+'&process_cat_id=116&process_id='+process_id+'&wrk_row_id='+wrk_row_id+'&stock_id='+eval('document.add_virman.exit_stock_id'+row).value +'&product_id='+eval('document.add_virman.exit_product_id'+row).value+'&amount='+filterNum(eval('document.add_virman.exit_amount'+row).value)+'&spect_id='+eval('document.add_virman.exit_spec_main_id'+row).value,'list');
		}
		else{
			alert("<cf_get_lang dictionary_id="57725.Önce Ürün Seçiniz">!");
			return false;	
		}
	}
	
	function add_row()
	{
		table_clear();
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_old_stock").insertRow(document.getElementById("table_old_stock").rows.length);
		newRow.setAttribute("name","stock_row" + row_count);
		newRow.setAttribute("id","stock_row" + row_count);		
		newRow.setAttribute("NAME","stock_row" + row_count);
		newRow.setAttribute("ID","stock_row" + row_count);
		newRow.setAttribute("height","30");
		document.add_virman.stock_record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="delete_row('+row_count+')"><i class="fa fa-minus" alt="Ürün Sil"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="exit_stock_code'+row_count+'" id="exit_stock_code'+row_count+'" value="" readonly><input type="hidden" id="exit_product_id'+row_count+'" name="exit_product_id'+row_count+'" value=""><input type="hidden" id="exit_stock_id'+row_count+'" name="exit_stock_id'+row_count+'" value=""><input type="hidden" id="exit_spec_id'+row_count+'" name="exit_spec_id'+row_count+'" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="exit_product_name'+row_count+'" id="exit_product_name'+row_count+'" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="open_add_product('+row_count+',1)"></span><span class="input-group-addon icon-ellipsis font-red" href="javascript://" onclick="open_product_detail(add_virman.exit_product_id'+row_count+'.value,add_virman.exit_stock_id'+row_count+'.value)"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="exit_spec_main_id'+row_count+'" id="exit_spec_main_id'+row_count+'" value=""><input type="text" name="exit_spec_main_name'+row_count+'" value="" readonly><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_spec(document.add_virman.exit_product_id'+row_count+'.value,document.add_virman.exit_stock_id'+row_count+'.value,'+row_count+',1);"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><a href="javascript://" onClick="open_serial_no('+row_count+',1)"><i class="fa fa-barcode" style="font-size:20px;" title="<cf_get_lang dictionary_id='57717.Garanti'>" alt="<cf_get_lang dictionary_id='57717.Garanti'>"></i></a></div></div>';
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="exit_shelf_id'+row_count+'" id="exit_shelf_id'+row_count+'" value=""><input type="text" name="exit_shelf_code'+row_count+'" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_shelf(row_count,1);"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="exit_amount'+row_count+'" id="exit_amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" align="right" onKeyUp="return FormatCurrency(this,event,3);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="exit_unit_id'+row_count+'" id="exit_unit_id'+row_count+'" value=""><input type="text" name="exit_unit'+row_count+'" value="" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="exit_amount2_'+row_count+'" id="exit_amount2_'+row_count+'" class="moneybox" align="right" onKeyUp="return FormatCurrency(this,event,3);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="exit_unit2_'+row_count+'" id="exit_unit2_'+row_count+'" value=""><input type="hidden" id="exit_wrk_row_id'+row_count+'"  name="exit_wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'"></div>';
		<cfif isdefined('is_lot_no') and is_lot_no eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="exit_lot_no'+row_count+'" id="exit_lot_no'+row_count+'" value="" onKeyup="lotno_control('+row_count+',1);"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_list_product(add_virman.exit_product_id'+row_count+'.value,add_virman.exit_stock_id'+row_count+'.value,'+row_count+');"></span></div></div>';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code'+row_count+'" id="stock_code'+row_count+'" value="" readonly><input type="hidden" name="product_id'+row_count+'" id="product_id'+row_count+'" value=""><input type="hidden" name="stock_id'+row_count+'" id="stock_id'+row_count+'" value=""><input type="hidden" name="spec_id'+row_count+'" id="spec_id'+row_count+'" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="product_name'+row_count+'" id="product_name'+row_count+'" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="open_add_product('+row_count+',2)"></span><span class="input-group-addon icon-ellipsis font-red" href="javascript://" onclick="open_product_detail(add_virman.product_id'+row_count+'.value,add_virman.stock_id'+row_count+'.value)"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="spec_main_id'+row_count+'" id="spec_main_id'+row_count+'" value=""><input type="text" name="spec_main_name'+row_count+'" id="spec_main_name'+row_count+'" value="" readonly><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_spec(document.add_virman.product_id'+row_count+'.value,document.add_virman.stock_id'+row_count+'.value,'+row_count+',0);"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><a href="javascript://" onclick="add_seri_no('+row_count+')"><i class="fa fa-barcode" style="font-size:20px;" title="<cf_get_lang dictionary_id="57717.Garant">"></i></a></div></div>';
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="shelf_id'+row_count+'" id="shelf_id'+row_count+'" value=""><input type="text" name="shelf_code'+row_count+'" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_shelf(row_count,0);"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount'+row_count+'" id="amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" align="right" onkeyup="return(FormatCurrency(this,event,3));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_id'+row_count+'" id="unit_id'+row_count+'" value=""><input type="text" name="unit'+row_count+'" id="unit'+row_count+'" value="" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount2_'+row_count+'" id="amount2_'+row_count+'" class="moneybox" align="right" onkeyup="return(FormatCurrency(this,event,3));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="unit2_'+row_count+'" id="unit2_'+row_count+'" value=""><input type="hidden" id="wrk_row_id'+row_count+'"  name="wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'"></div>';
		<cfif isdefined('is_lot_no') and is_lot_no eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="lot_no'+row_count+'" id="lot_no'+row_count+'" value="" onKeyup="lotno_control('+row_count+',2);"></div>';
		</cfif>
		return true;
	}
	
	function open_spec(pro_id,s_id,row,type)
	{
		if(pro_id!= undefined && pro_id!='' && s_id!= undefined && s_id!='')
			if(type == 1)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_virman.exit_spec_main_id'+row+'&field_name=add_virman.exit_spec_main_name'+row+'&is_display=1&stock_id='+eval('document.add_virman.exit_stock_id'+row).value,'list');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_virman.spec_main_id'+row+'&field_name=add_virman.spec_main_name'+row+'&is_display=1&stock_id='+eval('document.add_virman.stock_id'+row).value,'list');
		else
			alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
	}
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], _, `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 1)
			lot_no = document.getElementById('exit_lot_no'+crntrow);
		else if(type == 2)
			lot_no = document.getElementById('lot_no'+crntrow);
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
	function open_shelf(row_no,is_exit_part)
	{	
		kontrol_info = 0;
		if(is_exit_part==1)
		{
			if(eval('document.add_virman.exit_product_id'+row_no).value != '')
			{
				kontrol_info = 1;
				var name_field='exit_shelf_code';
				var code_field='exit_shelf_id';
				var shelf_department_id=document.add_virman.exit_department_id.value;
				var shelf_location_id=document.add_virman.exit_location_id.value;
				<cfif is_show_all_shelf eq 0>
					var shelf_prod_id=eval('document.add_virman.exit_product_id'+row_no).value;
				<cfelse>
					var shelf_prod_id='';	
				</cfif>
			}
			else
				alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
		}
		else
		{
			if(eval('document.add_virman.product_id'+row_no).value != '')
			{
				kontrol_info = 1;
				var name_field='shelf_code';
				var code_field='shelf_id';
				var shelf_department_id=document.add_virman.department_id.value;
				var shelf_location_id=document.add_virman.location_id.value;
				<cfif is_show_all_shelf eq 0>
					var shelf_prod_id=eval('document.add_virman.product_id'+row_no).value;
				<cfelse>
					var shelf_prod_id='';	
				</cfif>
			}
			else
				alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
		}
		if(kontrol_info == 1)
		{		
			if(shelf_department_id!='' && shelf_location_id!= '')
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_shelves&is_array_type=0&form_name=add_virman&field_code='+name_field+'&field_id='+code_field+'&department_id='+shelf_department_id+'&location_id='+shelf_location_id+'&row_id='+row_no+'&shelf_product_id='+shelf_prod_id,'small','form_add_stock_exchange');
			else
			{	
				if(is_exit_part==1)
					alert("<cf_get_lang dictionary_id='51278.Lütfen Çıkış Depo Seçiniz'>!");
				else
					alert("<cf_get_lang dictionary_id='45601.Giriş Deposunu Seçmelisiniz'>!");
				return false;
			}
		}
	}
	function open_product_detail(pro_id,s_id)
	{
		if(pro_id!= undefined && pro_id!='' && s_id!= undefined && s_id!='')
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
		else
			alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
	}
	
	function open_add_product(sy,type)
	{
		if(type==1)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=empty_spect&run_function_param1='+sy+'&run_function_param=1&field_id=add_virman.exit_stock_id'+sy+'&field_name=add_virman.exit_product_name'+sy+'&product_id=add_virman.exit_product_id'+sy+'&field_code=add_virman.exit_stock_code'+sy+'&field_unit_name=add_virman.exit_unit'+sy+'&field_unit=add_virman.exit_unit_id'+sy+'&keyword='+encodeURIComponent(eval('document.add_virman.exit_product_name'+sy).value)+'&is_form_submitted=1');
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=empty_spect&run_function_param1='+sy+'&run_function_param=2&field_id=add_virman.stock_id'+sy+'&field_name=add_virman.product_name'+sy+'&product_id=add_virman.product_id'+sy+'&field_code=add_virman.stock_code'+sy+'&field_unit_name=add_virman.unit'+sy+'&field_unit=add_virman.unit_id'+sy+'&keyword='+encodeURIComponent(eval('document.add_virman.product_name'+sy).value)+'&is_form_submitted=1');
	}
	
	function pencere_ac_list_product(pro_id,s_id,no)//satira lot_no ekliyor
	{
		if(pro_id!= undefined && pro_id!='' && s_id!= undefined && s_id!='')
		{
			form_stock_code = document.getElementById("exit_stock_code"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_virman.exit_lot_no'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
		else
			alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
	}
	
	function empty_spect(row_no,type)
	{
		if(type == 1)
		{
			eval('document.add_virman.exit_spec_main_id'+row_no).value = '';
			eval('document.add_virman.exit_spec_main_name'+row_no).value = '';
		}
		else
		{
			eval('document.add_virman.spec_main_id'+row_no).value = '';
			eval('document.add_virman.spec_main_name'+row_no).value = '';
		}
	}
	function control()
	{
		if(document.add_virman.department_name.value=="" || document.add_virman.location_id.value=="")
		{
			alert("<cf_get_lang dictionary_id ='45601.Giriş Deposu Seçiniz'>!");
			return false;
		}
		if(document.add_virman.exit_department_name.value=="" || document.add_virman.exit_location_id.value=="")
		{
			alert("<cf_get_lang dictionary_id ='51278.Çıkış Deposu Seçiniz'>!");
			return false;
		}
	
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1><!--- raf bilgisi seçilmişse satır raf bilgileriyle depolar karsılastırılıyor --->
			var exit_shelf_list_js_='';
			var shelf_list_js_='';
		</cfif>
		for(var i=1;i <= row_count;i++)
		{
			if(eval('document.add_virman.row_kontrol'+i).value == 1 && (eval('document.add_virman.exit_stock_code'+i).value == '' || eval('document.add_virman.stock_code'+i).value == '' || eval('document.add_virman.product_name'+i).value == '' || eval('document.add_virman.exit_product_name'+i).value == ''))
			{
				alert(i+".<cf_get_lang dictionary_id ='45635.Satırda Ürünleri Seçiniz'>!");
				return false;
			}
			<!---<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
				<cfif isdefined('is_lot_no') and is_lot_no eq 1>
					if(check_lotno('add_virman'))//işlem kategorisinde lot no zorunlu olsun seçili ise
					{
						get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("exit_stock_id"+i).value);
						if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						{
							if(document.getElementById("exit_lot_no"+i).value == '')
							{
								alert(i+'. satırdaki '+ document.getElementById("exit_product_name"+i).value + ' ürünü için lot no takibi yapılmaktadır!');
								return false;
							}
						}
						get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id"+i).value);
						if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						{
							if(document.getElementById("lot_no"+i).value == '')
							{
								alert(i+'. satırdaki '+ document.getElementById("product_name"+i).value + ' ürünü için lot no takibi yapılmaktadır!');
								return false;
							}
						}
					}
				</cfif>
			</cfif>--->
			<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1><!--- raf bilgisi seçilmişse satır raf bilgileriyle depolar karsılastırılıyor --->
				if(eval('document.add_virman.row_kontrol'+i).value == 1 && eval('document.add_virman.exit_shelf_id'+i).value != '' && eval('document.add_virman.exit_shelf_code'+i).value != '' )
				{
					if(list_len(exit_shelf_list_js_)==0)
						exit_shelf_list_js_=eval('document.add_virman.exit_shelf_id'+i).value;
					else
						exit_shelf_list_js_= exit_shelf_list_js_+','+eval('document.add_virman.exit_shelf_id'+i).value;
				}
				if(eval('document.add_virman.row_kontrol'+i).value == 1 && eval('document.add_virman.shelf_id'+i).value != '' && eval('document.add_virman.shelf_code'+i).value != '' )
				{
					if(list_len(exit_shelf_list_js_)==0)
						shelf_list_js_=eval('document.add_virman.shelf_id'+i).value;
					else
						shelf_list_js_= shelf_list_js_+','+eval('document.add_virman.shelf_id'+i).value;
				}
			</cfif>
		}
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1><!--- raf bilgisi seçilmişse satır raf bilgileriyle depolar karsılastırılıyor --->
			if(exit_shelf_list_js_!='')
			{
				var listParam = exit_shelf_list_js_ + "*" + document.add_virman.exit_department_id.value + "*" + document.add_virman.exit_location_id.value;
				var get_exit_shelf_sql = wrk_safe_query("stk_get_exit_shelf_sql",'dsn3',0,listParam);
				if(get_exit_shelf_sql.recordcount)
				{
					alert_exit_shelf_str = "<cf_get_lang dictionary_id='61256.Çıkış Depoya Bağlı Olmayan Raflar'>:\n";
					for(var cnt_ii=0;cnt_ii<get_exit_shelf_sql.recordcount;cnt_ii=cnt_ii+1)
						alert_exit_shelf_str = alert_exit_shelf_str +' '+get_exit_shelf_sql.SHELF_CODE[cnt_ii] + '\n';
					alert(alert_exit_shelf_str +"\n <cf_get_lang dictionary_id='61258.Çıkan Stoklar Bölümünde Çıkış Deponun Rafları Seçilebilir'>!");
					return false;
				}
			}
			if(shelf_list_js_!='')
			{
	
				var listParam = shelf_list_js_ + "*" + document.add_virman.department_id.value + "*" + document.add_virman.location_id.value;
				var get_shelf_sql = wrk_safe_query("stk_get_exit_shelf_sql",'dsn3',0,listParam);
				if(get_shelf_sql.recordcount)
				{
					alert_shelf_str = "<cf_get_lang dictionary_id='61256.Çıkış Depoya Bağlı Olmayan Raflar'>:\n";
					for(var shlf_ii=0;shlf_ii<get_shelf_sql.recordcount;shlf_ii=shlf_ii+1)
						alert_shelf_str = alert_shelf_str +' '+get_shelf_sql.SHELF_CODE[shlf_ii] + '\n';
					alert(alert_shelf_str +"\n <cf_get_lang dictionary_id='61257.Stok Giriş Bölümünde Giriş Deposunun Rafları Seçilebilir'>!");
					return false;
				}
			}
		</cfif>
		if(!chk_period(add_virman.process_date)) return false;
		if (!chk_process_cat('add_virman')) return false;
		if(!check_display_files('add_virman')) return false;
		if(silinen_satir_toplam== row_count){
		alert("<cf_get_lang dictionary_id='48664.Lütfen Satır Ekleyiniz'>");return false;
		}
		if (!zero_stock_control('add_virman')) return false;
		pre_submit_clear();		
		return true;
	}
	
	function pre_submit_clear(){
		
		for(var i=1;i <= row_count;i++)
		{
			eval('document.add_virman.exit_amount'+i).value = filterNum(eval('document.add_virman.exit_amount'+i).value,3);
			eval('document.add_virman.amount'+i).value = filterNum(eval('document.add_virman.amount'+i).value,3);
			eval('document.add_virman.exit_amount2_'+i).value = filterNum(eval('document.add_virman.exit_amount2_'+i).value,3);
			eval('document.add_virman.amount2_'+i).value = filterNum(eval('document.add_virman.amount2_'+i).value,3);
		}
		return true;
	}
	
	function zero_stock_control()
	{
		var stock_id_list='0';
		var stock_amount_list='0';
		var main_spec_id_list='0';
		var main_spec_amount_list='0';
		var hata='';
		var lotno_hata='';
		var get_process = wrk_safe_query('stk_get_process','dsn3',0,document.add_virman.process_cat.value);
		if(get_process.IS_ZERO_STOCK_CONTROL == 1)
		{
			<cfif isdefined('is_lot_no') and is_lot_no eq 1>
				try{
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('add_virman') != undefined && check_lotno('add_virman'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							for(i=1;i<=row_count;i++)
							{
								if(eval('document.add_virman.exit_spec_main_id'+i).value != '')
									varName = "lot_no_" + eval('document.add_virman.exit_stock_id'+i).value + eval('document.add_virman.exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_') + eval('document.add_virman.exit_spec_main_id'+i).value;
								else
									varName = "lot_no_" + eval('document.add_virman.exit_stock_id'+i).value + eval('document.add_virman.exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_');								
								this[varName] = 0;
							}
							for(i=1;i<=row_count;i++)
							{
								if(eval('document.add_virman.row_kontrol'+i).value==1)
								{	
									if(eval('document.add_virman.exit_spec_main_id'+i).value != '')
									{
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,eval('document.add_virman.exit_stock_id'+i).value);
										if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
										{
											var spec_main_id_ = eval('document.add_virman.exit_spec_main_id'+i).value;
											var stock_id_ = eval('document.add_virman.exit_stock_id'+i).value;
											var lot_no_ = eval('document.add_virman.exit_lot_no'+i).value;
											var loc_id = document.add_virman.exit_location_id.value;
											var dep_id = document.add_virman.exit_department_id.value;
											var paper_date_kontrol = js_date(date_add('d',1,document.add_virman.process_date.value));
											varName = "lot_no_" + eval('document.add_virman.exit_stock_id'+i).value + eval('document.add_virman.exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_') + eval('document.add_virman.exit_spec_main_id'+i).value;
											var xxx = String(this[varName]);
											var yyy = eval('document.add_virman.exit_amount'+i).value;
											this[varName] = parseFloat( filterNum(xxx,3) ) + parseFloat( filterNum(yyy,3) );
											<cfif xml_zero_stock_date eq 1>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&spec_main_id='+ spec_main_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											<cfelse>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_7&lot_no='+ encodeURIComponent(lot_no_) +'&spec_main_id='+ spec_main_id_ +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											</cfif>
											$.ajax({
													url: url_,
													dataType: "text",
													cache:false,
													async: false,
													success: function(read_data) {
													data_ = jQuery.parseJSON(read_data);
													if(data_.DATA.length != 0)
													{
														$.each(data_.DATA,function(i){
															var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
															var PRODUCT_NAME = data_.DATA[i][1];
															var STOCK_CODE = data_.DATA[i][2];
															var SPECT_MAIN_ID  = data_.DATA[i][3];
															if(eval(varName) > PRODUCT_TOTAL_STOCK)
															{
																if(SPECT_MAIN_ID > 0)
																	lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+') (Main Spec Id:'+SPECT_MAIN_ID+')\n';
																else
																	lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
															}
														});
													}
													else
													{
														lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
													}
												}
											});
										}
									}
									else if(eval('document.add_virman.exit_stock_id'+i).value != '' )
									{
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,eval('document.add_virman.exit_stock_id'+i).value);
										if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
										{
											var stock_id_ = eval('document.add_virman.exit_stock_id'+i).value;
											var lot_no_ = eval('document.add_virman.exit_lot_no'+i).value;
											var loc_id = document.add_virman.exit_location_id.value;
											var dep_id = document.add_virman.exit_department_id.value;
											var paper_date_kontrol = js_date(document.add_virman.process_date.value);
											varName = "lot_no_" + eval('document.add_virman.exit_stock_id'+i).value + eval('document.add_virman.exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_');
											var xxx = String(this[varName]);
											var yyy = eval('document.add_virman.exit_amount'+i).value;
											this[varName] = parseFloat( filterNum(xxx,3) ) + parseFloat( filterNum(yyy,3) );
											<cfif xml_zero_stock_date eq 1>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											<cfelse>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											</cfif>
											$.ajax({
													url: url_,
													dataType: "text",
													cache:false,
													async: false,
													success: function(read_data) {
													data_ = jQuery.parseJSON(read_data);
													if(data_.DATA.length != 0)
													{
														$.each(data_.DATA,function(i){
															var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
															var PRODUCT_NAME = data_.DATA[i][1];
															var STOCK_CODE = data_.DATA[i][2];
															var SPECT_MAIN_ID  = data_.DATA[i][3];
															if(eval(varName) > PRODUCT_TOTAL_STOCK)
															{
																lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
															}
														});
													}
													else
													{
														lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
													}
												}
											});
										}
									}
								}
							}
						}
					</cfif>
				}
				catch(e)
				{}
			</cfif>
			for(var i=1;i <= row_count;i++)
			{
				if(eval('document.add_virman.row_kontrol'+i).value==1)
				{
					if(eval('document.add_virman.exit_spec_main_id'+i).value!='')
					{
						var yer=list_find(main_spec_id_list,eval('document.add_virman.exit_spec_main_id'+i).value,',');
						if(yer){
							top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(filterNum(eval('document.add_virman.exit_amount'+i).value,3));
							main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
						}else{
							main_spec_id_list=main_spec_id_list+','+eval('document.add_virman.exit_spec_main_id'+i).value;
							main_spec_amount_list=main_spec_amount_list+','+filterNum(eval('document.add_virman.exit_amount'+i).value,3);
						}
					}
					else
					{
						var yer=list_find(stock_id_list,eval('document.add_virman.exit_stock_id'+i).value,',');
						if(yer){
							top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(eval('document.add_virman.exit_amount'+i).value,3));
							stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						}else{
							stock_id_list=stock_id_list+','+eval('document.add_virman.exit_stock_id'+i).value;
							stock_amount_list=stock_amount_list+','+filterNum(eval('document.add_virman.exit_amount'+i).value,3);
						}
					}
				}	
			}
			if(list_len(stock_id_list,',')>1)
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + document.add_virman.exit_location_id.value + "*" + document.add_virman.exit_department_id.value + "*" + js_date(document.add_virman.process_date.value);
				<cfif xml_zero_stock_date eq 1>
				var new_sql = "stk_get_total_stock_4";
				<cfelse>
				var new_sql = "stk_get_total_stock_5";
				</cfif>
				var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
				if(get_total_stock.recordcount)
				{
					var query_stock_id_list='0';
					for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
					{
						query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
						var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					}
				}
				var diff_stock_id='0';
				for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
				{
					var stk_id=list_getat(stock_id_list,lst_cnt,',')
					if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
						diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
				}
				if(list_len(diff_stock_id,',')>1)
				{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
					var get_stock = wrk_safe_query('stk_get_stock','dsn3',0,diff_stock_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
				}
				get_total_stock='';
			}
			if(list_len(main_spec_id_list,',')>1){
	
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + document.add_virman.exit_location_id.value + "*" + document.add_virman.exit_department_id.value + "*" + js_date(document.add_virman.process_date.value);
				<cfif xml_zero_stock_date eq 1>
				var new_sql = "stk_get_total_stock_6";
				<cfelse>
				var new_sql = "stk_get_total_stock_7";		
				</cfif>	
				var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
				if(get_total_stock.recordcount)
				{
					var query_spec_id_list='0';
					for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
					{
						query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];
						var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					}
				}
				var diff_spec_id='0';
				for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
				{
					var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
					if(query_spec_id_list==undefined || query_spec_id_list=='0' || list_find(query_spec_id_list,spc_id,',') == '0')
						diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
				}
				if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
				{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
					var get_stock = wrk_safe_query('stk_get_stock_2','dsn3',0,diff_spec_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+') (main spec id:'+get_stock.SPECT_MAIN_ID[cnt]+')\n';
				}
			}
		}
		if(lotno_hata != '')
		{
				alert(lotno_hata+"\n\n <cf_get_lang dictionary_id='60055.Yukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir'> <cf_get_lang dictionary_id='60599.Lütfen seçtiğiniz depo lokasyonundaki miktarları kontrol ediniz'> !");
			lotno_hata='';
			return false;
		
		}
		if(hata!='')
		{
			alert(hata+"\n\n<cf_get_lang dictionary_id ='45636.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo lokasyonundaki miktarları kontrol ediniz'> !");
			return false;
		}
		else
			return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
