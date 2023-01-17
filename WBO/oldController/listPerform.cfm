<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.position_cat_id" default=''>
    <cfparam name="attributes.emp_status" default=1>
    <cfparam name="attributes.period_year" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department_name" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch_name" default="">
    <cfparam name="attributes.hierarchy" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.my_form" default="">
    <cfscript>
        if(not len(attributes.period_year) and isdefined('attributes.is_form_submit'))
            attributes.period_year = year(now());//session.ep.period_year degeri vardı ancak eski dönmede olabilir diye now yaptık
        url_str = "";
        if(isdefined('attributes.is_form_submit'))
        {
            url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#';
            if(len(attributes.keyword))
                url_str = "#url_str#&keyword=#attributes.keyword#";
            if(len(attributes.my_form))
                url_str = "#url_str#&my_form=#attributes.my_form#";
            if(len(attributes.department_id))
                url_str = "#url_str#&department_id=#attributes.department_id#";
            if(len(attributes.department_name))
                url_str = "#url_str#&department_name=#attributes.department_name#";		
            if(len(attributes.branch_name))
                url_str="#url_str#&branch_name=#attributes.branch_name#";
            if(len(attributes.branch_id))
                url_str="#url_str#&branch_id=#attributes.branch_id#";
            if(isdefined("attributes.position_cat_id"))
                url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
            if(isdefined("attributes.period_year"))
                url_str = "#url_str#&period_year=#attributes.period_year#";
            if(isdefined("attributes.attenders"))
                url_str = "#url_str#&attenders=#attributes.attenders#";
            if(isdefined('emp_status'))
                url_str = '#url_str#&emp_status=#attributes.emp_status#';
            if(isdefined('per_stage'))
                url_str = '#url_str#&per_stage=#attributes.per_stage#';
            if(isdefined('perf'))
                url_str = '#url_str#&perf=#attributes.perf#';
        }
    </cfscript>
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
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.list_perform%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfinclude template="../myhome/query/get_position_cats.cfm">
    <cfif isdefined('attributes.is_form_submit') and attributes.is_form_submit eq 1>
        <cfquery name="get_all_positions" datasource="#dsn#">
            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
        </cfquery>
        <cfset pos_code_list = valuelist(get_all_positions.position_code)>
        <!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
        <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
            SELECT
                O.EMPLOYEE_ID,
                EP.POSITION_CODE
            FROM
                OFFTIME O,
                EMPLOYEE_POSITIONS EP
            WHERE
                O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
                O.VALID = 1 AND
                #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
        </cfquery>
        <cfif Get_Offtime_Valid.recordcount>
            <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
            <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
                SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
            </cfquery>
            <cfoutput query="Get_StandBy_Position1">
                <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
            </cfoutput>
            <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
                SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
            </cfquery>
            <cfoutput query="Get_StandBy_Position2">
                <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
            </cfoutput>
            <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
                SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
            </cfquery>
            <cfoutput query="Get_StandBy_Position3">
                <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
            </cfoutput>
        </cfif>
        <cfquery name="GET_UNDER_POS" datasource="#dsn#">
            SELECT 
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_CAT_ID
            FROM 
                EMPLOYEE_POSITIONS,
                EMPLOYEE_POSITIONS_STANDBY,
                DEPARTMENT,
                BRANCH
            WHERE 
                EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE
                AND EMPLOYEE_POSITIONS.DEPARTMENT_ID =DEPARTMENT.DEPARTMENT_ID
                AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                AND EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0
                AND 
                ( 	EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE IN(#pos_code_list#)
                    OR EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#) 
                    OR EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#) 
                    OR EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#) 
                )
                <cfif len(attributes.department_id)>
                    AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
                </cfif> 
                <cfif len(attributes.branch_id)>
                    AND BRANCH.BRANCH_ID = #attributes.branch_id#
                </cfif>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND
                    (
                        EMPLOYEE_POSITIONS.POSITION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )
                </cfif>
                <cfif isdefined('attributes.perf') and attributes.perf eq 1>
                AND EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#)
                <cfelseif isdefined('attributes.perf') and attributes.perf eq 2>
                AND EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#)
                <cfelseif isdefined('attributes.perf') and attributes.perf eq 3>
                AND EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#)
                </cfif>
        </cfquery>
        <cfif get_under_pos.recordcount>
            <cfset under_emp_list=valuelist(GET_UNDER_POS.EMPLOYEE_ID,',')>
        <cfelse>
            <cfset under_emp_list=0>
        </cfif>
        <cfinclude template="../myhome/query/get_perf_results.cfm">
    <cfelse>
        <cfset get_perf_results.RECORDCOUNT = 0>
    </cfif>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_perf_results.RECORDCOUNT#'>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<!---<cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'> 
        <cfset attributes.survey_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.survey_id,accountKey:'wrk')>
        <cfset attributes.action_type_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_type_id,accountKey:'wrk')>
    </cfif>--->
    <cfquery name="get_survey_main" datasource="#dsn#">
        SELECT 
            SURVEY_MAIN_HEAD,
            SURVEY_MAIN_DETAILS ,
            PROCESS_ID,
            IS_MANAGER_0,
            IS_MANAGER_1,
            IS_MANAGER_2,
            IS_MANAGER_3,
            IS_MANAGER_4,
            TYPE,
            START_DATE AS STARTDATE,
            FINISH_DATE,
            IS_SELECTED_ATTENDER
        FROM 
            SURVEY_MAIN 
        WHERE 
            SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
    </cfquery>   
    <!--- memnuniyet anketi kontrolü SG 20131129--->
    <cfif get_survey_main.type eq 14 and isdefined('attributes.is_portal')>
        <cfquery name="get_control" datasource="#dsn#">
            SELECT
                SURVEY_MAIN_RESULT_ID
            FROM
                SURVEY_MAIN_RESULT
            WHERE
                SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
                EMPLOYEE_EMAIL = '#attributes.control_value#'
        </cfquery>
        <cfif get_control.recordcount>
            <script type="text/javascript">
                alert('Bu anketi daha önce doldurdunuz!');
                window.close();
            </script>
            <cfabort>
        </cfif>		
    </cfif>
    <cfquery name="get_survey_info" datasource="#dsn#">
        SELECT
            SC.SURVEY_CHAPTER_ID,
            SC.SURVEY_CHAPTER_HEAD,
            SC.SURVEY_CHAPTER_DETAIL,
            SQ.SURVEY_QUESTION_ID,
            SQ.QUESTION_HEAD,
            SQ.QUESTION_DETAIL,
            SQ.QUESTION_TYPE,
            SQ.QUESTION_DESIGN,
            SQ.QUESTION_IMAGE_PATH,
            SQ.IS_REQUIRED,
            SC.IS_CHAPTER_DETAIL2,
            SC.SURVEY_CHAPTER_DETAIL2,
            SC.SURVEY_CHAPTER_WEIGHT,
            SC.IS_SHOW_GD,
            SQ.IS_SHOW_GD AS QUESTION_GD
        FROM
            SURVEY_CHAPTER SC,
            SURVEY_QUESTION SQ
        WHERE
            SC.SURVEY_CHAPTER_ID = SQ.SURVEY_CHAPTER_ID AND
            SC.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
        ORDER BY
            SC.SURVEY_CHAPTER_ID,
            SQ.SURVEY_QUESTION_ID
    </cfquery>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = wrk_get_today()>
    </cfif>
    <cfquery name="get_survey_option_max" datasource="#dsn#">
        SELECT MAX(OPTION_POINT) AS MAX_OPTION_POINT FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = #get_survey_info.SURVEY_CHAPTER_ID#
    </cfquery>
    <cfset max_point_survey = get_survey_option_max.MAX_OPTION_POINT>
    <cfoutput>
        <cfquery name="get_opt_question_id" datasource="#dsn#">
            SELECT SURVEY_QUESTION_ID,QUESTION_TYPE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#">
        </cfquery>
        <cfquery name="get_opt_question_id_" datasource="#dsn#">
            SELECT SURVEY_QUESTION_ID,QUESTION_TYPE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID IS NULL  AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#">
        </cfquery>
        <cfquery name="get_survey_chapter_questions_options" datasource="#dsn#">
            SELECT SURVEY_OPTION_ID,SURVEY_QUESTION_ID,OPTION_HEAD,OPTION_NOTE,SCORE_RATE1,SCORE_RATE2 FROM SURVEY_OPTION WHERE <cfif len(get_survey_info.survey_question_id) and len(get_opt_question_id.SURVEY_QUESTION_ID)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"><cfelse>SURVEY_QUESTION_ID IS NULL</cfif> AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#"> ORDER BY SURVEY_OPTION_ID
        </cfquery>
        <cfif get_survey_info.question_type eq 3><!--- Acik uclu soruda satir sayisinin artirilabilirligi icin kullaniliyor --->
            <cfif len(get_survey_chapter_questions_options.survey_option_id)>
                <cfset Record_ = get_survey_chapter_questions_options.recordcount / ListLen(ListDeleteDuplicates(ValueList(get_survey_chapter_questions_options.survey_option_id)))>
            <cfelse>
                <cfset Record_ = get_survey_chapter_questions_options.recordcount>
            </cfif>
            <input type="hidden" name="record_num_result_#survey_question_id#" id="record_num_result_#survey_question_id#" value=""><!--- #Record_# --->
        </cfif>
	</cfoutput>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
<!---	<cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
        <cfset attributes.survey_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.survey_id,accountKey:session.ep.userid)>
        <cfset attributes.result_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.result_id,accountKey:session.ep.userid)>
    </cfif>
--->    <cfquery name="get_survey_main" datasource="#dsn#">
        SELECT 
            TYPE,
            SURVEY_MAIN_HEAD,
            SURVEY_MAIN_DETAILS, 
            AVERAGE_SCORE, 
            TOTAL_SCORE,
            PROCESS_ID,
            IS_MANAGER_0,
            IS_MANAGER_1,
            IS_MANAGER_2,
            IS_MANAGER_3,
            IS_MANAGER_4,
            EMP_QUIZ_WEIGHT,
            MANAGER_QUIZ_WEIGHT_1,
            MANAGER_QUIZ_WEIGHT_2,
            MANAGER_QUIZ_WEIGHT_3,
            MANAGER_QUIZ_WEIGHT_4,
            IS_SELECTED_ATTENDER,
            IS_NOT_SHOW_SAVED
        FROM 
            SURVEY_MAIN 
        WHERE 
            SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
    </cfquery>
    <!--- Doldurulacak anketin, bilgilerini getirir --->
    <cfquery name="get_survey_info" datasource="#dsn#">
        SELECT
            SC.SURVEY_CHAPTER_ID,
            SC.SURVEY_CHAPTER_HEAD,
            SC.SURVEY_CHAPTER_DETAIL,
            SC.IS_CHAPTER_DETAIL2,
            SC.SURVEY_CHAPTER_DETAIL2,
            SC.SURVEY_CHAPTER_WEIGHT,
            SC.IS_SHOW_GD,
            SQ.SURVEY_QUESTION_ID,
            SQ.QUESTION_HEAD,
            SQ.QUESTION_DETAIL,
            SQ.QUESTION_TYPE,
            SQ.QUESTION_DESIGN,
            SQ.QUESTION_IMAGE_PATH,
            SQ.IS_REQUIRED,
            SQ.IS_SHOW_GD AS QUESTION_GD
        FROM
            SURVEY_CHAPTER SC,
            SURVEY_QUESTION SQ
        WHERE
            SC.SURVEY_CHAPTER_ID = SQ.SURVEY_CHAPTER_ID AND
            SC.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
        ORDER BY
            SC.SURVEY_CHAPTER_ID,
            SQ.SURVEY_QUESTION_ID
    </cfquery><!--- İlgili anketin, bolum ve sorularini getirir, optionları loop edebilmek için kullanılır --->
    <cfquery name="get_main_result_info" datasource="#dsn#">
        SELECT 
            PARTNER_ID,
            CONSUMER_ID,
            COMPANY_ID,
            EMP_ID,
            START_DATE,
            FINISH_DATE,
            COMMENT,
            PROCESS_ROW_ID,
            RESULT_NOTE,
            ACTION_TYPE,
            ACTION_ID,
            VALID,
            VALID1,
            VALID2,
            VALID3,
            VALID4,
            MANAGER1_EMP_ID,
            MANAGER1_POS,
            MANAGER2_EMP_ID,
            MANAGER2_POS,
            MANAGER3_EMP_ID,
            MANAGER3_POS,
            SCORE_RESULT_EMP,
            SCORE_RESULT_MANAGER1,
            SCORE_RESULT_MANAGER2,
            SCORE_RESULT_MANAGER3,
            SCORE_RESULT_MANAGER4,
            SCORE_RESULT,
            IS_CLOSED,
            CLASS_ATTENDER_EMP_ID,
            CLASS_ATTENDER_CONS_ID,
            CLASS_ATTENDER_PAR_ID,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM 
            SURVEY_MAIN_RESULT 
        WHERE 
            SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
    </cfquery> <!--- ilgili anketin result_id sini verir --->
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = wrk_get_today()>
    </cfif>
    
</cfif>
<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
document.getElementById('keyword').focus();
	function kontrol()
	{
		if(document.search.branch_name.value.length==0)document.search.branch_id.value="";
		if(document.search.department_name.value.length==0)document.search.department_id.value="";
		return true;
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	var is_add_record_ = 1;
	function kontrol()
	{	
		if(is_add_record_ == 1)
			{
				is_add_record_ = 0;
				if(document.getElementById('action_type').value == 9 && document.getElementById('is_selected_attender').value == 1 && (document.getElementById('user_name').value == '' || document.getElementById('user_id').value == ''))
				{
					alert("<cf_get_lang_main no='1983.Katılımcı'>");
					is_add_record_ = 1;
					return false;
				}
				if(document.getElementById('company_name')!= undefined && document.getElementById('company_name').value == '' && document.getElementById('employee').value == '')
				{
					alert("<cf_get_lang_main no='246.Üye'> / <cf_get_lang_main no='1701.Çalışan Girmelisiniz'> !");
					is_add_record_ = 1;
					return false;
				}
				if(document.getElementById('action_type').value == 8)
				{
					if((document.getElementById('start_date').value == '' || (document.getElementById('finish_date') != undefined && document.getElementById('finish_date').value == '')))
					{
						alert("<cf_get_lang_main no='1060.Dönem'>");
						is_add_record_ = 1;
						return false;
					}
				}
				//Tekli soru tipleri icin radiobutonun secili olup olmadıgını kontrol eder
				var get_question_info = wrk_query("SELECT SURVEY_QUESTION_ID, IS_REQUIRED, QUESTION_HEAD, QUESTION_TYPE,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_QUESTION WHERE SURVEY_MAIN_ID ="+ document.survey_main_result.survey_id.value+" ORDER BY SURVEY_QUESTION_ID","dsn");
				for (var xx=0; xx<get_question_info.recordcount; xx++)
				{	
					var get_opt_info = wrk_query("SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx]+" ORDER BY SURVEY_QUESTION_ID","dsn");
					if(get_opt_info.SURVEY_QUESTION_ID[xx] == '')
						var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
					else
						var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ get_question_info.SURVEY_QUESTION_ID[xx] + " AND SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
			
					if(get_question_info.IS_REQUIRED[xx] == 1)
					{
						if(get_question_info.QUESTION_TYPE[xx] == 1 || get_question_info.QUESTION_TYPE[xx] == 2)//Tekli yada coklu
						{
							gecti_ = 0;
							var question_id_ = get_question_info.SURVEY_QUESTION_ID[xx];
							var inputid = "user_answer_" + question_id_;
							var get_chapter = wrk_query("SELECT IS_SHOW_GD FROM SURVEY_CHAPTER WHERE SURVEY_CHAPTER_ID ="+get_question_info.SURVEY_CHAPTER_ID[xx],"DSN");
							if(get_question_info.IS_SHOW_GD[xx] == 1 || (get_chapter.recordcount >0 && get_chapter.IS_SHOW_GD[0] == 1)) //GD seçeneği geliyor ise
							{var sayac = get_opt_info.recordcount+1;}else var sayac = get_opt_info.recordcount;
							for (var yy=0; yy<sayac; yy++)
							{
								if(document.getElementsByName(inputid)[yy] != undefined && document.getElementsByName(inputid)[yy].checked == true)
								{gecti_ = 1;break;}
							}
							if(gecti_ == 0)
							{
								alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang_main no='1984.Lütfen Zorunlu Alanları Doldurunuz'> !");
								is_add_record_ = 1;
								return false;
								
							}
						}
						/*if(get_question_info.QUESTION_TYPE[xx] == 4)//Skor
						{
							var question_id = get_question_info.SURVEY_QUESTION_ID[xx];
							for (var zz=0; zz<get_option_info_.recordcount; zz++)
							{
								gecti_ = 0;
								var inputid = "user_answer_" + question_id+'_'+get_option_info_.SURVEY_OPTION_ID[zz];
								for (var yy=0; yy<get_option_info_.record_count; yy++)
								{
									if(document.getElementsByName(inputid)[yy].checked == true)
									{gecti_ = 1;break;}
								}
								if(gecti_ == 0)
								{
									alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang_main no='1984.Lütfen Zorunlu Alanları Doldurunuz'> !");
									return false;
								}
							}
							
						}*/
						if(get_question_info.QUESTION_TYPE[xx] == 3)//Acikuclu
						{
							var question_id = get_question_info.SURVEY_QUESTION_ID[xx];
							for (var zz=0; zz<get_option_info_.recordcount; zz++)
							{
								var inputid = "user_answer_" + question_id+'_'+get_option_info_.SURVEY_OPTION_ID[zz];
								if(document.getElementById(inputid).value == '')
								{
									alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang_main no='1984.Lütfen Zorunlu Alanları Doldurunuz'> !");
									is_add_record_ = 1;
									return false;
								}
							}	
						}
					}
				}
			}
			else
			{
				return false;
			}
		<cfif len(get_survey_main.process_id)>
			$(document).ready(function(e) {
				return process_cat_control();
			})
		</cfif>
		//document.getElementById('wrk_submit_button').disabled = true;	
		return true;
	}
	var s = 98;//Ascii kodu a harfine karsilik geliyor
	function add_new_option(x,row_count_options,survey_chapter_id)
	{	
		aaa = document.getElementById("record_num_result_"+row_count_options).value;
		var get_option_info = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID, SURVEY_QUESTION_ID, OPTION_HEAD, OPTION_POINT, OPTION_NOTE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ row_count_options,"dsn");
		var newRow;
		var newCell;
		newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
		newRow.setAttribute("name","add_new_option_row_'+row_count_options+'_'+aaa+'");
		newRow.setAttribute("id","add_new_option_row_'+row_count_options+'_'+aaa+'");	
		newRow.setAttribute("NAME","add_new_option_row_'+row_count_options+'_'+aaa+'");
		newRow.setAttribute("ID","add_new_option_row_'+row_count_options+'_'+aaa+'");
		for (var mm=0; mm<x; mm++)
		{
			
			newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
			newRow.setAttribute("name","add_new_option_row_" + row_count_options);
			newRow.setAttribute("id","add_new_option_row_" + row_count_options);	
			newRow.setAttribute("NAME","add_new_option_row_" + row_count_options);
			newRow.setAttribute("ID","add_new_option_row_" + row_count_options);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = String.fromCharCode(s)+' ) '+get_option_info.OPTION_HEAD[mm];
			var option_id = parseInt(get_option_info.SURVEY_OPTION_ID[x-1]) + parseInt(mm+1);
			alert(option_id);
			document.getElementById("record_num_result_"+row_count_options).value = option_id;
			/*var opt_note = get_option_info.OPTION_NOTE[mm];
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="user_answer_'+row_count_options+'_'+option_id+'" value="">';
			if (opt_note == 1)
			{
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="add_note_'+row_count_options+'_'+aaa+'" value="">';
			}*/
		}
		s = s + 1;
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	function kontrol()
	{
		if(document.getElementById('action_type').value == 9 && document.getElementById('is_selected_attender').value == 1 && (document.getElementById('user_name').value == '' || document.getElementById('user_id').value == ''))
		{
			alert("<cf_get_lang_main no='1983.Katılımcı'>");
			return false;
		}
		if(document.getElementById('company_name')!= undefined && document.getElementById('company_name').value == '' && document.getElementById('employee').value == '')
		{
			alert("<cf_get_lang_main no='246.Üye'>/<cf_get_lang_main no='1701.Çalışan Girmelisiniz'> !");
			return false;
		}
		if(document.getElementById('action_type').value == 8 & (document.getElementById('start_date').value == '' || (document.getElementById('finish_date') != undefined && document.getElementById('finish_date').value == '')))
		{
			alert("<cf_get_lang_main no='1060.Dönem'>");
			return false;
		}
		//Tekli soru tipleri icin radiobutonun secili olup olmadigini kontrol eder
		var get_question_info = wrk_query("SELECT SURVEY_QUESTION_ID, IS_REQUIRED, QUESTION_HEAD, QUESTION_TYPE,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_QUESTION WHERE SURVEY_MAIN_ID ="+ document.survey_main_result.survey_id.value+" ORDER BY SURVEY_QUESTION_ID","dsn");
		for (var xx=0; xx<get_question_info.recordcount; xx++)
		{	
			var get_opt_info = wrk_query("SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx]+" ORDER BY SURVEY_QUESTION_ID","dsn");
			if(get_opt_info.SURVEY_QUESTION_ID[xx] == '')
				{
					var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
				}
			else
				{
					var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ get_question_info.SURVEY_QUESTION_ID[xx] + " AND SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
				}
			if(get_question_info.IS_REQUIRED[xx] == 1)
			{
				if(get_question_info.QUESTION_TYPE[xx] == 1 || get_question_info.QUESTION_TYPE[xx] == 2)//Tekli yada coklu
				{
					gecti_ = 0;
					var question_id_ = get_question_info.SURVEY_QUESTION_ID[xx];
					var inputid = "user_answer_" + question_id_;
					var get_chapter = wrk_query("SELECT IS_SHOW_GD FROM SURVEY_CHAPTER WHERE SURVEY_CHAPTER_ID ="+get_question_info.SURVEY_CHAPTER_ID[xx],"DSN");
					if(get_question_info.IS_SHOW_GD[xx] == 1 || (get_chapter.recordcount >0 && get_chapter.IS_SHOW_GD[0] == 1)) //GD seçeneği geliyor ise
					{var sayac = get_opt_info.recordcount+1;}else var sayac = get_opt_info.recordcount;
					for (var yy=0; yy<sayac; yy++)
					{
						if(document.getElementsByName(inputid)[yy]!= undefined && document.getElementsByName(inputid)[yy].checked == true)
							{gecti_ = 1;break;}
					}
					if(gecti_ == 0)
					{
						alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang_main no='1984.Lütfen Zorunlu Alanları Doldurunuz'> !");
						return false;
					}
				}
				/*if(get_question_info.QUESTION_TYPE[xx] == 4)//Skor
				{
					var question_id = get_question_info.SURVEY_QUESTION_ID[xx];
					for (var zz=0; zz<get_option_info_.recordcount; zz++)
					{
						gecti_ = 0;
						var inputid = "user_answer_" + question_id+'_'+get_option_info_.SURVEY_OPTION_ID[zz];
						for (var yy=0; yy<get_option_info_.record_count; yy++)
						{
							if(document.getElementsByName(inputid)[yy].checked == true)
							{gecti_ = 1;break;}
						}
						if(gecti_ == 0)
						{
							alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang_main no='1984.Lütfen Zorunlu Alanları Doldurunuz'> !");
							return false;
						}
					}
					
				}*/
				if(get_question_info.QUESTION_TYPE[xx] == 3)//Acikuclu
				{
					var question_id = get_question_info.SURVEY_QUESTION_ID[xx];
					for (var zz=0; zz<get_option_info_.recordcount; zz++)
					{
						var inputid = "user_answer_" + question_id+'_'+get_option_info_.SURVEY_OPTION_ID[zz];
						if(document.getElementById(inputid).value == '')
						{
							alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang_main no='1984.Lütfen Zorunlu Alanları Doldurunuz'> !");
							return false;
						}
					}
				}
			}
		}
		if(document.getElementById('process_stage')!= undefined)
		return process_cat_control();
		return true;
	}
	var s = 98;//Ascii kodu a harfine karsilik geliyor
	function add_new_option(x,row_count_options,survey_chapter_id)
	{	
		aaa = document.getElementById("record_num_result_"+row_count_options).value;
		var get_option_info = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID, SURVEY_QUESTION_ID, OPTION_HEAD, OPTION_POINT, OPTION_NOTE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ row_count_options,"dsn");
		var newRow;
		var newCell;
		newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
		newRow.setAttribute("name","add_new_option_row_'+row_count_options+'_'+aaa+'");
		newRow.setAttribute("id","add_new_option_row_'+row_count_options+'_'+aaa+'");	
		newRow.setAttribute("NAME","add_new_option_row_'+row_count_options+'_'+aaa+'");
		newRow.setAttribute("ID","add_new_option_row_'+row_count_options+'_'+aaa+'");
		for (var mm=0; mm<x; mm++)
		{
			
			newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
			newRow.setAttribute("name","add_new_option_row_" + row_count_options);
			newRow.setAttribute("id","add_new_option_row_" + row_count_options);	
			newRow.setAttribute("NAME","add_new_option_row_" + row_count_options);
			newRow.setAttribute("ID","add_new_option_row_" + row_count_options);
			newCell = newRow.insertCell();
			newCell.innerHTML = String.fromCharCode(s)+' ) '+get_option_info.OPTION_HEAD[mm];
			var option_id = parseInt(get_option_info.SURVEY_OPTION_ID[x-1]) + parseInt(mm+1);
			alert(option_id);
			document.getElementById("record_num_result_"+row_count_options).value = option_id;
			/*var opt_note = get_option_info.OPTION_NOTE[mm];
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input type="text" name="user_answer_'+row_count_options+'_'+option_id+'" value="">';
			if (opt_note == 1)
			{
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" name="add_note_'+row_count_options+'_'+aaa+'" value="">';
			}*/
		}
		s = s + 1;
	}
	function unlock_send()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_to_lock&survey_id=#attributes.survey_id#&survey_main_result_id=#attributes.result_id#&lock=1</cfoutput>','menu_1','0',"Form Kilidi Kaldırılıyor");
	}
	function lock_send()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_to_lock&survey_id=#attributes.survey_id#&survey_main_result_id=#attributes.result_id#&lock=0</cfoutput>','menu_1','0',"Form Kilitleniyor");
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_perform';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_perform.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.list_perform';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/form_add_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/emptypopup_add_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_perform&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_perform';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/form_upd_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/emptypopup_upd_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_perform&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'survey_id=##attributes.survey_id##';
	
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_detailed_survey_main_result&result_id=#attributes.result_id#&survey_id=#attributes.survey_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_detailed_survey_main_result.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'objects/query/del_detailed_survey_main_result.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_perform';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();

		if (get_main_result_info.is_closed EQ 1)
		{
				if (session.ep.ehesap or session.ep.admin)
				{
					// ehesap kilit açabilir 
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Form Kilidini Kaldır';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "unlock_send();";
				}
		}
		else if (get_module_user(3))//IK yetkisi olan kişi kilitleyebilir
		
				{
					// kilitlenebilir 
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Formu Kilitle';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "lock_send();";
				}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.list_perform&event=add&survey_id=#attributes.survey_id#&ACTION_TYPE_ID=#get_main_result_info.action_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=#attributes.result_id#&print_type=510','page');";
		

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
