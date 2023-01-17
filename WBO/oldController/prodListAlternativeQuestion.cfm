<cf_get_lang_set module_name = "prod">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cfparam name="attributes.keyword" default="">
    <cfquery name="get_alternative_questions" datasource="#dsn#">
        SELECT 
            QUESTION_NO,
            QUESTION_ID,
            QUESTION_NAME,
            QUESTION_DETAIL
        FROM 
            SETUP_ALTERNATIVE_QUESTIONS
        <cfif len(attributes.keyword)>
        WHERE
            QUESTION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        </cfif>
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="get_questions" datasource="#dsn#">
        SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
    </cfquery>
</cfif>
<script type="text/javascript">
function control()
{
	var get_no = wrk_safe_query('prdp_get_no','dsn',0,document.getElementById('question_no').value); 
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		if(get_no.recordcount)
		{
			alert("Aynı No İle Kayıtlı Başka Bir Soru Mevcut !");
			return false;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		if(get_no.recordcount && get_no.QUESTION_ID !=document.getElementById('question_id').value)
		{
			alert("Aynı No İle Kayıtlı Başka Bir Soru Mevcut !");
			return false;
		}
	</cfif>
	
	if(document.getElementById('question_detail').value == '')
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>:<cf_get_lang_main no='217.Açıklama'> !");
		return false;
	}
	return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_alternative_questions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_alternative_questions.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_alternative_questions&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/form/upd_alternative_questions.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_alternative_questions.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_alternative_questions';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'question_id=##attributes.question_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.question_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_alternative_questions&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/add_alternative_questions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_alternative_questions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_alternative_questions';
	
	if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_del_alternative_questions&question_id=#attributes.question_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'production_plan/query/del_alternative_questions.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'production_plan/query/del_alternative_questions.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_alternative_questions';
	}
	
	if(attributes.event is 'upd')
	{         
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.list_alternative_questions&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodListAlternativeQuestion';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_ALTERNATIVE_QUESTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-question_no','item-question_name','item-question_detail']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
	
</cfscript>
