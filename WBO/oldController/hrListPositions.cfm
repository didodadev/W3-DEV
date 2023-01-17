<cfif (isdefined("attributes.event") and listfind('list,add,upd,list_up_pos,pos_req,pos_content,pos_money,emp_auth_code,copy',attributes.event)) or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="hr">
	<cfif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		<cf_xml_page_edit fuseact="hr.form_add_position">
		<cfinclude template="../hr/query/get_titles.cfm">
		<cfinclude template="../hr/query/get_modules.cfm">
		<cfinclude template="../hr/query/get_position_cats.cfm">
        <cfif attributes.event is 'add'>
            <cfquery name="get_organization_steps" datasource="#dsn#">
                SELECT 
                    ORGANIZATION_STEP_ID,
                    ORGANIZATION_STEP_NAME
                FROM
                    SETUP_ORGANIZATION_STEPS
                ORDER BY
                    ORGANIZATION_STEP_NAME
            </cfquery>
        </cfif>
	</cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.position_cat_id" default="">
	<cfparam name="attributes.unit_id" default="">
	<cfparam name="attributes.title_id" default="">
	<cfparam name="attributes.our_company_id" default="">
	<cfparam name="attributes.organization_step_id" default="">
	<cfparam name="attributes.comp_id" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.status" default="-1">
	<cfparam name="attributes.empty_position" default="1">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	
	<cfscript>
		attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1;
		
		cmp_title = createObject("component","hr.cfc.get_titles");
		cmp_title.dsn = dsn;
		titles = cmp_title.get_title();
		
		cmp_pos_cat = createObject("component","hr.cfc.get_position_cat");
		cmp_pos_cat.dsn = dsn;
		get_position_cats = cmp_pos_cat.get_position_cat();
		
		//Pozisyon ekleme sayfasinin xml ine gore pozisyon alanini kapatiyoruz
		cmp_property = createObject("component","hr.cfc.get_fuseaction_property");
		cmp_property.dsn = dsn;
		get_position_list_xml = cmp_property.get_property(
			our_company_id: session.ep.company_id,
			fuseaction_name: 'hr.form_add_position',
			property_name: 'x_add_position_name'
		);
		if ((get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0)
			show_position = 1;
		else
			show_position = 0;
			
		cmp_process = createObject("component","hr.cfc.get_process_rows");
		cmp_process.dsn = dsn;
		get_process_stage = cmp_process.get_process_type_rows(faction: 'hr.list_positions');
		
		include "../hr/query/get_emp_codes.cfm";
		
		if (not isdefined("attributes.keyword"))
		{
			arama_yapilmali = 1;
			get_positions.recordcount = 0;
		}
		else
		{
			arama_yapilmali = 0;
			cmp_position = createObject("component","hr.cfc.get_positions");
			cmp_position.dsn = dsn;
			get_positions = cmp_position.get_position(
				collar_type: attributes.collar_type,
				process_stage: '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
				empty_position: attributes.empty_position,
				status: attributes.status,
				position_cat_id: attributes.position_cat_id,
				unit_id: attributes.unit_id,
				title_id: attributes.title_id,
				comp_id: attributes.comp_id,
				keyword: attributes.keyword,
				hierarchy: attributes.hierarchy,
				emp_code_list: emp_code_list,
				branch_id: attributes.branch_id,
				department: attributes.department,
				duty_type: attributes.duty_type,
				fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
				database_type: database_type,
				startrow: attributes.startrow,
				maxrows: attributes.maxrows
			);
		}
		
		if (fuseaction contains "popup")
			is_popup = 1;
		else
			is_popup = 0;
			
		cmp_company = createObject("component","hr.cfc.get_our_company");
		cmp_company.dsn = dsn;
		get_our_company = cmp_company.get_company();
		
		cmp_org_step = createObject("component","hr.cfc.get_organization_steps");
		cmp_org_step.dsn = dsn;
		get_organization_steps = cmp_org_step.get_organization_step();
		
		cmp_unit = createObject("component","hr.cfc.get_functions");
		cmp_unit.dsn = dsn;
		get_fonc_units = cmp_unit.get_function();
		
		if (isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all")
		{
			cmp_branch = createObject("component","hr.cfc.get_branches");
			cmp_branch.dsn = dsn;
			get_branch = cmp_branch.get_branch(comp_id: attributes.comp_id);
		}
		
		if (isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all")
		{
			cmp_department = createObject("component","hr.cfc.get_departments");
			cmp_department.dsn = dsn;
			get_department = cmp_department.get_department(branch_id: attributes.branch_id);
		}
		
		duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
		QueryAddRow(duty_type,8);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#lang_array_main.item[164]#",1); //çalışan
		QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[1320]#',2);//işveren vekili
		QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[1321]#',3);//işveren
		QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Sendikalı',4);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Sözleşmeli',5);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Kapsam Dışı',6);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Kısmi İstihdam',7);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'Taşeron',8);
		
		url_str = "";
		if (isdefined("attributes.comp_id") and len(attributes.comp_id))
			url_str = "#url_str#&comp_id=#attributes.comp_id#";
		if (isdefined("attributes.branch_id") and len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.department") and len(attributes.department))
			url_str = "#url_str#&department=#attributes.department#";
		if (isdefined("attributes.unit_id") and len(attributes.unit_id))
			url_str = "#url_str#&unit_id=#attributes.unit_id#";
		if (isdefined("attributes.organization_step_id") and len(attributes.organization_step_id))
			url_str = "#url_str#&organization_step_id=#attributes.organization_step_id#";
		if (isdefined("attributes.process_stage") and len(attributes.process_stage))
			url_str = "#url_str#&process_stage=#attributes.process_stage#";
		if (isdefined("attributes.collar_type") and len(attributes.collar_type))
			url_str = "#url_str#&collar_type=#attributes.collar_type#";
		if (isdefined("attributes.hierarchy") and len(attributes.hierarchy))
			url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
		if (isdefined("attributes.keyword"))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.status") and len(attributes.status))
			url_str = "#url_str#&status=#attributes.status#";
		if (isdefined("attributes.empty_position") and len(attributes.empty_position))
			url_str = "#url_str#&empty_position=#attributes.empty_position#";
		if (isdefined("attributes.position_cat_id") and len(attributes.position_cat_id))
			url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
		if (isdefined("attributes.our_company_id") and len(attributes.our_company_id))
			url_str = "#url_str#&our_company_id=#attributes.our_company_id#";
		if (isdefined("attributes.title_id") and len(attributes.title_id))
			url_str = "#url_str#&title_id=#attributes.title_id#";
		if (isdefined("attributes.duty_type") and len(attributes.duty_type))
			url_str = "#url_str#&duty_type=#attributes.duty_type#";
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_positions.query_count#'>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfinclude template="../hr/query/get_moneys.cfm">
	<cfinclude template="../hr/query/get_user_groups.cfm">
	<cfif fuseaction contains "popup">
		<cfset is_popup = 1 >
	<cfelse>
		<cfset is_popup = 0 >
	</cfif>
	<cfif not get_user_groups.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='982.Pozisyon Ekleyebileceğiniz Standart Bir Yetki Grubu Tanımlaması veya Gecerli Kullanıcı Grubu Bulunmamaktadır'>!");
			history.back();
		</script>	
		<cfabort>
	</cfif>
	<cfquery name="get_units" datasource="#DSN#">
        SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif not isdefined("attributes.position_id") or (isdefined("attributes.position_id") and not len(attributes.position_id))>
		<script type="text/javascript">
			alert("<cf_get_lang no='994.Eksik Parametre'> !");	
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfinclude template="../hr/query/get_position_detail.cfm">
	<cfif not get_position_detail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='996.Böyle bir pozisyon yok veya Yetki dışı erişim denemesi yaptınız'> !");
			history.back();
		</script>
		<cfexit method="exittemplate">
	</cfif>
	<cfset attributes.position_cat_id = get_position_detail.position_cat_id>
	<cfinclude template="../hr/query/get_position_cat.cfm">
	<cfquery name="CHECK" datasource="#dsn#">
		SELECT 
			SB_ID,
			POSITION_CODE 
		FROM 
			EMPLOYEE_POSITIONS_STANDBY 
		WHERE 
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_detail.position_code#">
	</cfquery>
	<cfquery name="DENIED_PAGE" datasource="#DSN#" maxrows="1">
		SELECT 
			POSITION_CODE 
		FROM
			EMPLOYEE_POSITIONS_DENIED
		WHERE 
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_detail.position_code#">
	</cfquery>
	<cfquery name="GET_LAST_HIST_ROW" datasource="#DSN#" maxrows="1">
		SELECT
			START_DATE,
			FINISH_DATE
		FROM
			EMPLOYEE_POSITIONS_HISTORY
		WHERE
			POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
		ORDER BY
			HISTORY_ID DESC
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'hist'>
	<cfinclude template="../hr/query/get_position_history.cfm">
	<cfset title_list = "">
<cfelseif isdefined("attributes.event") and attributes.event is 'list_up_pos'>
	<cfquery datasource="#dsn#" name="get_alt_pos_cat">
		SELECT 
			EC.RELATED_POS_CAT_ID AS CAT_ID,
			EC.STEP_NO AS STEP_NO,
			SPC.POSITION_CAT AS POSITION_NAME
		FROM
			EMPLOYEE_CAREER EC
			INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID=EC.RELATED_POS_CAT_ID
		WHERE
			EC.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			AND STATE=0
		ORDER BY STEP_NO
	</cfquery>
	<cfquery datasource="#dsn#" name="get_ust_pos_cat">
		SELECT 
			EC.RELATED_POS_CAT_ID AS CAT_ID,
			EC.STEP_NO AS STEP_NO,
			SPC.POSITION_CAT AS POSITION_NAME
		FROM
			EMPLOYEE_CAREER EC
			INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID=EC.RELATED_POS_CAT_ID
		WHERE
			EC.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			AND STATE=1
		ORDER BY STEP_NO
	</cfquery>
	<cfquery name="get_position_cat_name" datasource="#dsn#">
        SELECT 
            POSITION_CAT 
        FROM
            SETUP_POSITION_CAT
        WHERE
            POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'pos_req'>
	<cfquery name="GET_POS_REQ" datasource="#DSN#">
		SELECT 
			* 
		FROM 
			POSITION_REQUIREMENTS 
		WHERE 
			POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
	</cfquery>
	<cfset old_reqs = valuelist(get_pos_req.req_type_id)>
	<cfquery name="GET_POS_CAT_REQ" datasource="#DSN#">
		SELECT 
			* 
		FROM 
			POSITION_REQUIREMENTS 
		WHERE 
			POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
	<cfloop query="GET_POS_CAT_REQ">
		<cfset OLD_REQS = ListAppend(OLD_REQS,#GET_POS_CAT_REQ.REQ_TYPE_ID#,',')>
	</cfloop>
	<cfquery name="get_pos" datasource="#dsn#">
		SELECT
			POSITION_NAME,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'pos_content'>
	<cfinclude template="../hr/query/get_positioncat_content.cfm">
	<cfinclude template="../hr/query/get_position_content.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'pos_money'>
	<cfinclude template="../hr/query/get_position_detail.cfm">
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfquery name="GET_POSITION_COST" datasource="#dsn#">
		SELECT * FROM EMPLOYEE_POSITIONS_COST WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'emp_auth_code'>
	<cfinclude template="../hr/query/get_emp_authority_codes.cfm">
	<cfquery dbtype="query" name="GET_EMP_AUTHORITY_CODES_1">
        SELECT * FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 3
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = document.search.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
				myList.appendChild(txtFld);
			}
		}
		function showBranch(comp_id)	
		{
			var comp_id = document.search.comp_id.value;
			if (comp_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
				AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
			}
			else {document.search.branch_id.value = "";document.search.department.value ="";}
			//departman bilgileri sıfırla
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function dsp_button()
		{
			buton.style.display='';
		}
		function open_position_norm()
		{
			mk = document.getElementById('POSITION_CAT_ID').selectedIndex;
			if(document.add_pos.POSITION_CAT_ID[mk].value == "")
				alert("<cf_get_lang no ='1238.Pozisyon Tipi Seçmelisiniz'>!");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cat_norms&position_cat_id=' + list_getat(document.add_pos.POSITION_CAT_ID[mk].value,1,';'),'horizantal');
		}
		function control()
		{
			if ($('#department_id').val() == "")
			{
				alert("<cf_get_lang_main no='160.Departman'> !");
				return false;
			}
			if (document.getElementById('title_id').selectedIndex == 0)
			{
				alert("<cf_get_lang_main no='159.Ünvan'> !");
				return false;
			}
			if (document.getElementById('POSITION_CAT_ID').selectedIndex == 0)
			{
				alert("<cf_get_lang_main no='1592.Pozisyon Tipi'> !");
				return false;
			}
			if($('#x_position_change_control').val() == 1 && $('#employee_id').val() != "" && $('#employee').val() != "" && $('#position_in_out_date').val() == "") //görev değişikliği kontrolleri yapılsın evet ise
			{
				alert("Lütfen Görev Başlangıç Tarihini Giriniz!");
				return false;
			}
			return process_cat_control();
			
			<cfif x_add_position_name eq 1>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_simular_employees&POSITION_CAT_ID=' + list_getat(document.getElementById('POSITION_CAT_ID').value,1,';') + '&POSITION_NAME=' + $('#POSITION_NAME').val() + '&DEPARTMENT_ID=' + $('#department_id').val() + '&TITLE_ID=' + $('#title_id').val(),'medium');
			<cfelse>
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_simular_employees&POSITION_CAT_ID=' + list_getat(document.getElementById('POSITION_CAT_ID').value,1,';') + '&POSITION_NAME=&DEPARTMENT_ID=' + $('#department_id').val() + '&TITLE_ID=' + $('#title_id').val(),'medium');
			</cfif>
		}
		function change_fields(){
			var dizi = document.add_pos.POSITION_CAT_ID.value.split(';');
			if(dizi[0] != '')
			{
				var pos_cat_det = wrk_query('SELECT TITLE_ID, FUNC_ID, ORGANIZATION_STEP_ID, COLLAR_TYPE FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = '+dizi[0],'dsn');
				if (pos_cat_det){
					if (pos_cat_det.TITLE_ID != '')
						document.add_pos.title_id.value = pos_cat_det.TITLE_ID;
					if (pos_cat_det.ORGANIZATION_STEP_ID != '')
						document.add_pos.ORGANIZATION_STEP_ID.value = pos_cat_det.ORGANIZATION_STEP_ID;
					if (pos_cat_det.FUNC_ID != '')
						document.add_pos.func_id.value = pos_cat_det.FUNC_ID;
					if (pos_cat_det.COLLAR_TYPE != '')
						document.add_pos.collar_type.value = pos_cat_det.COLLAR_TYPE;
				}
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function chk()
		{
			$('#is_change_position').val(0);
			if($('#old_emp_id').val() == 0 && $('#employee_id').val() != "" && $('#x_position_change_control').val() == 1)
			{
				$('#is_change_position').val(1);
				if($('#position_in_out_date').val() == "")
				{
					alert("Göreve başlama tarihini giriniz!");
					return false;
				}
				if($('#reason_id').val() == "")
				{
					alert("Gerekçe seçiniz!");
					return false;
				}
			}
			if($('#employee_id').val() != "" && $('#employee').val() == "" && $('#x_position_change_control').val() == 1)
			{
				$('#is_change_position').val(1);
				if($('#position_in_out_date').val() == "")
				{
					alert("Pozisyonu boşaltıyorsunuz.Lütfen Görev Bitiş tarihini giriniz");
					return false;
				}
				if($('#reason_id').val() == "")
				{
					alert("Pozisyonu boşaltıyorsunuz.Lütfen Gerekçe seçiniz.");
					return false;
				}
			}
			if($('#employee_id').val() != "")
			{
				if($('#x_position_change_control').val() == 1)
				{
					new_pos_cat_id = $('#POSITION_CAT_ID').val().substring(0,$('#POSITION_CAT_ID').val().indexOf(';'));
					if(<cfif x_add_position_name eq 1>($('#old_position_name') != undefined && $('#old_position_name').val() != $('#POSITION_NAME').val()) || </cfif>$('#old_department_id').val() != $('#department_id').val() || $('#old_title_id').val() != $('#title_id').val() || $('#old_position_cat_id').val() != new_pos_cat_id || $('#old_func_id').val() != $('#func_id').val() || $('#old_collar_type').val() != $('#collar_type').val() || $('#old_organization_step_id').val() != $('#organization_step_id').val())
					{
						$('#is_change_position').val(1);
						if($('#position_in_out_date').val() == "")
						{
							alert("Pozisyon bilgilerinde değişiklik yaptınız.Lütfen Görev Değişiklik tarihini giriniz");
							return false;
						}
						if($('#reason_id').val() == "")
						{
							alert("Pozisyon bilgilerinde değişiklik yaptınız.Lütfen Gerekçe seçiniz.");
							return false;
						}
					}
				}
				<cfif x_upper_pos_hist eq 1>
					if ($('#old_upper_position_code').val() != $('#upper_position_code').val() || $('#old_upper_position').val() != $('#upper_position').val() || $('#old_upper_position_code2').val() != $('#upper_position_code2').val() || $('#old_upper_position2').val() != $('#upper_position2').val())
					{
						$('#is_change_position').val(1);
						if($('#position_in_out_date').val() == "")
						{
							alert("Pozisyon bilgilerinde değişiklik yaptınız.Lütfen Görev Değişiklik tarihini giriniz");
							return false;
						}
						if($('#reason_id').val() == "")
						{
							alert("Pozisyon bilgilerinde değişiklik yaptınız.Lütfen Gerekçe seçiniz.");
							return false;
						}
					}
				</cfif>
			}
			if($('#employee').val()=="")	
			{
				$('#employee_id').val("");
			}
			if(trim($('#title_id').val()) == "")
			{
				alert("<cf_get_lang_main no='159.Ünvan'>");
				return false;
			}
			return process_cat_control();
		}
		function reset_reason()
		{
			if($('#old_emp_id').val() == 0 && $('#employee_id').val() != "" && $('#x_position_change_control').val() == 1)
			{ 
				$('#reason_id').val("");
			}
			if($('#employee_id').val() != "" && $('#employee').val()=="" && $('#x_position_change_control').val() == 1)
			{
				$('#reason_id').val("");
			}
			if($('#employee_id').val() != "")
			{
				if($('#x_position_change_control').val() == 1)
				{
					new_pos_cat_id = $('#POSITION_CAT_ID').val().substring(0,$('#POSITION_CAT_ID').val().indexOf(';'));
					if(<cfif x_add_position_name eq 1>($('#old_position_name') != undefined && $('#old_position_name').val() != $('#POSITION_NAME').val()) || </cfif>$('#old_department_id').val() != $('#department_id').val() || $('#old_title_id').val() != $('#title_id').val() || $('#old_position_cat_id').val() != new_pos_cat_id || $('#old_func_id').val() != $('#func_id').val() || $('#old_collar_type').val() != $('#collar_type').val() || $('#old_organization_step_id').val() != $('#organization_step_id').val())
					{
						$('reason_id').val("");
					}
				}
				<cfif x_upper_pos_hist eq 1>
					if ($('#old_upper_position_code').val() != $('#upper_position_code').val() || $('#old_upper_position').val() != $('#upper_position').val() || $('#old_upper_position_code2').val() != $('#upper_position_code2').val() || $('#old_upper_position2').val() != $('#upper_position2').val())
					{
						$('#reason_id').val("");
					}
				</cfif>
			}
		}
		function reset_level()
		{
			if (td_group.style.display == 'none')
				document.getElementById('GROUP_ID').selectedIndex = 0;
		}
		
		function set_conf()
		{
			alert("<cf_get_lang_main no='1287.Onaylandı'> ");
			$('#confirmed').val(1);
			$('#rejected').val("");
			$('#change').val(1);
			upd_pos.submit();
		}
		function set_rej()
		{
			alert("<cf_get_lang_main no='205.Reddedildi'>");
			$('#confirmed').val("");
			$('#rejected').val(1);
			$('#change').val(1);
			upd_pos.submit();
		}
		function open_position_norm()
		{
			mk = document.upd_pos.POSITION_CAT_ID.selectedIndex;
			if(document.upd_pos.POSITION_CAT_ID[mk].value == "")
				alert("<cf_get_lang no ='1238.Pozisyon Tipi Seçmelisiniz'>!");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cat_norms&position_cat_id=' + list_getat(document.upd_pos.POSITION_CAT_ID[mk].value,1,';'),'horizantal');
		}
		function change_fields(){
			var dizi = document.upd_pos.POSITION_CAT_ID.value.split(';');
			if(dizi[0] != '')
			{
				var pos_cat_det = wrk_query('SELECT TITLE_ID, FUNC_ID, ORGANIZATION_STEP_ID, COLLAR_TYPE FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = '+dizi[0],'dsn');
				if (pos_cat_det){
					if (pos_cat_det.TITLE_ID != '')
						document.upd_pos.title_id.value = pos_cat_det.TITLE_ID;
					if (pos_cat_det.ORGANIZATION_STEP_ID != '')
						document.upd_pos.ORGANIZATION_STEP_ID.value = pos_cat_det.ORGANIZATION_STEP_ID;
					if (pos_cat_det.FUNC_ID != '')
						document.upd_pos.func_id.value = pos_cat_det.FUNC_ID;
					if (pos_cat_det.COLLAR_TYPE != '')
						document.upd_pos.collar_type.value = pos_cat_det.COLLAR_TYPE;
				}
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'pos_req'>
		row_count=0;
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
			document.add_pos_requirement.record_num.value=row_count;			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="req_type_id_' + row_count + '"><input type="text" name="req_type_' + row_count + '" id="req_type' + row_count + '" style="width:170px;"  class="formfieldright"><a onclick="javascript:opage(' + row_count +');"><i class="icon-pluss"></i></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="coefficient_' + row_count + '" id="coefficient' + row_count + '" style="width:50px;" onkeyup="isNumber(this);" maxlength="3" onblur="isNumber(this);"  value="" class="formfieldright">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}		
	
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_pos_req_types&field_id=add_pos_requirement.req_type_id_' + deger + '&field_name=add_pos_requirement.req_type_' + deger,'list');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'pos_money'>
		row_count=<cfoutput>#get_position_cost.recordcount#</cfoutput>;
		function sil(sy)
		{
			var my_element=eval("upd_pos_money.row_kontrol"+sy);
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
			newRow = document.getElementById("table1_").insertRow(document.getElementById("table1_").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.upd_pos_money.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="icon-trash-o"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="detail' + row_count +'" style="width:180px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="period' + row_count +'" style="width:70px;" onChange="add_toplam();"><option value="1">Aylık</option><option value="2">Yıllık</option></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input name="rakam' + row_count +'" type="Text"  style="width:100px;" class="moneybox"  value="0" onBlur="add_toplam();" onkeyup="return(FormatCurrency(this,event));">';
		}
		function add_toplam()
		{
			toplam_deger_aylik = 0;
			toplam_deger_yillik = 0;
			for (var p=1;p<=row_count;p++)
			{
				alan_row_kontrol = eval('upd_pos_money.row_kontrol'+p);
				alan_period = eval('upd_pos_money.period'+p);
				alan_rakam = eval('upd_pos_money.rakam'+p);
				
				if( alan_rakam.value == "") { alan_rakam.value = 0; }
				alan_rakam.value = filterNum(alan_rakam.value);
				if(alan_row_kontrol.value == 1)
				{
					if(alan_period.value == 1)
					{
						toplam_deger_aylik = toplam_deger_aylik + parseFloat(alan_rakam.value);
						toplam_deger_yillik = toplam_deger_yillik + (parseFloat(alan_rakam.value) * 12);
					}
					else
					{
						toplam_deger_aylik = toplam_deger_aylik + (parseFloat(alan_rakam.value)/12);
						toplam_deger_yillik = toplam_deger_yillik + parseFloat(alan_rakam.value);
					}
				}
				alan_rakam.value = commaSplit(alan_rakam.value);
			}
			upd_pos_money.ON_MALIYET.value = commaSplit(toplam_deger_aylik);
			upd_pos_money.ON_MALIYET_YIL.value = commaSplit(toplam_deger_yillik);
		}
		function UnformatFields()
		{ 	
			if(upd_pos_money.ON_HOUR.value.length < 1)
			{
				alert("<cf_get_lang no='825.Aylık Çalışma Saati Girmelisiniz'>");
				return false;
			}
			upd_pos_money.ON_MALIYET.value=filterNum(upd_pos_money.ON_MALIYET.value);
			upd_pos_money.ON_MALIYET_YIL.value=filterNum(upd_pos_money.ON_MALIYET_YIL.value);
			upd_pos_money.ONGR_UCRET.value=filterNum(upd_pos_money.ONGR_UCRET.value);
			for (var p=1;p<=row_count;p++)
			{	
				alan_row_kontrol = eval('upd_pos_money.row_kontrol'+p);
				alan_rakam = eval('upd_pos_money.rakam'+p);
				if(alan_row_kontrol.value == 1)
				{
					alan_rakam.value=filterNum(alan_rakam.value);
				}
			}
			document.upd_pos_money.ON_HOUR.value = filterNum(document.upd_pos_money.ON_HOUR.value);
			document.upd_pos_money.ON_HOUR_DAILY.value = filterNum(document.upd_pos_money.ON_HOUR_DAILY.value);
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_positions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_positions.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_position';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_position.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_position.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_positions&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_position';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_position.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_position.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_positions&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'position_id=##attributes.position_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_position_detail.position_code##';
	WOStruct['#attributes.fuseaction#']['upd']['pageParameters'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['pageParameters']['paramList'] = 'Unvanlar:SETUP_TITLE:TITLE;Kredi Kartı:SETUP_CREDITCARD:CARDCAT';
	
	WOStruct['#attributes.fuseaction#']['hist'] = structNew();
	WOStruct['#attributes.fuseaction#']['hist']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['hist']['fuseaction'] = 'hr.popup_position_history';
	WOStruct['#attributes.fuseaction#']['hist']['filePath'] = 'hr/display/popup_position_history.cfm';
	
	WOStruct['#attributes.fuseaction#']['list_up_pos'] = structNew();
	WOStruct['#attributes.fuseaction#']['list_up_pos']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list_up_pos']['fuseaction'] = 'hr.popup_list_up_position';
	WOStruct['#attributes.fuseaction#']['list_up_pos']['filePath'] = 'hr/display/list_up_position.cfm';
	
	WOStruct['#attributes.fuseaction#']['pos_req'] = structNew();
	WOStruct['#attributes.fuseaction#']['pos_req']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['pos_req']['fuseaction'] = 'hr.popup_upd_pos_requirement';
	WOStruct['#attributes.fuseaction#']['pos_req']['filePath'] = 'hr/form/upd_positionrequirement.cfm';
	WOStruct['#attributes.fuseaction#']['pos_req']['queryPath'] = 'hr/query/add_position_requirement.cfm';
	WOStruct['#attributes.fuseaction#']['pos_req']['nextEvent'] = 'hr.list_positions&event=upd';
	WOStruct['#attributes.fuseaction#']['pos_req']['parameters'] = 'position_id=##attributes.position_id##';
	WOStruct['#attributes.fuseaction#']['pos_req']['Identity'] = 'position_id=##attributes.position_id##';
	
	WOStruct['#attributes.fuseaction#']['pos_content'] = structNew();
	WOStruct['#attributes.fuseaction#']['pos_content']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['pos_content']['fuseaction'] = 'hr.popup_list_position_content';
	WOStruct['#attributes.fuseaction#']['pos_content']['filePath'] = 'hr/display/list_position_content.cfm';
	
	WOStruct['#attributes.fuseaction#']['pos_money'] = structNew();
	WOStruct['#attributes.fuseaction#']['pos_money']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['pos_money']['fuseaction'] = 'hr.popup_position_money';
	WOStruct['#attributes.fuseaction#']['pos_money']['filePath'] = 'hr/form/upd_pos_money.cfm';
	WOStruct['#attributes.fuseaction#']['pos_money']['queryPath'] = 'hr/query/upd_position_money.cfm';
	WOStruct['#attributes.fuseaction#']['pos_money']['nextEvent'] = 'hr.list_positions&event=upd';
	WOStruct['#attributes.fuseaction#']['pos_money']['parameters'] = 'position_id=##attributes.position_id##';
	WOStruct['#attributes.fuseaction#']['pos_money']['Identity'] = 'position_id=##attributes.position_id##';
	
	WOStruct['#attributes.fuseaction#']['emp_auth_code'] = structNew();
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['fuseaction'] = 'hr.popup_form_add_emp_authority_codes';
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['filePath'] = 'hr/form/add_emp_authority_codes.cfm';
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['queryPath'] = 'hr/query/add_emp_authority_codes.cfm';
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['nextEvent'] = 'hr.list_positions&event=upd';
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['parameters'] = 'position_id=##attributes.position_id##';
	WOStruct['#attributes.fuseaction#']['emp_auth_code']['Identity'] = 'position_id=##attributes.position_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['copy'] = structNew();
		WOStruct['#attributes.fuseaction#']['copy']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'hr.emptypopup_position_copy';
		WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'hr/query/position_copy.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'hr/query/position_copy.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'hr.list_positions&event=upd';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=hr.form_upd_position&action_name=position_id&action_id=#attributes.position_id#','list');";
		i = 1;
		if (not listfindnocase(denied_pages,'hr.popup_position_history'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_positions&event=hist&position_id=#get_position_detail.position_id#','page');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_list_up_position'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[891]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_positions&event=list_up_pos&position_id=#get_position_detail.position_id#&position_cat_id=#get_position_detail.position_cat_id#','medium');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_upd_pos_requirement'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[420]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_positions&event=pos_req&position_id=#get_position_detail.position_id#&position_cat_id=#get_position_detail.position_cat_id#','medium');";
			i = i + 1;
		}
		if (session.ep.admin eq 1 or get_module_power_user(3))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[23]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_positions_poweruser&employee_id=#get_position_detail.EMPLOYEE_ID#&position_id=#get_position_detail.position_id#&employee_name=#get_position_detail.employee_name# #get_position_detail.employee_surname#','wwide1');";
			i = i + 1;
		}
		if (not denied_page.recordcount and get_module_user(7))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[50]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=settings.user_denied_emp&cont=#get_position_detail.position_code#";
			i = i + 1;
		}
		else if (get_module_user(7))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[50]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=settings.upd_user_denied_emp&pos_code=#get_position_detail.position_code#";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_list_position_content'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[84]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_positions&event=pos_content&position_id=#get_position_detail.position_id#&position_cat_id=#get_position_detail.position_cat_id#','medium');";
			i = i + 1;
		}
		if (get_module_user(48) and (not listfindnocase(denied_pages,'hr.popup_position_money')))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[846]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_positions&event=pos_money&position_id=#get_position_detail.position_id#','medium');";
			i = i + 1;
		}
		if (get_position_detail.position_code is check.position_code)
		{
			if (not listfindnocase(denied_pages,'hr.list_puantaj'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[81]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.form_upd_standby&sb_id=#check.sb_id#";
				i = i + 1;
			}
		}
		else
		{
			if (not listfindnocase(denied_pages,'hr.form_add_standby'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[81]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.form_add_standby&position_id=#attributes.position_id#";
				i = i + 1;
			}
		}
		if (session.ep.ehesap and not listfindnocase(denied_pages, 'hr.popup_form_add_emp_authority_codes'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[910]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_positions&event=emp_auth_code&position_id=#get_position_detail.position_id#','medium');";
			i = i + 1;
		}
		if (get_position_detail.employee_id neq 0 and len(get_position_detail.employee_id) and get_module_user(48))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'Çalışan Giriş Çıkışları';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#get_position_detail.employee_id#','list');";
			i = i + 1;
		}
		if (get_position_detail.employee_id neq 0 and len(get_position_detail.employee_id) and not listfindnocase(denied_pages,'hr.form_add_quiz'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[164]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_position_detail.employee_id#";
			i = i + 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_positions&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=hr.list_positions&event=copy&position_id=#get_position_detail.position_id#&position_code=#get_position_detail.position_code#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.position_id#&print_type=185','page','workcube_print');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'pos_req')
	{
		if ((get_pos_cat_req.recordcount or get_pos_req.recordcount) and (not listfindnocase(denied_pages,'hr.popup_pos_fit_employees')))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['pos_req'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['pos_req']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['pos_req']['menus'][0]['text'] = 'Yeterliliklere Uygun Çalışanlar';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['pos_req']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_pos_fit_employees&position_id=#attributes.position_id#','medium');";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListPositions';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_POSITIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2','item3','item11','item12','item13']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>