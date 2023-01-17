<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_unit.cfm">
<cfquery name="GET_CARE_REPORT_ROW" datasource="#DSN#">
	SELECT 
		ASSET_CARE_REPORT_ROW.*,
		SETUP_CARE_CAT.HIERARCHY,
		SETUP_CARE_CAT.CARE_CAT
	FROM
		ASSET_CARE_REPORT_ROW,
		SETUP_CARE_CAT
	WHERE
		CARE_REPORT_ID = #care_report_id# AND
		SETUP_CARE_CAT.CARE_CAT_ID = ASSET_CARE_REPORT_ROW.CARE_CAT_ID
	ORDER BY 
		ASSET_CARE_REPORT_ROW.CARE_REPORT_ROW_ID
</cfquery>
<cfset row = get_care_report_row.recordcount>
<cfset top_price = 0>
<cfset top_kdv_price = 0>
<cf_grid_list>
	<thead>
		<tr>
			<th width="20">
				<input name="record_num" type="hidden" value="<cfoutput>#get_care_report_row.recordcount#</cfoutput>" id="record_num">
				<a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
			</th>
			<th><cf_get_lang dictionary_id='48062.Bakım Kategorisi'> *</th>
			<th width="250"><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th width="65"><cf_get_lang dictionary_id='57635.Miktar'> *</th>
			<th width="65"><cf_get_lang dictionary_id='57636.Birim'> *</th>
			<th width="65"><cf_get_lang dictionary_id='58084.Fiyat'></th>
			<th width="75"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            <th width="65"><cf_get_lang dictionary_id='57639.kdv'></th>
            <th width="65"><cf_get_lang dictionary_id='57641.iskonto'></th>
			<th width="65"><cf_get_lang dictionary_id='57673.Tutar'></th>
		</tr>
	</thead>
	<tbody name="table1" id="table1">
		<cfif get_care_report_row.recordCount>
			<cfoutput query="get_care_report_row">
				<tr id="frm_row#currentrow#">
					<td nowrap><a onClick="sil_sor(#currentrow#);"><i class="fa fa-minus" title="Sil"></i></a></td>
					<td nowrap>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
								<input type="hidden" name="care_cat_id#currentrow#" id="care_cat_id#currentrow#" value="#get_care_report_row.care_cat_id#">
								<input type="text" name="care_cat#currentrow#" id="care_cat#currentrow#" value="#get_care_report_row.hierarchy# #get_care_report_row.care_cat#" readonly="yes">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_care_cat_names&field_id=upd_asset_care.care_cat_id#currentrow#&field_name=upd_asset_care.care_cat#currentrow#');"></span>
							</div>
						</div>
					</td>
					<td nowrap><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#get_care_report_row.detail#" maxlength="50"></div></td>
					<td nowrap><div class="form-group"><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" class="moneybox" value="#tlformat(get_care_report_row.quantity)#" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp='return(FormatCurrency(this,event));'></div></td>
					<td nowrap>
						<div class="form-group">
							<select name="unit#currentrow#" id="unit#currentrow#">
								<cfset unit_ = unit>
								<cfinclude template="../query/get_unit.cfm">		
								<cfloop query="get_unit">
									<option value="#unit_id#" <cfif unit_ eq unit_id>selected</cfif>>#unit#</option>
								</cfloop>
							</select>
						</div>
					</td>
					<td nowrap><div class="form-group"><input type="text" name="price#currentrow#" id="price#currentrow#" value="#tlformat(get_care_report_row.price)#" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');"  onKeyUp='return(FormatCurrency(this,event));'></div></td>
					<td>
						<div class="form-group">
							<select name="money_currency#currentrow#" id="money_currency#currentrow#">
								<cfloop query="get_money">
									<option value="#money#" <cfif get_care_report_row.money_currency eq money>selected</cfif>>#money#</option>
								</cfloop>
							</select>
						</div>
					</td>
					<td nowrap><div class="form-group"><input type="text" name="kdv#currentrow#" id="kdv#currentrow#" value="#kdv#" onBlur="fiyat_hesapla('#currentrow#');" class="moneybox" onKeyUp='return(FormatCurrency(this,event));'></div></td>
					<td nowrap><div class="form-group"><input type="text" name="iskonto#currentrow#" id="iskonto#currentrow#" value="#tlformat(iskonto)#" onBlur="fiyat_hesapla('#currentrow#');" class="moneybox" onKeyUp='return(FormatCurrency(this,event));'></div></td>
					<td nowrap><input type="text" name="total_price#currentrow#" id="total_price#currentrow#" onBlur="fiyat_hesapla('#currentrow#',1);" value="#tlformat(get_care_report_row.total_price)#" class="moneybox" onKeyUp='return(FormatCurrency(this,event));'></div></td>
                </tr>
			</cfoutput>
		</cfif>
	</tbody>
</cf_grid_list>
<script type="text/javascript">
	row_count=<cfoutput>#row#</cfoutput>;
	top_price = 0;
	top_kdv_price = 0;
	my_money = "";
	//document.all.record_num.value=row_count;
	function add_row()
	{	
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
				
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onClick="sil_sor('+row_count+');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="care_cat_id'+ row_count +'" id="care_cat_id'+ row_count +'" value=""><input type="text" name="care_cat'+ row_count +'" id="care_cat'+ row_count +'" value="" readonly="yes"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="detail'+ row_count +'" id="detail'+ row_count +'" maxlength="50">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity'+ row_count +'" id="quantity'+ row_count +'" value="<cfoutput>#tlformat(1)#</cfoutput>" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count + ');"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="unit'+ row_count +'" id="unit'+ row_count +'"><option value=""></option><cfoutput query="get_unit"><option value="#unit_id#">#unit#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="price' + row_count +'" id="price' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="money_currency' + row_count +'" id="money_currency' + row_count +'""><cfoutput query="get_money"><option value="#money#">#money#</option></cfoutput></select></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv' + row_count +'" id="kdv' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="iskonto' + row_count +'" id="iskonto' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="total_price' + row_count +'" id="total_price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count + ',1);" class="moneybox"></div>';

	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_care_cat_names&field_id=upd_asset_care.care_cat_id'+ no +'&field_name=upd_asset_care.care_cat'+ no);
	}
	function sil_sor(param)
	{
		sil(param);	
	}
	function sil(sy)
	{
		document.getElementById('row_kontrol'+sy).value=0;	
		document.getElementById('frm_row'+sy).style.display = "none";
	}
	function fiyat_hesapla(satir,type)
	{
		if(type == 1)
		{	
			total_price_ = filterNum(document.getElementById('total_price'+satir).value);
			if(total_price_!='')
			{
				temp_ = parseFloat(total_price_);
				
				if(document.getElementById('kdv'+satir).value.length != 0)
				{
					kdv = filterNum(document.getElementById('kdv'+satir).value);
					temp_ = parseFloat(total_price_/(1+(kdv/100)));
				}
				if(document.getElementById('iskonto'+satir).value.length != 0)
				{
					iskonto = filterNum(document.getElementById('iskonto'+satir).value);
					temp_ = parseFloat(temp_/(1-(iskonto/100)));
				}
				
				price_ = parseFloat(temp_);
				amount_ = filterNum(document.getElementById('quantity'+satir).value);
				price =  parseFloat((price_)/amount_);
				document.getElementById('price' + satir).value = commaSplit(price);
			}
			
		}
		else
		{
			if(document.getElementById('price'+satir).value.length != 0 && document.getElementById('quantity'+satir).value.length != 0)
			{
				price_ = filterNum(document.getElementById('price'+satir).value);
				price_ = parseFloat(price_ );
				fiyat_ = parseFloat(price_ )
				if(document.getElementById('iskonto'+satir).value.length != 0)
				{
					iskonto = filterNum(document.getElementById('iskonto'+satir).value);
					price_ = price_ - price_*iskonto/100 ;
					fiyat_ = price_ - price_*iskonto/100 ;
				}
				if(document.getElementById('kdv'+satir).value.length != 0)
				{
					kdv = filterNum(document.getElementById('kdv'+satir).value);
					kdv_ = ((price_*kdv)/100);
					fiyat_ = parseFloat(price_ )+ parseFloat(kdv_);
				}
				amount_ = filterNum(document.getElementById('quantity'+satir).value);
				total_price_ =  parseFloat((fiyat_)*amount_);
				document.getElementById('total_price' + satir).value = commaSplit(total_price_);
			}
			else if(document.getElementById('total_price'+satir).value.length != 0 && document.getElementById('quantity'+satir).value.length != 0 || document.getElementById('total_price'+satir).value.length != 0 && document.getElementById('quantity'+satir).value.length != 0 && document.getElementById('total_price'+satir).value.length != 0)
			{
				total_price_ = filterNum(document.getElementById('total_price'+satir).value);
				temp_ = 100;
				if(document.getElementById('iskonto'+satir).value.length != 0)
				{
					iskonto = filterNum(document.getElementById('iskonto'+satir).value);
					temp_ = parseFloat(100)-parseFloat(iskonto);
				}
				if(document.getElementById('kdv'+satir).value.length != 0)
				{
					kdv = filterNum(document.getElementById('kdv'+satir).value);
					temp_ = parseFloat(100)+parseFloat(kdv);
				}
				price_ = (parseFloat(100*total_price_))/temp_;
				amount_ = filterNum(document.getElementById('quantity'+satir).value);
				price =  parseFloat((price_)/amount_);
				document.getElementById('price' + satir).value = commaSplit(price);
			}
		}

		return true;
	}
	function unformat_fields()
	{
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById('row_kontrol'+r).value == 1)
			{
				fiyat_hesapla(r);
				document.getElementById('quantity'+r).value = filterNum(document.getElementById('quantity'+r).value);
				document.getElementById('price'+r).value = filterNum(document.getElementById('price'+r).value);
				document.getElementById('total_price'+r).value = filterNum(document.getElementById('total_price'+r).value);
				document.getElementById('kdv'+r).value = filterNum(document.getElementById('kdv'+r).value);
				document.getElementById('iskonto'+r).value = filterNum(document.getElementById('iskonto'+r).value);
				if(r==row_count)
				{
					my_money = document.getElementById('money_currency'+r).value;
				}
				if(document.getElementById('iskonto'+r).value.length != 0)
				iskonto_ = document.getElementById('iskonto'+r).value;
				else
				iskonto_ = 0;
				top_price = parseFloat(top_price) +	parseFloat(document.getElementById('price'+r).value)*(1-(iskonto_/100))*parseFloat(document.getElementById('quantity'+r).value);
				top_kdv_price = parseFloat(top_kdv_price) +	parseFloat(document.getElementById('total_price'+r).value);
			}
		}
		if(top_kdv_price!='' && document.getElementById('expense') != undefined) document.getElementById('expense').value = commaSplit(top_kdv_price);
		if(top_price!='') document.getElementById('expense_net').value= commaSplit(top_price);
		if(my_money!='' && document.getElementById('money_currency') != undefined) document.getElementById('money_currency').value= my_money;
	}
</script> 
