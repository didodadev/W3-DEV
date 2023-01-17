<cf_get_lang_set module_name = 'hr'>
<cfscript>
	cmp_company = createObject("component","hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company();
	cmp_branch = createObject("component","hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(comp_id : '#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#');
	cmp_department = createObject("component","hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#');
	cmp_department_all = createObject("component","hr.cfc.get_departments");
	cmp_department_all.dsn = dsn;
	get_department_all = cmp_department_all.get_department();
	cmp_pos_cat = createObject("component","hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cat = cmp_pos_cat.get_position_cat();
	cmp_func = createObject("component","hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_func = cmp_func.get_function();
	cmp_title = createObject("component","hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
	cmp_org_step = createObject("component","hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_org_step = cmp_org_step.get_organization_step();
	collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
	QueryAddRow(collar_type,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#lang_array.item[980]#",1);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME",'#lang_array.item[981]#',2);
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.work_startdate" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfif isdefined('attributes.work_startdate') and isdate(attributes.work_startdate)><cf_date tarih = "attributes.work_startdate"></cfif>
<cfquery name="fire_reasons" datasource="#dsn#">
	SELECT REASON_ID,REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE IS_POSITION = 1 ORDER BY REASON
</cfquery>
<cfquery name="get_xml_detail" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.form_add_position"> AND
		(PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_upd_in_out"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_control"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_reason_control">)
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_positions" datasource="#dsn#">
		SELECT DISTINCT
			EP.POSITION_ID,
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.POSITION_CAT_ID,
			EP.TITLE_ID,
			EP.FUNC_ID,
			EP.ORGANIZATION_STEP_ID,
			EP.COLLAR_TYPE,
			EP.IN_COMPANY_REASON_ID,
			D.DEPARTMENT_ID,
			B.BRANCH_ID,
			B.BRANCH_NAME
		FROM
			EMPLOYEE_POSITIONS EP
			INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
		WHERE
			EP.IS_MASTER = 1
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
			</cfif>
			<cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
				AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.pos_cat_id#">)
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.func_id#">)
			</cfif>
			<cfif isdefined("attributes.org_step_id") and len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.org_step_id#">)
			</cfif>
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
				AND EP.COLLAR_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.collar_type#">)
			</cfif>
			<cfif isdefined("attributes.work_startdate") and len(attributes.work_startdate)>
				AND EP.POSITION_ID IN (SELECT DISTINCT POSITION_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.work_startdate#">)
			</cfif>
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
		ORDER BY
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.is_submitted")>
		row_count=<cfoutput>#get_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>

<cfquery name="get_xml_pos_chng" dbtype="query">
    SELECT PROPERTY_VALUE FROM get_xml_detail WHERE PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_control">
</cfquery>
<cfquery name="get_xml_chng_reason" dbtype="query">
    SELECT PROPERTY_VALUE FROM get_xml_detail WHERE PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_reason_control">
</cfquery>

<script type="text/javascript">
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	
	function hepsi(satir,nesne,baslangic)
	{
		deger=$('#'+nesne);
		if(!baslangic){baslangic=1;}
		for(var i=baslangic;i<=satir;i++)
		{
			nesne_=$('#'+nesne+i);
			nesne_.val(deger.val());
		}
	}
	
	function sil(sy)
	{
		var my_element = $('#row_kontrol_' + sy);
		my_element.val(0);
		var my_element = $('#my_row_' +sy);
		my_element.css("display","none");
	}
	
	function control()
	{	
		deger = $('#record_num').val();
		if (deger > 0)
		{
			for (i=1; i<=deger; i++)
			{
				if ($('#row_kontrol_'+i).val() == 1)
				{
					$('#is_change_pos'+i).val(0);
					if($('#emp_id'+i).val() != "")
					{
						if($('#x_position_change_control').val() == 1 && ($('#old_dep'+i).val() != $('#pos_dep'+i).val() || $('#old_title'+i).val() != $('#pos_title'+i).val() || $('#old_pos_cat'+i).val() != $('#pos_cat'+i).val() || $('#old_func'+i).val() != $('#pos_func'+i).val() || $('#old_collar'+i).val() != $('#pos_collar_type'+i).val() || $('#old_org_step'+i).val() != $('#pos_org_step_id').val()))
						{
							$('#is_change_pos'+i).val(1);
							if($('#pos_in_out_date'+i).val() == "")
							{
								alert(i+". pozisyon bilgilerinde değişiklik yaptınız. Lütfen Görev Değişiklik tarihini giriniz!");
								return false;
							}
							if($('#reason_id'+i).val() == "")
							{
								alert(i+". pozisyon bilgilerinde değişiklik yaptınız. Lütfen Gerekçe seçiniz!");
								return false;
							}
						}
					}
					if(trim($('#pos_cat'+i).val()) == "")
					{
						alert("Pozisyon tipi alanlarını doldurunuz.");
						return false;
					}
					if(trim($('#pos_dep'+i).val()) == "")
					{
						alert("Departman alanlarını doldurunuz.");
						return false;
					}
					if(trim($('#pos_title'+i).val()) == "")
					{
						alert("Ünvan alanlarını doldurunuz.");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	function reset_reason(i)
	{
		if($('#emp_id'+i).val() != "")
		{
			if($('#x_position_change_control').val() == 1 && ($('#old_dep'+i).val() != $('#pos_dep'+i).val() || $('#old_title'+i).val() != $('#pos_title'+i).val() || $('#old_pos_cat'+i).val() != $('#pos_cat'+i).val() || $('#old_func'+i).val() != $('#pos_func'+i).val() || $('#old_collar'+i).val() != $('#pos_collar_type'+i).val() || $('#old_org_step'+i).val() != $('#pos_org_step_id').val()))
			{
				$('#reason_id'+i).val("");
			}
		}
	}
	
	function add_row2()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);
		
		$('#record_num').val(row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+row_count+'" id="row_kontrol_'+row_count+'" value="1"><input type="hidden" name="old_org_step'+row_count+'" id="old_org_step'+row_count+'" value=""><input type="hidden" name="old_collar'+row_count+'" id="old_collar'+row_count+'" value=""><input type="hidden" name="old_func'+row_count+'" id="old_func'+row_count+'" value=""><input type="hidden" name="old_pos_cat'+row_count+'" id="old_pos_cat'+row_count+'" value=""><input type="hidden" name="old_title'+row_count+'" id="old_title'+row_count+'" value=""><input type="hidden" name="old_dep'+row_count+'" id="old_dep'+row_count+'" value=""><input type="hidden" name="is_change_pos' + row_count +'" id="is_change_pos' + row_count +'" value="0"><i class="icon-trash-o btnPointer" onclick="sil(' + row_count + ');"></i>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" id="pos_id_'+row_count+'" name="pos_id_'+row_count+'" style="width:10px;" value=""><input type="text" id="employee' + row_count +'" name="employee' + row_count +'" style="width:120px;" value=""><input type="hidden" name="emp_id' + row_count +'" id="emp_id' + row_count +'" value=""><i class="icon-ellipsis btnPointer" onclick="javascript:opage(' + row_count +');"></i>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" readonly id="branch_name' + row_count +'" name="branch_name' + row_count +'" style="width:120px;" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="pos_cat' + row_count + '" id="pos_cat'+row_count+'" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_position_cat"><option value="#position_cat_id#">#position_cat#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="pos_dep' + row_count + '" id="pos_dep' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_department_all"><option value="#department_id#">#department_head#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="pos_title' + row_count + '" id="pos_title' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_title"><option value="#title_id#">#title#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="pos_func' + row_count + '" id="pos_func' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_func"><option value="#unit_id#">#unit_name#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="pos_org_step_id' + row_count + '" id="pos_org_step_id' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_org_step"><option value="#organization_step_id#">#organization_step_name#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="pos_collar_type' + row_count + '" id="pos_collar_type' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><option value="1"><cf_get_lang no ='980.Mavi Yaka'></option><option value="2"><cf_get_lang no ='981.Beyaz Yaka'></option></select>';
	}
	
	function opage(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_name=employee' + deger + '&field_id=pos_id_' + deger + '&field_emp_id=emp_id' + deger + '&field_branch_name=branch_name' + deger + '&field_pos_cat_id=pos_cat' + deger + '&field_dep_id=pos_dep' + deger + '&field_title_id=pos_title' + deger + '&field_func_id=pos_func' + deger + '&field_org_step_id=pos_org_step_id' + deger + '&call_function=change_old(' + deger +')','list');
	}
	
	function change_old(i)
	{
		$('#old_dep'+i).val($('#pos_dep'+i).val());
		$('#old_title'+i).val($('#pos_title'+i).val());
		$('#old_pos_cat'+i).val($('#pos_cat'+i).val());
		$('#old_func'+i).val($('#pos_func'+i).val());
		$('#old_collar'+i).val($('#pos_collar_type'+i).val());
		$('#old_org_step'+i).val($('#pos_org_step_id'+i).val());
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.popup_update_positions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/form/upd_positions.cfm';
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_update_positions';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/upd_positions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/upd_positions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.popup_update_positions';EMPLOYEE_POSITIONS
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'updPositions';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_POSITIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>
