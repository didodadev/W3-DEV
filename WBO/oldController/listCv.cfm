<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
    <cfparam name="attributes.finishdate" default="#day(now())#/#month(now())#/#session.ep.period_year#">
    <cfif len(attributes.startdate) gt 5>
        <cf_date tarih="attributes.startdate">
    <cfelse>
        <cfset attributes.startdate = "">
    </cfif>
    <cfif len(attributes.finishdate) gt 5>
        <cf_date tarih="attributes.finishdate">
    <cfelse>
        <cfset attributes.finishdate="">
    </cfif>
    <cfif not isdefined("attributes.keyword")>
        <cfset filtered = 0>
    <cfelse>
        <cfset filtered = 1>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.status" default="">
    <cfparam name="attributes.emp_app_type" default="">
    <cfparam name="attributes.cv_status" default="">
    <cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.list_cv%">
    </cfquery>
    <cfquery name="get_cv_status_query" datasource="#dsn#">
        SELECT 
            STATUS_ID,STATUS,ICON_NAME
        FROM 
            SETUP_CV_STATUS
        ORDER BY
            STATUS_ID
    </cfquery>
    <cfif filtered>
        <cfquery name="get_cv" datasource="#dsn#">
            SELECT
                AP.EMPAPP_ID,
                AP.NAME,
                AP.SURNAME,
                AP.EMAIL,
                AP.MOBILCODE,
                AP.MOBIL,
                AP.MOBILCODE2,
                AP.MOBIL2,
                AP.PHOTO,
                AP.PHOTO_SERVER_ID,
                AP.HOMETELCODE,
                AP.HOMETEL,
                AP.SEX,
                AP.CV_STAGE,
                AP.APP_COLOR_STATUS,
                AP.RECORD_DATE,
                EW.EXP,
                EW.EXP_POSITION,
                EU.EDU_NAME,
                EU.EDU_PART_NAME,
                EI.BIRTH_DATE
            FROM
                EMPLOYEES_APP AP 
                OUTER APPLY (SELECT TOP 1 EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO EU WHERE AP.EMPAPP_ID = EU.EMPAPP_ID ORDER BY EDU_START DESC) EU
                OUTER APPLY (SELECT TOP 1 EXP,EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO EW WHERE AP.EMPAPP_ID = EW.EMPAPP_ID ORDER BY EXP_START DESC) EW
                OUTER APPLY (SELECT BIRTH_DATE FROM EMPLOYEES_IDENTY EI WHERE EMPAPP_ID IS NOT NULL AND AP.EMPAPP_ID =EI.EMPAPP_ID ) EI
            WHERE
                EMPAPP_ID IS NOT NULL
                <cfif len(attributes.keyword)>
                 	AND (AP.NAME + ' ' + AP.SURNAME LIKE '#attributes.keyword#%' OR AP.SURNAME LIKE '#attributes.keyword#%')
                </cfif>
                <cfif len(attributes.cv_status)>
                	AND APP_COLOR_STATUS = #attributes.cv_status#
                </cfif>
                <cfif len(attributes.status)>
                 	AND AP.APP_STATUS=#attributes.status#
                </cfif>
                <cfif len(attributes.emp_app_type) and attributes.emp_app_type eq 1>
                     AND AP.RECORD_APP_IP IS NULL
                     AND AP.RECORD_IP IS NOT NULL
                <cfelseif len(attributes.emp_app_type) and attributes.emp_app_type eq 0>
                     AND AP.RECORD_IP IS NULL
                     AND AP.RECORD_APP_IP IS NOT NULL
                </cfif>
                <cfif isDefined('attributes.STARTDATE') and len(attributes.STARTDATE) gt 5>
                	AND RECORD_DATE >= #attributes.STARTDATE#
                </cfif>
                <cfif isDefined('attributes.FINISHDATE') and len(attributes.FINISHDATE) gt 5>
                	AND RECORD_DATE < #DATEADD('d',1,attributes.finishdate)#
                </cfif>
          	ORDER BY 
                NAME
        </cfquery>
    <cfelse>
        <cfset get_cv.recordcount=0>
    </cfif>   
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_cv.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>  
    <cfset url_str = "">
    <cfif isdefined("attributes.keyword")>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfif isdefined("attributes.status")>
        <cfset url_str = "#url_str#&status=#attributes.status#">
    </cfif>
    <cfif isdefined("attributes.emp_app_type")>
        <cfset url_str = "#url_str#&emp_app_type=#attributes.emp_app_type#">
    </cfif>
    <cfif isdefined('attributes.cv_status') and len(attributes.cv_status)>
        <cfset url_str="#url_str#&cv_status=#cv_status#">
    </cfif>
    <cfif len(attributes.startdate) gt 5>
        <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
    </cfif>
    <cfif len(attributes.finishdate) gt 5>
        <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
        <cfset url_str="#url_str#&process_stage=#attributes.process_stage#">
    </cfif>
    <cfif get_cv.recordcount>
        <cfset app_color_status_list =''>
        <cfset cv_stage_list=''>
        <cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(app_color_status) and (not listfind(app_color_status_list,app_color_status))>
                <cfset app_color_status_list = listappend(app_color_status_list,get_cv.app_color_status,',')>
            </cfif>
            <cfif len(cv_stage) and (not listfind(cv_stage_list,cv_stage))>
                <cfset cv_stage_list = listappend(cv_stage_list,cv_stage)>
            </cfif>
        </cfoutput>	
        <cfif len(cv_stage_list)>
            <cfset cv_stage_list=listsort(cv_stage_list,"numeric","ASC",",")>
            <cfquery name="process_type" datasource="#dsn#">
                SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#cv_stage_list#) ORDER BY PROCESS_ROW_ID
            </cfquery>
        </cfif>
        <cfif listlen(app_color_status_list)>
            <cfquery name="get_cv_status" datasource="#dsn#">
                SELECT 
                    STATUS_ID,
                    STATUS,
                    ICON_NAME
                FROM 
                    SETUP_CV_STATUS
                WHERE 
                    STATUS_ID IN (#app_color_status_list#)
                ORDER BY 
                    STATUS_ID
            </cfquery>
            <cfset app_color_status_list = listsort(valuelist(get_cv_status.status_id,','),"numeric","ASC",',')>
        </cfif>
        <cfoutput query="get_cv">
            <!---<cfquery name="get_app_edu_info" datasource="#dsn#">
                SELECT TOP 1 EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #get_cv.empapp_id# ORDER BY EDU_START DESC
            </cfquery>
            <cfquery name="get_app_work_info" datasource="#dsn#">
                SELECT TOP 1 EXP,EXP_POSITION FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #get_cv.empapp_id# ORDER BY EXP_START DESC
            </cfquery>
            <cfquery name="get_birth_date" datasource="#dsn#">
                SELECT BIRTH_DATE FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID IS NOT NULL AND EMPAPP_ID = #get_cv.empapp_id# 
            </cfquery>--->
            <cfif len(birth_date)>
                <cfset YAS = datediff("yyyy",birth_date,now())>
            </cfif>
        </cfoutput>
    </cfif>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfinclude template="../hr/query/get_mobil_cats.cfm">
    <cfinclude template="../hr/query/get_edu_level.cfm">
    <cfinclude template="../hr/query/get_im_cats.cfm">
    <cfinclude template="../hr/ehesap/query/get_our_comp_and_branchs.cfm">
   	<cfquery name="get_unv" datasource="#dsn#">
        SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
    </cfquery>
    <cfquery name="get_school_part" datasource="#dsn#">
        SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
    </cfquery>
    <cfquery name="get_high_school_part" datasource="#dsn#">
        SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
    </cfquery>
    <cfquery name="get_cv_status" datasource="#dsn#">
        SELECT STATUS_ID, ICON_NAME, STATUS FROM SETUP_CV_STATUS
    </cfquery>
    <cfquery name="get_reference_type" datasource="#dsn#">
        SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
    </cfquery>
    <cfquery name="GET_LANGUAGES" datasource="#dsn#">
        SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
    </cfquery>
    <cfquery name="KNOW_LEVELS" datasource="#dsn#">
        SELECT KNOWLEVEL_ID,KNOWLEVEL FROM SETUP_KNOWLEVEL
    </cfquery>
    <cfquery name="get_city" datasource="#dsn#">
        SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
    </cfquery>
   	<cfquery name="get_country" datasource="#dsn#">
        SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
    </cfquery>
    <cfquery name="get_branch" datasource="#dsn#">
        SELECT 
            BRANCH_ID,
            BRANCH_NAME,
            BRANCH_CITY
        FROM 
            BRANCH
        WHERE 
        	BRANCH_STATUS =1
        ORDER BY 
        	BRANCH_NAME
    </cfquery>
    <cfquery name="GET_ZONES" datasource="#DSN#">
        SELECT ZONE_ID, ZONE_NAME FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
    </cfquery>
    <cfquery name="get_cv_source" datasource="#dsn#">
        SELECT CV_SOURCE_ID,SOURCE_HEAD FROM SETUP_CV_SOURCE ORDER BY SOURCE_HEAD
    </cfquery>
    <cfquery name="get_cv_unit" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            SETUP_CV_UNIT
        WHERE 
            IS_ACTIVE=1
    </cfquery>
    <cfquery name="get_position_cat" datasource="#dsn#">
        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_UPPER_TYPE = 1 
    </cfquery>
    <cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT
            *
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #SESSION.EP.PERIOD_ID#
    </cfquery>
    <cfinclude template="../hr/query/get_driverlicence.cfm">
	<cfif attributes.event is 'add'>
        <cf_xml_page_edit fuseact="hr.form_add_cv">
        <cfinclude template="../hr/query/get_id_card_cats.cfm">
        <cfparam name="attributes.homecity" default="">
        <cfparam name="attributes.county_id" default="">
        <cfparam name="attributes.homecounty" default="">
        <cfparam name="attributes.branch_id" default="#listgetat(session.ep.USER_LOCATION,2,'-')#">
        <cfquery name="get_hr_detail" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_DETAIL
        </cfquery>
        <cfquery name="get_country2" dbtype="query" maxrows="1">
            SELECT COUNTRY_ID FROM get_country WHERE IS_DEFAULT = 1	
        </cfquery>
        <cfif isdefined('attributes.homecountry') and len(attributes.homecountry)>
            <cfquery name="GET_CITY_NAME" datasource="#DSN#">
                SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #attributes.homecountry#
            </cfquery>
        <cfelseif get_country2.recordcount>
            <cfquery name="GET_CITY_NAME" datasource="#DSN#">
                SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #get_country2.country_id#
            </cfquery>                                                           
        </cfif>
        <cfif isdefined('attributes.homecity') and len(attributes.homecity)>
            <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
                SELECT * FROM SETUP_COUNTY WHERE CITY = #attributes.homecity#
            </cfquery>
        </cfif>
    <cfelseif attributes.event is 'upd'>
        <cf_xml_page_edit fuseact="hr.form_upd_cv">
        <cfscript>
            get_imcat = createObject("component","hr.cfc.get_im");
            get_imcat.dsn = dsn;
            get_ims = get_imcat.get_im(
                empapp_id : attributes.empapp_id
            );
        </cfscript>
        <cfif not isnumeric(attributes.empapp_id)>
            <cfset hata = 10>
            <cfinclude template="../../dsp_hata.cfm">
        </cfif>
        <cfinclude template="../hr/query/get_app.cfm">
        <cfif not get_app.recordcount>
            <script type="text/javascript">
                alert('Özgeçmişin kaydı bulunamıyor kayıt silinmiş olabilir!');
                history.go(-1);
            </script>
            <cfabort>
        </cfif>
        <cfinclude template="../hr/query/get_app_identy.cfm">
        <cfquery name="get_computer_info" datasource="#dsn#">
            SELECT * FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_STATUS = 1
        </cfquery>
        <cfquery name="get_teacher_info" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID = #EMPAPP_ID#
        </cfquery>
        <cfquery name="get_app_pos" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_APP_POS WHERE EMPAPP_ID=#get_app.empapp_id#	
        </cfquery>
        <cfquery name="get_emp_course" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_COURSE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
        </cfquery>
        <cfquery name="get_emp_reference" datasource="#dsn#">
            SELECT * FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
        </cfquery>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT * FROM SETUP_COUNTY <cfif len(get_app.homecity)>WHERE CITY = #get_app.homecity#</cfif>
        </cfquery>
        <cfif len(get_app.homecity)>
            <cfquery name="get_homecity" dbtype="query">
                SELECT CITY_NAME FROM get_city WHERE CITY_ID=#get_app.homecity#
            </cfquery>
        </cfif>
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_ID, CITY_NAME FROM SETUP_CITY <cfif len(get_app.homecountry)>WHERE COUNTRY_ID = #get_app.homecountry#</cfif>
        </cfquery>
        <cfquery name="get_edu_info" datasource="#DSN#">
            SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
        </cfquery>
        <cfoutput query="get_edu_info">
            <cfif len(edu_type)>
                <cfquery name="get_education_level_name" datasource="#dsn#">
                    SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
                </cfquery>
                <cfset edu_type_name=get_education_level_name.education_name>
                <cfset edu_type_ = get_education_level_name.EDU_TYPE>											
            </cfif>
            <cfif len(edu_id) and edu_id neq -1>
                <cfquery name="get_unv_name" datasource="#dsn#">
                    SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                </cfquery>
                <cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
            <cfelse>
                <cfset edu_name_degisken = edu_name>
            </cfif>
            <cfif (len(edu_part_id) and edu_part_id neq -1)>
                <cfif get_education_level_name.edu_type eq 1> <!--- edu_type 0:İlköğretim,1:lise,2:üniversite--->
                    <cfquery name="get_high_school_part_name" datasource="#dsn#">
                        SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                    </cfquery>
                    <cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
                <cfelse>
                    <cfquery name="get_school_part_name" datasource="#dsn#">
                        SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #edu_part_id#
                    </cfquery>
                    <cfset edu_part_name_degisken = get_school_part_name.PART_NAME>
                </cfif>
            <cfelseif len(edu_part_name)>
                <cfset edu_part_name_degisken = edu_part_name>
            <cfelse>
                <cfset edu_part_name_degisken = "">
            </cfif>
        </cfoutput>
        <cfquery name="get_emp_language" datasource="#dsn#">
            SELECT 
                EMPAPP_ID,
                LANG_ID,
                LANG_SPEAK,
                LANG_WRITE,
                LANG_MEAN,
                LANG_WHERE 
            FROM 
                EMPLOYEES_APP_LANGUAGE
            WHERE
                EMPAPP_ID = #EMPAPP_ID#
        </cfquery>
        <cfquery name="get_work_info" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_APP_WORK_INFO
            WHERE
                EMPAPP_ID=#attributes.empapp_id#
        </cfquery>
        <cfoutput query="get_work_info">
            <cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
                <cfquery name="get_sector_cat" datasource="#dsn#">
                    SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
                </cfquery>
            </cfif>                                                        
            <cfif isdefined("exp_task_id") and len(exp_task_id)>
                <cfquery name="get_exp_task_name" datasource="#dsn#">
                    SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
                </cfquery>
            </cfif>
            <cfif isdefined("exp_work_type_id") and len(exp_work_type_id)>
                <cfquery name="get_exp_work_type_name" datasource="#dsn#">
                    SELECT WORK_TYPE_ID,WORK_TYPE_NAME FROM SETUP_WORK_TYPE WHERE WORK_TYPE_ID = #exp_work_type_id#
                </cfquery>
            </cfif>
        </cfoutput>   
        <cfquery name="get_relatives" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_RELATIVES
            WHERE
                EMPAPP_ID=#attributes.empapp_id#
            ORDER BY
                BIRTH_DATE, NAME, SURNAME, RELATIVE_LEVEL
        </cfquery>
        <cfif get_cv_unit.recordcount>
            <cfquery name="get_app_unit" datasource="#dsn#"> 
                SELECT 
                    UNIT_ID,UNIT_ROW
                FROM 
                    EMPLOYEES_APP_UNIT
                WHERE 
                    EMPAPP_ID=#attributes.empapp_id#
            </cfquery>
            <cfset liste = valuelist(get_app_unit.unit_id)>
            <cfset liste_row = valuelist(get_app_unit.unit_row)>
        </cfif>
  	</cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		$(document).ready(function(){
			if($('input[name=cv_type]:checked').val() != 1)
			{
				gizle(referans_name);
				gizle(referans_task);
			}
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Muaf.style.display='none';
			disp_spouse();
			disp_child();
		});
		function box_show(id)
		{	
					
			$("#"+id.id).removeClass("hide");		
		}
		function all_box_hide(id)
		{
			document.getElementById('handle_orta_box').innerHTML = id;
			for(var i=0;i<11;i++)
			{
				//$("#gizli"+i).css("display", "none");
				$("#gizli"+i).addClass("hide");
			
			}
		}
		function referans_calistir()
		{
			/*if(document.employe_detail.cv_type[0].checked == true)*/
			if($('input[name=cv_type]:checked').val() == 0)
			{
				gizle(referans_name);
				gizle(referans_task);
			}
			else
			{
				goster(referans_name);
				goster(referans_task);
			}
		}
		var add_ref_info=0;
		function del_ref(dell){
				var my_element1=eval("employe_detail.del_ref_info"+dell);
				my_element1.value=0;
				var my_element1=eval("ref_info_"+dell);
				my_element1.style.display="none";
		}
		function add_ref_info_(){
			add_ref_info++;
			document.getElementById('add_ref_info').value=add_ref_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
			newRow.setAttribute("name","ref_info_" + add_ref_info);
			newRow.setAttribute("id","ref_info_" + add_ref_info);
			document.getElementById('referance_info').value=add_ref_info;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><i class="icon-trash-o btnPointer" onclick="del_ref(' + add_ref_info + ');"></i>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="ref_type' + add_ref_info +'"><option value=""><cf_get_lang no="155.Referans Tipi"></option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput>/select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'">';
		}
		var add_im_info=0;
		function del_im(dell){
				var my_emement1=eval("employe_detail.del_im_info"+dell);
				my_emement1.value=0;
				var my_element1=eval("im_info_"+dell);
				my_element1.style.display="none";
		}
		function add_im_info_(){
			add_im_info++;
			document.getElementById('add_im_info').value=add_im_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
			newRow.setAttribute("name","im_info_" + add_im_info);
			newRow.setAttribute("id","im_info_" + add_im_info);
			document.getElementById('instant_info').value=add_im_info;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><i class="icon-trash-o btnPointer" onclick="del_im(' + add_im_info + ');"></i>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="imcat_id' + add_im_info +'"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput>/select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="im' + add_im_info +'">';
		}
		var extra_course = <cfif isdefined("get_emp_course")><cfoutput>'#get_emp_course.recordcount#'</cfoutput><cfelse>0</cfif>;
		/*value="'+course_subject+'"value="'+course_year+'" value="'+course_location+'"value="'+course_period+'"*/
		function sil_(del){
				var my_element_=eval("employe_detail.del_course_prog"+del);
				my_element_.value=0;
				var my_element_=eval("pro_course"+del);
				my_element_.style.display="none";
		
		}		
		function add_row_course(){
			extra_course++;
			employe_detail.extra_course.value = extra_course;
			var newRow;
			var newCell;
				newRow = document.getElementById("add_course_pro").insertRow(document.getElementById("add_course_pro").rows.length);
				newRow.setAttribute("name","pro_course" + extra_course);
				newRow.setAttribute("id","pro_course" + extra_course);
				document.employe_detail.extra_course.value=extra_course;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + extra_course +'"><i class="icon-trash-o btnPointer" onclick="sil_(' + extra_course + ');"></i>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="kurs1_' + extra_course +'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="kurs1_yer' + extra_course +'">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="kurs1_exp' + extra_course +'" maxlength="200">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="kurs1_yil' + extra_course +'"  maxlength="4" onKeyup="isNumber(this);">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="kurs1_gun' + extra_course +'">';
		}
		function seviye()
		{
			if(document.employe_detail.defected_level.disabled==true)
			{document.employe_detail.defected_level.disabled=false;}
			else
			{document.employe_detail.defected_level.disabled=true;}
		}
		function pencere_ac()
		{
			x = document.employe_detail.homecountry.selectedIndex;
			if (document.employe_detail.homecountry[x].value == "")
			{
				alert("<cf_get_lang no ='1091.İlk Olarak Ülke Seçiniz'>.");
			}	
			else if(document.employe_detail.homecity.value == "")
			{
				alert("<cf_get_lang no ='1405.İl Seçiniz'>!");
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=employe_detail.county_id&field_name=employe_detail.homecounty&city_id=' + document.employe_detail.homecity.value,'small');
			}
		}
		function pencere_ac_city()
		{
			x = document.employe_detail.homecountry.selectedIndex;
			if (document.employe_detail.homecountry[x].value == "")
			{
				alert("<cf_get_lang no='1091.İlk Olarak Ülke Seçiniz'> !");
			}	
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.employe_detail.homecountry.value,'small');
			}
		}
		<cfoutput>
			<cfif get_cv_unit.recordcount>
				unit_count=#get_cv_unit.recordcount#;
			<cfelse>
				unit_count=0;
			</cfif>
		</cfoutput>
		function seviye_kontrol(nesne)
		{
			for(var j=1;j<=unit_count;j++)
			{
				diger_nesne=eval("document.employe_detail.unit"+j);
				if(diger_nesne!=nesne)
				{
					if(nesne.value==diger_nesne.value && diger_nesne.value.length!=0)
					{
						alert("<cf_get_lang no ='1406.İki tane aynı seviye giremezsiniz'>!");
						diger_nesne.value='';
					}
				}
			}
		}
		function kontrol()
		{
			var obj =  document.employe_detail.photo.value;
			if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
			{
				 alert("<cf_get_lang no ='993.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");        
				return false;
			}

			var selectImcat = $('select[name^="imcat_id"]');
			if ( selectImcat ) {
				
					for (i = 0 ; i < add_im_info; i++ ){
				
							var selVal = selectImcat.eq(i).find(':selected');
							var inVal = $('input[name^=im]').eq(i);
						
							if( selVal.val() != '' ){
								if(inVal.val() == '')	{
										alert("<cf_get_lang_main no='13.uyarı'>: IMessege Kategorisi seçilmiş fakat Instant Mesaj adresi girilmemiş !");
										inVal.focus();
										return false;
									}//if inVal
							}//if selVal
					} // for
				} // if selectImcat

			for (var counter_=1; counter_ <=  document.employe_detail.extra_course.value; counter_++)
			{
				if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 && eval("document.employe_detail.kurs1_"+counter_).value == '')
				{
					alert("Lütfen Kurs " + counter_ + " İçin Konu Giriniz!");
					return false;
				}
				if(eval("document.employe_detail.del_course_prog"+counter_).value == 1 &&  (eval("document.employe_detail.kurs1_yil"+counter_).value == '' || eval("document.employe_detail.kurs1_yil"+counter_).value.length <4))
				{
					alert("Lütfen Kurs " + counter_ + " İçin Yıl Giriniz!");
					return false;
				}
			}
			for (var counter_=1; counter_ <=  document.employe_detail.referance_info.value; counter_++)
			{
				if(eval("document.employe_detail.ref_name"+counter_).value == '' && eval("document.employe_detail.del_ref_info"+counter_).value == 1)
				{
					alert("Lütfen Satır " + counter_ + " İçin Ad Soyad Giriniz!");
					return false;
				}
			
			}
			<cfif attributes.event is 'add'>
				return (process_cat_control() && control_last());	
			<cfelseif attributes.event is 'upd'> 
				return process_cat_control();
			</cfif>	
		}
		function tecilli_fonk(gelen)
		{
			if (gelen == 4)
			{
				Tecilli.style.display='';
				Yapti.style.display='none';
				Muaf.style.display='none';
			}
			else if(gelen == 1)
			{
				Yapti.style.display='';
				Tecilli.style.display='none';
				Muaf.style.display='none';
			}
			else if(gelen == 2)
			{
				Muaf.style.display='';
				Tecilli.style.display='none';
				Yapti.style.display='none';
			}
			else
			{
				Tecilli.style.display='none';
				Yapti.style.display='none';
				Muaf.style.display='none';
			}
		}
		function disp_child()
		{
			if($('#have_children:checked').val() == 1)
				$('#form_ul_child').css('display','');
			else
				$('#form_ul_child').css('display','none');
		}
		/* Dil Bilgileri */
		<cfif attributes.event is 'add'>
			var add_lang_info=0;
		</cfif>
			function del_lang(dell){
					var my_emement1=eval("employe_detail.del_lang_info"+dell);
					my_emement1.value=0;
					var my_element1=eval("lang_info_"+dell);
					my_element1.style.display="none";
			}
			function add_lang_info_()
			{
				add_lang_info++;
				employe_detail.add_lang_info.value=add_lang_info;
				var newRow;
				var newCell;
				newRow = document.getElementById("lang_info").insertRow(document.getElementById("lang_info").rows.length);
				newRow.setAttribute("name","lang_info_" + add_lang_info);
				newRow.setAttribute("id","lang_info_" + add_lang_info);
				employe_detail.language_info.value=add_lang_info;
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><i class="icon-trash-o btnPointer" onclick="del_lang(' + add_lang_info + ');"></i>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="lang' + add_lang_info +'"><option value=""><cf_get_lang_main no="1584.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="lang_speak' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="lang_mean' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="lang_write' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="lang_where' + add_lang_info + '" value="">';
			}
			function disp_spouse()
			{
				if($('#married:checked').val() == 1)
				{
					$('#form_ul_partner_name').css('display','');
					$('#form_ul_partner_position').css('display','');
					$('#form_ul_partner_company').css('display','');
				}
				else
				{
					$('#form_ul_partner_name').css('display','none');
					$('#form_ul_partner_position').css('display','none');
					$('#form_ul_partner_company').css('display','none');
				}
			}
		<cfif attributes.event is 'add'>			
			function onceki_adim(id)
			{
				document.getElementById('gizli'+id).style.display = 'none';
				document.getElementById('gizli'+(id-1)).style.display = '';
			}
			
			rowCount=0;
			function addRow()
			{
				rowCount++;
				document.getElementById('rowCount').value = rowCount;
				var newRow;
				var newCell;
				newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '&nbsp;';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="name_relative' + rowCount + '" value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="surname_relative' + rowCount + '">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="relative_level' + rowCount + '"><option value="1"><cf_get_lang no="180.Baba"></option><option value="2"><cf_get_lang no="385.Anne"></option><option value="3"><cf_get_lang no="190.Eşi"></option><option value="4"><cf_get_lang no="168.Oğlu"></option><option value="5"><cf_get_lang no="149.Kızı"></option><option value="6">Kardeşi</option></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","birth_date_relative" + rowCount + "_td");
				newCell.innerHTML = '<input type="text" id="birth_date_relative' + rowCount +'" name="birth_date_relative' + rowCount +'" class="text" maxlength="10" value=""> ';
				wrk_date_image('birth_date_relative' + rowCount);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="birth_place_relative' + rowCount + '" value="">';
				/*newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" name="tc_identy_no_relative' + rowCount + '" value="" style="width:75px;">';*/
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="education_relative' + rowCount + '"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="get_edu_level"><option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option></cfoutput></select><input type="checkbox" name="education_status_relative' + rowCount + '" value="1"><cf_get_lang no="398.Okuyor">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="job_relative' + rowCount + '" value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="company_relative' + rowCount + '" value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="job_position_relative' + rowCount + '" value="">';
			}
			
			function control_last()
			{
					document.getElementById('expected_price').value = filterNum(document.getElementById('expected_price').value);
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_dsp_app_prerecords&employee_name=' + document.getElementById('name_').value + '&employee_surname=' + document.getElementById('surname').value +'&identycard_no=' + document.getElementById('identycard_no').value + '&tax_number=' + document.getElementById('tax_number').value,'project');
					return true;
			}
			
			/*İş Tecrübesi*/
			row_count=0;
			satir_say=0;
			function sil(sy)
			{
				var my_element=eval("employe_detail.row_kontrol"+sy);
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
				satir_say--;
			}
			function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_work_type_id,exp_work_type_name,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
			{
				if(control == 1)
				{
					eval("employe_detail.exp_name"+my_count).value=exp_name;
					eval("employe_detail.exp_position"+my_count).value=exp_position;
					eval("employe_detail.exp_start"+my_count).value=exp_start;
					eval("employe_detail.exp_finish"+my_count).value=exp_finish;
					eval("employe_detail.exp_sector_cat"+my_count).value=exp_sector_cat;
					if(exp_sector_cat != '')
					{
					
						var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
						/*if(get_emp_cv_new.recordcount)*/
							var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
					}
					else
						var exp_sector_cat_name = '';
					eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
					eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
					if(exp_task_id != '')
					{
						var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
						/*if(get_emp_task_cv_new.recordcount)*/
							var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
					}
					else
						var exp_task_name = '';
					eval("employe_detail.exp_task_name"+my_count).value=exp_task_name;
					eval("employe_detail.exp_work_type_id" + my_count).value = exp_work_type_id;
					if(exp_work_type_id !='')
					{
						<!---var get_emp_work_type_cv_new = wrk_safe_query('hr_get_emp_work_type_cv_new','dsn',0,exp_work_type_id);
						var exp_work_type_name = get_emp_work_type_cv_new.WORK_TYPE_NAME;--->
						var exp_work_type_name = exp_work_type_name;
						}
					else
						var exp_work_type_name ='';
					eval("employe_detail.exp_work_type_name"+my_count).value=exp_work_type_name;
					eval("employe_detail.exp_telcode"+my_count).value=exp_telcode;
					eval("employe_detail.exp_tel"+my_count).value=exp_tel;
					eval("employe_detail.exp_salary"+my_count).value=exp_salary;
					eval("employe_detail.exp_extra_salary"+my_count).value=exp_extra_salary;
					eval("employe_detail.exp_extra"+my_count).value=exp_extra;
					eval("employe_detail.exp_reason"+my_count).value=exp_reason;
					eval("employe_detail.is_cont_work"+my_count).value=is_cont_work;
				}
				else
				{
					row_count++;
					document.getElementById('row_count').value = row_count;
					satir_say++;
					var new_Row;
					var new_Cell;
					get_emp_cv='';
					new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
					new_Row.setAttribute("name","frm_row" + row_count);
					new_Row.setAttribute("id","frm_row" + row_count);		
					new_Row.setAttribute("NAME","frm_row" + row_count);
					new_Row.setAttribute("ID","frm_row" + row_count);	
					
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<i class="icon-update btnPointer" onClick="gonder_add('+row_count+');"></i>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><i class="icon-trash-o btnPointer" onclick="sil(' + row_count + ');"></i>';
					new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_work_type_id' + row_count + '" value="' + exp_work_type_id +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
					new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
				
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
					if(exp_sector_cat != '')
					{
						var cv_sql = 'SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = '+exp_sector_cat+'';
						var get_emp_cv = wrk_query(cv_sql,'dsn');
						/*if(get_emp_cv.recordcount)*/
							var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
					}
					else
						var exp_sector_cat_name = '';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
					if(exp_task_id != '')
					{
						var get_emp_task_cv = wrk_safe_query("hr_get_emp_task_cv_new",'dsn',0,exp_task_id);
						/*if(get_emp_task_cv.recordcount)*/
							var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
					}
					else
						var exp_task_name = '';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly>';
					if(exp_work_type_id!='')
					{
						var work_type_sql = 'SELECT WORK_TYPE_ID, WORK_TYPE_NAME FROM SETUP_WORK_TYPE WHERE WORK_TYPE_ID= '+exp_work_type_id+'';
						var get_emp_work_type_cv = wrk_query(work_type_sql,'dsn');
						var exp_work_type_name = get_emp_work_type_cv.WORK_TYPE_NAME;
						}
					else
						var exp_work_type_name ='';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_work_type_name' + row_count + '" value="'+exp_work_type_name+'" class="boxtext" readonly>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly>';
				}
			}
			function gonder_add(count)
			{
				form_work_info.exp_name_new.value = eval("employe_detail.exp_name"+count).value;
				form_work_info.exp_position_new.value = eval("employe_detail.exp_position"+count).value;
				form_work_info.exp_sector_cat_new.value = eval("employe_detail.exp_sector_cat"+count).value;
				form_work_info.exp_task_id_new.value = eval("employe_detail.exp_task_id"+count).value;
				form_work_info.exp_work_type_id_new.value = eval("employe_detail.exp_work_type_id"+count).value;	
				form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
				form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
				form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
				form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
				form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
				form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
				form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
				form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
			
				form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
				windowopen('','large','add_kariyer_pop');
				form_work_info.target='add_kariyer_pop';
				form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
				form_work_info.submit();	
			}
			/*İş Tecrübesi*/
			
			/*Eğitim Bilgileri*/
			row_edu=0;
			satir_say_edu=0;
			function sil_edu(sv)
				{
					var my_element_edu=eval("employe_detail.row_kontrol_edu"+sv);
					my_element_edu.value=0;
					var my_element_edu=eval("frm_rowt"+sv);
					my_element_edu.style.display="none";
					satir_say_edu--;
				}
			
			function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,is_edu_continue)
			{
				var edu_type = edu_type.split(';')[0];
				var edu_name_degisken = '';
				var edu_part_name_degisken = '';
				if(ctrl_edu == 1)
				{
					eval("employe_detail.edu_type"+count_edu).value=edu_type;
					if(edu_type != undefined && edu_type != '')
					{
						var get_edu_part_name_sql = wrk_safe_query("hr_get_edu_part_name",'dsn',0,edu_type);
						if(get_edu_part_name_sql.recordcount)
							var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
					}	
					eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
					eval("employe_detail.edu_id"+count_edu).value=edu_id;
					eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
					eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
					if(edu_id != '' && edu_id != -1)
					{
						var get_cv_edu_new = wrk_safe_query("hr_get_cv_edu_new",'dsn',0,edu_id);
						if(get_cv_edu_new.recordcount)
							var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
						eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
					}
					else
					{
						eval("employe_detail.edu_name"+count_edu).value=edu_name;
					}
					eval("employe_detail.edu_start"+count_edu).value=edu_start;
					eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
					eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
					if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
					{
						var get_cv_edu_high_part_id = wrk_safe_query("hr_cv_edu_high_part_id_q",'dsn',0,edu_high_part_id);
						if(get_cv_edu_high_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
						eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
					}
					else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
					{
						var cv_edu_part_id_sql = 'SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = '+edu_part_id+'';
						var get_cv_edu_part_id = wrk_safe_query("hr_cv_edu_part_id_q",'dsn',0);
						if(get_cv_edu_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
						eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
					}
					else 
					{
						var edu_part_name_degisken = edu_part_name;
						eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
					}
					eval("employe_detail.is_edu_continue"+count_edu).value=is_edu_continue;
				}
				else
				{
					row_edu++;
					document.getElementById('row_edu').value = row_edu;
					satir_say_edu++;
					var new_Row_Edu;
					var new_Cell_Edu;
					new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
					new_Row_Edu.setAttribute("name","frm_rowt" + row_edu);
					new_Row_Edu.setAttribute("id","frm_rowt" + row_edu);		
					new_Row_Edu.setAttribute("NAME","frm_rowt" + row_edu);
					new_Row_Edu.setAttribute("ID","frm_rowt" + row_edu);
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<i class="icon-update btnPointer" onClick="gonder_add_edu('+row_edu+');"></i>';
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><i class="icon-trash-o btnPointer" onclick="sil_edu(' + row_edu + ');"></i>';
					new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_type' + row_edu + '" value="'+ edu_type +'">';
					new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'">';
					new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'">';
					new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'">';
					new_Cell_Edu.innerHTML += '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'">';
			
						
					if(edu_type != undefined && edu_type != '')
					{
						var get_edu_part_name_sql = wrk_safe_query("hr_get_edu_part_name",'dsn',0,edu_type);
						if(get_edu_part_name_sql.recordcount)
							var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
					}
						
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
					if(edu_id != undefined && edu_id != '')
					{
						var get_cv_edu_new = wrk_safe_query("hr_get_cv_edu_new",'dsn',0,edu_id);
						if(get_cv_edu_new.recordcount)
							var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
					}
					else if(edu_name != undefined && edu_name != '')
					{
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
					}
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
					new_Cell_Edu.innerHTML += '<input type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
					if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
					{
						var get_cv_edu_high_part_id = wrk_safe_query("hr_cv_edu_high_part_id_q",'dsn',0,edu_high_part_id);
						if(get_cv_edu_high_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
					}
					else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
					{
						var get_cv_edu_part_id = wrk_safe_query("hr_cv_edu_part_id_q",'dsn',0,edu_part_id);
						if(get_cv_edu_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
					}
					else
					{
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
					}
				}
			}
			function gonder_add_edu(count_new)
			{
				form_edu_info.edu_type_new.value = eval("employe_detail.edu_type"+count_new).value;//Okul Türü
				if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
					form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
				else
					form_edu_info.edu_id_new.value = '';
				
				if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
					form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
				else
					form_edu_info.edu_name_new.value = '';
				
				form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
				form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
				form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
				if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
					form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
				else
					form_edu_info.edu_high_part_id_new.value = '';
					
				if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
					form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
				else
					form_edu_info.edu_part_id_new.value = '';
					
				if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
					form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
				else
					form_edu_info.edu_part_name_new.value = '';
				form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
				windowopen('','medium','kryr_pop');
				form_edu_info.target='kryr_pop';
				form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
				form_edu_info.submit();	
			}
			/*Eğitim Bilgileri*/
		<cfelseif attributes.event is 'upd'>
			var add_lang_info = <cfif isdefined("get_emp_language")><cfoutput>#get_emp_language.recordcount#</cfoutput><cfelse>0</cfif>;
	
			function visible_mil(gelen)
			{
				if(gelen == 0)
				{
					military.style.display = 'none';
					Tecilli.style.display='none';
					Yapti.style.display='none';
					Muaf.style.display='none';
				}
				else
				{
					military.style.display = '';
					Yapti.style.display='';
					
				}
			}		
			/*function sil_lang(del){
					var my_element_=eval("employe_detail.del_lang_prog"+del);
					my_element_.value=0;
					var my_element_=eval("pro_lang"+del);
					my_element_.style.display="none";
			}
			*/
			function add_select_list()
			{
					windowopen('','list','select_list_window');
					create_selected_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&search_app=1&list_empapp_id=#attributes.empapp_id#&search_app_pos=0</cfoutput>'; <!---<cfif not len(get_app_pos.app_pos_id)>&search_app=1&list_empapp_id=#attributes.empapp_id#&search_app_pos=0</cfif>--->
					create_selected_list.target='select_list_window';create_selected_list.submit();
					/*document.create_selected_list.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
					/*document.create_selected_list.list_app_pos_id.value='';*/ 
			
			}
			function edit_select_list()
			{
					windowopen('','list','select_list_window');
					create_selected_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1&search_app=1&list_empapp_id=#attributes.empapp_id#&search_app_pos=0</cfoutput>';<!--- <cfif not len(get_app_pos.app_pos_id)>&search_app=1&list_empapp_id=#attributes.empapp_id#&search_app_pos=0</cfif>--->
					create_selected_list.target='select_list_window';
					create_selected_list.submit();
					document.create_selected_list.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
					document.create_selected_list.list_app_pos_id.value='';
			}		
			/*yakınlar için*/
			<cfoutput>
				<cfif get_relatives.recordcount neq 0>
					rowCount=#get_cv_unit.recordcount#;
					employe_detail.rowCount.value = rowCount;
				<cfelse>
					rowCount=0;
				</cfif>
			</cfoutput>
			function addRow()
			{
				rowCount++;
				satir_say++;
				employe_detail.rowCount.value = rowCount;
				var newRow;
				var newCell;
				newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);	
				newRow.setAttribute("name","frm_row" + rowCount);
				newRow.setAttribute("id","frm_row" + rowCount);		
				newRow.setAttribute("NAME","frm_row" + rowCount);
				newRow.setAttribute("ID","frm_row" + rowCount);	
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<i class="icon-trash-o btnPointer" onClick="relative_sil('+rowCount+');"></i>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" id="relative_sil'+rowCount+'" name="relative_sil'+rowCount+'" value="0">';
				newCell.innerHTML += '<input type="text" name="name_relative' + rowCount + '" id="name_relative' + rowCount + '" value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="surname_relative' + rowCount + '" id="surname_relative' + rowCount + '">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="relative_level' + rowCount + '"><option value="1"><cf_get_lang no="180.Babası"></option><option value="2"><cf_get_lang no="385.Annesi"></option><option value="3"><cf_get_lang no="190.Eşi"></option><option value="4"><cf_get_lang no="168.Oğlu"></option><option value="5"><cf_get_lang no="149.Kızı"></option><option value="6">Kardeşi</option></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","birth_date_relative" + rowCount + "_td");
				newCell.innerHTML = '<input type="text" nowrap="nowrap" id="birth_date_relative' + rowCount +'" name="birth_date_relative' + rowCount +'" maxlength="10" value=""> ';
				wrk_date_image('birth_date_relative' + rowCount);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="birth_place_relative' + rowCount + '" value="">';
				/*newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" name="tc_identy_no_relative' + rowCount + '" value="" style="width:75px;">';*/
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<select nowrap="nowrap" name="education_relative' + rowCount + '"> <option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfoutput query="get_edu_level"><option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option></cfoutput></select> <input type="checkbox" name="education_status_relative' + rowCount + '" value="1"><cf_get_lang no="398.Okuyor">';
		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="job_relative' + rowCount + '" value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="company_relative' + rowCount + '" value="">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="job_position_relative' + rowCount + '" value="">';
				
			}
			function relative_sil(satir)
			{
				var my_element=eval("employe_detail.relative_sil"+satir);
				my_element.value=0;
				var my_element=eval("frm_row"+satir);
				my_element.style.display="none";
				satir_say--;
			}
			function unformat_fields()
			{
				employe_detail.expected_price.value=filterNum(employe_detail.expected_price.value);
				return true;
			}
			/*iş tecrübeleri*/
			row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
			satir_say=0;
			function sil(sy)
			{
				var my_element=eval("employe_detail.row_kontrol"+sy);
				my_element.value=0;
				var my_element=eval("frm_row"+sy);
				my_element.style.display="none";
				satir_say--;
			}
			
			function gonder_upd(count)
			{
				form_work_info.exp_name_new.value = eval("employe_detail.exp_name"+count).value;
				form_work_info.exp_position_new.value = eval("employe_detail.exp_position"+count).value;
				form_work_info.exp_sector_cat_new.value = eval("employe_detail.exp_sector_cat"+count).value;
				form_work_info.exp_task_id_new.value = eval("employe_detail.exp_task_id"+count).value;
				form_work_info.exp_work_type_id_new.value = eval("employe_detail.exp_work_type_id"+count).value;
				form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
				form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
				form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
				form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
				form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
				form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
				form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
				form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
				form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
				windowopen('','medium','kariyer_pop');
				form_work_info.target='kariyer_pop';
				form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
				form_work_info.submit();	
			}
			
			function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_work_type_id,exp_work_type_name,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
			{
				if(control == 1)
				{
					eval("employe_detail.exp_name"+my_count).value=exp_name;
					eval("employe_detail.exp_position"+my_count).value=exp_position;
					eval("employe_detail.exp_start"+my_count).value=exp_start;
					eval("employe_detail.exp_finish"+my_count).value=exp_finish;
					eval("employe_detail.exp_sector_cat"+my_count).value=exp_sector_cat;
					if(exp_sector_cat != '')
					{
						var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
						/*if(get_emp_cv_new.recordcount)*/
							var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
					}
					else
						var exp_sector_cat_name = '';
					eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
					eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
					if(exp_task_id != '')
					{
						var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
						/*if(get_emp_task_cv_new.recordcount)*/
							var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
					}
					else
						var exp_task_name = '';
					eval("employe_detail.exp_task_name"+my_count).value=exp_task_name;
					eval("employe_detail.exp_work_type_id"+my_count).value=exp_work_type_id;
					
					if(exp_work_type_id != '')
					{
						//var get_emp_work_type_cv_new = wrk_safe_query('hr_get_emp_work_type_cv_new','dsn',0,exp_work_type_id);
						/*if(get_emp_work_type_cv_new.recordcount)*/
							var exp_work_type_name = exp_work_type_name;
					}
					else
						var exp_work_type_name = '';
					eval("employe_detail.exp_work_type_name"+my_count).value=exp_work_type_name;
					eval("employe_detail.exp_telcode"+my_count).value=exp_telcode;
					eval("employe_detail.exp_tel"+my_count).value=exp_tel;
					eval("employe_detail.exp_salary"+my_count).value=exp_salary;
					eval("employe_detail.exp_extra_salary"+my_count).value=exp_extra_salary;
					eval("employe_detail.exp_extra"+my_count).value=exp_extra;
					eval("employe_detail.exp_reason"+my_count).value=exp_reason;
					eval("employe_detail.is_cont_work"+my_count).value=is_cont_work;
				}
				else
				{
					row_count++;
					employe_detail.row_count.value = row_count;
					satir_say++;
					var new_Row;
					var new_Cell;
					new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);	
					new_Row.setAttribute("name","frm_row" + row_count);
					new_Row.setAttribute("id","frm_row" + row_count);		
					new_Row.setAttribute("NAME","frm_row" + row_count);
					new_Row.setAttribute("ID","frm_row" + row_count);	
					
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><i class="icon-trash-o btnPointer" onclick="sil(' + row_count + ');"></i>';
					new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_work_type_id' + row_count + '" value="'+ exp_work_type_id +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
					new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
					new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<i class="icon-update btnPointer" onClick="gonder_upd('+row_count+');"></i>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
					if(exp_sector_cat != '')
					{
						var get_emp_cv = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
						/*if(get_emp_cv.recordcount)*/
							var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
					}
					else
						var exp_sector_cat_name = '';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
					if(exp_task_id != '')
					{
						var get_emp_task_cv = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
						/*if(get_emp_task_cv.recordcount)*/
							var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
					}
					else
						var exp_task_name = '';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly>';
					if(exp_work_type_id != '')
					{
						var get_emp_work_type_cv = wrk_safe_query('hr_get_emp_work_type_cv_new','dsn',0,exp_work_type_id);
						/*if(get_emp_task_cv.recordcount)*/
							var exp_work_type_name = get_emp_work_type_cv.WORK_TYPE_NAME;
					}
					else
						var exp_work_type_name = '';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_work_type_name' + row_count + '" value="'+exp_work_type_name+'" class="boxtext" readonly>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly>';
					new_Cell = new_Row.insertCell(new_Row.cells.length);
					new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly>';
				}
			}
			/*iş tecrübeleri*/
			
			/*eğitim bilgileri*/
			row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
			satir_say_edu=0;
			
			function sil_edu(sv)
			{
				var my_element_edu=eval("employe_detail.row_kontrol_edu"+sv);
				my_element_edu.value=0;
				var my_element_edu=eval("frm_row_edu"+sv);
				my_element_edu.style.display="none";
				satir_say_edu--;
			}
			
			function gonder_upd_edu(count_new)
			{
				
				form_edu_info.edu_type_new.value = eval("employe_detail.edu_type"+count_new).value;//Okul Türü
				if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
					form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
				else
					form_edu_info.edu_id_new.value = '';
				
				if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
					form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
				else
					form_edu_info.edu_name_new.value = '';
				
				form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
				form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
				form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
				if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
					form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
				else
					form_edu_info.edu_high_part_id_new.value = '';
					
				if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
					form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
				else
					form_edu_info.edu_part_id_new.value = '';
					
				if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
					form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
				else
					form_edu_info.edu_part_name_new.value = '';
				form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
				windowopen('','medium','kryr_pop');
				form_edu_info.target='kryr_pop';
				form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
				form_edu_info.submit();	
			}
			
			function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,is_edu_continue,edu_part_name)
			{
				var edu_type = edu_type.split(';')[0];
				if(ctrl_edu == 1)
				{
					eval("employe_detail.edu_type"+count_edu).value=edu_type;
					if(edu_type != undefined && edu_type != '')
					{
						var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
						if(get_edu_part_name_sql.recordcount)
							var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
					}	
						
					eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
					eval("employe_detail.edu_id"+count_edu).value=edu_id;
					eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
					eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
					if(edu_id != '' && edu_id != -1)
					{
					
						var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
						if(get_cv_edu_new.recordcount)
							var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;		
						eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
					}
					else
					{
						var edu_name_degisken = edu_name;
						eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
					}
					eval("employe_detail.edu_start"+count_edu).value=edu_start;
					eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
					eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
					if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1)
					{
					
						var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
						if(get_cv_edu_high_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
						eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
					}
					else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
					{
					
						var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
						if(get_cv_edu_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
						eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
					}
					else
					{
						var edu_part_name_degisken = edu_part_name;
						eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
					}
					eval("employe_detail.is_edu_continue"+count_edu).value=is_edu_continue;
				}
				else
				{
					row_edu++;
					employe_detail.row_edu.value = row_edu;
					satir_say_edu++;
					var new_Row_Edu;
					var new_Cell_Edu;
					new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
					new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
					new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
					new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
					new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);
					
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<i class="icon-update btnPointer" onClick="gonder_upd_edu('+row_edu+');"></i>';
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input style="display:none;" type="hidden" id="row_kontrol_edu' + row_edu + '" value="1" name="row_kontrol_edu' + row_edu +'" ><i class="icon-trash-o btnPointer" onclick="sil_edu(' + row_edu + ');"></i>';
					new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_type' + row_edu + '" name="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
					new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_id' + row_edu + '" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
					new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_high_part_id' + row_edu + '" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" class="boxtext" readonly>';
					new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="edu_part_id' + row_edu + '" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" class="boxtext" readonly>';
					new_Cell_Edu.innerHTML += '<input style="display:none;" type="hidden" id="is_edu_continue' + row_edu + '" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" class="boxtext" readonly>';
		
						
					if(edu_type != undefined && edu_type != '')
					{
						var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
						if(get_edu_part_name_sql.recordcount)
							var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
					}
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" id="edu_type_name' + row_edu + '" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
					if(edu_id != '' && edu_id != -1)
					{
						var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
						if(get_cv_edu_new.recordcount)
							var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input id="edu_name' + row_edu + '" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
					}
					else
					{
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
					}
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					//new_Cell_Edu.innerHTML = '<input style="width:10px;" type="text" id="gizli' + row_edu + '" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
					//new_Cell_Edu = new_Row_Edu.insertCell();
					new_Cell_Edu.innerHTML = '<input type="text" id="edu_start' + row_edu + '" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" id="edu_finish' + row_edu + '" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input type="text" id="edu_rank' + row_edu + '" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
					if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
					{
					
						var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
						if(get_cv_edu_high_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
					}
					else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
					{
					
						var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
						if(get_cv_edu_part_id.recordcount)
							var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
					}
					else
					{
						new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
						new_Cell_Edu.innerHTML = '<input id="edu_part_name' + row_edu + '" type="text" name="edu_part_name' + row_edu + '" value="" class="boxtext" readonly>';
					}
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
	{
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	}
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_cv';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_cv.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_cv';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_cv.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_cv.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_cv&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_cv';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_cv.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_cv.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_cv&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'empapp_id=##attributes.empapp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_app.empapp_id##';
	
	WOStruct['#attributes.fuseaction#']['upd_other'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_other']['window'] = 'normal';
	WOSTRUCT['#attributes.fuseaction#']['upd_other']['fuseaction'] = 'hr.form_upd_cv';
	WOSTRUCT['#attributes.fuseaction#']['upd_other']['filePath'] = 'hr/form/upd_cv.cfm';
	WOSTRUCT['#attributes.fuseaction#']['upd_other']['queryPath'] = 'hr/query/upd_cv.cfm';
	WOSTRUCT['#attributes.fuseaction#']['upd_other']['nextEvent'] = 'hr.list_cv&event=upd';
	WOSTRUCT['#attributes.fuseaction#']['upd_other']['parameters'] = 'empapp_id=##attributes.empapp_id##';
	WOSTRUCT['#attributes.fuseaction#']['upd_other']['Identity'] = '##get_app.empapp_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_cv';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_cv.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_cv.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_cv';
	}
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[1752]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "add_select_list();";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[1753]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "edit_select_list();";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[87]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_add_app_pos&app_pos_id=#get_app_pos.app_pos_id#&empapp_id=#get_app.empapp_id#','medium');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[191]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_select_list_empapp&empapp_id=#get_app.empapp_id#','medium');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_app_history&empapp_id=#empapp_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_name=empapp_id&action_id=#attributes.empapp_id#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.empapp_id#&print_type=170','page','workcube_print');";


		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_cv&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_app&action=print&id=#attributes.empapp_id#&module=hr&iframe=1','page');return false;";

		if(xml_is_isebaslat == 1)
		{
			if (get_app.work_started == 0 || get_app.work_finished == 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array.item[618]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_add_app_test_time&empapp_id=#attributes.empapp_id#&process_stage_=#get_app.cv_stage#','medium');";
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listCv';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_APP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2']";
</cfscript>
