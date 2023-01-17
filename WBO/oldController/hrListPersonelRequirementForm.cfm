<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.requirement_emp_id" default="">
	<cfparam name="attributes.requirement_name" default="">
	<cfparam name="attributes.our_company_id" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.position_cat_id" default="">
	<cfparam name="attributes.position_cat" default="">
	<cfparam name="attributes.process_status" default="">
	<cfparam name="attributes.process_stage" default="">
	<cfset NewDate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
	<cfparam name="attributes.startdate" default="#DateFormat(DateAdd('d',-7,NewDate),'dd/mm/yyyy')#">
	<cfparam name="attributes.finishdate" default="#DateFormat(DateAdd('d',1,NewDate),'dd/mm/yyyy')#">
	<cfif isDate(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
	<cfif isDate(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
	
	<cfquery name="get_process_stage" datasource="#dsn#">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListFirst(attributes.fuseaction,'.')#.from_add_personel_requirement_form%">
		ORDER BY
			PTR.LINE_NUMBER
	</cfquery>
	
	<cfquery name="get_our_company" datasource="#dsn#">
		SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
	</cfquery>
	
	<cfquery name="get_our_branch" datasource="#dsn#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE <cfif Len(attributes.our_company_id)>COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND</cfif> BRANCH_STATUS =1 ORDER BY BRANCH_NAME
	</cfquery>
	
	<cfif Len(attributes.branch_id)>
		<cfquery name="get_our_department" datasource="#dsn#">
			SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
		</cfquery>
	</cfif>
	
	<cfif isDefined("attributes.is_filtered")>
		<cfquery name="get_form" datasource="#dsn#">
			SELECT
				PRF.*,
				PTR.STAGE,
				OC.NICK_NAME,
				B.BRANCH_NAME,
				D.DEPARTMENT_HEAD,
				SPC.POSITION_CAT,
				PAF.PERSONEL_NAME,
				PAF.PERSONEL_SURNAME,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				CP.COMPANY_PARTNER_NAME,
				CP.COMPANY_PARTNER_SURNAME,
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME
			FROM
				PERSONEL_REQUIREMENT_FORM PRF
				INNER JOIN PROCESS_TYPE_ROWS PTR ON PRF.PER_REQ_STAGE = PTR.PROCESS_ROW_ID
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = PRF.OUR_COMPANY_ID
				LEFT JOIN BRANCH B ON B.BRANCH_ID = PRF.BRANCH_ID
				LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = PRF.DEPARTMENT_ID
				LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = PRF.POSITION_CAT_ID
				LEFT JOIN PERSONEL_ASSIGN_FORM PAF ON PAF.PERSONEL_REQ_ID = PRF.PERSONEL_REQUIREMENT_ID
				LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = PRF.REQUIREMENT_EMP
				LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = PRF.REQUIREMENT_PAR_ID
				LEFT JOIN CONSUMER C ON C.CONSUMER_ID = PRF.REQUIREMENT_CONS_ID
			WHERE
				PRF.PERSONEL_REQUIREMENT_ID IS NOT NULL
				<cfif Len(attributes.process_status)>
					AND ISNULL(PRF.IS_FINISHED,-1) = #attributes.process_status#
				</cfif>
				<cfif Len(attributes.process_stage)>
					AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
				</cfif>
				<cfif len(attributes.our_company_id)>
					AND PRF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>
				<cfif len(attributes.branch_id)>
					AND PRF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				</cfif>
				<cfif len(attributes.department_id)>
					AND PRF.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
				</cfif>
				<cfif len(attributes.position_cat) and len(attributes.position_cat_id)>
					AND PRF.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
				</cfif>
				<cfif len(attributes.requirement_name) and len(attributes.requirement_emp_id)>
					AND PRF.REQUIREMENT_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.requirement_emp_id#">
				</cfif>
				<cfif Len(attributes.keyword)>
					AND 
					(
						<cfif isNumeric(attributes.keyword)>
							PRF.PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.keyword#"> OR
						</cfif>
						PRF.PERSONEL_REQUIREMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PRF.OLD_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PRF.OLD_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PRF.CHANGE_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PRF.CHANGE_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PRF.TRANSFER_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PRF.TRANSFER_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					)
				</cfif>
				<cfif not ListFirst(attributes.fuseaction,'.') contains 'hr'>
					AND 
					(
						<!---ISNULL(PRF.UPDATE_EMP,PRF.RECORD_EMP) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">--->
						PRF.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
						PRF.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
						PRF.PERSONEL_REQUIREMENT_ID IN(SELECT ACTION_ID FROM  PAGE_WARNINGS WHERE ACTION_COLUMN = 'PERSONEL_REQUIREMENT_ID' AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)<!---onay ve uyarılacaklar --->
						OR
						PRF.PERSONEL_REQUIREMENT_ID IN(SELECT PER_REQ_FORM_ID FROM EMPLOYEES_APP_AUTHORITY WHERE POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) <!--- yetkililer--->
					)
				</cfif>
				<cfif Len(attributes.startdate) and Len(attributes.finishdate)>
					AND ISNULL(PRF.UPDATE_DATE,PRF.RECORD_DATE) BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			ORDER BY
				PRF.PERSONEL_REQUIREMENT_ID DESC
		</cfquery>
	<cfelse>
		<cfset get_form.recordcount = 0>
	</cfif>
	
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
	<cfparam name="attributes.totalrecords" default="#get_form.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset url_str = "&is_filtered=1">
	<cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
	<cfif Len(attributes.requirement_name) and Len(attributes.requirement_emp_id)>
	    <cfset url_str = "#url_str#&requirement_name=#attributes.requirement_name#&requirement_emp_id=#attributes.requirement_emp_id#">
	</cfif>
	<cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
	<cfif Len(attributes.branch_id)><cfset url_str = "#url_str#&branch_id=#attributes.branch_id#"></cfif>
	<cfif Len(attributes.department_id)><cfset url_str = "#url_str#&department_id=#attributes.department_id#"></cfif>
	<cfif Len(attributes.position_cat) and Len(attributes.position_cat_id)>
	    <cfset url_str = "#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#">
	</cfif>
	<cfif Len(attributes.process_stage)><cfset url_str = "#url_str#&process_stage=#attributes.process_stage#"></cfif>
	<cfif Len(attributes.startdate)><cfset url_str = "#url_str#&startdate=#DateFormat(attributes.startdate,'dd/mm/yyyy')#"></cfif>
	<cfif Len(attributes.finishdate)><cfset url_str = "#url_str#&finishdate=#DateFormat(attributes.finishdate,'dd/mm/yyyy')#"></cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="hr.from_upd_personel_requirement_form">
	<cf_get_lang_set module_name="hr"><!--- sayfanin alt kisminda kapanisi var --->
	<cfinclude template="../hr/query/get_edu_level.cfm">
	<cfinclude template="../hr/query/get_driverlicence.cfm">
	<cfinclude template="../hr/query/get_moneys.cfm">
	<cfinclude template="../hr/query/get_languages.cfm">
	<cfinclude template="../hr/query/get_know_levels.cfm">
    <cfquery name="get_emp_quizes" datasource="#dsn#">
        SELECT QUIZ_ID,QUIZ_HEAD FROM EMPLOYEE_QUIZ WHERE IS_SHOW = 1
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name="hr">
	<cf_xml_page_edit fuseact="hr.from_upd_personel_requirement_form">
	<cfif fusebox.circuit eq 'myhome'>
	    <cfset attributes.per_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.per_req_id,accountKey:session.ep.userid)>
	</cfif>
	<cfquery name="get_per_req" datasource="#dsn#">
		SELECT 
	    	* 
	    FROM 
	    	PERSONEL_REQUIREMENT_FORM 
	    WHERE 
		    PERSONEL_REQUIREMENT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_req_id#"> 
	</cfquery>
	<cfif not get_per_req.recordcount>
		<cfset hata  = 11>
		<cfsavecontent variable="message"><cf_get_lang_main no='72.Kayıt Yok'>!</cfsavecontent>
		<cfset hata_mesaj  = message>
		<cfinclude template="../dsp_hata.cfm">
	<cfelse>
		<cfinclude template="../hr/query/get_edu_level.cfm">
		<cfinclude template="../hr/query/get_driverlicence.cfm">
		<cfinclude template="../hr/query/get_languages.cfm">
		<cfinclude template="../hr/query/get_know_levels.cfm">
		<cfif len(get_per_req.our_company_id) and len(get_per_req.branch_id) and len(get_per_req.department_id)>
			<cfquery name="get_department_info" datasource="#dsn#">
				SELECT 
					OUR_COMPANY.NICK_NAME,
					BRANCH.BRANCH_NAME,
					DEPARTMENT.DEPARTMENT_HEAD
				FROM 
					OUR_COMPANY,
					BRANCH,
					DEPARTMENT
				WHERE 
					OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
					BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
					OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.our_company_id#"> AND
					BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.branch_id#"> AND
					DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.department_id#">
			</cfquery>
		</cfif>
		<cfset app_position = "">
		<cfif len(get_per_req.position_id)>
			<cfquery name="get_position_name" datasource="#dsn#">
				SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.position_id#">
			</cfquery>
			<cfset app_position = "#get_position_name.position_name#">
		</cfif>
		<cfset position_cat = "">
		<cfif len(get_per_req.position_cat_id)>
			<cfset attributes.position_cat_id = get_per_req.position_cat_id>
			<cfinclude template="../hr/query/get_position_cat.cfm">
			<cfset position_cat = "#get_position_cat.position_cat#">
		</cfif>
		<cfinclude template="../hr/query/get_moneys.cfm">
		<cfquery name="get_relation_assign" datasource="#dsn#">
            SELECT PERSONEL_ASSIGN_ID FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_REQ_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_req_id#">
        </cfquery>
        <cfif x_related_forms eq 1>
			<cfquery name="get_emp_quizes" datasource="#dsn#">
                SELECT QUIZ_ID,QUIZ_HEAD FROM EMPLOYEE_QUIZ WHERE IS_SHOW = 1
            </cfquery>
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		//Sirket- Sube- Departman Filtresine Gore Sonuc Doner
		function showRelation(field_id,relation_name,relation_name2,type)	
		{
			field_length = eval('document.getElementById("' + relation_name + '")').options.length;
			if(field_length > 0)
				for(jj=field_length;jj>=0;jj--)
					eval('document.getElementById("' + relation_name + '")').options[jj+1]=null;
					
			if(relation_name2 != "")
			{
				field_length = eval('document.getElementById("' + relation_name2 + '")').options.length;
				if(field_length > 0)
					for(jj=field_length;jj>=0;jj--)
						eval('document.getElementById("' + relation_name2 + '")').options[jj+1]=null;
			}
		
			if(field_id != "")
			{
				if (type == 1)
					var get_relation_table = wrk_query("SELECT BRANCH_ID RELATED_ID,BRANCH_NAME RELATED_NAME FROM BRANCH WHERE BRANCH_STATUS =1 AND COMPANY_ID = "+ field_id +" ORDER BY BRANCH_NAME","dsn");
				else
					var get_relation_table = wrk_query("SELECT DEPARTMENT_ID RELATED_ID,DEPARTMENT_HEAD RELATED_NAME FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = "+ field_id +" ORDER BY DEPARTMENT_HEAD","dsn");
				
				if(get_relation_table.recordcount > 0)
					for(xx=0;xx<get_relation_table.recordcount;xx++)
						eval('document.getElementById("' + relation_name + '")').options[xx+1]=new Option(get_relation_table.RELATED_NAME[xx],get_relation_table.RELATED_ID[xx]);
			}
		}
		
		function send_print_choice()
		{
			print_form_list = "";
			<cfif get_form.recordcount eq 1>
				if(document.form_print_all.print_form_choice.checked == false)
				{
					alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
					return false;
				}
				else
				{
					print_form_list = document.form_print_all.print_form_choice.value;
				}
			<cfelseif get_form.recordcount gt 1>
				for (i=0; i < document.form_print_all.print_form_choice.length; i++)
				{
					if(document.form_print_all.print_form_choice[i].checked == true)
					{
						print_form_list = print_form_list + document.form_print_all.print_form_choice[i].value + ',';
					}
				}
			</cfif>
			if(print_form_list.length == 0)
			{
				alert("En Az Bir Seçim Yapmalısınız!");
				return false;
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_requirement&action=print&id='+print_form_list+'&module=<cfoutput>#ListFirst(attributes.fuseaction,'.')#</cfoutput>&iframe=1&trail=0','page');
				return false;
			}
		}
		function send_check_all()
		{
				
			all_count = "<cfoutput><cfif get_form.recordcount lte attributes.maxrows>#get_form.recordcount#<cfelse>#attributes.maxrows#</cfif></cfoutput>";
			if(all_count > 1)
				for(cc=0;cc<all_count;cc++)
					document.form_print_all.print_form_choice[cc].checked = document.getElementById("all_choice").checked;
			else if(all_count == 1)
				document.form_print_all.print_form_choice.checked = document.getElementById("all_choice").checked;
		}
	<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		<cfif isdefined("attributes.event") and attributes.event is 'add'>
			$(document).ready(function() {
				gizle(language_info);
				gizle(arac_modeli);
				gizle(personel_detail_other_info);
			});
			row_count=0;
			function lang_info()
			{
				if(document.add_form.language[0].checked)
					goster(language_info);
				else
					gizle(language_info);
			}
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
			$(document).ready(function() {
				<cfif ListFind(get_per_req.language,0)>
					gizle(language_info);
				</cfif>
				<cfif get_per_req.vehicle_req eq 0>
					gizle(arac_modeli);
				</cfif>
				<cfif listfindnocase('2,6',get_per_req.form_type,',')>
					gizle(ek_kadro);
				</cfif>
			});
			
			row_count="<cfoutput>#ListLen(get_per_req.language_id,',')#</cfoutput>";
			function lang_info(x)
			{
				gizle(language_info);
				if(x == 1)
					goster(language_info);
				else
					gizle(language_info);
			}
		</cfif>
		function CheckLen(Target,limit) 
		{
			StrLen = Target.value.length;
			if (StrLen == 1 && Target.value.substring(0,1) == " ") 
			{
				Target.value = "";
				StrLen = 0;
			}
			if (StrLen > limit ) 
			{
				Target.value = Target.value.substring(0,limit);
				CharsLeft = 0;
				alert("<cf_get_lang_main no ='1362.Maksimum açiklama uzunlugu'>" + ":" + limit);
			}
			else 
			{
				CharsLeft = StrLen;
			}
		}
		
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
		
			newRow = document.getElementById('table_lang').insertRow();
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			
			document.getElementById('record_num').value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><select name="language_id'+row_count+'" id="language_id'+row_count+'" style="width:150px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="knowlevel_id'+row_count+'" id="knowlevel_id'+row_count+'" style="width:150px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="icon-trash-o" title="Sil"></i></a>';							
		}
		
		function sil(sy)
		{
			var my_element=eval("add_form.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
		
		function kontrol()
		{
			if(!(document.add_form.form_type[0].checked == true || document.add_form.form_type[1].checked) == true)
			{
				document.add_form.is_organization_change.checked = false;
				document.add_form.is_volume_of_business.checked = false;
				document.add_form.volume_business_min.value = "";
				document.add_form.volume_business_max.value = "";
				document.add_form.is_new_project.checked = false;
				document.add_form.is_number_of_transactions.checked = false;
				document.add_form.transaction_number_min.value = "";
				document.add_form.transaction_number_max.value = "";
				document.add_form.additional_staff_detail.value = "";
			}			
			if($('#personel_other').val() == '')
			{
				alert('Görüş Girmelisiniz!');
				return false;
			}
			/*	Eski-Yeni	0-2		1-0		2-1		3-4		4-3		5-5		*/
			<cfif (not (x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)) and attributes.event is 'upd') or attributes.event is 'add'>
			if(document.add_form.vehicle_req[0].checked && $('#vehicle_req_model').val() == '')
			{
				alert('Araç Modeli Girmelisiniz!');
				return false;
			}		
			if(document.add_form.form_type[2].checked || document.add_form.form_type[5].checked)
			{
				if($('#old_personel_name').val() == '')
			  	{
			   	 	alert('İlgili Pozisyon Çalışanını Giriniz!');
					return false;
				}
				if($('#old_personel_position').val()=='')
			  	{
			    	alert('İlgili Pozisyon Giriniz!');
					return false;
				}
				<cfif attributes.event is 'add'>
					if($('#old_personel_finishdate').val()=='')
				  	{
				    	alert('İlgili Pozisyon Çıkış Tarihi Giriniz!');
						return false;
					}
				</cfif>
			}
			if(document.add_form.form_type[4].checked)
			{
				if($('#change_personel_name').val()=='')
			  	{
					alert('İlgili Pozisyon Çalışanını Giriniz!');
					return false;
				}
				if($('#change_personel_position').val()=='')
			  	{
					alert('İlgili Pozisyon Giriniz!');
					return false;
				}
				<cfif attributes.event is 'add'>
					if($('#change_personel_finishdate').val()=='')
				  	{
				    	alert('İlgili Pozisyon Çıkış Tarihi Giriniz!');
						return false;
					}
				</cfif>
			}
			if(document.add_form.form_type[3].checked)
			{
				if($('#transfer_personel_name').val()=='')
			  	{
					alert('İlgili Pozisyon Çalışanını Giriniz!');
					return false;
				}
				if($('#transfer_personel_position').val()=='')
			  	{
					alert('İlgili Pozisyon Giriniz!');
					return false;
				}
				<cfif attributes.event is 'add'>
					if($('#transfer_personel_startdate').val()=='')
				  	{
				    	alert('İlgili Pozisyon Çıkış Tarihi Giriniz!');
						return false;
					}
				</cfif>
			}
			if($('#personal_age_max').val() <= $('#personal_age_min').val())
			{
				alert("<cf_get_lang no='33.Yas araligi düzgün girilmedi'>!");
				return false;
			}
			</cfif>
			if(process_cat_control())
			{
				if(add_form.min_salary != undefined) add_form.min_salary.value = filterNum(add_form.min_salary.value);
				if(add_form.max_salary != undefined) add_form.max_salary.value = filterNum(add_form.max_salary.value);
				return true;
			}
			else
				return false;
		}
		
		function arac_talebi()
		{
			gizle(arac_modeli);
			if(document.add_form.vehicle_req[0].checked)
				goster(arac_modeli);
			else
				gizle(arac_modeli);
		}
		
		function gizleme_islemi()
		{
			gizle(ilgili_header_);
			gizle(ilgili_2);
			gizle(ilgili_3);
			gizle(belirsiz_header);
			gizle(belirsiz_1);
			gizle(belirsiz_2);
			gizle(position_header);
			gizle(position_1);
			gizle(position_2);
			gizle(position_3);
			gizle(nakil_header);
			gizle(nakil_1);
			gizle(nakil_2);
			gizle(nakil_3);
			gizle(personel_detail_other_info);
			gizle(ek_kadro);
			
			/*
				form_type;
				1: Ayrilan Kisinin Yerine
				2: Ek Kadro Süresiz (Default)
				3: Pozisyon Degisikligi Yapan Personelin Yerine
				4: Nakil Olan Personelin Yerine
				5: Emeklilik Nedeniyle Çikis / Giris Yapan Personelin Yerine
				6: Ek Kadro Süreli
			*/
		
			if(document.add_form.form_type[2].checked || document.add_form.form_type[5].checked) 
			{
				goster(ilgili_2);
				goster(ilgili_3);
				goster(belirsiz_header);
				goster(belirsiz_1);
				goster(belirsiz_2);
				goster(nakil_3);
				if(document.add_form.old_personel_detail[4].checked)
					goster(personel_detail_other_info);
			}
			if(document.add_form.form_type[1].checked)
			{
				goster(belirsiz_header);
				goster(belirsiz_1);
				goster(belirsiz_2);
			}
			if(document.add_form.form_type[4].checked)
			{
				goster(position_header);
				goster(position_1);
				goster(position_2);
				goster(position_3);
				goster(belirsiz_header);
				goster(belirsiz_1);
				goster(belirsiz_2);
			}
			if(document.add_form.form_type[3].checked)
			{
				goster(nakil_header);
				goster(nakil_1);
				goster(nakil_2);
				goster(nakil_3);
				goster(belirsiz_header);
				goster(belirsiz_1);
				goster(belirsiz_2);
			}
			if(document.add_form.form_type[0].checked || document.add_form.form_type[1].checked)
			{
				goster(ek_kadro);
			}
			
		}
		$(document).ready(function() {	
			gizleme_islemi();
		});
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_personel_requirement_form';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_personel_requirement_form.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_personel_requirement_form';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_personel_requirement_form.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_personel_requirement_form.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#ListFirst(attributes.fuseaction,".")#.list_personel_requirement_form&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_personel_requirement_form';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_personel_requirement_form.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_personel_requirement_form.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#ListFirst(attributes.fuseaction,".")#.list_personel_requirement_form&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'per_req_id=##attributes.per_req_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.per_req_id##';
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_personel_requirement_form&per_req_id=#attributes.per_req_id#&cat=#get_per_req.per_req_stage#&head=#get_per_req.personel_requirement_head#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_personel_requirement_form.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_personel_requirement_form.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#ListFirst(attributes.fuseaction,".")#.list_personel_requirement_form';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_name=per_req_id&action_id=#attributes.per_req_id#','list');";
		i = 1;
		if (get_module_user(3))
		{
			if (get_relation_assign.recordcount)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1786]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.from_upd_personel_assign_form&per_assign_id=#get_relation_assign.personel_assign_id#";
				i = i + 1;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[888]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=hr.popup_upd_per_form_autority&per_req_id=#attributes.per_req_id#','list');";
			i = i + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1447]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_notice&event=add&per_req_id=#attributes.per_req_id#";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_requirement&action=print&id=#attributes.per_req_id#&module=#ListFirst(attributes.fuseaction,'.')#&iframe=1&trail=0','page');return false;";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListPersonelRequirementForm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PERSONEL_REQUIREMENT_FORM';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-req_head','item-our_company','item-position_cat','item-personel_count','item-personel_exp','item-vehicle_req','item-personel_other']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
