<cf_get_lang_set module_name="ehesap">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="ehesap.list_ext_worktimes">
	<cfparam name="attributes.date1" default="01/#Month(now())#/#year(now())#">
	<cfparam name="attributes.date2" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),'dd/mm/yyyy')#">
	<cfparam name="attributes.param" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.related_company" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.day_type" default="">
	<cfparam name="attributes.pdks_status" default="">
	<cfparam name="attributes.period" default="#year(now())#">
	
	<!--- sorgu sirayi bozmayin  --->
	<cf_date tarih='attributes.date1'>
	<cf_date tarih='attributes.date2'>
	<cfscript>
		include "../hr/ehesap/query/get_our_comp_and_branchs.cfm";
		if (isdefined('attributes.form_submit'))
		{
			if (is_extwork_type eq 1)
				include "../hr/ehesap/query/get_ext_worktimes.cfm";
			else
				include "../hr/ehesap/query/get_ext_worktimes2.cfm";
		}
		else
			get_ext_worktimes.recordcount = 0;
			
		url_str = "";
		url_str="&keyword=#attributes.keyword#";
		if (IsDefined('attributes.day_type') and len(attributes.day_type))
			url_str="#url_str#&day_type=#attributes.day_type#";
		if (IsDefined('attributes.related_company') and len(attributes.related_company))
			url_str="#url_str#&related_company=#attributes.related_company#";
		url_str="#url_str#&pdks_status=#attributes.pdks_status#";
		if (IsDefined('attributes.form_submit') and len(attributes.form_submit))
			url_str="#url_str#&form_submit=#attributes.form_submit#";
		if (IsDefined('attributes.branch_id') and len(attributes.branch_id))
			url_str="#url_str#&branch_id=#attributes.branch_id#";
		if (IsDefined('attributes.department') and len(attributes.department))
			url_str="#url_str#&department=#attributes.department#";
		if (IsDefined('attributes.period') and len(attributes.period))
			url_str="#url_str#&period=#attributes.period#";
		if (IsDefined('attributes.mon') and len(attributes.mon))
			url_str="#url_str#&mon=#attributes.mon#";
		if (IsDefined('attributes.end_mon') and len(attributes.end_mon))
			url_str="#url_str#&end_mon=#attributes.end_mon#";
		if (is_extwork_type eq 1)
		{
			attributes.date1=dateformat(attributes.date1,'dd/mm/yyyy');
			attributes.date2=dateformat(attributes.date2,'dd/mm/yyyy');
			url_str="#url_str#&date1=#attributes.date1#";
			url_str="#url_str#&date2=#attributes.date2#";
		}
		
		mesai_farki = 0;
		aylik_maas_birim = 0;
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		
		if (get_ext_worktimes.recordcount)
		{
			sayfa_dakika = 0;
			sayfa_tutar = 0;
			sayfa_tutar_planlanan = 0;
			overtime_value_0_total = 0;
			overtime_value_1_total = 0;
			overtime_value_2_total = 0;
			overtime_value_3_total = 0;
		}
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_ext_worktimes.recordcount#">
	<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
		<cfquery name="get_departmant" datasource="#dsn#">
			SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
		</cfquery>
	</cfif>
	<cfquery name="get_our_company_hours" datasource="#dsn#">
		SELECT SSK_MONTHLY_WORK_HOURS SSK_AYLIK_MAAS,DAILY_WORK_HOURS AS GUNLUK_SAAT FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfif isDefined("attributes.employee_id") and isdefined("attributes.in_out_id")>
		<cfinclude template="../hr/ehesap/query/get_hr_name.cfm">
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../hr/ehesap/query/get_employees_overtime.cfm">
<cfelseif isdefined("attributes.event") and (attributes.event is 'add_ext' or attributes.event is 'upd_ext')>
	<cfif attributes.event is 'upd_ext'>
		<cfinclude template="../hr/ehesap/query/get_ext_worktime.cfm">
	</cfif>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add_all' or attributes.event is 'add_over')>
	<cfquery name="ALL_BRANCHES" datasource="#DSN#">
		SELECT 
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_ID
		FROM
			BRANCH
			INNER JOIN DEPARTMENT D ON D.BRANCH_ID = BRANCH.BRANCH_ID
		WHERE
			BRANCH.SSK_NO IS NOT NULL AND
			BRANCH.SSK_OFFICE IS NOT NULL AND
			BRANCH.SSK_BRANCH IS NOT NULL AND
			BRANCH.SSK_NO IS NOT NULL AND
			BRANCH.SSK_OFFICE IS NOT NULL AND
			BRANCH.SSK_BRANCH IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH.BRANCH_ID IN 
			(
	            SELECT
	                BRANCH_ID
	            FROM
	                EMPLOYEE_POSITION_BRANCHES
	            WHERE
	                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			)
		</cfif>
		ORDER BY
			BRANCH.BRANCH_NAME
	</cfquery>
	
	<cfif isdefined("attributes.department_id")>
		<cfquery name="get_department_positions" datasource="#DSN#">
			SELECT
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_ID,
				EIO.IN_OUT_ID,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
					INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
				</cfif>
			WHERE
				<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
					EP.IS_MASTER = 1 AND
					EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"> AND
				</cfif>
				D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND
				EIO.FINISH_DATE IS NULL
			ORDER BY
				E.EMPLOYEE_NAME
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
		
		function FazlaMesaiOnay()
		{
			var is_selected=0;
			if(document.getElementsByName('row_demand_accept').length > 0){
				var id_list="";
				if(document.getElementsByName('row_demand_accept').length ==1){
					if(document.getElementById('row_demand_accept').checked==true){
						is_selected=1;
						id_list+=document.ext_worktimes_form.row_demand_accept.value+',';
					}
				} else {
					for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
						if(document.ext_worktimes_form.row_demand_accept[i].checked==true){ 
							id_list+=document.ext_worktimes_form.row_demand_accept[i].value+',';
							is_selected=1;
						}
					}
				}
			}
			if(is_selected==1)
			{
				if(list_len(id_list,',') > 1)
				{
					id_list = id_list.substr(0,id_list.length-1);
					document.getElementById('id_list').value=id_list;
					document.getElementById('ext_worktime_app').value=1;
					ext_worktime_app_ = document.getElementById('ext_worktime_app').value;
					if(confirm("<cf_get_lang_main no='123.Kaydetmek İstediğinizden Emin Misiniz?'> ?"))
					{
						ext_worktimes_form.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_app_ext_worktimes&fsactn=#attributes.fuseaction##url_str#</cfoutput>&id_list='+document.getElementById('id_list').value;
						ext_worktimes_form.submit();
					}
				}
			} 
			else 
			{
				alert("<cf_get_lang dictionary_id='54563.En az bir satır seçmelisiniz'>.");
				return false;
			}
		}
		
		function FazlaMesaiSil()
		{
			var is_selected=0;
			if(document.getElementsByName('row_demand_accept').length > 0){
				var id_list="";
				if(document.getElementsByName('row_demand_accept').length ==1){
					if(document.getElementById('row_demand_accept').checked==true){
						is_selected=1;
						id_list+=document.ext_worktimes_form.row_demand_accept.value+',';
					}
				} else {
					for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
						if(document.ext_worktimes_form.row_demand_accept[i].checked==true){ 
							id_list+=document.ext_worktimes_form.row_demand_accept[i].value+',';
							is_selected=1;	
						}
					}
				}
			}
			if(is_selected==1)
			{
				if(list_len(id_list,',') > 1)
				{
					id_list = id_list.substr(0,id_list.length-1);
					document.getElementById('id_list').value=id_list;
					document.getElementById('ext_worktime_app').value=1;
					ext_worktime_app_ = document.getElementById('ext_worktime_app').value;
					if(confirm("<cf_get_lang dictionary_id='54564.Fazla Mesaileri Siliyorsunuz! Emin misiniz'>"))
					{
						ext_worktimes_form.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_ext_worktimes&fsactn=#attributes.fuseaction##url_str#</cfoutput>&id_list='+document.getElementById('id_list').value;
						ext_worktimes_form.submit();
					}
				}
			} 
			else 
			{
				alert("<cf_get_lang dictionary_id='54563.En az bir satır seçmelisiniz'>.");
				return false;
			}
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd' or attributes.event is 'add_ext' or attributes.event is 'upd_ext')>
		function check_()
		{
			<cfif attributes.event is 'add' or attributes.event is 'upd'>
				if($('#term').val() == "")
				{
					alert('<cf_get_lang_main no="1060.Dönem">');
					return false;
				}
				if($('#start_mon').val() == "")
				{
					alert('<cf_get_lang_main no="1312.Ay">');
					return false;
				}
				$('#overtime_value0').val(filterNum($('#overtime_value0').val(),4));
				$('#overtime_value1').val(filterNum($('#overtime_value1').val(),4));
				$('#overtime_value2').val(filterNum($('#overtime_value2').val(),4));
				$('#overtime_value3').val(filterNum($('#overtime_value3').val(),4));
			<cfelseif attributes.event is 'add_ext' or attributes.event is 'upd_ext'>
				if (document.getElementById('start_hour').selectedIndex > document.getElementById('end_hour').selectedIndex)
				{
					<cfif fusebox.circuit eq 'myhome'>
						alert("<cf_get_lang no='652.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
					<cfelse>
						alert("<cf_get_lang no='648.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
					</cfif>
					return false;
				}
				else if ((document.getElementById('start_hour').selectedIndex == document.getElementById('end_hour').selectedIndex) && (document.getElementById('start_min').selectedIndex >= document.getElementById('end_min').selectedIndex))
				{
					<cfif fusebox.circuit eq 'myhome'>
						alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'>!");
					<cfelse>
						alert("<cf_get_lang no='649.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
					</cfif>
					return false;
				}
			</cfif>
			return true;
		}
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add_all' or attributes.event is 'add_per' or attributes.event is 'add_over')>
		$(document).ready(function() {
			<cfif attributes.event is 'add_all' or attributes.event is 'add_over'>
				<cfif isdefined("get_department_positions") and get_department_positions.recordcount>
					row_count=<cfoutput>#get_department_positions.recordcount#</cfoutput>;
				<cfelse>
					row_count=1;
				</cfif>
			<cfelse>
				row_count=0;
			</cfif>
		});
		function hepsi(satir,nesne)
		{
			deger=eval("document.add_worktime."+nesne+"0");
			
			for(var i=1;i<=satir;i++)
			{
				nesne_tarih=eval("document.add_worktime."+nesne+i);
				nesne_tarih.value=deger.value;
			}
		}
		function sil(sy)
		{
			var my_element=eval("add_worktime.row_kontrol_"+sy);
			my_element.value=0;
			var my_element=eval("my_row_"+sy);
			my_element.style.display="none";
		}
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			
			<cfif attributes.event is 'add_all' or attributes.event is 'add_over'>
				document.add_worktime.record_num.value=row_count;
			</cfif>
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);
			
			<cfif attributes.event is 'add_per'>
				document.add_worktime.record_sayisi.value=row_count;
			</cfif>
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a><input type="hidden" value="1" name="row_kontrol_' + row_count + '">';
			<cfif attributes.event is 'add_all' or attributes.event is 'add_over'>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" value="" name="employee_id' + row_count +'">';
				newCell.innerHTML += '<input type="hidden" value="" name="employee_in_out_id' + row_count +'"><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" style="width:130px;" value="" onFocus="AutoComplete_Create(\'employee\' + row_count,\'FULLNAME\',\'FULLNAME,BRANCH_NAME\',\'get_in_outs_autocomplete\',\'\',\'EMPLOYEE_ID,IN_OUT_ID,BRANS_NAME_DEP_HEAD\',\'employee_id\' + row_count + \',employee_in_out_id\' + row_count + \',department\' + row_count,\'add_worktime\',\'3\',\'225\');"> <a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_worktime.employee_in_out_id'+ row_count + '&field_emp_name=add_worktime.employee'+ row_count + '&field_emp_id=add_worktime.employee_id'+ row_count + '&field_branch_and_dep=add_worktime.department'+ row_count + '\' ,\'list\');"><img border="0" src="/images/plus_thin.gif" align="absbottom"></a>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input name="department'+row_count+'" type="text" style="width:130px;" readonly value="">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif attributes.event is 'add_all' or attributes.event is 'add_per'>
				newCell.setAttribute("id","startdate" + row_count + "_td");
				newCell.innerHTML = '<input type="text" id="startdate' + row_count +'" name="startdate' + row_count +'" class="text" maxlength="10" style="width:65px;" value=""> ';
				wrk_date_image('startdate' + row_count);
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="start_hour' + row_count + '"><option value="0">s</option><cfloop from="1" to="23" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> <select name="start_min' + row_count + '"><option value="0">dk</option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="end_hour' + row_count + '"><option value="0">s</option><cfloop from="1" to="23" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select> <select name="end_min' + row_count + '"><option value="0">dk</option><cfloop from="1" to="59" index="i"><cfoutput><option value="#i#"><cfif i lt 10>0</cfif>#i#</option></cfoutput></cfloop></select>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				<cfif attributes.event is 'add_per'>
					newCell.innerHTML = '<input type="radio" name="day_type' + row_count + '" value="0" checked><cf_get_lang no ='68.Normal Gün'>  <input type="radio" name="day_type' + row_count + '" value="1"> <cf_get_lang no ='69.Hafta Sonu'> <input type="radio" name="day_type' + row_count + '" value="2"><cf_get_lang no ='70.Resmi Tatil'> <input type="radio" name="day_type' + row_count + '" value="3"> <cf_get_lang no="1305.Gece Çalışması">';
				<cfelse>
					newCell.innerHTML = '<input type="radio" name="day_type' + row_count + '" value="0" checked><cf_get_lang no="543.NG"> <input type="radio" name="day_type' + row_count + '" value="1"> <cf_get_lang no="544.HT"> <input type="radio" name="day_type' + row_count + '" value="2"> <cf_get_lang no="545.GT">  <input type="radio" name="day_type' + row_count + '" value="3"> <cf_get_lang no="1305.Gece Çalışması">';
				</cfif>
			<cfelseif attributes.event is 'add_over'>
				newCell.innerHTML = '<cfoutput><select name="term'+row_count+'" id="term'+row_count+'" style="width:80px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="#j#">#j#</option></cfloop></select></cfoutput>'; 
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<cfoutput><select name="start_mon'+row_count+'" id="start_mon'+row_count+'" style="width:80px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfloop from="1" to="12" index="j"><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfloop></select></cfoutput>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="overtime_value_0_'+row_count+'" id="overtime_value_0_'+row_count+'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="overtime_value_1_'+row_count+'" id="overtime_value_1_'+row_count+'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="overtime_value_2_'+row_count+'" id="overtime_value_2_'+row_count+'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="overtime_value_3_'+row_count+'" id="overtime_value_3_'+row_count+'" style="width:80px;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,2));">';
			</cfif>
		}
		function kontrol()
		{
			if(row_count == 0)
			{
				alert("<cf_get_lang no='654.Fazla Mesai Girişi Yapmadınız'>!");
				return false;
			}
			<cfif attributes.event is 'add_all' or attributes.event is 'add_over'>
				document.add_worktime.record_num.value=row_count;
				<cfif attributes.event is 'add_all'>
					for(var j=0;j<=row_count;j++)
					{
						tarih_nesne=eval("document.add_worktime.startdate"+j);
						if(!CheckEurodate(tarih_nesne.value,j+'. Tarih'))
						{ 
							tarih_nesne.focus();
							return false;
						}
					}
				<cfelse>
					recordnum = document.add_worktime.record_num.value;
					for(i =1;i <= recordnum; i++)
					{
						if($('#row_kontrol_'+i).val() != 0)
						{
							if ($('#term'+i).val() == '' || $('#term'+i).val() == 'undefined' || $('#start_mon'+i).val() == '' || $('#start_mon'+i).val() == 'undefined')
							{
								alert("<cf_get_lang dictionary_id='54566.Satırlardaki Dönem ve Ay Verilerini Kontrol Ediniz'>");
								return false;
							}
						}
					}
				</cfif>
			</cfif>
			return true;
		}
		<cfif isdefined("attributes.event") and (attributes.event is 'add_all' or attributes.event is 'add_per')>
			function hepsi_startdate()
			{
				hepsi(row_count,'startdate');
			}
			function hepsi_check(satir,nesne)
			{
				deger=eval(document.add_worktime.day_type0)
				for(var j=0;j<=deger.length-1;j++)
				{
					if(deger[j].checked==true)
					{
						sec=deger[j].value;
					}
				}
				for(var i=1;i<=satir;i++)
				{
					nesne_check=eval("document.add_worktime.day_type"+i);
					nesne_check[sec].checked=true;
				}
			}
		<cfelseif attributes.event is 'add_over'>
			function upd_0()
			{	
				deger = eval("document.add_worktime.overtime_value0_0");	
				for(var i=1;i<=row_count;i++)
				{
					nesne_=eval("document.add_worktime.overtime_value_0_"+i);
					nesne_.value=deger.value;
				}
			}
			function upd_1()
			{	
				deger = eval("document.add_worktime.overtime_value1_0");	
				for(var i=1;i<=row_count;i++)
				{
					nesne_=eval("document.add_worktime.overtime_value_1_"+i);
					nesne_.value=deger.value;
				}
			}
			function upd_2()
			{	
				deger = eval("document.add_worktime.overtime_value2_0");	
				for(var i=1;i<=row_count;i++)
				{
					nesne_=eval("document.add_worktime.overtime_value_2_"+i);
					nesne_.value=deger.value;
				}
			}
			function upd_3()
			{	
				deger = eval("document.add_worktime.overtime_value3_0");	
				for(var i=1;i<=row_count;i++)
				{
					nesne_=eval("document.add_worktime.overtime_value_3_"+i);
					nesne_.value=deger.value;
				}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_ext_worktimes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_ext_worktimes.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_all_overtime';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_all_overtime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_all_overtime.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_ext_worktimes&event=upd';
	
	WOStruct['#attributes.fuseaction#']['add_ext'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_ext']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_ext']['fuseaction'] = 'ehesap.popup_form_add_ext_worktime';
	WOStruct['#attributes.fuseaction#']['add_ext']['filePath'] = 'hr/ehesap/form/add_ext_worktime.cfm';
	WOStruct['#attributes.fuseaction#']['add_ext']['queryPath'] = 'hr/ehesap/query/add_ext_worktime.cfm';
	WOStruct['#attributes.fuseaction#']['add_ext']['nextEvent'] = 'ehesap.list_ext_worktimes&event=upd_ext';
	
	WOStruct['#attributes.fuseaction#']['add_all'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_all']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_all']['fuseaction'] = 'ehesap.popup_add_ext_worktimes_all';
	WOStruct['#attributes.fuseaction#']['add_all']['filePath'] = 'hr/ehesap/form/add_ext_worktimes_all.cfm';
	WOStruct['#attributes.fuseaction#']['add_all']['queryPath'] = 'hr/ehesap/query/add_ext_worktimes_all.cfm';
	WOStruct['#attributes.fuseaction#']['add_all']['nextEvent'] = 'ehesap.list_ext_worktimes';
	
	WOStruct['#attributes.fuseaction#']['add_per'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_per']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_per']['fuseaction'] = 'ehesap.popup_add_ext_worktimes_personal';
	WOStruct['#attributes.fuseaction#']['add_per']['filePath'] = 'hr/ehesap/form/add_ext_worktimes_personal.cfm';
	WOStruct['#attributes.fuseaction#']['add_per']['queryPath'] = 'hr/ehesap/query/add_ext_worktimes_personal.cfm';
	WOStruct['#attributes.fuseaction#']['add_per']['nextEvent'] = 'ehesap.list_ext_worktimes';
	
	WOStruct['#attributes.fuseaction#']['add_over'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_over']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_over']['fuseaction'] = 'ehesap.popup_add_overtime_all';
	WOStruct['#attributes.fuseaction#']['add_over']['filePath'] = 'hr/ehesap/form/add_overtime_all.cfm';
	WOStruct['#attributes.fuseaction#']['add_over']['queryPath'] = 'hr/ehesap/query/add_overtime_all.cfm';
	WOStruct['#attributes.fuseaction#']['add_over']['nextEvent'] = 'ehesap.list_ext_worktimes';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_all_overtime';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_all_overtime.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_all_overtime.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_ext_worktimes&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'overtime_id=##attributes.overtime_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.overtime_id##';
	
	WOStruct['#attributes.fuseaction#']['upd_ext'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_ext']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_ext']['fuseaction'] = 'ehesap.popup_form_upd_ext_worktime';
	WOStruct['#attributes.fuseaction#']['upd_ext']['filePath'] = 'hr/ehesap/form/upd_ext_worktime.cfm';
	WOStruct['#attributes.fuseaction#']['upd_ext']['queryPath'] = 'hr/ehesap/query/upd_ext_worktime.cfm';
	WOStruct['#attributes.fuseaction#']['upd_ext']['nextEvent'] = 'ehesap.list_ext_worktimes&event=upd_ext';
	WOStruct['#attributes.fuseaction#']['upd_ext']['parameters'] = 'ewt_id=##attributes.ewt_id##';
	WOStruct['#attributes.fuseaction#']['upd_ext']['Identity'] = '##attributes.ewt_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_overtime';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_all_overtime.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_all_overtime.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_ext_worktimes';
		
		WOStruct['#attributes.fuseaction#']['del_ext'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_ext']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del_ext']['fuseaction'] = 'ehesap.emptypopup_del_ext_worktime';
		WOStruct['#attributes.fuseaction#']['del_ext']['filePath'] = 'hr/ehesap/query/del_ext_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['del_ext']['queryPath'] = 'hr/ehesap/query/del_ext_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['del_ext']['nextEvent'] = 'ehesap.list_ext_worktimes';
	}
	
	if(attributes.event is 'upd_ext')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ext'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ext']['icons'] = structNew();
		if (isdefined("attributes.module_control") and len(attributes.module_control))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ext']['icons']['add']['text'] = '#lang_array.item[72]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ext']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.list_my_extra_times&event=add";
		}else{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ext']['icons']['add']['text'] = '#lang_array.item[72]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ext']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add_ext";
		}
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
		if (is_extwork_type eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[633]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add_all','horizantal');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array.item[633]# (#lang_array_main.item[2034]#)';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add_per','page');";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[633]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add_over','wide2');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	if (isdefined("attributes.event") and listfind('add_ext,upd_ext,add,upd',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapExtWorktimes';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		if (listfind('add_ext,upd_ext',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_ext,upd_ext';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_EXT_WORKTIMES';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-employee_id','item-startdate']";
		}
		else if (listfind('add,upd',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_OVERTIME';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-employee']";
		}
	}
</cfscript>
