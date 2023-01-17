<!--- attributes.in_or_out 1 olarak yolanırsa giriş işlemi 0 olarak gelirse çıkış işlemi yapar --->
<cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
	SELECT SHIP_TYPE,SHIP_DATE,DELIVER_STORE_ID,LOCATION,DEPARTMENT_IN,LOCATION_IN FROM SHIP WHERE SHIP_ID = #attributes.upd_id#
</cfquery>
<cfquery name="GET_STOCK" datasource="#DSN2#">
	SELECT 
		STOCKS_ROW.*,
		S.PRODUCT_NAME,
		S.PROPERTY,
		S.STOCK_CODE
	FROM 
		STOCKS_ROW,
		#dsn3_alias#.STOCKS S
	WHERE 
		STOCKS_ROW.PROCESS_TYPE = #attributes.process_cat_id# AND 
		STOCKS_ROW.UPD_ID = #attributes.upd_id# AND 
		S.STOCK_ID = STOCKS_ROW.STOCK_ID
</cfquery>
<cfif not isdefined("attributes.in_or_out")>
	<cfif GET_STOCK.STOCK_IN gt 0>
		<cfset attributes.in_or_out=0>
	<cfelse>
		<cfset attributes.in_or_out=1>
	</cfif>
</cfif>
<cfquery name="get_inv" datasource="#dsn2#">
	SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM INVOICE_SHIPS WHERE SHIP_ID = #attributes.upd_id# AND SHIP_PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="GET_STOCKS_UPD" datasource="#DSN2#">
	SELECT
		SR.STOCKS_UPD_ID,
		SR.UPDATE_EMP,
		SR.UPDATE_DATE,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		STOCKS_ROW_UPD SR,
		#dsn_alias#.EMPLOYEES E
	WHERE
		SR.ACTION_ID = #attributes.upd_id# AND 
		SR.PROCESS_TYPE = #attributes.process_cat_id# AND 
		E.EMPLOYEE_ID = SR.UPDATE_EMP
	ORDER BY
		STOCKS_UPD_ID DESC
</cfquery>
<cfquery name="GET_SERI" datasource="#dsn3#">
	SELECT
		STOCK_ID
	FROM 
		SERVICE_GUARANTY_NEW 
	WHERE 
		PROCESS_ID = #attributes.upd_id# AND 
		PROCESS_CAT = #attributes.process_cat_id# AND
		PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='34205.İrsaliye Stok Hareketleri'></cfsavecontent>
<cf_box title="#message#">
    <cfform name="form_upd_row" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_ship_stock_rows">
        <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#GET_STOCK.RECORDCOUNT#</cfoutput>">
        <input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.upd_id#</cfoutput>">
        <input type="hidden" name="process_cat_id" id="process_cat_id" value="<cfoutput>#attributes.process_cat_id#</cfoutput>">
        <input type="hidden" name="dep" id="dep" value="<cfif attributes.in_or_out eq 1><cfoutput>#GET_UPD_PURCHASE.DEPARTMENT_IN#</cfoutput><cfelse><cfoutput>#GET_UPD_PURCHASE.DELIVER_STORE_ID#</cfoutput></cfif>">
        <input type="hidden" name="location" id="location" value="<cfif attributes.in_or_out eq 1><cfoutput>#GET_UPD_PURCHASE.LOCATION_IN#</cfoutput><cfelse><cfoutput>#GET_UPD_PURCHASE.LOCATION#</cfoutput></cfif>">
        <input type="hidden" name="process_date" id="process_date" value="<cfoutput>#GET_UPD_PURCHASE.SHIP_DATE#</cfoutput>">
        <cf_grid_list>
        	<thead>
              <tr>
                 <th width="15"><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                 <th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                 <th width="270"><cf_get_lang dictionary_id ='57657.Ürün'></th>
                 <th width="100"><cf_get_lang dictionary_id ='57635.Miktar'></th>
              </tr>
           </thead>
           <tbody name="table1" id="table1">
			 <cfoutput query="GET_STOCK">
              <tr name="frm_row#currentrow#" id="frm_row#currentrow#">
                <td>
                    <input type="hidden" name="stock_row_id#currentrow#" id="stock_row_id#currentrow#" value="#STOCKS_ROW_ID#">
                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <a style="cursor:pointer" onclick="sil(#currentrow#);"> <img  src="images/delete_list.gif" border="0"></a>
                </td>
                <td><input type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#STOCK_CODE#"></td>
                <td>
                    <input type="hidden" name="old_stock_id#currentrow#" id="old_stock_id#currentrow#" value="#STOCK_ID#">
                    <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
                    <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#PRODUCT_NAME# #PROPERTY#" style="width:250px" readonly>
                    <a href="javascript://" onClick="pencere_ac('#currentrow#');"> <img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>
                </td>
                <td>
                <cfsavecontent variable="number_massage"><cf_get_lang dictionary_id ='33933.Sayı Giriniz'></cfsavecontent>
                <cfif attributes.in_or_out eq 1>
                    <input type="hidden" name="in_or_out#currentrow#" id="in_or_out#currentrow#" value="1">
                    <cfinput type="text" name="amount#currentrow#" value="#TLFormat(STOCK_IN,4)#" validate="float" onkeyup="return(FormatCurrency(this,event,3));" onBlur="is_Change(#currentrow#);" message="#number_massage#" style="width:100px;">
                <cfelse>
                    <input type="hidden" name="in_or_out#currentrow#" id="in_or_out#currentrow#" value="0">
                    <cfinput type="text" name="amount#currentrow#" value="#TLFormat(STOCK_OUT,4)#" validate="float" onkeyup="return(FormatCurrency(this,event,3));" onBlur="is_Change(#currentrow#);" message="#number_massage#" style="width:100px;">
                </cfif>
                </td>
              </tr> 	
              </cfoutput>
           </tbody>
        </cf_grid_list>
        <cf_box_footer>
            <cfif isdefined("get_stocks_upd") and get_stocks_upd.recordcount>
                 <cf_get_lang dictionary_id ='57703.Güncelleme'> :<cfoutput>#get_stocks_upd.employee_name# #get_stocks_upd.employee_surname# #dateformat(date_add('h',session.ep.time_zone,GET_STOCKS_UPD.UPDATE_DATE),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_STOCKS_UPD.UPDATE_DATE),timeformat_style)#)<!--- (#dateformat(GET_STOCKS_UPD.UPDATE_DATE,dateformat_style)# #dateformat(GET_STOCKS_UPD.UPDATE_DATE,timeformat_style)#) ---></cfoutput>
            </cfif>
            <!--- <cfif not get_inv.recordcount><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cfif> --->
           <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	var row_count=<cfoutput>#GET_STOCK.RECORDCOUNT#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("form_upd_row.row_kontrol"+sy);
		my_element.value=0;
	
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
					
		document.form_upd_row.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="2"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  > <img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="stock_code'+row_count+'" value="">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id'+row_count+'" value=""><input type="hidden" name="stock_id'+row_count+'" value=""><input type="text" name="product_name'+row_count+'" value="" style="width:250px" readonly><a href="javascript://" onClick="pencere_ac(' + row_count + ');"> <img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="in_or_out'+row_count+'" value="<cfif attributes.in_or_out eq 1>1<cfelse>0</cfif>"><input type="text" name="amount'+row_count+'" value="0" onKeyUp="return(FormatCurrency(this,event,3));" style="width:100px;">';
	}
	
	function pencere_ac(no)
	{
		var my_element=eval("form_upd_row.row_kontrol"+no);
		my_element.value=2;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form_upd_row.product_id'+no+'&field_name=form_upd_row.product_name'+no+'&field_id=form_upd_row.stock_id'+no+'&field_code=form_upd_row.stock_code'+no,'list');
	}
	
	function is_Change(st){
		var my_element=eval("form_upd_row.row_kontrol"+st);
		my_element.value=2;
	}
	
	function kontrol()
	{
	var change=0;
 	<cfif GET_SERI.RECORDCOUNT>
		for(var j=1;j<=row_count;j++)
		{		
			change=1;
			break;
		}
		if(change==1)
			if(!confirm("<cf_get_lang dictionary_id ='34206.Seri no kaydı yapılmış, devam ederseniz silinecektir'>!"))
				return false;
	</cfif> 
		for(var j=1;j<=row_count;j++)
		{		
			if(eval("document.form_upd_row.row_kontrol"+j).value>0 && !(filterNum(eval('document.form_upd_row.amount'+j).value)>0))
			{
				alert("<cf_get_lang dictionary_id ='34207.Miktarı Doğru Giriniz'>!");
				return false;
			}
		}
		for(var j=1;j<=row_count;j++)
			eval('document.form_upd_row.amount'+j).value=filterNum(eval('document.form_upd_row.amount'+j).value);
		return true;
	}
</script>
