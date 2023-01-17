<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
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
    <cfif isDate(attributes.startdate)>
    	<cf_date tarih="attributes.startdate">
   	</cfif>
    <cfif isDate(attributes.finishdate)>
    	<cf_date tarih="attributes.finishdate">
    </cfif>
    <cfquery name="get_process_stage" datasource="#dsn#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.from_add_personel_assign_form%">
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
                *
            FROM
                PERSONEL_ASSIGN_FORM PAF,
                PROCESS_TYPE_ROWS PTR
            WHERE
                PAF.PER_ASSIGN_STAGE = PTR.PROCESS_ROW_ID AND
                PAF.PERSONEL_ASSIGN_ID IS NOT NULL
                <cfif Len(attributes.process_status)>
                    AND ISNULL(PAF.IS_FINISHED,-1) = #attributes.process_status#
                </cfif>
                <cfif Len(attributes.process_stage)>
                    AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                </cfif>
                <cfif Len(attributes.our_company_id)>
                    AND PAF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
                </cfif>
                <cfif Len(attributes.branch_id)>
                    AND PAF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif Len(attributes.department_id)>
                    AND PAF.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif len(attributes.position_cat) and len(attributes.position_cat_id)>
                    AND PAF.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
                </cfif>
                <cfif Len(attributes.keyword)>
                    AND 
                    (
                        <cfif isNumeric(attributes.keyword)>
                            PAF.PERSONEL_ASSIGN_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.keyword#"> OR
                        </cfif>
                        PAF.PERSONEL_ASSIGN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        PAF.PERSONEL_TC_IDENTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        <cfif database_type is "MSSQL">
                            OR (PAF.PERSONEL_NAME + ' ' + PAF.PERSONEL_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        <cfelse>
                            OR (PAF.PERSONEL_NAME || ' ' || PAF.PERSONEL_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        </cfif>
                    )
                </cfif>
                <cfif not session.ep.ehesap>
                    AND PAF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
                <cfif Len(attributes.startdate) and Len(attributes.finishdate)>
                    AND ISNULL(PAF.UPDATE_DATE,PAF.RECORD_DATE) BETWEEN #attributes.startdate# AND #attributes.finishdate#
                </cfif>
            ORDER BY
                PAF.PERSONEL_ASSIGN_ID DESC
        </cfquery>
    <cfelse>
        <cfset get_form.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.totalrecords" default="#get_form.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                    
	<cfif Len(attributes.startdate)>
        <cfset startdate_ = dateformat(attributes.startdate,'dd/mm/yyyy')>
    <cfelse>
        <cfset startdate_ = "">
    </cfif>
	<cfif Len(attributes.finishdate)>
        <cfset finishdate_ = dateformat(attributes.finishdate,'dd/mm/yyyy')>
    <cfelse>
        <cfset finishdate_ = "">
    </cfif>
	<cfif get_form.recordcount>
        <cfset position_cat_list = "">
        <cfset our_company_id_list = "">
        <cfset branch_id_list = "">
        <cfset department_id_list = "">
        <cfset personel_requirement_list = "">
        <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif Len(position_cat_id) and not ListFind(position_cat_list,position_cat_id,",")>
            	<cfset position_cat_list = ListAppend(position_cat_list,position_cat_id,",")>
            </cfif>
            <cfif Len(our_company_id) and not ListFind(our_company_id_list,our_company_id,",")>
                <cfset our_company_id_list = ListAppend(our_company_id_list,our_company_id,",")>
            </cfif>
            <cfif Len(branch_id) and not ListFind(branch_id_list,branch_id,",")>
                <cfset branch_id_list = ListAppend(branch_id_list,branch_id,",")>
            </cfif>
            <cfif Len(department_id) and not ListFind(department_id_list,department_id,",")>
                <cfset department_id_list = ListAppend(department_id_list,department_id,",")>
            </cfif>
            <cfif Len(personel_req_id) and not ListFind(personel_requirement_list,personel_req_id,",")>
                <cfset personel_requirement_list = ListAppend(personel_requirement_list,personel_req_id,",")>
            </cfif>
        </cfoutput>
        <cfif ListLen(position_cat_list)>
            <cfquery name="get_position_cat" datasource="#dsn#">
                SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#position_cat_list#) ORDER BY POSITION_CAT_ID
            </cfquery>
            <cfset position_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_position_cat.position_cat_id,",")),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(our_company_id_list)>
            <cfquery name="get_our_company_name" datasource="#dsn#">
                SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_id_list#) ORDER BY COMP_ID
            </cfquery>
            <cfset our_company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_our_company_name.comp_id,",")),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(branch_id_list)>
            <cfquery name="get_branch_name" datasource="#dsn#">
                SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
            </cfquery>
            <cfset branch_id_list = ListSort(ListDeleteDuplicates(ValueList(get_branch_name.branch_id,",")),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(department_id_list)>
            <cfquery name="get_department_name" datasource="#dsn#">
                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_id_list#) ORDER BY DEPARTMENT_ID
            </cfquery>
            <cfset department_id_list = ListSort(ListDeleteDuplicates(ValueList(get_department_name.department_id,",")),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(personel_requirement_list)>
            <cfquery name="get_requirement_name" datasource="#dsn#">
                SELECT PERSONEL_REQUIREMENT_ID,PERSONEL_REQUIREMENT_HEAD,FORM_TYPE,OLD_PERSONEL_NAME,CHANGE_PERSONEL_NAME,TRANSFER_PERSONEL_NAME FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID IN (#personel_requirement_list#) ORDER BY PERSONEL_REQUIREMENT_ID
            </cfquery>
            <cfset personel_requirement_list = ListSort(ListDeleteDuplicates(ValueList(get_requirement_name.personel_requirement_id,",")),"numeric","asc",",")>
        </cfif>
    </cfif>
    <cfset url_str = "&is_filtered=1">
    <cfif Len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
    <cfif Len(attributes.branch_id)>
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif Len(attributes.department_id)>
		<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
    </cfif>
    <cfif Len(attributes.position_cat) and Len(attributes.position_cat_id)>
        <cfset url_str = "#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#">
    </cfif>
    <cfif Len(attributes.process_stage)>
	<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
    </cfif>
    <cfif Len(attributes.startdate)>
		<cfset url_str = "#url_str#&startdate=#DateFormat(attributes.startdate,'dd/mm/yyyy')#">
    </cfif>
    <cfif Len(attributes.finishdate)>
		<cfset url_str = "#url_str#&finishdate=#DateFormat(attributes.finishdate,'dd/mm/yyyy')#">
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfinclude template="../hr/query/get_edu_level.cfm">
    <cfinclude template="../hr/query/get_driverlicence.cfm">
    <cfinclude template="../hr/query/get_moneys.cfm">
    <cfquery name="get_per_req" datasource="#dsn#">
        SELECT
            PRF.PERSONEL_REQUIREMENT_ID,
            PRF.PERSONEL_REQUIREMENT_HEAD
        FROM
            PERSONEL_REQUIREMENT_FORM PRF
        WHERE
            PRF.PERSONEL_REQUIREMENT_HEAD IS NOT NULL AND 
            PRF.IS_FINISHED = 1 AND 
            PRF.PERSONEL_REQUIREMENT_ID NOT IN (SELECT PAF.PERSONEL_REQ_ID FROM PERSONEL_ASSIGN_FORM PAF WHERE IS_FINISHED = 1 AND PAF.PERSONEL_REQ_ID IS NOT NULL)
        <cfif not session.ep.ehesap>
            AND PRF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
        ORDER BY
            PRF.PERSONEL_REQUIREMENT_ID
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
    <cfquery name="get_per_req" datasource="#dsn#">
        SELECT 
            PAF.*, 
            EA.WORK_STARTED, 
            EA.WORK_FINISHED ,
            EA.CV_STAGE
        FROM 
            PERSONEL_ASSIGN_FORM PAF 
            LEFT JOIN EMPLOYEES_APP EA ON PAF.RELATED_CV_BANK_ID = EA.EMPAPP_ID 
        WHERE 
            PERSONEL_ASSIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_assign_id#">
    </cfquery>
    <cfquery name="get_req" datasource="#dsn#">
        SELECT
            PRF.PERSONEL_REQUIREMENT_ID,
            PRF.PERSONEL_REQUIREMENT_HEAD
        FROM
            PERSONEL_REQUIREMENT_FORM PRF
        WHERE
            PRF.PERSONEL_REQUIREMENT_HEAD IS NOT NULL
            AND PRF.IS_FINISHED = 1
            AND PRF.PERSONEL_REQUIREMENT_ID NOT IN (SELECT PAF.PERSONEL_REQ_ID FROM PERSONEL_ASSIGN_FORM PAF WHERE IS_FINISHED = 1 AND PAF.PERSONEL_REQ_ID IS NOT NULL)
            <cfif not session.ep.ehesap>
                AND PRF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
        ORDER BY
            PRF.PERSONEL_REQUIREMENT_ID
    </cfquery>
    <cfif Len(get_per_req.personel_req_id)>
        <cfquery name="get_relation_requirement" datasource="#dsn#">
            SELECT PERSONEL_REQUIREMENT_ID,PERSONEL_REQUIREMENT_HEAD FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.personel_req_id#"> ORDER BY PERSONEL_REQUIREMENT_ID
        </cfquery>
    </cfif>
    <cfif not get_per_req.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='72.Kayıt Yok'>!</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    </cfif>
    <cfinclude template="../hr/query/get_edu_level.cfm">
  	<cfinclude template="../hr/query/get_driverlicence.cfm">
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
	<cfif len(get_per_req.old_our_company_id) and len(get_per_req.old_branch_id) and len(get_per_req.old_department_id)>
		<cfquery name="get_old_department_info" datasource="#dsn#">
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
				OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_our_company_id#"> AND
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_branch_id#"> AND
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_department_id#">
		</cfquery>
	</cfif>

	<cfset app_position = "">
	<cfif len(get_per_req.old_position_id)>
		<cfquery name="get_position_name" datasource="#dsn#">
			SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_position_id#">
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
	
	<cfset Detail_ = "">
	<cfif isdefined("x_show_warning_process") and ListLen(x_show_warning_process)>
		<cfquery name="Get_Old_Assign_Control" datasource="#dsn#">
			SELECT
				PERSONEL_ASSIGN_ID,
				UPDATE_DATE,
				ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,
				PERSONEL_ASSIGN_DETAIL
			FROM
				PERSONEL_ASSIGN_FORM
			WHERE
				PERSONEL_ASSIGN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.personel_assign_id#"> AND
				PER_ASSIGN_STAGE IN (#x_show_warning_process#) AND 
				PERSONEL_TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_per_req.personel_tc_identy_no#">
		</cfquery>
		<cfif Get_Old_Assign_Control.RecordCount>
			<cfset Detail_ = "İlgili Kişinin Ataması #DateFormat(Get_Old_Assign_Control.UPDATE_DATE,'dd/mm/yyyy')# Tarihinde #Get_Emp_Info(Get_Old_Assign_Control.Update_Emp,0,0)# Tarafından Reddedilmiştir! <br/>Gerekçe : #Get_Old_Assign_Control.Personel_Assign_Detail#">
		</cfif>
	</cfif>
    
</cfif>
<script type="text/javascript">
//event:list
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		document.getElementById('keyword').focus();
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
			for (i=0; i < document.getElementsByName('print_form_choice').length; i++)
			{
				if(document.form_print_all.print_form_choice[i].checked == true)
				{
					print_form_list = print_form_list + document.form_print_all.print_form_choice[i].value + ',';
				}	
			}
			if(print_form_list.length == 0)
			{
				alert("En Az Bir Seçim Yapmalısınız!");
				return false;
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_assign&action=print&id='+print_form_list+'&module=hr&iframe=1&trail=0','page');
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
				document.getElementById('print_form_choice').checked = document.getElementById("all_choice").checked;
		}
	//Event add/upd		
	<cfelseif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd')>
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
				alert("<cf_get_lang_main no ='1362.Maksimum açıklama uzunluğu'>" + ":" + limit);
				}
			else 
				{
				CharsLeft = StrLen;
				}
				return true;
		}
		
		function kontrol()
		{ 
			if(document.getElementById('personel_assign_detail').value == '')
			{
				alert('Görüş Girmelisiniz!');
				return false;
			}
			<cfif isdefined("attributes.event") and attributes.event is 'add'>
				if(document.add_form.relative_status[0].checked && document.getElementById('relative_detail').value=='')
				{
					alert('Yakınlık Derecesi Girmelisiniz!');
					return false;
				}
				
				if(process_cat_control())
				{
					if(add_form.salary != undefined) add_form.salary.value = filterNum(add_form.salary.value);
					if(add_form.old_salary != undefined) add_form.old_salary.value = filterNum(add_form.old_salary.value);
					return true;
				}
				else
					return false;
			<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
				<cfif isdefined("x_display_page_detail") and x_display_page_detail eq 1 and not ListFind(x_detail_change_personel,session.ep.userid) and not ListFind(get_per_req.record_emp,session.ep.userid)>
					//Display Olarak Acilsin
				<cfelse>
					if(document.add_form.relative_status[0].checked && document.getElementById('relative_detail').value=='')
					{
						alert('Yakınlık Derecesi Girmelisiniz!');
						return false;
					}
				</cfif>
				if(process_cat_control())
				{
					if(document.getElementById('salary') != undefined) document.getElementById('salary').value = filterNum(document.getElementById('salary').value);
					if(document.getElementById('old_salary') != undefined) document.getElementById('old_salary').value = filterNum(document.getElementById('old_salary').value);
					return true;
				}
				else
					return false;
			</cfif>
			return true;
		}
		function get_per_req()
		{
			deger_ = document.getElementById('PERSONEL_REQ_ID').value;
			document.getElementById('work_start').value = '';
			document.getElementById('work_finish').value = '';
			if(deger_ != '')
			{
				get_req_ = wrk_query("SELECT FORM_TYPE,YEAR(WORK_START) AS BYIL,MONTH(WORK_START) AS BAY,DAY(WORK_START) AS BGUN,YEAR(WORK_FINISH) AS FYIL,MONTH(WORK_FINISH) AS FAY,DAY(WORK_FINISH) AS FGUN FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = " + deger_,"dsn");
				if(get_req_.FORM_TYPE == '6')
				{
					if(get_req_.BAY != '')
						document.getElementById('work_start').value = get_req_.BGUN + '/' + get_req_.BAY + '/' + get_req_.BYIL;
					
					if(get_req_.FAY != '')
						document.getElementById('work_finish').value = get_req_.FGUN + '/' + get_req_.FAY + '/' + get_req_.FYIL;
				}
			}
			return true;
		}
		function control_identy_no()
		{
			if(document.getElementById('personel_tc_identy_no').value.length == 11)
			{
				//Talebi Giren Kisinin Sadece Yekili Oldugu Departmanlardaki Kisilerin Kimlik Bilgilerini Gorebilmesi Icin Kontrol Eklendi FBS 20120607
				get_session_authority_department = "SELECT D.DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES EPB, DEPARTMENT D WHERE D.BRANCH_ID = EPB.BRANCH_ID AND EPB.POSITION_CODE = <cfoutput>#session.ep.position_code#</cfoutput> GROUP BY D.DEPARTMENT_ID";
				get_kisi_ = wrk_query("SELECT DISTINCT E.EMPLOYEE_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS E,EMPLOYEES_IDENTY EI WHERE E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND E.IS_MASTER = 1 AND EI.TC_IDENTY_NO = '" + document.getElementById('personel_tc_identy_no').value + "' AND E.DEPARTMENT_ID IN ("+ get_session_authority_department +")","dsn");
				if(get_kisi_.recordcount > 1)
				{
					var kisiler = "";
					for(var i=0;i<get_kisi_.recordcount;i++)
						var kisiler = kisiler + ' ' + get_kisi_.EMPLOYEE_NAME[i] + ' ' + get_kisi_.EMPLOYEE_SURNAME[i] + ',';
		
					document.getElementById('identy_control_td').innerHTML = '<font style="color:red;">Girilen TC Kimlik No Birden Fazla Bulundu : ' + kisiler + '</font>';
					document.getElementById('personel_name').value = "";
					document.getElementById('personel_surname').value = "";
					document.getElementById('old_branch_id').value = "";
					document.getElementById('old_branch').value = "";
					document.getElementById('old_department_id').value = "";
					document.getElementById('old_department').value = "";
					document.getElementById('old_our_company_id').value = "";
					document.getElementById('old_our_company').value = "";
					document.getElementById('old_position_name').value = "";
					document.getElementById('old_position_id').value = "";
					document.getElementById('old_salary').value = "";
					document.getElementById('old_work_start').value = "";
					document.getElementById('old_work_finish').value = "";
				}
				else if(get_kisi_.recordcount == 1)
				{
					document.getElementById('identy_control_td').innerHTML = '<font style="color:red;">Girilen TC Kimlik No Bulundu : ' + get_kisi_.EMPLOYEE_NAME + ' ' + get_kisi_.EMPLOYEE_SURNAME + '</font>';
					document.getElementById('personel_name').value = get_kisi_.EMPLOYEE_NAME;
					document.getElementById('personel_surname').value = get_kisi_.EMPLOYEE_SURNAME;
					get_kisi_position_ = wrk_query("SELECT TOP 1 EP.POSITION_NAME,EP.POSITION_CODE,D.DEPARTMENT_ID,B.BRANCH_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME,O.NICK_NAME,O.COMP_ID FROM EMPLOYEE_POSITIONS_HISTORY EP,DEPARTMENT D,BRANCH B,OUR_COMPANY O WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = O.COMP_ID AND EP.EMPLOYEE_ID = " + get_kisi_.EMPLOYEE_ID + " ORDER BY EP.RECORD_DATE DESC","dsn");
					if(get_kisi_position_.recordcount)
					{
						document.getElementById('old_branch_id').value = get_kisi_position_.BRANCH_ID;
						document.getElementById('old_branch').value = get_kisi_position_.BRANCH_NAME;
						document.getElementById('old_department_id').value = get_kisi_position_.DEPARTMENT_ID;
						document.getElementById('old_department').value = get_kisi_position_.DEPARTMENT_HEAD;
						document.getElementById('old_our_company_id').value = get_kisi_position_.COMP_ID;
						document.getElementById('old_our_company').value = get_kisi_position_.NICK_NAME;
						document.getElementById('old_position_name').value = get_kisi_position_.POSITION_NAME;
						document.getElementById('old_position_id').value = get_kisi_position_.POSITION_CODE;
					}
					get_kisi_ucret_ = wrk_query("SELECT TOP 1 ES.M12 M12,YEAR(EI.START_DATE) AS BYIL,MONTH(EI.START_DATE) AS BAY,DAY(EI.START_DATE) AS BGUN,YEAR(EI.FINISH_DATE) AS FYIL,MONTH(EI.FINISH_DATE) AS FAY,DAY(EI.FINISH_DATE) AS FGUN FROM EMPLOYEES_IN_OUT EI,EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI.IN_OUT_ID AND EI.EMPLOYEE_ID = " + get_kisi_.EMPLOYEE_ID + " ORDER BY EI.START_DATE DESC,ES.PERIOD_YEAR DESC","dsn");
					if(get_kisi_ucret_.recordcount)
					{
						if(get_kisi_ucret_.M12 != "") document.getElementById('old_salary').value = commaSplit(get_kisi_ucret_.M12,2);				
						if(get_kisi_ucret_.BGUN != "" && get_kisi_ucret_.BAY != "" && get_kisi_ucret_.BYIL != "") document.getElementById('old_work_start').value = get_kisi_ucret_.BGUN + '/' + get_kisi_ucret_.BAY + '/' + get_kisi_ucret_.BYIL;
						if(get_kisi_ucret_.FGUN != "" && get_kisi_ucret_.FAY != "" && get_kisi_ucret_.FYIL != "") document.getElementById('old_work_finish').value = get_kisi_ucret_.FGUN + '/' + get_kisi_ucret_.FAY + '/' + get_kisi_ucret_.FYIL;
					}
				}
				else
				{
					document.getElementById('identy_control_td').innerHTML = '<font style="color:red;">Girilen TC Kimlik Numarası Bulunamadı!</font>';
					document.getElementById('personel_name').value = "";
					document.getElementById('personel_surname').value = "";
					document.getElementById('old_branch_id').value = "";
					document.getElementById('old_branch').value = "";
					document.getElementById('old_department_id').value = "";
					document.getElementById('old_department').value = "";
					document.getElementById('old_our_company_id').value = "";
					document.getElementById('old_our_company').value = "";
					document.getElementById('old_position_name').value = "";
					document.getElementById('old_position_id').value = "";
					document.getElementById('old_salary').value = "";
					document.getElementById('old_work_start').value = "";
					document.getElementById('old_work_finish').value = "";
				}
				<cfif isdefined("attributes.event") and attributes.event is 'upd'>
					<cfif isdefined("x_show_warning_process") and ListLen(x_show_warning_process)>
						var Get_Old_Assign_Identy = wrk_query("SELECT PERSONEL_ASSIGN_ID,UPDATE_DATE, ISNULL(UPDATE_EMP,RECORD_EMP) UPDATE_EMP,PERSONEL_ASSIGN_DETAIL FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_ASSIGN_ID <><cfoutput>#get_per_req.personel_assign_id# AND PER_ASSIGN_STAGE IN (#x_show_warning_process#</cfoutput>) AND PERSONEL_TC_IDENTY_NO = '" + document.all.personel_tc_identy_no.value + "'","dsn");
						if(Get_Old_Assign_Identy.recordcount > 0)
						{
							Get_Update_Emp = wrk_query("SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = " + Get_Old_Assign_Identy.UPDATE_EMP,"dsn");
							document.getElementById('process_detail_control_td').innerHTML = "İlgili Kişinin Ataması " + date_format(Get_Old_Assign_Identy.UPDATE_DATE) + " Tarihinde " + Get_Update_Emp.EMPLOYEE_NAME + " " + Get_Update_Emp.EMPLOYEE_SURNAME + " Tarafından Reddedilmiştir! <br/>Gerekçe : " + Get_Old_Assign_Identy.PERSONEL_ASSIGN_DETAIL;
						}
					</cfif>
				</cfif>
			}
			return true;
		}
		function relative_detail_info()
		{
			if(document.add_form.relative_status[0].checked)
				goster(relative_info);
			else
				gizle(relative_info);
				return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_personel_assign_form';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_personel_assign_form.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.from_add_personel_assign_form';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_personel_assign_form.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_personel_assign_form.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_personel_assign_form&event=upd';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.from_upd_personel_assign_form';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_personel_assign_form.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_personel_assign_form.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_personel_assign_form&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'per_assign_id=##attributes.per_assign_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.per_assign_id##';
	
	if(isdefined("attributes.event") and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_personel_assign_form';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_personel_assign_form.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_personel_assign_form.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_personel_assign_form';
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_name=per_assign_id&action_id=#attributes.per_assign_id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[85]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=hr.list_hr&event=add&per_assign_id=#attributes.per_assign_id#";
		if (Len(get_per_req.personel_req_id) and get_relation_requirement.recordcount){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[1787]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=hr.from_upd_personel_requirement_form&per_req_id=#get_per_req.personel_req_id#";
		}
		if (get_per_req.work_started == 0 or get_per_req.work_finished == 1){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[618]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_add_app_test_time&empapp_id=#get_per_req.related_cv_bank_id#&process_stage_=#get_per_req.cv_stage#')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_personel_assign_form&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_assign&action=print&id=#attributes.per_assign_id#&module=hr&iframe=1&trail=0','page')";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPersonalAssignForm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PERSONEL_ASSIGN_FORM';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-personel_assign_head','item-company_info','item-name_surname','item-personel_tc_identy_no','item-position_cat','item-birth_date','']";
</cfscript>