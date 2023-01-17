<!---E.A select ifadeleri düzenlendi. 24.07.2012--->
<cfsetting showdebugoutput="no">
<cfquery name="GET_OPERATION_ROW" datasource="#DSN#">
	SELECT 
		SERVICE_OPE_ID,
		PRODUCT_ID,
		PRODUCT_NAME,
		AMOUNT,
		UNIT_ID,
		UNIT,
		PRICE,
		TOTAL_PRICE,
		STOCK_ID,
		CURRENCY,
		DETAIL,
		WRK_ROW_ID,
		START_DATE,
		FINISH_DATE,
		ROW_DETAIL,
		BRANCH_ID 
	
	FROM 
		ASSET_P_SERVICE_OPERATION 
	WHERE 
		ASSETP_ID = #attributes.assetp_id# AND IS_OUT = 0
</cfquery>
<cfquery name="GET_OPERATION_ROW_OLD" datasource="#DSN#">
	SELECT 
		SERVICE_OPE_ID,
		PRODUCT_ID,
		PRODUCT_NAME,
		AMOUNT,
		UNIT_ID,
		UNIT,
		PRICE,
		TOTAL_PRICE,
		STOCK_ID,
		CURRENCY,
		DETAIL,
		WRK_ROW_ID,
		START_DATE,
		FINISH_DATE,
		ROW_DETAIL,
		BRANCH_ID 
	FROM 
		ASSET_P_SERVICE_OPERATION 
	WHERE 
		ASSETP_ID = #attributes.assetp_id# AND 
		IS_OUT = 1
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE
		BRANCH_STATUS = 1
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfset operation_row = get_operation_row.recordcount>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
</cfquery>
	<table id="table1">
	<cfform name="add_service" method="post" action="#request.self#?fuseaction=call.emptypopup_upd_service_operation" onsubmit="return unformat_fields()">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#url.assetp_id#</cfoutput>">
		  <tr class="txtboldblue">
			<td width="15"><input type="button" class="eklebuton" title="Ekle" onClick="add_row();"></td>			
			<td width="90"><cf_get_lang dictionary_id="58467.Başlama"></td>
			<td width="90"><cf_get_lang dictionary_id="57502.Bitiş"></td>
			<td width="135"><cf_get_lang_main no='244.Ürün'></td>
			<td width="40"><cf_get_lang_main no='223.Miktar'></td>
			<td width="30"><cf_get_lang_main no='224.Birim'></td>
			<td width="60"><cf_get_lang dictionary_id="58084.Fiyat"></td>
			<td width="60"><cf_get_lang_main no='261.Tutar'></td>
			<td><cf_get_lang_main no='77.Para Br'></td>
			<td><cf_get_lang dictionary_id="57453.Şube"> *</td>
			<td><cf_get_lang_main no='217.Açıklama'></td>
			<td></td>
		  </tr>			
		<cfif get_operation_row.recordcount>    
        <cfoutput query="get_operation_row">
		  <tr id="frm_row#currentrow#">
			<td>
              <input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#WRK_ROW_ID#">
			  <input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
			  <a style="cursor:pointer" onClick="sil(#currentrow#);"><img src="images/delete_list.gif" alt="Sil" title="Sil" border="0" align="absmiddle"></a>
			</td>			
			<td>
			<cfsavecontent variable="message_startdate"><cf_get_lang dictionary_id="57655.Başlama Tarihi"></cfsavecontent>
			<cfinput type="text" name="start_date#currentrow#" value="#dateformat(start_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message_startdate#" style="width:65px;">
			<cf_wrk_date_image date_field="start_date#currentrow#">
			</td>
			<td>
			<cfsavecontent variable="message_finishdate"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
			<cfinput type="text" name="finish_date#currentrow#" value="#dateformat(finish_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message_finishdate#" style="width:65px;">
			<cf_wrk_date_image date_field="finish_date#currentrow#">
			</td>
			<td>
			  <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
			  <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
			  <input type="text" name="product#currentrow#" id="product#currentrow#" value="#detail#" style="width:125px;" onFocus="AutoComplete_Create('product#currentrow#','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id#currentrow#,stock_id#currentrow#','','3','125');" autocomplete="off">
              <a href="javascript://" onclick="pencere_ac_product('#currentrow#');"><img src="/images/plus_thin.gif" border="0" alt="" align="absmiddle"></a>
			</td>
            <td><cfset my_amount_ = replace(amount,'.',',')>
            	<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#my_amount_#" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp="FormatCurrency(this,event);" class="moneybox" style="width:40px;">
            </td>
			<td>
			  <input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="<cfif isdefined('unit_id')>#unit_id#</cfif>">
         	  <input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#unit#" readonly style="width:30px;">
			</td>
			<td><input type="text" name="price#currentrow#" id="price#currentrow#" value="#tlformat(price)#" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" style="width:60px;"></td>
            <td><input type="text" name="total_price#currentrow#" id="total_price#currentrow#" value="#tlformat(total_price)#" class="moneybox" onBlur="return toplam_kontrol();" onkeyup="return(FormatCurrency(this,event));" readonly style="width:60px;"></td>
            <td>
				<select name="money#currentrow#" id="money#currentrow#" style="width:65px;">
				<cfloop query="get_money">
					<option value="#get_money.money#" <cfif get_money.money is get_operation_row.currency>selected</cfif>>#get_money.money#</option>
				</cfloop>
				</select>
			</td>
			<td>
				<select name="branch_id#currentrow#" id="branch_id#currentrow#">
					<option value=""><cf_get_lang dictionary_id="57453.Şube"></option>
					<cfloop query="get_branches">
						<option value="#get_branches.branch_id#" <cfif get_branches.branch_id is get_operation_row.branch_id>selected</cfif>>#get_branches.branch_name#</option>
					</cfloop>
				</select>
			</td>
			<td><input type="text" value="#row_detail#" name="row_detail#currentrow#" id="row_detail#currentrow#" maxlength="250" style="width:65px;"></td>
			<td><input type="checkbox" value="#SERVICE_OPE_ID#" name="service_operation_id" id="service_operation_id"></td>
		  </tr>
		</cfoutput>
        </cfif>
        <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#operation_row#</cfoutput>">
	</table>
	<table>
	  <tr>
		<td class="txtboldblue"><cf_get_lang dictionary_id="29534.Toplam Tutar"> :</td>
		<td id="toplam_tutar">&nbsp;&nbsp;<cfoutput>#get_operation_row.currency#</cfoutput> </td>
	  </tr>
	</table>
	<table>
	  <tr>
		<td>
		<input type="button" onClick="gizle_goster(all_service_records);" value="Tüm Kayıtlar">
		<input type="button" onClick="send_to_invoice();" value="Faturala">
		<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol_asset_service()'></td>
	  </tr>
</cfform>
	</table>
	<br/>
	<table id="all_service_records" style="display:none;">
		  <tr class="txtboldblue">
			<td width="135"><cf_get_lang_main no='217.Açıklama'>/<cf_get_lang_main no='244.Ürün'></td>
			<td width="40"><cf_get_lang_main no='223.Miktar'></td>
			<td width="40"><cf_get_lang_main no='224.Birim'></td>
			<td width="80"><cf_get_lang dictionary_id="58084.Fiyat"></td>
			<td width="90"><cf_get_lang_main no='261.Tutar'></td>
			<td width="75"><cf_get_lang_main no='77.Para Br'></td>
		  </tr>
		  <cfif GET_OPERATION_ROW_OLD.recordcount>
		  <cfoutput query="GET_OPERATION_ROW_OLD">
		  <tr>
			<td>#product_name#</td>
			<td width="40">#amount#</td>
			<td width="40">#unit#</td>
			<td width="80">#tlformat(price)#</td>
			<td width="90">#tlformat(total_price)#</td>
			<td width="75">#currency#</td>
		  </tr>
		  </cfoutput>
		  <cfelse>
		  <tr>
		  	<td colspan="6"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</td>
		  </tr>
		  </cfif>
	</table>	  
	<script type="text/javascript">
	function send_to_invoice()
	{
		<cfif not get_operation_row.recordcount>
			alert("<cf_get_lang dictionary_id='54695.Faturalanacak İşlem Seçmelisiniz'>!");
			return false;
		</cfif>
		
		<cfif get_operation_row.recordcount eq 1>
			if(document.add_service.service_operation_id.checked == false)
				{
				alert("<cf_get_lang dictionary_id='54695.Faturalanacak İşlem Seçmelisiniz'>!");
				return false;
				}
			else
				{
				service_list_ = document.add_service.service_operation_id.value;
				}
		</cfif>
		
		<cfif get_operation_row.recordcount gt 1>
			service_list_ = "";
			for (i=0; i < document.add_service.service_operation_id.length; i++)
			{
				if(document.add_service.service_operation_id[i].checked == true)
					{
					service_list_ = service_list_ + document.add_service.service_operation_id[i].value + ',';
					}	
			}
			if(service_list_.length == 0)
				{
				alert("<cf_get_lang dictionary_id='54695.Faturalanacak İşlem Seçmelisiniz'>!");
				return false;
				}
		</cfif>
		document.add_service.action='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>';
		document.add_service.target='blank';
		document.add_service.submit();
	}
	
	row_count=<cfoutput>#operation_row#</cfoutput>;
	kontrol_row_count=<cfoutput>#operation_row#</cfoutput>;
	
	function add_row()
	{
		row_count++;
		kontrol_row_count++;
		var newRow;
		var newCell;
	
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
	
		document.add_service.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'"><input type="hidden" value="1" name="row_kontrol' + row_count + '"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" alt="Sil" border="0" align="absmiddle"></a>';				
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","start_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="start_date' + row_count +'" name="start_date' + row_count +'" maxlength="10" style="width:65px;" value="">';
		wrk_date_image('start_date' + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","finish_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="finish_date' + row_count +'" name="finish_date' + row_count +'" maxlength="10" style="width:65px;" value="">';
		wrk_date_image('finish_date' + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><input type="text" name="product' + row_count +'" id="product' + row_count +'" style="width:125px;" onFocus="autocomp_product('+row_count+');"><a href="javascript://" onClick="pencere_ac_product('+ row_count +');"><img src="/images/plus_thin.gif" alt="Ekle" border="0" align="absmiddle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value="" class="moneybox" onBlur="fiyat_hesapla(' + row_count + ');" style="width:40px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'"><input type="text" name="unit_name' + row_count +'" value="" readonly style="width:30px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="price' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:60px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_price' + row_count +'" value="" onBlur="toplam_kontrol(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:60px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="money' + row_count +'" style="width:65px;"><cfoutput query="get_money"><option value="#get_money.money#">#get_money.money#</option></cfoutput></select>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="branch_id' + row_count +'"><option value="">Şube</option><cfoutput query="get_branches"><option value="#branch_id#">#branch_name#</option></cfoutput></select>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" value="" maxlength="250" style="width:65px;">';
	}
	function autocomp_product(no)
	{
		AutoComplete_Create("product"+no,"PRODUCT_NAME","PRODUCT_NAME","get_product_autocomplete","0","PRODUCT_ID,STOCK_ID,MAIN_UNIT","product_id"+no+",stock_id"+no+",unit_name"+no+",product"+no+"","",3,125);
	}
	function sil(sy)
	{
		if(confirm("<cf_get_lang dictionary_id='54696.Satırı Kaldırmak İstediğinize Emin misiniz'>?"))
			{
			var my_element=eval("add_service.row_kontrol"+sy);		
			my_element.value=0;
			
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			}
	}
	
	function pencere_ac_product(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_unit&field_stock_id=add_service.stock_id'+ no +'&field_id=add_service.product_id'+ no +'&field_name=add_service.product'+ no +'&field_amount=add_service.amount'+ no +'&field_unit_id=add_service.unit_id'+ no+'&field_unit=add_service.unit_name'+ no+'&field_price=add_service.price'+ no+'&field_total_price=add_service.total_price'+ no+'&field_money=add_service.money'+ no,'list');
	}	
	
	function kontrol_asset_service()
	{
		if(row_count == 0 || kontrol_row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='54697.En Az Bir Servis İşlem Kaydı Girmelisiniz'>!");
			return false;
		}
		
		static_row=0;
		for(r=1;r<=row_count;r++)		
		{
			if(eval("document.add_service.row_kontrol"+r).value == 1)
			{	
				static_row++;
				deger_start_date = eval("document.add_service.start_date"+r);
				deger_finish_date = eval("document.add_service.finish_date"+r);
				deger_product_id = eval("document.add_service.product_id"+r);
				deger_amount = eval("document.add_service.amount"+r);
				deger_price = eval("document.add_service.price"+r);
				deger_total_price = eval("document.add_service.total_price"+r);
				deger_branch_id = eval("document.add_service.branch_id"+r);
				
				if(deger_start_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> <cf_get_lang dictionary_id='58230.Satır No'>:" +static_row+"");
					return false;
				}
				
				if(deger_finish_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>:" +static_row+"");
					return false;
				}
				
				if(deger_product_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='37331.Ürün Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No:'>" +static_row+"");
					return false;
				}
				
				if(deger_amount.value=="")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='48404.Miktar Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>:" +static_row+"");
					return false;
				}

				if(deger_price.value=="")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='54619.Tutar Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>:" +static_row+"");
					return false;
				}
				
				if(deger_total_price.value=="")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='33575.Toplam Tutar Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>" +static_row+"");
					return false;
				}
				
				if(deger_branch_id.value=="")
				{
					alert("<cf_get_lang dictionary_id='54704.Eksik Veri'>: <cf_get_lang dictionary_id='48083.Şube Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>" +static_row+"");
					return false;
				}
			}
		}
		document.add_service.action='<cfoutput>#request.self#?fuseaction=call.emptypopup_upd_service_operation</cfoutput>';
		document.add_service.target='_self';
		return true;
	}
	
	function fiyat_hesapla(satir)
	{
		if(eval("document.add_service.price"+satir).value.length != 0 && eval("document.add_service.amount"+satir).value.length != 0)
		{
			eval("document.add_service.total_price" + satir).value =  filterNum(eval("document.add_service.price"+satir).value) * filterNum(eval("document.add_service.amount"+satir).value);
			eval("document.add_service.total_price" + satir).value = commaSplit(eval("document.add_service.total_price" + satir).value);
		}
		toplam_kontrol();
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=row_count;r++)
		{
			if(eval("document.add_service.row_kontrol"+r).value == 1)
			{
				fiyat_hesapla(r);
				eval("document.add_service.amount"+r).value = filterNum(eval("document.add_service.amount"+r).value);
				eval("document.add_service.price"+r).value = filterNum(eval("document.add_service.price"+r).value);
				eval("document.add_service.total_price"+r).value = filterNum(eval("document.add_service.total_price"+r).value);
			}
		}
		return true;
	}
	
	function toplam_kontrol()
		{	
			var sira_no=0;
			sira_no=row_count;
			toplam_al(sira_no);
			return true;
		}
	
	function toplam_al(sira)
		{	
			var toplam_1=0;
			for(var i=1; i <= sira; i++)
				if(eval("document.add_service.row_kontrol"+i).value > 0)
					{
					var ara_toplam=filterNum(eval("document.add_service.total_price"+i).value);
					if(ara_toplam!= null && ara_toplam.value != "")
						{
							deger_money = eval("document.add_service.money"+i);
							toplam_1 = toplam_1 + (parseFloat(ara_toplam));
						}
					}
			document.getElementById('toplam_tutar').innerHTML=commaSplit(toplam_1);
		}
	toplam_kontrol();
	</script>
