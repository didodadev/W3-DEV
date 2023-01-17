<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
    <cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
    <cfparam name="authority_station_id_list" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif len(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID 
        FROM 
            #dsn3_alias#.WORKSTATIONS W
        WHERE 
            W.ACTIVE = 1 AND
            W.EMP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
        ORDER BY 
            STATION_NAME
    </cfquery>
    <cfset authority_station_id_list = ValueList(get_w.station_id,',')>
    <cfif len(authority_station_id_list) and isdefined("attributes.is_form_submitted")>
        <cfscript>
            get_production_order_result_action = createObject("component", "production.cfc.get_production_order_result");
            get_production_order_result_action.dsn3 = dsn3;
			get_production_order_result_action.dsn = dsn;
            get_production_order_result_action.dsn_alias = dsn_alias;
            get_production_order_result_action.dsn1_alias = dsn1_alias;
			get_production_order_result_action.dsn3_alias = dsn3_alias;
            get_po_det = get_production_order_result_action.get_po_det_fnc(
                authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset get_po_det.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_po_det.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_po_det.recordcount#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cfif get_po_det.recordcount>
        <cfset prod_dep_id_list = ''>
        <cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(production_dep_id) and not listfind(prod_dep_id_list,production_dep_id)>
                <cfset prod_dep_id_list=listappend(prod_dep_id_list,production_dep_id)>
            </cfif>
        </cfoutput>
        <cfif listlen(prod_dep_id_list)>
            <cfset prod_dep_id_list=listsort(prod_dep_id_list,"numeric","ASC",",")>
            <cfquery name="get_dep" datasource="#DSN#">
                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#prod_dep_id_list#) ORDER BY DEPARTMENT_ID
            </cfquery>
            <cfset prod_dep_id_list = listsort(listdeleteduplicates(valuelist(get_dep.DEPARTMENT_ID,',')),'numeric','ASC',',')>
        </cfif>
    </cfif>
    <cfscript>wrkUrlStrings('url_str','is_form_submitted');</cfscript>
    <style>
        .box_yazi {font-size:16px;border-color:#666666;font:bold} 
        .box_yazi_td {font-size:14px;border-color:#666666;} 
    </style>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'production.#fuseaction_#';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production/display/list_production_order_results.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;		
	
</cfscript>
