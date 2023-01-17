<cf_get_lang_set module_name="objects">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.position_code" default="">
    <cfparam name="attributes.position_name" default="">
    <cfparam name="attributes.department_id" default="0">
    <cfparam name="attributes.start_date" default="" >
    <cfparam name="attributes.finish_date" default="" >
    <cfparam name="attributes.page" default=1>
    <cfif isdefined("is_branch")>
		<cfset branch_kontrol = "&is_branch=1">
    <cfelse>
		<cfset branch_kontrol = "">
    </cfif>
    <cfif isdefined("is_submitted")>
		<cfset arama_yapilmali = 0>
        <cfinclude template="../objects/query/get_stock_open_import.cfm">
	<cfelse>
		<cfset arama_yapilmali = 1>
        <cfset get_stock_open_import.recordcount=0>
    </cfif>
    <cfif isdate(attributes.start_date)>
		<cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
    </cfif>
    <cfif isdate(attributes.finish_date)>
		<cfset attributes.finish_date = dateformat(attributes.finish_date, "dd/mm/yyyy")>
    </cfif>
    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
        SELECT 
            D.DEPARTMENT_HEAD,
            SL.DEPARTMENT_ID,
            SL.LOCATION_ID,
            SL.STATUS,
            SL.COMMENT
        FROM 
            STOCKS_LOCATION SL,
            DEPARTMENT D,
            BRANCH B
        WHERE
            D.IS_STORE <> 2 AND
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
            D.DEPARTMENT_STATUS = 1 AND
            D.BRANCH_ID = B.BRANCH_ID AND
            B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            <cfif session.ep.our_company_info.is_location_follow eq 1>
                AND
                (
                    CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                    OR
                    D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
                )
            </cfif>
        ORDER BY
            D.DEPARTMENT_HEAD,
            COMMENT
    </cfquery>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_stock_open_import.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cf_papers paper_type="STOCK_FIS">
    <cfif isdefined("attributes.return")>
        <cfquery name="get_update_message" datasource="#DSN2#">
         IF object_id('tempdb..##TEMP_STOCK_COUNT') IS NOT NULL
          BEGIN
            SELECT DISTINCT MESSAGE FROM ##TEMP_STOCK_COUNT
           END
        </cfquery>
        <cfoutput query="get_update_message"><li>#MESSAGE#</li><br></cfoutput>
        <cfquery name="get_temp_table" datasource="#DSN2#">
            IF object_id('tempdb..##TEMP_STOCK_COUNT') IS NOT NULL
               BEGIN
                DROP TABLE ##TEMP_STOCK_COUNT 
               END
        </cfquery>
        <cfabort>
    </cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
        $('#department_id').focus();
		function delete_sayim(import_id)
		{
			if(confirm("<cf_get_lang no ='1498.Dosyayı Silmek İstediğinizden Emin Misiniz'>?"))
			{
				windowopen('','small','del_sayim');
				document.delete_form.target = 'del_sayim';
				document.delete_form.import_id.value = import_id;
				document.delete_form.submit();
			}
		}
    </script>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<script type="text/javascript">
		function control()
		{
			if($('#department_id').val()=='')
			{
				alert('<cf_get_lang_main no ="59.Eksik Veri"> - <cf_get_lang_main no ="1351.Depo">');
				return false;	
			}
			return true;
		}
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_stock_count';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'objects/display/list_stock_count.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_form_import_stock_count';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/import_stock_count.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/display/import_stock_count_display.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_stock_count&event=add';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockCount';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'FILE_IMPORTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-seperator_type','item-stock_identity_type','item-uploaded_file','item-store','item-process_date']";
	
</cfscript>

