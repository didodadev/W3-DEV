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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_cheques';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/cheque/display/list_cheques.cfm';
		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'cheque.popup_view_cheque_detail';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/cheque/display/dsp_cheque_detail.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/cheque/display/dsp_cheque_detail.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'cheque.list_cheques';
		WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
		
		if(attributes.event is 'det' or attributes.event is 'del')
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=cheque.del_cheque_or_voucher&cheque_id=##caller.GET_CHEQUE_DETAIL.cheque_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/cheque/query/del_cheque_or_voucher.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/cheque/query/del_cheque_or_voucher.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_cheques';
		}	
	}
	
	
</cfscript>
