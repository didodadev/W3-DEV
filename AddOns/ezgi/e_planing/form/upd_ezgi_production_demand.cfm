<cfquery name="get_deamand" datasource="#dsn3#">
	SELECT * FROM EZGI_PRODUCTION_DEMAND WHERE EZGI_DEMAND_ID = #attributes.upd_id#
</cfquery>
<cfquery name="get_deamand_row" datasource="#dsn3#">
	SELECT  
    	EDPR.EZGI_DEMAND_ROW_ID,      
    	EDPR.STOCK_ID, 
        EDPR.QUANTITY, 
        EDPR.EZGI_ID, 
        EDPR.PRODUCT_TYPE, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        PU.MAIN_UNIT, 
        ISNULL(SUM(EPO.QUANTITY), 0) AS PROD_QUANTITY
	FROM           
    	EZGI_PRODUCTION_DEMAND_ROW AS EDPR INNER JOIN
      	STOCKS AS S ON EDPR.STOCK_ID = S.STOCK_ID INNER JOIN
      	PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID LEFT OUTER JOIN
     	EZGI_IFLOW_PRODUCTION_ORDERS AS EPO ON EDPR.EZGI_DEMAND_ROW_ID = EPO.ACTION_ID
	WHERE        
    	EDPR.EZGI_DEMAND_ID = #attributes.upd_id#
	GROUP BY 
    	EDPR.EZGI_DEMAND_ROW_ID,
    	EDPR.STOCK_ID, 
        EDPR.QUANTITY, 
        EDPR.EZGI_ID, 
        EDPR.PRODUCT_TYPE, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        PU.MAIN_UNIT 
   ORDER BY EDPR.EZGI_DEMAND_ROW_ID
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT        
    	DEPARTMENT_HEAD, 
        DEPARTMENT_ID,
        DEPARTMENT_STATUS
	FROM            
    	DEPARTMENT
	WHERE        
    	IS_PRODUCTION = 1 AND 
        BRANCH_ID = #ListGetAt(session.ep.user_location,2,'-')#
</cfquery>
<cfif not get_deamand_row.recordcount>
	<cfset get_deamand_row.recordcount = 0>
</cfif>
<cfquery name="get_delete_control" dbtype="query">
    SELECT SUM(PROD_QUANTITY) AS CONTROL_ FROM get_deamand_row
</cfquery>
<cfparam name="attributes.order_employee_id" default="#get_deamand.DEMAND_EMP#">
<cfparam name="attributes.order_employee" default="#get_emp_info(get_deamand.DEMAND_EMP,0,0)#">
<cfparam name="attributes.demand_employee_id" default="#get_deamand.DEMAND_TO_EMP#">
<cfparam name="attributes.demand_employee" default="#get_emp_info(get_deamand.DEMAND_TO_EMP,0,0)#">
<cfparam name="attributes.department_id" default="#get_deamand.DEMAND_DEPARTMENT_ID#">
<cfparam name="attributes.date" default="#get_deamand.DEMAND_DATE#">
<cfparam name="attributes.termin" default="#get_deamand.DEMAND_DELIVER_DATE#">
<cfparam name="attributes.date" default="">
<cfparam name="attributes.termin" default="">
<cfset var_="upd_purchase_basket">
<table class="dph">
    <tr>
        <td class="dpht" name="<cfoutput>#getLang('myhome',1274)#</cfoutput>"><cfoutput>#getLang('finance',83)#</cfoutput></td>
        <td class="dphb" name="butons">
        	<a style="cursor:pointer" onclick="add_demand_row();"><img src="images/carier.gif"  title="<cf_get_lang_main no='3075.Üretim Plan Hesaplama'>" border="0"></a>
            <a style="cursor:pointer" onclick="add_demonte_row();"><img src="images/package.gif"  title="<cf_get_lang_main no='3076.Demonte Ürün Hesaplama'>" border="0"></a>
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=285&action_id=#attributes.upd_id#</cfoutput>','page');"><img src="/images/print.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" title="<cf_get_lang_main no='62.Yazdır'>
        </td>
  	</tr>
</table>
<table class="dpm">
    <tr>
		<td valign="top" class="dpml" name="Detail Page Left">
        <cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_production_demand">
        <cfinput type="hidden" name="upd_id" value="#attributes.upd_id#">
        <cf_form_box width="100%">
            <cf_object_main_table>
    			<cf_object_table column_width_list="70,180">
                	<cf_object_tr id="form_ul_fis_number" Title="#getLang('main',1408)#">
                        <cf_object_td type="text"><cfoutput>#getLang('main',1408)#</cfoutput></cf_object_td>
                        <cf_object_td>
                           <cfinput type="text" name="demand_head" value="#get_deamand.demand_head#" maxlength="150" style="width:160px;">
                        </cf_object_td>
                    </cf_object_tr>
                    <cf_object_tr id="form_ul_date" Title="#getLang('project',86)#">
                        <cf_object_td type="text"><cfoutput>#getLang('project',86)#</cfoutput></cf_object_td>
                        <cf_object_td>
                         	<input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee_id#</cfoutput></cfif>">
                 			<input name="order_employee" type="text" id="order_employee" style="width:160px;vertical-align:top" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','125');" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee#</cfoutput></cfif>" autocomplete="off">	
                 			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.order_employee_id&field_name=form_basket.order_employee&is_form_submitted=1&select_list=1','list');"><img src="/images/plus_thin.gif"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>   
                <cf_object_table column_width_list="70,180">
                	<cf_object_tr id="form_ul_fis_number" Title="#getLang('main',160)#">
                        <cf_object_td type="text"><cfoutput>#getLang('main',160)#</cfoutput> *</cf_object_td>
                        <cf_object_td>
                           	<select name="department_id"  id="department_id"style="width:160px; height:20px">
                           		<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_department">
                                	<option value="#department_id#" <cfif department_id eq attributes.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                </cfoutput>
                           	</select>
                        </cf_object_td>
                    </cf_object_tr>
                    <cf_object_tr id="form_ul_date" Title="#getLang('main',512)#">
                        <cf_object_td type="text"><cfoutput>#getLang('main',512)#</cfoutput> *</cf_object_td>
                        <cf_object_td>
                         	<input type="hidden" name="demand_employee_id" id="demand_employee_id" value="<cfif isdefined('attributes.demand_employee_id') and len(attributes.demand_employee_id) and isdefined('attributes.demand_employee') and len(attributes.demand_employee)><cfoutput>#attributes.demand_employee_id#</cfoutput></cfif>">
                 	<input name="demand_employee" type="text" id="demand_employee" style="width:160px;vertical-align:top" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','demand_employee_id','','3','125');" value="<cfif isdefined('attributes.demand_employee_id') and len(attributes.demand_employee_id) and isdefined('attributes.demand_employee') and len(attributes.demand_employee)><cfoutput>#attributes.demand_employee#</cfoutput></cfif>" autocomplete="off">	
                 	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.demand_employee_id&field_name=form_basket.demand_employee&is_form_submitted=1&select_list=1','list');"><img src="/images/plus_thin.gif"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table> 
                <cf_object_table column_width_list="70,100">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='1447.Süreç'></cfsavecontent>
                    <cf_object_tr id="form_ul_fis_type" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no="1447.Süreç"> *</cf_object_td>
                        <cf_object_td>
                            <cf_workcube_process is_upd='0' process_cat_width='90' is_detail='0'>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cfoutput>#getLang('prod',133)#</cfoutput></cfsavecontent>
                    <cf_object_tr id="form_ul_connect_type" Title="#header_#">
                        <cf_object_td type="text"><cfoutput>#getLang('prod',133)#</cfoutput></cf_object_td>
                        <cf_object_td>
                             <cfinput type="text" name="demand_no" readonly="yes" value="#get_deamand.DEMAND_NUMBER#" style="width:90px; text-align:right">
                        </cf_object_td>
                    </cf_object_tr>
               	</cf_object_table>
                <cf_object_table column_width_list="70,100">
                    <cfsavecontent variable="header_"><cfoutput>#getLang('main',280)#</cfoutput></cfsavecontent>
                    <cf_object_tr id="form_ul_fis_type" Title="#header_#">
                        <cf_object_td type="text"><cfoutput>#getLang('main',280)#</cfoutput> *</cf_object_td>
                        <cf_object_td>
                            <cfsavecontent variable="message"><cfoutput>#getLang('main',494)#</cfoutput></cfsavecontent>
                 			<cfinput required="Yes" message="#message#" type="text" name="date" id="date" validate="eurodate" style="width:65px;" value="#dateformat(attributes.date,'dd/mm/yyyy')#">
                    		<cf_wrk_date_image date_field="date">
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cfoutput>#getLang('report',1830)#</cfoutput></cfsavecontent>
                    <cf_object_tr id="form_ul_connect_type" Title="#header_#">
                        <cf_object_td type="text"><cfoutput>#getLang('report',1830)#</cfoutput> *</cf_object_td>
                        <cf_object_td>
                         	<cfsavecontent variable="message1"><cfoutput>#getLang('main',3078)#</cfoutput></cfsavecontent>
                 			<cfinput required="Yes" message="#message1#" type="text" name="termin" id="termin" validate="eurodate" style="width:65px;" value="#dateformat(attributes.termin,'dd/mm/yyyy')#">
                    		<cf_wrk_date_image date_field="termin">
                        </cf_object_td>
                    </cf_object_tr>
               	</cf_object_table>
                <cf_object_table column_width_list="50,200">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='217.Açıklama'></cfsavecontent>
                    <cf_object_tr id="form_ul_detail" Title="#header_#">
                        <cf_object_td type="text" rowspan="2"><cf_get_lang_main no='217.Açıklama'></cf_object_td>
                        <cf_object_td rowspan="2">
                            <textarea name="detail" id="detail" style="height:50px; width:190px"><CFOUTPUT>#get_deamand.DEMAND_DETAIL#</CFOUTPUT></textarea>        
                        </cf_object_td>          
                    </cf_object_tr>
                </cf_object_table>
            </cf_object_main_table>
            <cf_form_box_footer>
                <table width="100%">
                    <tr>
                        <td>
                       	</td>
                        <td style="text-align:right">
                        	<cfif get_delete_control.CONTROL_ eq 0 or not get_deamand_row.recordcount>
                                <cf_workcube_buttons is_upd='1' add_function='kontrol()' 
                                        is_delete='1'
                                        del_function='sil_kontrol()' 
                                    >
                            	<cfelse>
                                	<cf_workcube_buttons is_delete='0' is_upd='1' add_function='kontrol()'>
                                </cfif>

                         </td> 
                    </tr>
                </table>
			</cf_form_box_footer> 
        </cf_form_box>
            <cf_form_list id="table2">
                <thead style="width:100%">
                    <tr>
                        <th width="30px" style="text-align:center">
                        	<a href="javascript://" onClick="openProducts();">
                             	<img src="/images/plus_list.gif" border="0" id="basket_header_add" title="<cfoutput>#getLang('main',1616)#</cfoutput>">
                          	</a>
                        </th>
                        <th width="30px"><cf_get_lang_main no='1165.Sıra'></th>
                        <th width="50px" nowrap="nowrap"><cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='218.Tip'></th>
                        <th width="150px" nowrap="nowrap"><cf_get_lang_main no='106.Stok Kodu'></th>
                        <th width="100%" nowrap="nowrap"><cf_get_lang_main no='809.Ürün Adı'></th>
                        <th width="65px"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="50px"><cf_get_lang_main no='224.Birim'></th>
                        <th width="70px"><cf_get_lang_main no='2252.Üretim Emri'></th>
                    </tr>
                </thead>
                <tbody name="new_row" id="new_row">
                	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_deamand_row.recordcount#</cfoutput>">
					<cfif get_deamand_row.recordcount gt 0>
						<cfoutput query="get_deamand_row">
                            <input type="Hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                            <input type="Hidden" name="demand_row_list" id="demand_row_list" value="#EZGI_DEMAND_ROW_ID#">
                            <tr height="20" id="frm_row#currentrow#">
                                <td style="text-align:center">
                                	<cfif prod_quantity eq 0>
                                        <a href="javascript://" onClick="sil(#currentrow#);">
                                            <img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0">
                                        </a>
                                    </cfif>
                                </td>
                                <td style="text-align:center">#currentrow#&nbsp;</td>
                                <td class="boxtext">&nbsp;
                                   	<cfif PRODUCT_TYPE eq 1><cf_get_lang_main no='1099.Takım'>
                                   	<cfelseif PRODUCT_TYPE eq 2><cf_get_lang_main no='2944.Modül'>
                                   	<cfelseif PRODUCT_TYPE eq 3><cf_get_lang_main no='2903.Paket'>
                                   	<cfelseif PRODUCT_TYPE eq 4><cf_get_lang_main no='2848.Parça'>
                                   	</cfif>
                                 	<input type="hidden" name="type#currentrow#" id="type#currentrow#" value="#PRODUCT_TYPE#">
                             	</td>
                                <td>&nbsp;
                                	<input type="text" id="stock_code#currentrow#" name="stock_code#currentrow#" style="width:140px;" class="boxtext" value="#PRODUCT_CODE#" readonly=yes>
                                </td>
                                <td nowrap="nowrap">&nbsp;
                                	<input type="Hidden" name="stock_id#currentrow#" value="#stock_id#">
                                	<input type="text" name="product_name#currentrow#" style="width:300px;" class="boxtext" value="#product_name#">
                                </td>
                                <td style="text-align:right">
                                	<input type="text" name="quantity#currentrow#" id="quantity#currentrow#"  value="#TlFormat(quantity,2)#" onkeyup="isNumber(this);" style="width:65px; text-align:right;" <cfif prod_quantity eq 0><cfelse>readonly="readonly"</cfif>>

                              	</td>
                                <td nowrap="nowrap">&nbsp;
                                	<input type="text" name="main_unit#currentrow#" style="width:50px;" class="boxtext" value="#MAIN_UNIT#">
                                </td>
                                <td style="text-align:right">
                                	<input type="text" name="prod_quantity#currentrow#" readonly="readonly" id="prod_quantity#currentrow#"  value="#TlFormat(prod_quantity,2)#" onkeyup="isNumber(this);" style="width:65px; text-align:right;">
                              	</td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
            </cf_form_list>
        </td>
  	</tr>
    </cfform>
</table>          
<script type="text/javascript">
	var row_count = document.form_basket.record_num.value;
	function kontrol()
	{
		if (form_basket.termin.value.length == '')
		{
			alert("<cf_get_lang_main no='3095.Planlama Tarihi Girmelisiniz'> !");
			return false;
		}
		if (form_basket.date.value.length == '')
		{
			alert("<cf_get_lang_main no='3095.Planlama Tarihi Girmelisiniz'> !");
			return false;
		}
		if(process_cat_control())
			return true;
		else
			return false;
	}
	function sil_kontrol()
	{
		if(process_cat_control())
			window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_production_demand&upd_id=#attributes.upd_id#</cfoutput>";
		else
			return false;
	}
	function add_demand_row()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_production_need&upd_id=#attributes.upd_id#'</cfoutput>,'longpage');
	}
	function add_demonte_row()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_production_demonte_need&upd_id=#attributes.upd_id#'</cfoutput>,'longpage');
	}
	function openProducts()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&price_cat=-2&ezgi_production=1&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
	}
	<!---function deleteProducts()
	{
		sor=confirm("<cf_get_lang_main no='121.Silmek İstediğinizden Emin Misiniz?'> ");
		if(sor==true)
			window.location ="<cfoutput>
		#request.self#?fuseaction=prod.emptypopup_del_ezgi_production_demand&upd_id=#attributes.upd_id#</cfoutput>";
		else
			return false;
	}--->
	function sil(sy)
	{
		var element=eval("form_basket.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";		
	}
	function add_row(stockid,stockprop,sirano,product_id,product_name,stock_code,type,type_detail,main_unit)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.form_basket.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:right;");
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>&nbsp;';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = row_count+'&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="type' + row_count + '" value="'+type+'">';
		newCell.innerHTML = newCell.innerHTML + '&nbsp;<input type="text" name="type_detail' + row_count + '" style="width:70px;" class="boxtext" value="'+type_detail+'"><input type="Hidden" name="ezgi_id' + row_count + '" id="ezgi_id' + row_count + '" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '&nbsp;<input type="text" name="stock_code' + row_count + '" style="width:140px;" class="boxtext" value="'+stock_code+'">';
		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '&nbsp;<input type="text" name="product_name' + row_count + '" style="width:300px;" class="boxtext" value="'+product_name+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:right;");
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,2)#</cfoutput>" style="width:65px; text-align:right;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '&nbsp;<input type="text" name="main_unit' + row_count + '" style="width:50px;" class="boxtext" value="'+main_unit+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:right;");
		newCell.innerHTML = '<input type="text" id="prod_quantity' + row_count +'" name="prod_quantity' + row_count +'" value="<cfoutput>#TlFormat(0,2)#</cfoutput>" style="width:65px; text-align:right;">';
	}
</script>