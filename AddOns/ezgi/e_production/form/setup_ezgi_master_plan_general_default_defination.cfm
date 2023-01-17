<cfparam name="attributes.cat" default="">
<cfparam name="attributes.category_name" default="">
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_MASTER_PLAN_DEFAULTS WHERE SHIFT_ID = #attributes.shift_id#
</cfquery>
<cfquery name="get_shift" datasource="#dsn#">
	SELECT DEPARTMENT_ID, BRANCH_ID FROM SETUP_SHIFTS WHERE SHIFT_ID = #attributes.shift_id#
</cfquery>
<cfquery name="get_w" datasource="#dsn3#">
	SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS WHERE UP_STATION IS NULL AND DEPARTMENT = #get_shift.DEPARTMENT_ID# ORDER BY STATION_NAME
</cfquery>
<cfquery name="get_defaults_row" datasource="#dsn3#">
	SELECT * FROM EZGI_MASTER_PLAN_SABLON WHERE SHIFT_ID = #attributes.shift_id# ORDER BY SIRA
</cfquery>
<cfquery name="get_main_default" dbtype="query">
	SELECT * FROM get_defaults_row WHERE STATUS_ID = 0
</cfquery>
<cfquery name="get_sub_row" dbtype="query">
	SELECT * FROM get_defaults_row WHERE STATUS_ID = 1 ORDER BY SIRA
</cfquery>
<cfif get_defaults.recordcount>
    <cfquery name="get_department_pro" datasource="#dsn#">
        SELECT LOCATION_ID, DEPARTMENT_ID, COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = #get_defaults.DEFAULT_PRODUCTION_LOC_ID# AND DEPARTMENT_ID = #get_defaults.DEFAULT_PRODUCTION_STORE_ID#
    </cfquery>
    <cfquery name="get_department_raw" datasource="#dsn#">
        SELECT LOCATION_ID, DEPARTMENT_ID, COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = #get_defaults.DEFAULT_RAW_LOC_ID# AND DEPARTMENT_ID = #get_defaults.DEFAULT_RAW_STORE_ID#
    </cfquery>
    <cfquery name="get_cat" datasource="#dsn1#">
    	SELECT PRODUCT_CATID, PRODUCT_CAT, HIERARCHY FROM PRODUCT_CAT WHERE HIERARCHY = '#get_defaults.FABRIC_CAT#'
   	</cfquery> 
    <cfset attributes.pro_department_id = get_department_pro.DEPARTMENT_ID>
    <cfset attributes.pro_location_id = get_department_pro.LOCATION_ID>
	<cfset attributes.pro_location_name = get_department_pro.COMMENT>
    <cfset attributes.raw_department_id = get_department_raw.DEPARTMENT_ID>
    <cfset attributes.raw_location_id = get_department_raw.LOCATION_ID>
	<cfset attributes.raw_location_name = get_department_raw.COMMENT>
    <cfset attributes.cat = get_cat.HIERARCHY>
	<cfset attributes.category_name = get_cat.PRODUCT_CAT>
<cfelse>
	<cfset attributes.pro_department_id = ''>
    <cfset attributes.pro_location_id = ''>
	<cfset attributes.pro_location_name = ''>
    <cfset attributes.raw_department_id = ''>
    <cfset attributes.raw_location_id = ''>
	<cfset attributes.raw_location_name = ''>
    <cfset attributes.cat = ''>
	<cfset attributes.category_name = ''>
</cfif>

<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='3374.Üretim Genel Default Tanımları'></td>
        <td class="dphb">
        	<cfoutput>
				
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<cfform name="upd_e_production_setup" method="post" action="#request.self#?fuseaction=prod.emptypopup_setup_ezgi_master_plan_general_default_defination">
	<cfinput type="hidden" name="shift_id" value="#attributes.shift_id#">
    <table class="dpm" align="center" style="width:100%">
        <tr>
            <td valign="top" class="dpml">
                <cf_form_box>	
                    <table>
                        <tr height="25px" >
                            <td width="150px"  style="font-weight:bold"><cf_get_lang_main no='3376.Default Üretim Depo'></td>
                            <td width="280px"  style="text-align:left">
                                <cf_wrkdepartmentlocation 
                                                returninputvalue="pro_location_id,pro_location_name,pro_department_id"
                                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                                fieldname="pro_location_name"
                                                fieldid="pro_location_id"
                                                status="1"
                                                is_department="1"
                                                department_fldid="pro_department_id"
                                                department_id="#attributes.pro_department_id#"
                                                location_id="#attributes.pro_location_id#"
                                                location_name="#attributes.pro_location_name#"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                user_location = "0"
                                                width="200">
                            
                            </td>
                            <td width="150px" style="font-weight:bold"><cf_get_lang_main no='3386.Optimizasyon'> <cf_get_lang_main no='74.Kategori'></td>
                            <td width="280px">
                                <input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
                                <input name="category_name" type="text" id="category_name" style="width:200px;" onFocus="AutoComplete_Create('category_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','cat','','3','170');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
                                <a href="javascript://"onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=upd_e_production_setup.cat&field_name=upd_e_production_setup.category_name</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                
                            </td>
                            <td width="100px" style="font-weight:bold"><cf_get_lang_main no='3379.Doluluk'></td>
                            <td width="180px">
                            	<select name="point_method" id="point_method" style="width:170px; height:20px">
                                	<option value="1" <cfif get_defaults.POINT_METHOD eq 1>selected</cfif>><cfoutput>#getLang('myhome',979)#</cfoutput></option>
                                    <option value="2" <cfif get_defaults.POINT_METHOD eq 2>selected</cfif>><cfoutput>#getLang('product',170)#</cfoutput></option>
                                </select>
                            </td>
                        </tr>
                        <tr height="25px"  id="design_name_">
                            <td style="font-weight:bold"><cf_get_lang_main no='3377.Default Malzeme Depo'></td>
                            <td width="280px"  style="text-align:left">
                                <cf_wrkdepartmentlocation 
                                                returninputvalue="raw_location_id,raw_location_name,raw_department_id"
                                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                                fieldname="raw_location_name"
                                                fieldid="raw_location_id"
                                                status="1"
                                                is_department="1"
                                                department_fldid="raw_department_id"
                                                department_id="#attributes.raw_department_id#"
                                                location_id="#attributes.raw_location_id#"
                                                location_name="#attributes.raw_location_name#"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                user_location = "0"
                                                width="200">
                            </td>
                            <td  style="font-weight:bold"><cf_get_lang_main no='1204.Belge Numarası'></td>
                            <td >
                                <input type="text" name="paper_serious" id="paper_serious" value="<cfoutput>#Trim(get_main_default.PAPER_SERIOUS)#</cfoutput>" style="width:40px">
                                <input type="text" name="paper_no" id="paper_no" value="<cfoutput>#get_main_default.paper_no#</cfoutput>" style="width:80px">
                            </td>
                            <td  style="font-weight:bold"><cfoutput>#getLang('invoice',276)#</cfoutput></td>
                            <td>
                            	<select name="control_method" id="control_method" style="width:170px; height:20px">
                                	<option value="1" <cfif get_defaults.CONTROL_METHOD eq 1>selected</cfif>><cfoutput>#getLang('report',2085)#</cfoutput></option>
                                    <option value="2" <cfif get_defaults.CONTROL_METHOD eq 2>selected</cfif>><cfoutput>Sipariş Bazında</cfoutput></option>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <cf_form_box_footer>
                        <cf_workcube_buttons 
                            is_upd='1' 
                            is_delete = '0' 
                            add_function='kontrol()'>
                    </cf_form_box_footer>
                </cf_form_box>
                <cf_seperator title="<cfoutput>#getLang('main',3412)#</cfoutput>" id="sub_plans_" is_closed="0">
                <div id="sub_plans_" style="width:100%">
                    <cf_form_list id="table2">
                        <thead style="width:100%">
                            <tr height="20px">
                                <th style="text-align:center; width:20px;" rowspan="2" >
                                    <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="add_row();">
                                    <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_sub_row.recordcount#</cfoutput>">
                                </th>
                                <th style="text-align:center; width:30px" rowspan="2"><cf_get_lang_main no='1165.Sıra'> *</th>
                                <th style="text-align:center;" rowspan="2"><cf_get_lang_main no='3212.Alt Plan'> *</th>
                                <th style="text-align:center; width:120px" rowspan="2"><cf_get_lang_main no='1204.Belge Numarası'> *</th>
                                <th style="text-align:center; width:200px" rowspan="2"><cf_get_lang_main no='1422.İstasyon'> *</th>
                                <th style="text-align:center;" rowspan="2"><cfoutput>#getLang('settings',2641)#</cfoutput></th>
                                <th style="text-align:center; width:70px" rowspan="2"><cf_get_lang_main no='539.Hedef'></th>
                                <th style="text-align:center; height:20px" colspan="2"><cf_get_lang_main no='3075.Üretim Planı Hesaplama'></th>
                                <th style="text-align:center;" colspan="3"><cfoutput>#getLang('service',27)#</cfoutput></th>
                                <th style="text-align:center;" colspan="5"><cf_get_lang_main no='1498.Özellikler'></th>
                                <th style="text-align:center; width:170px" rowspan="2"><cfoutput>#getLang('myhome',1461)#</cfoutput></th>
                            </tr>
                            <tr>
                                <th style="text-align:center; height:20px; width:200px"><cf_get_lang_main no='1422.İstasyon'></th>
                                <th style="text-align:center; width:60px"><cf_get_lang_main no='78.Gün'></th>
                                <th style="text-align:center; width:90px"><cfoutput>#getLang('prod',221)#</cfoutput></th>
                                <th style="text-align:center; width:90px"><cfoutput>#getLang('main',3399)#</cfoutput></th>
                                <th style="text-align:center; width:90px"><cf_get_lang_main no='3306.Optimum İhtiyaç'></th>
                                <th style="text-align:center; width:50px"><cfoutput>#getLang('prod',502)#</cfoutput></th>
                                <th style="text-align:center; width:50px"><cf_get_lang_main no='3551.Birleştir'></th>
                                <th style="text-align:center; width:50px"><cf_get_lang_main no='1331.Gönder'></th>
                                <th style="text-align:center; width:50px"><cf_get_lang_main no='51.Sil'></th>
                                <th style="text-align:center; width:90px"><cf_get_lang_main no='3283.Alt Plan Malzeme Kontrol Sistemi'></th>
                            </tr>
                        </thead>
                        <tbody name="new_row" id="new_row">
                            <cfif get_sub_row.recordcount>
                                <cfoutput query="get_sub_row">
                                    <tr name="frm_row" id="frm_row#currentrow#">
                                        <td style="height:20px; text-align:center">
                                            <a style="cursor:pointer" onclick="sil(#currentrow#);">
                                                <img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>">
                                            </a>
                                            <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                            <input type="hidden" name="process_id#currentrow#" id="process_id#currentrow#" value="#process_id#">
                                        </td>
                                        <td style="text-align:right">
                                            <input type="text" name="sira#currentrow#" id="sira#currentrow#" value="#sira#" style="width:30px; text-align:right" maxlength="3">
                                        </td>
                                        <td><input type="text" name="process_name#currentrow#" id="process_name#currentrow#" value="#process_name#" style="width:100%" maxlength="100"></td>
                                        <td nowrap="nowrap">
                                            <input type="text" name="paper_serious#currentrow#" id="paper_serious#currentrow#" value="#paper_serious#" style="width:30px" maxlength="3">
                                            <input type="text" name="paper_no#currentrow#" id="paper_no#currentrow#" value="#paper_no#" style="width:85px" maxlength="10">
                                        </td>
                                        <td>
                                            <select name="workstation_id#currentrow#" id="workstation_id#currentrow#" style="width:200px; height:20px">
                                                <cfloop query="get_w">
                                                    <option value="#get_w.STATION_ID#" <cfif get_sub_row.workstation_id eq get_w.STATION_ID>selected</cfif>>#get_w.STATION_NAME#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                        <td><input type="text" name="sub_plan_head#currentrow#" id="sub_plan_head#currentrow#" value="#menu_head#" style="width:100%" maxlength="100"></td>
                                        <td><input type="text" name="current_point#currentrow#" id="current_point#currentrow#" value="#current_point#" style="width:70px; text-align:center" maxlength="8"></td>
                                        <td>
                                            <select name="up_workstation_id#currentrow#" id="up_workstation_id#currentrow#" style="width:200px; height:20px">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfloop query="get_w">
                                                    <option value="#get_w.STATION_ID#" <cfif get_sub_row.up_workstation_id eq get_w.STATION_ID>selected</cfif>>#get_w.STATION_NAME#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                        <td><input type="text" name="up_workstation_time#currentrow#" id="up_workstation_time#currentrow#" value="#up_workstation_time#" style="width:60px; text-align:center" maxlength="3"></td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="toplu_p_orders#currentrow#" id="toplu_p_orders#currentrow#" value="1" <cfif toplu_p_orders eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="p_order_from_order#currentrow#" id="p_order_from_order#currentrow#" value="1" <cfif p_order_from_order eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="p_order_free#currentrow#" id="p_order_free#currentrow#" value="1" <cfif p_order_free eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="is_group#currentrow#" id="is_group#currentrow#" value="1" <cfif is_group eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="is_collect#currentrow#" id="is_collect#currentrow#" value="1" <cfif is_collect eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="is_movie#currentrow#" id="is_movie#currentrow#" value="1" <cfif is_movie eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="is_delete#currentrow#" id="is_delete#currentrow#" value="1" <cfif is_delete eq 1>checked</cfif>>
                                        </td>
                                        <td style="text-align:center">
                                            <input type="checkbox" name="is_control#currentrow#" id="is_control#currentrow#" value="1" <cfif is_control eq 1>checked</cfif>>
                                        </td>
                                        <td>
                                            <select name="timing_type#currentrow#" id="timing_type#currentrow#" style="width:170px; height:20px">
                                                <option value="1" <cfif timing_type eq 1>selected</cfif>><cf_get_lang_main no='1639.Standart Hesap'></option>
                                                <option value="3" <cfif timing_type eq 3>selected</cfif>>#getLang('production',94)#</option>
                                            </select>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </cfif>
                        </tbody>
                    </cf_form_list>
                </div>
            </td>
        </tr>
    </table>
    </cfform>
    <script type="text/javascript">
	var row_count=document.upd_e_production_setup.record_num.value;
	function kontrol()
	{
		if(document.getElementById("pro_location_name").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='3376.Default Üretim Depo'>!");
			document.getElementById('pro_location_name').focus();
			return false;
		}
		if(document.getElementById("raw_location_name").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='3377.Default Malzeme Depo'>!");
			document.getElementById('raw_location_name').focus();
			return false;
		}
		if(document.getElementById("category_name").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='3386.Optimizasyon'> <cf_get_lang_main no='74.Kategori'>!");
			document.getElementById('category_name').focus();
			return false;
		}
		if(document.getElementById("paper_serious").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1204.Belge Numarası'>!");
			document.getElementById('paper_serious').focus();
			return false;
		}
		if(document.getElementById("paper_no").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1204.Belge Numarası'> !");
			document.getElementById('paper_no').focus();
			return false;
		}
		for(var cl_ind=1; cl_ind <= row_count; cl_ind++)
		{
			if(document.getElementById("sira"+cl_ind).value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1165.Sıra'>!");
				document.getElementById("sira"+cl_ind).focus();
				return false;
			}
			if(document.getElementById("process_name"+cl_ind).value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='3212.Alt Plan'>!");
				document.getElementById("process_name"+cl_ind).focus();
				return false;
			}
			if(document.getElementById("paper_serious"+cl_ind).value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1204.Belge Numarası'>!");
				document.getElementById("paper_serious"+cl_ind).focus();
				return false;
			}
			if(document.getElementById("paper_no"+cl_ind).value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1204.Belge Numarası'>!");
				document.getElementById("paper_no"+cl_ind).focus();
				return false;
			}
			if(document.getElementById("workstation_id"+cl_ind).value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1422.İstasyon'>!");
				document.getElementById("workstation_id"+cl_ind).focus();
				return false;
			}
			if(document.getElementById("sub_plan_head"+cl_ind).value == '')
			{
				alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cfoutput>#getLang('settings',2641)#</cfoutput>!");
				document.getElementById("sub_plan_head"+cl_ind).focus();
				return false;
			}
		}
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
		
		document.upd_e_production_setup.record_num.value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="process_id' + row_count +'" id="process_id' + row_count +'" value="0"><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'right';
		newCell.innerHTML = '<input type="text" name="sira' + row_count +'" id="sira' + row_count +'" value="' + row_count +'" style="width:30px; text-align:right" maxlength="3">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'left';
		newCell.innerHTML = '<input type="text" name="process_name' + row_count +'" id="process_name' + row_count +'" value="" style="width:100%; maxlength="100">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'left';
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="paper_serious' + row_count +'" id="paper_serious' + row_count +'" value="" style="width:30px; maxlength="3"> <input type="text" name="paper_no' + row_count +'" id="paper_no' + row_count +'" value="" style="width:85px; maxlength="10">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		b = '<select name="workstation_id' + row_count +'" id="workstation_id' + row_count +'" style="width:200px; height:20px"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
		<cfoutput query="get_w">
			b += '<option value="#get_w.station_id#">#get_w.station_name#</option>';
		</cfoutput>
		newCell.innerHTML = b + '</select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'left';
		newCell.innerHTML = '<input type="text" name="sub_plan_head' + row_count +'" id="sub_plan_head' + row_count +'" value="" style="width:100%; maxlength="100">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'left';
		newCell.innerHTML = '<input type="text" name="current_point' + row_count +'" id="current_point' + row_count +'" value="0" style="width:70px; text-align:center" maxlength="8">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		b = '<select name="up_workstation_id' + row_count +'" id="up_workstation_id' + row_count +'" style="width:200px; height:20px"><option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
		<cfoutput query="get_w">
			b += '<option value="#get_w.station_id#">#get_w.station_name#</option>';
		</cfoutput>
		newCell.innerHTML = b + '</select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'left';
		newCell.innerHTML = '<input type="text" name="up_workstation_time' + row_count +'" id="up_workstation_time' + row_count +'" value="0" style="width:60px; text-align:center" maxlength="3">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="toplu_p_orders' + row_count +'" id="toplu_p_orders' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="p_order_from_order' + row_count +'" id="p_order_from_order' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="p_order_free' + row_count +'" id="p_order_free' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="is_group' + row_count +'" id="is_group' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="is_collect' + row_count +'" id="is_collect' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="is_movie' + row_count +'" id="is_movie' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="is_delete' + row_count +'" id="is_delete' + row_count +'" value="1">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign = 'center';
		newCell.innerHTML = '<input type="checkbox" name="is_control' + row_count +'" id="is_control' + row_count +'" value="1">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		b = '<select name="timing_type' + row_count +'" id="timing_type' + row_count +'" style="width:170px; height:20px"><option value="1"><cf_get_lang_main no='1639.Standart Hesap'></option><option value="3"><cfoutput>#getLang('production',94)#</cfoutput></option>';
		newCell.innerHTML = b + '</select>';

	}
	function sil(sy)
	{
		
		var element=eval("upd_e_production_setup.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy);
		element.style.display="none";		
	} 
</script>