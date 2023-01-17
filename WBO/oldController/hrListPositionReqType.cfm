<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="get_pos_req_types" datasource="#dsn#">
			SELECT 
				POSITION_REQ_TYPE.*,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME
			FROM 
				POSITION_REQ_TYPE
				INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = POSITION_REQ_TYPE.RECORD_EMP
			<cfif len(attributes.keyword)>
				WHERE
					AND REQ_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
		</cfquery>
	<cfelse>
		<cfset get_pos_req_types.recordcount=0>
	</cfif>
	<cfif fuseaction contains "popup">
		<cfset is_popup=1>
	<cfelse>
		<cfset is_popup=0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_pos_req_types.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset url_str = ''>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	    <cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
	</cfif>
	<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	    <cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
	</cfif>
<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
	<cf_xml_page_edit fuseact="hr.add_pos_req_type">
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
		<cf_get_lang_set module_name="hr">
		<cfquery name="get_type" datasource="#dsn#">
			SELECT * FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
		</cfquery>
		<cfquery name="get_chapter" datasource="#dsn#">
			SELECT CHAPTER_ID FROM EMPLOYEE_QUIZ_CHAPTER WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
		</cfquery>
		<cfquery name="get_req_fill" datasource="#dsn#">
			SELECT 
				IS_FILL
			FROM
				RELATION_SEGMENT
			WHERE
				IS_FILL=1 AND
				RELATION_TABLE = 'POSITION_REQ_TYPE' AND
				RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_chapter'>
	<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
		<cfinclude template="../hr/query/get_quiz.cfm">
	<cfelseif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>
		<cfquery name="GET_QUIZ" datasource="#dsn#">
			SELECT * FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#"> 
		</cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and listfind('upd_chapter,add_question,upd_question',attributes.event)>
	<cfinclude template="../hr/query/get_quiz_chapter.cfm">
	<cfif isdefined("attributes.event") and attributes.event is 'upd_question'>
		<cfinclude template="../hr/query/get_question.cfm">
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and listfind('add_chapter,upd_chapter,add_question,upd_question',attributes.event)>
		function goster(number)
		{
			/*sayı seçilenin 1 eksiği geliyor*/
			if (number!=0)
			{
				for (i=0;i<=number;i++)
				{
					eleman = eval('answer'+i);
					eleman.style.display = '';
				}
				for (i=number+1;i<=19;i++)
				{
					eleman = eval('answer'+i);
					eleman.style.display = 'none';
				}
			}
			else
			{
				for (i=0;i<=19;i++)
				{
					eleman = eval('answer'+i);
					eleman.style.display = 'none';
				}
			}
		}
		<cfif isdefined("attributes.event") and listfind('add_chapter,upd_chapter',attributes.event)>
			function kontrol()
			{
				$('#chapter_weight').val($('#chapter_weight').val());
				<cfloop from="0" to="19" index="i">
					<cfoutput>
						document.getElementById('answer#i#_point').value=filterNum(document.getElementById('answer#i#_point').value);
					</cfoutput>
				</cfloop>
				return true;
			}
			
			function goster2(number)
			{
				if (number==1)
				{
					cevap_tasarim.style.display = '';
				}
				else
				{
					cevap_tasarim.style.display = 'none';
					document.getElementById('answer_number').selectedIndex=0;
					goster(0);
				}
			}
			<cfif isdefined("attributes.event") and attributes.event is 'upd_chapter'>
				$(document).ready(function() {
					<cfif evaluate(get_quiz_chapter.answer_number) neq 0>
						document.upd_CHAPTER.answer_number.selectedIndex = <cfoutput>#evaluate(get_quiz_chapter.answer_number-1)#</cfoutput>;
						goster(<cfoutput>#evaluate(get_quiz_chapter.answer_number-1)#</cfoutput>);
					</cfif>
				});
			</cfif>
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd_question'>
			$(document).ready(function() {
				<cfif evaluate(get_question.answer_number) neq 0>
					document.upd_question.answer_number.selectedIndex = <cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>;
					goster(<cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>);
				</cfif>
			});
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_position_req_type';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_pos_req_type.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.add_pos_req_type';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_pos_req_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_pos_req_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.upd_pos_req_type';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_pos_req_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_pos_req_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'req_type_id=##attributes.req_type_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.req_type_id##';
	
	WOStruct['#attributes.fuseaction#']['add_chapter'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_chapter']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_chapter']['fuseaction'] = 'hr.popup_form_add_chapter';
	WOStruct['#attributes.fuseaction#']['add_chapter']['filePath'] = 'hr/form/form_add_quiz_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['add_chapter']['queryPath'] = 'hr/query/add_quiz_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['add_chapter']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	WOStruct['#attributes.fuseaction#']['add_chapter']['Identity'] = '##lang_array_main.item[2198]##';
	
	WOStruct['#attributes.fuseaction#']['upd_chapter'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_chapter']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_chapter']['fuseaction'] = 'hr.popup_form_upd_chapter';
	WOStruct['#attributes.fuseaction#']['upd_chapter']['filePath'] = 'hr/form/form_upd_quiz_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['upd_chapter']['queryPath'] = 'hr/query/upd_quiz_chapter.cfm';
	WOStruct['#attributes.fuseaction#']['upd_chapter']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	WOStruct['#attributes.fuseaction#']['upd_chapter']['parameters'] = 'chapter_id=##attributes.chapter_id##&req_type_id=##attributes.req_type_id##';
	WOStruct['#attributes.fuseaction#']['upd_chapter']['Identity'] = '##get_quiz_chapter.chapter##';
	
	WOStruct['#attributes.fuseaction#']['add_question'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_question']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_question']['fuseaction'] = 'hr.popup_form_add_question';
	WOStruct['#attributes.fuseaction#']['add_question']['filePath'] = 'hr/form/form_add_question.cfm';
	WOStruct['#attributes.fuseaction#']['add_question']['queryPath'] = 'hr/query/add_question.cfm';
	WOStruct['#attributes.fuseaction#']['add_question']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	WOStruct['#attributes.fuseaction#']['add_question']['Identity'] = '##get_quiz_chapter.chapter##';
	
	WOStruct['#attributes.fuseaction#']['upd_question'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_question']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_question']['fuseaction'] = 'hr.popup_form_upd_question';
	WOStruct['#attributes.fuseaction#']['upd_question']['filePath'] = 'hr/form/form_upd_question.cfm';
	WOStruct['#attributes.fuseaction#']['upd_question']['queryPath'] = 'hr/query/upd_question.cfm';
	WOStruct['#attributes.fuseaction#']['upd_question']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	WOStruct['#attributes.fuseaction#']['upd_question']['parameters'] = 'chapter_id=##attributes.chapter_id##&req_type_id=##attributes.req_type_id##';
	WOStruct['#attributes.fuseaction#']['upd_question']['Identity'] = '##get_quiz_chapter.chapter##';
	
    if(isdefined("attributes.event") and(attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['copy'] = structNew();
		WOStruct['#attributes.fuseaction#']['copy']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'hr.emptypopup_pos_req_type_copy';
		WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'hr/query/pos_req_type_copy.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'hr/query/pos_req_type_copy.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'hr.list_position_req_type&event=upd';
		
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_pos_req_type&req_type_id=#attributes.req_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_pos_req_type.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_pos_req_type.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_position_req_type';
		
		WOStruct['#attributes.fuseaction#']['del_question'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_question']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del_question']['fuseaction'] = 'hr.del_question';
		WOStruct['#attributes.fuseaction#']['del_question']['filePath'] = 'hr/query/del_question.cfm';
		WOStruct['#attributes.fuseaction#']['del_question']['queryPath'] = 'hr/query/del_question.cfm';
		WOStruct['#attributes.fuseaction#']['del_question']['nextEvent'] = 'hr.list_position_req_type&event=upd';
		
		WOStruct['#attributes.fuseaction#']['del_chapter'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_chapter']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del_chapter']['fuseaction'] = 'hr.del_quiz_chapter';
		WOStruct['#attributes.fuseaction#']['del_chapter']['filePath'] = 'hr/query/del_quiz_chapter.cfm';
		WOStruct['#attributes.fuseaction#']['del_chapter']['queryPath'] = 'hr/query/del_quiz_chapter.cfm';
		WOStruct['#attributes.fuseaction#']['del_chapter']['nextEvent'] = 'hr.list_position_req_type&event=upd';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		if (get_req_fill.recordcount eq 0)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[763]#';
			if (get_chapter.recordcount)
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_position_req_type&event=upd_chapter&chapter_id=#get_chapter.chapter_id#&req_type_id=#attributes.req_type_id#','medium');";
			else
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=hr.list_position_req_type&event=add_chapter&req_type_id=#attributes.req_type_id#','medium');";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_position_req_type&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=hr.list_position_req_type&event=copy&req_type_id=#attributes.req_type_id#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (attributes.event is 'upd_chapter')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_chapter'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_chapter']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_chapter']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_chapter']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_position_req_type&event=add_chapter";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (attributes.event is 'upd_question')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_question'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_question']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_question']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_question']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_position_req_type&event=add_question&chapter_id=#attributes.chapter_id#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListPositionReqType';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'POSITION_REQ_TYPE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-REQ_TYPE','item-form_type','item-form_head']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>