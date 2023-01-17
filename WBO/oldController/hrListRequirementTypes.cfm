<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="hr">
	<cfparam name="attributes.keyword" default="">
	<cfquery name="get_pos_req_types" datasource="#dsn#">
		SELECT 
			REQ_TYPE,
			REQ_TYPE_ID 
		FROM 
			POSITION_REQ_TYPE
		<cfif len(attributes.keyword)>
			WHERE
				REQ_TYPE LIKE '%#attributes.keyword#%'
		</cfif>
	</cfquery>
	
	<cfif fuseaction contains "popup">
		<cfset is_popup=1>
	<cfelse>
		<cfset is_popup=0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_pos_req_types.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function kontrol()
		{
			<cfif get_pos_req_types.recordcount eq 1>
				if (!search1.type_id.checked)
				{
					alert("<cf_get_lang no='1780.yeterlilik tanımı yapmadınız kontrol edin'> !");
					return false;
				}
				if (!search1.coefficient.value.length)
				{
					alert("<cf_get_lang no='1781.oran tanımı yapmadınız kontrol edin'> !");
					return false;
				}
			<cfelseif get_pos_req_types.recordcount gt 1>
				flag = 0;
				for(i=0;i < search1.type_id.length; i++)
				    if (search1.type_id[i].checked)
						flag = 1;
		
				if (!flag)
				{
					alert("<cf_get_lang no='1782.En az 1 oran tanımı yapmalısınız'> !");
					return false;
				}
		
				for(i=0;i < search1.type_id.length; i++)
				    if ( search1.type_id[i].checked && (!search1.coefficient[i].value.length) )
					{
						alert((i+1) + ". <cf_get_lang no='1781.oran tanımı yapmadınız kontrol edin'> !");
						return false;
					}
			</cfif>
			return true;
		}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_requirement_types';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_requirement_types.cfm';
</cfscript>
