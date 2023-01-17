<cf_get_lang_set module_name="stock">
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
    <cf_papers paper_type="stock_fis">
    <cfif isdefined("paper_full") and isdefined("paper_number")>
        <cfset system_paper_no = paper_full>
        <cfset system_paper_no_add = paper_number>
    <cfelse>
        <cfset system_paper_no = "">
        <cfset system_paper_no_add = "">
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_STOCK_EXCHANGE" datasource="#DSN2#">
        SELECT
            STOCK_EXCHANGE.EXCHANGE_NUMBER,
            STOCK_EXCHANGE.STOCK_ID,
            STOCK_EXCHANGE.PRODUCT_ID,
            S.STOCK_CODE,
            S.PRODUCT_NAME,
            STOCK_EXCHANGE.PROCESS_CAT,
            STOCK_EXCHANGE.PROCESS_DATE,
            STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID OLD_SPECT_MAIN_ID,
            STOCK_EXCHANGE.SPECT_MAIN_ID,
            STOCK_EXCHANGE.RECORD_EMP,
            STOCK_EXCHANGE.RECORD_DATE,
            STOCK_EXCHANGE.UPDATE_EMP,
            STOCK_EXCHANGE.UPDATE_DATE,
            STOCK_EXCHANGE.AMOUNT,
            STOCK_EXCHANGE.DEPARTMENT_ID,
            STOCK_EXCHANGE.LOCATION_ID
        FROM
            STOCK_EXCHANGE,
            #dsn3_alias#.STOCKS S
        WHERE
            STOCK_EXCHANGE.STOCK_EXCHANGE_ID = #attributes.exchange_id# AND
            S.STOCK_ID = STOCK_EXCHANGE.STOCK_ID
    </cfquery>
    <cfif not GET_STOCK_EXCHANGE.recordcount>
		<cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    <cfelse>
        <cfquery name="GET_SPEC_NEW" datasource="#dsn3#">
            SELECT
                SMR.RELATED_MAIN_SPECT_ID,
                SM.SPECT_MAIN_NAME,
                SMR.AMOUNT,
                SMR.PRODUCT_NAME,
                IS_SEVK,
                S.STOCK_CODE,
                SMR.PRODUCT_ID,
                SMR.STOCK_ID
            FROM
                SPECT_MAIN SM,
                SPECT_MAIN_ROW SMR,
                #dsn1_alias#.STOCKS S
            WHERE 
                SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
                SM.SPECT_MAIN_ID = #GET_STOCK_EXCHANGE.SPECT_MAIN_ID# AND
                SMR.STOCK_ID = S.STOCK_ID
        </cfquery>
        <cfquery name="GET_SPEC_OLD" datasource="#dsn3#">
            SELECT
                SMR.RELATED_MAIN_SPECT_ID,
                SM.SPECT_MAIN_NAME,
                SMR.AMOUNT,
                SMR.PRODUCT_NAME,
                IS_SEVK,
                S.STOCK_CODE,
                SMR.PRODUCT_ID,
                SMR.STOCK_ID
            FROM
                SPECT_MAIN SM,
                SPECT_MAIN_ROW SMR,
                #dsn1_alias#.STOCKS S
            WHERE 
                SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
                SM.SPECT_MAIN_ID = #GET_STOCK_EXCHANGE.OLD_SPECT_MAIN_ID# AND
                SMR.STOCK_ID = S.STOCK_ID
        </cfquery>
    </cfif>
</cfif>

<script type="text/javascript">
$(document).ready(function(){
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
   row_count=0;
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
   row_count=<cfoutput>#GET_SPEC_NEW.RECORDCOUNT#</cfoutput>;
</cfif>
});
function control()
{
	if(document.specVirman.stock_id.value=="" || document.specVirman.product_name.value=="" )
	{
		alert("<cf_get_lang_main no='815.Ürün seçmeniz gerekmektedir'>");
		return false;
	}else if(document.specVirman.department_name.value=="" || document.specVirman.location_id.value=="")
	{
		alert("<cf_get_lang no ='195.Depo seçmeniz gerekmektedir'>.");
		return false;
	}else if(document.specVirman.main_spec_id.value=="" || document.specVirman.main_spec_name.value=="")
	{
		alert("<cf_get_lang no ='461.Spec seçmeniz gerekmektedir'>.");
		return false;
	}
	if(!chk_period(specVirman.process_date)) return false;
	if (!chk_process_cat('specVirman')) return false;
	if(!check_display_files('specVirman')) return false;
	document.specVirman.amount.value=filterNum(document.specVirman.amount.value);
	for(var row=0;row <= row_count;row++)
	{
		if(document.getElementById('sb_amount'+row)!=undefined)
			document.getElementById('sb_amount'+row).value=filterNum(document.getElementById('sb_amount'+row).value);
	}
	return true;
}
function product_control()/*Ürün seçmeden spect seçemesin.*/
{
	if(document.specVirman.stock_id.value=="" || document.specVirman.product_name.value=="" )
	{
		alert("<cf_get_lang no ='462.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
		return false;
	}else if(document.specVirman.department_name.value=="" || document.specVirman.location_id.value=="")
	{
		alert("<cf_get_lang no ='463.Spect Seçmek için öncelikle depo seçmeniz gerekmektedir'>");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=specVirman.main_spec_id&field_name=specVirman.main_spec_name&function_name=get_spec_row&is_display=1&is_stock=1&process_date='+document.specVirman.process_date.value+'&department_id='+document.specVirman.department_id.value+'&location_id='+document.specVirman.location_id.value+'&stock_id='+document.specVirman.stock_id.value,'list');
}

function open_product_detail(pro_id,s_id)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
}

function open_sb_add_row(sy)
{//sadece alternatifler gelmesi isin is_only_alternative v.s. parametreleri eklendi
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=specVirman.sb_stock_id'+sy+'&field_name=specVirman.sb_product_name'+sy+'&product_id=specVirman.sb_product_id'+sy+'&field_code=specVirman.sb_stock_code'+sy+'&is_form_submitted=1&is_only_alternative=1&alternative_product='+document.getElementById("sb_product_id"+sy).value,'list');
}

function table_clear()
{
	var oTable=document.getElementById("table_old_spec");
	while(oTable.rows.length>1)
		oTable.deleteRow(oTable.rows.length-1);
	var nTable=document.getElementById("table_new_spec");
	while(nTable.rows.length>1)
		nTable.deleteRow(nTable.rows.length-1);
}

function sil_sb_row(sy)
{
	document.getElementById('sb_row_kontrol'+sy).value = 0;
	document.getElementById('sb_row'+sy).style.display="none";
}


function add_row()
{
	if(document.specVirman.main_spec_id.value=="" || document.specVirman.main_spec_name.value=="")
	{
		alert("<cf_get_lang no ='461.Spec seçmeniz gerekmektedir'>");
		return false;
	}
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_new_spec").insertRow(document.getElementById("table_new_spec").rows.length);
	newRow.setAttribute("name","sb_row" + row_count);
	newRow.setAttribute("id","sb_row" + row_count);		
	newRow.setAttribute("NAME","sb_row" + row_count);
	newRow.setAttribute("ID","sb_row" + row_count);
	document.specVirman.sb_record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="sb_row_kontrol'+row_count+'"  id="sb_row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="sil_sb_row('+row_count+')"> <i class="icon-trash-o" title="<cf_get_lang no ='465.Ürün Sil'>"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="sb_stock_code'+row_count+'"  id="sb_stock_code'+row_count+'" value="" style="width:110px" readonly><input type="hidden"  name="sb_product_id'+row_count+'" id="sb_product_id'+row_count+'" value=""><input type="hidden" name="sb_stock_id'+row_count+'"  id="sb_stock_id'+row_count+'" value="">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="sb_product_name'+row_count+'"  id="sb_product_name'+row_count+'" value="" style="width:260px" readonly><a href="javascript://" onclick="open_sb_add_row('+row_count+')"> <i class="icon-ellipsis" align="absmiddle" title="<cf_get_lang_main no='1613.Ürün Ekle'>"></i></a><a href="javascript://" onclick="open_product_detail(specVirman.sb_product_id'+row_count+'.value,specVirman.sb_stock_id'+row_count+'.value)"> <i class="icon-ellipsis-p" align="absmiddle" title="<cf_get_lang no ='467.Ürün Detay'>"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" style="width:60px;text-align:right;" name="related_spect_main_id'+row_count+'" id="related_spect_main_id'+row_count+'" value="" readonly><a href="javascript://" onClick="open_spec_page('+row_count+');"> <i class="icon-ellipsis" align="absmiddle""></i></a>';	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("align", "right");
	newCell.innerHTML = '<input type="text"  name="sb_amount'+row_count+'" id="sb_amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" style="width:40px" align="right" onKeyUp="return FormatCurrency(this,event,3);">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="sb_is_sevk'+row_count+'" id="sb_is_sevk'+row_count+'" value="1" checked disabled="disabled">';	
}

function add_row_spec(type,table_id,rw,stock_id,prod_id,stock_code,prod_name,amount,is_sb,related_spect_main_id)
{
	var newRow;
	var newCell;
	newRow = document.getElementById(table_id).insertRow();
	if(type=='txt')
	{
		//eskisi uzerind duzenleme olmayacagından bu sekilde gelmesi yeterli
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = stock_code;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = prod_name;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = related_spect_main_id;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = commaSplit(amount,3);
		newCell.setAttribute("align", "right");
		newCell = newRow.insertCell(newRow.cells.length);
		if(is_sb==1) newCell.innerHTML = '*'; else newCell.innerHTML ='';
	}else
	{
		//formsa id vermekyeter text olarak eklenende gerek yok
		newRow.setAttribute("name","sb_row" + rw);
		newRow.setAttribute("id","sb_row" + rw);		
		newRow.setAttribute("NAME","sb_row" + rw);
		newRow.setAttribute("ID","sb_row" + rw);
		row_count=row_count+1;
		document.specVirman.sb_record_num.value=row_count;
		if(is_sb==0)
		{
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = stock_code;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = prod_name;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = related_spect_main_id;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("align", "right");
			newCell.innerHTML = commaSplit(amount,3);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}
		else
		{			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="sb_row_kontrol'+row_count+'"  id="sb_row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="sil_sb_row('+row_count+')"> <i class="icon-trash-o" title="<cf_get_lang no ='465.Ürün Sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="sb_stock_code'+row_count+'" id="sb_stock_code'+row_count+'" value="'+stock_code+'" style="width:120px" readonly><input type="hidden" name="sb_product_id'+row_count+'"  id="sb_product_id'+row_count+'" value="'+prod_id+'"><input type="hidden" name="sb_stock_id'+row_count+'"  id="sb_stock_id'+row_count+'" value="'+stock_id+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="sb_product_name'+row_count+'" id="sb_product_name'+row_count+'" value="'+prod_name+'" style="width:300px" readonly><a href="javascript://" onclick="open_sb_add_row('+row_count+')"> <i class="icon-ellipsis" align="absmiddle" title="<cf_get_lang_main no='1613.Ürün Ekle'>"></i></a><a href="javascript://" onclick="open_product_detail(specVirman.sb_product_id'+row_count+'.value,specVirman.sb_stock_id'+row_count+'.value)"> <i class="icon-ellipsis-p" title="<cf_get_lang no ='467.Ürün Detay'>" align="absmiddle"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" style="width:80px;text-align:right;" name="related_spect_main_id'+row_count+'" id="related_spect_main_id'+row_count+'" value="'+related_spect_main_id+'" readonly><a href="javascript://" onClick="open_spec_page('+row_count+');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("align", "right");
			newCell.innerHTML = '<input type="text" name="sb_amount'+row_count+'" value="'+commaSplit(amount,3)+'" class="moneybox" style="width:50px" align="right" onKeyUp="return FormatCurrency(this,event,3);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="sb_is_sevk'+row_count+'" id="sb_is_sevk'+row_count+'" value="1" checked="checked" disabled="disabled">';	
		}	
	}
}
function open_spec_page(row_count){
	var _stock_id_ = document.getElementById('sb_stock_id'+row_count).value;
	if(_stock_id_ != undefined && _stock_id_ != "")
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=specVirman.related_spect_main_id'+row_count+'&is_display=1&is_stock=1&stock_id='+_stock_id_,'list');
}
function open_location_popup()
{
	if(document.specVirman.main_spec_id.value!="" || document.specVirman.main_spec_name.value!="")
	{
		if(confirm("<cf_get_lang no ='464.Spec Seçmişsiniz Depo Değiştirseniz Spec Boşaltılacaktır'>!"))
		{
			document.specVirman.main_spec_id.value="";
			document.specVirman.main_spec_name.value="";
			table_clear();
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=specVirman&field_name=department_name&field_location_id=location_id&field_id=department_id&field_location=location_name</cfoutput>','medium');
		}
	}
	else
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=specVirman&field_name=department_name&field_location_id=location_id&field_id=department_id&field_location=location_name</cfoutput>','medium');
	}
	return true;
}

function get_spec_row()
{
	//yeni bastan eklendigi iscin row_count sıfırlanıyor ve satırlar siliniyor
	row_count=0;
	table_clear();
	var get_row = wrk_safe_query('stk_get_row_spec','dsn3',0,document.specVirman.main_spec_id.value);
	for(var rw=0;rw<get_row.recordcount;rw++)
	{
		var str_rw = rw+1;
		add_row_spec('txt','table_old_spec',str_rw,get_row.STOCK_ID[rw],get_row.PRODUCT_ID[rw],get_row.STOCK_CODE[rw],get_row.PRODUCT_NAME[rw],get_row.AMOUNT[rw],get_row.IS_SEVK[rw],get_row.RELATED_MAIN_SPECT_ID[rw]);
		add_row_spec('form','table_new_spec',str_rw,get_row.STOCK_ID[rw],get_row.PRODUCT_ID[rw],get_row.STOCK_CODE[rw],get_row.PRODUCT_NAME[rw],get_row.AMOUNT[rw],get_row.IS_SEVK[rw],get_row.RELATED_MAIN_SPECT_ID[rw]);
	}
}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_spec_exchange';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/form_add_spec_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_spec_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_spec_exchange&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['default'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('spec_exchange','spec_exchange_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_upd_spec_exchange';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/form_upd_spec_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_spec_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_spec_exchange&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'exchange_id=##attributes.exchange_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.exchange_id##';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('spec_exchange','spec_exchange_bask')";
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_spec_exchange&exchange_id=#attributes.exchange_id#&process_type=#GET_STOCK_EXCHANGE.PROCESS_CAT#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/del_spec_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/del_spec_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.welcome';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockSpecExchange';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_EXCHANGE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-exchange_no_','item-process_cat','item-department_name','item-product_name','item-process_date']";
</cfscript>
