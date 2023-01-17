<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.stockbond_type_id" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined('attributes.form_exist')>
        <cfscript>
			getCredit_=createobject("component","credit.cfc.credit");
			getCredit_.dsn3=#dsn3#;
			getStockbond = getCredit_.getStockbond(
				keyword : attributes.keyword ,
				stockbond_type_id : attributes.stockbond_type_id ,
				startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
					maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
			);
		</cfscript>
    <cfparam name="attributes.totalrecords" default='#getStockbond.QUERY_COUNT#'>
    <cfelse>
        <cfset getStockbond.recordcount = 0>
        <cfparam name="attributes.totalrecords" default='0'>	
    </cfif>
    
    <script type="application/javascript">
		$( document ).ready(function() {
			$('#keyword').focus();
		});
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cfquery name="GET_STOCKBOND" datasource="#DSN3#">
        SELECT
            *
        FROM
            STOCKBONDS
        WHERE
            STOCKBOND_ID = #attributes.stockbond_id#
    </cfquery>
    <cfquery name="GET_STOCKBOND_TYPES" datasource="#DSN#">
        SELECT
            STOCKBOND_TYPE
        FROM 
            SETUP_STOCKBOND_TYPE
        WHERE
            STOCKBOND_TYPE_ID = #get_stockbond.stockbond_type#
    </cfquery>
    <cfif len(get_stockbond.row_exp_center_id)>
        <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
            SELECT 
                EXPENSE 
            FROM 
                EXPENSE_CENTER 
            WHERE 
                EXPENSE_ID=#get_stockbond.row_exp_center_id#
        </cfquery>
    </cfif>
    <cfif len(get_stockbond.row_exp_item_id)>
        <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
            SELECT 
                EXPENSE_ITEM_NAME 
            FROM 
                EXPENSE_ITEMS 
            WHERE
                IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = #get_stockbond.row_exp_item_id#
        </cfquery>
    </cfif>
    <cfquery name="GET_STOCK_TOTAL" datasource="#dsn3#">
        SELECT 
            SUM(STOCKBOND_IN) AS STOCK_IN,
            SUM(STOCKBOND_OUT) AS STOCK_OUT
        FROM
            STOCKBONDS_INOUT
        WHERE 
            STOCKBOND_ID = #attributes.stockbond_id#
    </cfquery>
    <cfif len(get_stock_total.stock_out)>
        <cfset stok=get_stock_total.stock_in-get_stock_total.stock_out>
    <cfelse>
        <cfset stok=get_stock_total.stock_in>
    </cfif>
    <cfquery name="GET_STOCKBOND_" datasource="#dsn3#">
        SELECT 
            * ,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_ID,
            C.FULLNAME,
			C.COMPANY_ID
        FROM 
            STOCKBONDS_SALEPURCHASE
            LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = STOCKBONDS_SALEPURCHASE.EMPLOYEE_ID
            LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = STOCKBONDS_SALEPURCHASE.COMPANY_ID
        WHERE ACTION_ID IN
            (
                SELECT 
                    SALES_PURCHASE_ID
                FROM
                    STOCKBONDS_SALEPURCHASE_ROW
                WHERE STOCKBOND_ID = #attributes.stockbond_id#
            )
    </cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_stockbonds';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'credit/display/list_stockbonds.cfm';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'credit.list_stockbonds';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'credit/display/detail_stockbond.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'credit/display/detail_stockbond.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'credit.list_stockbonds&event=det';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'stockbond_id=##attributes.stockbond_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.stockbond_id##';
	
</cfscript>

