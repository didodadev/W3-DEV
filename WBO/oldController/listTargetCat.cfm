<cf_get_lang_set module_name = 'hr'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
    <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_TARGETS_CAT" datasource="#dsn#">
            SELECT 
                TARGETCAT_ID,
                TARGETCAT_NAME,
                RECORD_EMP
            FROM
                TARGET_CAT
            WHERE
                1=1
                <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                    AND TARGETCAT_NAME LIKE '%#attributes.keyword#%'
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_targets_cat.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#GET_TARGETS_CAT.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset url_str = "">
    <cfparam name="attributes.keyword" default="">
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    
    <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_TARGET_CAT" datasource="#dsn#">
        SELECT 
            TARGETCAT_ID, 
            TARGETCAT_NAME, 
            DETAIL, 
            TARGETCAT_WEIGHT, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP,
            IS_ACTIVE
        FROM 
            TARGET_CAT 
        WHERE 
            TARGETCAT_ID=#attributes.targetcat_id#
    </cfquery>
    <cfquery name="GET_TARGET_COUNT" datasource="#dsn#">
        SELECT COUNT(TARGET_ID) AS TARGET_COUNT FROM TARGET WHERE TARGETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#">
    </cfquery>
</cfif>
<script language="javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add' or attributes.event is 'upd'>
		function kontrol()
		{
			if(document.add_target_cat.targetcat_detail.value.length>250)
			{
				alert("<cf_get_lang no ='968.Açıklama alanı en fazla 250 karekter olabilir'>!");
				return false;
			}
			if(document.add_target_cat.targetcat_name.value.length==0)
			{
				alert("<cf_get_lang_main no ='1143.Kategori ismi girmelisiniz'>!");
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
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_target_cat';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_target_cat.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_target_cat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_target_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_target_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_target_cat&event=upd';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_target_cat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_target_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_target_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_target_cat&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'targetcat_id=##attributes.targetcat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.targetcat_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_target_cat';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_target_cat.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_target_cat.cfm';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'targetcat_id=##attributes.targetcat_id##';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_target_cat';
	}
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.form_add_target_cat";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>