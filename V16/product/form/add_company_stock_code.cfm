<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_get_company" method="post" action="#request.self#?fuseaction=product.emptypopup_get_company_stock_code" onsubmit="return search_kontrol();">
			<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-company_id">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
						<input type="text" name="member_name" placeholder="<cfoutput><cf_get_lang dictionary_id='57658.Üye'></cfoutput>" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>" style="width:200px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form_get_company.member_name&field_comp_id=form_get_company.company_id&select_list=2&keyword='+encodeURIComponent(document.form_get_company.member_name.value),'list');"></span>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='search_kontrol()' is_excel="0">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfif isDefined("form.form_varmi")>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57658.Üye'> <cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
		<cf_box title="#message#" uidrop="1" hide_table_column="1">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_add_company_stock_code">
				<input type="hidden" name="form_add_" id="form_add_" value="1">
				<input name="record_num" id="record_num" type="hidden" value="">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
				<input type="hidden" name="member_name" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>">
				<cf_flat_list>
					<thead>
						<tr>
							<th width="20"><a title="Ekle" onClick="add_row();"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id='57657.Ürün'></th>
							<th><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
							<th><cf_get_lang dictionary_id='57629.Aciklama'></th>
							<th><cf_get_lang dictionary_id='57485.Oncelik'></th>
							<th><cf_get_lang dictionary_id='57493.Aktif'></th>
						</tr>
					</thead>
					<tbody name="table1" id="table1"></tbody>
				</cf_flat_list>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='satir_kontrol()'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</cfif>
</div>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.form_basket.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';				
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="row_kontrol' + row_count +'"  value="1"><input type="hidden" name="stock_id' + row_count +'"><input type="text" name="stock_code' + row_count + '" readonly></div>';			
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count + '" readonly><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="pencere_pos(' + row_count + ');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_stock_code' + row_count + '" maxlength="150"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_product_name' + row_count + '" maxlength="600"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '" maxlength="250"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_product_priority' + row_count + '" id="company_product_priority' + row_count + '" onkeyup="isNumber(this);"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="is_active' + row_count + '" id="is_active' + row_count + '"></div>';
	}
	function pencere_pos(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id' + no + '&field_code=form_basket.stock_code' + no + '&field_name=form_basket.product_name' + no,'list');
	}
	function search_kontrol()
	{
		if((document.form_get_company.company_id.value=="") || document.form_get_company.member_name.value=="")
		{
			alert("<cf_get_lang dictionary_id='37409.Müşteri Seçmelisiniz'> !");
			return false;
		}
		else
			return true;
	}
	function satir_kontrol()
	{
		if(document.form_basket.record_num.value > 0)
		{
			for(r=1;r<=form_basket.record_num.value;r++)
			{
				if(eval("document.form_basket.row_kontrol"+r).value == 1)
				{
					if(eval("document.form_basket.stock_id"+r).value == "" || eval("document.form_basket.product_name"+r).value == "")
					{
						alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
						return false;
					}
					if(eval("document.form_basket.company_stock_code"+r).value == "")
					{
						alert("<cf_get_lang dictionary_id='37293.Üye Stok Kodu Girmelisiniz'>!");
						return false;
					}
					deger = 1;
					for(deger=1;deger<=r;deger++)
					{
						if(deger != r)
						{
							if(eval("document.form_basket.stock_code"+r).value == eval("document.form_basket.stock_code"+deger).value)
							{
								alert("<cf_get_lang dictionary_id='37484.Aynı Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang dictionary_id='57518.Stok Kodu'> : "+eval("document.form_basket.stock_code"+r).value);
								return false;
							}
							if(eval("document.form_basket.company_stock_code"+r).value == eval("document.form_basket.company_stock_code"+deger).value)
							{
								alert("<cf_get_lang dictionary_id='37486.Aynı Üye Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='57518.Stok Kodu'> : "+eval("document.form_basket.company_stock_code"+r).value);
								return false;
							}
						}
					}
			}	}
		}
	}
</script>
