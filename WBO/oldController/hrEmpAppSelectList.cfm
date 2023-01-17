<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="is_filtered" default="0">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.status" default="1">
	<cfparam name="attributes.record_date" default="">
	<cfparam name="attributes.record_date2" default="">
	<cfparam name="attributes.list_stage" default="">
	<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.emp_app_select_list%">
	</cfquery>
	<cfif is_filtered>
		<cfif isdate(attributes.record_date)>
			<cf_date tarih = "attributes.record_date">
		</cfif>
		<cfif isdate(attributes.record_date2)>
			<cf_date tarih = "attributes.record_date2">
		</cfif>
		<cfquery name="get_list" datasource="#dsn#">
			SELECT
				EL.LIST_ID,
				EL.LIST_NAME,
				EL.LIST_DETAIL,
				EL.LIST_STATUS,
				EL.NOTICE_ID,
				EL.OUR_COMPANY_ID,
				EL.DEPARTMENT_ID,
				EL.BRANCH_ID,
				EL.COMPANY_ID,
				EL.RECORD_DATE,
				EL.RECORD_EMP,
				EL.SEL_LIST_STAGE,
				COUNT(ER.LIST_ROW_ID) SATIR_SAYISI,
				N.NOTICE_NO,
				N.NOTICE_HEAD,
				B.BRANCH_NAME,
				C.FULLNAME,
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS RECORD_EMP_NAME,
				PTR.STAGE
			FROM
				EMPLOYEES_APP_SEL_LIST EL
				INNER JOIN EMPLOYEES_APP_SEL_LIST_ROWS ER ON ER.LIST_ID = EL.LIST_ID
				LEFT JOIN NOTICES N ON N.NOTICE_ID = EL.NOTICE_ID
				LEFT JOIN BRANCH B ON B.BRANCH_ID = EL.BRANCH_ID
				LEFT JOIN COMPANY C ON C.COMPANY_ID = EL.COMPANY_ID
				LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EL.RECORD_EMP
				LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EL.SEL_LIST_STAGE
			WHERE
				1=1
				<cfif isdefined("list_authority")><!---myhome da yetkisi olan listeleri görsün--->
					AND EL.LIST_ID IN (#list_authority#)
				</cfif>
				<cfif len(attributes.keyword)>
					AND EL.LIST_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.status)>
					AND EL.LIST_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
				</cfif>
				<cfif isdefined('attributes.notice_head') and len(attributes.notice_head) and len(attributes.notice_id)>
					AND EL.NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
				</cfif>
				<cfif isdefined('attributes.company_id') and isdefined('attributes.company') and len(attributes.company)>
					AND EL.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined('attributes.branch_id') and isdefined('attributes.branch') and len(attributes.branch)>
					AND EL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				</cfif>
				<cfif isdefined('attributes.position_cat') and isdefined('attributes.position_cat_id') and len(attributes.position_cat)>
					AND EL.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
				</cfif>
				<cfif isdefined('attributes.position') and isdefined('attributes.position_id') and len(attributes.position)>
					AND EL.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
				</cfif>
				<cfif isdate(attributes.record_date)>
					AND EL.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
				</cfif>
				<cfif isdate(attributes.record_date2)>
					AND EL.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(dateadd('d',1,attributes.record_date2))#">
				</cfif>
			GROUP BY
				EL.LIST_ID,
				EL.LIST_NAME,
				EL.LIST_DETAIL,
				EL.LIST_STATUS,
				EL.NOTICE_ID,
				EL.OUR_COMPANY_ID,
				EL.DEPARTMENT_ID,
				EL.BRANCH_ID,
				EL.COMPANY_ID,
				EL.RECORD_DATE,
				EL.RECORD_EMP,
				EL.SEL_LIST_STAGE,
				N.NOTICE_NO,
				N.NOTICE_HEAD,
				B.BRANCH_NAME,
				C.FULLNAME,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				PTR.STAGE
			ORDER BY 
				EL.RECORD_DATE DESC 
		</cfquery>
	<cfelse>
		<cfset get_list.recordcount = 0>
	</cfif>

	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#get_list.recordcount#">
	<cfscript>
		if (isdate(attributes.record_date))
			attributes.record_date = dateformat(attributes.record_date, "dd/mm/yyyy");
		else
			attributes.record_date = '';
		if (isdate(attributes.record_date2) and isdate(attributes.record_date2))
			attributes.record_date2 = dateformat(attributes.record_date2, "dd/mm/yyyy");
		else
			attributes.record_date2 = '';
		attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#";
	    if (isdefined('attributes.company') and len(attributes.company)) 
	        url_str="#url_str#&company_id=#attributes.company_id#";
	    if (isdefined('attributes.notice_head') and len(attributes.notice_head))
	        url_str="#url_str#&notice_head=#attributes.notice_head#&notice_id=#attributes.notice_id#";
	    if (isdefined('attributes.branch') and len(attributes.branch))
	        url_str="#url_str#&branch=#attributes.branch#&branch_id=#attributes.branch_id#";
	    if (isdefined('attributes.position') and len(attributes.position))
	        url_str="#url_str#&position=#attributes.position#&position_id=#attributes.position_id#";
	    if (isdefined('attributes.position_cat') and len(attributes.position_cat))
	        url_str="#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#";
	    if (len('attributes.record_date'))
	        url_str="#url_str#&record_date=#attributes.record_date#";
	    if (len('attributes.record_date2'))
	        url_str="#url_str#&record_date2=#attributes.record_date2#";
	    if (isdefined('attributes.is_filtered'))
	        url_str="#url_str#&is_filtered=#attributes.is_filtered#";
	    if (len('attributes.list_stage'))
	        url_str="#url_str#&list_stage=#attributes.list_stage#";
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfquery name="GET_LIST" datasource="#dsn#">
		SELECT
			SL.BRANCH_ID,
			SL.COMPANY_ID,
			SL.DEPARTMENT_ID,
			SL.LIST_DETAIL,
			SL.LIST_NAME,
			SL.LIST_STATUS,
			SL.NOTICE_ID,
			SL.PIF_ID,
			SL.POSITION_CAT_ID,
			SL.POSITION_ID,
			SL.RECORD_DATE,
			SL.RECORD_EMP,
			SL.SEL_LIST_STAGE,
			SL.UPDATE_DATE,
			SL.UPDATE_EMP,
			N.NOTICE_HEAD,
			N.NOTICE_NO,
			PTR.STAGE,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			EP.POSITION_NAME + ' - ' + EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS APP_POSITION,
			SPC.POSITION_CAT
		FROM 
			EMPLOYEES_APP_SEL_LIST SL
			LEFT JOIN NOTICES N ON N.NOTICE_ID = SL.NOTICE_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = SL.SEL_LIST_STAGE
			LEFT JOIN BRANCH B ON B.COMPANY_ID = SL.COMPANY_ID AND B.BRANCH_ID = SL.BRANCH_ID
			LEFT JOIN DEPARTMENT D ON D.BRANCH_ID = B.BRANCH_ID AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = SL.POSITION_ID
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = SL.POSITION_CAT_ID
		WHERE 
			LIST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_id#">
	</cfquery>
	
	<cfparam name="attributes.row_status" default="1">
	<cfparam name="attributes.row_order" default="">
	<cfquery name="get_emp_app" datasource="#dsn#">
		SELECT
			LR.LIST_ROW_ID,
			LR.EMPAPP_ID,
			ISNULL(LR.APP_POS_ID,0) APP_POS_ID,
			LR.ROW_STATUS,
			EA.NAME,
			EA.SURNAME,
			LR.RECORD_DATE,
			LR.RECORD_EMP,
			LR.STAGE,
			EA.APP_COLOR_STATUS,
			EA.WORK_STARTED,
			EA.WORK_FINISHED,
			EAEI.EDU_NAME AS EDU_NAME,
			EAEI.EDU_PART_NAME AS EDU_PART_NAME,
			EI.BIRTH_DATE,
			(SELECT TOP 1 EXP FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = LR.EMPAPP_ID ORDER BY EXP_START DESC) EXP,
			(SELECT TOP 1 EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = LR.EMPAPP_ID ORDER BY EXP_START DESC) EXP_POSITION,
			(SELECT TOP 1 EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = LR.EMPAPP_ID ORDER BY EXP_START DESC) EXP_FINISH,
			PTR.STAGE STAGE_NAME,
			SCS.STATUS,
			SCS.ICON_NAME
		FROM
			EMPLOYEES_APP_SEL_LIST_ROWS AS LR
			INNER JOIN EMPLOYEES_APP EA ON LR.EMPAPP_ID = EA.EMPAPP_ID
			INNER JOIN EMPLOYEES_APP_EDU_INFO EAEI ON EA.EMPAPP_ID = EAEI.EMPAPP_ID
			LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPAPP_ID = LR.EMPAPP_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = LR.STAGE
			LEFT JOIN SETUP_CV_STATUS SCS ON SCS.STATUS_ID = EA.APP_COLOR_STATUS
		WHERE
			LR.LIST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_id#">
			AND EAEI.EMPAPP_EDU_ROW_ID IN( SELECT MAX(EMPAPP_EDU_ROW_ID) FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEES_APP_EDU_INFO.EMPAPP_ID = EAEI.EMPAPP_ID)
			<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
				AND ROW_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.row_status#">
			</cfif>
	UNION
		SELECT
			LR.LIST_ROW_ID,
			LR.EMPAPP_ID,
			ISNULL(LR.APP_POS_ID,0) APP_POS_ID,
			LR.ROW_STATUS,
			EA.NAME,
			EA.SURNAME,
			LR.RECORD_DATE,
			LR.RECORD_EMP,
			LR.STAGE,
			EA.APP_COLOR_STATUS,
			EA.WORK_STARTED,
			EA.WORK_FINISHED,
			'' AS EDU_NAME,
			'' AS EDU_PART_NAME,
			EI.BIRTH_DATE,
			(SELECT TOP 1 EXP FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = LR.EMPAPP_ID ORDER BY EXP_START DESC) EXP,
			(SELECT TOP 1 EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = LR.EMPAPP_ID ORDER BY EXP_START DESC) EXP_POSITION,
			(SELECT TOP 1 EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = LR.EMPAPP_ID ORDER BY EXP_START DESC) EXP_FINISH,
			PTR.STAGE STAGE_NAME,
			SCS.STATUS,
			SCS.ICON_NAME
		FROM
			EMPLOYEES_APP_SEL_LIST_ROWS AS LR
			INNER JOIN EMPLOYEES_APP EA ON LR.EMPAPP_ID=EA.EMPAPP_ID
			LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPAPP_ID = LR.EMPAPP_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = LR.STAGE
			LEFT JOIN SETUP_CV_STATUS SCS ON SCS.STATUS_ID = EA.APP_COLOR_STATUS
		WHERE
			LR.LIST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_id#">
			AND EA.EMPAPP_ID NOT IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEES_APP_EDU_INFO.EMPAPP_ID = EA.EMPAPP_ID)
			<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
				AND ROW_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.row_status#">
			</cfif> 
		ORDER BY
			<cfif len(attributes.row_order)>
				<cfif attributes.row_order eq 1>
				EA.NAME
				<cfelseif attributes.row_order eq 2>
				EA.NAME DESC
				<cfelseif attributes.row_order eq 3>
				EA.SURNAME
				<cfelseif attributes.row_order eq 4>
				EA.SURNAME DESC
				<cfelseif attributes.row_order eq 5>
				EDU_NAME
				<!--- EA.EDU1, EA.EDU2, EA.EDU3, EA.EDU4, EA.EDU5, EA.NAME --->
				<cfelseif attributes.row_order eq 6>
				LR.STAGE DESC,EA.NAME
				</cfif>
			<cfelse>
				EA.NAME
			</cfif>
	</cfquery>
	<cfquery name="get_count_list_row" datasource="#dsn#">
		SELECT
			COUNT(ROW_STATUS) TOPLAM,
			ROW_STATUS
		FROM
			EMPLOYEES_APP_SEL_LIST_ROWS
		WHERE
			LIST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_id#">
		GROUP BY
			LIST_ID,ROW_STATUS
	</cfquery>
	<cfset pasif_row=0>
	<cfset aktif_row=0>
	<cfoutput query="get_count_list_row">
		<cfif get_count_list_row.row_status eq 1>
			<cfset aktif_row=get_count_list_row.toplam>
		<cfelse>
			<cfset pasif_row=get_count_list_row.toplam>
		</cfif>
	</cfoutput> 
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#get_emp_app.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset url_str = "&list_id=#attributes.list_id#&row_status=#attributes.row_status#&row_order=#attributes.row_order#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_list'>
	<cfquery name="get_list" datasource="#dsn#">
		SELECT
			EAS.BRANCH_ID,
			EAS.COMPANY_ID,
			EAS.DEPARTMENT_ID,
			EAS.LIST_DETAIL,
			EAS.LIST_NAME,
			EAS.LIST_STATUS,
			EAS.NOTICE_ID,
			EAS.OUR_COMPANY_ID,
			EAS.PIF_ID,
			EAS.POSITION_ID,
			EAS.POSITION_CAT_ID,
			EAS.RECORD_DATE,
			EAS.RECORD_EMP,
			EAS.SEL_LIST_STAGE,
			EAS.UPDATE_DATE,
			EAS.UPDATE_EMP,
			EP.POSITION_NAME + ' - ' + EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS APP_POSITION,
			SPC.POSITION_CAT,
			PRF.PERSONEL_REQUIREMENT_HEAD,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			N.NOTICE_HEAD,
			N.NOTICE_NO
		FROM
			EMPLOYEES_APP_SEL_LIST EAS
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EAS.POSITION_ID
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EAS.POSITION_CAT_ID
			LEFT JOIN PERSONEL_REQUIREMENT_FORM PRF ON PRF.PERSONEL_REQUIREMENT_ID = EAS.PIF_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EAS.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON B.COMPANY_ID = EAS.OUR_COMPANY_ID AND B.BRANCH_ID = EAS.BRANCH_ID AND B.BRANCH_ID = D.BRANCH_ID
			LEFT JOIN NOTICES N ON N.NOTICE_ID = EAS.NOTICE_ID
		WHERE 
			EAS.LIST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_id#">
	</cfquery>
	
	<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_WARNINGS 
		ORDER BY 
			SETUP_WARNING
	</cfquery>

    <cfquery name="get_authority" datasource="#DSN#">
        SELECT 
            SLA.*,
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME
        FROM
            EMPLOYEES_APP_AUTHORITY SLA
            INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = SLA.POS_CODE
        WHERE
            LIST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_id#"> AND
            SLA.AUTHORITY_STATUS = 1
    </cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function satir_kontrol()
		{
			error_ = 1;
			if(select_list.list_row_id.length>0)
			{
				for(i=0;i<select_list.list_row_id.length;i++)
				if(select_list.list_row_id[i].checked == true)
				{
					error_ = 0;
				}
			}
			else if (select_list.list_row_id.checked == true)
			{
				error_ = 0;
			}
			if(error_==1)
			{
				alert('<cf_get_lang no="967.Listeden Satır Seçmelisiniz">');
				return false;
			}
			return true;
		}
		function kontrol_row()
		{
			if(satir_kontrol())
			{
				$('#del').val('1');
				return process_cat_control();
			}
			else
			{
				return false;
			}
		}
		
		function kontrol_row2()
		{
			if(satir_kontrol())
				return process_cat_control();
			else
				return false;
		}
		function hepsi()
		{
			var check_len = document.getElementsByName('_list_row_id_').length;
			for(cl=0;cl<check_len;cl++)
			document.getElementsByName('_list_row_id_')[cl].checked = (document.getElementById('all_check').checked)?true:false;
		}
		function send_mail()
		{
			windowopen('','list','select_list_window');
			select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_app_add_mail&mail_sum=1&list_id=#attributes.list_id#</cfoutput>';
			select_list.target='select_list_window';select_list.submit();
		}
		function start_work()
		{
			if(document.getElementById('_list_row_id_')!=undefined)
			{
				if(document.getElementById('_list_row_id_').length>0)
				{
					var ayirac='';
					for(i=0;i<document.getElementById('_list_row_id_').length;i++)
						if(document.select_list.list_row_id[i].checked == true)
						{
							select_list.list_app_pos_id.value=select_list.list_app_pos_id.value+ayirac+select_list.app_pos_id[i].value;
							ayirac=',';
						}
					if(ayirac==',')
					{
						windowopen('','list','select_list_window');
						select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_app_test_time&list_id=#attributes.list_id#&process_stage_='+document.getElementById('process_stage').value+'&toplu=1</cfoutput>';
						select_list.target='select_list_window';
						select_list.submit();
						select_list.list_app_pos_id.value='';
						return true;
					}
					else
					{
						alert("<cf_get_lang no='967.Listeden Satır Seçmelisiniz'>");
						return false;
					}
				}
				else
				{
					if(document.getElementById('_list_row_id_').checked == true)
					{
						windowopen('','list','select_list_window');
						select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_app_test_time&list_id=#attributes.list_id#&process_stage_='+document.getElementById('process_stage').value+'&toplu=1</cfoutput>';
						select_list.target='select_list_window';
						select_list.submit();
						select_list.list_app_pos_id.value='';
						return true;
					}
					else
					{
						alert("<cf_get_lang no='967.Listeden Satır Seçmelisiniz'>");
						return false;
					}
				}
			}
			else
			{
				alert("Kişi Seçiniz");
				return false;
			}
		}
			  
		function edit_app_color()
		{
			<cfif get_emp_app.recordcount>
				<cfif get_emp_app.recordcount gt 1> 
					if(select_list.list_row_id!=undefined)
						for(z=0;z<select_list.list_row_id.length;z++)
						{
							if(document.select_list.cv_status[z].value == 1)
							{
								if(document.select_list.list_row_id[z]!=undefined && document.select_list.list_row_id[z].checked)
								{
									if(document.getElementById('_list_row_id_').length==0) ayirac=''; else ayirac=',';
									document.getElementById('_list_row_id_').value=document.getElementById('_list_row_id_').value+ayirac+document.select_list.list_row_id[z].value;
								}
							}
						}
				<cfelse>
					if(document.getElementById('_list_row_id_')!=undefined && document.getElementById('_list_row_id_').checked)
					{
						$('#_list_row_id_').val($('#_list_row_id_').val());
					}
				</cfif>
					windowopen('','small','select_list_window');
					select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_list_app_color_status&is_sel_list=1</cfoutput>';
					select_list.target='select_list_window';
					select_list.submit();
			<cfelse>
				alert("<cf_get_lang_main no ='72.Kayıt Yok'>!")
			</cfif>
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd_list'>
		function kontrol()
		{
			if (upd_list.list_detail.value.length>250)
			{
				alert("<cf_get_lang no='968.Detay Alanı 250 Karakterden Fazla Olamaz'>");
				return false;
			}
			return 	process_cat_control();
		}
		
		row_count=0;
		main_row_count=0;
		function sil(sy)
		{
			for(i=sy;i<sy+5;i++){
				var my_element=eval("upd_list.row_kontrol"+i);
				my_element.value=0;
		
				var my_element=eval("frm_row"+i);
				my_element.style.display="none";		
			}
			document.getElementById('record_count').value=parseInt(document.getElementById('record_count').value)-1;
		}
		
		function add_row()
		{
			row_count++;
			main_row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
						
			document.getElementById('record_num').value=row_count;
			document.getElementById('record_count').value=parseInt(document.getElementById('record_count').value)+1;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","td_" + row_count);
			newCell.innerHTML = '<hr size="1" color="#000066"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
			eval("td_" + row_count).colSpan = 5;
			
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","yetkili_" + row_count);
			newCell.innerHTML = '<cf_get_lang_main no="166.Yetkili">*';
			eval("yetkili_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","talep_" + row_count);
			newCell.innerHTML = 'Talep*';
			eval("talep_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","aciklama_" + row_count);
			newCell.innerHTML = 'Açıklama';
			eval("aciklama_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<i class="icon-trash-o btnPointer" onclick="sil(' + (row_count - 1) + ');" ></i><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
		
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","yetkili_in_" + row_count);
			eval("yetkili_in_" + row_count).colSpan = 2;
			newCell.innerHTML = '<input type="text" name="employee' + main_row_count + '" style="width:150px;"><i class="icon-ellipsis btnPointer" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_list.position_code" + main_row_count + "&field_name=upd_list.employee" + main_row_count + "','list');"+'"></i><input type="hidden" name="position_code' + main_row_count + '">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","talep_in_" + row_count);
			eval("talep_in_" + row_count).colSpan = 2;
			newCell.innerHTML = '<select name="warning_head' + main_row_count + '" style="width:165px;"><cfoutput query="GET_SETUP_WARNING"><option value="#SETUP_WARNING#--#SETUP_WARNING_ID#">#SETUP_WARNING#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","aciklama_in_" + row_count);
			eval("aciklama_in_" + row_count).colSpan = 2;
			newCell.innerHTML = '<input type="text" name="warning_description' + main_row_count + '" style="width:150px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
		
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","son_cevap_" + row_count);
			newCell.innerHTML = 'Son Cevap *';
			eval("son_cevap_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","SMS_" + row_count);
			newCell.innerHTML = 'SMS';
			eval("SMS_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","email_" + row_count);
			newCell.innerHTML = 'Email Uyarı';
			eval("email_" + row_count).colSpan = 2;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
		
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			
			document.getElementById('record_num').value=row_count;
			
		 	newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","response_date" + main_row_count + "_td");
			newCell.innerHTML = '<input type="text" name="response_date' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput>">';
			wrk_date_image('response_date' + main_row_count);
			
			newCell = newRow.insertCell(newRow.cells.length);
			HTMLStr = '<select name="response_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
			HTMLStr = HTMLStr + '<select name="response_min' + main_row_count + '" style="width:37px;;"><option value="00" selected>00</option>';
			HTMLStr = HTMLStr + '<option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option>';
			HTMLStr = HTMLStr + '<option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
			HTMLStr = HTMLStr + '</select>';
			newCell.innerHTML = HTMLStr;
			
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","sms_startdate" + main_row_count + "_td");
			newCell.innerHTML = '<input type="text" name="sms_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput>">';
			wrk_date_image('sms_startdate' + main_row_count);
		
			newCell = newRow.insertCell(newRow.cells.length);
			HTMLStr = '<select name="sms_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
			HTMLStr = HTMLStr + '<select name="sms_start_min' + main_row_count + '" style="width:37px;;">';
			HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
			HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
			HTMLStr = HTMLStr + '</select>';
			newCell.innerHTML = HTMLStr;
		
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","email_startdate" + main_row_count + "_td");
			newCell.innerHTML = '<input type="text" name="email_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), "DD/MM/YYYY")#</cfoutput>">';
			wrk_date_image('email_startdate' + main_row_count);
		
		 	newCell = newRow.insertCell(newRow.cells.length);	
		 	HTMLStr = '<select name="email_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
			HTMLStr = HTMLStr + '<select name="email_start_min' + main_row_count + '" style="width:37px;;">';
			HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
			HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
			HTMLStr = HTMLStr + '</select>';
			newCell.innerHTML = HTMLStr;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.emp_app_select_list';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_emp_app_select_list.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.emp_app_select_list';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_emp_app_select_list.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_emp_app_select_list_rows.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.emp_app_select_list&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'list_id=##attributes.list_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_list.list_name##';
	
	WOStruct['#attributes.fuseaction#']['upd_list'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_list']['fuseaction'] = 'hr.emp_app_select_list';
	WOStruct['#attributes.fuseaction#']['upd_list']['filePath'] = 'hr/form/upd_select_list.cfm';
	WOStruct['#attributes.fuseaction#']['upd_list']['queryPath'] = 'hr/query/upd_emp_app_select_list.cfm';
	WOStruct['#attributes.fuseaction#']['upd_list']['nextEvent'] = 'hr.emp_app_select_list&event=upd';
	WOStruct['#attributes.fuseaction#']['upd_list']['parameters'] = 'list_id=##attributes.list_id##';
	WOStruct['#attributes.fuseaction#']['upd_list']['Identity'] = '##get_list.list_name##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emp_app_select_list';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_emp_app_select_list.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_emp_app_select_list.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.emp_app_select_list';

	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=myhome.upd_emp_app_select_list&action_name=list_id&action_id=#attributes.list_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[957]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_del_select_list_empapp&list_id=#attributes.list_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[52]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=hr.emp_app_select_list&event=upd_list&list_id=#attributes.list_id#','medium');";
		/*tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = 'gg';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['customTag'] = "<cf_workcube_file_action is_ajax='1' pdf='1' mail='1' doc='1' print='1' tag_module='select_list_div'>";*/
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrEmpAppSelectList';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_APP_SEL_LIST_ROWS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-orientation_head','item-emp_name','item-start_date','item-finish_date']";
</cfscript>
