<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<!--- kullaniciya g�nderilen deneme s�resi degerlendirme ve isten �ikis degerlendirme formlari burada listelenir SG 20120921--->
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.type_id" default="">
    <cfif isdefined('attributes.form_submitted')>
        <cfquery name="get_main_result" datasource="#dsn#">
            SELECT
                SM.SURVEY_MAIN_HEAD+' - '+(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = SR.ACTION_ID) AS HEAD,
                SM.SURVEY_MAIN_ID,
                SM.TYPE,
                SR.SURVEY_MAIN_RESULT_ID,
                SR.ACTION_TYPE,
                SR.ACTION_ID,
                SR.RECORD_DATE
            FROM
                SURVEY_MAIN_RESULT SR,
                SURVEY_MAIN SM
            WHERE
                SR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
                (SR.EMP_ID = #session.ep.userid# 
                OR (SR.RECORD_EMP = #session.ep.userid# AND SM.TYPE <> 10)
                )AND
                SM.TYPE IN(6,10) AND <!--- deneme süresi ve isten çikis formlari--->
                SR.ACTION_TYPE IS NOT NULL AND
                SR.ACTION_ID IS NOT NULL AND
                (
                <!---deneme süresi tipindeki formlar deneme s�resi uyari tarihi geldikten sonra gosterilmeli --->
                (SM.TYPE = 6 AND GETDATE() >= (SELECT (DATEADD(d,(TEST_TIME-CAUTION_TIME),(SELECT TOP 1 START_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = SR.ACTION_ID ORDER BY IN_OUT_ID DESC))) AS STARTDATE FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = SR.ACTION_ID))
                OR SM.TYPE <> 6
                )
                <cfif len(attributes.type_id)>
                    AND SM.TYPE = #attributes.type_id#
                </cfif>
                <cfif len(attributes.keyword)>
                    AND 
                    (
                        SM.SURVEY_MAIN_HEAD LIKE '%#attributes.keyword#%'
                    )
                </cfif>
            ORDER BY
                SR.RECORD_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_main_result.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_main_result.recordcount#'>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
        <cfset attributes.survey_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.survey_id,accountKey:session.ep.userid)>
        <cfset attributes.result_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.result_id,accountKey:session.ep.userid)>
    </cfif>
    <cfsetting showdebugoutput="no">
    <cfquery name="get_survey_main" datasource="#dsn#">
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_employee_detail_survey_form';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_employee_detail_survey_form.cfm';

//	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_employee_detail_survey_form';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/form_upd_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/emptypopup_upd_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_employee_detail_survey_form&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'survey_id=##attributes.survey_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_survey_main.survey_main_head##';
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		if (get_main_result_info.is_closed EQ 1)
		{
			if (session.ep.ehesap or session.ep.admin)
				{
					
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Form Kilidini Kaldır';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "unlock_send();";
				}
		}
		else 	 
			if (get_module_user(3))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Formu Kilitle';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "lock_send();";
			}
		
		if (isdefined("attributes.is_popup"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#attributes.survey_id#&is_popup=#attributes.is_popup#&ACTION_TYPE_ID=#get_main_result_info.action_id#";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#attributes.survey_id#&ACTION_TYPE_ID=#get_main_result_info.action_id#";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=#attributes.result_id#&print_type=510','page');";


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}	
	
</cfscript>
