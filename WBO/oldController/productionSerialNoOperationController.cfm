<cfparam name="attributes.keyword" default="">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
	<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
    <cfparam name="authority_station_id_list" default="0">
    <cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID 
        FROM 
            #dsn3_alias#.WORKSTATIONS W
        WHERE 
            W.ACTIVE = 1 AND
            W.EMP_ID LIKE '%,#session.ep.userid#,%'
        ORDER BY 
            STATION_NAME
    </cfquery>
    <cfset authority_station_id_list = ValueList(get_w.station_id,',')>
    <cfif isdefined("is_form_submitted")>
        <cfquery name="get_serial_no" datasource="#dsn3#">
            SELECT
                    PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
                    PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
                    SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT) QUANTITY,
                    PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID PROCESS_ID,
                    PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
                    PRODUCTION_ORDER_RESULTS.RESULT_NO PROCESS_NUMBER,
                    PRODUCTION_ORDER_RESULTS.FINISH_DATE PROCESS_DATE,
                    PRODUCTION_ORDER_RESULTS.START_DATE DELIVER_DATE,
                    PRODUCTION_ORDER_RESULTS.STATION_ID,
                    PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID LOCATION_IN,
                    PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID DEPARTMENT_IN,
                    PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID LOCATION_OUT,
                    PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID DEPARTMENT_OUT,
                    (SELECT TOP 1
                            SG.SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW AS SG
                        WHERE
                            STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
                            PROCESS_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
                            SG.PERIOD_ID = #session.ep.period_id#) SERIAL_NO
                FROM
                    PRODUCTION_ORDER_RESULTS,
                    PRODUCTION_ORDER_RESULTS_ROW,
                    STOCKS
                WHERE
                    PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID IS NOT NULL AND
                    PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID IS NOT NULL AND
                    PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND
                    PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID AND
                    PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                    STOCKS.IS_SERIAL_NO = 1
                    <cfif isdefined("keyword") and len(keyword)>
                    AND PRODUCTION_ORDER_RESULTS.RESULT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    </cfif>
                GROUP BY 
                    PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
                    PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
                    PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID,
                    PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
                    PRODUCTION_ORDER_RESULTS.RESULT_NO,
                    PRODUCTION_ORDER_RESULTS.FINISH_DATE,
                    PRODUCTION_ORDER_RESULTS.START_DATE,		
                    PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
                    PRODUCTION_ORDER_RESULTS.STATION_ID,
                    PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
                    PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
                    PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
                    PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID
                ORDER BY
                    PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID DESC
        </cfquery>
        <cfif len(authority_station_id_list)>
            <cfquery name="get_serial_no_" dbtype="query">
                SELECT 
                    *
                FROM
                    get_serial_no
                WHERE
                    P_ORDER_ID IS NOT NULL AND
                    <cfif len(authority_station_id_list)>
                        (STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#authority_station_id_list#" list="yes">) AND STATION_ID IS NOT NULL)
                    <cfelse>
                        1 = 0
                    </cfif>
                ORDER BY
                    P_ORDER_ID DESC
            </cfquery>
        <cfelse>
            <cfset get_serial_no_.recordcount = 0>
        </cfif>
    <cfelse>
        <cfset get_serial_no_.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_serial_no_.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_serial_no_.recordcount#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cfif get_serial_no_.recordcount>
        <cfset p_order_id_list = ''>
        <cfset stock_id_list = ''>
        <cfset dept_in_list = ''>
        <cfset dept_out_list = ''>
        <cfoutput query="get_serial_no_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(p_order_id) and not listfind(p_order_id_list,p_order_id)>
                <cfset p_order_id_list=listappend(p_order_id_list,p_order_id)>
            </cfif>
            <cfif len(stock_id) and not listfind(stock_id_list,stock_id)>
                <cfset stock_id_list=listappend(stock_id_list,stock_id)>
            </cfif>
            <cfif len(DEPARTMENT_IN) and not listfind(dept_in_list,DEPARTMENT_IN)>
                <cfset dept_in_list=listappend(dept_in_list,DEPARTMENT_IN)>
            </cfif>
            <cfif len(DEPARTMENT_OUT) and not listfind(dept_out_list,DEPARTMENT_OUT)>
                <cfset dept_out_list=listappend(dept_out_list,DEPARTMENT_OUT)>
            </cfif>
            <cfif len(p_order_id_list)>
                <cfset p_order_id_list=listsort(p_order_id_list,"numeric","ASC",",")>
                <cfquery name="get_project" datasource="#dsn#">
                    SELECT 
                        PROJECT_HEAD,
                        PROJECT_ID 
                    FROM 
                        PRO_PROJECTS 
                    WHERE 
                        PROJECT_ID IN (
                                        SELECT
                                            PROJECT_ID
                                        FROM
                                            #dsn3_alias#.PRODUCTION_ORDERS
                                        WHERE
                                            P_ORDER_ID IN (#p_order_id_list#) 
                                      )
                    ORDER BY PROJECT_ID
                </cfquery>
                <cfset p_order_id_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(stock_id_list)>
                <cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
                <cfquery name="get_product" datasource="#dsn3#">
                    SELECT 
                        PRODUCT_NAME,
                        STOCK_CODE,
                        STOCK_ID 
                    FROM 
                        STOCKS 
                    WHERE 
                        STOCK_ID IN (#stock_id_list#)
                    ORDER BY STOCK_ID
                </cfquery>
                <cfset stock_id_list = listsort(listdeleteduplicates(valuelist(get_product.STOCK_ID,',')),'numeric','ASC',',')>
            </cfif>
            <cfif listlen(dept_in_list)>
                <cfset dept_in_list = listsort(dept_in_list,"numeric","ASC",",")>
                <cfquery name="get_dept_in" datasource="#DSN#" >
                    SELECT
                        DEPARTMENT_ID,
                        DEPARTMENT_HEAD
                    FROM 
                        DEPARTMENT
                    WHERE
                        DEPARTMENT_ID IN (#dept_in_list#)
                    ORDER BY
                        DEPARTMENT_ID
                </cfquery> 
                <cfset dept_in_list = listsort(listdeleteduplicates(valuelist(get_dept_in.DEPARTMENT_ID,',')),'numeric','ASC',',')>
            </cfif>
            <cfif listlen(dept_out_list)>
                <cfset dept_out_list = listsort(dept_out_list,"numeric","ASC",",")>
                <cfquery name="get_dept_out" datasource="#DSN#" >
                    SELECT
                        DEPARTMENT_ID,
                        DEPARTMENT_HEAD
                    FROM 
                        DEPARTMENT
                    WHERE
                        DEPARTMENT_ID IN (#dept_out_list#)
                    ORDER BY
                        DEPARTMENT_ID
                </cfquery> 
                <cfset dept_out_list = listsort(listdeleteduplicates(valuelist(get_dept_out.DEPARTMENT_ID,',')),'numeric','ASC',',')>
            </cfif>
        </cfoutput>
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
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production/display/list_production_orders_serial_no.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
</cfscript>
