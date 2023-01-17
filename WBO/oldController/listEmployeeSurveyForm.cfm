<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<!--- anket tipinde oluşturulan formlar bu listeye gelir--->
        <cfscript>
            get_survey_ = createObject("component", "myhome.cfc.get_survey_main");
            get_survey_.dsn = dsn;
            get_survey_.dsn_alias = dsn_alias;
            get_survey_form = get_survey_.survey_records
            (
                survey_type : 14,//anket formu tipi
                keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                is_show_myhome : 1, //gündemde gösterilsin
                result_control :1, // çalışan sadece formu 1 kere dolduracak ise bu kontrol eklenmeli
                action_type_id : session.ep.userid // result_control 1 ise bu parametrede gonderilmeli kontrol icin
            );
        </cfscript>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfparam name="attributes.totalrecords" default='#get_survey_form.recordcount#'>
    <cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
        <cfset attributes.survey_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.survey_id,accountKey:session.ep.userid)>
        <cfset attributes.action_type_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_type_id,accountKey:session.ep.userid)>
    </cfif>
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
    
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
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
		return process_cat_control();
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
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_employee_survey_form';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_employee_survey_form.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.list_employee_survey_form';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/form_add_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/emptypopup_add_detailed_survey_main_result.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_employee_survey_form';
	
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=0&print_type=510','page');";


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
