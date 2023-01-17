<cfquery name="get_price_cats" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>

<cfif isdefined("attributes.camp_id") and Len(attributes.camp_id)>
	<cfquery name="get_camp_info" datasource="#dsn3#">
		SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
	<cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
	<cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
	<cfset camp_id = get_camp_info.camp_id>
	<cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,dateformat_style)#-#dateformat(camp_finish,dateformat_style)#)'>
<cfelse>
	<cfset camp_start = ''>
	<cfset camp_finish = ''>
	<cfset camp_id = ''>
	<cfset camp_head = ''>
</cfif>
<script type="text/javascript">
	<cfoutput>
		start_date = "#dateformat(camp_start,dateformat_style)#";
		finish_date = "#dateformat(camp_finish,dateformat_style)#"; 
		
		stock_id = "<cfif isDefined("attributes.prom_stock_id") and Len(attributes.prom_stock_id)>#attributes.prom_stock_id#</cfif>";
		product_id = "<cfif isDefined("attributes.prom_product_id") and Len(attributes.prom_product_id)>#attributes.prom_product_id#</cfif>";
		product_name = "<cfif isDefined("attributes.prom_product_name") and Len(attributes.prom_product_name)>#attributes.prom_product_name#</cfif>";
		prom_head = "<cfif isDefined("attributes.prom_product_head") and Len(attributes.prom_product_head)>#attributes.prom_product_head#</cfif>";
		price_cat = "<cfif isDefined("attributes.prom_product_cat") and Len(attributes.prom_product_cat)>#attributes.prom_product_cat#</cfif>";
		amount = "<cfif isDefined("attributes.prom_amount") and Len(attributes.prom_amount)>#attributes.prom_amount#<cfelse>1</cfif>";
		free_stock_id = "<cfif isDefined("attributes.prom_free_stock_id") and Len(attributes.prom_free_stock_id)>#attributes.prom_free_stock_id#</cfif>";
		free_product_id = "<cfif isDefined("attributes.prom_free_product_id") and Len(attributes.prom_free_product_id)>#attributes.prom_free_product_id#</cfif>";
		free_product_name = "<cfif isDefined("attributes.prom_free_product_name") and Len(attributes.prom_free_product_name)>#attributes.prom_free_product_name#</cfif>";
		free_amount = "<cfif isDefined("attributes.prom_free_amount") and Len(attributes.prom_free_amount)>#attributes.prom_free_amount#<cfelse>1</cfif>";
		invoice_value = "<cfif isDefined("attributes.prom_invoice_value") and Len(attributes.prom_invoice_value)>#attributes.prom_invoice_value#<cfelse>0</cfif>";
		cost_value = "<cfif isDefined("attributes.prom_cost_value") and Len(attributes.prom_cost_value)>#attributes.prom_cost_value#<cfelse>0</cfif>";
		percent_discount = "<cfif isDefined("attributes.prom_percent_discount") and Len(attributes.prom_percent_discount)>#attributes.prom_percent_discount#<cfelse>0</cfif>";
		value_discount = "<cfif isDefined("attributes.prom_value_discount") and Len(attributes.prom_value_discount)>#attributes.prom_value_discount#<cfelse>0</cfif>";
		row_count = "<cfif isDefined("attributes.prom_row_count") and Len(attributes.prom_row_count)>#attributes.prom_row_count#</cfif>";
		row_count++;
		var newRow;
		var newCell;
		newRow = window.opener.document.getElementById("table1").insertRow(window.opener.document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.className = 'color-row';
		window.opener.document.getElementById("record_num").value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="0" name="prom_id' + row_count +'"><input type="hidden" value="1" name="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');" title="<cf_get_lang_main no ="1559.Satır Sil">"><i class="fa fa-minus" ></i></a><a style="cursor:pointer" onclick="copy_row(' + row_count + ');" title="<cf_get_lang_main no ="1560.Satır Kopyala">"> <i class="fa fa-copy"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="product_id' + row_count +'" value="' + product_id + '"><input type="hidden" name="stock_id' + row_count +'" value="' + stock_id + '"><input type="text" style="width:140px;" name="product_name' + row_count +'" value="' + product_name + '"><span class="input-group-addon icon-ellipsis"  onclick="pencere_ac_product_detail('+ row_count +');" align="absmiddle" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="prom_head' + row_count +'" style="width:120px;" maxlength="100" value="' + prom_head + '">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="price_cat' + row_count +'" style="width:200px;"><option value="-2" selected><cf_get_lang_main no="1309.Standart Satış"></option><cfloop query="get_price_cats"><option value="#price_catid#">#price_cat#</option></cfloop></select>';
		if(price_cat != undefined && price_cat != '') 
		{
				price_cat_new = eval('add_prom.price_cat'+ row_count);				
				for(var inf_count_=0; inf_count_ < price_cat_new.options.length; inf_count_++)
					if(price_cat_new.options[inf_count_].value == price_cat)
						eval('add_prom.price_cat'+ row_count).selectedIndex = inf_count_;
		}
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="start_date' + row_count +'" id="start_date' + row_count +'" maxlength="10" value="' + start_date + '" ><span class="input-group-addon" id="start_date' + row_count + '_td"></span></div></div> ';
		window.opener.wrk_date_image('start_date' + row_count);		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="finish_date' + row_count +'" id="finish_date' + row_count +'" maxlength="10" value="' + finish_date + '"><span class="input-group-addon" id="finish_date' + row_count + '_td"></span></div></div> ';
		window.opener.wrk_date_image('finish_date' + row_count);	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="amount' + row_count +'" value="' + amount + '" onkeyup="return(FormatCurrency(this,event));" style="text-align:right;width:60px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="free_product_id' + row_count +'" value="' + free_product_id + '"><input type="hidden" name="free_stock_id' + row_count +'" value="' + free_stock_id + '"><input type="text" style="width:140px;" name="free_product_name' + row_count +'" value="' + free_product_name + '"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_free_product('+ row_count +');" align="absmiddle" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="free_amount' + row_count +'" value="' + free_amount + '" onkeyup="return(FormatCurrency(this,event));" style="text-align:right;width:60px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'1\';">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="invoice_value' + row_count +'" value="' + invoice_value + '" onkeyup="return(FormatCurrency(this,event));"style="text-align:right;width:70px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_value' + row_count +'" value="' + cost_value + '" onkeyup="return(FormatCurrency(this,event));" style="text-align:right;width:70px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="percent_discount' + row_count +'" value="' + percent_discount + '" onkeyup="return(FormatCurrency(this,event));" style="text-align:right;width:70px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="value_discount' + row_count +'" value="' + value_discount + '" onkeyup="return(FormatCurrency(this,event));" style="text-align:right;width:70px;" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = \'0\';">';
	//window.close();
		window.location.href = '#request.self#?fuseaction=objects.popup_product_names&is_collacted_prom=1&is_form_submitted=1&record_num='+row_count+'<cfif isDefined('attributes.camp_id') and len(attributes.camp_id)>&camp_id=#attributes.camp_id#</cfif>&page=#attributes.prom_page#&maxrows=#attributes.prom_maxrows#&keyword=#attributes.keyword#&barcod=#attributes.barcod#&product_cat_code=#attributes.product_cat_code#&product_cat=#attributes.product_cat#';
		</cfoutput>

</script>
