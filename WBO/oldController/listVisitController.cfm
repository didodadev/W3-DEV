<cf_get_lang_set module_name="sales">
<cfif (isdefined("attributes.event") and listfind('add,upd',attributes.event)) or not isdefined("attributes.event")>
	<cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT DISTINCT
            B.BRANCH_NAME,
            B.BRANCH_ID
        FROM
            BRANCH B,
            EMPLOYEE_POSITION_BRANCHES EPB
        WHERE
            B.BRANCH_ID = EPB.BRANCH_ID AND
            EPB.POSITION_CODE = #session.ep.position_code#
        ORDER BY
            B.BRANCH_NAME
    </cfquery>
    <cfif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
    	<cfquery name="GET_VISIT_TYPES" datasource="#DSN#">
            SELECT VISIT_TYPE_ID,VISIT_TYPE FROM SETUP_VISIT_TYPES ORDER BY VISIT_TYPE
        </cfquery>
    </cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="sales.list_visit">
    <cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.employee_name" default='#session.ep.name# #session.ep.surname#'>
    <cfparam name="attributes.finish_date" default="#dateformat(date_add('d',7,now()),'dd/mm/yyyy')#">
    <cfparam name="attributes.is_active" default='1'>
    <cfparam name="attributes.zone_director" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.search_project_id" default="">
    <cfparam name="attributes.project_name" default="">
    <cfparam name="attributes.search_emp_id" default='#session.ep.userid#'>
    <cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
    <cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
    <cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
        SELECT
            EMPLOYEE_POSITIONS.EMPLOYEE_ID,
            EMPLOYEE_POSITIONS.POSITION_ID,
            EMPLOYEE_POSITIONS.POSITION_CODE,
            BRANCH.BRANCH_ID,
            BRANCH.BRANCH_NAME,
            DEPARTMENT.DEPARTMENT_ID,
            DEPARTMENT.DEPARTMENT_HEAD
        FROM
            EMPLOYEE_POSITIONS,
            DEPARTMENT,
            BRANCH
        WHERE
            EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
            AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
            AND EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfif isdefined("attributes.is_submitted")>
        <cfif x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
            <cfinclude template="../../member/query/get_ims_control.cfm">
        </cfif>
        <cfquery name="GET_EVENT_PLAN" datasource="#dsn#">
            SELECT
                EVENT_PLAN.EVENT_PLAN_ID,
                EVENT_PLAN.MAIN_START_DATE,
                EVENT_PLAN.MAIN_FINISH_DATE,
                EVENT_PLAN.SALES_ZONES,
                EVENT_PLAN.EVENT_PLAN_HEAD,
                EVENT_PLAN.EVENT_PLAN_ID,
                EVENT_PLAN.EVENT_STATUS,
                EVENT_PLAN.RECORD_EMP,
                EVENT_PLAN.ANALYSE_ID,
                EVENT_PLAN.CAMPAIGN_ID,
                EVENT_PLAN.SALES_ZONES_ID,
                EVENT_PLAN.EST_LIMIT,
                EVENT_PLAN.IMS_CODE_ID,
                PROCESS_TYPE_ROWS.STAGE,
                EVENT_PLAN.MONEY_CURRENCY,
                EVENT_PLAN.IS_WIEW_DEPARTMENT,
                EVENT_PLAN.IS_WIEW_BRANCH,
                EVENT_PLAN.VIEW_TO_ALL
            FROM
                EVENT_PLAN,
                PROCESS_TYPE_ROWS
            WHERE
                EVENT_PLAN.IS_SALES = 1 AND
                PROCESS_TYPE_ROWS.PROCESS_ROW_ID = EVENT_PLAN.EVENT_STATUS 
                <cfif len(attributes.keyword)>AND EVENT_PLAN.EVENT_PLAN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
                <cfif len(attributes.employee_name) and len(attributes.search_emp_id)>AND EVENT_PLAN.RECORD_EMP = #attributes.search_emp_id#</cfif>
                <cfif len(attributes.zone_director)>AND EVENT_PLAN.SALES_ZONES = #attributes.zone_director#</cfif>
                <cfif len(attributes.search_project_id) and len(attributes.project_name) and is_project eq 1>
                  AND EVENT_PLAN.EVENT_PLAN_ID IN 
                  (SELECT EVENT_PLAN_ID FROM EVENT_PLAN_ROW WHERE EVENT_PLAN_ROW.EVENT_PLAN_ID=EVENT_PLAN.EVENT_PLAN_ID AND PROJECT_ID=#attributes.search_project_id#) 	
                </cfif>
                <cfif len(attributes.start_date)>AND EVENT_PLAN.MAIN_START_DATE >= #attributes.start_date#</cfif>
                <cfif len(attributes.finish_date)>AND EVENT_PLAN.MAIN_FINISH_DATE <= #attributes.finish_date#</cfif>
                <cfif len(attributes.is_active)>AND EVENT_PLAN.IS_ACTIVE = #attributes.is_active#</cfif>
                <cfif x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
                    AND
                        (
                            (EVENT_PLAN.EVENT_PLAN_ID IN(SELECT EEP.EVENT_PLAN_ID FROM EVENT_PLAN_ROW EEP WHERE EEP.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))) OR
                            (EVENT_PLAN.EVENT_PLAN_ID IN(SELECT EEP.EVENT_PLAN_ID FROM EVENT_PLAN_ROW EEP WHERE EEP.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#)))
                        )	
                </cfif> 
                AND	
                (
                    (
                        (	
                            EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
                            EVENT_PLAN.IS_WIEW_DEPARTMENT IS NOT NULL AND
                            EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                            EVENT_PLAN.IS_WIEW_DEPARTMENT = #find_department_branch.department_id#
                        )
                        OR
                        (
                            EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
                            EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                            EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                            EVENT_PLAN.IS_WIEW_BRANCH = #find_department_branch.branch_id#
                        )
                        OR
                        (
                            EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
                            EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                            EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                        )
                    )
                    <cfif Get_Branch.RecordCount>
                    OR
                    (
                        EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
                        EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                        EVENT_PLAN.VIEW_TO_ALL IS NULL AND
                        EVENT_PLAN.SALES_ZONES  IN (#ListDeleteDuplicates(ValueList(Get_Branch.Branch_Id,','))#)
                    )
                    </cfif>
                )
            ORDER BY
                EVENT_PLAN.MAIN_START_DATE DESC
         </cfquery>
    <cfelse> 
        <cfset get_event_plan.recordcount = 0>
    </cfif> 
    <cfparam name='attributes.totalrecords' default='#get_event_plan.recordcount#'>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit fuseact="sales.form_add_visit">
    <cfif isdefined('attributes.visit_id') and len(attributes.visit_id)>
        <cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
            SELECT * FROM EVENT_PLAN WHERE EVENT_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.visit_id#">
        </cfquery>
    </cfif>
    <cfif isdefined('attributes.project_id') and len(attributes.project_id)>
        <cfquery name="get_project_head" datasource="#dsn#">
            SELECT  PRO_PROJECTS.PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#attributes.project_id#
        </cfquery>
    </cfif>
    <cfif isdefined('get_event_plan') and len(get_event_plan.analyse_id)>
        <cfquery name="GET_ANALYSIS" datasource="#DSN#">
            SELECT ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event_plan.analyse_id#">
        </cfquery>
    </cfif>
    <cfif isdefined('is_agenda_authority') and (is_agenda_authority eq 1)>
		<cfif isdefined('get_event_plan') and len(get_event_plan.record_emp)>
            <cfquery name="get_record_positions_code" datasource="#dsn#">
                SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event_plan.record_emp#">  AND IS_MASTER = 1
            </cfquery>
        </cfif>
        <cfif (isdefined('get_event_plan') and len(get_event_plan.record_emp) and isdefined('get_record_positions_code') and get_record_positions_code.recordcount) or isdefined('is_agenda_authority') and (is_agenda_authority eq 1)>
            <cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
                SELECT
                    EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                    EMPLOYEE_POSITIONS.POSITION_ID,
                    EMPLOYEE_POSITIONS.POSITION_CODE,
                    BRANCH.BRANCH_ID,
                    BRANCH.BRANCH_NAME,
                    DEPARTMENT.DEPARTMENT_ID,
                    DEPARTMENT.DEPARTMENT_HEAD,
                    BRANCH.COMPANY_ID
                FROM
                    EMPLOYEE_POSITIONS,
                    DEPARTMENT,
                    BRANCH
                WHERE
                    EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                    DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
                    <cfif isdefined('is_agenda_authority') and (is_agenda_authority eq 1)>
    	                EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                    <cfelse>
	                    EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_positions_code.position_code#">
                    </cfif>
            </cfquery>
        </cfif>
	</cfif>      
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="sales.form_add_visit">
    <cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
        SELECT
            EMPLOYEE_POSITIONS.EMPLOYEE_ID,
            EMPLOYEE_POSITIONS.POSITION_ID,
            EMPLOYEE_POSITIONS.POSITION_CODE,
            BRANCH.BRANCH_ID,
            BRANCH.BRANCH_NAME,
            DEPARTMENT.DEPARTMENT_ID,
            DEPARTMENT.DEPARTMENT_HEAD,
            BRANCH.COMPANY_ID
        FROM
            EMPLOYEE_POSITIONS,
            DEPARTMENT,
            BRANCH
        WHERE
            EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
            AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
            AND EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfquery name="GET_AGENDA_COMPANY" datasource="#DSN#">
        SELECT  DISTINCT
            SETUP_PERIOD.OUR_COMPANY_ID
        FROM
            EMPLOYEE_POSITION_PERIODS,
            EMPLOYEE_POSITIONS,
            SETUP_PERIOD
        WHERE
            EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITION_PERIODS.POSITION_ID
            AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            AND SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITION_PERIODS.PERIOD_ID
    </cfquery>
    <cfset my_comp_list = VALUELIST(GET_AGENDA_COMPANY.OUR_COMPANY_ID)>
    <cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            EVENT_PLAN LEFT JOIN
            EVENT_PLAN_COMPANY ON
            EVENT_PLAN.EVENT_PLAN_ID =  EVENT_PLAN_COMPANY.EVENT_PLAN_ID
        WHERE 
            EVENT_PLAN.EVENT_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.visit_id#">
            AND	
            (
                (
                    (	
                        EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
                        EVENT_PLAN.IS_WIEW_DEPARTMENT IS NOT NULL AND
                        EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                        EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
                        EVENT_PLAN.IS_WIEW_DEPARTMENT = #find_department_branch.department_id#
                    )
                    OR
                    (
                        EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
                        EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                        EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                        EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
                        EVENT_PLAN.IS_WIEW_BRANCH = #find_department_branch.branch_id#
                    )
                    OR
                    (
                        EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
                        EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                        EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
                        EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                    )
                    OR
                    (
                        EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
                        EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                        EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                        AND 
                        <cfif xml_multiple_comp>
                            (EVENT_PLAN.IS_VIEW_COMPANY IN (#my_comp_list#) 
                            AND EVENT_PLAN_COMPANY.COMPANY_ID IN (#my_comp_list#)) 
                        <cfelse>
                            EVENT_PLAN.IS_VIEW_COMPANY IN (#my_comp_list#)
                        </cfif>
                        
                    )
                )
                <cfif Get_Branch.RecordCount>
                OR
                (
                    EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
                    EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                    EVENT_PLAN.VIEW_TO_ALL IS NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
                    EVENT_PLAN.SALES_ZONES  IN (#ListDeleteDuplicates(ValueList(Get_Branch.Branch_Id,','))#)
                )
                </cfif>
            )
    </cfquery>
    <cfquery name="get_event_plan_company" datasource="#dsn#">
        SELECT COMPANY_ID FROM EVENT_PLAN_COMPANY WHERE EVENT_PLAN_ID = #attributes.visit_id#
    </cfquery>
    <cfset comp_list = valuelist(get_event_plan_company.COMPANY_ID)>
    <cfif len(get_event_plan.analyse_id)>
        <cfquery name="GET_ANALYSIS" datasource="#DSN#">
            SELECT ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event_plan.analyse_id#">
        </cfquery>
    </cfif>
    <cfif get_event_plan.recordcount eq 0>
        <br />
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1074.Kayıt Bulunamadı'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
	</cfif>        
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
			$('#keyword').focus();
		});
		function kontrol()
		{
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		$(document).ready(function(){
			if($("#is_view_company").prop('checked') == false)
				$('div#item-agenda_company').css('display',"none");				
		});
		function check_visit()
		{
			var formName = 'add_event',
			form  = $('form[name="'+ formName +'"]');
			
			if (form.find('input#main_start_date').val() != '' && form.find('input#main_finish_date').val() != ''){
				if(datediff(form.find('input#main_start_date').val(),form.find('input#main_finish_date').val() ,0)<0){
						validateMessage('notValid',form.find('input#main_start_date'),1);
						return false;
				}else    {
						  validateMessage('valid',form.find('input#main_start_date') );
						 } 
			}

			if ($("#record_num").val() == 0)
			{
				alertObject({ message : "<cf_get_lang no ='417.Lütfen Ziyaret Edilecek Seçiniz'>"});
				return false;
			}
			row_kontrol=0;
			for(r=1;r<=$("#record_num").val();r++)
			{	 
				deger_row_kontrol=document.getElementById('row_kontrol'+r).value;
				deger_start_date = document.getElementById('start_date'+r).value;
				deger_start_clock = document.getElementById('start_clock'+r).value;
				deger_start_minute = document.getElementById('start_minute'+r).value;
				deger_finish_clock = document.getElementById('finish_clock'+r).value;
				deger_finish_minute = document.getElementById('finish_minute'+r).value;
				deger_pos_emp_name = document.getElementById('pos_emp_name'+r).value;
				deger_warning_id = document.getElementById('warning_id'+r).value;
				if (deger_warning_id == "")
				{ 
					alertObject({ message : "<cf_get_lang no ='240.Lütfen Ziyaret Nedeni Giriniz'>"});
					return false;
				}	
				if(deger_pos_emp_name == "")
				{
					alertObject({ message : "<cf_get_lang no ='241.Lütfen Ziyaret Edecekler Satırına En Az Bir Kişi Ekleyiniz'>"});
					return false;
				}
				var deger = document.getElementById('finish_date'+r);
				if (isDefined("deger") || deger != null)
				{
					deger_finish_date = document.getElementById('finish_date'+r).value;
				}
				else
					deger_finish_date="undefined";//
					
				if(deger_row_kontrol == 1)
				{
					row_kontrol++;
					if(deger_start_date== "")
					{
						alertObject({ message : "<cf_get_lang no ='237.Lütfen Başlangıç Tarihi Giriniz'> !"});
						return false;
					}
					if(deger_finish_date== "")
					{
						alertObject({ message : "<cf_get_lang no ='238.Lütfen Bitiş Tarihi Giriniz'> !"});
						return false;
					}
					if(deger_finish_date!="undefined")
					{
						if (deger_start_date != "" && deger_finish_date!="")
						{
							tarih1_ = deger_start_date.substr(6,4) + deger_start_date.substr(3,2) + deger_start_date.substr(0,2);
							tarih2_ = deger_finish_date.substr(6,4) + deger_finish_date.substr(3,2) + deger_finish_date.substr(0,2);
						
							if (deger_start_clock.length < 2) saat1_ = '0' + deger_start_clock; else saat1_ = deger_start_clock;
							if (deger_start_minute.length < 2) dakika1_ = '0' + deger_start_minute; else dakika1_ = deger_start_minute;
							if (deger_finish_clock.length < 2) saat2_ = '0' + deger_finish_clock; else saat2_ = deger_finish_clock;
							if (deger_finish_minute.length < 2) dakika2_ = '0' + deger_finish_minute; else dakika2_ = deger_finish_minute;
						
							tarih1_ = tarih1_ + saat1_ + dakika1_;
							tarih2_ = tarih2_ + saat2_ + dakika2_;	
							
							if (tarih1_ >= tarih2_) 
							{
								alertObject({ message : "<cf_get_lang no ='239.Ziyaret Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"});
								return false;
							}
						}
					}
				}
			}
			return true;
			
		}
		function sil(sy)
		{
			var my_element=document.getElementById('row_kontrol'+sy);
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
		
		function pencere_ac(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_buyer_seller=0&field_id=add_event.partner_id' + no +'&field_comp_name=add_event.company_name' + no +'&field_name=add_event.partner_name' + no +'&field_comp_id=add_event.company_id' + no + '&select_list=7,8','project');
		}
		
		function temizlerim(no)
		{
			var my_element=eval("add_event.pos_emp_id"+no);
			var my_element2=eval("add_event.pos_emp_name"+no);
			my_element.value='';
			my_element2.value='';
		}
		function clear(no)
		{
			var my_asset=eval("add_event.relation_asset_id"+no);
			var my_asset2=eval("add_event.relation_asset"+no);
			my_asset.value='';
			my_asset2.value='';
		}
		function pencere_ac_pos(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.pos_emp_id' + no +'&field_name=add_event.pos_emp_name' + no +'&select_list=1&is_upd=1','list');
		}
		function pencere_ac_asset(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_event.relation_asset_id'+ no +'&field_name=add_event.relation_asset' + no +'&event_id=0','list');
		}
		function pencere_ac_project(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_event.project_id'+ no +'&project_head=add_event.project_head' + no,'list');
		}
		function pencere_ac_date(no)
		{
			if((document.add_event.main_start_date.value == "") && (document.add_event.main_finish_date.value == ""))
				alertObject({ message : "<cf_get_lang no ='243.Lütfen İlk Önce Olay Başlangıç ve Bitiş Tarihlerini Seçiniz'> !"});
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_event.start_date' + no +'&is_check=' + no,'date');
		}
		
		function pencere_ac_date_finish(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_event.finish_date' + no ,'date');
		}
		
		function pencere_ac_company(no)
		{
			if((document.getElementById('main_start_date').value=='') || (document.getElementById('main_finish_date').value == ''))
			{
				alertObject({ message : "<cf_get_lang no ='418.Önce Ziyaret Tarihlerini Giriniz'> !"});
				return false;	
			}
			else if(datediff(document.getElementById('main_start_date').value,document.getElementById('main_finish_date').value ,0)<0)
			{
				alertObject({ message : "<cf_get_lang_main no ='1450.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'> !"});
				return false;
			}
			else	
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_multiuser_company&kontrol_startdate='+document.getElementById('main_start_date').value+'&record_num_=' + document.getElementById('record_num').value +'&is_first=1&startdate=' + document.getElementById('main_start_date').value +'&is_sales=1&is_close=0&is_choose_project=#is_choose_project#</cfoutput>','list','popup_list_multiuser_company');
		}
		
		function time_check(satir_deger)
		{
			check_start_date = eval("document.add_event.start_date"+satir_deger);
			tarih_main_start_date = add_event.main_start_date.value.substr(6,4) + add_event.main_start_date.value.substr(3,2) + add_event.main_start_date.value.substr(0,2);
			tarih_main_finish_date = add_event.main_finish_date.value.substr(6,4) + add_event.main_finish_date.value.substr(3,2) + add_event.main_finish_date.value.substr(0,2);
			check_start = check_start_date.value.substr(6,4) + check_start_date.value.substr(3,2) + check_start_date.value.substr(0,2);
			if((check_start < tarih_main_start_date) || (check_start > tarih_main_finish_date))
			{
				alertObject({ message : "<cf_get_lang no ='242.Tarih Başlangıç ve Bitiş Tarihleri Arasında Olmalıdır'> !"});
				check_start_date.value = "";
			}
		}
		
		function wiew_control(type)
		{
			if(type == 1)
			{
				$('input#is_wiew_branch').prop('checked',false);
				$('input#is_wiew_department').prop('checked',false);
				$('input#is_view_company').prop('checked',false);
				<cfif xml_multiple_comp eq 1>
					$('div#item-agenda_company').css('display',"none");
				</cfif>	
			}	
			if(type == 2)
			{
				$('input#view_to_all').prop('checked',false);
				$('input#is_wiew_department').prop('checked',false);
				$('input#is_view_company').prop('checked',false);
				<cfif xml_multiple_comp eq 1>
					$('div#item-agenda_company').css('display',"none");
				</cfif>	
			}	
			if(type == 3)
			{
				$('input#view_to_all').prop('checked',false);
				$('input#is_wiew_branch').prop('checked',false);
				$('input#is_view_company').prop('checked',false);
				<cfif xml_multiple_comp eq 1>
					$('div#item-agenda_company').css('display',"none");
				</cfif>	
			}	
			if(type == 4)
			{
				$('input#view_to_all').prop('checked',false);
				$('input#is_wiew_branch').prop('checked',false);
				$('input#is_wiew_department').prop('checked',false);
				<cfif xml_multiple_comp eq 1>
					if($("#is_view_company").prop('checked') == false)
						$('div#item-agenda_company').css('display',"none");
					else
						$('div#item-agenda_company').css('display',"");
				</cfif>
		
			}	
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfif get_event_plan.recordcount neq 0>
			$(document).ready(function(){
				if($("#is_view_company").prop('checked') == false)
					$('div#item-agenda_company').css('display',"none");
			});
			function check()
			{
				var formName = 'add_event', 
                form  = $('form[name="'+ formName +'"]');
                
                if (form.find('input#main_start_date').val() != '' && form.find('input#main_finish_date').val() != ''){
					if(datediff(form.find('input#main_start_date').val(),form.find('input#main_finish_date').val() ,0)<0){
                            validateMessage('notValid',form.find('input#main_start_date'),1);
                            return false;
                    }else    {
                              validateMessage('valid',form.find('input#main_start_date') );
                             } 
                }

				if ($("#record_num").val() == 0)
				{
					alertObject({ message : "<cf_get_lang no ='569.Ziyaret Edilecek Seçiniz'> !"});
					return false;
				}
				row_kontrol=0;
				for(r=1;r<=$("#record_num").val();r++)
				{
					deger_row_kontrol=document.getElementById('row_kontrol'+r).value;
					deger_start_date = document.getElementById('start_date'+r).value;
					deger_start_clock = document.getElementById('start_clock'+r).value;
					deger_start_minute = document.getElementById('start_minute'+r).value;
					var deger = document.getElementById('finish_date'+r);
					if (isDefined("deger") || deger != null)
					{
						deger_finish_date = document.getElementById('finish_date'+r).value;
					}
					else
						deger_finish_date="undefined";//
					deger_finish_clock = document.getElementById('finish_clock'+r).value;
					deger_finish_minute = document.getElementById('finish_minute'+r).value;
					deger_pos_emp_name = document.getElementById('pos_emp_name'+r).value;
					deger_warning_id = document.getElementById('warning_id'+r).value;
				
					if(deger_row_kontrol == 1)
					{
						row_kontrol++;
						if(deger_start_date == "")
						{
							alertObject({ message : "<cf_get_lang no='237.Lütfen Başlangıç Tarihi Giriniz'> !"});
							return false;
						}
						if(deger_finish_date == "")
						{
							alertObject({ message : "<cf_get_lang no='238.Lütfen Bitiş Tarihi Giriniz'> !"});
							return false;
						}
						if(deger_finish_date!="undefined")
						{
							if ((deger_start_date != "") && (deger_finish_date != ""))
							{
								tarih1_ = deger_start_date.substr(6,4) + deger_start_date.substr(3,2) + deger_start_date.substr(0,2);
								tarih2_ = deger_finish_date.substr(6,4) + deger_finish_date.substr(3,2) + deger_finish_date.substr(0,2);
							
								if (deger_start_clock.length < 2) saat1_ = '0' + deger_start_clock; else saat1_ = deger_start_clock;
								if (deger_start_minute.length < 2) dakika1_ = '0' + deger_start_minute; else dakika1_ = deger_start_minute;
								if (deger_finish_clock.length < 2) saat2_ = '0' + deger_finish_clock; else saat2_ = deger_finish_clock;
								if (deger_finish_minute.length < 2) dakika2_ = '0' + deger_finish_minute; else dakika2_ = deger_finish_minute;
							
								tarih1_ = tarih1_ + saat1_ + dakika1_;
								tarih2_ = tarih2_ + saat2_ + dakika2_;	
								
								if (tarih1_ >= tarih2_) 
								{
									alertObject({ message : "<cf_get_lang no='239.Ziyaret Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !"});
									return false;
								}
							}	
						}
						if (deger_warning_id == "")
						{ 
							alertObject({ message : "<cf_get_lang no='240.Lütfen Ziyaret Nedeni Giriniz'> !"});
							return false;
						}	
						if(deger_pos_emp_name == "")
					   {
							alertObject({ message : "<cf_get_lang no='241.Lütfen Ziyaret Edecekler Satırına En Az Bir Kişi Ekleyiniz'> !"});
							return false;
						}
					}
				}
				return true;
			}
			
			function temizlerim(no)
			{
				var my_element=eval("add_event.pos_emp_id"+no);
				var my_element2=eval("add_event.pos_emp_name"+no);
				my_element.value='';
				my_element2.value='';
			}
			
			function time_check(satir_deger)
			{
				check_start_date = eval("document.add_event.start_date"+satir_deger);
				tarih_main_start_date = add_event.main_start_date.value.substr(6,4) + add_event.main_start_date.value.substr(3,2) + add_event.main_start_date.value.substr(0,2);
				tarih_main_finish_date = add_event.main_finish_date.value.substr(6,4) + add_event.main_finish_date.value.substr(3,2) + add_event.main_finish_date.value.substr(0,2);
				check_start = check_start_date.value.substr(6,4) + check_start_date.value.substr(3,2) + check_start_date.value.substr(0,2);
				if((check_start < tarih_main_start_date) || (check_start > tarih_main_finish_date))
				{
					alertObject({ message : "<cf_get_lang no='242.Tarih Başlangıç ve Bitiş Tarihleri Arasında Olmalıdır'> !"});
					check_start_date.value = "";
				}
			}
			
			function sil(sy)
			{
				var my_element=eval("add_event.row_kontrol"+sy);
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
			<cfoutput>
			function pencere_ac(no)
			{
				windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_buyer_seller=0&field_id=add_event.partner_id' + no +'&field_comp_name=add_event.company_name' + no +'&field_name=add_event.partner_name' + no +'&field_comp_id=add_event.company_id'+ no +'&field_consumer=add_event.consumer_id' + no + '&select_list=7,8','project');
			}
			function pencere_ac_pos(no)
			{
				windowopen('#request.self#?fuseaction=objects.popup_list_multi_pars&field_id=add_event.pos_emp_id' + no +'&field_name=add_event.pos_emp_name' + no +'&select_list=1&is_upd=1','list');
			
			}
			function pencere_ac_inf(no)
			{
				windowopen('#request.self#?fuseaction=objects.popup_list_multi_pars&field_id=add_event.inf_emp_id' + no +'&field_name=add_event.inf_emp_name' + no +'&select_list=1&is_upd=1','list');
			}
			function pencere_ac_asset(no)
			{
				windowopen('#request.self#?fuseaction=assetcare.popup_list_assetps&field_id=add_event.relation_asset_id'+ no +'&field_name=add_event.relation_asset' + no +'&event_id=0','list');
			}
			function pencere_ac_project(no)
			{
			
				windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_event.project_id'+ no +'&project_head=add_event.project_head' + no,'list');
			}
			function pencere_ac_date(no)
			{
				if((document.add_event.main_start_date.value == "") && (document.add_event.main_finish_date.value == ""))
				{
					alertObject({ message : "<cf_get_lang no='243.Lütfen İlk Önce Olay Başlangıç ve Bitiş Tarihlerini Seçiniz'> !"});
				}
				else
				{
					windowopen('#request.self#?fuseaction=objects.popup_calender&alan=add_event.start_date' + no +'&is_check=' + no,'date');
				}
			}
			function pencere_ac_date_finish(no)
			{
				windowopen('#request.self#?fuseaction=objects.popup_calender&alan=add_event.finish_date' + no ,'date');
			}
			function pencere_ac_company(no)
			{
				if((add_event.main_start_date.value == '') || (add_event.main_finish_date.value == ''))
				{
					alertObject({ message : "<cf_get_lang no ='418.Önce Ziyaret Tarihlerini Giriniz'> !"});
					return false;
				}
				else if(datediff(document.getElementById('main_start_date').value,document.getElementById('main_finish_date').value ,0)<0)
				{
					alertObject({ message : "<cf_get_lang_main no ='1450.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'> !"});
					return false;
				}
				else	
					windowopen('#request.self#?fuseaction=objects.popup_list_multiuser_company&kontrol_startdate='+add_event.main_start_date.value+'&record_num_=' + add_event.record_num.value +'&is_choose_project=#is_choose_project#&is_first=1&startdate=' + add_event.main_start_date.value +'&is_sales=1&is_close=0','list','popup_list_multiuser_company');
			}
			</cfoutput>
			function manage_date(gelen_alan)
			{
				wrk_date_image(gelen_alan);
			}
			function wiew_control(type)
			{
			
				if(type == 1)
				{
					$('input#is_wiew_branch').prop('checked',false);
					$('input#is_wiew_department').prop('checked',false);
					$('input#is_view_company').prop('checked',false);
					<cfif xml_multiple_comp eq 1>
						$('div#item-agenda_company').css('display',"none");
					</cfif>	
				}	
				if(type == 2)
				{
					$('input#view_to_all').prop('checked',false);
					$('input#is_wiew_department').prop('checked',false);
					$('input#is_view_company').prop('checked',false);
					<cfif xml_multiple_comp eq 1>
						$('div#item-agenda_company').css('display',"none");
					</cfif>	
				}	
				if(type == 3)
				{
					$('input#view_to_all').prop('checked',false);
					$('input#is_wiew_branch').prop('checked',false);
					$('input#is_view_company').prop('checked',false);
					<cfif xml_multiple_comp eq 1>
						$('div#item-agenda_company').css('display',"none");
					</cfif>	
				}	
				if(type == 4)
				{
					$('input#view_to_all').prop('checked',false);
					$('input#is_wiew_branch').prop('checked',false);
					$('input#is_wiew_department').prop('checked',false);
					<cfif xml_multiple_comp eq 1>
						if($("#is_view_company").prop('checked') == false)
							$('div#item-agenda_company').css('display',"none");
						else
							$('div#item-agenda_company').css('display',"");
					</cfif>
			
				}	
			}
		</cfif>		
	</cfif>		
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
			
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(isdefined('attributes.event') and attributes.event contains 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = Get_Event_Plan.Event_Status;	
		
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = DSN; // Transaction icin yapildi.
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EVENT_PLAN';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EVENT_PLAN_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-warning_head','item-sales_zones','item-analyse_id','item-main_start_date','item-main_finish_date']";

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_visit';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_visit.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_visit';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/form_add_visit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_warning.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_visit&event=upd&visit_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_event';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'check_visit() && validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_add_visit';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/form_upd_visit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_warning.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_visit&event=upd&visit_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'visit_id=##attributes.visit_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.visit_id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'GET_EVENT_PLAN';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_event';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'check() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
				
	if(isdefined("attributes.event") and listFind('upd,del',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_visit&visit_id=#attributes.visit_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/del_visit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/del_visit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_visit';
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_visit&event=add";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_visit&event=add&visit_id=#get_event_plan.event_plan_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>