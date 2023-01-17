<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
	SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD ORDER BY SHIP_METHOD
</cfquery>
<cfquery name="GET_PACKAGE_TYPE" datasource="#DSN#">
	SELECT PACKAGE_TYPE_ID, PACKAGE_TYPE, DIMENTION, CALCULATE_TYPE_ID FROM SETUP_PACKAGE_TYPE ORDER BY PACKAGE_TYPE
</cfquery>
<cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
	SELECT 
    	SHIP_METHOD_PRICE_ID, 
        COMPANY_ID, 
        PRICE, 
        MAX_LIMIT, 
        OTHER_MONEY, 
        CALCULATE_TYPE, 
        MULTI_CITY_ID, 
        PRODUCT_ID, 
        RECORD_IP, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        PICTURE, 
        PICTURE_SERVER_ID 
    FROM 
	    SHIP_METHOD_PRICE 
    WHERE 
	    SHIP_METHOD_PRICE_ID = #attributes.ship_method_price_id#
</cfquery>
<cfquery name="GET_SHIP_METHOD_PRICE_ROW" datasource="#DSN#">
	SELECT 
        SHIP_METHOD_PRICE_ID, 
        SHIP_METHOD_ID, 
        PACKAGE_TYPE_ID, 
        START_VALUE, 
        FINISH_VALUE, 
        PRICE, 
        CUSTOMER_PRICE, 
        OTHER_MONEY 
    FROM 
    	SHIP_METHOD_PRICE_ROW 
    WHERE 
	    SHIP_METHOD_PRICE_ID = #attributes.ship_method_price_id#
</cfquery>
<!--- Bu query taşıyıcı firmaların 1 kere seçildiğini kontrol etmek için kullanılıyor. --->
<cfquery name="GET_SHIP_METHOD_PRICE_" datasource="#DSN#">
	SELECT COMPANY_ID FROM SHIP_METHOD_PRICE WHERE SHIP_METHOD_PRICE_ID <> #attributes.ship_method_price_id#
</cfquery>
<cfset transport_selected=ValueList(get_ship_method_price_.company_id,',')><!--- Taşıyıcı Firma Sadece 1 kez seçilsin. --->
<cfset ship_method_price_row = get_ship_method_price_row.recordcount>

<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD
</cfquery>
<!--- Silme ikonu için kontrol --->
<cfquery name="GET_CONTROL_SHIP_RESULT" datasource="#DSN#">
	<cfloop from="1" to="#get_period.recordcount#" index="i">
		SELECT DISTINCT SERVICE_COMPANY_ID FROM #dsn#_#get_period.period_year[i]#_#get_period.our_company_id[i]#.SHIP_RESULT WHERE SERVICE_COMPANY_ID = #get_ship_method_price.company_id# 
	<cfif get_period.recordcount neq i>
		UNION
	</cfif>		
	</cfloop>
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfparam name="is_sending_zone" default="0">
<cf_xml_page_edit fuseact="settings.form_add_ship_method_price">
<cfsavecontent variable="img_">
	<cfif is_sending_zone eq 1>
        <div style="position:absolute;display:none;margin-left:-150px;height:250px;width:400px;" id="is_sending_zone"></div>
        <a href="javascript://" onclick="goster(is_sending_zone);open_process();"><img src="/images/plus_branch.gif" border="0" align="absmiddle" title="Sevkiyat Bölgesi İl Seçimi"></a>
    </cfif>
    <!--- <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_ship_method_price"><img src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0" align="absmiddle"></a> --->
</cfsavecontent>

<cf_box title="#getLang('main',1098)#" right_images="#img_#" add_href="#request.self#?fuseaction=settings.form_add_ship_method_price" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Sevk Fiyatı Güncelleme --->
    <cfform name="upd_ship_method_price" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_ship_method_price" onsubmit="return (unformat_fields());" enctype="multipart/form-data">
        <input type="hidden" name="ship_method_price_id" id="ship_method_price_id" value="<cfoutput>#attributes.ship_method_price_id#</cfoutput>">
        <input type="hidden" name="multi_city_id" id="multi_city_id" value="<cfoutput>#get_ship_method_price.multi_city_id#</cfoutput>">
        <cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group" >
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="company_id_" id="company_id_" value="<cfoutput>#get_ship_method_price.company_id#</cfoutput>">
                   			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_ship_method_price.company_id#</cfoutput>">
                   			<input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_ship_method_price.company_id,1,1,0)#</cfoutput>">
                  			 <span class="input-group-addon icon-ellipsis btnPointer"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=upd_ship_method_price.company&field_comp_id=upd_ship_method_price.company_id&function_name=clear_multi_city&select_list=2');"></a>
						</div>
					</div>
				</div>
				<div class="form-group" >
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='245.Urun'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<div class="input-group">
							<cfif len(get_ship_method_price.product_id)>
								<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
									SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #get_ship_method_price.product_id#
								</cfquery>
							</cfif>
							<!--- <cf_wrk_products form_name = 'upd_ship_method_price' product_name='product_name' product_id='product_id'> --->
							<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#get_ship_method_price.product_id#</cfoutput>">
							<input type="text" name="product_name" id="product_name" value="<cfif len(get_ship_method_price.product_id)><cfoutput>#get_product_name.product_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_ship_method_price.product_id&field_name=upd_ship_method_price.product_name');"></span>
						
							</div>
					</div>
				</div>
				<div class="form-group" >
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58637.Logo'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						
                			<input type="file" name="picture" id="picture" tabindex="31">
					
					</div>
				</div>
			</div>

			
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group">
				<div class="col col-3 col-md-6 col-xs-12">
					<input type="text" name="max_limit" id="max_limit" value="<cfoutput>#get_ship_method_price.max_limit#</cfoutput>" onkeyup="isNumber(this);">
				</div>
				<label class="col col-3 col-md-6 col-xs-12">
					<cf_get_lang no='1375.Üzeri Kg-Desi'> *
				</label>
				<div class="col col-3 col-md-6 col-xs-12">
					<input type="text" name="price" id="price" value="<cfoutput>#TlFormat(get_ship_method_price.price,3)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,3));" class="moneybox" style="width:100px;">
				</div>
				<div class="col col-3 col-md-6 col-xs-12">
					<cfoutput>&nbsp;#session.ep.money#</cfoutput>
				</div>
			</div>

			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='1507.Hesap Yöntemi'></label>
				<div class="col col-4 col-md-6 col-xs-12">
					<input type="radio" name="calculate_type" id="calculate_type" value="1" <cfif get_ship_method_price.calculate_type eq 1>checked</cfif> ><cf_get_lang no='1508.Kümülatif'>&nbsp;
				</div>
				<div class="col col-4 col-md-6 col-xs-12">
					<input type="radio" name="calculate_type" id="calculate_type" value="2" <cfif get_ship_method_price.calculate_type eq 2>checked</cfif>><cf_get_lang no='1509.Paket'>

			</div>
			
		</div>

		</cf_box_elements>

        <cf_grid_list name="table1" id="table1">
            <thead>
                <tr>
                    <th width="20"><input name="record_num" id="record_num" type="hidden" value="0"><input type="button" class="eklebuton" title="<cf_get_lang_main no ='170.Ekle'>" onclick="add_row();"></th>
                    <th width="110"><cf_get_lang_main no='1703.Sevk Yöntemi'>*</th>
                    <th width="100"><cf_get_lang no='485.Paket Tipi'>*</th>
                    <th width="80"><cf_get_lang no='1027.İlk Değer'>*</th>
                    <th width="70"><cf_get_lang no='1028.Son Değer'>*</th>
                    <th width="100"><cf_get_lang_main no='672.Fiyat'>*</th>
                    <th width="150"><cf_get_lang_main no='45.Müşteri'> <cf_get_lang_main no='672.Fiyat'></th>
                </tr>
            </thead>
            <cfoutput query="get_ship_method_price_row">
                <tbody>
                    <tr id="frm_row#currentrow#">
                        <td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                            <a style="cursor:pointer" onclick="sil(#currentrow#);"><img src="images/delete_list.gif" alt="<cf_get_lang_main no ='51.Sil'>" border="0" align="absmiddle"></a>
                        </td>
                        <td><cfset ship_method_id_ = ship_method_id>
                            <select name="ship_method#currentrow#" id="ship_method#currentrow#" style="width:100px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_ship_method">
                                    <option value="#ship_method_id#" <cfif ship_method_id_ eq ship_method_id>selected</cfif>>#ship_method#</option>
                                </cfloop>
                            </select>				
                        </td>
                        <td><select name="package_type#currentrow#" id="package_type#currentrow#" style="width:100px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif package_type_id eq 1> selected</cfif>><cf_get_lang no='1021.Desi'></option>
                                <option value="2" <cfif package_type_id eq 2> selected</cfif>><cf_get_lang no='1022.Kg'></option>
                                <option value="3" <cfif package_type_id eq 3> selected</cfif>><cf_get_lang no='557.Zarf'></option>
                                <option value="4" <cfif package_type_id eq 4> selected</cfif>><cf_get_lang no='1839.Zarf S Dışı'></option>
                            </select>
                        </td>
                        <td><input type="text" name="start_value#currentrow#" id="start_value#currentrow#" value="#TlFormat(start_value,2)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:65px;"></td>
                        <td><input type="text" name="finish_value#currentrow#" id="finish_value#currentrow#" value="#TlFormat(finish_value,2)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:65px;"></td>
                        <td><input type="text" name="price#currentrow#" id="price#currentrow#" value="#TlFormat(price,3)#" onkeyup="return(FormatCurrency(this,event,3));" class="moneybox" style="width:100px;"></td>
                        <td><input type="text" name="customer_price#currentrow#" id="customer_price#currentrow#" value="#TlFormat(customer_price,3)#" onkeyup="return(FormatCurrency(this,event,3));" class="moneybox" style="width:100px;">&nbsp;#session.ep.money#</td>
                    </tr>
                </tbody>
            </cfoutput>
        </cf_grid_list>
        <cf_box_footer>
        	<cf_record_info query_name="get_ship_method_price">
        	<cfif get_control_ship_result.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='0'  add_function="kontrol()" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_ship_method_price' , #attributes.modal_id#)"),DE(""))#">
            <cfelse>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_ship_method_price&ship_method_price_id=#attributes.ship_method_price_id#&head=#attributes.ship_method_price_id#&' add_function="kontrol()" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_ship_method_price' , #attributes.modal_id#)"),DE(""))#">
            </cfif>		
        </cf_box_footer>
    </cfform>
</cf_box>

<script type="text/javascript">
max_limit_deger=document.upd_ship_method_price.max_limit.value;
row_count=<cfoutput>#ship_method_price_row#</cfoutput>;
kontrol_row_count=<cfoutput>#ship_method_price_row#</cfoutput>;
document.upd_ship_method_price.record_num.value=row_count;
function kontrol()
{
	if(document.upd_ship_method_price.company_id.value != document.upd_ship_method_price.company_id_.value)//Taşıyıcı firma değiştirildiyse
	{	
		<cfif is_sending_zone eq 0>
			if(list_find(<cfoutput>'#transport_selected#'</cfoutput>,document.upd_ship_method_price.company_id.value,','))//Taşıyıcı firmanın dışında seçilen firma daha önceden seçilmiş mi?
			{
				alert("<cf_get_lang no ='1510.Bu Taşıyıcı Firmaya Ait Bir Kayıt Var'>");
				document.upd_ship_method_price.company_id.value="";
				document.upd_ship_method_price.company.value="";
				return false;
			}
		</cfif>
	}
	<!--- XML de Hesaplama Bolge Bazında secili ise BK --->
	<cfif is_sending_zone eq 1>
		if(document.upd_ship_method_price.multi_city_id.value == '')
		{
			alert("<cf_get_lang no='1550.Hesaplama Bölge Bazında Seçildiği İçin İl Seçiniz'>!");
			return false;
		}
	</cfif>
	
	for	(i=1;i<=row_count;i++)
	{
		if(parseFloat(document.upd_ship_method_price.max_limit.value) < parseFloat(eval("document.upd_ship_method_price.start_value"+i).value) || parseFloat(document.upd_ship_method_price.max_limit.value) < parseFloat(eval("document.upd_ship_method_price.finish_value"+i).value))
		{
			alert("<cf_get_lang no ='1512.Girilen Değerleriniz Arasında Uyumsuzluk Var Lütfen Kontrol Ediniz'>");
			return false;
		}
	}
	
	if(document.upd_ship_method_price.company_id.value=="" || document.upd_ship_method_price.company.value=="")
	{
		alert("<cf_get_lang no ='1029.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
	
	y = filterNum(document.upd_ship_method_price.price.value);
	if(upd_ship_method_price.price.value=="" || y ==0)
	{
		alert("<cf_get_lang no ='1378.Fiyat Değerinizi Kontrol Ediniz'> !");
		document.upd_ship_method_price.price.focus();	
		return false;
	}

	if(row_count == 0 || kontrol_row_count == 0)
	{
		alert("<cf_get_lang no ='1379.En Az Bir Satır Fiyat Kaydı Girmelisiniz'>!");
		return false;
	}
	static_row=0;
	for(r=1;r<=row_count;r++)		
	{
		if(eval("document.upd_ship_method_price.row_kontrol"+r).value == 1)		
		{	
			static_row++;
			deger_ship_method = eval("document.upd_ship_method_price.ship_method"+r);
			deger_package_type = eval("document.upd_ship_method_price.package_type"+r);
			deger_start_value = eval("document.upd_ship_method_price.start_value"+r);
			deger_finish_value = eval("document.upd_ship_method_price.finish_value"+r);			
			deger_price = eval("document.upd_ship_method_price.price"+r);

			if(deger_ship_method.value=="")
			{
				alert(static_row+"<cf_get_lang no ='1386.Satır Sevk Yöntemi Seçmelisiniz'> !");
				return false;
			}
			
			if(deger_package_type.value == "")
			{
				alert(static_row+"<cf_get_lang no ='1387.Satır Paket Tipi Seçmelisiniz'> !");
				return false;
			}			
			
			if(deger_package_type.value == 1 || deger_package_type.value == 2)
			{
				if(deger_start_value.value=="" || deger_finish_value.value=="")
				{
					alert(static_row+"<cf_get_lang no ='1388.Satır Ilk Değer ve Son Değer Girmelisiniz'>!");
					return false;
				}
			}
			
			if(deger_price.value=="")
			{
				alert(static_row+"<cf_get_lang no ='1389.Satır Fiyat Girmelisiniz'>  !");
				return false;
			}
		}
	}
	return true;
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

	document.upd_ship_method_price.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" alt="<cf_get_lang_main no ="51.Sil">" border="0" align="absmiddle"></a>';				

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'" value="1"><select name="ship_method' + row_count +'" style="width:100px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><cfoutput query="get_ship_method"><option value="#ship_method_id#">#ship_method#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="package_type' + row_count +'" style="width:100px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><option value="1"><cf_get_lang no ="1021.Desi"></option><option value="2"><cf_get_lang no="1022.Kg"></option><option value="3"><cf_get_lang no ="557.Zarf"></option><option value="4"><cf_get_lang no ="1839.Zarf S Dışı"></option></select>'; //add_general_prom();

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="start_value' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value="" class="moneybox" style="width:65px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="finish_value' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value="" class="moneybox" style="width:65px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="price' + row_count +'" onkeyup="return(FormatCurrency(this,event,3));" value="" class="moneybox" style="width:100px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="customer_price' + row_count +'" onkeyup="return(FormatCurrency(this,event,3));" value="" class="moneybox" style="width:100px;">';
}

function sil(sy)
{
	var my_element=eval("upd_ship_method_price.row_kontrol"+sy);		
	my_element.value=0;
	
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	
	kontrol_row_count--;
}

function unformat_fields()
{
	for(r=1;r<=row_count;r++)
	{
		if(eval("document.upd_ship_method_price.row_kontrol"+r).value == 1)
		{
			deger_package_type = eval("document.upd_ship_method_price.package_type"+r);
			if(deger_package_type.value == 1 || deger_package_type.value == 2) //Paket tipi desi veya kg
			{
				eval("document.upd_ship_method_price.start_value"+r).value = filterNum(eval("document.upd_ship_method_price.start_value"+r).value);
				eval("document.upd_ship_method_price.finish_value"+r).value = filterNum(eval("document.upd_ship_method_price.finish_value"+r).value);
			}
			else
			{
				eval("document.upd_ship_method_price.start_value"+r).value = '';
				eval("document.upd_ship_method_price.finish_value"+r).value = '';
			}
			eval("document.upd_ship_method_price.price"+r).value = filterNum(eval("document.upd_ship_method_price.price"+r).value,3);
			eval("document.upd_ship_method_price.customer_price"+r).value = filterNum(eval("document.upd_ship_method_price.customer_price"+r).value,3);
		}
	}
	document.upd_ship_method_price.price.value = filterNum(document.upd_ship_method_price.price.value,3);	
}
unformat_fields();
function open_process()//row_count,conscat_id
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.popup_list_city_check&multi_city_id='+document.upd_ship_method_price.multi_city_id.value+'&ship_method_price_id='+#attributes.ship_method_price_id#+'&company_id='+document.upd_ship_method_price.company_id.value+</cfoutput>'','is_sending_zone',1);
}

function clear_multi_city()
{	
	document.upd_ship_method_price.multi_city_id.value = '';
}
</script>
