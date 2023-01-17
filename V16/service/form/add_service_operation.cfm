<cfif is_other_customer_services eq 1>
	<cfsavecontent variable="text"><cf_get_lang no='243.Servis İşlemleri'></cfsavecontent>
	<cf_box title="#text#" closable="0">
		<cf_ajax_list>
        	<tbody>
                <tr>
                    <td>
                        <cfoutput>
                            <cfif len(attributes.employee_id)>
                                <a href="#request.self#?fuseaction=service.list_service&employee_id=#attributes.employee_id##str_link#" class="tableyazi"><cf_get_lang no='28.Üyeye Ait Diğer Servis Başvuruları'></a>
                            <cfelseif len(attributes.partner_id)>
                                <a href="#request.self#?fuseaction=service.list_service&partner_id=#attributes.partner_id##str_link#" class="tableyazi"><cf_get_lang no='28.Üyeye Ait Diğer Servis Başvuruları'></a>
                            <cfelseif len(attributes.consumer_id)>
                                <a href="#request.self#?fuseaction=service.list_service&consumer_id=#attributes.consumer_id##str_link#" class="tableyazi"><cf_get_lang no='28.Üyeye Ait Diğer Servis Başvuruları'></a>
                            <cfelse>
                                <cf_get_lang_main no='72.Kayıt Yok'>!
                            </cfif>
                        </cfoutput>
                    </td>
                </tr>
			</tbody>
        </cf_ajax_list>
	</cf_box>
</cfif>
<cfif x_select_amount and len(get_service_detail.subscription_id)>
	<cfset subscription_id = get_service_detail.subscription_id>
<cfelse>
	<cfset subscription_id = "">
</cfif>
<cfquery name="GET_SERVICE_SPARE_PART" datasource="#DSN3#">
	SELECT SPARE_PART,SPARE_PART_ID FROM SERVICE_SPARE_PART
</cfquery>
<cfquery name="GET_OPERATION_ROW" datasource="#DSN3#">
	SELECT * FROM SERVICE_OPERATION WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfset operation_row = get_operation_row.recordcount>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY DESC
</cfquery>
<!--- Şirket Akış Parametreleri - Garanti Takip Tamir ve Seri No Uygulansın Mı Seçeneğine Bağlı Olarak Seri No Alanini Getirir --->
<cfquery name="get_our_comp_info" datasource="#dsn#">
	SELECT IS_GUARANTY_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfsavecontent variable="text"><cf_get_lang no='38.Ürün Servis İşlemleri'></cfsavecontent>
<cf_box title="#text#" closable="0">
<cfform name="add_service" id="add_service" method="post" action="#request.self#?fuseaction=service.emptypopup_upd_service_operation" onsubmit="return unformat_fields();">
    <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#url.service_id#</cfoutput>">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
    <input type="hidden" name="convert_spect_id" id="convert_spect_id" value="">
    <input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
    <input type="hidden" name="convert_price" id="convert_price" value="">
    <input type="hidden" name="convert_price_other" id="convert_price_other" value="">
    <input type="hidden" name="convert_money" id="convert_money" value="">
    <input type="hidden" name="convert_cost_price" id="convert_cost_price" value="" />
    <input type="hidden" name="convert_extra_cost" id="convert_extra_cost" value="" />
    <!--- <input type="hidden" name="process_cat_id" id="process_cat_id" value="23" /> id gonderilir mi, sabit bir deger degilki??????? FBS20130322 --->
    <input type="hidden" name="record_num" id="record_num" value="">
    <cf_form_list>
        <thead>
            <tr>
                <th style="width:15px;"><input type="button" class="eklebuton" title="Ekle" onClick="add_row();"></th>			
                <th><cf_get_lang_main no='280.İşlem'>*</th>
                <cfif x_select_employee neq 0>
                    <th><cf_get_lang no='2.İşlemi Yapan'><cfif x_select_employee eq 2>*</cfif></th>
                </cfif>
				<cfif get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
               	 <th><cf_get_lang_main no='225.Seri No'></th>
				</cfif>
                <th><cf_get_lang_main no='217.Açıklama'>/<cf_get_lang_main no='245.Ürün'></th>
                <cfif x_select_amount eq 1>
                    <th style="width:40px;"><cf_get_lang_main no='223.Miktar'></th>
                </cfif>
                <cfif x_select_unit eq 1>
                    <th style="width:40px;"><cf_get_lang_main no='224.Birim'></th>
                </cfif>
                <th><cf_get_lang_main no='672.Fiyat'></th>
                <th><cf_get_lang_main no='261.Tutar'></th>
                <th style="width:90px;"><cf_get_lang_main no='77.Para Br'></th>
                <th style="width:90px;"><cf_get_lang no='7.Toplama Dahil'></th>
                <th style="width:50px;"><cf_get_lang_main no='1264.Aktar'></th>
            </tr>	
        </thead>		
        <tbody id="table1">
        <cfif get_operation_row.recordcount>
            <cfoutput query="get_operation_row">
            <tr id="frm_row#currentrow#">
                <td>
                    <input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <a style="cursor:pointer" onClick="sil(#currentrow#);"><img src="images/delete_list.gif" title="Sil" border="0" align="absbottom"></a>
                </td>			
                <td>
                    <cf_wrk_selectlang 
                        name="spare_part_type#currentrow#"
                        width="100"
                        table_name="SERVICE_SPARE_PART"
                        option_name="SPARE_PART"
                        option_value="SPARE_PART_ID"
                        data_source="#DSN3#"
                        value="#spare_part_id#">
                </td>
                <cfif x_select_employee neq 0>
                    <td>
                        <input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="#service_emp_id#">
                        <input type="text" name="employee_name_#currentrow#" id="employee_name_#currentrow#" value="#get_emp_info(service_emp_id,0,0)#" onFocus="autocomp_employee(#currentrow#);" class="text" style="width:120px;">
                        <a href="javascript://" onClick="pencere_ac_employee1(#currentrow#);"><img src="/images/plus_thin.gif"  align="absbottom" border="0" title="<cf_get_lang_main no='322.Seçiniz'>"></a>
                    </td>
                </cfif>
				<cfif  get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
                	<td><input type="text" name="serial_no_#currentrow#" id="serial_no_#currentrow#" value="<cfif len(serial_no)>#serial_no#</cfif>" onkeydown="if(event.keyCode == 13) {get_product_detail(this.value,#currentrow#);return false;}" style="width:100px;" autocomplete="off"></td>
				</cfif>
                <td>
                	<input type="hidden" name="product_catid#currentrow#" id="product_catid#currentrow#" value="" />
                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#" onfocus="getir();">
                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                    <input type="text" name="product#currentrow#" id="product#currentrow#" value="#detail#" onFocus="AutoComplete_Create('product#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0,0,-2','PRODUCT_ID,STOCK_ID,PRODUCT_UNIT_ID,MAIN_UNIT,PRODUCT_CATID,PRICE,PRICE,RATE2','product_id#currentrow#,stock_id#currentrow#,unit_id#currentrow#,unit_name#currentrow#,product_catid#currentrow#,price#currentrow#,total_price#currentrow#,money#currentrow#','add_services',1,'','get_service_cat(#currentrow#)');" style="width:120px;">
                    <a href="javascript://" onclick="pencere_ac_product('#currentrow#');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#','list');"><img src="/images/plus_thin_p.gif"  align="absbottom" border="0" title="<cf_get_lang_main no='322.Seçiniz'>"></a>
                </td>
                <cfif x_select_amount eq 1>
                    <td><cfset my_amount_ = replace(amount,'.',',')>
                        <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#my_amount_#" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp="FormatCurrency(this,event);" class="moneybox" style="width:40px;">
                    </td>
                </cfif>
                <cfif x_select_unit eq 1>
                    <td>
                        <input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="<cfif isdefined('unit_id')>#unit_id#</cfif>">
                        <input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#unit#" readonly style="width:40px;">
                    </td>
                </cfif>
                <td><input type="text" name="price#currentrow#" id="price#currentrow#" value="#tlformat(price)#" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" style="width:60px;" <cfif x_change_price eq 1>readonly</cfif>></td>
                <td><input type="text" name="total_price#currentrow#" id="total_price#currentrow#" value="#tlformat(total_price)#" onBlur="return toplam_kontrol();" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly  style="width:60px;"></td>
                <td>
                    <select name="money#currentrow#" id="money#currentrow#" style="width:80px;" onchange="toplam_kontrol(#currentrow#);">
                        <cfset get_setup_money_id = trim(get_operation_row.currency)>
                        <cfloop query="get_money">
                            <option value="#money#;#rate1#;#rate2#" <cfif get_money.money eq get_setup_money_id>selected</cfif>>#get_money.money#</option>
                        </cfloop>
                    </select>
                </td>
                <td><input type="checkbox" name="is_total#currentrow#" id="is_total#currentrow#" value="1" onclick=" fiyat_hesapla('#currentrow#');" <cfif is_total eq 1>checked</cfif>></td>
                <td><input type="checkbox" name="service_operation_id" id="service_operation_id#currentrow#" value="#service_ope_id#"></td>
            </tr>
            <tr id="frm_row_#currentrow#" style="display:none">
                <td colspan="3"></td>
                <td><div id="check_product_layer#currentrow#" style="width:200px;position:absolute;"></div></td>
                <td colspan="8"></td>
            </tr>
            </cfoutput>
        </cfif>
        </tbody>
        <tfoot>
            <div id="add_specify_"></div>
            <tr>
                <td class="txtbold" colspan="2"><cf_get_lang_main no='1737.Toplam Tutar'> :</td>
                <td colspan="10"><input type="text" name="toplam_tutar"  id="toplam_tutar" value="" style="width:100px;" readonly="" class="box">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput> </td>
            </tr>
            <tr>
                <td colspan="12">
                	<cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='0' add_function='kontrol()' type_format="1">
                    <cfif session.ep.our_company_info.subscription_contract eq 1 and x_send_to_subscription eq 1>
                        <input type="button" value="<cf_get_lang no='9.Sisteme Aktar'>" onclick="sendToSubscription();"/>
                    </cfif>
                    <input type="button" value="<cf_get_lang no='12.İrsaliyeye Aktar'>" onclick="sendToShip();"/>
                    <input type="button" value="Sarf Fişi Oluştur" onclick="sendToFis();"/>
                    <input type="button" value="İç Talep Oluştur" onclick="addOrder();"/>
                </td>
            </tr>
        </tfoot>
    </cf_form_list> 
</cfform>
</cf_box>
<script type="text/javascript">
	row_count=<cfoutput>#operation_row#</cfoutput>;
	kontrol_row_count=<cfoutput>#operation_row#</cfoutput>;
	document.getElementById('record_num').value = row_count;
	
	function getir()
	{
		alert('ss');	
	}
	function pencere_ac_employee1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_service.employee_id_' + no +'&field_name=add_service.employee_name_' + no +'&select_list=1,9','list');
	}

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
		newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'"><input type="hidden" value="1" name="row_kontrol' + row_count + '"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" alt="Sil" border="0" align="absbottom"></a>';				
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="spare_part_type' + row_count + '" name="spare_part_type' + row_count + '" style="width:100px;"><option value="">Seçiniz</option><cfoutput query="GET_SERVICE_SPARE_PART" ><option value="#GET_SERVICE_SPARE_PART.SPARE_PART_ID#" >#GET_SERVICE_SPARE_PART.SPARE_PART#</option></cfoutput></select>';
	
		<cfif x_select_employee neq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" id="employee_id_' + row_count +'" name="employee_id_' + row_count +'" value="<cfoutput>#session.ep.userid#</cfoutput>"><input type="text" id="employee_name_' + row_count +'" name="employee_name_' + row_count +'" style="width:120px;" onFocus="autocomp_employee('+row_count+');"  value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">&nbsp;<a onclick="javascript:pencere_ac_employee1(' + row_count + ');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		</cfif>
		<cfif  get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="serial_no_' + row_count +'" id="serial_no_' + row_count +'" style="width:100px;" autocomplete="off" onkeydown="if(event.keyCode == 13) {get_product_detail(this.value,'+row_count+');return false;}">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_catid' + row_count +'" id="product_catid' + row_count +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><input type="text" name="product' + row_count +'" id="product' + row_count +'"  onFocus="autocomp_product('+row_count+');" style="width:120px;">&nbsp;<a onclick="javascript:pencere_ac_product(' + row_count + ');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		
		<cfif x_select_amount eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="amount' + row_count +'" id="amount' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value="1" class="moneybox" onBlur="fiyat_hesapla(' + row_count + ');" style="width:40px;">';
		</cfif>
		
		<cfif x_select_unit eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text" name="unit_name' + row_count +'" id="unit_name' + row_count +'" value="" readonly style="width:40px;">';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="price' + row_count +'" id="price' + row_count +'" value="" <cfif x_change_price eq 1>readonly</cfif> onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:60px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_price' + row_count +'" id="total_price' + row_count +'" value="" onBlur="toplam_kontrol(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:60px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="money' + row_count +'" id="money' + row_count +'" style="width:80px;" onchange="toplam_kontrol(' + row_count + ');"><cfoutput query="get_money"><option value="#get_money.money#;#rate1#;#rate2#">#get_money.money#</option></cfoutput></select>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" value="1" name="is_total' + row_count + '" id="is_total' + row_count + '" onclick=" fiyat_hesapla(' + row_count + ');" checked>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" value="1" name="service_operation_id' + row_count + '" id="service_operation_id' + row_count + '" checked>';
	
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row_" + row_count);
		newRow.setAttribute("id","frm_row_" + row_count);
		newRow.style.display = 'none';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('colSpan', '3');
		newCell.innerHTML = '&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div id="check_product_layer'+row_count+'" style="width:200px;position:absolute;"></div>&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('colSpan', '8');
		newCell.innerHTML = '&nbsp;';
	
	}
	
	function sil(sy)
	{
		var my_element=eval("add_service.row_kontrol"+sy);		
		my_element.value=0;
		
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_kontrol()
	}
	
	function pencere_ac_product(no)
	{
		<cfif x_prod_calc_sub_contract and len(attributes.subscription_id)>
			SBR_VALUE = <cfoutput>#attributes.subscription_id#</cfoutput>;
			sbr = '&subscription_id='+SBR_VALUE;
		<cfelse>
			sbr = '';
		</cfif>
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_price_unit'+ sbr+'&company_id=#attributes.company_id#</cfoutput>&field_stock_id=add_service.stock_id'+ no +'&field_id=add_service.product_id'+ no +'&field_name=add_service.product'+ no +'&field_amount=add_service.amount'+ no +'&field_unit_id=add_service.unit_id'+ no+'&field_unit=add_service.unit_name'+ no+'&field_price=add_service.price'+ no+'&field_total_price=add_service.total_price'+ no+'&field_money_rate=add_service.money'+ no+'&field_product_catid=add_service.product_catid'+ no+'&count='+no,'list');
	}	
	
	function pencere_ac_date(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_service.operation_date' + no,'date');
	}	
	
	function kontrol()
	{
		if(row_count == 0 || kontrol_row_count == 0)
		{
			alert("En Az Bir Servis İşlem Kaydı Girmelisiniz !");
			return false;
		}
		
		static_row=0;
		for(r=1;r<=row_count;r++)		
		{
			if(eval("document.add_service.row_kontrol"+r).value == 1)
			{	
				static_row++;
				deger_product_id = eval("document.add_service.product_id"+r);
				deger_spare_part_type = eval("document.add_service.spare_part_type"+r);
				if(deger_spare_part_type.value=="")
				{
					alert(static_row+".Satır İşlem Seçmelisiniz !");
					return false;
				}			
				<cfif x_select_employee eq 2>
					if(eval("document.add_service.employee_id_"+r).value=="" || eval("document.add_service.employee_name_"+r).value=="")
					{
						alert(static_row+".Satır İşlem Yapan Girmelisiniz !");
						return false;
					}
				</cfif>
				if(eval("document.add_service.product_id"+r).value=="" || eval("document.add_service.product"+r).value=="")
				{
					alert(static_row+".Satır Ürün Girmelisiniz !");
					return false;
				}
				<cfif x_select_amount eq 1>
					deger_amount = eval("document.add_service.amount"+r);
					if(deger_amount.value=="")
					{
						alert(static_row+".Satır Miktar Girmelisiniz !");
						return false;
					}
				</cfif>
			}
		}
		return true;
	}
	
	function autocomp_employee(no)
	{
		AutoComplete_Create("employee_name_"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","3","EMPLOYEE_ID","employee_id_"+no,"",3,140);
	}
	
	function autocomp_product(no)
	{
		AutoComplete_Create("product"+no,"PRODUCT_NAME","PRODUCT_NAME,STOCK_CODE","get_product_autocomplete","0,0,-2","PRODUCT_ID,STOCK_ID,PRODUCT_UNIT_ID,MAIN_UNIT,PRODUCT_CATID,PRICE,PRICE,RATE2","product_id"+no+",stock_id"+no+",unit_id"+no+",unit_name"+no+",product_catid"+no+",price"+no+",total_price"+no+",money"+no,"add_services",1,"","get_service_cat("+no+")");
		
	}
	
	function fiyat_hesapla(satir)
	{
		<cfif x_select_amount eq 1>
			amount_ = filterNum(eval("add_service.amount"+satir).value);
		<cfelse>
			amount_ = 1;
		</cfif>
		if(eval("add_service.price"+satir).value.length != 0 && eval("add_service.is_total"+satir).checked==true)
		{
			eval("document.add_service.total_price" + satir).value =  parseFloat(filterNum(eval("document.add_service.price"+satir).value) * amount_);
			eval("add_service.total_price" + satir).value = commaSplit(eval("add_service.total_price" + satir).value);
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
				<cfif x_select_amount eq 1>
					eval("document.add_service.amount"+r).value = filterNum(eval("document.add_service.amount"+r).value);
				</cfif>
				eval("document.add_service.price"+r).value = filterNum(eval("document.add_service.price"+r).value);
				eval("document.add_service.total_price"+r).value = filterNum(eval("document.add_service.total_price"+r).value);
			}
		}
	}
	
	function toplam_kontrol()
		{	
			var sira_no=0;
			sira_no=document.add_service.record_num.value;
			toplam_al(sira_no);
			return true;
		}
	
	function toplam_al(sira)
	{	
		document.add_service.toplam_tutar.value=0;
		var toplam_1=0;
		for(var i=1; i <= sira; i++)
			if(eval("add_service.row_kontrol"+i).value > 0 && eval("add_service.is_total"+i).checked==true)
				{
					if(eval("document.add_service.total_price"+i).value != '')
					{
						var ara_toplam=filterNum(eval("document.add_service.total_price"+i).value);
						if(ara_toplam!= null && ara_toplam.value != "")
						{
							deger_money = eval("document.add_service.money"+i);
							toplam_1 = parseFloat(toplam_1 + (parseFloat(ara_toplam) * (parseFloat(list_getat(deger_money.value,3,';')) / parseFloat(list_getat(deger_money.value,2,';')))));
							document.add_service.toplam_tutar.value=commaSplit(toplam_1);
						}
					}
				}
		
	}
	toplam_kontrol();
	
	function sendToSubscription()
		{
			if(document.upd_service.subscription_id != undefined && (document.upd_service.subscription_id.value == '' || document.upd_service.subscription_no.value == ''))
			{
				alert('Sistem Seçmelisiniz!');
				return false;
			}
			<cfif not get_operation_row.recordcount>
				alert('Sisteme Aktarılacak İşlem Seçmelisiniz!');
				return false;
			</cfif>
			
			<cfif get_operation_row.recordcount eq 1>
				if(document.add_service.service_operation_id.checked == false)
				{
					alert('Sisteme Aktarılacak İşlem Seçmelisiniz!');
					return false;
				}
				else
				{
					service_list_ = document.add_service.service_operation_id.value;
				}
			</cfif>
			<cfif get_operation_row.recordcount gt 1>
				service_list_ = "";
				for (i=0; i <document.add_service.service_operation_id.length;  i++)
				{
					if(document.add_service.service_operation_id[i].checked == true)
						{
						service_list_ = service_list_ + document.add_service.service_operation_id[i].value + ',';
						}	
				}
				if(service_list_.length == 0)
					{
					alert('Sisteme Aktarılacak İşlem Seçmelisiniz!');
					return false;
					}
			</cfif>
			document.add_service.action='<cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id='+document.upd_service.subscription_id.value</cfoutput>;
			document.add_service.target='blank';
			document.add_service.submit();
		}
		
	function sendToShip()
		{
			<cfif not get_operation_row.recordcount>
				alert('İrsaliye Kesilecek İşlem Seçmelisiniz!');
				return false;
			</cfif>
			<cfif get_operation_row.recordcount eq 1>
				if(document.add_service.service_operation_id.checked == false)
					{
					alert('İrsaliye Kesilecek İşlem Seçmelisiniz!');
					return false;
					}
				else
					{
					service_list_ = document.add_service.service_operation_id.value;
					}
			</cfif>
			<cfif get_operation_row.recordcount gt 1>
				service_list_ = "";
				for (i=0; i <document.add_service.service_operation_id.length;  i++)
				{
					if(document.add_service.service_operation_id[i].checked == true)
						{
						service_list_ = service_list_ + document.add_service.service_operation_id[i].value + ',';
						}	
				}
				if(service_list_.length == 0)
					{
					alert('İrsaliye Kesilecek İşlem Seçmelisiniz!');
					return false;
					}
			</cfif>
			windowopen('','wide','ship_window');
			document.add_service.action='<cfoutput>#request.self#?fuseaction=service.popup_add_sale_ship&is_from_operations=1&service_ids=#attributes.service_id#</cfoutput>';
			document.add_service.target='ship_window';
			document.add_service.submit();
		}
		
	function sendToFis()
		{
			 var convert_list = "";
			 var convert_list_amount = "";
			 var convert_list_price = "";
			 var convert_list_price_other = "";
			 var convert_list_money = "";
			 var convert_cost_price = "";
			 var convert_extra_cost = "";
			 for(var i =1 ; i<=document.getElementById('record_num').value; ++i)
			 {
				 if(document.getElementById('amount'+i) != undefined && filterNum(document.getElementById('amount'+i).value) > 0)
				 {
					convert_list += document.getElementById('stock_id'+i).value+",";
					convert_list_amount += filterNum(document.getElementById('amount'+i).value,3)+',';
					convert_list_price_other += 0+',';
					convert_list_price += filterNum(document.getElementById('price'+i).value,3)+',';
					convert_cost_price += 0+',';
					convert_extra_cost += 0+',';
					convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
				 }
			 }
				
			document.getElementById('convert_stocks_id').value = convert_list;
			document.getElementById('convert_amount_stocks_id').value = convert_list_amount;
			document.getElementById('convert_price').value = convert_list_price;
			document.getElementById('convert_price_other').value = convert_list_price_other;
			document.getElementById('convert_money').value = convert_list_money;
			document.getElementById('convert_cost_price').value = convert_cost_price;
			document.getElementById('convert_extra_cost').value = convert_extra_cost;
	
			document.getElementById('add_service').action="<cfoutput>#request.self#?fuseaction=stock.form_add_fis&type=convert&service_id=#attributes.service_id#&service=#URLEncodedFormat(get_service_detail.service_no)#</cfoutput>";
			document.getElementById('add_service').submit();
			return true;
		}
		
	function addOrder()
	{
		var convert_list = "";
		var convert_list_amount = "";
		var convert_list_price = "";
		var convert_list_price_other = "";
		var convert_list_money = "";
		var convert_cost_price = "";
		var convert_extra_cost = "";
		
		<cfif get_operation_row.recordcount eq 1>
				if(document.add_service.service_operation_id.checked == false)
					{
					alert('İç Talep Oluşturulacak İşlem Seçmelisiniz!');
					return false;
					}
				else
					{
					service_list_ = document.add_service.service_operation_id.value;
					}
			</cfif>
			<cfif get_operation_row.recordcount gt 1>
				service_list_ = "";
				for (i=0; i <document.add_service.service_operation_id.length;  i++)
				{
					if(document.add_service.service_operation_id[i].checked == true)
						{
						service_list_ = service_list_ + document.add_service.service_operation_id[i].value + ',';
						}	
				}
				if(service_list_.length == 0)
					{
					alert('İç Talep Oluşturulacak İşlem Seçmelisiniz!');
					return false;
					}
			</cfif>
	
		for(var i =1 ; i<=document.getElementById('record_num').value; ++i)
		{
			if(filterNum(document.getElementById('amount'+i).value) > 0)
			{
				convert_list += document.getElementById('stock_id'+i).value+",";
				convert_list_amount += filterNum(document.getElementById('amount'+i).value,3)+',';
				convert_list_price_other += 0+',';
				//convert_list_price += filterNum(document.getElementById('price'+i).value,3)+',';
				convert_list_price += filterNum(document.getElementById('price'+i).value)+',';
				convert_extra_cost += 0+',';
				convert_list_money += list_getat(document.getElementById('money'+i).value,1,';')+',';
			}
		}
		
		document.getElementById('convert_stocks_id').value = convert_list;
		document.getElementById('convert_amount_stocks_id').value = convert_list_amount;
		document.getElementById('convert_price').value = convert_list_price;
		document.getElementById('convert_price_other').value = convert_list_price_other;
		document.getElementById('convert_money').value = convert_list_money;
		document.getElementById('convert_cost_price').value = convert_cost_price;
		document.getElementById('convert_extra_cost').value = convert_extra_cost;
	
		document.getElementById('add_service').action="<cfoutput>#request.self#?fuseaction=purchase.list_internaldemand&event=add&type=convert&service_id=#attributes.service_id#</cfoutput>";
		document.getElementById('add_service').submit();
		return true;
		
	}
	
	function get_product_detail(this_serial_no,row_number)
	{
		var div_name_ = 'check_product_layer'+row_number;
	
		if(document.getElementById(div_name_) != undefined)
		{
			document.getElementById('frm_row_'+row_number).style.display='';
			document.getElementById(div_name_).style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=service.emptypopup_get_product_with_serial&serial_no=' + this_serial_no+'&row_number='+row_number,div_name_ ,1);
		}
		else
			setTimeout('_show_("'+this_serial_no+'")',20);
	}
	
	function get_service_cat(count,deger)
	{
		<cfif x_prod_calc_sub_contract and len(attributes.subscription_id)>
		if(deger==undefined)
		{
			deger1 = <cfoutput>#attributes.subscription_id#</cfoutput>;
			deger2 = document.getElementById('product_id'+count).value;
			var listParam = deger1 + "*" + deger2;
			result_ = wrk_safe_query('srv_get_subscription_price','dsn3',0,listParam);
			my_deger = result_.OTHER_MONEY_VALUE;
			my_deger_money = result_.OTHER_MONEY;
			my_deger_rate1 = result_.RATE1;
			my_deger_rate2 = result_.RATE2;
			document.getElementById('price'+count).value = my_deger;
			document.getElementById('money'+count).value = my_deger_money+';'+my_deger_rate1+';'+my_deger_rate2;
			document.getElementById('total_price'+count).value = my_deger;
		}
		</cfif>
		<cfif x_product_cat_operation>
		if(document.getElementById('product_catid'+count).value)
		{
			deger = document.getElementById('product_catid'+count).value;
			result = wrk_safe_query('srv_get_spare_part','dsn3',0,deger);
			mylist = result.SPARE_PART_ID;
			document.getElementById('spare_part_type'+count).value = mylist;
		}
		</cfif>
	}

</script>
