<!--- Güncelleme sayfasına bu url_str'nin konulma amacı;eğer spect güncelleme sayfasına üretim emrinde spect seçerken
spect detayına girilirse ve burdan da tekrar konfigüratör'e tıklanara spect listesine gidilirse url_str değişkenlerini kaybetmemesi için
eklendi.Tüm spect güncelleme sayfalarına eklenmesi gerekiyor M.ER 20071108
 --->
<cfscript> 
	url_str='';
	
	if(isdefined('attributes.CREATE_MAIN_SPECT_AND_ADD_NEW_SPECT_ID') and len(attributes.CREATE_MAIN_SPECT_AND_ADD_NEW_SPECT_ID))
		url_str=url_str&'&CREATE_MAIN_SPECT_AND_ADD_NEW_SPECT_ID=1';
	if(isdefined('attributes.field_id') and len(attributes.field_id))
		url_str=url_str&'&field_id=#attributes.field_id#';
	if(isdefined('attributes.field_name') and len(attributes.field_name))
		url_str=url_str&'&field_name=#attributes.field_name#';
	if(isdefined('attributes.last_spect') and len(attributes.last_spect))
		url_str=url_str&'&last_spect=#attributes.last_spect#';
	if(isdefined('attributes.main_to_add_spect') and len(attributes.main_to_add_spect))
		url_str=url_str&'&main_to_add_spect=#attributes.main_to_add_spect#';
	if(isdefined('attributes.PR_ORDER_ID') and len(attributes.PR_ORDER_ID))
		url_str=url_str&'&PR_ORDER_ID=#attributes.PR_ORDER_ID#';
	if(isdefined('attributes.P_ORDER_ID') and len(attributes.P_ORDER_ID))
		url_str=url_str&'&P_ORDER_ID=#attributes.P_ORDER_ID#';
	if(isdefined('attributes.SPECT_CHANGE') and len(attributes.SPECT_CHANGE))
		url_str=url_str&'&SPECT_CHANGE=#attributes.SPECT_CHANGE#';
</cfscript>
<cfquery name="GET_SPECT" datasource="#dsn3#">
	SELECT * FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #attributes.spect_main_id#
</cfquery>
<cfif GET_SPECT.RECORDCOUNT>
	<cfset attributes.stock_id=GET_SPECT.STOCK_ID>
	<cfset attributes.product_id=GET_SPECT.PRODUCT_ID>
</cfif>

<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
		SELECT 
			SPECT_MAIN_ROW.*,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY
		FROM 
			SPECT_MAIN_ROW,
			STOCKS
		WHERE 
			SPECT_MAIN_ID = #attributes.spect_main_id#
			AND SPECT_MAIN_ROW.STOCK_ID=STOCKS.STOCK_ID
	UNION 
		SELECT 
			SPECT_MAIN_ROW.*,
			'',
			''
		FROM 
			SPECT_MAIN_ROW
		WHERE 
			SPECT_MAIN_ID = #attributes.spect_main_id# AND
			STOCK_ID IS NULL
</cfquery>
<cfif len(attributes.product_id)>
	<cfquery name="GET_SPECTS_VARIATION" datasource="#DSN1#">
		SELECT
			PRODUCT_DT_PROPERTIES.PRODUCT_ID,
			PRODUCT_DT_PROPERTIES.TOTAL_MIN,
			PRODUCT_DT_PROPERTIES.TOTAL_MAX,
			PRODUCT_DT_PROPERTIES.AMOUNT,
			PRODUCT_PROPERTY.PROPERTY,
			PRODUCT_PROPERTY.PROPERTY_ID,
			PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL,
			PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID
		FROM
			PRODUCT_DT_PROPERTIES,
			PRODUCT_PROPERTY,
			PRODUCT_PROPERTY_DETAIL
		WHERE
			PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND
			PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.product_id# AND
			PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
			PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
			PRODUCT_DT_PROPERTIES.IS_OPTIONAL = 1
	</cfquery>
</cfif>
<cfsavecontent variable="img_">
  <a href="<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#attributes.stock_id#&#url_str#</cfoutput>"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="Liste"></a>
</cfsavecontent>
<cf_popup_box title="Spect Güncelle No:<cfoutput>#attributes.spect_main_id#</cfoutput>" right_images="#img_#">
    <cfform name="upd_spect_variations" action="#request.self#?fuseaction=objects.emptypopup_upd_spect_main" method="post">
    <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
    <table>
        <tr>
            <td width="65"><cf_get_lang dictionary_id='57647.Spect'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.spec girmelisiniz'></cfsavecontent>
            <cfinput type="text" name="spect_name" required="yes" message="#message#" style="width:200;" value="#GET_SPECT.SPECT_MAIN_NAME#" maxlength="50">
            </td>
            <td><cf_get_lang dictionary_id='57493.Aktif'></td>
            <td><input type="checkbox" value="<cfoutput>#GET_SPECT.SPECT_STATUS#</cfoutput>" <cfif GET_SPECT.SPECT_STATUS eq 1>checked</cfif> name="spect_status" id="spect_status"></td>
        </tr>
    </table>
    <cf_form_list>
    	<thead>
            <tr>
                <th width="15"><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                <th width="120"><cf_get_lang dictionary_id="57518.Stok Kodu"></th>
                <th width="350"><cf_get_lang dictionary_id="57657.Ürün"></th>
                <th width="15">SB</th>
                <th width="50"><cf_get_lang dictionary_id="57635.Miktar">*</th>
            </tr>
            <tr class="list" height="22">
                <th width="15">&nbsp;</th>
                <th width="120">&nbsp;</th>
                <th width="350"><cfoutput>#GET_SPECT.SPECT_MAIN_NAME#</cfoutput></th>
                <th width="15">&nbsp;</th>
                <th width="50">1</th>
            </tr>
        </thead>
        <tbody name="table_tree" id="table_tree">
			<cfif isdefined("attributes.product_id")>
                <input type="hidden" name="value_product_id" id="value_product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                <input type="hidden" name="value_stock_id" id="value_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
            </cfif>
            <cfquery name="GET_SPECT_TREE" dbtype="query">
                SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY=0
            </cfquery>
            <cfif GET_SPECT_TREE.RECORDCOUNT>
                <cfset product_id_list=ValueList(GET_SPECT_TREE.PRODUCT_ID,',')>
            </cfif>
            <cfif isdefined("product_id_list") and len(product_id_list)>
                <cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
                    SELECT
                        AP.PRODUCT_ID ASIL_PRODUCT,
                        AP.ALTERNATIVE_PRODUCT_ID,
                        P.PRODUCT_NAME, 
                        P.PRODUCT_ID,
                        P.STOCK_ID,
                        P.PROPERTY
                    FROM
                        STOCKS AS P,
                        ALTERNATIVE_PRODUCTS AS AP
                    WHERE
                        <cfif len(attributes.product_id)>
                            P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=#attributes.product_id#) AND
                        </cfif>
                        (
                            (
                                P.PRODUCT_ID=AP.PRODUCT_ID AND
                                AP.ALTERNATIVE_PRODUCT_ID IN (#product_id_list#)
                            )
                            OR
                            (
                                P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
                                AP.PRODUCT_ID IN (#product_id_list#)
                            )
                        )
                </cfquery>
                <cfset product_id_alter_list=0>
            </cfif>
            <cfoutput query="GET_SPECT_TREE">
            <cfif is_configure>
                <cfquery name="get_alternative" dbtype="query">
                    SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT=#PRODUCT_ID# OR ALTERNATIVE_PRODUCT_ID=#PRODUCT_ID#
                </cfquery>
            </cfif>
            <tr id="tree_row#currentrow#">
                <input type="hidden" name="tree_row_kontrol#currentrow#" id="tree_row_kontrol#currentrow#" value="1">
                <input type="hidden" name="tree_is_configure#currentrow#" id="tree_is_configure#currentrow#" value="<cfif is_configure>1</cfif>">
                <td><cfif is_configure><a href="javascript://" onClick="sil_tree_row(#currentrow#)"> <img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='50765.Ürün Sil'>" border="0"></a></cfif></td>
                <td><input type="hidden" name="tree_stock_id#currentrow#" id="tree_stock_id#currentrow#" value="#GET_SPECT_TREE.STOCK_ID#">
                <input type="text" name="tree_stock_code#currentrow#" id="tree_stock_code#currentrow#" value="#GET_SPECT_TREE.STOCK_CODE#" style="width:120px" readonly></td>
                <td nowrap="nowrap">
                    <select name="tree_product_id#currentrow#" id="tree_product_id#currentrow#" style="width:300px;">
                        <option value="#product_id#,#stock_id#,#PRODUCT_NAME# ">#PRODUCT_NAME#</option>
                        <cfif is_configure>
                        <cfloop query="get_alternative">
                            <option value="#get_alternative.PRODUCT_ID#,#get_alternative.stock_id#,#get_alternative.product_name# #get_alternative.PROPERTY# ">#get_alternative.product_name# #get_alternative.PROPERTY#</option>
                        </cfloop>
                        </cfif>
                    </select>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+list_getat(document.upd_spect_variations.tree_product_id#currentrow#.value,1)+'&sid='+list_getat(document.upd_spect_variations.tree_product_id#currentrow#.value,2),'medium')"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='46799.Ürün Detay'>" border="0" align="absmiddle"></a>
                </td>
                <td><input type="checkbox" name="tree_is_sevk#currentrow#" id="tree_is_sevk#currentrow#" value="1" <cfif GET_SPECT_TREE.IS_SEVK>checked</cfif>></td>
                <td><input type="text" name="tree_amount#currentrow#" id="tree_amount#currentrow#" value="#TLFormat(GET_SPECT_TREE.AMOUNT,2)#" class="moneybox" style="width:50px" <cfif is_configure eq 0>readonly</cfif>></td>
            </tr>
        </cfoutput>
        <input type="hidden" name="tree_record_num" id="tree_record_num" value="<cfoutput>#GET_SPECT_TREE.RECORDCOUNT#</cfoutput>">
    </tbody>
    </cf_form_list>
    <cfquery name="GET_SPECT_PRO_COUNT" dbtype="query">
        SELECT IS_PROPERTY FROM GET_SPECT_ROW WHERE IS_PROPERTY=1
    </cfquery>
    <cfset satir=0>
    <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#GET_SPECT_PRO_COUNT.RECORDCOUNT#</cfoutput>">
    <cfif len(attributes.product_id)>
        <cfoutput query="get_spects_variation">
            <cf_form_list>
            <thead>
                <tr>
                    <th colspan="5"><cf_get_lang dictionary_id="32968.Ek Bileşenler"> - <cf_get_lang dictionary_id="32969.Uyumlu Ürünler"></th>
                </tr>
                <tr>
                    <th width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_stock_property&property_detail_id=#get_spects_variation.property_detail_id#&property_id=#get_spects_variation.property_id#&product_id=#attributes.product_id#<cfif isdefined("attributes.company_id")>&company_id=#attributes.company_id#</cfif>&add_row_func=add_row_property&table_id=table#currentrow#&total_min=#total_min#&total_max=#total_max#','medium');"><img src="/images/plus_ques.gif" title="<cf_get_lang dictionary_id='32968.Ek Bileşen-Özellik'>" border="0"></a></th>
                    <th colspan="5" width="500">
                        <b>#property# / #property_detail#</b>  
                        <cf_get_lang dictionary_id="33329.Değer Aralığı">: #total_min# - #total_max# 
                        <b><cf_get_lang dictionary_id="57635.Miktar">: #AMOUNT#</b>
                    </th>
                </tr>
             </thead>
             <tbody name="table#currentrow#" id="table#currentrow#">
                <cfquery name="GET_SPECT_PRO" dbtype="query">
                    SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY=1 AND PROPERTY_ID=#property_id# AND VARIATION_ID=#property_detail_id#
                </cfquery>
                <cfloop query="GET_SPECT_PRO">
                <cfset satir=satir+1>
                    <tr id="frm_row#satir#">
                        <td><input type="hidden" name="row_kontrol#satir#" id="row_kontrol#satir#" value="1">
                        <input type="hidden" name="product_id#satir#" id="product_id#satir#" value="#product_id#"><a href="javascript://" onClick="sil_row('#satir#')"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='50765.Ürün Sil'>" border="0"></a></td>
                        <td><input type="hidden" name="stock_id#satir#" id="stock_id#satir#" value="#GET_SPECT_PRO.stock_id#">
                        <input type="text" name="stock_code#satir#" id="stock_code#satir#" value="#stock_code#" style="width:120px" readonly>
                        <input type="hidden" name="total_min#satir#" id="total_min#satir#" value="#GET_SPECT_PRO.total_min#">
                        <input type="hidden" name="total_max#satir#" id="total_max#satir#" value="#GET_SPECT_PRO.total_max#"></td>
                        <td><input type="text" name="product_name#satir#" id="product_name#satir#" value="#GET_SPECT_PRO.product_name#" style="width:300px" readonly><a href="javascript://" onclick="open_product_detail('#GET_SPECT_PRO.product_id#','#GET_SPECT_PRO.stock_id#')"> <img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='46799.Ürün Detay'>" align="absmiddle" border="0"></a></td>
                        <td><input type="checkbox" name="is_sevk#satir#" id="is_sevk#satir#" value="1" <cfif GET_SPECT_PRO.IS_SEVK>checked</cfif>></td>
                        <td><input type="text" name="amount#satir#" id="amount#satir#" value="#GET_SPECT_PRO.AMOUNT#" style="width:50px" class="moneybox">
                        <input type="hidden" name="property_id#satir#" id="property_id#satir#" value="#GET_SPECT_PRO.property_id#">
                        <input type="hidden" name="variation_id#satir#" id="variation_id#satir#" value="#GET_SPECT_PRO.VARIATION_ID#"></td>
                    </tr>
                </cfloop>
            </tbody>
            </cf_form_list>
        </cfoutput>
      </cfif>
    <cf_popup_box_footer>
        <cf_record_info query_name="get_spect">
        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
   </cf_popup_box_footer>
  </cfform>
</cf_popup_box>
<script type="text/javascript">
tree_row_count=<cfoutput>#GET_SPECT_TREE.RECORDCOUNT#</cfoutput>;
function open_product_detail(pro_id,s_id)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
}

function open_tree_add_row(sy)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_spect_variations.tree_stock_id'+sy+'&field_name=upd_spect_variations.tree_product_name'+sy+'&product_id=upd_spect_variations.tree_product_id'+sy+'&field_code=upd_spect_variations.tree_stock_code'+sy,'list');
}

function add_row()
{
	tree_row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_tree").insertRow(document.getElementById("table_tree").rows.length);
	newRow.setAttribute("name","tree_row" + tree_row_count);
	newRow.setAttribute("id","tree_row" + tree_row_count);		
	newRow.setAttribute("NAME","tree_row" + tree_row_count);
	newRow.setAttribute("ID","tree_row" + tree_row_count);
	document.upd_spect_variations.tree_record_num.value=tree_row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="tree_is_configure'+tree_row_count+'" value="0"><input type="hidden" name="tree_row_kontrol'+tree_row_count+'" value="1"><a href="javascript://" onClick="sil_tree_row('+tree_row_count+')"><img src="/images/delete_list.gif" alt="<cf_get_lang dictionary_id='50765.Ürün Sil'>" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="tree_stock_code'+tree_row_count+'" value="" style="width:120px" readonly><input type="hidden" name="tree_product_id'+tree_row_count+'" value=""><input type="hidden" name="tree_stock_id'+tree_row_count+'" value="">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="tree_product_name'+tree_row_count+'" value="" style="width:300px" readonly><a href="javascript://" onclick="open_tree_add_row('+tree_row_count+')"> <img src="/images/plus_thin.gif" alt="Ürün Ekle" border="0" align="absmiddle"></a><a href="javascript://" onclick="open_product_detail(upd_spect_variations.tree_product_id'+tree_row_count+'.value,upd_spect_variations.tree_stock_id'+tree_row_count+'.value)"> <img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='46799.Ürün Detay'>" border="0" align="absmiddle"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="tree_is_sevk'+tree_row_count+'" value="1">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="tree_amount'+tree_row_count+'" value="1" class="moneybox" style="width:50px">';
}

function sil_tree_row(sy)
{
	var my_element=eval("upd_spect_variations.tree_row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("tree_row"+sy);
	my_element.style.display="none";
}

row_count=<cfif isdefined("GET_SPECT_PRO_COUNT.RECORDCOUNT")><cfoutput>#GET_SPECT_PRO_COUNT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
function add_row_property(product_id,stock_id,stock_code,product_name,total_max,total_min,price,money,property_id,variation_id,table_id)
{
	if(document.upd_spect_variations.value_stock_id.value==stock_id)
	{
		alert("<cf_get_lang dictionary_id='60318.Ana ürünü kendi spectine ekleyemezsiniz'>!");
		return false;
	}
	row_count++;
	var newRow;
	var newCell;
	form_table=eval("document.getElementById('" + table_id + "')");
	newRow = document.getElementById("form_table").insertRow(document.getElementById("form_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	document.upd_spect_variations.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><input type="hidden" name="product_id'+row_count+'" value="'+product_id+'"><a href="javascript://" onClick="sil_row('+row_count+')"><img src="/images/delete_list.gif" alt="<cf_get_lang dictionary_id='50765.Ürün Sil'>" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="stock_id'+row_count+'" value="'+stock_id+'"><input type="text" name="stock_code'+row_count+'" value="'+stock_code+'" style="width:120px" readonly><input type="hidden" name="total_min'+row_count+'" value="'+total_min+'"><input type="hidden" name="total_max'+row_count+'" value="'+total_max+'">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="product_name'+row_count+'" value="'+product_name+'" style="width:300px" readonly><a href="javascript://" onclick="open_product_detail('+product_id+','+stock_id+')"> <img src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='46799.Ürün Detay'>" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="is_sevk'+row_count+'" value="1">';		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="amount'+row_count+'" value="1" style="width:50px" class="moneybox"><input type="hidden" name="property_id'+row_count+'" value="'+property_id+'"><input type="hidden" name="variation_id'+row_count+'" value="'+variation_id+'">';
}

function sil_row(sy)
{
	var my_element=eval("upd_spect_variations.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol()
{
	for (var r=1;r<=upd_spect_variations.tree_record_num.value;r++)
	{
			form_tree_amount = eval('upd_spect_variations.tree_amount'+r);
			form_tree_amount.value = filterNum(form_tree_amount.value);
	}

	//ozellikli
	for (var r=1;r<=upd_spect_variations.record_num.value;r++)
	{
		form_product_id = eval('upd_spect_variations.product_id'+r);
		form_product_name = eval('upd_spect_variations.product_name'+r);
		form_amount = eval('upd_spect_variations.amount'+r);
		form_total_min = eval('upd_spect_variations.total_min'+r);
		form_total_max = eval('upd_spect_variations.total_max'+r);
		form_amount.value = filterNum(form_amount.value);
	}
}
</script>
