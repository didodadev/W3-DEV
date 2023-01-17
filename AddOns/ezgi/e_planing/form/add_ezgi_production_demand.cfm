<cfset fis_stock_id_list = ''>
<cfparam name="attributes.stock_id_list" default="">
<cfparam name="attributes.order_employee_id" default="#session.ep.userid#">
<cfparam name="attributes.demand_employee_id" default="">
<cfparam name="attributes.order_employee" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.demand_employee" default="">
<cfset var_="upd_purchase_basket">
<cfquery name="get_max_no" datasource="#dsn3#">
	SELECT ISNULL(max(DEMAND_NUMBER),10000) AS DEMAND_NUMBER FROM EZGI_PRODUCTION_DEMAND
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT        
    	DEPARTMENT_HEAD, 
        DEPARTMENT_ID
	FROM            
    	DEPARTMENT
	WHERE        
    	IS_PRODUCTION = 1 AND 
        BRANCH_ID = #ListGetAt(session.ep.user_location,2,'-')# AND 
        DEPARTMENT_STATUS = 1
</cfquery>
<cfset demand_number = get_max_no.DEMAND_NUMBER+1>
<cfif listlen(attributes.stock_id_list)>
	<cfloop list="#attributes.stock_id_list#" index="i">
		<cfset stock_id = ListGetAt(i,1,'_')>
        <cfset amount = ListGetAt(i,2,'_')>
     	<cfset fis_stock_id_list = ListAppend(fis_stock_id_list,stock_id)>
     	<cfset 'Amount_#stock_id#' = amount>
  	</cfloop>
 	<cfif ListLen(fis_stock_id_list)>
     	<cfquery name="get_stock_list" datasource="#dsn3#">
      		SELECT     
          		S.STOCK_ID, 
             	S.PRODUCT_NAME + ' - ' + S.PROPERTY AS PRODUCT_NAME, 
            	S.PRODUCT_CODE, 
             	PU.MAIN_UNIT,
                (
                	SELECT   TOP(1)     
                    	PIECE_TYPE 
					FROM            
                    	(
                        	SELECT        
                            	2 AS PIECE_TYPE, 
                                DESIGN_MAIN_RELATED_ID AS STOCK_ID
                          	FROM      
                            	EZGI_DESIGN_MAIN_ROW
                          	WHERE        
                            	DESIGN_MAIN_STATUS = 1 AND 
                                DESIGN_MAIN_RELATED_ID IS NOT NULL
                          	UNION ALL
                          	SELECT        
                          		3 AS PIECE_TYPE, 
                            	PACKAGE_RELATED_ID AS STOCK_ID
                          	FROM            
                            	EZGI_DESIGN_PACKAGE_ROW
                          	WHERE        
                            	PACKAGE_RELATED_ID IS NOT NULL
                          	UNION ALL
                          	SELECT        
                            	4 AS PIECE_TYPE, 
                                PIECE_RELATED_ID AS STOCK_ID
                          	FROM    
                            	EZGI_DESIGN_PIECE_ROWS
                          	WHERE        
                            	PIECE_RELATED_ID IS NOT NULL
              			) AS TBL
                  	WHERE TBL.STOCK_ID = S.STOCK_ID
                ) AS PRODUCT_TYPE
			FROM         
            	STOCKS AS S LEFT OUTER JOIN
            	PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
         	WHERE     
            	S.STOCK_ID IN (#fis_stock_id_list#)
     	</cfquery>
  	</cfif>
<cfelse>
	<cfset get_stock_list.recordcount = 0>
</cfif>
<cfparam name="attributes.date" default="">
<cfparam name="attributes.termin" default="">
<table class="dph">
    <tr>
        <td class="dpht" name="Fis Ekle"><cfoutput>#getLang('prod',76)#</cfoutput></td>
        <td class="dphb" name="butons" style="text-align:right">
            
        </td>
  	</tr>
</table>
<table class="dpm">
    <tr>
		<td valign="top" class="dpml" name="Detail Page Left">
        <cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_production_demand">
        <cfinput type="hidden" name="record_num" id="record_num" value="#get_stock_list.recordcount#">
        <cf_form_box width="100%">
            <cf_object_main_table>
    			<cf_object_table column_width_list="70,180">
                	<cf_object_tr id="form_ul_fis_number" Title="#getLang('main',1408)#">
                        <cf_object_td type="text"><cfoutput>#getLang('main',1408)#</cfoutput></cf_object_td>
                        <cf_object_td>
                           <cfinput type="text" name="demand_head" value="" maxlength="50" style="width:160px;">
                        </cf_object_td>
                    </cf_object_tr>
                    <cf_object_tr id="form_ul_date" Title="#getLang('objects',970)#">
                        <cf_object_td type="text"><cfoutput>#getLang('objects',970)#</cfoutput></cf_object_td>
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
                                	<option value="#department_id#">#DEPARTMENT_HEAD#</option>
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
                    <cfsavecontent variable="header_"><cfoutput>#getLang('main',1447)#</cfoutput></cfsavecontent>
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
                             <cfinput type="text" name="demand_no" readonly="yes" value="#demand_number#" style="width:90px; text-align:right">
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
                    <cfsavecontent variable="header_"><cfoutput>#getLang('prod',485)#</cfoutput></cfsavecontent>
                    <cf_object_tr id="form_ul_connect_type" Title="#header_#">
                        <cf_object_td type="text"><cfoutput>#getLang('prod',485)#</cfoutput> *</cf_object_td>
                        <cf_object_td>
                             <cfsavecontent variable="message1"><cfoutput>#getLang('main',3078)#</cfoutput></cfsavecontent>
                 			<cfinput required="Yes" message="#message1#" type="text" name="termin" id="termin" validate="eurodate" style="width:65px;" value="#dateformat(attributes.termin,'dd/mm/yyyy')#">
                    		<cf_wrk_date_image date_field="termin">
                        </cf_object_td>
                    </cf_object_tr>
               	</cf_object_table>
                <cf_object_table column_width_list="70,200">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='217.Açıklama'></cfsavecontent>
                    <cf_object_tr id="form_ul_detail" Title="#header_#">
                        <cf_object_td type="text" rowspan="2"><cf_get_lang_main no='217.Açıklama'></cf_object_td>
                        <cf_object_td rowspan="2">
                            <textarea name="detail" id="detail" style="height:50px; width:190px"></textarea>              
                        </cf_object_td>          
                    </cf_object_tr>
                </cf_object_table>
            </cf_object_main_table>
            <cf_form_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_form_box_footer> 
        </cf_form_box>

            <cf_form_list id="table2">
                <thead style="width:100%">
                    <tr>
                        <th width="30px" style="text-align:center">
                        	 <a href="javascript://" onClick="openProducts();"><img src="/images/plus_list.gif" border="0" id="basket_header_add" title="<cf_get_lang_main no='1613.Ürün Ekle'>"></a>
                        </th>
                        <th width="30px"><cfoutput>#getLang('main',1165)#</cfoutput></th>
                        <th width="70px" nowrap="nowrap"><cfoutput>#getLang('main',245)# #getLang('main',218)#</cfoutput></th>
                        <th width="150px" nowrap="nowrap"><cfoutput>#getLang('main',106)#</cfoutput></th>
                        <th width="100%" nowrap="nowrap"><cfoutput>#getLang('main',809)#</cfoutput></th>
                        <th width="65px"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="50px"><cfoutput>#getLang('main',224)#</cfoutput></th
                    </tr>
                </thead>
                <tbody name="new_row" id="new_row">
                	<cfif get_stock_list.recordcount gt 0>
						<cfoutput query="get_stock_list">
                            <tr name="frm_row#currentrow#" id="frm_row#currentrow#">
                                <input type="Hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                <input type="Hidden" name="ezgi_id#currentrow#" id="ezgi_id#currentrow#" value="">
                                <td style="text-align:center">
                                    <a style="cursor:pointer" onclick="sil(#currentrow#);" >
                                    	<img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>">
                                    </a>
                                </td>
                                <td style="text-align:center">#currentrow#</td>
                                <td style="text-align:left" class="boxtext">&nbsp;
                                	<cfif PRODUCT_TYPE eq 1><cf_get_lang_main no='1099.Takım'>
                                   	<cfelseif PRODUCT_TYPE eq 2><cf_get_lang_main no='2944.Modül'>
                                   	<cfelseif PRODUCT_TYPE eq 3><cf_get_lang_main no='2903.Modül'>
                                   	<cfelseif PRODUCT_TYPE eq 4><cf_get_lang_main no='2848.Modül'>
                                   	</cfif>
                                 	<input type="hidden" name="type#currentrow#" id="type#currentrow#"  value="#PRODUCT_TYPE#">
                                </td>
                                <td>&nbsp;
                                	<input type="text" id="stock_code#currentrow#" name="stock_code#currentrow#" style="width:135px;" class="boxtext" value="#PRODUCT_CODE#" readonly=yes>
                                </td>
                                <td nowrap="nowrap">&nbsp;
                                	<input type="text" name="product_name#currentrow#" style="width:300px;" class="boxtext" value="#product_name#">
                                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                                </td>
                                <td style="text-align:right">
                                	<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TlFormat(Evaluate('Amount_#stock_id#'),2)#" onkeyup="isNumber(this);" style="width:65px; text-align:right;">
                                </td>
                                <td>
                                	<input type="text" name="main_unit#currentrow#" style="width:45px;" class="boxtext" value="#MAIN_UNIT#">
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr><td colspan="7"><cf_get_lang_main no='72.Kayıt Yok'></td></tr>
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
		if(document.getElementById('order_employee_id').value < 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3079.Talep Eden'> !");
			return false;
		}
		if(document.getElementById('demand_employee_id').value <0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='512.Kime'> !");
			return false;
		}
		if(document.getElementById('department_id').value <0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='160.Departman'> !");
			return false;
		}
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
	function openProducts()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&price_cat=-2&ezgi_production=1&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
	}
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
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = row_count;
		
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
	}
</script>