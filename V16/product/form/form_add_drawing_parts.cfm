<cfif isdefined('attributes.dpl_id') and len(attributes.dpl_id)>
	<cfquery name="get_drawing_part" datasource="#dsn3#">
		SELECT 
			DP.*,
			P.PRODUCT_NAME,
			P.PRODUCT_CATID 
		FROM 
			DRAWING_PART DP,
			PRODUCT P
		WHERE 
			DP.DPL_ID = #attributes.dpl_id# AND
			DP.DPL_PRODUCT_ID = P.PRODUCT_ID
	</cfquery>
	<cfset attributes.main_product_id = get_drawing_part.main_product_id>
	<cfset attributes.asset_id = get_drawing_part.asset_id>
	<cfif len(attributes.asset_id)>
		<cfquery name="get_asset_name" datasource="#dsn#">
			SELECT ASSET_NAME,ASSET_NO FROM ASSET WHERE ASSET_ID = #attributes.asset_id#
		</cfquery>
	</cfif>
	<cfset attributes.dpl_product_id = get_drawing_part.dpl_product_id>
	<cfset attributes.dpl_product_name = get_drawing_part.product_name>
	<cfset attributes.main_quantity = get_drawing_part.quantity>
	<cfquery name="get_drawing_part_rows" datasource="#dsn3#">
		SELECT 
            DPR.*,
            PW.WORK_HEAD,
            SPC.PBS_CODE,
            S.PRODUCT_NAME,
            S.PRODUCT_CODE_2
        FROM 
            DRAWING_PART_ROW DPR
            LEFT JOIN #dsn_alias#.PRO_WORKS PW ON PW.WORK_ID = DPR.WORK_ID
            LEFT JOIN SETUP_PBS_CODE SPC ON SPC.PBS_ID = DPR.PBS_ID
            LEFT JOIN STOCKS S ON S.STOCK_ID = DPR.STOCK_ID
        WHERE 
        	DPR.IS_ACTIVE = 1 AND
            DPL_ID = #attributes.dpl_id#
	</cfquery>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37138.DPL Ekle'></cfsavecontent>
<cf_form_box title="#message#">
<cfform name="add_drawing_parts" method="post" action="#request.self#?fuseaction=product.emptypopup_add_drawing_parts">
	<table>
        <tr>
            <td></td>
            <td nowrap="nowrap"><input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"/><cf_get_lang dictionary_id ='57493.aktif'>&nbsp;
                <input type="checkbox" name="is_main_dpl" id="is_main_dpl" value="1" checked="checked"/><cf_get_lang dictionary_id="37164.Ana Ürün">
                <input type="checkbox" name="is_yrm" id="is_yrm" value="1" checked="checked"/><cf_get_lang dictionary_id='37473.Yari Mamul'>
            </td>
        </tr>
        <tr>
            <td width="65"><cf_get_lang dictionary_id="37164.Ana Ürün"> *</td>
            <td width="170">
                <cfoutput>
                    <input type="hidden" name="main_product_id" id="main_product_id" value="<cfif isdefined('attributes.main_product_id') and len(attributes.main_product_id)>#attributes.main_product_id#</cfif>">
                    <input name="main_product_name" type="text" id="main_product_name" style="width:135px;" onFocus="AutoComplete_Create('main_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','main_product_id','add_drawing_parts','3','200');" value="<cfif isdefined('attributes.main_product_id') and len(attributes.main_product_id)>#get_product_name(attributes.main_product_id)#</cfif>" autocomplete="off">
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=add_drawing_parts.main_product_id&field_name=add_drawing_parts.main_product_name','list');"><img src="/images/plus_thin.gif" align="absmiddle"></a>
                </cfoutput>
            </td>
            <td nowrap="nowrap"><cf_get_lang dictionary_id='58080.Resim'>/ <cf_get_lang dictionary_id="37120.DPL No"> *</td>
            <td width="170">
                <cfoutput>
                    <input type="hidden" name="asset_id" id="asset_id" value="<cfif isdefined('attributes.asset_id') and len(attributes.asset_id)>#attributes.asset_id#</cfif>">
                    <input type="text" name="asset_no" id="asset_no" value="<cfif isdefined('attributes.asset_id') and len(attributes.asset_id)>#get_asset_name.asset_no#</cfif>" onFocus="AutoComplete_Create('asset_no','ASSET_NO,ASSET_NAME,ASSET_ID','ASSET_NO,ASSET_NAME','get_asset_autocomplete','','ASSET_NO,ASSET_NAME,ASSET_ID','asset_no,asset_name,asset_id','','3','140');" style="width:135px;">
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_digital_asset&sbmt=1&field_id=asset_id&field_name=asset_name&field_no=asset_no','list');"><img src="/images/plus_thin.gif" align="absmiddle"></a> 
                </cfoutput>
            </td>
            <td><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
            <td><input type="text" name="dpl_product_name" id="dpl_product_name" value="<cfif isdefined('attributes.dpl_product_name') and len(attributes.dpl_product_name)><cfoutput>#attributes.dpl_product_name#</cfoutput></cfif>" style="width:135px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57416.proje'></td>
            <td>
                <input type="hidden" name="project_id" id="project_id" value="">
                <input type="text" name="project_head"  id="project_head" style="width:135px;" value="" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_drawing_parts.project_id&project_head=add_drawing_parts.project_head');"> <img src="/images/plus_thin.gif" align="absmiddle"></a>
            </td>
            <td width="65"><cf_get_lang dictionary_id="58080.Resim"> <cf_get_lang dictionary_id="57897.Adı"> *</td>
            <td width="170"><input type="text" name="asset_name" id="asset_name" value="<cfif isdefined('attributes.asset_id') and len(attributes.asset_id)><cfoutput>#get_asset_name.asset_name#</cfoutput></cfif>" style="width:135px;"></td>
            <td><cf_get_lang dictionary_id='57635.Miktar'></td>
            <td><input type="text" name="main_quantity" id="main_quantity" value="<cfif isdefined('attributes.main_quantity') and len(attributes.main_quantity)><cfoutput>#TLFormat(attributes.main_quantity,2)#</cfoutput><cfelse>1</cfif>" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;"></td>
        </tr>
        <tr>
            <td width="85"><cf_get_lang dictionary_id='58859.Süreç'>*</td>
            <td><cf_workcube_process is_upd='0' process_cat_width='135' is_detail='0'></td>
            <td colspan="4"></td>
        </tr>
    </table>
    <br />
    <cf_form_list>
        <thead>
            <tr>
                <th class="txtboldblue" colspan="6"><cf_get_lang dictionary_id="37330.Malzeme Listesi"></th>
                <th>
                    <input type="hidden" name="pbs_id0" id="pbs_id0" onfocus="hepsi(row_count,'pbs_code');" value="">
                    <input name="pbs_code0" id="pbs_code0" type="text" style="width:145px;" onkeypress="controlInput(1);" onFocus="AutoComplete_Create('pbs_code0','PBS_CODE','PBS_CODE','get_pbs',''+document.add_drawing_parts.main_product_id.value+'','PBS_ID','pbs_id0','add_drawing_parts',1);hepsi(row_count,'pbs_code');" value="" autocomplete="off">
                    <a href="javascript://" onClick="pencere_ac_pbs_code(0);"><img src="/images/plus_thin.gif" align="absmiddle"></a>
                </th>
                <th nowrap>
                    <input type="hidden" name="work_id0" id="work_id0" value="">
                    <input name="work_head0" type="text" style="width:145px;" value=""  onkeypress="controlInput(2);" onFocus="AutoComplete_Create('work_head0','WORK_HEAD','WORK_HEAD','get_work',''+document.add_drawing_parts.project_id.value+'','WORK_ID','work_id0','',3,139);hepsi(row_count,'work_head');">
                    <a href="javascript://" onClick="pencere_ac_work(0);"><img src="/images/plus_thin.gif" align="absmiddle"></a>
                </th>
            </tr>
            <tr>
            	<th width="15"></th>
                <th width="30" style="text-align:center;">
                    <input name="record_num" id="record_num" type="hidden" value="<cfif isdefined('attributes.dpl_id') and len(attributes.dpl_id)><cfoutput>#get_drawing_part_rows.recordcount#</cfoutput><cfelse>0</cfif>">
                    <input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();">
                </th>
                <th width="255"><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th width="150"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                <th width="70"><cf_get_lang dictionary_id='57635.Miktar'></th>
                <th width="70"><cf_get_lang dictionary_id='57636.Birim'></th>
                <th width="170"><cf_get_lang dictionary_id="37200.PBS"></th>
                <th width="170"><cf_get_lang dictionary_id='58445.İş'></th>
            </tr>
        </thead>
        <tbody name="table1" id="table1">
        <cfif isdefined('attributes.dpl_id') and len(attributes.dpl_id)>
            <cfoutput query="get_drawing_part_rows">
            <tr id="frm_row#currentrow#">
                <td style="text-align:center;">#currentrow#</td>
                <td><input  type="hidden" value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a style="cursor:pointer" onClick="sil('#currentrow#');"><img  src="images/delete_list.gif"></a><a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id ='58972.Satır Kopyala'>"><img  src="images/copy_list.gif"></a></td>
                <td nowrap="nowrap"><input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                    <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif len(product_id) and len(stock_id)>#product_name#</cfif>" onFocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','stock_id#currentrow#,product_id#currentrow#','add_drawing_parts',1);" style="width:250px;" >
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=add_drawing_parts.stock_id#currentrow#&product_id=add_drawing_parts.product_id#currentrow#&field_name=add_drawing_parts.product_name#currentrow#&field_unit=add_drawing_parts.unit_id#currentrow#&field_unit_name=add_drawing_parts.unit#currentrow#&field_special_code=add_drawing_parts.special_code#currentrow#','list');"><img align="middle" src="/images/plus_thin.gif"></a>
                </td>
                <td><input type="text" name="special_code#currentrow#" id="special_code#currentrow#" readonly value="<cfif len(product_id) and len(stock_id)>#product_code_2#</cfif>" style="width:150px;" >&nbsp;</td>
                <td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TLFormat(quantity,2)#" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;" class="box"></td>
                <td><input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#unit_id#"><input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#unit#" readonly style="width:50px;" ></td>
                <td>
                    <input type="hidden" name="pbs_id#currentrow#" id="pbs_id#currentrow#" value="#pbs_id#">
                    <input name="pbs_code#currentrow#" id="pbs_code#currentrow#" type="text"  style="width:139px;" value="<cfif len(pbs_id)>#pbs_code#</cfif>" onkeypress="controlInput(1);" onFocus="AutoComplete_Create('pbs_code#currentrow#','PBS_CODE','PBS_CODE','get_pbs',''+document.add_drawing_parts.main_product_id.value+'','PBS_ID','pbs_id#currentrow#','add_drawing_parts',1);">
                    <a href="javascript://" onClick="pencere_ac_pbs_code('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle"></a>
                </td>
                <td><input type="hidden"  name="work_id#currentrow#" id="work_id#currentrow#" value="#work_id#">
                    <input name="work_head#currentrow#" id="work_head#currentrow#" type="text"  style="width:139px;" value="<cfif len(work_id)>#work_head#</cfif>"  onkeypress="controlInput(2);" onFocus="AutoComplete_Create('work_head#currentrow#','WORK_HEAD','WORK_HEAD','get_work',''+document.add_drawing_parts.project_id.value+'','WORK_ID','work_id#currentrow#','',3,139);">
                    <a href="javascript://" onClick="pencere_ac_work('#currentrow#');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='58691.iş listesi'>" align="absmiddle"></a>
                </td>
            </tr>
        </cfoutput>
    </cfif>
    </tbody>
  </cf_form_list>
<cf_form_box_footer>
    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
</cf_form_box_footer>
</cfform>
</cf_form_box>						
<script type="text/javascript">
	function hepsi(satir,nesne)
	{
		deger=eval("document.add_drawing_parts."+nesne+"0");
		for(var i=1;i<=satir;i++)
		{ 
			nesne_=eval("document.add_drawing_parts."+nesne+i);
			nesne_.value=deger.value;
		}
		if(nesne=='work_head')
			hepsi(row_count,'work_id');
		
		if(nesne=='pbs_code')
			hepsi(row_count,'pbs_id');
	}
	
	row_count=0;
	function sil(sy)
	{
		my_element = document.getElementById('row_kontrol' + sy);	
		my_element.value=0;
		my_element = document.getElementById('frm_row'+sy);
		my_element.style.display = "none";	
	}
	
	function add_row(special_code,exp_product_id,exp_stock_id,exp_product_name,row_quantity,row_unit,row_unit_id,row_pbs_id,row_pbs_code,row_work_id,row_work_head)
	{
		if(document.add_drawing_parts.main_product_id.value == "" && document.add_drawing_parts.main_product_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='52302.Lütfen Ana Ürün Seçiniz'> !");
			return false;
		}
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if (special_code == undefined)special_code ="";
		if (exp_product_id == undefined)exp_product_id ="";
		if (exp_stock_id == undefined)exp_stock_id ="";
		if (exp_product_name == undefined)exp_product_name ="";
		if (row_pbs_id == undefined)row_pbs_id ="";
		if (row_pbs_code == undefined)row_pbs_code ="";
		if (row_work_id == undefined) row_work_id ="";
		if (row_work_head == undefined) row_work_head ="";
		if (row_quantity == undefined) row_quantity ="1";
		if (row_unit == undefined) row_unit ="";
		if (row_unit_id == undefined) row_unit_id ="";
		
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'form_list';
		document.add_drawing_parts.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="no_' + row_count +'" style="width:20px;text-align:center;" class="boxtext" value="'+row_count+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><img  src="images/copy_list.gif"></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name'+ row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'STOCK_ID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE_2,PRODUCT_UNIT_ID,MAIN_UNIT\',\'stock_id' + row_count +',product_id' + row_count +',product_name'+ row_count +',special_code' + row_count +',unit_id' + row_count +',unit' + row_count +'\',\'\',3,130);" maxlength="50" style="width:242px;" value="'+exp_product_name+'">';
		newCell.innerHTML += '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&field_id=add_drawing_parts.stock_id" + row_count + "&product_id=add_drawing_parts.product_id" + row_count + "&field_name=add_drawing_parts.product_name" + row_count + "&field_unit=add_drawing_parts.unit_id" + row_count + "&field_unit_name=add_drawing_parts.unit" + row_count + "&field_special_code=add_drawing_parts.special_code" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="special_code' + row_count +'" id="special_code' + row_count +'" readonly style="width:180px;" value="'+special_code+'">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+row_quantity+'" onkeyup="return(FormatCurrency(this,event));" style="width:70px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id'+ row_count +'" value="'+row_unit_id+'"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" readonly value="'+row_unit+'" style="width:70px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="pbs_id' + row_count +'" id="pbs_id'+ row_count +'" value="'+row_pbs_id+'"><input type="text" name="pbs_code' + row_count +'" id="pbs_code'+ row_count +'" value="'+row_pbs_code+'" onkeypress="controlInput(1);" onFocus="AutoComplete_Create(\'pbs_code'+ row_count +'\',\'PBS_CODE\',\'PBS_CODE\',\'get_pbs\',\''+document.add_drawing_parts.main_product_id.value+'\',\'PBS_ID\',\'pbs_id'+ row_count +'\',\'\',3,100);" style="width:145px;">';
		newCell.innerHTML +=' <a href="javascript://" onClick="pencere_ac_pbs_code('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="work_id' + row_count +'" id="work_id'+ row_count +'" value="'+row_work_id+'"><input type="text" name="work_head' + row_count +'" id="work_head'+ row_count +'" value="'+row_work_head+'" onkeypress="controlInput(2);" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\''+document.add_drawing_parts.project_id.value+'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,139);" style="width:145px;">';
		newCell.innerHTML +=' <a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle"></a>';
	}
	
	<cfoutput>
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function copy_row(no_info)
	{ 
	
		special_code = document.getElementById('special_code' + no_info).value;	
		exp_product_id = document.getElementById('product_id' + no_info).value;	
		exp_stock_id = document.getElementById('stock_id' + no_info).value;	
		exp_product_name = document.getElementById('product_name' + no_info).value;	
		row_pbs_id = document.getElementById('pbs_id' + no_info).value;	
		row_pbs_code = document.getElementById('pbs_code' + no_info).value;	
		row_quantity = document.getElementById('quantity' + no_info).value;	
		row_unit = document.getElementById('unit' + no_info).value;	
		row_unit_id = document.getElementById('unit_id' + no_info).value;	
		
		if(eval('document.all.work_id' + no_info) != undefined)
		{
			row_work_id = eval('document.all.work_id' + no_info).value;
			row_work_head = eval('document.all.work_head' + no_info).value;
		}
		else
		{
			row_work_id = '';
			row_work_head = '';
		}
		add_row(special_code,exp_product_id,exp_stock_id,exp_product_name,row_quantity,row_unit,row_unit_id,row_pbs_id,row_pbs_code,row_work_id,row_work_head);
	}
	</cfoutput>
	
	
	function kontrol()
	{
		if(document.all.process_stage.value == "")
		{
			alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanimlayiniz ve/veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
			return false;
		}
		if(document.add_drawing_parts.main_product_id.value == "" && document.add_drawing_parts.main_product_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz'> !");
			return false;
		}
		if(document.add_drawing_parts.asset_no.value == "" && document.add_drawing_parts.asset_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='57514.Lütfen Resim Seçiniz'> !");
			return false;
		}
		
		if (document.add_drawing_parts.main_quantity.value == "" || document.add_drawing_parts.main_quantity.value == 0)
		{ 
			alert ("<cf_get_lang dictionary_id='60481.Lütfen Ana Miktar Alanını Giriniz'>!");
			return false;
		}
		if(document.add_drawing_parts.is_yrm.checked == false)
		{
			if(document.add_drawing_parts.main_quantity.value > 1)
			{
				alert("<cf_get_lang dictionary_id='60482.Yarı mamül olmayan DPL de miktar alanı 1 den büyük olamaz'>!");
				return false;
			}
		}
		
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=document.add_drawing_parts.record_num.value;r++)
		{
			deger_row_kontrol = eval("document.add_drawing_parts.row_kontrol"+r);
			deger_pbs_id = eval("document.add_drawing_parts.pbs_id"+r);
			deger_pbs_code = eval("document.add_drawing_parts.pbs_code"+r);
			deger_product_code = eval("document.add_drawing_parts.special_code"+r);
			deger_stock_id = eval("document.add_drawing_parts.stock_id"+r);
			deger_product_id = eval("document.add_drawing_parts.product_id"+r);
			deger_product_name = eval("document.add_drawing_parts.product_name"+r);
			deger_quantity = eval("document.add_drawing_parts.quantity"+r);
			if(deger_row_kontrol.value == 1)
			{
				record_exist=1;
				if (deger_product_id.value == "" || deger_product_name.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='40069.Lütfen Ürün Seçiniz'>!");
					return false;
				}
				if (deger_quantity.value == "" || deger_quantity.value == 0)
				{ 
					alert ("<cf_get_lang dictionary_id='29943.Lütfen Miktar Giriniz'>!");
					return false;
				}
				if (deger_pbs_id.value == "" || deger_pbs_code.value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='60483.Lütfen PBS Seçiniz'>!");
					return false;
				}		
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='60484.Lütfen DPL Satırları Ekleyiniz'> !");
			return false;
		}
		return process_cat_control();
	}
	function pencere_ac_work(no)
	{
		if(document.add_drawing_parts.project_id.value == "" && document.add_drawing_parts.project_head.value == "")
		{
			alert("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'> !");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&project_id='+document.getElementById('project_id').value+'&project_head='+document.getElementById('project_head').value+'&field_id=work_id' + no +'&field_name=work_head' + no,'list');
	}
	
	function pencere_ac_pbs_code(no)
	{
		if(document.add_drawing_parts.main_product_id.value == "" && document.add_drawing_parts.main_product_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz'> !");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_pbs_code&is_submitted=1&is_single=1&project_id='+document.getElementById('project_id').value+'&product_id='+document.getElementById('main_product_id').value+'&field_id=pbs_id' + no +'&field_name=pbs_code' + no,'medium','popup_list_pbs_code');
	}
	
	function controlInput(type)
	{
		if(type == 1)
		{
			if(document.add_drawing_parts.main_product_id.value == "" && document.add_drawing_parts.main_product_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz'> !");
				return false;
			}
		}
		else
		{
			if(document.add_drawing_parts.project_id.value == "" && document.add_drawing_parts.project_head.value == "")
			{
				alert("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'> !");
				return false;
			}
		}
	}
</script>

