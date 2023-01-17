<cfquery name="get_drawing_part" datasource="#dsn3#">
	SELECT 
		DP.*,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE_2
	FROM 
		DRAWING_PART DP
		RIGHT JOIN PRODUCT P ON DP.MAIN_PRODUCT_ID = P.PRODUCT_ID
	WHERE 
		DP.DPL_ID = #attributes.dpl_id#
</cfquery>
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
    	DPL_ID = #attributes.dpl_id#
</cfquery>
<table class="dph">
	<tr>
		<td class="dpht"><cf_get_lang dictionary_id='51098.DPL'> <cf_get_lang dictionary_id='57464.Güncelle'></td>
		<td class="dphb">
			<cfoutput>
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_drawing_part_history&dpl_id=#attributes.dpl_id#','list');"><img src="/images/history.gif" border="0" title=""></a>
                <a href="#request.self#?fuseaction=product.form_add_drawing_parts"><img src="/images/plus1.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
                <cfif not len(get_drawing_part.project_id)>
                    <a href="#request.self#?fuseaction=product.form_add_drawing_parts&dpl_id=#attributes.dpl_id#"><img src="/images/plus.gif" border="0" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></a>
                </cfif>
            </cfoutput>
		</td>
	</tr>
</table>
<cfform name="upd_drawing_parts" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_drawing_parts">
    <input type="hidden" name="dpl_id" id="dpl_id" value="<cfoutput>#attributes.dpl_id#</cfoutput>" />
    <input type="hidden" name="is_confirm" id="is_confirm" value="0" />
    <cf_basket_form>
        <table>
            <tr>
                <td></td>
                <td nowrap="nowrap"><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_drawing_part.is_active eq 1>checked="checked"</cfif>/><cf_get_lang dictionary_id='57493.aktif'>&nbsp;
                    <input type="checkbox" name="is_main_dpl" id="is_main_dpl" value="1" <cfif get_drawing_part.is_main_dpl eq 1>checked="checked"</cfif>/><cf_get_lang dictionary_id='40161.Ana Ürün'>
                    <input type="checkbox" name="is_yrm" id="is_yrm" value="1" <cfif get_drawing_part.is_yrm eq 1>checked="checked"</cfif>/><cf_get_lang dictionary_id='37473.Yari Mamul'>
                </td>
            </tr>
            <tr>
                <td width="65"><cf_get_lang dictionary_id='40161.Ana Ürün'> *</td>
                <td width="170">
                    <input type="hidden" name="main_product_id" id="main_product_id" value="<cfoutput>#get_drawing_part.main_product_id#</cfoutput>">
                    <input name="main_product_name" type="text" id="main_product_name" style="width:150px;" onFocus="AutoComplete_Create('main_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','main_product_id','upd_drawing_parts','3','200');" value="<cfoutput><cfif len(get_drawing_part.product_code_2)>#get_drawing_part.product_code_2#-</cfif>#get_drawing_part.product_name#</cfoutput>" autocomplete="off">
                    <a href="javascript://" id="mainProductLink" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_drawing_parts.main_product_id&field_name=upd_drawing_parts.main_product_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                </td>
                <td nowrap="nowrap"><cf_get_lang dictionary_id='58080.Resim'> / <cf_get_lang dictionary_id='51115.DPL No'> *</td>
                <td width="170">
                    <cfquery name="get_asset_name" datasource="#dsn#">
                        SELECT ASSET_NAME,ASSET_NO + ' - ' + CAST(REVISION_NO AS nvarchar) AS ASSET_NO,PROJECT_MULTI_ID FROM ASSET WHERE ASSET_ID = #get_drawing_part.asset_id#
                    </cfquery>
                    <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#get_drawing_part.asset_id#</cfoutput>">
                    <input type="text" name="asset_no" id="asset_no" value="<cfoutput>#get_asset_name.asset_no#</cfoutput>" onFocus="AutoComplete_Create('asset_no','ASSET_NO,ASSET_NAME,ASSET_ID','ASSET_NO,ASSET_NAME','get_asset_autocomplete','','ASSET_NO,ASSET_NAME,ASSET_ID','asset_no,asset_name,asset_id','','3','140');" style="width:135px;">
                    <a href="javascript://" id="assetLink" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_digital_asset&sbmt=1&field_id=asset_id&field_name=asset_name&field_no=asset_no','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> 
                </td>
                <td><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
                <td><input type="text" name="dpl_product_name" id="dpl_product_name" value="<cfif len(get_drawing_part.dpl_product_id)><cfoutput>#get_product_name(get_drawing_part.dpl_product_id)#</cfoutput></cfif>" style="width:135px;">
                    <cfif len(get_drawing_part.dpl_product_id)>
                        <a href="<cfoutput>#request.self#?fuseaction=product.list_product&event=det&pid=#get_drawing_part.dpl_product_id#</cfoutput>" target="_blank"> <img src="/images/plus_thin_p.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='58764.Ürün Detay'>" border="0"></a>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='57416.proje'></td>
                <td><cfif len(get_drawing_part.project_id)>
                        <cfquery name="get_project_name" datasource="#dsn#">
                            SELECT PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID = #get_drawing_part.project_id#
                        </cfquery>
                        <cfset project_name_ = '#get_project_name.project_number#-#get_project_name.project_head#'>
                    <cfelse>
                        <cfset project_name_ = ''>
                    </cfif>
                    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_drawing_part.project_id#</cfoutput>">
                    <input type="text" name="project_head"  id="project_head" style="width:150px;" value="<cfoutput>#project_name_#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                    <a href="javascript://" id="projectLink" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_drawing_parts.project_id&project_head=upd_drawing_parts.project_head');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                </td>
                <td width="65"><cf_get_lang dictionary_id='60494.Resim Adı'> *</td>
                <td width="170"><input type="text" name="asset_name" id="asset_name" value="<cfoutput>#get_asset_name.asset_name#</cfoutput>" style="width:135px;"></td>
                <td><cf_get_lang dictionary_id='57635.Miktar'></td>
                <td><input type="text" name="main_quantity" id="main_quantity" value="<cfoutput>#TLFormat(get_drawing_part.quantity,2)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;"></td>
            </tr>
            <tr>
                <td width="85"><cf_get_lang dictionary_id='58859.Süreç'>*</td>
                <td><cf_workcube_process is_upd='0' process_cat_width='150' select_value='#get_drawing_part.stage_id#' is_detail='1'></td>
            </tr>
            <cfif len(get_asset_name.project_multi_id)>
                <tr height="20">
                    <td class="txtboldblue"><cf_get_lang dictionary_id='51011.İlişkili Projeler'></td>
                </tr>
                <tr>
                    <td colspan="6">
                    <cfloop list="#get_asset_name.project_multi_id#" index="i">
                        <cfquery name="get_projects_" datasource="#dsn#">
                            SELECT PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID = #i#
                        </cfquery>
                        <cfoutput><a href="#request.self#?fuseaction=project.projects&event=det&id=#i#" target="_blank" class="tableyazi">#get_projects_.PROJECT_NUMBER#-#get_projects_.PROJECT_HEAD#</a></cfoutput>,
                    </cfloop>
                    </td>
                </tr>
            </cfif>
        </table>
        <cf_basket_form_button>
            <cf_record_info query_name="get_drawing_part">
            <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0' type_format="1">
        </cf_basket_form_button>
    </cf_basket_form>
    <cf_basket>
        <cf_form_list name="table1" id="table1" class="form_list" margin="0">
        	<thead>
                <tr>
                    <th colspan="6"><cf_get_lang dictionary_id='37330.Malzeme Listesi'></th>
                    <th>
                        <input type="hidden" name="pbs_id0" id="pbs_id0" onfocus="hepsi(row_count,'pbs_code');" value="">
                        <input name="pbs_code0" id="pbs_code0" type="text" style="width:130px;" onkeypress="controlInput(1);" onkeydown="controlInput(1);" onFocus="AutoComplete_Create('pbs_code0','PBS_CODE','PBS_CODE','get_pbs',''+document.upd_drawing_parts.main_product_id.value+'','PBS_ID','pbs_id0','upd_drawing_parts',1);hepsi(row_count,'pbs_code');" value="" autocomplete="off">
                        <a href="javascript://" onClick="pencere_ac_pbs_code(0);"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                    </th>
                    <th>
                        <input type="hidden" name="work_id0" id="work_id0" value="">
                        <input type="text" name="work_head0" id="work_head0" style="width:130px;" onkeypress="controlInput(2);" onkeydown="controlInput(2);" value="" onFocus="AutoComplete_Create('work_head0','WORK_HEAD','WORK_HEAD','get_work',''+document.upd_drawing_parts.project_id.value+'','WORK_ID','work_id0','',3,139);hepsi(row_count,'work_head');">
                        <a href="javascript://" onClick="pencere_ac_work(0);"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                    </th>
                </tr>
                <tr>
                	<th width="15"></th>
                    <th width="30" style="text-align:center;"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_drawing_part_rows.recordcount#</cfoutput>"><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();"></th>
                    <th width="255"><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th width="150"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th width="50"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th width="155"><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th width="155"><cf_get_lang dictionary_id='37200.PBS'></th>
                    <th width="155"><cf_get_lang dictionary_id='58445.İş'></th>
                </tr>
            </thead>
            <cfoutput query="get_drawing_part_rows">
            <tbody>
                <tr id="frm_row#currentrow#">
                    <td style="text-align:center;">#currentrow#</td>
                    <td><input  type="hidden" value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a style="cursor:pointer" onClick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id ='58972.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a></td>
                    <td><input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                        <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif len(product_id) and len(stock_id)>#product_name#</cfif>" onFocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID,PRODUCT_CODE_2,PRODUCT_UNIT_ID,MAIN_UNIT','stock_id#currentrow#,product_id#currentrow#,special_code#currentrow#,unit_id#currentrow#,unit#currentrow#','upd_drawing_parts',1);" style="width:240px;" class="boxtext">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=upd_drawing_parts.stock_id#currentrow#&product_id=upd_drawing_parts.product_id#currentrow#&field_name=upd_drawing_parts.product_name#currentrow#&field_unit=upd_drawing_parts.unit_id#currentrow#&field_unit_name=upd_drawing_parts.unit#currentrow#&field_special_code=upd_drawing_parts.special_code#currentrow#','list');"><img border="0" align="middle" src="/images/plus_thin.gif"></a>
                    </td>
                    <td><input type="text" name="special_code#currentrow#" id="special_code#currentrow#" value="<cfif len(product_id) and len(stock_id)>#product_code_2#</cfif>" style="width:150px;" readonly class="boxtext"></td>
                    <td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TLFormat(quantity,2)#" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;" class="box"></td>
                    <td><input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#unit_id#"><input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#unit#" style="width:50px;" readonly class="boxtext"></td>
                    <td><input type="hidden" name="pbs_id#currentrow#" id="pbs_id#currentrow#" value="#pbs_id#">
                        <input name="pbs_code#currentrow#" id="pbs_code#currentrow#" type="text" class="boxtext" style="width:139px;" value="<cfif len(pbs_id)>#pbs_code#</cfif>" onFocus="AutoComplete_Create('pbs_code#currentrow#','PBS_CODE','PBS_CODE','get_pbs',''+document.upd_drawing_parts.main_product_id.value+'','PBS_ID','pbs_id#currentrow#','upd_drawing_parts',1);">
                        <a href="javascript://" onClick="pencere_ac_pbs_code('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                    <td><input type="hidden" class="boxtext" name="work_id#currentrow#" id="work_id#currentrow#" value="#work_id#">
                        <input name="work_head#currentrow#" id="work_head#currentrow#" type="text" class="boxtext" style="width:139px;" value="<cfif len(work_id)>#work_head#</cfif>"  onkeypress="controlInput(2);" onFocus="AutoComplete_Create('work_head#currentrow#','WORK_HEAD','WORK_HEAD','get_work',''+document.upd_drawing_parts.project_id.value+'','WORK_ID','work_id#currentrow#','',3,139);">
                        <a href="javascript://" onClick="pencere_ac_work('#currentrow#');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='58691.iş listesi'>" align="absmiddle" border="0"></a>
                    </td>
                </tr>
            </tbody>
        </cfoutput>
        </cf_form_list>
    </cf_basket>
</cfform>
<script type="text/javascript">
function hepsi(satir,nesne)
{
	deger=eval("document.upd_drawing_parts."+nesne+"0");
	for(var i=1;i<=satir;i++)
	{ 
		nesne_=eval("document.upd_drawing_parts."+nesne+i);
		nesne_.value=deger.value;
	}
	if(nesne=='work_head')
		hepsi(row_count,'work_id');
	
	if(nesne=='pbs_code')
		hepsi(row_count,'pbs_id');
}
row_count=<cfoutput>#get_drawing_part_rows.recordcount#</cfoutput>;
function sil(sy)
{
	my_element = document.getElementById('row_kontrol' + sy);	
	my_element.value=0;
	my_element = document.getElementById('frm_row'+sy);
	my_element.style.display = "none";
}

function add_row(special_code,exp_product_id,exp_stock_id,exp_product_name,row_quantity,row_unit,row_unit_id,row_pbs_id,row_pbs_code,row_work_id,row_work_head)
{
	if(upd_drawing_parts.main_product_id.value == "" && upd_drawing_parts.main_product_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz'> !");
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
	newRow.className = 'color-row';
	document.upd_drawing_parts.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="no_' + row_count +'" id="no_' + row_count +'" style="width:100%;" class="boxtext" value="'+row_count+'">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1" id="row_kontrol' + row_count +'"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="Satır Kopyala"><img  src="images/copy_list.gif" border="0"></a>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name'+ row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product_autocomplete\',\'0\',\'STOCK_ID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE_2,PRODUCT_UNIT_ID,MAIN_UNIT\',\'stock_id' + row_count +',product_id' + row_count +',product_name'+ row_count +',special_code' + row_count +',unit_id' + row_count +',unit' + row_count +'\',\'\',3,130);" maxlength="50" style="width:242px;" value="'+exp_product_name+'">';
	newCell.innerHTML += '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&field_id=upd_drawing_parts.stock_id" + row_count + "&product_id=upd_drawing_parts.product_id" + row_count + "&field_name=upd_drawing_parts.product_name" + row_count + "&field_unit=upd_drawing_parts.unit_id" + row_count + "&field_unit_name=upd_drawing_parts.unit" + row_count + "&field_special_code=upd_drawing_parts.special_code" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="special_code' + row_count +'" id="special_code' + row_count +'" readonly style="width:150px;" class="boxtext" value="'+special_code+'">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+row_quantity+'" onkeyup="return(FormatCurrency(this,event));" style="width:50px;" class="box">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id'+ row_count +'" value="'+row_unit_id+'"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" value="'+row_unit+'" readonly style="width:50px;" class="boxtext">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="pbs_id' + row_count +'" id="pbs_id'+ row_count +'" value="'+row_pbs_id+'"><input type="text" name="pbs_code' + row_count +'" id="pbs_code'+ row_count +'" value="'+row_pbs_code+'" onkeypress="controlInput(1);" onFocus="AutoComplete_Create(\'pbs_code'+ row_count +'\',\'PBS_CODE\',\'PBS_CODE\',\'get_pbs\',\''+document.upd_drawing_parts.main_product_id.value+'\',\'PBS_ID\',\'pbs_id'+ row_count +'\',\'\',3,100);" style="width:140px;" class="boxtext">';
	newCell.innerHTML +='<a href="javascript://" onClick="pencere_ac_pbs_code('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="work_id' + row_count +'" id="work_id'+ row_count +'" value="'+row_work_id+'"><input type="text" name="work_head' + row_count +'" id="work_head'+ row_count +'" value="'+row_work_head+'" onkeypress="controlInput(2);" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\''+document.upd_drawing_parts.project_id.value+'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,139);" style="width:142px;" class="boxtext">';
	newCell.innerHTML +='<a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';

}

function pencere_ac_work(no)
{
	if(upd_drawing_parts.project_id.value == "" && upd_drawing_parts.project_head.value == "")
	{
		alert("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'> !");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&project_id='+document.getElementById('project_id').value+'&project_head='+document.getElementById('project_head').value+'&field_id=work_id' + no +'&field_name=work_head' + no,'list');
}
function pencere_ac_pbs_code(no)
{
	if(upd_drawing_parts.main_product_id.value == "" && upd_drawing_parts.main_product_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz'> !");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_pbs_code&is_submitted=1&is_single=1&project_id='+document.getElementById('project_id').value+'&product_id='+document.getElementById('main_product_id').value+'&field_id=pbs_id' + no +'&field_name=pbs_code' + no,'medium','popup_list_pbs_code');
}

<cfoutput>
record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
function copy_row(no_info)
{ 
	special_code = document.getElementById('special_code' + no_info).value;	
	exp_stock_id = document.getElementById('stock_id' + no_info).value;	
	exp_product_id = document.getElementById('product_id' + no_info).value;	
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
		alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanimlayiniz ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!");
		return false;
	}
	if(document.upd_drawing_parts.main_product_id.value == "" && document.upd_drawing_parts.main_product_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz'> !");
		return false;
	}
	if(document.upd_drawing_parts.asset_no.value == "" && document.upd_drawing_parts.asset_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='58080.Resim'> <cf_get_lang dictionary_id ='57734.Seçiniz'> !");
		return false;
	}
	if (document.upd_drawing_parts.main_quantity.value == "" || document.upd_drawing_parts.main_quantity.value == 0)
	{ 
		alert ("<cf_get_lang dictionary_id='60481.Lütfen Ana Miktar Alanını Giriniz'>!");
		return false;
	}
	if(document.upd_drawing_parts.is_yrm.checked == false)
	{
		if(document.upd_drawing_parts.main_quantity.value > 1)
		{
			alert("<cf_get_lang dictionary_id='60482.Yarımamül olmayan DPL de miktar alanı 1 den büyük olamaz'>!");
			return false;
		}
	}
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	for(r=1;r<=upd_drawing_parts.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.upd_drawing_parts.row_kontrol"+r);
		deger_pbs_id = eval("document.upd_drawing_parts.pbs_id"+r);
		deger_pbs_code = eval("document.upd_drawing_parts.pbs_code"+r);
		deger_product_code = eval("document.upd_drawing_parts.special_code"+r);
		deger_product_id = eval("document.upd_drawing_parts.product_id"+r);
		deger_stock_id = eval("document.upd_drawing_parts.stock_id"+r);
		deger_product_name = eval("document.upd_drawing_parts.product_name"+r);
		deger_quantity = eval("document.upd_drawing_parts.quantity"+r);
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
			/*var xx = parseInt(upd_drawing_parts.record_num.value-1);
			for(i=r+1;i<=xx;i++)
			{
				deger_row_kontrol_ = eval("document.upd_drawing_parts.row_kontrol"+i);
				if(deger_row_kontrol_.value == 1)
				{
					if((document.getElementById('pbs_id'+r).value == document.getElementById('pbs_id'+i).value) && (document.getElementById('stock_id'+r).value == document.getElementById('stock_id'+i).value) && (document.getElementById('quantity'+r).value == document.getElementById('quantity'+i).value) && (document.getElementById('work_id'+r).value == document.getElementById('work_id'+i).value))
					{
						alert(r+' ve '+i+' .Satırlar Eşit');	
						return false;
					}
				}
			}*/
		}
	}

	if (record_exist == 0) 
	{
		alert("<cf_get_lang dictionary_id='60484.Lütfen DPL Satırları Ekleyiniz'> !");
		return false;
	}
	return process_cat_control();
}

function controlInput(type)
{
	if(type == 1)
	{
		if(document.upd_drawing_parts.main_product_id.value == "" && document.upd_drawing_parts.main_product_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='52302.Lütfen Ana Ürün Seçiniz'> !");
			return false;
		}
	}
	else
	{
		if(document.upd_drawing_parts.project_id.value == "" && document.upd_drawing_parts.project_head.value == "")
		{
			alert("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'> !");
			return false;
		}
	}
}
</script>

