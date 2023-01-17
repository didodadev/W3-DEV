<!---


<<<<<<< HEAD
﻿<cf_get_lang_set module ="product">
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
<cfelseif attributes.event is 'upd'>
 	<cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfquery name="get_company_stock_code" datasource="#dsn1#">
        SELECT
            *
        FROM
            SETUP_COMPANY_STOCK_CODE
        WHERE
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
    </cfquery>
    <cfset toplam = get_company_stock_code.RecordCount>    
    <cfset company_code_list = "">
	<cfoutput query="get_company_stock_code">
        <cfif len(stock_id) and not listfind(company_code_list,stock_id)>
            <cfset company_code_list=listappend(company_code_list,stock_id)>
        </cfif>
    </cfoutput>
    <cfif len(company_code_list)>
        <cfquery name="get_product_name" datasource="#dsn3#">
            SELECT STOCK_ID,STOCK_CODE,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#company_code_list#) ORDER BY STOCK_ID
        </cfquery>
        <cfset company_code_list = listsort(listdeleteduplicates(valuelist(get_product_name.stock_id,',')),'numeric','ASC',',')>
    </cfif>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
   <script type="text/javascript">
   		row_count=0;
        function sil(sy)
        {
            var my_element=eval("form_basket.row_kontrol"+sy);
            my_element.value=0;
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
        }
        function kontrol_et()
        {
            if(row_count ==0)
                return false;
            else
                return true;
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
            document.form_basket.record_num.value=row_count;
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';				
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'"  value="1"><input type="hidden" name="stock_id' + row_count +'"><input type="text" name="stock_code' + row_count + '" style="width:150px;" readonly>';			
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_name' + row_count + '" style="width:150px;" readonly>&nbsp;<a href="javascript://" onClick="pencere_pos(' + row_count + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_stock_code' + row_count + '" style="width:150px;" maxlength="150">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_name' + row_count + '" style="width:450px;" maxlength="600">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '" style="width:250px;" maxlength="250">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_priority' + row_count + '" id="company_product_priority' + row_count + '" style="width:150px;text-align:right;" onkeyup="isNumber(this);">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count + '" id="is_active' + row_count + '">';
        }
        function pencere_pos(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id' + no + '&field_code=form_basket.stock_code' + no + '&field_name=form_basket.product_name' + no,'list');
        }
        
        function satir_kontrol()
        {
            if(document.form_basket.record_num.value > 0)
            {
                for(r=1;r<=form_basket.record_num.value;r++)
                {
                    if(eval("document.form_basket.row_kontrol"+r).value == 1)
                    {
                        if(eval("document.form_basket.stock_id"+r).value == "" || eval("document.form_basket.product_name"+r).value == "")
                        {
                            alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
                            return false;
                        }
                        if(eval("document.form_basket.company_stock_code"+r).value == "")
                        {
                            alert("<cf_get_lang no='282.Üye Stok Kodu Girmelisiniz'>!");
                            return false;
                        }
                        deger = 1;
                        for(deger=1;deger<=r;deger++)
                        {
                            if(deger != r)
                            {
                                if(eval("document.form_basket.stock_code"+r).value == eval("document.form_basket.stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='473.Aynı Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.stock_code"+r).value);
                                    return false;
                                }
                                if(eval("document.form_basket.company_stock_code"+r).value == eval("document.form_basket.company_stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='475.Aynı Üye Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='246.Üye'><cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.company_stock_code"+r).value);
                                    return false;
                                }
                            }
                        }
                }	}
            }
			return true;
        }
		function search_kontrol()
		{
				if((document.form_get_company.company_id.value=="") || document.form_get_company.member_name.value=="")
				{
					alert("<cf_get_lang no='398.Müşteri Seçmelisiniz'> !");
					return false;
				}
			
			else
				return true;
		}
	</script>
<cfelseif attributes.event is 'upd'>
	<script type="text/javascript">
	$( document ).ready(function() {
   		row_count=<cfoutput>#toplam#</cfoutput>;
	});	
	
        function sil(sy)
        {
            var my_element=eval("form_basket.row_kontrol"+sy);
            my_element.value=0;
        
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
        }
        function kontrol_et()
        {
            if(row_count ==0)
                return false;
            else
                return true;
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
                        
            document.form_basket.record_num.value=row_count;
        
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';				
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'"  value="1"><input type="hidden" name="stock_id' + row_count +'"><input type="text" name="stock_code' + row_count + '" style="width:150px;" readonly>';			
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_name' + row_count + '" style="width:150px;" readonly>&nbsp;<a href="javascript://" onClick="pencere_pos(' + row_count + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_stock_code' + row_count + '" style="width:150px;">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_name' + row_count + '" style="width:300px;">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '" style="width:300px;">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_priority' + row_count + '" id="company_product_priority' + row_count + '" style="width:50px;text-align:right;" onkeyup="isNumber(this);">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count + '" id="is_active' + row_count + '">';
            
        }
        function pencere_pos(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id' + no + '&field_code=form_basket.stock_code' + no + '&field_name=form_basket.product_name' + no,'list');
        }
        function search_kontrol()
        {
            if((document.form_get_company.company_id.value == "") || document.form_get_company.member_name.value == "")
            {
                alert("<cf_get_lang no='398.Müşteri Seçmelisiniz'> !");
                return false;
            }
            else
                return true;
        }
        function satir_kontrol()
        {
            if(document.form_basket.record_num.value > 0)
            {
                for(r=1;r<=form_basket.record_num.value;r++)
                {
                    if(eval("document.form_basket.row_kontrol"+r).value == 1)
                    {
                        if(eval("document.form_basket.stock_id"+r).value == "" || eval("document.form_basket.product_name"+r).value == "")
                        {
                            alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
                            return false;
                        }
                        if(eval("document.form_basket.company_stock_code"+r).value == "")
                        {
                            alert("<cf_get_lang no='282.Üye Stok Kodu Girmelisiniz'>!");
                            return false;
                        }				
                        deger = 1;
                        for(deger=1;deger<=r;deger++)
                        {
                            if(deger != r)
                            {
                                if(eval("document.form_basket.stock_code"+r).value == eval("document.form_basket.stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='473.Aynı Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.stock_code"+r).value);
                                    return false;
                                }
                                if(eval("document.form_basket.company_stock_code"+r).value == eval("document.form_basket.company_stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='475.Aynı Üye Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='246.Üye'><cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.company_stock_code"+r).value);
                                    return false;
                                }
                            }
                        }
                        
                    }
                }
            }	
			return true;
        }
    </script>

</cfif>  

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['add']['querypath'] = 'product/query/get_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/get_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
	
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode'] = structNew();
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['filePath'] = 'product/form/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['queryPath'] = 'product/query/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode'] = structNew();
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['filePath'] = 'product/form/upd_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['queryPath'] = 'product/query/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['Identity'] = '';

	
=======
﻿<cf_get_lang_set module_name="product">

<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
<cfelseif attributes.event is 'upd'>
 	<cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_name" default="">
    <cfquery name="get_company_stock_code" datasource="#dsn1#">
        SELECT
            *
        FROM
            SETUP_COMPANY_STOCK_CODE
        WHERE
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
    </cfquery>
    <cfset toplam = get_company_stock_code.RecordCount>    
    <cfset company_code_list = "">
	<cfoutput query="get_company_stock_code">
        <cfif len(stock_id) and not listfind(company_code_list,stock_id)>
            <cfset company_code_list=listappend(company_code_list,stock_id)>
        </cfif>
    </cfoutput>
    <cfif len(company_code_list)>
        <cfquery name="get_product_name" datasource="#dsn3#">
            SELECT STOCK_ID,STOCK_CODE,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#company_code_list#) ORDER BY STOCK_ID
        </cfquery>
        <cfset company_code_list = listsort(listdeleteduplicates(valuelist(get_product_name.stock_id,',')),'numeric','ASC',',')>
    </cfif>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
   <script type="text/javascript">
   		row_count=0;
        function sil(sy)
        {
            var my_element=eval("form_basket.row_kontrol"+sy);
            my_element.value=0;
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
        }
        function kontrol_et()
        {
            if(row_count ==0)
                return false;
            else
                return true;
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
            document.form_basket.record_num.value=row_count;
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';				
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'"  value="1"><input type="hidden" name="stock_id' + row_count +'"><input type="text" name="stock_code' + row_count + '" style="width:150px;" readonly>';			
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_name' + row_count + '" style="width:150px;" readonly>&nbsp;<a href="javascript://" onClick="pencere_pos(' + row_count + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_stock_code' + row_count + '" style="width:150px;" maxlength="150">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_name' + row_count + '" style="width:450px;" maxlength="600">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '" style="width:250px;" maxlength="250">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_priority' + row_count + '" id="company_product_priority' + row_count + '" style="width:150px;text-align:right;" onkeyup="isNumber(this);">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count + '" id="is_active' + row_count + '">';
        }
        function pencere_pos(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id' + no + '&field_code=form_basket.stock_code' + no + '&field_name=form_basket.product_name' + no,'list');
        }
        
        function satir_kontrol()
        {
            if(document.form_basket.record_num.value > 0)
            {
                for(r=1;r<=form_basket.record_num.value;r++)
                {
                    if(eval("document.form_basket.row_kontrol"+r).value == 1)
                    {
                        if(eval("document.form_basket.stock_id"+r).value == "" || eval("document.form_basket.product_name"+r).value == "")
                        {
                            alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
                            return false;
                        }
                        if(eval("document.form_basket.company_stock_code"+r).value == "")
                        {
                            alert("<cf_get_lang no='282.Üye Stok Kodu Girmelisiniz'>!");
                            return false;
                        }
                        deger = 1;
                        for(deger=1;deger<=r;deger++)
                        {
                            if(deger != r)
                            {
                                if(eval("document.form_basket.stock_code"+r).value == eval("document.form_basket.stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='473.Aynı Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.stock_code"+r).value);
                                    return false;
                                }
                                if(eval("document.form_basket.company_stock_code"+r).value == eval("document.form_basket.company_stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='475.Aynı Üye Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='246.Üye'><cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.company_stock_code"+r).value);
                                    return false;
                                }
                            }
                        }
                }	}
            }
			return true;
        }
		function search_kontrol()
		{
				if((document.form_get_company.company_id.value=="") || document.form_get_company.member_name.value=="")
				{
					alert("<cf_get_lang no='398.Müşteri Seçmelisiniz'> !");
					return false;
				}
			
			else
				return true;
		}
	</script>
<cfelseif attributes.event is 'upd'>
	<script type="text/javascript">
	$( document ).ready(function() {
   		row_count=<cfoutput>#toplam#</cfoutput>;
	});	
	
        function sil(sy)
        {
            var my_element=eval("form_basket.row_kontrol"+sy);
            my_element.value=0;
        
            var my_element=eval("frm_row"+sy);
            my_element.style.display="none";
        }
        function kontrol_et()
        {
            if(row_count ==0)
                return false;
            else
                return true;
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
                        
            document.form_basket.record_num.value=row_count;
        
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';				
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'"  value="1"><input type="hidden" name="stock_id' + row_count +'"><input type="text" name="stock_code' + row_count + '" style="width:150px;" readonly>';			
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="product_name' + row_count + '" style="width:150px;" readonly>&nbsp;<a href="javascript://" onClick="pencere_pos(' + row_count + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_stock_code' + row_count + '" style="width:150px;">';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_name' + row_count + '" style="width:300px;">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '" style="width:300px;">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="company_product_priority' + row_count + '" id="company_product_priority' + row_count + '" style="width:50px;text-align:right;" onkeyup="isNumber(this);">';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count + '" id="is_active' + row_count + '">';
            
        }
        function pencere_pos(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id' + no + '&field_code=form_basket.stock_code' + no + '&field_name=form_basket.product_name' + no,'list');
        }
        function search_kontrol()
        {
            if((document.form_get_company.company_id.value == "") || document.form_get_company.member_name.value == "")
            {
                alert("<cf_get_lang no='398.Müşteri Seçmelisiniz'> !");
                return false;
            }
            else
                return true;
        }
        function satir_kontrol()
        {
            if(document.form_basket.record_num.value > 0)
            {
                for(r=1;r<=form_basket.record_num.value;r++)
                {
                    if(eval("document.form_basket.row_kontrol"+r).value == 1)
                    {
                        if(eval("document.form_basket.stock_id"+r).value == "" || eval("document.form_basket.product_name"+r).value == "")
                        {
                            alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
                            return false;
                        }
                        if(eval("document.form_basket.company_stock_code"+r).value == "")
                        {
                            alert("<cf_get_lang no='282.Üye Stok Kodu Girmelisiniz'>!");
                            return false;
                        }				
                        deger = 1;
                        for(deger=1;deger<=r;deger++)
                        {
                            if(deger != r)
                            {
                                if(eval("document.form_basket.stock_code"+r).value == eval("document.form_basket.stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='473.Aynı Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.stock_code"+r).value);
                                    return false;
                                }
                                if(eval("document.form_basket.company_stock_code"+r).value == eval("document.form_basket.company_stock_code"+deger).value)
                                {
                                    alert("<cf_get_lang no='475.Aynı Üye Stok Kodunu Birden Fazla Giremezsiniz'>! \n<cf_get_lang_main no='246.Üye'><cf_get_lang_main no='106.Stok Kodu'> : "+eval("document.form_basket.company_stock_code"+r).value);
                                    return false;
                                }
                            }
                        }
                        
                    }
                }
            }	
			return true;
        }
    </script>

</cfif>  

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['add']['querypath'] = 'product/query/get_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	WStruct['#attributes.fuseaction#']['add']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['add']['Identity'] = '';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/get_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
	
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode'] = structNew();
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['filePath'] = 'product/form/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['queryPath'] = 'product/query/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['addCompanyStockCode']['Identity'] = '';
	
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode'] = structNew();
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['fuseaction'] = 'product.add_company_stock_code';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['filePath'] = 'product/form/upd_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['queryPath'] = 'product/query/add_company_stock_code.cfm';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['nextEvent'] = 'product.add_company_stock_code&event=upd';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['updCompanyStockCode']['Identity'] = '';

	
>>>>>>> qa_feature/96600
</cfscript>


--->
