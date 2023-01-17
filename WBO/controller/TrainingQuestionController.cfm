<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_questions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_questions.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;

    WOStruct['#attributes.fuseaction#']['add'] = structNew();
    WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
    WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.popup_form_add_question';
    WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/add_question.cfm';
    WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_question.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'V16/training_management/query/add_question&question_id=';
   
	}
</cfscript>
