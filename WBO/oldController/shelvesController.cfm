<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_get_lang_set module_name="stock">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.shelve_pro_cat" default="">
    <cfparam name="attributes.place_status" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfinclude template="../product/query/get_stores.cfm">
    <cfinclude template="../product/query/get_shelves.cfm">
     <cfif session.ep.isBranchAuthorization >
        <cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
    </cfif>
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
        SELECT 
            PRODUCT_CATID, 
            HIERARCHY, 
            PRODUCT_CAT 
        FROM 
            PRODUCT_CAT
        WHERE 
            PRODUCT_CATID IS NOT NULL
            <cfif isDefined("attributes.id")>
                AND	PRODUCT_CATID = #attributes.id#
            </cfif>
             <cfif session.ep.isBranchAuthorization >
                AND	PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #dsn1_alias#.PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#)
            </cfif>
        ORDER BY
            HIERARCHY
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../stock/query/get_product_place.cfm">
    <cfelse>
        <cfset get_product_place.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_product_place.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset prod_place_stock_id_list=''>
    <cfif get_product_place.recordcount>
			<cfoutput query="get_product_place" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(product_id) and len(place_stock_id) and not listfind(prod_place_stock_id_list,place_stock_id)>
					<cfset prod_place_stock_id_list=listappend(prod_place_stock_id_list,place_stock_id)>
				</cfif>
			</cfoutput>
			<cfif len(prod_place_stock_id_list)>
				<cfquery name="get_stock_names" datasource="#dsn3#">
					SELECT BARCOD,PRODUCT_NAME,PROPERTY,STOCK_ID,PRODUCT_ID FROM STOCKS WHERE STOCK_ID IN (#prod_place_stock_id_list#) ORDER BY STOCK_ID
				</cfquery>
				<cfset prod_place_stock_id_list=valuelist(get_stock_names.STOCK_ID)>
			</cfif>
    </cfif>   
<cfelseif attributes.event is 'add'>
    <cf_get_lang_set module_name="stock">
    <cfinclude template="../product/query/get_shelves.cfm">
    <cfif isdefined("pid") and len(pid)>
        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
            SELECT PRODUCT_ID, STOCK_ID, PRODUCT_NAME + ' ' + ISNULL(PROPERTY,'') AS PRODUCT_NAME FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        </cfquery>
    </cfif>
<cfelseif attributes.event is 'upd'>
    <cf_get_lang_set module_name="stock">
    <cfif isnumeric(attributes.product_place_id)>
        <cfinclude template="../product/query/get_product_place.cfm">
        <cfinclude template="../product/query/get_shelves.cfm">
    <cfelse>
        <cfset get_product_place.recordcount = 0> 
    </cfif>
    <cfif not get_product_place.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
    <cfelse>
    <cfquery name="get_our_comps" datasource="#dsn#">
        SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
    </cfquery>
    <cfquery name="GET_CONTROL" datasource="#DSN2#">  
     <cfloop query="get_our_comps">
            <cfset new_dsn2 = '#dsn#_#get_our_comps.period_year#_#get_our_comps.our_company_id#'>
                SELECT
                    SHELF_NUMBER
                FROM
                    #new_dsn2#.STOCKS_ROW
                WHERE 
                    SHELF_NUMBER = #attributes.product_place_id#
            <cfif get_our_comps.recordcount neq currentrow>
                UNION
            </cfif>	
        </cfloop> 
    </cfquery>
    </cfif>    
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">   
        function connectAjax(crtrow,shelf_id)
        {		
            var load_url_ = '<cfoutput>#request.self#?fuseaction=stock.emptypopup_ajax_list_shelf_products</cfoutput>&frm_shlf_list=1&shelf_id='+shelf_id+'&crtrow='+crtrow;
            AjaxPageLoad(load_url_,'DISPLAY'+crtrow,1);
        }        
    </script>
<cfelseif attributes.event is 'add'>
	<script type="text/javascript">
	$(document).ready(function(){
		row_count=document.add_product_plc.record_num.value;
	});
		function kontrol_et()
		{		
			if(!date_check(document.add_product_plc.START_DATE, document.add_product_plc.FINISH_DATE, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!")) return false;
			if(trim(document.add_product_plc.shelf_code.value) == '')
			{
				alert("<cf_get_lang no='528.Raf Kodu Girmelisiniz' module_name='product'>! ");
				return false;
			}
			
			if(document.add_product_plc.shelf_type.value == '')
			{
				alert("<cf_get_lang no ='711.Lütfen Raf Tipi Seçiniz'>!");
				return false;
			}
			return true;
		}
		
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.add_product_plc.record_num.value = row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
			
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="text" name="urun' + row_count +'" id="urun'+ row_count +'" style="width:300px;"><input type="hidden" name="pid' + row_count +'" id="pid'+ row_count +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"> <a style="cursor:pointer" href"javascript://" onClick="pencere_ac('+ row_count +');"><img src="/images/plus_thin.gif" title="Ekle" border="0" align="absmiddle"></a>';
			
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="text" name="quantity' + row_count +'"  onkeyup="isNumber(this);" style="width:85px; text-align:right;">';
		}
		function pencere_ac(no)
		{
			windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_product_plc.pid" + no +"&field_id=add_product_plc.stock_id" + no +"&field_name=add_product_plc.urun" + no,'list');
		}
		function sil(sy)
		{
			var element=eval("add_product_plc.row_kontrol"+sy);
			element.value=0;
			var element=eval("frm_row"+sy); 
			element.style.display="none";	
		} 
	</script>
<cfelseif attributes.event is 'upd'>
  <script type="text/javascript">
	  $(document).ready(function(){
			row_count=document.add_product_plc.record_num.value;
		});		
		function kontrol_et() 
		{
			 if(document.add_product_plc.shelf_type.value == '' )
			 {
				 alert("<cf_get_lang no ='711.Lütfen Raf Tipi Seçiniz'>!"); 
				 return false; 
			 }
			 
			 if(!date_check(document.add_product_plc.START_DATE, document.add_product_plc.FINISH_DATE, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!")) return false;
			
			document.add_product_plc.place_status.disabled = false;
			return true;
		}
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.add_product_plc.record_num.value = row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
				
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="text" name="urun' + row_count +'" id="urun'+ row_count +'" style="width:300px;"><input type="hidden" name="pid' + row_count +'" id="pid'+ row_count +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"> <a style="cursor:pointer" href"javascript://" onClick="pencere_ac('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="stock_code' + row_count +'" id="stock_code'+ row_count +'" readonly>';
			
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="special_code' + row_count +'" id="special_code'+ row_count +'" readonly>';
			
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" style="width:85px; text-align:right;"  onkeyup="isNumber(this);">';
		}
		function pencere_ac(no)
		{
			windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_product_plc.pid" + no +"&field_id=add_product_plc.stock_id" + no +"&field_name=add_product_plc.urun" + no+"&field_special_code=add_product_plc.special_code" + no +"&field_code=add_product_plc.stock_code" + no,'list');
		}
		function sil(sy)
		{
		
			var element=eval("add_product_plc.row_kontrol"+sy);
			element.value=0;
			var element=eval("frm_row"+sy); 
			element.style.display="none";		
		} 
		</script>  
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_shelves';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_shelves.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;		
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_form_add_product_place';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_product_place.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_product_place.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_shelves';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.popup_form_upd_product_place';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_product_place.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_product_place.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_shelves';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'product_place_id=##attributes.product_place_id##&department_in=##attributes.department_in##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.product_place_id##';
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_shelves&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'shelvesController';		
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCT_PLACE';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-txt_department_in','item-shelf_code','item-shelf_type']";
	
</cfscript>