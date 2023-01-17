<cf_get_lang_set module_name="stock">
<cf_xml_page_edit fuseact="stock.list_departments">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.control_number" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_pos_id" datasource="#dsn#">
	SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfif isDefined("attributes.is_filter")>
    <cfquery name="get_department" datasource="#dsn#">
    WITH CTE1 AS 
    (
		SELECT DISTINCT
			D.DEPARTMENT_STATUS,
			D.IS_STORE,
			D.DEPARTMENT_ID,
			D.DEPARTMENT_HEAD,
			D.DEPARTMENT_DETAIL,
			D.ADMIN1_POSITION_CODE,
			B.BRANCH_ID,
			B.BRANCH_NAME,
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.EMPLOYEE_ID<!---,
            SL.DEPARTMENT_LOCATION--->
		FROM 
			DEPARTMENT D
            LEFT JOIN EMPLOYEE_POSITIONS EP ON D.ADMIN1_POSITION_CODE = EP.POSITION_CODE
            LEFT JOIN STOCKS_LOCATION SL ON D.DEPARTMENT_ID = SL.DEPARTMENT_ID
			,BRANCH B
		WHERE
			B.BRANCH_ID = D.BRANCH_ID AND
			D.IS_STORE <> 2 
			<cfif len(attributes.company_id)>
				AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelse>
				AND B.COMPANY_ID IN
				(
					SELECT
						O.COMP_ID
					FROM 
						SETUP_PERIOD SP, 
						EMPLOYEE_POSITION_PERIODS EP,
						OUR_COMPANY O
					WHERE 
						SP.OUR_COMPANY_ID = O.COMP_ID AND
						EP.PERIOD_ID = SP.PERIOD_ID AND 
						EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
				)
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
					D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    D.DEPARTMENT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					D.DEPARTMENT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    (
                    	SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    	SL.DEPARTMENT_LOCATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )
				)
			</cfif>
			<cfif isdefined("attributes.branch_id") and isdefined("attributes.branch") and len(attributes.branch)>
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfelseif session.ep.isBranchAuthorization >
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			</cfif>
			<cfif attributes.is_active is 1>
				AND D.DEPARTMENT_STATUS = 1
			<cfelseif attributes.is_active is 0>
				AND D.DEPARTMENT_STATUS = 0
			<cfelse>
				AND D.DEPARTMENT_STATUS IS NOT NULL
			</cfif>	
	),
    CTE2 AS (
                SELECT
                     CTE1.*,
                     ROW_NUMBER() OVER (ORDER BY CTE1.DEPARTMENT_HEAD) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                     CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
    <cfparam name="attributes.totalrecords" default='#get_department.query_count#'>
    <cfif get_department.recordcount>
        <cfquery name="get_location" datasource="#dsn#"><!--- Lokasyonlar çekiliyor --->
            SELECT 
                D.DEPARTMENT_STATUS,
                SL.LOCATION_ID,
                SL.DEPARTMENT_ID,

                SL.DEPARTMENT_LOCATION,
                SL.COMMENT,
                SL.WIDTH AS LOCATION_WIDTH,
                SL.HEIGHT AS LOCATION_HEIGHT,
                SL.DEPTH AS LOCATION_DEPTH,
                SL.STATUS
            FROM 
                DEPARTMENT D,
                BRANCH B,
                STOCKS_LOCATION SL
            WHERE
                D.DEPARTMENT_ID IN (#valuelist(get_department.department_id)#) AND
                B.BRANCH_ID = D.BRANCH_ID AND
                D.IS_STORE <> 2 AND
                SL.DEPARTMENT_ID = D.DEPARTMENT_ID
               <!---  <cfif xml_show_product_place_info eq 1>
                    AND SL.LOCATION_ID NOT IN ( SELECT DISTINCT PP.LOCATION_ID FROM #dsn3_alias#.PRODUCT_PLACE PP WHERE PP.STORE_ID = D.DEPARTMENT_ID )
                </cfif> --->
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND(
                    D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    D.DEPARTMENT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					D.DEPARTMENT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    (
                        SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        SL.DEPARTMENT_LOCATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )
                    )
                </cfif>
                <cfif attributes.is_active is 1>
                    AND (D.DEPARTMENT_STATUS = 1 OR SL.STATUS = 1)
                <cfelseif attributes.is_active is 0>
                    AND (D.DEPARTMENT_STATUS = 0 OR SL.STATUS = 0)
                <cfelse>
                    AND D.DEPARTMENT_STATUS IS NOT NULL
                </cfif>
            ORDER BY 
                D.DEPARTMENT_HEAD
        </cfquery>
    </cfif>
    	<cfif get_department.recordcount and get_location.recordcount>
            <cfquery name="GET_PLACES" datasource="#DSN#">
                SELECT DISTINCT
                    SL.LOCATION_ID,
                    SL.DEPARTMENT_ID,
                    PP.PRODUCT_PLACE_ID,
                    PP.SHELF_TYPE,
                    PP.SHELF_CODE,
                    PP.WIDTH AS SHELF_WIDTH,
                    PP.HEIGHT AS SHELF_HEIGHT,
                    PP.DEPTH AS SHELF_DEPTH,
                    SHELF.SHELF_NAME,
                    PP.PLACE_STATUS
                FROM 
                    DEPARTMENT D,
                    BRANCH B,
                    STOCKS_LOCATION SL,
                    #dsn3_alias#.PRODUCT_PLACE PP
                        LEFT JOIN SHELF ON PP.SHELF_TYPE = SHELF.SHELF_ID
                WHERE
                    B.BRANCH_ID = D.BRANCH_ID AND
                    SL.LOCATION_ID IN (#valuelist(get_location.location_id)#) AND
                    D.IS_STORE <> 2 AND
                    SL.LOCATION_ID = PP.LOCATION_ID  AND
                    SL.DEPARTMENT_ID = PP.STORE_ID AND
                    SL.DEPARTMENT_ID = D.DEPARTMENT_ID
                    <cfif attributes.is_active is 1>
                        AND D.DEPARTMENT_STATUS = 1
                        AND SL.STATUS = 1
                    <cfelseif attributes.is_active is 0>
                        AND D.DEPARTMENT_STATUS = 0
                        AND SL.STATUS = 0			
                    <cfelse>
                        AND D.DEPARTMENT_STATUS IS NOT NULL
                    </cfif>
            </cfquery>
        </cfif>
<cfelse>
	<cfset get_department.recordcount = 0>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfquery name="periods" datasource="#dsn#">
	SELECT DISTINCT
		O.COMP_ID,
		O.COMPANY_NAME
	FROM 
		SETUP_PERIOD SP, 
		EMPLOYEE_POSITION_PERIODS EP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		EP.PERIOD_ID = SP.PERIOD_ID AND 
		EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
	ORDER BY
		O.COMP_ID,
		O.COMPANY_NAME
</cfquery>

<cfquery name="BRANCHES" datasource="#DSN#">
    SELECT 
        BRANCH_ID, 
        BRANCH_NAME 
    FROM 
        BRANCH 
    WHERE 
        BRANCH_STATUS = 1						
        <cfif session.ep.isBranchAuthorization >
            AND BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
    ORDER BY
        BRANCH_NAME
</cfquery>

<cfif isDefined("attributes.event") and attributes.event is 'upd'>
	<cfif isnumeric(attributes.department_id)>
        <cfinclude template="../stock/query/get_department_upd.cfm">
    <cfelse>
        <cfset get_department_upd.recordcount = 0>
    </cfif>
	<cfif not get_department_upd.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang no='363.Depo Kaydı Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
    </cfif>
     <cfquery name="BRANCHES" datasource="#DSN#">
        SELECT 
            BRANCH_ID, 
            BRANCH_NAME 
        FROM 
            BRANCH 
        <cfif session.ep.isBranchAuthorization >
            WHERE 
                BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
        </cfif>
        ORDER BY
            BRANCH_NAME
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'updloc'>
	<cfset DEPO = listgetat(attributes.id,1,"-")>
    <cfset LOC = listgetat(attributes.id,2,"-")>
    <cfinclude template="../stock/query/get_location_priority.cfm">
    <cfinclude template="../stock/query/get_det_stock_location.cfm">
    <cfquery name="GET_DET" datasource="#DSN2#">
        SELECT
            STOCKS_ROW_ID
        FROM
            STOCKS_ROW
        WHERE 
            STORE = #DEPO# AND
            STORE_LOCATION = #LOC#
    </cfquery>
    <cfif not get_det_stock_location.recordcount>
		<cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
	<cfelse>
    	<cfsavecontent variable="right">
			<cfoutput>
                <cfif not listfindnocase(denied_pages,'product.popup_list_stock_location_period')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.popup_list_stock_location_period&id=#attributes.id#','list');"><img src="/images/hand.gif" border="0" title="<cf_get_lang_main no='1399.muhasebe kodu'>"></a></cfif>	  
            </cfoutput>
        </cfsavecontent>
        <cfif get_det.recordcount eq 0>
        	<cfinclude template="../stock/query/get_department.cfm">
        <cfelse>
        	<cfquery name="GET_NAME" datasource="#DSN#">
                SELECT 
                    DEPARTMENT_HEAD
                FROM 
                    DEPARTMENT
                WHERE
                    DEPARTMENT_ID=#DEPO#
            </cfquery>
        </cfif>
        <cfquery name="get_department_status" datasource="#dsn#">
            SELECT 
                DEPARTMENT_STATUS
            FROM 
                DEPARTMENT
            WHERE 
                DEPARTMENT_ID = #get_det_stock_location.department_id#
        </cfquery>
        <cfif len(get_det_stock_location.company_id)>
        	<cfquery name="get_company" datasource="#dsn#">
                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_det_stock_location.company_id#
            </cfquery>
        <cfelseif len(get_det_stock_location.consumer_id)>
            <cfquery name="get_consumer" datasource="#dsn#">
                SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID = #get_det_stock_location.consumer_id#
            </cfquery>
        </cfif>
    </cfif>
<cfelseif isDefined("attributes.event") and attributes.event is 'add' and isdefined("attributes.department_id")>
	<cfinclude template="../stock/query/get_location_priority.cfm">
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});			
	
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function kontrol()
		{	
			if(document.getElementById('status').checked == false)
			{
				var location_status = wrk_safe_query('stk_get_location_status','dsn',0,<cfoutput>#attributes.department_id#</cfoutput>);	
				if(location_status.recordcount)
				{
					alert("Bu depoya ait aktif lokasyonlar bulunmaktadır.");
					return false;
				}
			}
			return true;
		}
	
	<cfelseif isDefined("attributes.event") and attributes.event is 'add' and isdefined("attributes.department_id")>
		function kontrol_priority()
		{	
			if(document.getElementById('priority').checked && document.getElementById('priority_exist').value == 1)
			{
				if(confirm ("<cf_get_lang no='343.Daha onceden Bir Lokasyon Secilmis İptal etmek istiyor musunuz'>?"))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			return true;
		}
	
	<cfelseif isdefined("attributes.event") and attributes.event is 'updloc'>
			function kontrol_priority()
			{
				if (document.getElementById('control_status').value == 0)
				{
					alert("Bu lokasyonun bağlı olduğu depo pasif durumdadır.");
					return false;
				}	
				if(document.add_loc.status.checked == false)
				{
					var listParam = document.getElementById('department_id').value+"*" + document.getElementById('location_id').value;
					var shelf_status = wrk_safe_query('stk_get_shelf_status','dsn3',0,listParam);
					if(shelf_status.recordcount)
					{
						alert("Bu lokasyona ait aktif raflar bulunmaktadır.");
						return false;
					}
				}	
				if(add_loc.priority.checked && add_loc.priority_exist.value==1)
					if(confirm ("<cf_get_lang no='343.Daha onceden Bir Lokasyon Secilmis!İptal etmek istiyor musunuz'>?"))return true;
					else return false;
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
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	if(attributes.event is 'add' and isDefined("attributes.department_id"))
	{
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_stock_location';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/display/add_stock_location.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_stock_location.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_departments&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['parameters'] = 'department_id=##attributes.department_id##&location_id=##attributes.location_id##';
		WOStruct['#attributes.fuseaction#']['add']['Identity'] = '##attributes.department_id##';
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_department';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/display/add_department.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_department.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_departments&event=upd';
	}
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.popup_department_upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/display/upd_department.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_department.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_departments&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'department_id=##attributes.department_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.department_id##';
	
	WOStruct['#attributes.fuseaction#']['updloc'] = structNew();
	WOStruct['#attributes.fuseaction#']['updloc']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updloc']['fuseaction'] = 'stock.popup_department_upd';
	WOStruct['#attributes.fuseaction#']['updloc']['filePath'] = 'stock/display/upd_stock_location.cfm';
	WOStruct['#attributes.fuseaction#']['updloc']['queryPath'] = 'stock/query/upd_stock_location.cfm';
	WOStruct['#attributes.fuseaction#']['updloc']['nextEvent'] = 'stock.list_departments';
	WOStruct['#attributes.fuseaction#']['updloc']['parameters'] = 'id=##attributes.id##&location_id=##attributes.location_id##';
	WOStruct['#attributes.fuseaction#']['updloc']['Identity'] = '##attributes.id##';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_departments';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_department.cfm';
 
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_departments&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'storePlanController';
	if(not isDefined("attributes.department_id"))
	{	
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'DEPARTMENT';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-department_head','item-branch_id','item-admin1']";
	}
	else if(isDefined("attributes.department_id"))
	{
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,updloc';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCKS_LOCATION';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['department_id-item','item-location_id','item-comment','item-location_type']";
	}
</cfscript>