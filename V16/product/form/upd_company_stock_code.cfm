<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfquery name="get_company_stock_code" datasource="#dsn1#">
	SELECT
		*
	FROM
		SETUP_COMPANY_STOCK_CODE
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>
<cfset toplam = get_company_stock_code.RecordCount>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57658.Üye'> <cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
	<cf_box title="#message#">
		<cfform name="form_get_company" method="post" action="#request.self#?fuseaction=product.emptypopup_get_company_stock_code" onsubmit="return search_kontrol();">
			<cf_box_search more="0">
				<input type="hidden" name="form_varmi" id="form_varmi" value="1">
				<div class="form-group" id="item-company_id">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
						<input type="text" name="member_name" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>" style="width:200px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">				
						<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form_get_company.member_name&field_comp_id=form_get_company.company_id&field_name=form_get_company.member_name&select_list=2&keyword='+encodeURIComponent(document.form_get_company.member_name.value),'list');"></span>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='search_kontrol()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfif isDefined("form.form_varmi")>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57658.Üye'> <cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
		<cf_box title="#message#" uidrop="1" hide_table_column="1">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_add_company_stock_code">
				<input type="hidden" name="form_upd_" id="form_upd_" value="1">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
				<input type="hidden" name="member_name" id="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>">
				<input type="hidden" name="record_num" id="record_num"  value="<cfoutput>#toplam#</cfoutput>">
				<cf_flat_list>
					<thead>
						<tr>
							<th width="20"><a title="Ekle" onClick="add_row();"><i class="fa fa-plus"></i></a></th>
							<th width="150" align="left"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th width="180" align="left"><cf_get_lang dictionary_id='57657.Ürün'></th>
							<th width="150" align="left"><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th width="300" align="left"><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
							<th width="300"><cf_get_lang dictionary_id='57629.Aciklama'></th>
							<th width="50"><cf_get_lang dictionary_id='57485.Oncelik'></th>
							<th class="header_icn_text"><cf_get_lang dictionary_id='57493.Aktif'></th>
						</tr>
					</thead>
					<tbody name="table1" id="table1">
						<cfset company_code_list = "">
						<cfoutput query="get_company_stock_code">
							<cfif len(stock_id) and not listfind(company_code_list,stock_id)>
								<cfset company_code_list=listappend(company_code_list,stock_id)>
							</cfif>
						</cfoutput>
						<cfif len(company_code_list)>
							<cfquery name="get_product_name" datasource="#dsn3#">
								SELECT STOCK_ID,STOCK_CODE,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#company_code_list#) ORDER BY STOCK_ID
							</cfquery>
							<cfset company_code_list = listsort(listdeleteduplicates(valuelist(get_product_name.stock_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfoutput query="get_company_stock_code">
							<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
							<input type="hidden" name="stock_id#get_company_stock_code.currentrow#" id="stock_id#get_company_stock_code.currentrow#" value="#stock_id#">
							<tr id="frm_row#currentrow#">
								<td style="cursor:pointer"><div class="form-group"><a style="cursor:pointer" onclick="sil(#currentrow#);" ><img  src="images/delete_list.gif" border="0"></a></td>
								<td><div class="form-group"><input type="text" value="#get_product_name.stock_code[listfind(company_code_list,stock_id,',')]#" name="stock_code#currentrow#" id="stock_code#currentrow#" readonly></div></td>
								<td><div class="form-group"><div class="input-group"><input type="text"  value="#get_product_name.product_name[listfind(company_code_list,stock_id,',')]#" name="product_name#currentrow#" id="product_name#currentrow#" readonly>
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id#currentrow#&field_code=form_basket.stock_code#currentrow#&field_name=form_basket.product_name#currentrow#','list');"></span></div></div>
								</td>
								<td><div class="form-group"><input type="text" value="#company_stock_code#" name="company_stock_code#currentrow#" id="company_stock_code#currentrow#"></div></td>
								<td><div class="form-group"><input type="text" value="#company_product_name#" name="company_product_name#currentrow#" id="company_product_name#currentrow#"></div></td>
								<td><div class="form-group"><input type="text" value="#detail#" name="company_product_detail#currentrow#" id="company_product_detail#currentrow#"></div></td>
								<td><div class="form-group"><input type="text" value="#priority#" name="company_product_priority#currentrow#" id="company_product_priority#currentrow#" onkeyup="isNumber(this);"></div></td>
								<td><div class="form-group"><input type="checkbox" name="is_active#currentrow#" id="is_active#currentrow#" <cfif is_active eq 1>checked="checked"</cfif>/></div></td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_flat_list>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='satir_kontrol()' type_format="1">
				</cf_box_footer>
			</cfform>
		</cf_box>
	</cfif>
</div>
<script type="text/javascript">
	row_count=<cfoutput>#toplam#</cfoutput>;
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
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_stock_code' + row_count + '"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="company_product_name' + row_count + '"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '"></div>';

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
		if((document.form_get_company.company_id.value == "") || document.form_get_company.member_name.value == "")
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
								alert("<cf_get_lang dictionary_id='37486.Aynı Üye Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang dictionary_id='57658.Üye'> <cf_get_lang dictionary_id='57518.Stok Kodu'> : "+eval("document.form_basket.company_stock_code"+r).value);
								return false;
							}
						}
					}
					
				}
			}
		}	
	}
</script>
