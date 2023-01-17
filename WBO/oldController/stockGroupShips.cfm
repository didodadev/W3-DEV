<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.department_id" default="">
    <cfquery name="STORES" datasource="#dsn#">
        SELECT 
            DEPARTMENT_STATUS, 
            IS_STORE, 
            BRANCH_ID, 
            DEPARTMENT_ID, 
            DEPARTMENT_HEAD, 
            HIERARCHY, 
            IS_ORGANIZATION, 
            OUR_COMPANY_ID
        FROM 
            DEPARTMENT D 
        WHERE  
            D.IS_STORE <> 2 AND D.DEPARTMENT_STATUS = 1 AND BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">) ORDER BY D.DEPARTMENT_HEAD
    </cfquery>
    <cfif isdefined("attributes.is_form_submitted")>
        <cfset form_varmi = 1>
    <cfelse>
        <cfset form_varmi = 0>
    </cfif>
    <cfquery name="GET_COMPANY_IDS" datasource="#dsn#">
        SELECT COMPANY_ID FROM COMPANY WHERE OUR_COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
    </cfquery>
    <cfset company_list = valuelist(GET_COMPANY_IDS.COMPANY_ID)>
    <cfquery name="SETUP_PERIODS" datasource="#dsn#">
        SELECT SP.*,OC.NICK_NAME FROM SETUP_PERIOD SP,OUR_COMPANY OC WHERE SP.PERIOD_YEAR = #SESSION.EP.PERIOD_YEAR# AND SP.OUR_COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#"> AND OC.COMP_ID = SP.OUR_COMPANY_ID ORDER BY SP.OUR_COMPANY_ID ASC
    </cfquery>
    <cfset period_list = valuelist(SETUP_PERIODS.OUR_COMPANY_ID)>
    <cfif listlen(company_list) and listlen(period_list)>
        <cfquery name="GET_RECORD_OF_ACTION" datasource="#DSN#">
            <cfset c = 0>
            <cfloop list="#period_list#" index="i">
                <cfset c = c + 1>
                <cfquery name="get_period_info" dbtype="query">
                    SELECT * FROM SETUP_PERIODS WHERE OUR_COMPANY_ID = #i#
                </cfquery>
                <cfset 'b#i#' = get_period_info.NICK_NAME>			
                <cfset a = dsn&'_'&get_period_info.PERIOD_YEAR&'_'&i>	
                <cfset d = get_period_info.OUR_COMPANY_ID>	
                <cfset new_dsn3 = dsn&'_'&i>
                <cfset old_period_id = get_period_info.PERIOD_ID>	
                SELECT			
                    '#old_period_id#' AS OLD_PERIOD_ID,
                    '#new_dsn3#' AS NEW_DSN3,
                    '#evaluate("b#i#")#' AS S_COMPANY_NAME,
                    '#d#' AS OUR_COMPANY_ID,
                    S.PURCHASE_SALES ,
                    S.SHIP_ID AS ISLEM_ID,
                    S.SHIP_NUMBER AS BELGE_NO,
                    S.SHIP_TYPE AS ISLEM_TIPI,
                    S.SHIP_DATE AS ISLEM_TARIHI,
                    S.COMPANY_ID,
                    C.FULLNAME,
                    S.DELIVER_STORE_ID AS DEPARTMENT_ID_2
                FROM 	
                    #a#.SHIP S,
                    COMPANY C		
                WHERE
                    S.SHIP_TYPE IN (70,71,72,78,79,81,83) AND
                    S.IS_EXPORTED IS NULL AND
                    S.COMPANY_ID IN ( <cfqueryparam list="yes" value="#company_list#"  cfsqltype="cf_sql_integer"> ) AND
                    C.COMPANY_ID = S.COMPANY_ID
                <cfif len(attributes.keyword)>
                    AND ( S.SHIP_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR C.FULLNAME LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> )
                </cfif>
                <cfif len(attributes.department_id)>
                    AND S.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                AND S.COMPANY_ID IN ( <cfqueryparam list="yes" value="#company_list#"  cfsqltype="cf_sql_integer"> )
                <cfif c neq listlen(period_list)>
                    UNION
                </cfif>
            </cfloop>
        </cfquery>
        <cfquery name="GET_FIS" dbtype="query">
            SELECT * FROM GET_RECORD_OF_ACTION
            <cfif isDefined('attributes.oby') and attributes.oby eq 2>
                ORDER BY ISLEM_TARIHI
            <cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
                ORDER BY BELGE_NO
            <cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
                ORDER BY BELGE_NO DESC
            <cfelse>
                ORDER BY ISLEM_TARIHI DESC
            </cfif>	
        </cfquery>
    <cfelse>
        <cfset GET_RECORD_OF_ACTION.recordcount = 0>
        <cfset GET_FIS.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default="#GET_FIS.recordcount#">
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
   	<cfquery name="get_pro_cat_1" datasource="#dsn3#">
        SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN  (75,77,76,73,74)
    </cfquery>
    <cfquery name="get_period" datasource="#dsn#">
        SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            OTHER_MONEY, 
            RECORD_DATE, 
            RECORD_IP,
            RECORD_EMP, 
            UPDATE_DATE,
            UPDATE_IP, 
            UPDATE_EMP, 
            PROCESS_DATE
        FROM 
            SETUP_PERIOD 
        WHERE 
            OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #SESSION.EP.PERIOD_YEAR#
    </cfquery>
    <cfquery  name="get_comp_money"  datasource="#dsn#">
        SELECT
            OC.COMP_ID,
            OC.NICK_NAME
        FROM
            SETUP_MONEY SM,
            OUR_COMPANY OC
        WHERE
            OC.COMP_ID=SM.COMPANY_ID AND
            SM.MONEY_STATUS=1 AND
            SM.RATE1=SM.RATE2 AND
            SM.MONEY = '#session.ep.money#' AND		
            OC.COMP_ID = #attributes.OUR_COMPANY_ID#
    </cfquery>
    <cfquery name="get_comp_id" datasource="#DSN#" maxrows="1">
            SELECT 
                C.COMPANY_ID,
                CP.PARTNER_ID,
                C.COMPANY_ADDRESS								
            FROM 
                COMPANY C,
                COMPANY_PARTNER CP 
            WHERE 
                C.OUR_COMPANY_ID=#attributes.OUR_COMPANY_ID#
                AND CP.COMPANY_PARTNER_STATUS = 1
                AND CP.COMPANY_ID = C.COMPANY_ID
        </cfquery>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
     	 document.getElementById('keyword').focus();
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_group_ships';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_group_ships.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_ship_group_comp';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_ship_group_comp_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_ship_group_comp_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_group_ships&event=add';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockGroupShips';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-period_id','item-txt_departman_']";
</cfscript>