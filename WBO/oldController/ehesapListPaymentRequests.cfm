<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cf_xml_page_edit fuseact="ehesap.list_payment_requests">
	<cfparam name="attributes.date1" default="01/#Month(now())#/#year(now())#">
	<cfset bu_ay_sonu = DaysInMonth('#Month(now())#/01/#year(now())#')>
	<cfparam name="attributes.date2" default="#bu_ay_sonu#/#Month(now())#/#year(now())#">
	<cfparam name="attributes.avans_type" default="0">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.status" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.sayfa_toplam" default="0">
	<cfparam name="attributes.comp_id" default="">
	<cfparam name="attributes.money" default="">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfscript>
		url_str = "keyword=#attributes.keyword#&status=#attributes.status#&hierarchy=#attributes.hierarchy#&branch_id=#attributes.branch_id#&avans_type=#attributes.avans_type#";
		if (isdefined('attributes.form_submit') and len(attributes.form_submit))
			url_str = "#url_str#&form_submit=#attributes.form_submit#";
		if (isdefined('attributes.comp_id') and len(attributes.comp_id))
			url_str = "#url_str#&comp_id=#attributes.comp_id#";
		if (isdefined('attributes.money') and len(attributes.money))
			url_str = "#url_str#&money=#attributes.money#";
		cmp_company = createObject("component","hr.cfc.get_our_company");
		cmp_company.dsn = dsn;
		get_our_company = cmp_company.get_company();
	</cfscript>
	<cf_date tarih='attributes.date1'>
	<cf_date tarih='attributes.date2'>
	<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
		SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2
	</cfquery>
	<!--- sorgu sirayi bozmayin  --->
	<cfif isdefined('attributes.form_submit')>
		<cfinclude template="../hr/ehesap/query/get_payment_requests.cfm">
	<cfelse>
		<cfset get_requests.recordcount = 0>
	</cfif>
	<cfif not isDefined("attributes.status")>
		<cfset attributes.status=2>
	</cfif>
	<cfinclude template="../hr/ehesap/query/get_setup_moneys.cfm">
	<cfparam name="attributes.totalrecords" default="#get_requests.recordcount#">
	<cfset attributes.date1=dateformat(attributes.date1,'dd/mm/yyyy')>
    <cfset attributes.date2=dateformat(attributes.date2,'dd/mm/yyyy')>
    <cfset url_str="#url_str#&date1=#attributes.date1#&date2=#attributes.date2#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
    	<cfquery name="get_branch" datasource="#dsn#">
			SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> ORDER BY BRANCH_NAME
		</cfquery>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="ehesap.add_payment_request">
	<cfinclude template="../hr/ehesap/query/get_priority.cfm">
	<cfquery name="all_pos_cats" datasource="#DSN#">
		SELECT 
			POSITION_CAT_ID,
			POSITION_CAT
		FROM
			SETUP_POSITION_CAT
		ORDER BY
			POSITION_CAT
	</cfquery>
	<cfinclude template="../hr/ehesap/query/get_all_branches.cfm">
	<cfif isdefined("attributes.pos_cat_id") and isdefined('attributes.is_submit') and attributes.is_submit eq 1>
		<cfquery name="get_poscat_positions" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
				INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
			WHERE
				<cfif len(attributes.branch_id)>
					B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
				</cfif>
				<cfif len(attributes.pos_cat_id)>
					EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_cat_id#"> AND POSITION_STATUS = 1 AND EMPLOYEE_ID > 0) AND
				</cfif>
				<cfif Len(attributes.collar_type)>
					 EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"> AND
				</cfif>
				EP.IS_MASTER = 1 AND
				EIO.FINISH_DATE IS NULL
			ORDER BY
				EMPLOYEE_NAME
		</cfquery>
	</cfif>
	<cfquery name="PAY_METHODS" datasource="#DSN#">
		SELECT 	
			SP.* 
		FROM 
			SETUP_PAYMETHOD SP
			INNER JOIN SETUP_PAYMETHOD_OUR_COMPANY SPOC ON SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID
		WHERE 
			SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR
			INNER JOIN PROCESS_TYPE PT ON PT.PROCESS_ID = PTR.PROCESS_ID
			INNER JOIN PROCESS_TYPE_OUR_COMPANY PTO ON PT.PROCESS_ID = PTO.PROCESS_ID
		WHERE
			PT.IS_ACTIVE = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.popup_add_payment_request%">
		ORDER BY 
			PTR.LINE_NUMBER
	</cfquery>
	<cfif not get_request_stage.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='54610.Avans Süreçleri Tanımlı Değil'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfinclude template="../hr/ehesap/query/get_setup_moneys.cfm">
	<cfif fuseaction contains "popup">
		<cfset is_popup=1>
	<cfelse>
		<cfset is_popup=0>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
	<cfinclude template="../hr/ehesap/query/get_payment_request.cfm">
	<cfif fuseaction contains "popup">
		<cfset is_popup=1>
	<cfelse>
		<cfset is_popup=0>
	</cfif>
	<cfinclude template="../hr/ehesap/query/get_priority.cfm">
	<cfquery name="GET_IN_OUTS" datasource="#DSN#">
		SELECT 
			EIO.IN_OUT_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,B.BRANCH_NAME 
		FROM 
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			INNER JOIN BRANCH B ON B.BRANCH_ID = EIO.BRANCH_ID
		WHERE 
			EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment_request.to_employee_id#"> AND 
			(EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">)
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_payment_request.cfm">
	<cfinclude template="../hr/ehesap/query/get_priority.cfm">
	<cfquery name="PAY_METHODS" datasource="#DSN#">
		SELECT 	
			SP.* 
		FROM 
			SETUP_PAYMETHOD SP,
			SETUP_PAYMETHOD_OUR_COMPANY SPOC
		WHERE
			SP.PAYMETHOD_STATUS = 1
			AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
			AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfquery name="GET_IN_OUTS" datasource="#DSN#">
		SELECT 
			EIO.IN_OUT_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,B.BRANCH_NAME 
		FROM 
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			INNER JOIN BRANCH B ON B.BRANCH_ID = EIO.BRANCH_ID
		WHERE 
			EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment_request.to_employee_id#"> AND 
			(EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">)
	</cfquery>
	<cfquery name="GET_MONEYS" datasource="#DSN#">
		SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfif len(get_payment_request.validator_position_code_1) and not len(get_payment_request.valid_1)>
		<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
			SELECT
				O.EMPLOYEE_ID,
				EP.POSITION_CODE
			FROM
				OFFTIME O
				INNER JOIN EMPLOYEE_POSITIONS EP ON O.EMPLOYEE_ID = EP.EMPLOYEE_ID
			WHERE
				O.VALID = 1 AND
				#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
		</cfquery>
		<cfset offtime_pos_code_list = valuelist(Get_Offtime_Valid.position_code)>
		<cfset extra_pos_code = ''>
		<cfif listfind(offtime_pos_code_list,get_payment_request.validator_position_code_1)>
			<!--- Eğer 1.amir izindeyse 1.amirin yedekleri bulunuyor --->
			<cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
				SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 ,CANDIDATE_POS_3 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_payment_request.validator_position_code_1#
			</cfquery>
			<cfif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1)>
				<cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1>
			<cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
				<cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
			<cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
				<cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
			</cfif>
		</cfif>
	</cfif>
	<cfif len(get_payment_request.validator_position_code_2) and not len(get_payment_request.valid_2)>
		<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
			SELECT
				O.EMPLOYEE_ID,
				EP.POSITION_CODE
			FROM
				OFFTIME O
				INNER JOIN EMPLOYEE_POSITIONS EP ON O.EMPLOYEE_ID = EP.EMPLOYEE_ID
			WHERE
				O.VALID = 1 AND
				#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
		</cfquery>
		<cfset offtime_pos_code_list = valuelist(Get_Offtime_Valid.position_code)>
		<cfset extra_pos_code = ''>
		<cfif listfind(offtime_pos_code_list,get_payment_request.validator_position_code_2)>
			<!--- Eğer 1.amir izindeyse 1.amirin yedekleri bulunuyor --->
			<cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
				SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 ,CANDIDATE_POS_3 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_payment_request.validator_position_code_2#
			</cfquery>
			<cfif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1)>
				<cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1>
			<cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
				<cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
			<cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
				<cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function pencere_ac(deger)
		{ 
			var sayac = 0;
			var money_control = 1;  
			var money_temp = '';
			<cfif get_requests.recordcount>
				<cfif get_requests.recordcount gt 1>
					if(form.is_sec != undefined)
					{
						for(i=0;i<form.is_sec.length;i++) 
						{
							if(form.is_sec[i] != undefined && document.form.is_sec[i].disabled != true && form.is_sec[i].checked == true)
							{
								sayac ++;
								if($('#payment_ids').val().length==0) ayirac=''; else ayirac=',';
								document.getElementById('payment_ids').value=document.getElementById('payment_ids').value+ayirac+document.form.is_sec[i].value;
								if (money_temp == '')
									money_temp = $('#money_'+document.form.is_sec[i].value).val();
								if (money_temp.length && money_temp != $('#money_'+document.form.is_sec[i].value).val())
									money_control = 0;
							}
						}
					}
					else if(document.form.is_sec.value != undefined && document.form.is_sec.value != 0 && document.form.is_sec.disabled != true)
					{
						sayac ++;
						document.getElementById('payment_ids').value = document.form.is_sec.value;
					}
				<cfelse>
					if(document.form.is_sec.value != undefined && document.form.is_sec.value != 0 && document.form.is_sec.disabled != true)
					{
						sayac ++;
						document.getElementById('payment_ids').value = document.form.is_sec.value;
					}
				</cfif>
				if (money_control == 0)
				{
					alert("<cf_get_lang dictionary_id='54615.Seçtiğiniz satırların para birimi aynı olmalıdır'>.<cf_get_lang dictionary_id='364.Lütfen kontrol ediniz'>!");
					return false;
				}
				else if(sayac == 0)
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='280.İşlem'>");
					return false;
				}
				else{
				windowopen('','wide','select_list_window');
				if(deger == 1)
				{
					form.action='<cfoutput>#request.self#?fuseaction=bank.popup_add_collacted_gidenh</cfoutput>';
				}
				else if (deger == 2)
				{
					form.action='<cfoutput>#request.self#?fuseaction=cash.popup_add_collacted_payment</cfoutput>';
				}
				form.target='select_list_window';form.submit();
				$('#payment_ids').val('');
				}
			</cfif>
		}
		function hepsi()
		{
			if (document.getElementById('all_check').checked)
			{
			<cfif get_requests.recordcount gt 1>	
				for(i=0;i<form.is_sec.length;i++) 
				{
					form.is_sec[i].checked = true;
				}
			<cfelseif get_requests.recordcount eq 1>
				form.is_sec.checked = true;
			</cfif>
			}
			else
			{
			<cfif get_requests.recordcount gt 1>	
				for(i=0;i<form.is_sec.length;i++) 
				{
					form.is_sec[i].checked = false;
				}
			<cfelseif get_requests.recordcount eq 1>
				form.is_sec.checked = false;
			</cfif>
			}
		}
		function showBranch(comp_id)	
		{
			var comp_id = document.myform.comp_id.value;
			if (comp_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id+"&is_department=0";
				AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		$(document).ready(function() {
			<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1 and isdefined("get_poscat_positions") and get_poscat_positions.recordcount>
				row_count=<cfoutput>#get_poscat_positions.recordcount#</cfoutput>;
			<cfelse>
				row_count=0;
			</cfif>
			$('#record_num').val(row_count);
			//document.getElementById('payment_req_file').style.marginLeft=screen.width-360;
		});
		function hepsi(satir,nesne,baslangic)
		{
			deger=eval("document.form_add_payment_request."+nesne+"0");
			if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
			{
				if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
				for(var i=baslangic;i<=satir;i++)
				{
					nesne_tarih=eval('document.getElementById( nesne + i )');
					nesne_tarih.value=deger.value;
				}
			}
			if(nesne == 'total')
			{
				toplam_hesapla();
			}
		}
		function toplam_hesapla()
		{
			var total_amount = 0;
			var sayac = 0;
			for(var i=1;i<=row_count;i++)
			{
				if(eval("form_add_payment_request.row_kontrol_"+i).value != 0 && eval("document.form_add_payment_request.total"+i).value != 0)
				{
					nesne_tarih=eval("document.form_add_payment_request.total"+i);
					total_amount += parseFloat(filterNum(nesne_tarih.value));
					sayac++
				}
			}
			$('#total_amount').val(parseFloat(total_amount));
			$('#total_emp').val(sayac);
		}
		function kontrol_et()
		{
			for (i=1;i <= row_count; i++)
			{
				temp_field = eval('document.form_add_payment_request.total'+i);
				if (!(parseFloat(filterNum(temp_field.value)) > 0) && eval("form_add_payment_request.row_kontrol_"+i).value != 0)
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='261.Tutar'>");
					return false;
				}
				emp_id_field  = eval('document.form_add_payment_request.emp_id'+i);
				employee_field = eval('document.form_add_payment_request.employee'+i)
				if(!(emp_id_field.value.length || employee_field.value.length) && eval("form_add_payment_request.row_kontrol_"+i).value != 0)
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'>");
					return false;
				}
			}
			<cfif session.ep.ehesap neq 1>
			if (confirm("<cf_get_lang no='657.Tüm Talepleri Onaylamak İster misiniz'> ?"))
				$('#hepsi_onayli').val('1');
			else
				$('#hepsi_onayli').val('0');
			</cfif>
			UnformatFields();
			return true;
		}
		function sil(sy)
		{
			var my_element=eval("form_add_payment_request.row_kontrol_"+sy);
			my_element.value=0;
			var my_element=eval("my_row_"+sy);
			my_element.style.display="none";
	
			toplam_hesapla();
		}
		function add_row(emp_in_out_id,emp_id,employee,total)
		{
			//Normal satır eklerken değişkenler olmadığı için boşluk atıyor
			if(emp_in_out_id == undefined)emp_in_out_id = '';
			if(emp_id == undefined)emp_id = '';
			if(employee == undefined)employee = '';
			if(total == undefined)total = '';
			
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);		
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);		
			
			document.getElementById('record_num').value=row_count;	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<i class="icon-trash-o btnPointer" onclick="sil(' + row_count + ');" ></i>';			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="in_out_id' + row_count + '" id="in_out_id' + row_count + '" value="' + emp_in_out_id + '"><input type="hidden" name="emp_id' + row_count + '" id="emp_id' + row_count + '" value="' + emp_id + '"><input type="text" name="employee' + row_count + '" id="employee' + row_count + '" value="' + employee + '"><input type="hidden" value="1" name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"><i class="icon-ellipsis btnPointer" onclick="javascript:opage(' + row_count +');">&nbsp;</i>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total' + row_count + '" id="total' + row_count + '" class="moneybox" onkeyup=""FormatCurrency(this,event,2,"float");"" value="'+total+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="money' + row_count + '" id="money' + row_count + '"><cfoutput query="get_moneys"><option value="#money#" <cfif session.ep.money eq get_moneys.money>selected</cfif>>#money#</option></cfoutput></select>';
			<cfif xml_pay_method eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="pay_method' + row_count + '" id="pay_method' + row_count + '" ><cfoutput query="PAY_METHODS"><option value="#PAYMETHOD_ID#" >#PAYMETHOD#</option></cfoutput></select>';
			</cfif>
		}		
		
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=form_add_payment_request.in_out_id'+deger+'&field_emp_id=form_add_payment_request.emp_id' + deger + '&field_emp_name=form_add_payment_request.employee' + deger,'list');
		}	
		
		function UnformatFields()
		{
			for(satir_i=1; satir_i <= row_count; satir_i++)
			{
				var str_me = eval("form_add_payment_request.total" + satir_i);
				str_me.value = filterNum(str_me.value);
			}
		}
		function open_file(el)
		{
				var control = $('*').find('div#payment_req_file').length;
				
				if( control > 0 ) $('div#payment_req_file').remove();
			
			
			$('<div>').attr('id','payment_req_file').css({
				"position" : "absolute",
				"left" : $(el).offset().left - 220,
				"top" : $(el).offset().top + 35
				
				}).appendTo(document.body)
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_payment_request_file</cfoutput>','payment_req_file',1);
			return false;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
		<cfif isdefined("attributes.is_print")>
			function waitfor()
			{
				window.close();
			}	
			setTimeout("waitfor()",3000);
			window.print();
		</cfif>
		function kontrol_et()
		{
			if (!document.upd_payment.amount.value.length)
			{
				alert("<cf_get_lang dictionary_id='54619.Tutar Girmelisiniz'>");
				return false;
			}
			document.upd_payment.amount.value = filterNum(document.upd_payment.amount.value);
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfif isdefined('attributes.is_print')>
			function waitfor(){
			window.close();
			}	
			setTimeout("waitfor()",3000);
			window.print();
		</cfif>
		function UnformatFields()
		{
			document.getElementById('AMOUNT').value = filterNum(document.getElementById('AMOUNT').value);
			return true;
		}
		
		function onay_islemi()
		{
			x = document.getElementById('employee_in_out_id').selectedIndex;
			if (document.form_upd_payment_request.employee_in_out_id[x].value == "")
			{ 
				alert ("<cf_get_lang no ='1121.Onay İşlemi İçin Bir Giriş-Çıkış Seçmelisiniz'>!");
				return false;
			}
			else
			{
				my_id = document.form_upd_payment_request.employee_in_out_id[x].value;
				window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_deny_payment_request&payment_id=#attributes.id#&upd_id=1&employee_in_out_id=</cfoutput>'+my_id;
			}	
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_payment_requests';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_payment_requests.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_payment_request';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_payment_requests&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_payment_request';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_payment_requests&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'ehesap.popup_dsp_payment_requests';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/ehesap/display/dsp_pay_request_detail.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'hr/ehesap/query/upd_pay_request.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'ehesap.list_payment_requests&event=det';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_payment_request';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_payment_requests';
	}
	
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[2576]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "open_file(this);";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (attributes.event is 'det')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		if (isdefined("attributes.id") and len(attributes.id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_payment_requests&event=det&id=#attributes.id#&is_print=1','page');";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_payment_requests&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		if (isdefined("attributes.id") and len(attributes.id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_payment_requests&event=upd&id=#attributes.id#&is_print=1','page');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListPaymentRequests';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CORRESPONDENCE_PAYMENT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	if(attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-subject','item-duedate']";
	}
	else if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-subject','item-duedate','item-amount']";
	}
	
</cfscript>
