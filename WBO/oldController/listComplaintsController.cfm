<cf_get_lang_set module_name='hr'>
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfparam name="attributes.status" default="1">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.is_submit")>
      <cfset get_complaint_list = createObject("component","hr.cfc.setupComplaints").getComplaints(is_default:attributes.status,keyword:attributes.keyword)>
    <cfelse>
        <cfset get_complaint_list.recordcount = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#get_complaint_list.recordcount#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfset cmp = createObject("component","hr.cfc.setupComplaints") />
    <cfset get_Complaint = cmp.getComplaints(complaint_id:attributes.complaint_id)>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});	
	<cfelseif isdefined('attributes.event') and listfind('add,upd',attributes.event,',')>
		function kontrol()
		{
			if(document.getElementById("complaint").value == "")
			{
				alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang no='131.Tanı'>!");
				return false;
			}
			return true;
		}
	</cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_complaints';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_complaints.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_complaints&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_complaints.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_complaints.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_complaints&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_complaints';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_complaints.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_complaints.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_complaints&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'complaint_id=##attributes.complaint_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.complaint_id##';

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listComplaintsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_COMPLAINTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-complaint']";
</cfscript>
