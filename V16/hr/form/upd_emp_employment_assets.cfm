<cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk')>
</cfif>
<cfquery name="CATEGORIES" datasource="#dsn#">
	SELECT 
		HIERARCHY,
		ASSET_CAT_ID,
		SPECIAL_HIERARCHY,
        ISNULL(SEQUENCE_NO,999) AS SEQUENCE_NO,
        CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE ASSET_CAT
		END AS ASSET_CAT
	FROM 
		SETUP_EMPLOYMENT_ASSET_CAT 
        LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ASSET_CAT">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_EMPLOYMENT_ASSET_CAT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY 
		HIERARCHY,
		SPECIAL_HIERARCHY,
		ASSET_CAT
</cfquery>
<cfquery name="get_ProcessTypes" datasource="#dsn#">
	SELECT
		STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.popup_form_emp_employment_assets,%">
</cfquery>
<cfquery name="DRIVERLICENCECATEGORIES" dbtype="query">
	SELECT 
		ASSET_CAT,
		HIERARCHY,
		ASSET_CAT_ID,
		SPECIAL_HIERARCHY
	FROM 
		categories
	WHERE
		HIERARCHY NOT LIKE '%.%'
	ORDER BY 
        SEQUENCE_NO,
		HIERARCHY,
		SPECIAL_HIERARCHY,
		ASSET_CAT
</cfquery>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_x_employment_assets_process = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'hr.form_upd_emp',
    property_name : 'x_employment_assets_process'
)>
<cfif get_x_employment_assets_process.recordcount>
    <cfset x_employment_assets_process = get_x_employment_assets_process.property_value>
<cfelse>
    <cfset x_employment_assets_process = 0>
</cfif>
<cfsavecontent variable="select_"><cfoutput query="driverLicenceCategories"><optgroup label="#asset_cat#"><cfquery name="get_alts" dbtype="query">SELECT ASSET_CAT,HIERARCHY,ASSET_CAT_ID FROM categories WHERE HIERARCHY LIKE '#hierarchy#.%' ORDER BY HIERARCHY,ASSET_CAT</cfquery><cfloop query="get_alts"><option value="#get_alts.asset_cat_id#"><cfloop from="1" to="#listlen(get_alts.hierarchy,'.')-1#" index="ccc">&nbsp;&nbsp;</cfloop>#get_alts.asset_cat#</option></cfloop></optgroup></cfoutput></cfsavecontent>		
<cfif not DRIVERLICENCECATEGORIES.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='41449.Önce Özlük Belge Kategorilerini Tanımlayınız'>!");
		window.close();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="get_old_rows" datasource="#dsn#">
		SELECT 
        	EMPLOYEE_ID, 
            ASSET_CAT_ID, 
            ASSET_DATE, 
            ASSET_FINISH_DATE, 
            ASSET_NO, 
            ASSET_NAME, 
            ASSET_FILE, 
            ROW_ID,
            RECORD_EMP,
            RECORD_IP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_IP,
            UPDATE_DATE,
            EMPLOYMENT_STAGE
        FROM 
    	    EMPLOYEE_EMPLOYMENT_ROWS 
        WHERE 
	        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
        	ASSET_CAT_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valuelist(driverlicencecategories.asset_cat_id)#">)
	</cfquery>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55312.Özlük Belgeleri"></cfsavecontent>
<cf_box title="#message# : #get_emp_info(attributes.employee_id,0,0)#">
    <cfform action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.emptypopup_upd_emp_employment_assets" method="post" name="form_basket" enctype="multipart/form-data">
        <cfset rowcount = 0>
        <cfset rowcount_sabit = 0>
        <input type="hidden" name="rowCount" id="rowCount" value="">
        <input type="hidden" name="sabit_rowCount" id="sabit_rowCount" value="<cfoutput>#get_old_rows.recordcount#</cfoutput>">
        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <input type="hidden" name="x_employment_assets_process" id="x_employment_assets_process" value="<cfoutput>#x_employment_assets_process#</cfoutput>">
            <cfloop query="driverLicenceCategories">
                <cfset up_asset_cat_id = ASSET_CAT_ID>
                <cfset up_hierarchy = HIERARCHY>
                <cfset up_name = ASSET_CAT>
                <cfset up_code = SPECIAL_HIERARCHY>
                <cfoutput>
                    <cfsavecontent variable="title_">
                        <cfif len(up_code)>#up_code#.</cfif>#up_name#
                    </cfsavecontent>
                </cfoutput>
                <cf_seperator id="table_list_#up_asset_cat_id#_#currentrow#" is_closed="1" title="#title_#">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="<cfoutput>table_list_#up_asset_cat_id#_#currentrow#</cfoutput>" style="display:none;">
                    <cf_grid_list>
                        <thead>
                        <cfoutput>
                            <tr>         
                                <th width="20"></th>
                                <th><cf_get_lang dictionary_id="57630.tip"></th>
                                <cfif x_employment_assets_process eq 1>
                                    <th style="min-width:75px"><cf_get_lang dictionary_id="58859.Süreç"></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id="55652.Belge Adı"></th>
                                <th><cf_get_lang dictionary_id="57880.belge no"></th>
                                <th><cf_get_lang dictionary_id="55659.Veriliş Tarihi"></th>
                                <th><cf_get_lang dictionary_id="57700.bitis tarih"></th>
                                <th><cf_get_lang dictionary_id="57468.Belge"></th>		 
                                <th class="text-center" width="20"><a href="javascript://"><i class="fa fa-file-text" border="0" title="Ekli Belge"></i></a></th>
                            </tr>
                        </cfoutput>
                        </thead>
                        <cfquery name="get_alts" dbtype="query">
                            SELECT 
                                ASSET_CAT,
                                HIERARCHY,
                                ASSET_CAT_ID
                            FROM 
                            categories
                            WHERE
                                HIERARCHY LIKE '#up_hierarchy#.%' AND
                                ASSET_CAT_ID <> #up_asset_cat_id#
                            ORDER BY 
                                SEQUENCE_NO,
                                HIERARCHY,
                                ASSET_CAT
                        </cfquery>
                        <tbody>
                        <cfloop query="get_alts">
                            <cfset second_asset_cat_id = get_alts.ASSET_CAT_ID>
                            <cfset second_hierarchy = get_alts.HIERARCHY>
                            <cfset second_name = get_alts.ASSET_CAT>
                            <cfquery name="cont_upper" dbtype="query">
                                SELECT * FROM get_old_rows WHERE ASSET_CAT_ID = #second_asset_cat_id#
                            </cfquery>
                            <cfif cont_upper.recordcount>
                                <cfoutput query="cont_upper">
                                    <cfset employment_stage_ = cont_upper.EMPLOYMENT_STAGE>
                                    <cfset rowcount_sabit = rowcount_sabit + 1>
                                    <cfset asset_cat_id_ = cont_upper.asset_cat_id>
                                    <input type="hidden" name="row_id#rowcount_sabit#" id="row_id#rowcount_sabit#" value="#row_id#">
                                    <tr id="sabit_my_row_#rowcount_sabit#">         
                                        <td width="20"><input type="hidden" name="sabit_row_kontrol_#rowcount_sabit#" id="sabit_row_kontrol_#rowcount_sabit#" value="1"><a href="javascript://" onClick="sabit_sil(#rowcount_sabit#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id="57463.Sil">"></i></a></td>
                                        <td><input type="hidden" name="sabit_asset_cat_id#rowcount_sabit#" id="sabit_asset_cat_id#rowcount_sabit#" value="#asset_cat_id_#"><input type="hidden" id="sabit_asset_cat_name#rowcount_sabit#" name="sabit_asset_cat_name#rowcount_sabit#" value="#second_name#"> #second_name#</td>
                                        <cfif x_employment_assets_process eq 1>
                                            <cfset line_number_ = -1>
                                            <cfif employment_stage_ neq ''>
                                                <cfquery name="GET_PROCESS_LINE_NUMBER" datasource="#dsn#">
                                                    SELECT
                                                        LINE_NUMBER
                                                    FROM
                                                        PROCESS_TYPE_ROWS
                                                    WHERE
                                                        PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employment_stage_#">
                                                </cfquery>
                                                <cfif GET_PROCESS_LINE_NUMBER.recordCount>
                                                    <cfset line_number_ = GET_PROCESS_LINE_NUMBER.LINE_NUMBER>
                                                </cfif>
                                            </cfif>
                                            <td>
                                                <div class="form-group" id="process_stage#rowcount_sabit#"><cfinput type="hidden" name="sabit_old_process_line" value="#line_number_#">
                                                <cf_workcube_process select_name="sabit_process_stage" is_upd='0' process_cat_width='120' is_detail='0' select_value='#employment_stage_#'></div>
                                            </td>
                                        </cfif>
                                        <td><div class="form-group"><input type="text" name="sabit_asset_name#rowcount_sabit#" id="sabit_asset_name#rowcount_sabit#" maxrows="100" value="#asset_name#"></div></td>
                                        <td><div class="form-group"><input type="text" name="sabit_asset_no#rowcount_sabit#" id="sabit_asset_no#rowcount_sabit#" maxrows="100" value="#asset_no#"></div></td>
                                        <td>
                                            <div class="form-group"><div class="input-group"><cfinput type="text" name="sabit_asset_date#rowcount_sabit#" maxrows="10" value="#dateformat(asset_date,dateformat_style)#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="sabit_asset_date#rowcount_sabit#"></span></div></div>
                                        </td>
                                        <td>
                                            <div class="form-group"><div class="input-group"><cfinput type="text" name="sabit_asset_finish_date#rowcount_sabit#" maxrows="10" value="#dateformat(asset_finish_date,dateformat_style)#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="sabit_asset_finish_date#rowcount_sabit#"></span></div></div>
                                        </td>
                                        <td>
                                            <div class="form-group"><input type="hidden" name="old_file_name#rowcount_sabit#" id="old_file_name#rowcount_sabit#" value="#ASSET_FILE#">
                                            <input type="file" name="sabit_asset_file#rowcount_sabit#" id="sabit_asset_file#rowcount_sabit#"></div>
                                        </td>
                                        <td class="text-center" width="20"><div class="form-group"><cfif len(ASSET_FILE)><a href="javascript://" onClick="windowopen('/documents/hr/#ASSET_FILE#','list');"><i class="fa fa-file-text" title="Ekli Belge" align="absmiddle"></a></cfif></div></td>			 
                                    </tr>
                                </cfoutput>
                            <cfelse>
                                <cfoutput>
                                    <cfset rowcount = rowcount + 1>
                                    <tr id="my_row_#rowcount#">         
                                        <td width="20"><input type="hidden" name="row_kontrol_#rowcount#" id="row_kontrol_#rowcount#" value="1"><a href="javascript://" onClick="sil(#rowcount#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id="57463.Sil">" alt="<cf_get_lang dictionary_id="57463.Sil">"></i></a></td>
                                        <td><input type="hidden" name="asset_cat_id#rowcount#" id="asset_cat_id#rowcount#" value="#second_asset_cat_id#"><input type="hidden" id="asset_cat_name#rowcount#" name="asset_cat_name#rowcount#" value="#second_name#"> #second_name#</td>
                                        <cfif x_employment_assets_process eq 1>
                                            <td>
                                                <div class="form-group" id="process_stage#rowcount#"><cfinput type="hidden" name="old_process_line" value="-1">
                                                <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0' select_value=''></div>
                                            </td>
                                        </cfif>
                                        <td><div class="form-group"><input type="text" name="asset_name#rowcount#" id="asset_name#rowcount#" maxrows="100" value=""></div></td>
                                        <td><div class="form-group"><input type="text" name="asset_no#rowcount#" id="asset_no#rowcount#" maxrows="100" value=""></div></td>
                                        <td>
                                            <div class="form-group"><div class="input-group"><cfinput type="text" name="asset_date#rowcount#" maxrows="10" value="">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="asset_date#rowcount#"></span></div></div>
                                        </td>
                                        <td>
                                            <div class="form-group"><div class="input-group"><cfinput type="text" name="asset_finish_date#rowcount#" maxrows="10" value="">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="asset_finish_date#rowcount#"></span></div></div></td>
                                        <td><input type="file" name="asset_file#rowcount#" id="asset_file#rowcount#" ></td>
                                        <td width="20">&nbsp;</td>			 
                                    </tr>
                                </cfoutput>
                            </cfif>
                        </cfloop>
                        </tbody>
                    </cf_grid_list>  
                </div> 
            </cfloop>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="55653.Ek Belgeler"></cfsavecontent>
            <cf_seperator id="table_list_ozel" is_closed="1" title="#message#"><!---.Ek Belgeler--->
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="table_list_ozel" style="display:none;">
                <cf_grid_list>
                    <thead>
                    <tr>
                        <th width="20"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary="57582.Ekle">"></i></a></th>
                        <th><cf_get_lang dictionary_id="57630.tip"></th>
                            <cfif x_employment_assets_process eq 1>
                                <th style="min-width:75px"><cf_get_lang dictionary_id="58859.Süreç"></th>
                            </cfif>
                        <th><cf_get_lang dictionary_id="55652.Belge Adı"></th>
                        <th><cf_get_lang dictionary_id="57880.belge no"></th>
                        <th><cf_get_lang dictionary_id="55659.Veriliş Tarihi"></th>
                        <th><cf_get_lang dictionary_id="57700.bitis tarih"></th>
                        <th><cf_get_lang dictionary_id="57468.Belge"></th>
                    </tr>
                    </thead>
                    <tbody id="table_list"></tbody>
                </cf_grid_list>
            </div>
            <div class="col col-12">
                <cf_box_footer>
                    <cf_record_info query_name="get_old_rows">
                    <cf_workcube_buttons is_upd='1' is_delete='0'  add_function='check_form()'>
                </cf_box_footer>
            </div>
    </cfform>
</cf_box>
<script type="text/javascript">
	rowCount = <cfoutput>#rowcount#</cfoutput>;
	function add_row()
	{
		rowCount++;
		var newRow;
		var newCell;
		
		newRow = table_list.insertRow();
		newRow.className = 'color-row';
		newRow.setAttribute("name","my_row_" + rowCount);
		newRow.setAttribute("id","my_row_" + rowCount);		
		newRow.setAttribute("NAME","my_row_" + rowCount);
		newRow.setAttribute("ID","my_row_" + rowCount);
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML= '<div class="form-group"></div><input type="hidden" name="row_kontrol_' + rowCount + '" value="1"><a href="javascript://" onClick="sil(' + rowCount + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id="57463.Sil">"></i></a></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML= '<div class="form-group"><select name="asset_cat_id' + rowCount + '"><cfoutput>#trim(select_)#</cfoutput></select><input type="hidden" id="asset_cat_name' + rowCount + '" name="asset_cat_name' + rowCount + '" value="#trim(select_)#"></div>';
        <cfif x_employment_assets_process eq 1>
            <cfoutput>
                newCell = newRow.insertCell(newRow.cells.length);
           	    newCell.innerHTML= '<div class="form-group"><select name="process_stage" id="process_stage" style="width:120px;"><cfloop query="get_ProcessTypes"><option value="#process_row_id#">#stage#</option></cfloop></select></div>';
            </cfoutput>
        </cfif>
        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML= '<div class="form-group"><input type="text" name="asset_name' + rowCount + '" maxrows="10"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML= '<div class="form-group"><input type="text" name="asset_no' + rowCount + '" maxrows="10"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("name","asset_date" + rowCount + "_td");
		newCell.setAttribute("id","asset_date" + rowCount + "_td");
		newCell.setAttribute("NAME","asset_date" + rowCount + "_td");
		newCell.setAttribute("ID","asset_date_" + rowCount + "_td");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="asset_date' + rowCount + '" id="asset_date' + rowCount + '" maxrows="10"><span class="input-group-addon" id="asset_date'+rowCount + '_td'+'"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("name","asset_finish_date" + rowCount + "_td");
		newCell.setAttribute("id","asset_finish_date" + rowCount + "_td");
		newCell.setAttribute("NAME","asset_finish_date" + rowCount + "_td");
		newCell.setAttribute("ID","asset_finish_date_" + rowCount + "_td");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="asset_finish_date' + rowCount + '" id="asset_finish_date' + rowCount + '" maxrows="10"><span class="input-group-addon" id="asset_finish_date'+rowCount + '_td'+'"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML= '<input type="file" name="asset_file' + rowCount + '" >';
		wrk_date_image('asset_date' + rowCount);
		wrk_date_image('asset_finish_date' + rowCount);
		return true;
	}
	
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function sabit_sil(sy)
	{
		var my_element=eval("form_basket.sabit_row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("sabit_my_row_"+sy);
		my_element.style.display="none";
	}
	
    function check_form()
	{
		document.getElementById('rowCount').value = rowCount;
	}

</script>