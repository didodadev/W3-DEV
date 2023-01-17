<!--- act_type 1 olanlar musteri fiyat listeleri--->
<cf_get_lang_set module_name="contract">
<cfquery name="GET_PRICE_CATS_SALES" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE IS_SALES = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND PRICE_CAT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_PRICE_CATS_PUR" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE IS_PURCHASE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND PRICE_CAT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_PRICE_CAT_EXCEPTIONS_2" datasource="#DSN3#">
    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        SELECT * FROM PRICE_CAT_EXCEPTIONS WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND ACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
    <cfelse>
        SELECT * FROM PRICE_CAT_EXCEPTIONS WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND ACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
    </cfif>
</cfquery>
<cfform name="form_basket_2" method="post" action="#request.self#?fuseaction=contract.emptypopoup_add_company_price_cat_type">   
    <input name="record_num_2" id="record_num_2" type="hidden" value="<cfoutput>#get_price_cat_exceptions_2.RecordCount#</cfoutput>">
    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
    <cfelse>
        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
    </cfif>
    <cf_grid_list table_width="500">
        <thead>
            <tr>
                <cfif get_module_user(17)><th width="20"><a onClick="add_row_2();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th></cfif>
                <th><cf_get_lang dictionary_id='50814.Alış/satış'></th>
                <th><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
                <th><cf_get_lang dictionary_id='50715.Öncelikli Liste'></th>
            </tr>
        </thead>
        <tbody name="table2" id="table2">
            <cfoutput query="get_price_cat_exceptions_2">
                <tr id="frm_row_2#currentrow#">
                    <input type="hidden" name="row_kontrol_2#currentrow#" id="row_kontrol_2#currentrow#" value="1">
                    <cfif get_module_user(17)><td><a style="cursor:pointer" onclick="sil_2(#currentrow#);"><i class="fa fa-minus" title="Sil"></i></a></cfif>
                    <td>
                        <div class="form-group">
                            <select name="purchase_sales#currentrow#" id="purchase_sales#currentrow#" onChange="kontrol_pricecat(#currentrow#);">
                                <option value="1" <cfif get_price_cat_exceptions_2.purchase_sales eq 1>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
                                <option value="0" <cfif get_price_cat_exceptions_2.purchase_sales eq 0>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <cfif get_price_cat_exceptions_2.purchase_sales eq 1>
                                <select name="price_cat_2#currentrow#" id="price_cat_2#currentrow#">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_price_cats_sales">
                                        <option value="#get_price_cats_sales.price_catid#" <cfif get_price_cat_exceptions_2.price_catid eq get_price_cats_sales.price_catid>selected</cfif>>#get_price_cats_sales.price_cat#</option>
                                    </cfloop>
                                </select>
                            <cfelse>
                                <select name="price_cat_2#currentrow#" id="price_cat_2#currentrow#">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_price_cats_pur">
                                        <option value="#get_price_cats_pur.price_catid#" <cfif get_price_cat_exceptions_2.price_catid eq get_price_cats_pur.price_catid>selected</cfif>>#get_price_cats_pur.price_cat#
                                    </cfloop>
                                </select>
                            </cfif>
                        </div>
                    </td>
                    <td>
                        <input type="checkbox" name="is_default#currentrow#" id="is_default#currentrow#" value="1" <cfif get_price_cat_exceptions_2.is_default eq 1>checked ="checked"</cfif>>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <cf_box_footer>
        <cf_record_info query_name="get_price_cat_exceptions_2">
            <cfif get_module_user(17)>
            <cf_workcube_buttons type_format='1' add_function="control()" is_upd='1' is_delete="0">
            </cfif>
    </cf_box_footer>
</cfform>
<script type="text/javascript">
$(document).ready(function(){
	row_count_2=<cfoutput>#get_price_cat_exceptions_2.recordcount#</cfoutput>;
});
    function control(){
        unformat_fields();
    }
	function sil_2(sy)
	{
		var my_element=document.getElementById("row_kontrol_2"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row_2"+sy);
		my_element.style.display="none";
	}	
	function add_row_2()
	{  
		row_count_2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
		newRow.setAttribute("name","frm_row_2" + row_count_2);
		newRow.setAttribute("id","frm_row_2" + row_count_2);		
		newRow.setAttribute("NAME","frm_row_2" + row_count_2);
		newRow.setAttribute("ID","frm_row_2" + row_count_2);	
		document.getElementById('record_num_2').value 	=row_count_2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil_2(' + row_count_2 + ');"><i class="fa fa-minus" title="Sil"></i></a>';				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1" id="row_kontrol_2' + row_count_2 +'" name="row_kontrol_2' + row_count_2 +'"><select id="purchase_sales' + row_count_2 + '"  name="purchase_sales' + row_count_2 + '" onChange="kontrol_pricecat(' + row_count_2 + ');"><option value="1"><cf_get_lang dictionary_id="57448.Satış"></option><option value="0"><cf_get_lang dictionary_id="58176.Alış"></option></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="price_cat_2' + row_count_2 + '" name="price_cat_2' + row_count_2 + '"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_price_cats_sales"><option value="#PRICE_CATID#">#PRICE_CAT#</option></cfoutput></select></div>';
		newCell = newRow.style.textAlign="center";
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" id="is_default' + row_count_2 +'" name="is_default' + row_count_2 +'" value="1">';
	}
	function kontrol_pricecat(row_no)
	{
        price_cat_2_len = document.getElementById('price_cat_2'+row_no).options.length;
		for(j=price_cat_2_len;j>=0;j--)
			document.getElementById('price_cat_2'+row_no).options[j] = null;	
			
		if(document.getElementById('purchase_sales'+row_no).value == 1)
			var new_sql1 = "cnt_get_price_cat";
		else
			var new_sql1 = "cnt_get_price_cat_2";

		var get_price_cat = wrk_safe_query(new_sql1,'dsn3');
		document.getElementById('price_cat_2'+row_no).options[0]=new Option('<cf_get_lang dictionary_id="57734.Seçiniz">','');
		for(var jj=0;jj < get_price_cat.recordcount;jj++)
			document.getElementById('price_cat_2'+row_no).options[jj+1]=new Option(''+get_price_cat.PRICE_CAT[jj]+'',''+get_price_cat.PRICE_CATID[jj]+'');
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
