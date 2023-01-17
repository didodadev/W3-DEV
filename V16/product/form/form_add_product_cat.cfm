<!--- Ilgili urun kategorisinde iliskili urun kaydı var ise alt kategori tanımlanması engellenir  --->
<cf_xml_page_edit fuseact="product.list_product_cat">
<cfif isdefined('attributes.ust_cat')>
	<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
		SELECT HIERARCHY FROM PRODUCT_CAT,PRODUCT WHERE PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ust_cat#">
	</cfquery>
	<cfif get_products.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='37261.Bu Kategoride Ürün Tanımlı Oldugu için Alt Kategori Açamazsınız !'> !");
			window.location.href = '<cfoutput>#request.self#?fuseaction=product.list_product_cat</cfoutput>';
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- Ilgili urun kategorisinde iliskili urun kaydı var ise alt kategori tanımlanması engellenir  --->
<cfinclude template="../query/product_cats.cfm">
<cfinclude template="../query/get_our_companies.cfm">
<cfparam name="attributes.ust_cat" default="">
<cf_catalystHeader>
<cf_box>
    <cfform name="product_cat" method="post" action="#request.self#?fuseaction=product.product_cat_add" enctype="multipart/form-data">
		<cfoutput>
		<input type="hidden" id="counter" name="counter">
		<input type="hidden" name="link_type" id="link_type" value="<cfif isdefined("attributes.link_type") and attributes.link_type eq 1>#attributes.link_type#</cfif>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-our_company_ids">
						<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
						<div class="col col-9 col-xs-12">
							<cf_multiselect_check
							name="our_company_ids"
							option_name="nick_name"
							option_value="comp_id"
							width="220"
							table_name="OUR_COMPANY"
							value="iif(#listlen(session.ep.company_id)#,#session.ep.company_id#,DE(''))">
						</div>
					</div>
					<div class="form-group" id="item-hierarchy">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
						<div class="col col-9 col-xs-12">
							<select name="hierarchy" id="hierarchy" value="<cfif len(attributes.ust_cat)>#attributes.ust_cat#</cfif>" onchange="document.getElementById('head_cat_code').value = document.product_cat.hierarchy[document.product_cat.hierarchy.selectedIndex].value;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="product_cats">
									<option value="#hierarchy#"<cfif len(attributes.ust_cat) and compare(ust_cat,hierarchy) eq 0> selected</cfif>>#hierarchy# #product_cat#</option>
								</cfloop> 
							</select>
						</div>
					</div>
					<div class="form-group" id="item-head_cat_code">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37159.Kategori Kodu'> *</label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="text" name="head_cat_code" id="head_cat_code" value="<cfif len(attributes.ust_cat)>#attributes.ust_cat#</cfif>" disabled>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='37431.Kategori Kodu girmelisiniz'></cfsavecontent>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="product_cat_code" id="product_cat_code" value="" maxlength="50" required="yes" message="#message#">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-product_cat">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
						<div class="col col-9 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='37378.Kategori girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="product_cat" id="product_cat" value="" maxlength="150" required="yes" message="#message#">
						</div>
					</div>
					<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
					<cfset GET_OUR_COMPANY_INFO = company_cmp.GET_OURCMP_INFO()>
					<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1>
						<div class="form-group" id="item-watalogy_product_cat">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<cfsavecontent  variable="message"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></cfsavecontent>
									<cfinput type="hidden" name="watalogy_cat_id" value="">
									<cfinput type="text" name="watalogy_cat_name" id="watalogy_cat_name" value="">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_watalogy_category_names&field_id=product_cat.watalogy_cat_id&field_name=product_cat.watalogy_cat_name');" title="<cf_get_lang dictionary_id='61454.Watalogy Kategorisi Ekle'>!"></span>
								</div>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-profit_margin_min">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37045.Marj'>(%)</label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<label><cf_get_lang dictionary_id='37321.Min'></label>
								<input type="text" name="profit_margin_min" id="profit_margin_min" value="" maxlength="3" class="moneybox" onkeyup="return(FormatCurrency(this,event));" />
								<span class="input-group-addon no-bg"></span>
								<label><cf_get_lang dictionary_id='37319.Maximum'></label>
								<label><input type="text" name="profit_margin_max" id="profit_margin_max" value="" maxlength="3" class="moneybox" onkeyup="return(FormatCurrency(this,event));" /></label>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-9 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla kararkter sayısı'></cfsavecontent>
							<textarea name="detail" id="detail" maxlength="150" onKeyUp="return ismaxlength(this)" onblur="return ismaxlength(this);" message="#message#"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-list_order_no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37545.Listeleme Sırası'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="list_order_no" id="list_order_no" range="1,1000" message="Listeleme Sırası 1-1000 arası olmalıdır!" validate="integer">
						</div>
					</div>
					<div class="form-group" id="item-stock_code_counter">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61459.Stock Code Counter'></label>
						<div class="col col-9 col-xs-12">
							<cfinput type="text" name="stock_code_counter" id="stock_code_counter"  message="Stok kodu değeri sayı olmalıdır!" validate="integer">
						</div>
					</div>
					<cfif xml_form_factor>
                        <div class="form-group" id="item-form_factor">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='65046.Form Faktörü'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="form_factor" id="form_factor">
                                    <option value="0" selected><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                    <cfoutput>
                                        <option value = "1"><cf_get_lang dictionary_id="65045.Boru"></option>
                                        <option value = "2"><cf_get_lang dictionary_id="39097.Profil"></option>
                                        <option value = "3">H</option>
                                        <option value = "4">I</option>
                                        <option value = "5">T</option>
                                        <option value = "6">U</option>
                                        <option value = "7">L</option>
                                        <option value = "8"><cf_get_lang dictionary_id="65047.Köşebent"></option>
                                        <option value = "9"><cf_get_lang dictionary_id="57666.Silindir"></option>
                                        <option value = "10"><cf_get_lang dictionary_id="65048.Altıgen"></option>
                                        <option value = "11"><cf_get_lang dictionary_id="65049.Beşgen"></option>
                                        <option value = "12"><cf_get_lang dictionary_id="65050.Kare"></option>
                                        <option value = "13"><cf_get_lang dictionary_id="65051.Dikdörtgen"></option>
                                        <option value = "14"><cf_get_lang dictionary_id="65052.Üçgen"></option>
                                        <option value = "15"><cf_get_lang dictionary_id="65053.Küre"></option>
                                        <option value = "16"><cf_get_lang dictionary_id="63870.Rulo"></option>
                                        <option value = "17"><cf_get_lang dictionary_id="65055.Sıvı"></option>
                                        <option value = "18"><cf_get_lang dictionary_id="65054.Dökme"></option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
					<div class="form-group" id="item-image_cat">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37135.İmaj'></label>
						<div class="col col-9 col-xs-12">
							<input type="file" name="image_cat" id="image_cat">
						</div>
					</div>
					<div class="form-group" id="item-is_public">
						<label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='37161.Web de Göster'></span></label>
						<div class="col col-9 col-xs-12">
							<label><input type="checkbox" value="1" name="is_public" id="is_public"> <cf_get_lang dictionary_id='37161.Web de Göster'></label>
						</div>
					</div>
					<div class="form-group" id="item-is_cash_register">
						<label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='65171.Display on Whops'></span></label>
						<div class="col col-9 col-xs-12">
							<label><input type="checkbox" value="1" name="is_cash_register" id="is_cash_register"> <cf_get_lang dictionary_id='65171.Display on Whops'></label>
						</div>
					</div> 
					<div class="form-group" id="item-is_customizable">
						<label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='37342.Konfigüre edilebilir'></span></label>
						<div class="col col-9 col-xs-12">
							<label><input type="checkbox" name="is_customizable" id="is_customizable"> <cf_get_lang dictionary_id='37342.Konfigüre edilebilir'></label>
						</div>
					</div>
					<div class="form-group" id="item-is_installment_payment">
						<label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='37263.Ödeme adımında taksit uygulanamaz'></span></label>
						<div class="col col-9 col-xs-12">
							<label><input type="checkbox" name="is_installment_payment" id="is_installment_payment"/> <cf_get_lang dictionary_id='37263.Ödeme adımında taksit uygulanamaz'></label>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
					<cfsavecontent  variable="head"><cf_get_lang dictionary_id='37353.İlişkili Markalar'></cfsavecontent>
					<cf_seperator title="#head#" id="brand_ids">
					<div id="brand_ids">
						<cfinclude template="../display/add_product_brand.cfm">
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
					<cfsavecontent  variable="head"><cf_get_lang dictionary_id='37316.İlişkili Sorumlular'></cfsavecontent>
					<cf_seperator title="#head#" id="position_">
					<div id="position_">
						<cf_grid_list>
							<thead>
								<tr>
									<th width="20"><a href="javascrript://" onclick="add_responsible_row();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
									<th><cf_get_lang dictionary_id ='37624.Sıra No'></th>
									<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
								</tr>
							</thead>
							<input type="hidden" name="record_num_responsible" id="record_num_responsible" value="0">
							<tbody id="table_responsible"></tbody>
						</cf_grid_list>
					</div>
				</div>
			</cf_box_elements>
			<div class="ui-form-list-btn">
				<cf_workcube_buttons is_upd='0' add_function='form_check()'>
			</div>
			
		</cfoutput>
	</cfform>
</cf_box>
<script type="text/javascript">
	responsible_row_count = 0;
	function form_kontrol(alan,msg,min_n,max_n)
	{
		if(!checkElementLengthRange(alan, "<cf_get_lang dictionary_id='60485.Mesaj bölümüne girilebilecek maksimum karakter sayısı'>:" +max_n, 1, max_n)) 
		return false;
	}
		
	function checkElementLengthRange(target, msg, min_n, max_n)
	{	
		if (!(target.value.length>=min_n && target.value.length<=max_n)){
			alert(msg);
			target.focus();
			return false;
		}
		return true;
	}
	
	function form_check()
	{ 
		if($('#our_company_ids').val() == '')
		{
			alert("<cf_get_lang dictionary_id ='37201.Lütfen, kaydetmek istediğiniz kategoriyi en az bir şirket ile ilişkilendiriniz!'>");
			return false;
		}
		for (i=1;i<responsible_row_count+1;i++)
		{
			if(eval("document.getElementById('row_kontrol_responsibles" + i + "')").value == 1){
				
			if($('#order_number'+ i).val() == '' || $('#position_code'+ i).val() == '')
			{
				alert("<cf_get_lang dictionary_id='60486.Lütfen Sorumluları Eksiksiz Giriniz'>");
				return false;
			}
			}
		}
		/* bosluklar aliniyor */ 
		our_pro_str = $('#product_cat_code').val();
		for(;;)
		{
			if (our_pro_str.search(" ") != -1)
			{      
				our_pro_str = our_pro_str.replace(" ","");
				product_cat.product_cat_code.value = our_pro_str;
			}
			else
			{
				break;
			}
		}
		
		temp_profit_margin_min = filterNum($('#profit_margin_min').val());
		temp_profit_margin_max = filterNum($('#profit_margin_max').val());
		if (temp_profit_margin_min!="" && temp_profit_margin_max!="" && (parseFloat(temp_profit_margin_min) > parseFloat(temp_profit_margin_max)))
		{
			alert("<cf_get_lang dictionary_id='37864.Marj Degerlerini Kontrol Ediniz'> , <cf_get_lang dictionary_id='60487.Min Marj Max Marj dan Büyük Olamaz'> !");
			return false;
		}
		
		if (product_cat.product_cat_code.value.indexOf('.') != -1)
		{
			alert("<cf_get_lang dictionary_id='43391.Ürün özel kategori kodu . içeremez'>!");
			return false;
		}
		
		$('#profit_margin_max').val() = filterNum($('#profit_margin_min').val());
		$('#profit_margin_max').val() = filterNum($('#profit_margin_max').val());
		return true;	
	}
	function add_responsible_row()
	{
		responsible_row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_responsible").insertRow(document.getElementById("table_responsible").rows.length);
		newRow.setAttribute("id","responsibles" + responsible_row_count);
		document.getElementById('record_num_responsible').value = responsible_row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_responsibles' + responsible_row_count +'" id="row_kontrol_responsibles' + responsible_row_count +'" value="1"><a onclick="sil_responsible(' + responsible_row_count + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="order_number' + responsible_row_count +'" id="order_number' + responsible_row_count +'" onkeyup="isNumber(this);" onblur="isNumber(this);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="position_code' + responsible_row_count +'" id="position_code' + responsible_row_count +'"><input type="text" name="position_name' + responsible_row_count +'" id="position_name' + responsible_row_count +'"  value="" onFocus="AutoCompleteOpenPos(' + responsible_row_count + ');" ><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="PopupOpenPos('+ responsible_row_count +');"></span></div></div>';
		
	}
	function AutoCompleteOpenPos(row)
	{
		AutoComplete_Create('position_name'+row,'FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','position_code'+row,'','3','130');
	}
	function PopupOpenPos(row)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=product_cat.position_name' + row +'&field_code=product_cat.position_code' + row </cfoutput>,'list');
	}
	function sil_responsible(row)
	{
		$('row_kontrol_responsibles' + row).val(0);
		//eval("document.getElementById('row_kontrol_responsibles" + row + "')").value = 0;
		document.getElementById('responsibles' + row ).style.display = 'none';
	}

	$( document ).ready(function() {
		var my_options = $("#form_factor option");

		my_options.sort(function(a,b) {
		    if (a.text > b.text) return 1;
		    else if (a.text < b.text) return -1;
		    else return 0;
		});

		$("#form_factor").empty().append(my_options).selectpicker("refresh");
	})
</script>
