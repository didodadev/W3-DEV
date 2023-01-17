<cf_get_lang_set module_name="ehesap">
<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add')) or not isdefined("attributes.event")>
	<cfscript>
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
	</cfscript>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="ehesap.list_emp_interruption">
	<cfparam name="attributes.yil" default="#year(now())#">
	<cfparam name="attributes.aylar" default="#Month(now())#">
	<cfparam name="attributes.end_mon" default="#Month(now())#">
	<cfparam name="attributes.odkes" default="">
	<cfparam name="attributes.param" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.position_cat_id" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.inout_statue" default="">
	<cfparam name="attributes.startdate" default="">
	<cfparam name="attributes.finishdate" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<!--- Pozistyon ekleme sayfasının xml ine göre pozisyon alanını kapatıyoruz --->
	<cfquery name="get_position_list_xml" datasource="#dsn#">
		SELECT 
			PROPERTY_VALUE,
			PROPERTY_NAME
		FROM
			FUSEACTION_PROPERTY
		WHERE
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.form_add_position"> AND
			PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_add_position_name">
	</cfquery>
	<cfscript>
		if ((get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0)
			show_position = 1;
		else
			show_position = 0;
		toplam_tutar=0;
		url_str = "";
		url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.branch_id") and len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (len(attributes.odkes))
			url_str = "#url_str#&odkes=#attributes.odkes#";
		if (len(attributes.yil))
			url_str = "#url_str#&yil=#attributes.yil#";
		if (len(attributes.aylar))
			url_str = "#url_str#&aylar=#attributes.aylar#";
		if (len(attributes.collar_type))
			url_str = "#url_str#&collar_type=#attributes.collar_type#";
		if (len(attributes.position_cat_id))
			url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
		if (len(attributes.end_mon))
			url_str = "#url_str#&end_mon=#attributes.end_mon#";
		if (isdefined('attributes.form_submit'))
			url_str = "#url_str#&form_submit=#attributes.form_submit#";
		if (isdefined("attributes.department_id"))
			url_str = "#url_str#&department_id=#attributes.department_id#";
		if (isdefined("attributes.hierarchy"))
			url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
		if (isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_code_name") and len(attributes.expense_code_name))
			url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#&expense_code_name=#attributes.expense_code_name#";
		include "../hr/ehesap/query/get_ssk_offices.cfm";
		if (is_expense_center eq 1) cols = cols+1;
		if (is_in_date eq 1) cols = cols+1;
		if (is_out_date eq 1) cols = cols+1;
		if (show_position eq 1) cols = cols+1;
	</cfscript>
	<cfif len(attributes.startdate) and isdate(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	</cfif>
	<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	</cfif>
	<cfquery name="get_branches" datasource="#DSN#">
		SELECT DISTINCT
			RELATED_COMPANY
		FROM 
			BRANCH
		WHERE 
			BRANCH_ID IS NOT NULL AND
			RELATED_COMPANY IS NOT NULL
		<cfif not session.ep.ehesap>
			AND
			BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
						)
		</cfif>
		ORDER BY
			RELATED_COMPANY
	</cfquery>
	<cfif isdefined('attributes.form_submit')>
		<cfinclude template="../hr/ehesap/query/get_interruptions.cfm">
	<cfelse>
		<cfset get_interruption.recordcount = 0>
	</cfif>
	<cfquery name="get_odeneks" datasource="#dsn#">
		SELECT 
			ODKES_ID,
			COMMENT_PAY
		FROM 
			SETUP_PAYMENT_INTERRUPTION 
		WHERE 
			IS_ODENEK = 0
	</cfquery>
	<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
		SELECT 
	    	POSITION_CAT_ID, 
	        POSITION_CAT, 
	        HIERARCHY, 
	        POSITION_CAT_STATUS
	    FROM 
		    SETUP_POSITION_CAT 
	    ORDER BY 
	    	POSITION_CAT
	</cfquery>
	<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
		<cfquery name="get_departmant" datasource="#dsn#">
            SELECT 
                DEPARTMENT_STATUS, 
                IS_STORE, 
                BRANCH_ID, 
                DEPARTMENT_ID, 
                DEPARTMENT_HEAD, 
                HIERARCHY
            FROM 
                DEPARTMENT 
            WHERE 
                DEPARTMENT_STATUS = 1 
            AND 
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
            AND 
                IS_STORE <> 1 
            ORDER BY 
            	DEPARTMENT_HEAD
        </cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="ehesap.popup_form_add_kesinti_all">
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.func_id" default="">
	<cfparam name="attributes.title_id" default="">
	<cfparam name="attributes.pos_cat_id" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.inout_statue" default="2">
	<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
	<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	
	<cfscript>
		duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
		QueryAddRow(duty_type,8);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#lang_array_main.item[164]#",1);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[194]#',2);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[604]#',3);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[206]#',4);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[232]#',5);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[223]#',6);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[236]#',7);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[253]#',8);
		
		collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
		QueryAddRow(collar_type,2);
		QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
		QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#lang_array.item[1109]#",1);
		QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
		QuerySetCell(collar_type,"COLLAR_TYPE_NAME",'#lang_array.item[1110]#',2);
		
		cmp_pos_cat = createObject("component","hr.cfc.get_position_cat");
		cmp_pos_cat.dsn = dsn;
		all_pos_cats = cmp_pos_cat.get_position_cat();
		cmp_func = createObject("component","hr.cfc.get_functions");
		cmp_func.dsn = dsn;
		get_func = cmp_func.get_function();
		cmp_title = createObject("component","hr.cfc.get_titles");
		cmp_title.dsn = dsn;
		get_title = cmp_title.get_title();
		
		include "../hr/ehesap/query/get_all_branches.cfm";
	</cfscript>
	
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
		<cfquery name="get_poscat_positions" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_NO,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
	            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
				LEFT JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
			WHERE
				1=1
				<cfif len(attributes.collar_type) or len(attributes.pos_cat_id) or len(attributes.title_id) or len(attributes.func_id)>
					AND EP.IS_MASTER = 1	
				</cfif>
				<cfif len(attributes.branch_id)>
					AND B.BRANCH_ID IN (#attributes.branch_id#)
				</cfif>
				<cfif len(attributes.collar_type)>
					AND EP.COLLAR_TYPE IN (#attributes.collar_type#)
				</cfif>
				<cfif len(attributes.pos_cat_id)>
					AND EP.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
				</cfif>
				<cfif len(attributes.title_id)>
					AND EP.TITLE_ID IN (#attributes.title_id#) 
				</cfif>
				<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
					AND EIO.DUTY_TYPE IN (#attributes.duty_type#)
				</cfif>
				<cfif len(attributes.func_id)>
					AND EP.FUNC_ID IN (#attributes.func_id#) 
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
				EMPLOYEE_NAME
		</cfquery>	
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = $('#branch_id').val();
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
		}
		function change_mon(i)
		{
			$('#end_mon').val(i);
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'add_tax')>
		$(document).ready(function() {
			<cfif isdefined("get_poscat_positions") and get_poscat_positions.recordcount>
				row_count=<cfoutput>#get_poscat_positions.recordcount#</cfoutput>;
			<cfelse>
				row_count=0;
			</cfif>
		});
		function hepsi(satir,nesne,baslangic)
		{
			deger = document.getElementById(nesne + '0');
			if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
			{
				if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
				for(var i=baslangic;i<=satir;i++)
				{
					nesne_tarih=eval('document.getElementById( nesne + i )');
					nesne_tarih.value=deger.value;
				}
			}
		}
		function sil(sy)
		{
			<cfif attributes.event is 'add'>
				var my_element=eval("add_ext_salary.row_kontrol_"+sy);
			<cfelse>
				var my_element = document.getElementById('row_kontrol_' + sy);
			</cfif>
			my_element.value=0;
			var my_element=eval("my_row_"+sy);
			my_element.style.display="none";
			<cfif attributes.event is 'add'>
				toplam_hesapla();
			</cfif>
		}
		function goster(show)
		{
			if(show==1)
			{
				show_img_baslik1.style.display='';
				show_img_baslik2.style.display='';
				for(var i=0;i<=row_count;i++)
				{
					satir=eval("show_img"+i);
					satir.style.display='';
				}
			}
			else
			{
				show_img_baslik1.style.display='none';
				show_img_baslik2.style.display='none';
				for(var i=0;i<=row_count;i++)
				{
					satir=eval("document.getElementById('show_img" + i + "')");
					satir.style.display='none';
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
						
			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<i class="icon-trash-o btnPointer" onclick="sil(' + row_count + ');"></i>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif attributes.event is 'add'>
				newCell.innerHTML = '<input type="text" id="empno' + row_count + '" name="empno' + row_count + '" readonly value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.whiteSpace = 'nowrap';
				newCell.innerHTML = '<input type="hidden" name="employee_in_out_id' + row_count +'" id="employee_in_out_id' + row_count +'" value=""><input type="text" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);" name="employee' + row_count +'" id="employee' + row_count +'" value=""><i class="icon-ellipsis btnPointer" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_ext_salary.employee_in_out_id'+row_count+'&field_emp_name=add_ext_salary.employee'+ row_count + '&field_emp_id=add_ext_salary.employee_id'+ row_count + '&field_emp_no=add_ext_salary.empno'+row_count + '&field_branch_and_dep=add_ext_salary.department'+ row_count + '\' ,\'list\');"></i><input type="Hidden" name="odkes_id' + row_count +'" id="odkes_id' + row_count +'" value=""><input type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input  type="hidden"  value="1"  name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'">';
			<cfelse>
				newCell.style.whiteSpace = 'nowrap';
				newCell.innerHTML = '<input type="hidden" name="employee_in_out_id' + row_count +'" id="employee_in_out_id' + row_count +'" value=""><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);" value=""><i class="icon-ellipsis btnPointer" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=employee_in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id'+ row_count +'&field_branch_and_dep=department'+ row_count + '\' ,\'list\');"></i><input type="Hidden" name="tax_exception_id' + row_count +'" id="tax_exception_id' + row_count +'" value=""><input type="hidden" name="exception_type' + row_count +'" id="exception_type' + row_count +'" value=""><input type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input type="hidden"  value="1"  name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif attributes.event is 'add'>
				newCell.innerHTML = '<input type="text" name="department' + row_count +'" id="department' + row_count +'" readonly value="">';
			<cfelse>
				newCell.innerHTML = '<input type="text" name="department' + row_count +'" id="department' + row_count +'" readonly value="">';
			</cfif>
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","show_img" + row_count);
			newCell.innerHTML = '<img border="0" src="/images/b_ok.gif" align="absmiddle">';
			if(document.getElementById('show0').value==0)/* eklerken satırı show0 değerini göre resim gözüksün gözükmesin ayarı*/
			{
				satir=eval("show_img"+row_count);
				satir.style.display='none';
			}
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			<cfif attributes.event is 'add'>
				newCell.innerHTML = '<input type="hidden" name="show' + row_count +'" id="show' + row_count +'" value="0"><input type="text" name="comment_pay' + row_count +'" id="comment_pay' + row_count +'" readonly value=""><i class="icon-ellipsis btnPointer" onClick="send_kesinti('+row_count+');"></i>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="detail' + row_count +'" id="detail' + row_count +'" value="">';
			<cfelse>
				newCell.innerHTML = '<input type="hidden" name="show' + row_count +'" id="show' + row_count +'" value="0"><input type="text" name="comment_pay' + row_count +'" id="comment_pay' + row_count +'" readonly value=""><i class="icon-ellipsis btnPointer" onClick="send_odenek('+row_count+');"></i>';
			</cfif>
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="term' + row_count +'" id="term' + row_count +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif session.ep.period_year eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="start_sal_mon' + row_count +'" id="start_sal_mon' + row_count +'" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="end_sal_mon' + row_count +'" id="end_sal_mon' + row_count +'"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif attributes.event is 'add'>
				newCell.innerHTML = '<input name="amount_pay' + row_count +'" id="amount_pay' + row_count +'" type="text" class="moneybox" value="" onclick="toplam_hesapla();" onchange="toplam_hesapla();" onkeyup="toplam_hesapla();return(FormatCurrency(this,event));">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("noWrap",true) 
				newCell.innerHTML = '<input type="hidden" name="sabit_company_id' + row_count +'" id="sabit_company_id' + row_count + '" value=""> <input type="hidden" name="sabit_consumer_id'+row_count+'" id="sabit_consumer_id'+row_count+'" value=""><input name="sabit_member_name'+row_count+'" id="sabit_member_name'+row_count+'" type="text" value=""><i class="icon-ellipsis btnPointer" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=add_ext_salary.sabit_member_name'+row_count+'&field_consumer=add_ext_salary.sabit_consumer_id'+row_count+'&field_comp_id=add_ext_salary.sabit_company_id'+row_count+'&field_member_name=add_ext_salary.sabit_member_name'+row_count+'\',\'list\')"></i>';
			<cfelse>
				newCell.innerHTML = '<input name="amount_pay' + row_count +'" id="amount_pay' + row_count +'" type="text" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">';
			</cfif>
			
			hepsi(row_count,'show',row_count);
			hepsi(row_count,'comment_pay',row_count);
			hepsi(row_count,'term',row_count);
			hepsi(row_count,'start_sal_mon',row_count);
			hepsi(row_count,'end_sal_mon',row_count);
			hepsi(row_count,'amount_pay',row_count);
			<cfif attributes.event is 'add'>
				hepsi(row_count,'odkes_id',row_count);
				hepsi(row_count,'sabit_company_id',row_count);
				hepsi(row_count,'sabit_consumer_id',row_count);
				hepsi(row_count,'sabit_member_name',row_count);
			<cfelse>
				hepsi(row_count,'tax_exception_id',row_count);
			</cfif>
			odenek_text=eval("document.add_ext_salary.comment_pay"+ row_count);
			odenek_text.focus();
			return true;
		}
		function kontrol()
		{
			$('#record_num').val(row_count);
			if(row_count == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='137.Kesinti'>");
				return false;
			}
			for(var i=1;i<=row_count;i++)
			{
				<cfif attributes.event is 'add'>
				if($('#row_kontrol_'+i).val() == 1 && eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				<cfelse>
				if(eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				</cfif>
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='137.Kesinti'>");
					return false;
				}
			}
			for(var i=1;i<=row_count;i++)
			{
				nesne=eval("document.add_ext_salary.amount_pay"+i);
				nesne.value=filterNum(nesne.value);
			}
			return true;
		}
		function change_mon(id,i)
		{
			$('#'+id).val(i);
		}
		<cfif isdefined("attributes.event") and attributes.event is 'add'>
			function add_row(from_salary,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,ehesap,row_id_,account_code,company_id,fullname,account_name,consumer_id,money,acc_type_id,tax,odkes_id)
			{
				if(row_count == 0)
				{
					alert("<cf_get_lang no='665.Satır Eklemediniz'>!");
					return false;
				}
				if(row_id_ != undefined && row_id_ != '')
				{	
					$('#show'+row_id_).val(show);
					$('#odkes_id'+row_id_).val(odkes_id);
					$('#term'+row_id_).val(term);
					$('#comment_pay'+row_id_).val(comment_pay);
					$('#start_sal_mon'+row_id_).val(start_sal_mon);
					$('#end_sal_mon'+row_id_).val(end_sal_mon);
					$('#amount_pay'+row_id_).val(amount_pay);
					$('#odkes_id'+row_id_).val(odkes_id);
					if(company_id != ''){$('#sabit_company_id'+row_id_).val(company_id);}
					if(consumer_id != ''){$('#sabit_consumer_id'+row_id_).val(consumer_id);}
					if(company_id != '' || consumer_id != ''){$('#sabit_member_name'+row_id_).val(fullname);}
				}
				else
				{
					$('#show0').val(show);
					goster(show);
					hepsi(row_count,'show');
					$('#comment_pay0').val(comment_pay);
					hepsi(row_count,'comment_pay');
					$('#odkes_id0').val(odkes_id);
					hepsi(row_count,'odkes_id');
					$('#term0').val(term);
					hepsi(row_count,'term');
					$('#start_sal_mon0').val(start_sal_mon);
					hepsi(row_count,'start_sal_mon');
					$('#end_sal_mon0').val(end_sal_mon);
					hepsi(row_count,'end_sal_mon');
					$('#amount_pay0').val(amount_pay);
					hepsi(row_count,'amount_pay');
					if(company_id != '')
					{
						$('#sabit_company_id0').val(company_id);
						hepsi(row_count,'sabit_company_id');
					}
					if(consumer_id != '')
					{
						$('#sabit_consumer_id0').val(consumer_id);
						hepsi(row_count,'sabit_consumer_id');
					}
					if(company_id != '' || consumer_id != '')
					{
						$('#sabit_member_name0').val(fullname);
						hepsi(row_count,'sabit_member_name');
					}
				}
			}
			function send_kesinti(row_count)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti&row_id_='+ row_count,'medium');
			}
			function toplam_hesapla()
			{
				var total_amount = 0;
				var sayac = 0;
				for(var i=1;i<=row_count;i++)
				{
					if(eval("add_ext_salary.row_kontrol_"+i).value != 0 && eval("document.add_ext_salary.amount_pay"+i).value != 0)
					{
						nesne_tarih=eval("document.add_ext_salary.amount_pay"+i);
						total_amount += parseFloat(filterNum(nesne_tarih.value));
						sayac++
					}
				}
				$('#total_amount').val(parseFloat(total_amount));
				$('#total_emp').val(sayac);
			}
		<cfelseif isdefined("attributes.event") and attributes.event is 'add_tax'>
			function add_row(tax_exception,sal_year,start_month,finish_month,amount,calc_days,yuzde_sinir,tamamini_ode,is_isveren_,is_ssk_,exception_type,row_id_,tax_exception_id)
			{
				if(row_count == 0)
				{
					alert("<cf_get_lang no='665.Satır Eklemediniz'>!");
					return false;
				}
				if(row_id_ != undefined && row_id_ != '')
				{	
					$('#comment_pay'+row_id_).val(tax_exception);
					$('#term'+row_id_).val(sal_year);
					$('#start_sal_mon'+row_id_).val(start_month);
					$('#end_sal_mon'+row_id_).val(finish_month);
					$('#amount_pay'+row_id_).val(amount);
					$('#tax_exception_id'+row_id_).val(tax_exception_id);
				}
				else
				{
					goster(show);
					hepsi(row_count,'show');
					$('#comment_pay0').val(tax_exception);
					hepsi(row_count,'comment_pay');
					$('#term0').val(sal_year);
					hepsi(row_count,'term');
					$('#start_sal_mon0').val(start_month);
					hepsi(row_count,'start_sal_mon');
					$('#end_sal_mon0').val(finish_month);
					hepsi(row_count,'end_sal_mon');
					$('#amount_pay0').val(amount);
					hepsi(row_count,'amount_pay');
					$('#tax_exception_id0').val(tax_exception_id);
					hepsi(row_count,'tax_exception_id');
				}
			}
			function send_odenek(row_count)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_tax_exception&row_id_='+ row_count,'medium');
			}
		</cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_interruption';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_emp_interruption.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_kesinti_all';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/popup_form_add_kesinti_all.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_kesinti_all.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_interruption';
	
	WOStruct['#attributes.fuseaction#']['add_tax'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_tax']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_tax']['fuseaction'] = 'ehesap.popup_form_add_tax_exception_all';
	WOStruct['#attributes.fuseaction#']['add_tax']['filePath'] = 'hr/ehesap/form/popup_form_add_tax_exception_all.cfm';
	WOStruct['#attributes.fuseaction#']['add_tax']['queryPath'] = 'hr/ehesap/query/add_tax_exception_all.cfm';
	WOStruct['#attributes.fuseaction#']['add_tax']['nextEvent'] = 'ehesap.list_interruption';
	WOStruct['#attributes.fuseaction#']['add_tax']['Identity'] = '#lang_array_main.item[645]# #lang_array.item[71]#';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_payment';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_interruption';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListInterruption';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARYPARAM_GET';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate','item-finishdate']";
</cfscript>
