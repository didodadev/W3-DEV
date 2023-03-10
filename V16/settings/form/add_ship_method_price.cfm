<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
	SELECT
		SHIP_METHOD_ID,
		#dsn#.Get_Dynamic_Language(SHIP_METHOD_ID,'#session.ep.language#','SHIP_METHOD','SHIP_METHOD.SHIP_METHOD',NULL,NULL,SHIP_METHOD) AS SHIP_METHOD
	FROM
		SHIP_METHOD 
	ORDER BY
		SHIP_METHOD
</cfquery>
<cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
	SELECT 
		COMPANY_ID
	FROM 
		SHIP_METHOD_PRICE
</cfquery>
<cf_xml_page_edit>
	<cfparam name="attributes.modal_id" default="">
<cfset transport_selected=ValueList(get_ship_method_price.company_id,',')><!--- Taşıyıcı Firma Sadece 1 kez seçilsin. --->
<cfsavecontent variable="img_">
	<cfif is_sending_zone eq 1>
        <div style="position:absolute;display:none;margin-left:-100px;overflow:auto;height:250px;width:350px;" id="is_sending_zone"></div>
        <a href="javascript://" onClick="goster(is_sending_zone);open_process();"><img src="/images/plus_branch.gif" border="0" align="absmiddle" title="<cf_get_lang no='772.Sevkiyat Bölgesi İl Seçimi'>"></a>
    </cfif>
</cfsavecontent>
<cf_box title="#getLang('settings',1026)#" right_images="#img_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="add_ship_method_price" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_ship_method_price" onsubmit="return (unformat_fields());">
<input type="hidden" name="multi_city_id" id="multi_city_id" value="">
	<!--- Sevk Fiyatı Ekle --->
		<cf_box_elements>
		
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group" >
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
				<div class="col col-8 col-md-6 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="">
						<input type="text" name="company" id="company" value="" >
			  			<span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=add_ship_method_price.company&field_comp_id=add_ship_method_price.company_id&select_list=2');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
					</div>
				</div>
			</div>
			<div class="form-group" >
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='245.Urun'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<div class="input-group">
							<input type="hidden" name="product_id" id="product_id" value="">
							<input type="text" name="product_name" id="product_name" value="" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" style="width:150px;">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_ship_method_price.product_id&field_name=add_ship_method_price.product_name');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
					</div>
				</div>
			</div>
		</div>

		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<div class="form-group">
				<div class="col col-3 col-md-6 col-xs-12">
					<input type="text" name="max_limit" id="max_limit" value="30"onkeyup="isNumber(this);">
				</div>
				<label class="col col-3 col-md-6 col-xs-12">
					<cf_get_lang no='1375.Üzeri Kg-Desi'> *
				</label>
				<div class="col col-3 col-md-6 col-xs-12">
					<input type="text" name="price" id="price" value="<cfoutput>#TlFormat(0,3)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,3));" class="moneybox">
					
				</div>
				<div class="col col-3 col-md-6 col-xs-12">
					<cfoutput>&nbsp;#session.ep.money#</cfoutput>
				</div>
			</div>

			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='1507.Hesap Yöntemi'></label>
				<div class="col col-4 col-md-6 col-xs-12">
					<input type="radio" name="calculate_type" id="calculate_type" value="1" checked="checked"><cf_get_lang no='1508.Kümülatif'>&nbsp;
				</div>
				<div class="col col-4 col-md-6 col-xs-12">
						<input type="radio" name="calculate_type" id="calculate_type" value="2"><cf_get_lang no='1509.Paket'>	
				</div>
			</div>
			
		</div>

		</cf_box_elements>
		
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><input name="record_num" id="record_num" type="hidden" value="0"><input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row();"></th>
                    <th width="110"><cf_get_lang_main no='1703.Sevk Yöntemi'> *</th>
                    <th width="100"><cf_get_lang no='485.Paket Tipi'> *</th>
                    <th nowrap><cf_get_lang no='1027.İlk Değer'> *</th>
                    <th nowrap><cf_get_lang no='1028.Son Değer'> *</th>
                    <th width="100"><cf_get_lang_main no='672.Fiyat'> *</th>
                    <th width="150"><cf_get_lang_main no='45.Müşteri'> <cf_get_lang_main no='672.Fiyat'></th>
                </tr>
            </thead>
            <tbody name="table1" id="table1"></tbody>
        </cf_grid_list>
        <cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="kontrol()" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_ship_method_price' , #attributes.modal_id#)"),DE(""))#">

			</cf_box_footer>
		</cfform>
	</cf_box>
<script type="text/javascript">
row_count=0;
kontrol_row_count=0;

function kontrol()
{
	<cfif is_sending_zone eq 0>
		if(list_find(<cfoutput>'#transport_selected#'</cfoutput>,document.add_ship_method_price.company_id.value,','))
		{
			alert("<cf_get_lang no='1510.Bu Taşıyıcı Firmaya Ait Bir Kayıt Var'>");
			document.add_ship_method_price.company_id.value="";
			document.add_ship_method_price.company.value="";
			return false;
		}
	<cfelse>
	<!--- XML de Hesaplama Bolge Bazında secili ise BK --->
		if(document.add_ship_method_price.multi_city_id.value == '')
		{
			alert("<cf_get_lang no='1550.Hesaplama Bölge Bazında Seçildiği İçin İl Seçiniz'> !");
			return false;
		}		
		
	</cfif>
	
	
	for	(i=1;i<=row_count;i++)
	{	
		if(document.add_ship_method_price.max_limit.value=="")
		{
			alert("<cf_get_lang no='1511.İlk Önce Max Desi Miktarı Giriniz'>");
			return false;
		}
		if(parseFloat(document.add_ship_method_price.max_limit.value) < parseFloat(eval("document.add_ship_method_price.start_value"+i).value) || parseFloat(document.add_ship_method_price.max_limit.value) < parseFloat(eval("document.add_ship_method_price.finish_value"+i).value))
		{
			alert("<cf_get_lang no='1512.Girilen Değerleriniz Arasında Uyumsuzluk Var Lütfen Kontrol Ediniz'>");
			return false;
		}
	}
	if(document.add_ship_method_price.company_id.value=="" || document.add_ship_method_price.company.value=="")
	{
		alert("<cf_get_lang no='1029.Cari Hesap Seçmelisiniz'>!");
		return false;
	}
	y = filterNum(document.add_ship_method_price.price.value);
	if(add_ship_method_price.price.value=="" || y ==0)
	{
		alert("<cf_get_lang no='1378.Fiyat Değerinizi Kontrol Ediniz'>!");
		document.add_ship_method_price.price.focus();	
		return false;
	}
	
	if(row_count == 0 || kontrol_row_count == 0)
	{
		alert("<cf_get_lang no='1379.En Az Bir Satır Fiyat Kaydı Girmelisiniz'>!");
		return false;
	}
	
	static_row=0;
	for(r=1;r<=row_count;r++)		
	{
		
		if(eval("document.add_ship_method_price.row_kontrol"+r).value == 1)			
		{	
			static_row++;
			deger_ship_method = eval("document.add_ship_method_price.ship_method"+r);
			deger_package_type = eval("document.add_ship_method_price.package_type"+r);
			deger_start_value = eval("document.add_ship_method_price.start_value"+r);
			deger_finish_value = eval("document.add_ship_method_price.finish_value"+r);
			deger_price = eval("document.add_ship_method_price.price"+r);

			if(deger_ship_method.value=="")
			{
				alert(static_row+". <cf_get_lang no='1386.Satır Sevk Yönetemi Seçmelisiniz '>!");
				return false;
			}
			
			if(deger_package_type.value == "")
			{
				alert(static_row+".<cf_get_lang no='1387.Satır Paket Tipi Seçmelisiniz'>!");
				return false;
			}
			
			if(deger_package_type.value == 1 || deger_package_type.value == 2) //Paket tipi desi veya kg
			{
				if(deger_start_value.value=="" || deger_finish_value.value=="")
				{
					alert(static_row+".<cf_get_lang no='1388.Satır Ilk Değer ve Son Değer Girmelisiniz'>!");
					return false;
				}
			}
			
			if(deger_price.value=="")
			{
				alert(static_row+".<cf_get_lang no='1389.Satır Fiyat Girmelisiniz'>! ");
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

	document.add_ship_method_price.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang_main no='51.Sil'>" border="0" align="absmiddle">';				

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="hidden" name="row_kontrol' + row_count +'" value="1"><select name="ship_method' + row_count +'" ><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="get_ship_method"><option value="#ship_method_id#">#ship_method#</option></cfoutput></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="package_type' + row_count +'" style="width:100px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><option value="1"><cf_get_lang no="1021.Desi"></option><option value="2"><cf_get_lang no="1022.Kg"></option><option value="3"><cf_get_lang no="557.Zarf"></option><option value="4"><cf_get_lang no="1839.Zarf SDışı"></option></select></div>'; //add_general_prom();

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="start_value' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value=""  ></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="finish_value' + row_count +'" onkeyup="return(FormatCurrency(this,event));" value="" class="moneybox" ></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="price' + row_count +'" onkeyup="return(FormatCurrency(this,event,3));" value="" class="moneybox"></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="input-group"><input type="text" name="customer_price' + row_count +'" onkeyup="return(FormatCurrency(this,event,3));" value="" class="moneybox" ><cfoutput>#session.ep.money#</cfoutput></div>';
}

function sil(sy)
{
	var my_element=eval("add_ship_method_price.row_kontrol"+sy);		
	my_element.value=0;
	
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	
	kontrol_row_count--;
}

function unformat_fields()
{
	for(r=1;r<=row_count;r++)
	{
		if(eval("document.add_ship_method_price.row_kontrol"+r).value == 1)
		{
			deger_package_type = eval("document.add_ship_method_price.package_type"+r);
			if(deger_package_type.value == 1 || deger_package_type.value == 2) //Paket tipi desi veya kg
			{
				eval("document.add_ship_method_price.start_value"+r).value = filterNum(eval("document.add_ship_method_price.start_value"+r).value);
				eval("document.add_ship_method_price.finish_value"+r).value = filterNum(eval("document.add_ship_method_price.finish_value"+r).value);
			}
			else
			{
				eval("document.add_ship_method_price.start_value"+r).value = '';
				eval("document.add_ship_method_price.finish_value"+r).value = '';
			}
			eval("document.add_ship_method_price.price"+r).value = filterNum(eval("document.add_ship_method_price.price"+r).value,3);
			eval("document.add_ship_method_price.customer_price"+r).value = filterNum(eval("document.add_ship_method_price.customer_price"+r).value,3);
		}
	}
	document.add_ship_method_price.price.value = filterNum(document.add_ship_method_price.price.value,3);	
}

function open_process()//row_count,conscat_id
{
	if(document.add_ship_method_price.company_id.value=="" || document.add_ship_method_price.company.value=="" )
	{
		alert("<cf_get_lang no='1029.Cari Hesap Seçmelisiniz'>!");
		return false;
	}
	else
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.popup_list_city_check&multi_city_id='+document.add_ship_method_price.multi_city_id.value+'&company_id='+document.add_ship_method_price.company_id.value+</cfoutput>'','is_sending_zone',1);
}

function clear_multi_city()
{	
	document.add_ship_method_price.multi_city_id.value = '';
}

</script>
