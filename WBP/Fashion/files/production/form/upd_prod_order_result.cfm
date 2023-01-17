<cf_get_lang_set module_name="prod">
<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
<style type="text/css">
	.detail_basket_list tbody tr.operasyon td {background-color:#FFCCCC !important;}
	.detail_basket_list tbody tr.phantom td {background-color:#FFCC99 !important;}
</style>
<style>
input, select{
border:none;
display: inline-block;
}
</style>
<cfquery name="get_xml_alternative_question" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_related_alternative_question_product">
</cfquery>
<cfquery name="get_workstation_xml" datasource="#dsn#">
	SELECT PROPERTY_VALUE FROM FUSEACTION_PROPERTY WHERE FUSEACTION_NAME = 'prod.add_prod_order' AND PROPERTY_NAME = 'is_product_station_relation' AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif get_workstation_xml.recordcount and get_workstation_xml.property_value eq 1>
	<cfset is_product_station_relation = 1 >
</cfif>
<cfset is_add_alternative_product = get_xml_alternative_question.PROPERTY_VALUE>
<cf_xml_page_edit fuseact="prod.upd_prod_order_result">
<cfif is_show_product_name2 eq 1><cfset product_name2_display =""><cfelse><cfset product_name2_display='none'></cfif>
<cfif is_show_spec_id eq 1><cfset spec_display = 'text'><cfelse><cfset spec_display = 'hidden'></cfif>
<cfif is_show_spec_name eq 1><cfset spec_name_display = 'text'><cfelse><cfset spec_name_display = 'hidden'></cfif>
<cfif is_show_spec_id eq 0 and isdefined('is_show_spec_name') and is_show_spec_name eq 0><cfset spec_img_display="none"><cfelse><cfset spec_img_display=""></cfif>
<cfif is_change_amount_demontaj eq 1><cfset _readonly_ =''><cfelse><cfset _readonly_ = 'readonly'></cfif>
<cfset variable_ = '0'>
<cfset variable = '1'>
<cfset variable2 = '2'> 
<cfset variable3 = '3'>
<cfif not isnumeric(attributes.party_id) or not isnumeric(attributes.pr_order_id)>
	<cfset hata  = 10>
		<cfinclude template="../../../dsp_hata.cfm">
    <cfabort>
</cfif>
<cfquery name="get_sarf_" datasource="#dsn3#">
select
	 AMOUNT,
	 PO.P_ORDER_ID,
	 POS.STOCK_ID
FROM
PRODUCTION_ORDERS_STOCKS POS,
PRODUCTION_ORDERS PO
WHERE 
	POS.P_ORDER_ID=PO.P_ORDER_ID AND
	PO.PARTY_ID=#attributes.party_id# AND
	POS.TYPE=2

</cfquery>
<cfquery name="GET_DETAIL" datasource="#DSN3#">
	SELECT 
    	PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
        PRODUCTION_ORDERS.PROJECT_ID,
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
		PRODUCTION_ORDERS_MAIN.PARTY_NO,
		PRODUCTION_ORDER_RESULTS.*,
		PRODUCTION_ORDERS.*,
		P.PRODUCT_ID,
		REQ_ID
	FROM
		TEXTILE_PRODUCTION_ORDERS_MAIN AS PRODUCTION_ORDERS_MAIN,
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS,
		STOCKS S,
		PRODUCT P
	WHERE
		PRODUCTION_ORDERS.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID AND
		PRODUCTION_ORDERS_MAIN.PARTY_ID=PRODUCTION_ORDERS.PARTY_ID AND
		PRODUCTION_ORDERS.PARTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.party_id#">  AND 
		<cfif isdefined("attributes.party_id") and len(attributes.party_id)>
			PRODUCTION_ORDERS.PARTY_ID = PRODUCTION_ORDER_RESULTS.PARTY_ID AND
		<cfelse>
			PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
		</cfif>
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
		
</cfquery>


<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	attributes.req_id=GET_DETAIL.req_id;
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>


<cfset dep_id_list =''>
<cfset loc_id_list =''>
<cfif len(GET_DETAIL.exit_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.exit_dep_id,',')>
    <cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.exit_loc_id,',')>
</cfif>
<cfif len(GET_DETAIL.production_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.production_dep_id,',')>
    <cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.production_loc_id,',')>
</cfif>
<cfif len(GET_DETAIL.enter_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.enter_dep_id,',')>
    <cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.enter_loc_id,',')>
</cfif>
<cfif len(dep_id_list)>
    <cfquery name="GET_DEP" datasource="#DSN#">
        SELECT
            DEPARTMENT_HEAD,
            DEPARTMENT_ID,
			BRANCH_ID
        FROM
            DEPARTMENT
        WHERE
            DEPARTMENT_ID IN (#dep_id_list#)
    </cfquery>
	<cfif len(loc_id_list)> 
        <cfquery name="GET_LOC" datasource="#DSN#">
            SELECT
                COMMENT,
                LOCATION_ID,
                DEPARTMENT_ID
            FROM
                STOCKS_LOCATION
            WHERE
                LOCATION_ID IN (#loc_id_list#) AND
                DEPARTMENT_ID IN (#dep_id_list#)
        </cfquery>
</cfif>
<cfset production_branch_id = ''>
<cfset exit_dep_name = ''>
<cfset production_dep_name = ''>
<cfset enter_dep_name = ''>
<cfset exit_loc_comment = ''>
<cfset production_loc_comment = ''>
<cfset enter_loc_comment = ''>
<cfloop query="GET_DEP">
	<cfif GET_DETAIL.exit_dep_id eq DEPARTMENT_ID>
        <cfset exit_dep_name = DEPARTMENT_HEAD>
    </cfif>
    <cfif GET_DETAIL.production_dep_id eq DEPARTMENT_ID>
        <cfset production_dep_name = DEPARTMENT_HEAD>
		<cfset production_branch_id = BRANCH_ID>
    </cfif>
    <cfif GET_DETAIL.enter_dep_id eq DEPARTMENT_ID>
        <cfset enter_dep_name = DEPARTMENT_HEAD>
    </cfif>
</cfloop>
<cfloop query="GET_LOC">
	<cfif GET_DETAIL.exit_loc_id eq LOCATION_ID and GET_DETAIL.exit_dep_id eq DEPARTMENT_ID>
		<cfset exit_loc_comment = COMMENT>
	</cfif>
    <cfif GET_DETAIL.production_loc_id eq LOCATION_ID and GET_DETAIL.production_dep_id eq DEPARTMENT_ID>
		<cfset production_loc_comment =  COMMENT>
	</cfif>
    <cfif GET_DETAIL.enter_loc_id eq LOCATION_ID and GET_DETAIL.enter_dep_id eq DEPARTMENT_ID>
		<cfset enter_loc_comment = COMMENT>
	</cfif>
</cfloop>
</cfif>
<cfif GET_DETAIL.recordcount>
<!--- Bu blok,üretim emri birden fazla sipariş ile ilişkili ise,yapılacak spec değişikliklerinde 
ilgili siparişlerin de spect_var_id'leri güncellenerek ilişkinin kopmamış olması sağlanıyor--->
	<cfquery name="get_orders_all" datasource="#dsn3#">
    	SELECT POR_.ORDER_ID,POR_.ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR_,PRODUCTION_ORDERS PO WHERE POR_.PRODUCTION_ORDER_ID =PO.P_ORDER_ID AND PO.PARTY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.party_id#">
    </cfquery>
</cfif>
<cfif not GET_DETAIL.RECORDCOUNT>
	<cfset hata  = 10 >
	<cfinclude template="../../../dsp_hata.cfm">
</cfif>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
</cfquery>
<cfif get_money.recordcount eq 0>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="get_money_rate" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
</cfquery>
<cfif get_money_rate.recordcount eq 0>
	<cfquery name="get_money_rate" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
	</cfquery>
</cfif>
<cfquery name="GET_ROW_AMOUNT" datasource="#DSN3#">
	SELECT 
		PR_ORDER_ID
	FROM 
		PRODUCTION_ORDER_RESULTS
	WHERE 
		<cfif len(GET_DETAIL.PARTY_ID)>
			PARTY_ID='#GET_DETAIL.PARTY_ID#'
		<cfelse>
			P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
		</cfif>
</cfquery>
<cfif GET_ROW_AMOUNT.RECORDCOUNT>
	<cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
		SELECT 
			SUM(AMOUNT) AS SUM_AMOUNT
		FROM 
			PRODUCTION_ORDER_RESULTS_ROW
		WHERE 
			PR_ORDER_ID IN
			(
			SELECT 
				PR_ORDER_ID
			FROM 
				PRODUCTION_ORDER_RESULTS
			WHERE 
				
					<cfif len(GET_DETAIL.PARTY_ID)>
						PARTY_ID='#GET_DETAIL.PARTY_ID#'
					<cfelse>
						P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
					</cfif>
			)
			<cfif GET_DETAIL.IS_DEMONTAJ EQ 0> AND TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#variable#"><cfelse>AND TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"></cfif>
	</cfquery>
</cfif>
<!---<cfset new_dsn2 = '#dsn#_#year(GET_DETAIL.FINISH_DATE)#_#session.ep.company_id#'>
---><cfset new_dsn2 = dsn2>
<cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_ROW_OUTAGE" datasource="#DSN3#">
	SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_STOK_FIS" datasource="#new_dsn2#">
	SELECT SHIP_NUMBER,SHIP_ID,SHIP_TYPE FROM SHIP WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
</cfquery>
<cfif len(get_detail.order_id)>
	<cfquery name="GET_ORDER_NUMBER" datasource="#DSN3#">
		SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.order_id#">
	</cfquery>
</cfif>
<cfset var119 = '119'>
<cfset var110 = '110'>
<cfset var111 = '111'>
<cfset var112 = '112'>
<cfset var113 = '113'>
<cfset GET_CAT.recordcount = 0>
<cfset GET_FIS.recordcount = 0>
<cfset GET_FIS_SARF.recordcount = 0>
<cfset GET_FIS_AMBAR.recordcount = 0>
<cfset GET_FIS_FIRE.recordcount = 0>
<cfset GET_FIS2.recordcount = 0>
<cfquery name="GET_CAT" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE =<cfif GET_DETAIL.IS_DEMONTAJ eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#var119#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#var110#"></cfif><!--- uretimden giris fisi demontej veya uretimden giris fisi --->
</cfquery>
<cfif GET_CAT.recordcount>
	<cfquery name="GET_FIS" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 110
	</cfquery>
	<cfquery name="GET_FIS2" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 119
	</cfquery>
</cfif>
<cfquery name="GET_CAT_SARF" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var111#">
</cfquery>
<cfif GET_CAT_SARF.recordcount>
	<cfquery name="GET_FIS_SARF" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 111
	</cfquery>
</cfif>
<cfquery name="GET_CAT_AMBAR" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var113#">
</cfquery>
<cfif GET_CAT_AMBAR.recordcount>
	<cfquery name="GET_FIS_AMBAR" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 113
	</cfquery>
</cfif>
<cfquery name="GET_CAT_FIRE" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var112#">
</cfquery>
<cfif GET_CAT_FIRE.recordcount>
	<cfquery name="GET_FIS_FIRE" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 112
	</cfquery>
</cfif>
<cfset Product_id_List = ''>
<cfset Product_cat_List = ''>
<cfif get_row_enter.recordcount>
	<cfoutput query="GET_ROW_ENTER">
		<cfif isdefined('product_id') and len(product_id) and not listfind(Product_id_List,product_id)>
			<cfset Product_id_List=listappend(Product_id_List,product_id)>
		</cfif>
	</cfoutput>
	<cfif len(Product_id_List)>
		<cfset Product_id_List=listsort(Product_id_List,"numeric","ASC",",")>
		<cfquery name="get_product_cat" datasource="#dsn1#">
			SELECT PRODUCT_CATID,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID IN (#Product_id_List#) ORDER BY PRODUCT_ID
		</cfquery>
		<cfset Product_id_List = listsort(listdeleteduplicates(valuelist(get_product_cat.PRODUCT_ID,',')),'numeric','ASC',',')>
		<cfset Product_cat_List = listsort(listdeleteduplicates(valuelist(get_product_cat.PRODUCT_CATID,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cf_catalystHeader>
	<!-------ürün kunyesi -------->
<cfinclude template="../../sales/query/get_req.cfm">
<div class="col col-12">
	<cf_box id="sample_request" closable="1" unload_body = "1"  title="Numune Özet" >
		<div class="col col-10 col-xs-12 ">
				
				<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
				<cfinclude template="../../sales/display/dsp_sample_request.cfm">
			
		</div>
		<div class="col col-2 col-xs-2">
			<cfinclude template="../../objects/display/asset_image.cfm">
		</div>
	</cf_box>
</div>

<!-------ürün kunyesi-------->
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_prod_order_result_act">
<cfif GET_DETAIL.IS_DEMONTAJ eq 0><!--- Ürünün kaç tane alt ürünü olduğunu gösteriyor. --->
	<input type="hidden" name="is_demontaj" id="is_demontaj" value="0">
	<input type="hidden" name="sarf_recordcount" id="sarf_recordcount" value="<cfoutput>#GET_ROW_EXIT.RECORDCOUNT#</cfoutput>">
<cfelse>
	<input type="hidden" name="is_demontaj" id="is_demontaj" value="1">
	<input type="hidden" name="sarf_recordcount" id="sarf_recordcount" value="<cfoutput>#GET_ROW_ENTER.RECORDCOUNT#</cfoutput>">
</cfif>
<input type="hidden" name="is_changed_spec_main" id="is_changed_spec_main" value="<cfoutput>#is_changed_spec_main#</cfoutput>">
<input type="hidden" name="fire_recordcount" id="fire_recordcount" value="<cfoutput>#GET_ROW_OUTAGE.RECORDCOUNT#</cfoutput>">
<input type="hidden" name="x_is_add_operation_result" id="x_is_add_operation_result" value="<cfif isdefined("x_is_add_operation_result")><cfoutput>#x_is_add_operation_result#</cfoutput><cfelse>0</cfif>"><!--- Stok fişi oluşturma sayfasında kullanılıyor xl parametresi --->
<input type="hidden" name="x_lot_no_in_stocks_row" id="x_lot_no_in_stocks_row" value="<cfif isdefined("x_lot_no_in_stocks_row")><cfoutput>#x_lot_no_in_stocks_row#</cfoutput><cfelse>0</cfif>"><!--- Stok fişi oluşturma sayfasında kullanılıyor xl parametresi --->
<input type="hidden" name="party_id" id="party_id" value="<cfoutput>#get_detail.party_id#</cfoutput>">

<!---<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">--->
<input type="hidden" name="pr_order_id" id="pr_order_id" value="<cfoutput>#get_Detail.pr_order_id#</cfoutput>">
<input type="hidden" name="process_type_111" id="process_type_111" value="<cfoutput>#process_type_111#</cfoutput>">
<input type="hidden" name="process_type_112" id="process_type_112" value="<cfoutput>#process_type_112#</cfoutput>">
<input type="hidden" name="process_type_81" id="process_type_81" value="<cfoutput>#process_type_81#</cfoutput>">
<input type="hidden" name="process_type_110" id="process_type_110" value="<cfoutput>#process_type_110#</cfoutput>">
<input type="hidden" name="process_type_119" id="process_type_119" value="<cfoutput>#process_type_119#</cfoutput>">
<input type="hidden" name="del_pr_order_id" id="del_pr_order_id" value="0">
<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
<input type="hidden" id="today_date_" name="today_date_" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>">
<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
<cfoutput query="get_money">
	<input type="hidden" name="hidden_rd_money_#CURRENTROW#" id="hidden_rd_money_#CURRENTROW#" value="#money#">
	<input type="hidden" name="txt_rate1_#CURRENTROW#" id="txt_rate1_#CURRENTROW#" value="#tlformat(rate1)#">
	<input type="hidden" name="txt_rate2_#CURRENTROW#" id="txt_rate2_#CURRENTROW#" value="#tlformat(rate2,session.ep.our_company_info.rate_round_num)#">
</cfoutput>
<cf_basket_form id="order_result">
<cf_object_main_table>





	
<div class="row">

	<div class="col col-12 uniqueRow">
    	<div class="row formContent">
        	<div class="row" type="row">
            	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                	<div class="form-group" id="item-process">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='447.İşlem Kategorisi'> *</label>
                        <div class="col col-8 col-xs-12">
                        	<cf_workcube_process_cat slct_width="135" module_id="26" process_cat='#get_detail.process_id#'>
                        </div>
                    </div>
                    <div class="form-group" id="item-production_order_no">
                    	<label class="col col-4 col-xs-12">Parti Üretim Emir No *</label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="production_order_no" id="production_order_no" style="width:135px;" readonly maxlength="25" value="<cfoutput>#get_detail.production_order_no#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-order_no">
                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='799.Siparis No'> *</label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="order_no" id="order_no" value="<cfoutput>#get_detail.order_no#</cfoutput>" readonly maxlength="25" style="width:135px;">
							<input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_orders_all.ORDER_ROW_ID")><cfoutput>#valuelist(get_orders_all.ORDER_ROW_ID,',')#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_employee">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='452.İşlemi Yapan'></label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
	                            <cfif len(get_detail.position_id)>
                                    <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#get_detail.position_id#</cfoutput>">
                                    <input type="text" name="expense_employee" id="expense_employee" value="<cfoutput>#get_emp_info(get_detail.position_id,0,0)#</cfoutput>" style="width:135px;">
                                <cfelse>
                                    <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="">
                                    <input type="text" name="expense_employee" id="expense_employee" value="" style="width:135px;">
                                </cfif>
	                        	<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.expense_employee_id&field_name=form_basket.expense_employee&select_list=1','list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                	<div class="form-group" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Başlama'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<cfsavecontent variable="message"><cf_get_lang_main no='383.Başlama Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="start_date" id="start_date" value="#dateformat(get_detail.start_date,'dd/mm/yyyy')#" validate="eurodate" readonly required="Yes" message="#message#" style="width:65px;">
								
								<cfoutput>
									<cfif len(get_detail.start_date)>
										<cfset hour_detail = hour(get_detail.start_date)>
										<cfset minute_detail = minute(get_detail.start_date)>
									<cfelse>
										<cfset hour_detail = 0>
										<cfset minute_detail = 0>
									</cfif>
	                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date" control_date="#dateformat(get_detail.start_date,'dd/mm/yyyy')#"></span>
	                            	<span class="input-group-addon">
		                        	<select name="start_h" id="start_h">
										<cfloop from="0" to="23" index="I">
											<option value="#i#" <cfif hour_detail eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
										</cfloop>
									</select>
	                                </span>
		                            <span class="input-group-addon">
									<select name="start_m" id="start_m">
										<cfloop from="0" to="59" index="i">
											<option value="#i#" <cfif minute_detail eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
										</cfloop>
									</select>
								</cfoutput>
                            	</span>
                        	</div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='90.Bitiş'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(get_detail.finish_date,'dd/mm/yyyy')#" readonly required="Yes" message="#message#" validate="eurodate" style="width:65px;" onBlur="change_money_info('form_basket','finish_date');">
								<cfoutput>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" call_function="change_money_info" control_date="#dateformat(get_detail.finish_date,'dd/mm/yyyy')#"></span>
                            	<span class="input-group-addon">
	                        	<select name="finish_h" id="finish_h">
									<cfif len(get_detail.finish_date)>
										<cfset value_finish_h = hour(get_detail.finish_date)>
										<cfset value_finish_m = minute(get_detail.finish_date)>
									<cfelse>
										<cfset value_finish_h = 0>
										<cfset value_finish_m = 0>
									</cfif>
									<cfloop from="0" to="23" index="I">
										<option value="#i#" <cfif value_finish_h eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
									</cfloop>
								</select>
                                </span>
	                            <span class="input-group-addon">
								<select name="finish_m" id="finish_m">
									<cfloop from="0" to="60" index="i">
										<option value="#i#" <cfif value_finish_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
									</cfloop>
								</select>
							</cfoutput>
                            </span>
                            </div>
                        </div>
                    </div>
                	<div class="form-group" id="item-production_result_no">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='449.Sonuç No'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="production_result_no" id="production_result_no" value="<cfoutput>#get_detail.result_no#</cfoutput>" readonly maxlength="25" style="width:167px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-project_name">
                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="hidden" name="project_id" id="project_id" value="<cfif len(get_detail.PROJECT_ID)><cfoutput>#get_detail.PROJECT_ID#</cfoutput></cfif>">
							<input type="text" name="project_name" id="project_name" value="<cfif len(get_detail.PROJECT_ID)><cfoutput>#get_project_name(get_detail.PROJECT_ID)#</cfoutput></cfif>" readonly style="width:167px;">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                	<div class="form-group" id="item-process">
                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1447.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                        	<cf_workcube_process is_upd='0' select_value='#get_detail.prod_ord_result_stage#' process_cat_width='135' is_detail=','>
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='385.Lot No'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#get_detail.lot_no#</cfoutput>">
							<input type="text" name="lot_no" id="lot_no" maxlength="25" value="<cfoutput>#get_detail.lot_no#</cfoutput>" onKeyup="lotno_control(1,1);" <cfif isdefined("x_lot_no") and x_lot_no eq 0>readonly</cfif> style="width:135px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-station_name">
                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1422.İstasyon'> *</label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
	                            <cfif len(get_detail.station_id)>
									<cfquery name="GET_STATION" datasource="#dsn3#">
										SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.station_id#">
									</cfquery>
									<input type="hidden" name="station_id" id="station_id" value="<cfoutput>#get_detail.station_id#</cfoutput>">
									<input type="text" name="station_name" id="station_name" <cfif is_change_station eq 0>readonly</cfif> value="<cfoutput>#get_station.station_name#</cfoutput>" style="width:135px;" <cfif is_change_station eq 1>onFocus="AutoComplete_Create('station_name','STATION_NAME','STATION_NAME','get_station','','STATION_ID','station_id','','3','135','send_dep_loc()');"</cfif> autocomplete="off">
									<cfif is_change_station eq 1>
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_station()"></span>
                                    </cfif>
									<cfelse>
										<input type="hidden" name="station_id" id="station_id"  value="">
										<input type="text" name="station_name" id="station_name" style="width:135px;" onfocus="AutoComplete_Create('station_name','STATION_NAME','STATION_NAME','get_station','','STATION_ID','station_id','','3','135','send_dep_loc()');" autocomplete="off">
		                        		<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_station()"></span>
                                    </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ref_no">
                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1372.Referans'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_detail.REFERANS#</cfoutput>" style="width:135px;">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-location">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='448.Sarf Depo'></label>
                        <div class="col col-8 col-xs-12">
                        	<cfif len(get_detail.exit_dep_id) and len(get_detail.exit_loc_id)>
								<cf_wrkdepartmentlocation
									returninputvalue="exit_location_id,exit_department,exit_department_id,branch_id"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldname="exit_department"
									fieldid="exit_location_id"
									department_fldid="exit_department_id"
									department_id="#get_detail.exit_dep_id#"
									location_id="#get_detail.exit_loc_id#"
									location_name="#exit_dep_name#- #exit_loc_comment#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 1
									width="135">
							<cfelse>
								 <cf_wrkdepartmentlocation
									returninputvalue="exit_location_id,exit_department,exit_department_id,branch_id"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldname="exit_department"
									fieldid="exit_location_id"
									department_fldid="exit_department_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 1
									width="135">
					</cfif>
					<cfif GET_DETAIL.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
						<cfset location_type =3>
					<cfelse>
						<cfset location_type =1>			
					</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='450.Üretim Depo'></label>
                        <div class="col col-8 col-xs-12">
	                        	<cfif isdefined("get_detail.production_dep_id") and len(get_detail.production_dep_id)>
							<cfquery name="GET_PRODUCTION_DEP" datasource="#DSN#">
								SELECT
									DEPARTMENT_HEAD,
									BRANCH_ID
								FROM 
									DEPARTMENT
								WHERE
									DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_dep_id#">
							</cfquery>
							<cfquery name="GET_PRODUCTION_LOC" datasource="#DSN#">
								SELECT
									COMMENT
								FROM
									STOCKS_LOCATION
								WHERE
									LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_loc_id#"> AND
									DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_dep_id#">
							</cfquery>
							<cf_wrkdepartmentlocation
								returninputvalue="production_location_id,production_department,production_department_id,production_branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="production_department"
								fieldid="production_location_id"
								department_fldid="production_department_id"
								branch_fldid="production_branch_id"
								branch_id="#get_production_dep.branch_id#"
								department_id="#get_detail.production_dep_id#"
								location_id="#get_detail.production_loc_id#"
								location_name="#get_production_dep.department_head# - #get_production_loc.comment#"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 2
								width="135">
						<cfelse>
							<cf_wrkdepartmentlocation
								returninputvalue="production_location_id,production_department,production_department_id,production_branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="production_department"
								fieldid="production_location_id"
								department_fldid="production_department_id"
								branch_fldid="production_branch_id"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 2
								width="135">
						</cfif>
						<cfif GET_DETAIL.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
							<cfset location_type =1>
						<cfelse>
							<cfset location_type =3>			
						</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-enter_loc">
                    	<label class="col col-4 col-xs-12"><cf_get_lang no='451.Sevkiyat Depo'></label>
                        <div class="col col-8 col-xs-12">
                        	<cfif len(get_detail.enter_dep_id) and len(get_detail.enter_loc_id)>
						<cf_wrkdepartmentlocation
							returninputvalue="enter_location_id,enter_department,enter_department_id,branch_id"
							returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
							fieldname="enter_department"
							fieldid="enter_location_id"
							department_fldid="enter_department_id"
							department_id="#get_detail.enter_dep_id#"
							location_id="#get_detail.enter_loc_id#"
							location_name="#enter_dep_name# - #enter_loc_comment#"
							user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
							line_info = 3
                            user_location = 0
							width="135">
					<cfelse>
						<cf_wrkdepartmentlocation
							returninputvalue="enter_location_id,enter_department,enter_department_id,branch_id"
							returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
							fieldname="enter_department"
							fieldid="enter_location_id"
							department_fldid="enter_department_id"
							user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
							line_info = 3
                            user_location = 0
							width="135">
					</cfif>
                        </div>
                    </div>
                	<div class="form-group" id="item-reference_no">
                    	<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                        	<textarea name="reference_no" id="reference_no" maxlength="500" style="width:167px;height:73px;" onkeydown="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onkeyup="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_detail.reference_no#</cfoutput></textarea>
							<input type="text" name="detailLen" id="detailLen" size="1"  style="width:25px" value="500" readonly class="no-bg text-right" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-8 col-xs-12">
                	<div class="col col-3 col-xs-12"><cf_record_info query_name='get_detail'></div>
                    <div class="col col-9 col-xs-12 record_info">
                    <cfif get_fis.recordcount or get_fis_sarf.recordcount or get_fis_fire.recordcount>
				<cfif get_fis.recordcount>
                <label><cf_get_lang no='465.Üretimden Çıkış Fişi'>:
					<cfoutput>
						<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_fis.FIS_ID#" class="tableyazi" target="_blank">#get_fis.fis_number#</a>
					</cfoutput>
                </label>
				</cfif>
				<cfif get_fis2.recordcount>
                <label>
                Üretimden Giriş Fişi:
				<cfoutput>
                    <a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_fis2.FIS_ID#" class="tableyazi" target="_blank">#get_fis2.fis_number#</a>
                </cfoutput>
                </label>
				</cfif>
				<cfif get_fis_sarf.recordcount>
					<label>
                    <cf_get_lang_main no='1831.Sarf Fişi'>:
					<cfoutput>
						<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_fis_sarf.FIS_ID#" class="tableyazi" target="_blank">#get_fis_sarf.fis_number#</a>
					</cfoutput>
                    </label>
				</cfif>
				<cfif get_fis_ambar.recordcount or GET_STOK_FIS.recordcount>
					<cfquery name="get_ship_kontrol" datasource="#dsn2#">
						SELECT ISNULL(IS_DELIVERED,0) IS_DELIVERED FROM SHIP WHERE SHIP_ID = #GET_STOK_FIS.SHIP_ID#
					</cfquery>
                    <label>
					<cf_get_lang no='467.Dep Arası İrsaliye'>
					<cf_get_lang no='471.Ambar Fisi (Depolar Arasi)'> :
					<cfoutput>
					<a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#GET_STOK_FIS.SHIP_ID#" class="tableyazi" target="_blank">#get_fis_ambar.fis_number# #GET_STOK_FIS.ship_number# </a>
					</cfoutput>
                    </label>
				</cfif>
				<cfif GET_FIS_FIRE.RECORDCOUNT>
                <label>
					<cf_get_lang_main no='1832.Fire Fişi'>:
					<cfoutput>
						<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#GET_FIS_FIRE.FIS_ID#" class="tableyazi" target="_blank">#GET_FIS_FIRE.fis_number#</a>
					</cfoutput>
                    </label>
				</cfif>
		</cfif>
                    </div>
                </div>
                <div class="col col-4 col-xs-12 pull-right">
					<cfif not (get_fis.recordcount or get_fis2.recordcount) and len(get_detail.exit_dep_id) and len(get_detail.production_dep_id)><!--- Fis olusmamıs,sarf ve üretim depo dolu ise --->
						<cfsavecontent variable="message"><cf_get_lang no ='568.Stok Fişi Oluştur'></cfsavecontent>
						<cfsavecontent variable="message2"><cf_get_lang no ='569.Stok Fişi Oluşturmak İstediğinizden Emin misiniz '></cfsavecontent>
						<cfoutput>
							<span class="pull-right"><cf_workcube_buttons is_upd='0' is_cancel="0" is_delete='0' insert_info="#message#" add_function='kontrol_et()' insert_alert="#message2#"></span> 
							<script language="javascript">
								function _sesion_control_(){
									var user_control = wrk_safe_query("prdp_user_control","dsn");
									if(user_control.recordcount == undefined){
										alert('<cf_get_lang no="669.Kullanıcı Girişi Yapınız">!');
										return false;
									}
									else
										return true;
								}
							</script>
						</cfoutput>
					</cfif>
		            
					<cfsavecontent variable="message"><cf_get_lang_main no ='51.Sil'></cfsavecontent>
					<cfsavecontent variable="message2"><cf_get_lang_main no ='121.Silmek İstediğinizden Emin misiniz'></cfsavecontent>
					<span class="pull-right"><cf_workcube_buttons is_upd='1' is_delete='1' add_function='kontrol()' del_function="kontrol2()"></span>
					<cfif get_fis.recordcount or get_fis_sarf.recordcount><label class="pull-right"><input type="checkbox" name="is_delstock" id="is_delstock" value="1"><cf_get_lang no='464.Stok Fişleri Silinsin'></label></cfif>
						<label><input type="checkbox" name="approved" id="approved" value="1"> Onaylı Reçete Oluştur</label>
						<button type="button" onclick="windowopen('<cfoutput>#request.self#?fuseaction=textile.wahing_recepie&event=add&pr_order_ids=#get_detail.pr_order_id#</cfoutput>&approved=' + ($('#approved').prop('checked')?1:0), 'wide')" class="btn green-haze">Recete Oluştur</buttoN>
                </div>
            </div>
        </div>
    </div>
</div>
</cf_object_main_table>            
    </cf_basket_form>
    <div class="row formContent">
    	<div class="col col-12">
        	<cf_basket id="order_result_bask">
		<cf_seperator header="#getLang('main',1854)#" id="table1">
		    <table id="table1" name="id1" class="basket_list" style="margin-bottom:50px; display:none; width:100%;">
				<cfif x_pro_add_barkod_and_seri_no eq 1>
					<iframe name="add_prod1" id="add_prod1" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>" width="100%" height="50"></iframe>
				</cfif>
				<thead>
				<tr>
					<th style="min-width:22px;"><input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_row_enter.recordcount#</cfoutput>"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#&party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>&type=1&record_num=' + form_basket.record_num.value,'list')"><img id="add_row_image" src="/images/plus_list.gif" align="absbottom" border="0"></a></th>
					<th style="min-width:125px;"><cf_get_lang_main no='106.Stok Kodu'></th>
					<cfif x_is_barkod_col eq 1><th style="min-width:95px;"><cf_get_lang_main no='221.Barkod'></th></cfif>
					<th style="min-width:256px;"><cf_get_lang_main no='40.Stok'></th>
					<th style="min-width:265px; display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
					<th style="min-width:75px;"><cf_get_lang_main no='223.Miktar'></th>
					<cfif x_is_fire_product eq 1>
						<th style="min-width:65px;"><cf_get_lang_main no='1674.Fire'></th>
					</cfif>
					<th style="min-width:65px;"><cf_get_lang_main no='224.Birim'></th>
					<!---<cfif x_is_show_abh eq 1>
						<th style="min-width:65px;">a*b*h</th>
					</cfif>--->
					<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
						<th style="min-width:130px; text-align:right;"><cf_get_lang no='454.Birim Maliyet'></th>
                        <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                        	<th style="min-width:22px; text-align:right;"><cf_get_lang no='499.Toplam Maliyet'></th>
                        </cfif>
						<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
							<th id="labor_cost" style="min-width:95x; text-align:right;">İşçilik Maliyeti</th>
						</cfif>													
						<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
							<th id="refl_cost" style="min-width:95px; text-align:right;"><cf_get_lang no='670.Yansıyan Maliyet'></th>
						</cfif>
						<th style="min-width:55px;"><cf_get_lang_main no='77.Para Br'></th>
						<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
							<th style="min-width:130px; text-align:right;"><cf_get_lang no='454.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                            <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                <th style="min-width:130px; text-align:right;"><cf_get_lang no='499.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                            </cfif>
						</cfif>
						<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
							<th id="labor_cost" style="min-width:22px; text-align:right;">İşçilik Maliyeti (<cfoutput>#session.ep.money2#</cfoutput>)</th>
						</cfif>													
						<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
							<th id="refl_cost" style="min-width:95px; text-align:right;"><cf_get_lang no='670.Yansıyan Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
						</cfif>
						<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
							<th style="min-width:55px;"><cf_get_lang_main no='77.Para Br'></th>
                        </cfif>
					</cfif>
					<cfif is_show_two_units eq 1>
						<th style="min-width:75px;">2.<cf_get_lang_main no='223.Miktar'></th>
						<th style="min-width:40px;">2.<cf_get_lang_main no='224.Birim'></th>
					</cfif>
					<cfif is_show_product_name2 eq 1>
						<th style="min-width:75px;">2.<cf_get_lang_main no='217.Açıklama'></th>
					</cfif>
					<th width="20">&nbsp;</th>
					<th width="20">&nbsp;</th>
                    <th width="20">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
			<cfset mamul_recordcount =get_row_enter.recordcount>
						<input type="hidden" name="mamul_recordcount" id="mamul_recordcount" value="<cfoutput>#mamul_recordcount#</cfoutput>"> 
					<cfif session.ep.userid eq 2>
						<!---<cfdump var="#get_row_enter#"><cfabort>--->
					</cfif>
				<cfoutput query="get_row_enter">
					<cfquery name="GET_PRODUCT" datasource="#dsn1#">
						SELECT 
							PRODUCT.PRODUCT_NAME,
							PRODUCT.BARCOD,
							STOCKS.PRODUCT_UNIT_ID,
							PRODUCT_UNIT.ADD_UNIT,
							PRODUCT_UNIT.MAIN_UNIT,
							PRODUCT_UNIT.DIMENTION,
							STOCKS.PROPERTY,
							STOCKS.STOCK_CODE
						FROM 
							PRODUCT,
							STOCKS,
							PRODUCT_UNIT
						WHERE 
							STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
							PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
					</cfquery>
					<cfif len(p_order_id)>
							<cfquery name="get_order_amount" datasource="#dsn3#">
								select QUANTITY from PRODUCTION_ORDERS WHERE P_ORDER_ID=#p_order_id#
							</cfquery>
						<cfelse>
							<cfset get_order_amount.quantity=0>
						</cfif>
					<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('x_quality_control') and x_quality_control eq 1>
						<cfquery name="get_prod_quality_info" datasource="#dsn3#">
							 SELECT IS_QUALITY FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
						</cfquery>
						<cfif get_prod_quality_info.is_quality eq 1>
							<cfquery name="get_quality" datasource="#dsn3#">
								SELECT TOP 1
									QS.SUCCESS,
									QS.IS_SUCCESS_TYPE,
									ORQ.CONTROL_AMOUNT,
									ORQ.IS_ALL_AMOUNT
								FROM 
									ORDER_RESULT_QUALITY ORQ,
									QUALITY_SUCCESS QS
								WHERE 
									ORQ.PROCESS_ID = #attributes.p_order_id# AND
									ORQ.SHIP_WRK_ROW_ID = '#WRK_ROW_ID#' AND
									ORQ.PROCESS_CAT = 171 AND
									ORQ.STAGE IN (SELECT PTR.PROCESS_ROW_ID FROM #dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = ORQ.STAGE AND PTR.IS_CONFIRM = 1) AND <!--- Asamasinin Onay Secili Olmasi Lazim --->
									ORQ.SUCCESS_ID = QS.SUCCESS_ID
								ORDER BY
									ISNULL(ORQ.UPDATE_DATE,ORQ.RECORD_DATE) DESC
							</cfquery>
							<cfif get_quality.recordcount>
								<!--- 1 Kabul, 0 Red, 2 Yeniden Muayene --->
								<input type="hidden" name="is_success_type_#pr_order_id#" id="is_success_type_#pr_order_id#" value="#get_quality.IS_SUCCESS_TYPE#" />
								<input type="hidden" name="is_all_amount_#pr_order_id#" id="is_all_amount_#pr_order_id#" value="#get_quality.IS_ALL_AMOUNT#" />
							<cfelse>
								<input type="hidden" name="is_success_type_#pr_order_id#" id="is_success_type_#pr_order_id#" value="" />
								<input type="hidden" name="is_all_amount_#pr_order_id#" id="is_all_amount_#pr_order_id#" value="" />
							</cfif>
						</cfif>
					</cfif>
					<!--- Ana Ürün --->
					<tr id="frm_row#currentrow#" <cfif TREE_TYPE is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif TREE_TYPE is 'O'>class="operasyon" title="Operasyondan Gelen Ürünler"</cfif>>
						<td>
							<input type="hidden" name="sub_p_order_id#currentrow#" id="sub_p_order_id#currentrow#" value="#p_order_id#">
							<input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#get_row_enter.wrk_row_id#">
							<input type="hidden" name="wrk_row_relation_id_#currentrow#" id="wrk_row_relation_id_#currentrow#" value="#get_row_enter.wrk_row_relation_id#">
                            <input type="hidden" name="is_free_amount_#currentrow#" id="is_free_amount_#currentrow#" value="#get_row_enter.is_free_amount#">
							<input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#TREE_TYPE#">
							<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
							<input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#COST_ID#">
							<input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#KDV_PRICE#">
							<input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#PURCHASE_NET_SYSTEM#">
							<input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
							<input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#PURCHASE_EXTRA_COST#">
							<input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
							<a style="cursor:pointer" onclick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0" align="absbottom" title="<cf_get_lang_main no='51.Sil'>"></a>
						</td>
						<td><input type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#get_product.stock_code#" readonly style="width:120px;"></td>
						<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode#currentrow#" id="barcode#currentrow#" value="#get_product.barcod#" readonly style="width:90px;"></td></cfif>
						<td nowrap>
							<input type="hidden" value="#product_id#" name="product_id#currentrow#"  id="product_id#currentrow#"/>
							<input type="hidden" value="#stock_id#" name="stock_id#currentrow#" id="stock_id#currentrow#">
							<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#get_product.product_name# #get_product.property#" readonly style="width:230px;">                                    
							<a href="javascript://" onclick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang no ='56.Stok Detay'>"></a>&nbsp;&nbsp;&nbsp;
						</td>
					
						<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
						<cfset _AMOUNT__ = wrk_round(get_order_amount.quantity,round_number,1)>
						<td style="display:#spec_img_display#;" nowrap>
							<cfif len(spect_id) or len(SPEC_MAIN_ID)>
								<cfquery name="GET_SPECT" datasource="#dsn3#">
									<cfif len(spect_id)>
										SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_id#">
									<cfelse>
										SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPEC_MAIN_ID#">
									</cfif>
								</cfquery>
								<input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="#spect_id#">
								<input type="#Evaluate('spec_display')#" value="#SPEC_MAIN_ID#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
								<input type="#Evaluate('spec_display')#" name="spect_id#currentrow#" id="spect_id#currentrow#"value="#spect_id#" readonly style="width:40px;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',4);"><img src="/images/plus_thin_p.gif" align="absbottom" border="0" title="<cf_get_lang no='481.Spect Detay'>"></a>
							<cfelse>
								<input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="">
								<input type="#Evaluate('spec_display')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="" readonly style="width:40px;">
								<input type="#Evaluate('spec_display')#" name="spect_id#currentrow#" id="spect_id#currentrow#" value="" readonly style="width:40px;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="" readonly style="width:150px;">
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',4);"><img src="/images/plus_thin_p.gif" align="absbottom" border="0" title="<cf_get_lang no='481.Spect Detay'>"></a>
							</cfif>
						</td>
						<td>
						<div id="miktar_sonuc_#currentrow#"></div>
						<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,0)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('GET_SUM_AMOUNT')>aktar('#p_order_id#','#currentrow#');</cfif>"<cfif is_change_amount_demontaj eq 0 or GET_FIS.RECORDCOUNT>readonly</cfif> class="moneybox" style="width:70px;"></td>
						<cfif len(get_row_enter.fire_amount)><cfset fire_amount_ = get_row_enter.fire_amount><cfelse><cfset fire_amount_ = 0></cfif>
						<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(wrk_round(_AMOUNT__+fire_amount_,round_number,1),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;" <cfif is_change_amount_demontaj eq 0 or GET_FIS.RECORDCOUNT>readonly</cfif>>
						<cfif x_is_fire_product eq 1>
							<td>
								<input type="hidden" class="moneybox" name="fire_amount__#currentrow#" id="fire_amount__#currentrow#" value="#TlFormat(wrk_round(get_row_enter.fire_amount,round_number,1),0)#" style="width:60px;" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,3);aktar();">
								<input type="text" class="moneybox" name="fire_amount_#currentrow#" id="fire_amount_#currentrow#" value="#TlFormat(wrk_round(get_row_enter.fire_amount,round_number,1),0)#" style="width:60px;" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,3);aktar('#p_order_id#','#currentrow#');">
							</td>
						</cfif>
						<td>
							<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#get_product.product_unit_id#">
							<input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#get_product.main_unit#" readonly style="width:60px;">
						</td>
						<!---<cfif x_is_show_abh eq 1>
							<td><input type="text" name="dimention#currentrow#" id="dimention#currentrow#" value="#get_product.dimention#" readonly style="width:60px;"></td>
						</cfif>--->
						<cfset PURCHASE_NET_ = wrk_round(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,8,1)>
						<cfif len(PURCHASE_NET_2)>
							<cfset PURCHASE_NET_2_ = wrk_round(PURCHASE_NET_2+PURCHASE_EXTRA_COST_SYSTEM_2,8,1)>
						<cfelse>	
							<cfset PURCHASE_NET_2_ = 0>
						</cfif>
						<cfset PURCHASE_NET_EXTRA_2_ = wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1)>
						<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
							<td><input type="text" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#" class="moneybox" readonly style="width:125px;"></td>
							<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
								<td><input type="text" name="total_cost_price#currentrow#" id="total_cost_price#currentrow#" value="#TLFormat(PURCHASE_NET_ * _AMOUNT_,round_number,0)#" class="moneybox" readonly style="width:125px;"></td>
                            </cfif>
							<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
								<td>
									<input type="hidden" name="labor_cost#currentrow#" id="labor_cost#currentrow#" value="#LABOR_COST_SYSTEM#" style="width:0px;">
									<input type="text" name="____labor_cost#currentrow#" id="____labor_cost#currentrow#" class="moneybox" readonly value="#TLFormat(LABOR_COST_SYSTEM,round_number,0)#" style="width:90px;">
								</td>
							</cfif>
							<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
								<td>
									<input type="hidden" name="station_reflection_cost_system#currentrow#" id="station_reflection_cost_system#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM#" style="width:0px;">
									<input type="text" name="____station_reflection_cost_system#currentrow#" id="____station_reflection_cost_system#currentrow#" class="moneybox" readonly value="#TLFormat(STATION_REFLECTION_COST_SYSTEM,round_number)#" style="width:90px;">
								</td>
							</cfif>
							<td><input type="text" name="money#currentrow#" id="money#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#" readonly style="width:50px;"></td>
							<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
								<td><input type="text" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" class="moneybox" readonly style="width:125px;"></td>
								<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(PURCHASE_NET_EXTRA_2_,round_number)#">
                                <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                    <td><input type="text" name="total_cost_price_2#currentrow#" id="total_cost_price_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_ * _AMOUNT_,round_number)#" class="moneybox" readonly style="width:125px;"></td>
                                </cfif>
							<cfelse>
								<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
								<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(PURCHASE_NET_EXTRA_2_,round_number)#">
                            </cfif>
							<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
								<td>
									<cfif len(LABOR_COST_SYSTEM)>
										<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM / get_money_rate.rate2>
									<cfelse>
										<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM>
									</cfif>
									<input type="text" name="____labor_cost2_#currentrow#" id="____labor_cost2_#currentrow#" class="moneybox" readonly value="#TLFormat(LABOR_COST_SYSTEM_,round_number)#" style="width:90px;">
								</td>
							</cfif>
							<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
								<td>
									<cfif len(STATION_REFLECTION_COST_SYSTEM)>
										<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2>
									<cfelse>
										<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM>
									</cfif>
									<input type="text" name="____station_reflection_cost_system2_#currentrow#" id="____station_reflection_cost_system2_#currentrow#" class="moneybox" readonly value="#TLFormat(STATION_REFLECTION_COST_SYSTEM_,round_number)#" style="width:90px;">
								</td>
							</cfif>
                            <cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
                                <td><input type="text" name="money_2#currentrow#" id="money_2#currentrow#" value="#PURCHASE_NET_MONEY_2#" readonly style="width:50px;"></td>
                            <cfelse>
                                <input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
                            </cfif>
						<cfelse>
							<cfif len(LABOR_COST_SYSTEM)>
								<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM / get_money_rate.rate2>
							<cfelse>
								<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM>
							</cfif>
							<cfif len(STATION_REFLECTION_COST_SYSTEM)>
								<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2>
							<cfelse>
								<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM>
							</cfif>
							<input type="hidden" name="labor_cost#currentrow#" id="labor_cost#currentrow#" value="#LABOR_COST_SYSTEM#">
							<input type="hidden" name="station_reflection_cost_system#currentrow#" id="station_reflection_cost_system#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM#">
							<input type="hidden" name="labor_cost2_#currentrow#" id="labor_cost2_#currentrow#" value="#LABOR_COST_SYSTEM_#">
							<input type="hidden" name="station_reflection_cost_system2_#currentrow#" id="station_reflection_cost_system2_#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM_#">
							<input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TLFormat(PURCHASE_NET,round_number)#">
							<input type="hidden" name="money#currentrow#" id="money#currentrow#" value="#PURCHASE_NET_MONEY#">
							<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(PURCHASE_NET_2,round_number)#">
							<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(PURCHASE_NET_EXTRA_2_,round_number)#">
							<input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
						</cfif>
						<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
							<td><input type="text" name="amount2_#currentrow#" id="amount2_#currentrow#" value="#TLFormat(AMOUNT2,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="" class="moneybox" style="width:70px;"></td>
							<td>
								<cfset _unıt2_ = UNIT2>
								<cfquery name="get_all_unit2" datasource="#dsn3#">
									 SELECT 
										PRODUCT_UNIT_ID,ADD_UNIT
									FROM 
										PRODUCT_UNIT 
									WHERE
										PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
										AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#">
										AND IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable_#">
								</cfquery>
								<select name="unit2#currentrow#" id="unit2#currentrow#" style="width:60;">
								<cfloop query="get_all_unit2">
									<option value="#ADD_UNIT#"<cfif _unıt2_ eq ADD_UNIT>selected</cfif>>#ADD_UNIT#</option>
								</cfloop>
								</select>
							</td>
						</cfif>
						<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2#currentrow#" id="product_name2#currentrow#" value="#product_name2#"></td>
						<td>
							<cfif len(get_detail.exit_dep_id)>
								<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
									SELECT
										SG.LOT_NO,
										SG.SERIAL_NO
									FROM
										SERVICE_GUARANTY_NEW AS SG
									WHERE
										STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#"> AND
										PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
										PROCESS_CAT = 171 AND
										<cfif len(spect_id)>
											SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_id#"> AND
										</cfif>
										SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
								</cfquery>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_stock_serialno&wrk_row_id=#get_detail.wrk_row_id#&product_id=#product_id#&stock_id=#stock_id#&process_number=#get_detail.result_no#&process_date=#get_detail.finish_date#&process_cat=171&process_id=#attributes.pr_order_id#&sale_product=0&is_serial_no=1&product_amount=#amount#&recorded_count=#get_serial_info.recordcount#&sale_product=0&company_id=&con_id=&location_out=#get_detail.exit_loc_id#&department_out=#get_detail.exit_dep_id#&location_in=#get_detail.production_loc_id#&department_in=#get_detail.production_dep_id#&guaranty_cat=&guaranty_startdate=&spect_id=#spect_id#','medium');"><img src="/images/barcode.gif" align="absbottom" border="0"></a>
							</cfif>
						</td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.list_quality_controls&event=add&pr_order_id=#attributes.pr_order_id#&product_id=#product_id#&stock_id=#stock_id#&process_id=#attributes.party_id#&process_row_id=#PR_ORDER_ROW_ID#&process_cat=171&ship_wrk_row_id=#wrk_row_id#','project');"><img src="/images/control.gif" border="0" align="absbottom" title="<cf_get_lang no='337.Kalite Kontrol'>"></a></td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_upper_serial_operations&wrk_row_id=#get_detail.wrk_row_id#&party_id=#attributes.party_id#&product_id=#product_id#&stock_id=#stock_id#&process_number=#get_detail.result_no#&process_cat_id=171&process_id=#attributes.pr_order_id#&is_serial_no=1&product_amount=#amount#&location_out=#get_detail.exit_loc_id#&department_out=#get_detail.exit_dep_id#&location_in=#get_detail.production_loc_id#&department_in=#get_detail.production_dep_id#&belge_no=#get_detail.production_order_no#&new_dsn2=#new_dsn2#&spect_id=#spec_main_id#','project');"><img src="/images/barcode_add.gif" border="0" align="absbottom" title="Hızlı Seri Giriş"></a></td>
                    </tr>
				</cfoutput>
			</tbody>
		</table>
		<cf_seperator header="#getLang('prod',455)#" id="table2">
		<table id="table2" name="table2" class="basket_list" style="margin-bottom:50px; display:none; width:100%;">
			<!---Alan 2 için iframe--->
			<cfif x_pro_add_barkod_and_seri_no eq 1>
				<iframe name="add_prod" id="add_prod" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>&type=exit" width="100%" height="50"></iframe>
			</cfif>
            <thead>
				<tr>
					<th style="min-width:54px; text-align:center;"><input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#get_row_exit.recordcount#</cfoutput>"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=0&record_num_exit=' + form_basket.record_num_exit.value,'list')"><img id="add_row_exit_image" src="/images/plus_list.gif" align="absbottom" border="0"></a></th>
					<th style="min-width:125px;""><cf_get_lang_main no='106.Stok Kodu'></th>
					<cfif x_is_barkod_col eq 1><th style="min-width:95px;"><cf_get_lang_main no='221.Barkod'></th></cfif>
					<th style="min-width:259px;"><cf_get_lang_main no='40.Stok'></th>
					<th style="min-width:263px; display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
					<th style="min-width:92px;"><cf_get_lang no='385.Lot No'></th>
					<th style="min-width:75px;"><cf_get_lang_main no='223.Miktar'></th>
					<th style="min-width:65px;"><cf_get_lang_main no='224.Birim'></th>
					<cfif x_is_show_abh eq 1><th style="min-width:65px;">a*b*h</th></cfif>
					<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
						<th style="min-width:151px; text-align:right;"><cf_get_lang no='454.Birim Maliyet'></th>
						<th style="min-width:151px; text-align:right;">Ek Maliyet</th>
                        <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                            <th style="min-width:151px; text-align:right;"><cf_get_lang no='499.Toplam Maliyet'></th>
                        </cfif>
						<th style="min-width:55px; text-align:right;"><cf_get_lang_main no='77.Para Br'></th>
						<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
							<th style="min-width:151px; text-align:right;"><cf_get_lang no='454.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
							<th style="min-width:151px; text-align:right;">Ek Maliyet (<cfoutput>#session.ep.money2#</cfoutput>)</th>
							<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                <th style="min-width:151px; text-align:right;"><cf_get_lang no='499.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                            </cfif>
							<th style="min-width:55px;"><cf_get_lang_main no='77.Para Br'></th>
						</cfif>
					</cfif>
					<cfif is_show_two_units eq 1>
						<th style="min-width:75px;">2.<cf_get_lang_main no='223.Miktar'></th>
						<th style="min-width:40px;">2.<cf_get_lang_main no='224.Birim'></th>
					</cfif>
					<cfif is_show_product_name2 eq 1>
						<th style="min-width:75px;">2.<cf_get_lang_main no='217.Açıklama'></th>
					</cfif>
					<cfif GET_DETAIL.is_demontaj neq 1 and x_is_show_sb eq 1>
						<th style="min-width:22px;">SB</th>
					</cfif>
                    <cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1><th width="30" title="Manuel Maliyet">M</th></cfif>
				</tr>
			</thead>
			<tbody id="table2_body">
				<cfoutput query="get_row_exit">
					<cfquery name="GET_PRODUCT" datasource="#DSN1#">
						SELECT 
							PRODUCT.PRODUCT_NAME,
							PRODUCT.BARCOD,
							STOCKS.PRODUCT_UNIT_ID,
							PRODUCT_UNIT.ADD_UNIT,
							PRODUCT_UNIT.MAIN_UNIT,
							PRODUCT_UNIT.DIMENTION,
							STOCKS.PROPERTY,
							STOCKS.STOCK_CODE
						FROM 
							PRODUCT,
							STOCKS,
							PRODUCT_UNIT
						WHERE 
							STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
							PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
					</cfquery>
					<!--- Sarflar --->
					<tr id="frm_row_exit#currentrow#" <cfif TREE_TYPE is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif TREE_TYPE is 'O'>class="operasyon" title="Operasyondan Gelen Ürünler"</cfif>>
						<cfif is_from_spect eq 1>
                            <input type="hidden" name="is_add_info_#currentrow#" id="is_add_info_#currentrow#" value="1">
                        </cfif>
                        <cfset cols_ = 11>
                        <input type="hidden" name="line_number_exit_#currentrow#" id="line_number_exit_#currentrow#" value="#line_number#">
                        <input type="hidden" name="wrk_row_id_exit_#currentrow#" id="wrk_row_id_exit_#currentrow#" value="#wrk_row_id#">
                        <input type="hidden" name="wrk_row_relation_id_exit_#currentrow#" id="wrk_row_relation_id_exit_#currentrow#" value="#wrk_row_relation_id#">
                        <input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#TREE_TYPE#">
                        <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                        <input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#COST_ID#">
                        <input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#KDV_PRICE#">
                        <input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">
						<td nowrap="nowrap" style="text-align:center;width:40px;">
							<a style="cursor:pointer" onclick="copy_row_exit('#currentrow#');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>
                            <a style="cursor:pointer" onclick="sil_exit('#currentrow#');"><img  src="images/delete_list.gif" border="0" align="absbottom" title="<cf_get_lang_main no='51.Sil'>"></a>
						</td>
						<td><input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#get_product.stock_code#" readonly style="width:120px;"></td>
						<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode_exit#currentrow#" id="barcode_exit#currentrow#" value="#get_product.barcod#" readonly style="width:90px;"></td><cfset cols_ = cols_ + 1></cfif>
						<td nowrap>
							<input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#" value="#product_id#">
							<input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
							<input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#get_product.product_name# #get_product.property#" readonly style="width:230px;">
							<a href="javascript://" onclick="pencere_ac_alternative(1,'#currentrow#',document.form_basket.product_id_exit#currentrow#.value,document.all.stock_id1.value);"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang no ='526.Alternatif Ürünler'>"></a>
							<a href="javascript://" onclick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang no ='56.Stok Detay'>"></a>
						</td>
						<td style="display:#spec_img_display#;" nowrap>
							<cfif len(get_row_exit.spect_id) OR LEN(get_row_exit.SPEC_MAIN_ID) >
								<cfquery name="GET_SPECT" datasource="#dsn3#">
									<cfif len(get_row_exit.spect_id)>
										SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.spect_id#">
									<cfelse>
										SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.SPEC_MAIN_ID#">
									</cfif>
								</cfquery>
								<input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_row_exit.spect_id#" >
								<input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_row_exit.SPEC_MAIN_ID#" readonly style="width:40px;">
								<input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_row_exit.spect_id#"  readonly style="width:40px;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:160px;">
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
							<cfelse>
								<!--- Demontaj sırasında spect'in değişip değişmediğini kontrol etmek için,değişmiş ise sayfa reload ediliyor. --->
								<input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="">
								<input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="" readonly style="width:40px;">
								<input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="" readonly style="width:160px;">
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
							</cfif>
						</td>
						<td nowrap="nowrap">
                        	<input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="#get_row_exit.lot_no#" onKeyup="lotno_control(#currentrow#,2);" style="width:75px;" />
                       		<a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','2');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
                        </td>
						<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
						<td>
							<input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));"  onblur="hesapla_deger(#currentrow#,0);<cfif GET_DETAIL.IS_DEMONTAJ eq 1 and isdefined('GET_SUM_AMOUNT')>aktar();</cfif>" <cfif GET_DETAIL.IS_DEMONTAJ eq 0 or GET_FIS.RECORDCOUNT>#_readonly_#</cfif>  class="moneybox" style="width:70px;">
							<input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));"  onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;">
						</td>
						<td>
							<input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#get_product.product_unit_id#">
							<input type="text" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#get_product.main_unit#" readonly style="width:60px;">
							<input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#" value="#serial_no#" style="width:150px;">
						</td>
						<cfset PURCHASE_NET_ = wrk_round(PURCHASE_NET,8,1)>
                        <cfif len(PURCHASE_NET_2)>
							<cfset PURCHASE_NET_2_ = wrk_round(PURCHASE_NET_2,8,1)>
						<cfelse>	
							<cfset PURCHASE_NET_2_ = 0>
						</cfif>
						<cfif x_is_show_abh eq 1><td><input type="text" name="dimention_exit#currentrow#" id="dimention_exit#currentrow#" value="#get_product.dimention#" readonly style="width:60px;"></td></cfif>
						<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
							<td><input type="text" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,2);"</cfif>></td>
							<td>
								<input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM#">
								<input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
								<input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
								<input type="text" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,2);"</cfif>>
							</td>
                            <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                <td><input type="text" name="total_cost_price_exit#currentrow#" id="total_cost_price_exit#currentrow#" value="#TLFormat((PURCHASE_NET_+PURCHASE_EXTRA_COST)*_AMOUNT_,round_number)#" readonly class="moneybox"></td>
                            </cfif>
							<td><input type="text" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#PURCHASE_NET_MONEY#" readonly style="width:50px;"></td>
							<cfset cols_ = cols_ + 3>
							<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
								<td><input type="text" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
								<td><input type="text" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                    <td><input type="text" name="total_cost_price_exit_2#currentrow#" id="total_cost_price_exit_2#currentrow#" value="#TLFormat((PURCHASE_NET_2_+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1))*_AMOUNT_,round_number)#" readonly class="moneybox"></td><cfset cols_ = cols_ + 1>
                                </cfif>
                                <td><input type="text" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#PURCHASE_NET_MONEY_2#" <cfif is_change_sarf_cost eq 0>readonly</cfif> style="width:50px;"></td>
								<cfset cols_ = cols_ + 3>
                            <cfelse>
								<input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
								<input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#">
                                <input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
                            </cfif>
						<cfelse>
							<input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM#">
							<input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
							<input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
							<input type="hidden" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST,round_number)#" class="moneybox" readonly>
							<input type="hidden" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#">
							<input type="hidden" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#PURCHASE_NET_MONEY#">
							<input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
							<input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST_SYSTEM_2,round_number)#" class="moneybox" readonly>
							<input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
						</cfif>
						<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
						<td><input type="text" name="amount_exit2_#currentrow#" id="amount_exit2_#currentrow#" value="#TLFormat(AMOUNT2,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="" class="moneybox" style="width:70px;"></td>
						<td>
							<cfset _unit2e_ = UNIT2>
							<cfquery name="get_all_unit2" datasource="#dsn3#">
								 SELECT 
									PRODUCT_UNIT_ID,ADD_UNIT
								FROM 
									PRODUCT_UNIT 
								WHERE
									PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
									AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#">
									AND IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable_#">
							</cfquery>
							<select name="unit2_exit#currentrow#" id="unit2_exit#currentrow#" style="width:60;">
								<cfloop query="get_all_unit2">
									<option value="#ADD_UNIT#"<cfif _unit2e_ eq ADD_UNIT>selected</cfif>>#ADD_UNIT#</option>
								</cfloop>
							</select>
						</td>
                        <cfset cols_ = cols_ + 2>
						</cfif>
						<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2_exit#currentrow#" id="product_name2_exit#currentrow#" value="#product_name2#"></td>
						<cfif GET_DETAIL.is_demontaj neq 1>
							<td <cfif x_is_show_sb eq 0> style="display:none;" </cfif>>
								<cfquery name="get_is_production" datasource="#dsn3#">
									SELECT TOP 1 IS_PRODUCTION FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
								</cfquery>
								<input type="checkbox" name="is_sevkiyat#currentrow#" id="is_sevkiyat#currentrow#" <cfif get_row_exit.is_sevkiyat eq 1>checked</cfif>>
								<input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="#get_is_production.IS_PRODUCTION#"><!--- Üretilen bir ürün ise hidden alan 1 oluyor ve query sayfasında bu ürün için otomatik bir spect oluşuyor --->
							</td>
                            <cfset cols_ = cols_ + 1>
						</cfif>
                        <td <cfif isdefined('x_is_show_mc') and x_is_show_mc eq 0> style="display:none;" </cfif>>
                            <input type="checkbox" name="is_manual_cost_exit#currentrow#" id="is_manual_cost_exit#currentrow#" value="1" <cfif get_row_exit.is_manual_cost eq 1>checked</cfif>>
                        </td>
						<cfif GET_DETAIL.is_demontaj eq 1>
                        	<cfset cols_ = cols_ + 1>
							<td>
								<cf_get_lang no='547.Demontaj'>
								<input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="0">
							</td>
						</cfif>
					</tr>
				</cfoutput>
			</tbody>
            <cfif get_row_exit.recordcount>
            <tfoot>
            	<tr>
                	<td style="text-align:center;" nowrap="nowrap"><a style="cursor:pointer" onclick="sil_exit_all();"><cf_get_lang_main no="2239.hepsini sil"></a></td>
                    <td colspan="<cfoutput>#cols_+1#</cfoutput>"></td>
                </tr>
            </tfoot>
            </cfif>
		</table>
		<cf_seperator header="#getLang('main',1674)#" id="table3">
		<table id="table3" name="table3" class="basket_list" style="margin-bottom:50px; display:none; width:100%;">
            <cfif x_pro_add_barkod_and_seri_no eq 1>
				<iframe name="add_prod" id="add_prod" frameborder="0" vspace="0" hspace="0" scrolling="no" src="<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>&type=outage" width="100%" height="50"></iframe>
			</cfif>
			<thead>
				<tr>
					<th style="min-width:54px; text-align:center;"><input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfoutput>#get_row_outage.recordcount#</cfoutput>"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=2&record_num_outage=' + form_basket.record_num_outage.value,'list')"><img id="add_row_outage_image" src="/images/plus_list.gif" align="absbottom" border="0"></a></th>
					<th style="min-width:125px;"><cf_get_lang_main no='106.Stok Kodu'></th>
					<cfif x_is_barkod_col eq 1><th style="min-width:95px;"><cf_get_lang_main no='221.Barkod'></th></cfif>
					<th style="min-width:259px;"><cf_get_lang_main no='40.Stok'></th>
					<th style="min-width:253px; display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang_main no='235.spect'></th>
					<th style="min-width:92px;"><cf_get_lang no='385.Lot No'></th>
					<th style="min-width:75px;"><cf_get_lang_main no='223.Miktar'></th>
					<th style="min-width:65px;"><cf_get_lang_main no='224.Birim'></th>
					<cfif x_is_show_abh eq 1><th style="min-width:65px;">a*b*h</th></cfif>
					<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
						<th style="min-width:151px; text-align:right;"><cf_get_lang no='454.Birim Maliyet'></th>
						<th style="min-width:151px; text-align:right;">Ek Maliyet</th>
                        <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                            <th style="min-width:151px; text-align:right;"><cf_get_lang no='499.Toplam Maliyet'></th>
                        </cfif>
						<th style="min-width:55px;"><cf_get_lang_main no='77.Para Br'></th>
						<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
							<th style="min-width:151px; text-align:right;"><cf_get_lang no='454.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
							<th width="120" style="text-align:right;">Ek Maliyet (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                            <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                <th style="min-width:151px; text-align:right;"><cf_get_lang no='499.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                            </cfif>
							<th style="min-width:55px;"><cf_get_lang_main no='77.Para Br'></th>
						</cfif>
					</cfif>
					<cfif is_show_two_units eq 1>
						<th style="min-width:75px;">2.<cf_get_lang_main no='223.Miktar'></th>
						<th style="min-width:40px;">2.<cf_get_lang_main no='224.Birim'></th>
					</cfif>
					<cfif is_show_product_name2 eq 1>
						<th style="min-width:75px;">2.<cf_get_lang_main no='217.Açıklama'></th>
					</cfif>
                    <cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1><th width="30" title="Manuel Maliyet">M</th></cfif>
				</tr>
			</thead>
			<tbody id="table3_body">
				<cfoutput query="get_row_outage">
					<cfquery name="GET_PRODUCT" datasource="#DSN1#">
						SELECT 
							PRODUCT.PRODUCT_NAME,
							PRODUCT.BARCOD,
							STOCKS.PRODUCT_UNIT_ID,
							PRODUCT_UNIT.ADD_UNIT,
							PRODUCT_UNIT.MAIN_UNIT,
							PRODUCT_UNIT.DIMENTION,
							STOCKS.PROPERTY,
							STOCKS.STOCK_CODE
						FROM 
							PRODUCT,
							STOCKS,
							PRODUCT_UNIT
						WHERE 
							PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
							STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
							PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
					</cfquery>
					<tr id="frm_row_outage#currentrow#">
                        <input type="hidden" name="line_number_outage_#currentrow#" id="line_number_outage_#currentrow#" value="#line_number#">
                        <input type="hidden" name="wrk_row_id_outage_#currentrow#" id="wrk_row_id_outage_#currentrow#" value="#wrk_row_id#">
                        <input type="hidden" name="wrk_row_relation_id_outage_#currentrow#" id="wrk_row_relation_id_outage_#currentrow#" value="#wrk_row_relation_id#">
                        <input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
                        <input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#COST_ID#">
                        <input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#KDV_PRICE#">
                        <input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">
						<td nowrap="nowrap" style="text-align:center;width:40px;">
							<a style="cursor:pointer" onclick="copy_row_outage('#currentrow#');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>
                            <a style="cursor:pointer" onclick="sil_outage('#currentrow#');"><img  src="images/delete_list.gif" border="0" align="absbottom" title="<cf_get_lang_main no='51.Sil'>"></a>
						</td>
						<td><input type="text" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#get_product.stock_code#" readonly style="width:120px;"></td>
						<cfif x_is_barkod_col eq 1><td><input type="text" name="barcode_outage#currentrow#" id="barcode_outage#currentrow#" value="#get_product.barcod#" readonly style="width:90px;"></td></cfif>
						<td nowrap="nowrap">
							<input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
							<input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#">
							<input type="text" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#get_product.product_name# #get_product.property#" readonly style="width:230px;">
							<a href="javascript://" onclick="pencere_ac_alternative(2,'#currentrow#',document.form_basket.product_id_outage#currentrow#.value,document.all.stock_id1.value);"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang no ='526.Alternatif Ürünler'>"></a>
							<a href="javascript://" onclick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang no ='56.Stok Detay'>"></a>
						</td>
						<td nowrap="nowrap" style="display:#spec_img_display#;">
							<cfif len(get_row_outage.spect_id)  OR LEN(get_row_outage.SPEC_MAIN_ID) >
								<cfquery name="GET_SPECT" datasource="#dsn3#">
									<cfif len(get_row_outage.spect_id)>
										SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.spect_id#">
									<cfelse>
										SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.SPEC_MAIN_ID#">
									</cfif>
								</cfquery>
								<input type="#Evaluate('spec_display')#" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="#get_row_outage.SPEC_MAIN_ID#" readonly style="width:40px;">
								<input type="#Evaluate('spec_display')#" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="#get_row_outage.spect_id#" readonly style="width:40px;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
							<cfelse>
								<input type="#Evaluate('spec_display')#" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="" readonly style="width:40px;">
								<input type="#Evaluate('spec_display')#" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;">
								<input type="#Evaluate('spec_name_display')#" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="" readonly style="width:150px;">
								<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
							</cfif>
						</td>
                        <td nowrap="nowrap">
                       		<input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="#get_row_outage.lot_no#" onKeyup="lotno_control(#currentrow#,3);" style="width:75px;" />
                            <a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','3');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
                        </td>
						<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
						<td>
							<input type="text" name="amount_outage#currentrow#" id="amount_outage#currentrow#" #_readonly_# value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" style="width:70px;">
							<input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));"  onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;">
						</td>
						<td>
							<input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#get_product.product_unit_id#">
							<input type="text" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#get_product.main_unit#" readonly style="width:60px;">
							<input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outage#currentrow#" value="#serial_no#" style="width:150px;">
						</td>
						<cfif x_is_show_abh eq 1><td><input type="text" name="dimention_outage#currentrow#" id="dimention_outage#currentrow#" value="#get_product.dimention#" readonly style="width:60px;"></td></cfif>
						<cfset PURCHASE_NET_ = wrk_round(PURCHASE_NET,8,1)>
						<cfset PURCHASE_NET_2_ = wrk_round(PURCHASE_NET_2,8,1)>
						<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
							<td><input type="text" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,8));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,3);"</cfif>></td>
							<td>
								<input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM#">
								<input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
								<input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
								<input type="text" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST,8,1),8,0)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,8));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,3);"</cfif>>
							</td>
                            <cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                <td><input type="text" name="total_cost_price_outage#currentrow#" id="total_cost_price_outage#currentrow#" value="#TLFormat((PURCHASE_NET_+PURCHASE_EXTRA_COST)*_AMOUNT_,round_number)#" readonly class="moneybox"></td>                           
                            </cfif>
							<td><input type="text" name="money_outage#currentrow#" id="money_outage#currentrow#" value="#PURCHASE_NET_MONEY#" readonly style="width:50px;"></td>
							<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
								<td><input type="text" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
								<td><input type="text" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></td>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
                                    <td><input type="text" name="total_cost_price_outage_2#currentrow#" id="total_cost_price_outage_2#currentrow#" value="#TLFormat((PURCHASE_NET_2_+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1))*_AMOUNT_,round_number)#" readonly class="moneybox"></td>
                                </cfif>
                                <td><input type="text" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#PURCHASE_NET_MONEY_2#" readonly style="width:50px;"></td>
							<cfelse>
								<input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));">
								<input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#">
                                <input type="hidden" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
                            </cfif>
						<cfelse>
							<input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM#">
							<input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
							<input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
							<input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST,round_number)#" />
							<input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#">
							<input type="hidden" name="money_outage#currentrow#"  id="money_outage#currentrow#"value="#PURCHASE_NET_MONEY#">
							<input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
							<input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),round_number)#">
							<input type="hidden" name="money_outage_2#currentrow#"  id="money_outage_2#currentrow#"value="#PURCHASE_NET_MONEY_2#">
						</cfif>
						<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
						<td><input type="text" name="amount_outage2_#currentrow#" id="amount_outage2_#currentrow#" value="#TLFormat(AMOUNT2,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="" class="moneybox" style="width:70px;"></td>
						<td>
							<cfset _unit2o_ = UNIT2>
							<cfquery name="get_all_unit2" datasource="#dsn3#">
								 SELECT 
									PRODUCT_UNIT_ID,ADD_UNIT
								FROM 
									PRODUCT_UNIT 
								WHERE
									PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
									AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> 
									AND IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable_#">
							</cfquery>
							<select name="unit2_outage#currentrow#" id="unit2_outage#currentrow#" style="width:60;">
								<cfloop query="get_all_unit2">
									<option value="#ADD_UNIT#"<cfif _unit2o_ eq ADD_UNIT>selected</cfif>>#ADD_UNIT#</option>
								</cfloop>
							</select>
						</td>
						</cfif>
						<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2_outage#currentrow#" id="product_name2_outage#currentrow#" value="#product_name2#"></td>
						<td <cfif isdefined('x_is_show_mc') and x_is_show_mc eq 0> style="display:none;" </cfif>>
                            <input type="checkbox" name="is_manual_cost_outage#currentrow#" id="is_manual_cost_outage#currentrow#" value="1" <cfif is_manual_cost eq 1>checked</cfif>>
                        </td>
                    </tr>
				</cfoutput>
			</tbody>
            <cfif get_row_outage.recordcount>
            <tfoot>
            	<tr>
                	<td style="text-align:center;" nowrap="nowrap"><a style="cursor:pointer" onclick="sil_outage_all();"><cf_get_lang_main no="2239.hepsini sil"></a></td>
                    <td colspan="<cfoutput>#cols_+1#</cfoutput>"></td>
                </tr>
            </tfoot>
            </cfif>
		</table>
    </cf_basket>
        </div>
    </div>
	
	
	<cfquery name="get_company_id" datasource="#dsn3#">
		SELECT COMPANY_ID FROM TEXTILE_SAMPLE_REQUEST WHERE PROJECT_ID=#GET_DETAIL.PROJECT_ID#
	</cfquery>
                                        
	<cf_get_textile_labor_critics company_id='#get_company_id.company_id#' action_section='TEXTILE_SAMPLE_REQUEST' action_id='#GET_DETAIL.REQ_ID#'>									
										
										
										
</cfform>
<script language="javascript">
	$(document).ready(function(){
	row_count=<cfoutput>#get_row_enter.recordcount#</cfoutput>;
	row_count_exit=<cfoutput>#get_row_exit.recordcount#</cfoutput>;
	row_count_outage = <cfoutput>#get_row_outage.recordcount#</cfoutput>;
	round_number = <cfoutput>#round_number#</cfoutput>;//xmlden geliyor. miktar kusuratlarini burdan aliyor
	});
	function change_row_cost(row_no,type)
	{
		if(type == 2)
		{
			new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
			extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_exit"+row_no).value,round_number);
			new_money = document.getElementById("money_exit"+row_no).value;
			amount = document.getElementById("amount_exit"+row_no).value;
			kontrol_money = 0;
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("hidden_rd_money_"+s).value == new_money)
				{
					rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
					rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
					kontrol_money = 1;
				}
			}
			if(kontrol_money==0){rate1=1;rate2=1;}
			document.getElementById("cost_price_system_exit"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
			document.getElementById("purchase_extra_cost_system_exit"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
			total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
			</cfif>
		}
		else if (type == 3)
		{
			new_cost = filterNum(document.getElementById("cost_price_outage"+row_no).value,round_number);
			extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_outage"+row_no).value,round_number);
			new_money = document.getElementById("money_outage"+row_no).value;
			amount = document.getElementById("amount_outage"+row_no).value;
			kontrol_money = 0;
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("hidden_rd_money_"+s).value == new_money)
				{
					rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
					rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
					kontrol_money = 1;
				}
			}
			if(kontrol_money==0){rate1=1;rate2=1;}
			document.getElementById("cost_price_system_outage"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
			document.getElementById("purchase_extra_cost_system_outage"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
			total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
			</cfif>
		}
		else if(type == 1)
		{
			row_no = 1;
			for (var row_no=1;row_no<=row_count_exit;row_no++)//sarflarin satirdaki maliyetlerini gunceliiyor
			{
				if(document.getElementById("row_kontrol_exit"+row_no).value==1)// sarf ürün satırı olması için kontrol eklendi.
				{
					new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
					extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_exit"+row_no).value,round_number);
					new_money = document.getElementById("money_exit"+row_no).value;
					amount = document.getElementById("amount_exit"+row_no).value;
					kontrol_money = 0;
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.getElementById("hidden_rd_money_"+s).value == new_money)
						{
							rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
							rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							kontrol_money = 1;
						}
					}
					if(kontrol_money==0){rate1=1;rate2=1;}
					document.getElementById("cost_price_system_exit"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
					document.getElementById("purchase_extra_cost_system_exit"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
					total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
					<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
					</cfif>
				}
			}
			for (var row_no=1;row_no<=row_count_outage;row_no++)//firelerin satirdaki maliyetlerini gunceliiyor
			{
				if(document.getElementById("row_kontrol_outage"+row_no).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					new_cost = filterNum(document.getElementById("cost_price_outage"+row_no).value,round_number);
					extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_outage"+row_no).value,round_number);
					new_money = document.getElementById("money_outage"+row_no).value;
					amount = document.getElementById("amount_outage"+row_no).value;
					kontrol_money = 0;
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.getElementById("hidden_rd_money_"+s).value == new_money)
						{
							rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
							rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							kontrol_money = 1;
						}
					}
					if(kontrol_money==0){rate1=1;rate2=1;}
					document.getElementById("cost_price_system_outage"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
					document.getElementById("purchase_extra_cost_system_outage"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
					total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
					<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
					</cfif>
				}
			}
		}
	}
	function counter(field, countfield, maxlimit){ 
		if(field.value.length > maxlimit){ 
			field.value = field.value.substring(0, maxlimit);
			alert("Max "+maxlimit+"!"); 
		}
		else 
			countfield.value = maxlimit - field.value.length; 
	} 
	function kontrol2()
	{
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		if (!process_cat_control()) return false;
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		form_basket.del_pr_order_id.value = <cfoutput>#get_Detail.pr_order_id#</cfoutput>;
		<cfif x_fis_kontrol eq 1 and isdefined("get_ship_kontrol") and get_ship_kontrol.recordcount and get_ship_kontrol.is_delivered eq 1>
			alert("Oluşan Sevk İrsaliyesi Teslim Alınmıştır. Lütfen Teslim Al Seçeneğini Kaldırınız !");
			return false
		</cfif>
		return true;
	}
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		
		sarf_miktar_hesapla(sy);
	}
	
	function sil_exit(sy)
	{
		var my_element=document.getElementById("row_kontrol_exit"+sy);
		my_element.value=0;

		var my_element=eval("frm_row_exit"+sy);
		my_element.style.display="none";
	}
	function sil_exit_all()
	{
		for(i=1;i<=<cfoutput>#get_row_exit.recordcount#</cfoutput>;i++)
		{
				document.getElementById('frm_row_exit' + i).style.display="none";
				//my_element.parentNode.removeChild(my_element);
				document.getElementById("row_kontrol_exit"+i).value = 0;
		}
	}
	
	function sil_outage(sy)
	{
		var my_element=document.getElementById("row_kontrol_outage"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_outage"+sy);
		my_element.style.display="none";
	}
	function sil_outage_all(sy)
	{
		for(i=1;i<=<cfoutput>#get_row_outage.recordcount#</cfoutput>;i++)
		{
				document.getElementById('frm_row_outage' + i).style.display="none";
				document.getElementById("row_kontrol_outage"+i).value = 0;
		}
	}
	//iframe çalıstiriyor add_row fonksiyonunu
	<!--- XX --->function add_row(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
	{               
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.getElementById("record_num").value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="tree_type_' + row_count +'" id="tree_type_' + row_count +'" value="S"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absbottom" alt="Sil"></a><input type="hidden" name="cost_id' + row_count +'" id="cost_id' + row_count +'" value="'+cost_id+'"><input type="hidden" name="product_cost' + row_count +'" id="product_cost' + row_count +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money' + row_count +'" id="product_cost_money' + row_count +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system' + row_count +'" id="cost_price_system' + row_count +'" value="'+cost_price_system+'"><input type="hidden" name="money_system' + row_count +'" id="money_system' + row_count +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost' + row_count +'" id="purchase_extra_cost' + row_count +'" value="'+purchase_extra_cost+'"><input type="hidden" name="purchase_extra_cost_system' + row_count +'" id="purchase_extra_cost_system' + row_count +'" value="'+purchase_extra_cost_system+'"><cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1><input type="hidden" name="cost_price_extra_2' + row_count +'" id="cost_price_extra_2' + row_count +'" value="'+purchase_extra_cost_2+'" readonly class="moneybox"></cfif>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount' + row_count +'" id="kdv_amount' + row_count +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="barcode' + row_count +'" id="barcode' + row_count +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";	
		newCell.innerHTML = '<input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id' + row_count +'" id="spec_main_id' + row_count +'" value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id' + row_count +'" id="spect_id' + row_count +'" value="" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name' + row_count +'" id="spect_name' + row_count +'"value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count +');" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount' + row_count +'" id="amount' + row_count +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:70px;">';
		<cfif isdefined("x_is_fire_product") and x_is_fire_product eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="fire_amount_' + row_count +'" id="fire_amount_' + row_count +'" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="'+product_unit_id+'" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" value="'+main_unit+'" readonly style="width:60px;">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention' + row_count +'" id="dimention' + row_count +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price' + row_count +'" id="cost_price' + row_count +'" value="'+cost_price+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price' + row_count +'" id="total_cost_price' + row_count +'" value="'+commaSplit(filterNum(cost_price,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="labor_cost' + row_count +'" id="labor_cost' + row_count +'" value="" class="moneybox" style="width:0px;"><input type="text" name="____labor_cost' + row_count +'" id="____labor_cost' + row_count +'" value="" style="width:90px;">';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="station_reflection_cost_system' + row_count +'" id="station_reflection_cost_system' + row_count +'" value="" class="moneybox" style="width:0px;"><input type="text" name="____station_reflection_cost_system' + row_count +'" id="____station_reflection_cost_system' + row_count +'" value="" style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money' + row_count +'" id="money' + row_count +'" value="'+cost_price_money+'" readonly style="width:50px;">';	
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" value="'+cost_price_2+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_2' + row_count +'" id="total_cost_price_2' + row_count +'" value="'+commaSplit(filterNum(cost_price_2,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
		</cfif>
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="____labor_cost2_' + row_count +'" id="____labor_cost2_' + row_count +'" value="" style="width:90px;">';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="____station_reflection_cost_system2_' + row_count +'" id="____station_reflection_cost_system2_' + row_count +'" value="" style="width:90px;">';
		</cfif>
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_2' + row_count +'" id="money_2' + row_count +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';	
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount2_' + row_count +'" id="amount2_' + row_count +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;">';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<select name="unit2'+row_count+'" id="unit2'+row_count+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<input type="text" style="width:70px;" name="product_name2' + row_count +'" id="product_name2' + row_count +'" value="">';
		//2.birim ekleme bitti.
	}
	satir_sarf = document.getElementById("table2").rows.length;
	function add_row_exit(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
	{
		row_count_exit++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2_body").insertRow(document.getElementById("table2_body").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_exit);
		newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
		newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
		document.getElementById("record_num_exit").value = row_count_exit;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="is_production_spect_exit' + row_count_exit +'" id="is_production_spect_exit' + row_count_exit +'" value="'+ is_production +'"><input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="tree_type_exit_' + row_count_exit +'" id="tree_type_exit_' + row_count_exit +'" value="S"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1"><a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> <a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img  src="images/delete_list.gif" border="0" align="absbottom" alt="Sil"></a><input type="hidden" name="cost_id_exit' + row_count_exit +'" id="cost_id_exit' + row_count_exit +'" value="'+cost_id+'"><input type="hidden" name="product_cost_exit' + row_count_exit +'" id="product_cost_exit' + row_count_exit +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_exit' + row_count_exit +'" id="product_cost_money_exit' + row_count_exit +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_exit' + row_count_exit +'" id="cost_price_system_exit' + row_count_exit +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_exit' + row_count_exit +'" id="money_system_exit' + row_count_exit +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_exit' + row_count_exit +'" id="purchase_extra_cost_system_exit' + row_count_exit +'" value="'+purchase_extra_cost_system+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_exit' + row_count_exit +'" id="kdv_amount_exit' + row_count_exit +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="barcode_exit' + row_count_exit +'" id="barcode_exit' + row_count_exit +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'" value="'+product_id+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+stock_id+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'"  value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+spect_name+'" readonly style="width:160px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="" onKeyup="lotno_control('+ row_count_exit +',2);" style="width:75px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_list_product('+ row_count_exit +',2);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count_exit +',0);" class="moneybox" style="width:70px;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+commaSplit(filterNum(amount,6),6)+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+product_unit_id+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_exit' + row_count_exit +'" id="serial_no_exit' + row_count_exit +'" value="'+serial+'">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention_exit' + row_count_exit +'" id="dimention_exit' + row_count_exit +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price_exit' + row_count_exit +'" id="cost_price_exit' + row_count_exit +'" value="'+cost_price+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif>>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="purchase_extra_cost_exit' + row_count_exit +'" id="purchase_extra_cost_exit' + row_count_exit +'" value="'+purchase_extra_cost+'"  onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> class="moneybox">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price_exit' + row_count_exit +'" id="total_cost_price_exit' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money_exit' + row_count_exit +'" id="money_exit' + row_count_exit +'" value="'+cost_price_money+'" readonly style="width:50px;">';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_exit_2' + row_count_exit +'" id="cost_price_exit_2' + row_count_exit +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="purchase_extra_cost_exit_2' + row_count_exit +'" id="purchase_extra_cost_exit_2' + row_count_exit +'" value="'+purchase_extra_cost_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_exit_2' + row_count_exit +'" id="total_cost_price_exit_2' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" class="moneybox" readonly>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_exit_2' + row_count_exit +'" id="money_exit_2' + row_count_exit +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_exit2_' + row_count_exit +'" id="amount_exit2_' + row_count_exit +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;">';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<select name="unit2_exit'+row_count_exit+'" id="unit2_exit'+row_count_exit+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<input type="text" style="width:70px;" name="product_name2_exit' + row_count_exit +'" id="product_name2_exit' + row_count_exit +'" value="">';
		<cfif isdefined("x_is_show_sb") and x_is_show_sb>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_sevkiyat' + row_count_exit +'" id="is_sevkiyat' + row_count_exit +'" value="1">';
		</cfif>
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_exit' + row_count_exit +'" id="is_manual_cost_exit' + row_count_exit +'" value="1">';
		</cfif>
	}
	
	function add_row_outage(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)

	{
		row_count_outage++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table3_body").insertRow(document.getElementById("table3_body").rows.length);
		newRow.setAttribute("name","frm_row_outage" + row_count_outage);
		newRow.setAttribute("id","frm_row_outage" + row_count_outage);
		newRow.setAttribute("NAME","frm_row_outage" + row_count_outage);
		newRow.setAttribute("ID","frm_row_outage" + row_count_outage);
		document.getElementById("record_num_outage").value = row_count_outage;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML  ='<input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1">';
		newCell.innerHTML +='<a style="cursor:pointer" onclick="copy_row_outage('+row_count_outage+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img src="images/copy_list.gif" border="0"></a> ';
		newCell.innerHTML +='<a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absbottom" alt="<cf_get_lang_main no="51.Sil">"></a>';
		newCell.innerHTML +='<input type="hidden" name="cost_id_outage' + row_count_outage +'" id="cost_id_outage' + row_count_outage +'" value="'+cost_id+'">';
		newCell.innerHTML +='<input type="hidden" name="product_cost_outage' + row_count_outage +'" id="product_cost_outage' + row_count_outage +'" value="'+product_cost+'">';
		newCell.innerHTML +='<input type="hidden" name="product_cost_money_outage' + row_count_outage +'" id="product_cost_money_outage' + row_count_outage +'" value="'+product_cost_money+'">';
		newCell.innerHTML +='<input type="hidden" name="cost_price_system_outage' + row_count_outage +'" id="cost_price_system_outage' + row_count_outage +'" value="'+cost_price_system+'">';
		newCell.innerHTML +='<input type="hidden" name="money_system_outage' + row_count_outage +'" id="money_system_outage' + row_count_outage +'" value="'+cost_price_system_money+'">';
		newCell.innerHTML +='<input type="hidden" name="purchase_extra_cost_system_outage' + row_count_outage +'" id="purchase_extra_cost_system_outage' + row_count_outage +'" value="'+purchase_extra_cost_system+'">';'';
		
		newCell.setAttribute('nowrap','nowrap');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_outage' + row_count_outage +'" id="kdv_amount_outage' + row_count_outage +'" value="'+tax+'">';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="barcode_outage' + row_count_outage +'" id="barcode_outage' + row_count_outage +'" value="'+barcode+'" readonly style="width:90px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="'+product_id+'"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'" value="'+stock_id+'"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="'+ product_name + property +'" readonly style="width:230px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_outage' + row_count_outage +'" id="spect_id_outage' + row_count_outage +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+spect_name+'" readonly style="width:150px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_spect('+ row_count_outage +',3);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="" onKeyup="lotno_control('+ row_count_outage +',3);" style="width:75px;"> <img src="/images/plus_thin.gif" onClick="pencere_ac_list_product('+ row_count_outage +',3);" align="absbottom" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count_outage +',2);" class="moneybox" style="width:70px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="'+product_unit_id+'" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_outage' + row_count_outage +'" id="serial_no_outage' + row_count_outage +'" value="'+serial+'">';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="dimention_outage' + row_count_outage +'" id="dimention_outage' + row_count_outage +'" value="'+dimention+'" readonly style="width:60px;">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="cost_price_outage' + row_count_outage +'" id="cost_price_outage' + row_count_outage +'" value="'+cost_price+'" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="purchase_extra_cost_outage' + row_count_outage +'" id="purchase_extra_cost_outage' + row_count_outage +'" value="'+purchase_extra_cost+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> class="moneybox">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="total_cost_price_outage' + row_count_outage +'" id="total_cost_price_outage' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="money_outage' + row_count_outage +'" id="money_outage' + row_count_outage +'" value="'+cost_price_money+'" readonly style="width:50px;">';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="cost_price_outage_2' + row_count_outage +'" id="cost_price_outage_2' + row_count_outage +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="purchase_extra_cost_outage_2' + row_count_outage +'" id="purchase_extra_cost_outage_2' + row_count_outage +'" value="'+purchase_extra_cost_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox">';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="total_cost_price_outage_2' + row_count_outage +'" id="total_cost_price_outage_2' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money_outage_2' + row_count_outage +'" id="money_outage_2' + row_count_outage +'" value="'+cost_price_money_2+'" readonly style="width:50px;">';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="amount_outage2_' + row_count_outage +'" id="amount_outage2_' + row_count_outage +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;">';
			//2.birim ekleme
			var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
			var unit2_values ='<select name="unit2_outage'+row_count_outage+'" id="unit2_outage'+row_count_outage+'" style="width:60;">';
			if(get_Unit2_Prod.recordcount){
			for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
				unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
			}
			unit2_values +='</select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = ''+unit2_values+'';
		</cfif>
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" style="width:50px;" name="product_name2_outage' + row_count_outage +'" id="product_name2_outage' + row_count_outage +'" value="'+cost_price_money_2+'">';
		//2.birim ekleme bitti.
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_outage' + row_count_outage +'" id="is_manual_cost_outage' + row_count_outage +'" value="1">';
		</cfif>
		
	}
	function copy_row_exit(no_info)
	{
		if (document.getElementById("is_production_spect_exit" + no_info) == undefined) is_production_spect_exit =""; else is_production_spect_exit = document.getElementById("is_production_spect_exit" + no_info).value;
		if (document.getElementById("is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = document.getElementById("is_add_info_" + no_info).value;
		if (document.getElementById("product_cost_money_exit" + no_info) == undefined) product_cost_money_exit =""; else product_cost_money_exit = document.getElementById("product_cost_money_exit" + no_info).value;
		if (document.getElementById("stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = document.getElementById("stock_code_exit" + no_info).value;
		if (document.getElementById("barcode_exit" + no_info) == undefined) barcode_exit =""; else barcode_exit = document.getElementById("barcode_exit" + no_info).value;
		if (document.getElementById("product_id_exit" + no_info) == undefined) product_id_exit =""; else product_id_exit = document.getElementById("product_id_exit" + no_info).value;
		if (document.getElementById("spec_main_id_exit" + no_info) == undefined) spec_main_id_exit =""; else spec_main_id_exit = document.getElementById("spec_main_id_exit" + no_info).value;
		if (document.getElementById("lot_no_exit" + no_info) == undefined) lot_no_exit =""; else lot_no_exit = document.getElementById("lot_no_exit" + no_info).value;
		if (document.getElementById("amount_exit" + no_info) == undefined) amount_exit =""; else amount_exit = document.getElementById("amount_exit" + no_info).value;
		if (document.getElementById("unit_id_exit" + no_info) == undefined) unit_id_exit =""; else unit_id_exit = document.getElementById("unit_id_exit" + no_info).value;
		if (document.getElementById("dimention_exit" + no_info) == undefined) dimention_exit =""; else dimention_exit = document.getElementById("dimention_exit" + no_info).value;
		if (document.getElementById("cost_price_exit" + no_info) == undefined) cost_price_exit =""; else cost_price_exit = document.getElementById("cost_price_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_exit" + no_info) == undefined) purchase_extra_cost_exit =""; else purchase_extra_cost_exit = document.getElementById("purchase_extra_cost_exit" + no_info).value;
		if (document.getElementById("total_cost_price_exit" + no_info) == undefined) total_cost_price_exit =""; else total_cost_price_exit = document.getElementById("total_cost_price_exit" + no_info).value;
		if (document.getElementById("money_exit" + no_info) == undefined) money_exit =""; else money_exit = document.getElementById("money_exit" + no_info).value;
		if (document.getElementById("cost_price_exit_2" + no_info) == undefined) cost_price_exit_2 =""; else cost_price_exit_2 = document.getElementById("cost_price_exit_2" + no_info).value;
		if (document.getElementById("total_cost_price_exit_2" + no_info) == undefined) total_cost_price_exit_2 =""; else total_cost_price_exit_2 = document.getElementById("total_cost_price_exit_2" + no_info).value;
		if (document.getElementById("money_exit_2" + no_info) == undefined) money_exit_2 =""; else money_exit_2 = document.getElementById("money_exit_2" + no_info).value;
		if (document.getElementById("amount_exit2_" + no_info) == undefined)  amount_exit2_ =""; else  amount_exit2_ = document.getElementById("amount_exit2_" + no_info).value;
		if (document.getElementById("product_name2_exit" + no_info) == undefined)  product_name2_exit =""; else  product_name2_exit = document.getElementById("product_name2_exit" + no_info).value;
		if (document.getElementById("is_sevkiyat" + no_info) == undefined) is_sevkiyat =""; else is_sevkiyat = document.getElementById("is_sevkiyat" + no_info).value;
		if (document.getElementById("is_manual_cost_exit" + no_info) == undefined) is_manual_cost_exit =""; else is_manual_cost_exit = document.getElementById("is_manual_cost_exit" + no_info).value;
		if (document.getElementById("tree_type_exit_" + no_info) == undefined) tree_type_exit_ =""; else tree_type_exit_ = document.getElementById("tree_type_exit_" + no_info).value;
		if (document.getElementById("row_kontrol_exit" + no_info) == undefined) row_kontrol_exit =""; else row_kontrol_exit = document.getElementById("row_kontrol_exit" + no_info).value;
		if (document.getElementById("cost_id_exit" + no_info) == undefined) cost_id_exit =""; else cost_id_exit = document.getElementById("cost_id_exit" + no_info).value;
		if (document.getElementById("product_cost_exit" + no_info) == undefined) product_cost_exit =""; else product_cost_exit = document.getElementById("product_cost_exit" + no_info).value;
		if (document.getElementById("cost_price_system_exit" + no_info) == undefined) cost_price_system_exit =""; else cost_price_system_exit = document.getElementById("cost_price_system_exit" + no_info).value;
		if (document.getElementById("money_system_exit" + no_info) == undefined) money_system_exit =""; else money_system_exit = document.getElementById("money_system_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_system_exit" + no_info) == undefined) purchase_extra_cost_system_exit =""; else purchase_extra_cost_system_exit = document.getElementById("purchase_extra_cost_system_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_exit_2" + no_info) == undefined) purchase_extra_cost_exit_2 =""; else purchase_extra_cost_exit_2 = document.getElementById("purchase_extra_cost_exit_2" + no_info).value;
		if (document.getElementById("amount_exit_" + no_info) == undefined) amount_exit_ =""; else amount_exit_ = document.getElementById("amount_exit_" + no_info).value;
		if (document.getElementById("kdv_amount_exit" + no_info) == undefined) kdv_amount_exit =""; else kdv_amount_exit = document.getElementById("kdv_amount_exit" + no_info).value;
		if (document.getElementById("stock_id_exit" + no_info) == undefined) stock_id_exit =""; else stock_id_exit = document.getElementById("stock_id_exit" + no_info).value;
		if (document.getElementById("product_name_exit" + no_info) == undefined) product_name_exit =""; else product_name_exit = document.getElementById("product_name_exit" + no_info).value;
		if (document.getElementById("spect_id_exit" + no_info) == undefined) spect_id_exit =""; else spect_id_exit = document.getElementById("spect_id_exit" + no_info).value;
		if (document.getElementById("spect_name_exit" + no_info) == undefined) spect_name_exit =""; else spect_name_exit = document.getElementById("spect_name_exit" + no_info).value;
		if (document.getElementById("unit_exit" + no_info) == undefined) unit_exit =""; else unit_exit = document.getElementById("unit_exit" + no_info).value;
		if (document.getElementById("serial_no_exit" + no_info) == undefined) serial_no_exit =""; else serial_no_exit = document.getElementById("serial_no_exit" + no_info).value;
		add_row_exit(stock_id_exit,product_id_exit,stock_code_exit,product_name_exit,'',barcode_exit,unit_exit,unit_id_exit,amount_exit,kdv_amount_exit,cost_id_exit,cost_price_exit,money_exit,cost_price_exit_2,purchase_extra_cost_exit_2,money_exit_2,cost_price_system_exit,money_system_exit,purchase_extra_cost_exit,purchase_extra_cost_system_exit,product_cost_exit,product_cost_money_exit,serial_no_exit,is_production_spect_exit,dimention_exit,spec_main_id_exit,spect_name_exit);
 	}
	function copy_row_outage(no_info)
	{
		if (document.getElementById("money_system_outage" + no_info) == undefined) money_system_outage =""; else money_system_outage = document.getElementById("money_system_outage" + no_info).value;
		if (document.getElementById("stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = document.getElementById("stock_code_outage" + no_info).value;
		if (document.getElementById("barcode_outage" + no_info) == undefined) barcode_outage =""; else barcode_outage = document.getElementById("barcode_outage" + no_info).value;
		if (document.getElementById("product_id_outage" + no_info) == undefined) product_id_outage =""; else product_id_outage = document.getElementById("product_id_outage" + no_info).value;
		if (document.getElementById("lot_no_outage" + no_info) == undefined) lot_no_outage =""; else lot_no_outage = document.getElementById("lot_no_outage" + no_info).value;
		if (document.getElementById("amount_outage" + no_info) == undefined) amount_outage =""; else amount_outage = document.getElementById("amount_outage" + no_info).value;
		if (document.getElementById("unit_id_outage" + no_info) == undefined) unit_id_outage =""; else unit_id_outage = document.getElementById("unit_id_outage" + no_info).value;
		if (document.getElementById("dimention_outage" + no_info) == undefined) dimention_outage =""; else dimention_outage = document.getElementById("dimention_outage" + no_info).value;
		if (document.getElementById("cost_price_outage" + no_info) == undefined) cost_price_outage =""; else cost_price_outage = document.getElementById("cost_price_outage" + no_info).value;
		if (document.getElementById("purchase_extra_cost_outage" + no_info) == undefined) purchase_extra_cost_outage =""; else purchase_extra_cost_outage = document.getElementById("purchase_extra_cost_outage" + no_info).value;
		if (document.getElementById("total_cost_price_outage" + no_info) == undefined) total_cost_price_outage =""; else total_cost_price_outage = document.getElementById("total_cost_price_outage" + no_info).value;
		if (document.getElementById("money_outage" + no_info) == undefined) money_outage =""; else money_outage = document.getElementById("money_outage" + no_info).value;
		if (document.getElementById("cost_price_outage_2" + no_info) == undefined) cost_price_outage_2 =""; else cost_price_outage_2 = document.getElementById("cost_price_outage_2" + no_info).value;
		if (document.getElementById("purchase_extra_cost_outage_2" + no_info) == undefined) purchase_extra_cost_outage_2 =""; else purchase_extra_cost_outage_2 = document.getElementById("purchase_extra_cost_outage_2" + no_info).value;
		if (document.getElementById("total_cost_price_outage_2" + no_info) == undefined) total_cost_price_outage_2 =""; else total_cost_price_outage_2 = document.getElementById("total_cost_price_outage_2" + no_info).value;
		if (document.getElementById("money_outage_2" + no_info) == undefined) money_outage_2 =""; else money_outage_2 = document.getElementById("money_outage_2" + no_info).value;
	    if (document.getElementById("amount_outage2_" + no_info) == undefined) amount_outage2_ =""; else amount_outage2_ = document.getElementById("amount_outage2_" + no_info).value;
		if (document.getElementById("product_name2_outage" + no_info) == undefined) product_name2_outage =""; else product_name2_outage = document.getElementById("product_name2_outage" + no_info).value;
		if (document.getElementById("unit_outage" + no_info) == undefined) unit_outage =""; else unit_outage = document.getElementById("unit_outage" + no_info).value;
		if (document.getElementById("cost_id_outage" + no_info) == undefined) cost_id_outage =""; else cost_id_outage = document.getElementById("cost_id_outage" + no_info).value;
		if (document.getElementById("product_cost_outage" + no_info) == undefined) product_cost_outage =""; else product_cost_outage = document.getElementById("product_cost_outage" + no_info).value;
		if (document.getElementById("product_cost_money_outage" + no_info) == undefined) product_cost_money_outage =""; else product_cost_money_outage = document.getElementById("product_cost_money_outage" + no_info).value;
		if (document.getElementById("cost_price_system_outage" + no_info) == undefined) cost_price_system_outage =""; else cost_price_system_outage = document.getElementById("cost_price_system_outage" + no_info).value;
		if (document.getElementById("purchase_extra_cost_system_outage" + no_info) == undefined) purchase_extra_cost_system_outage =""; else purchase_extra_cost_system_outage = document.getElementById("purchase_extra_cost_system_outage" + no_info).value;
		if (document.getElementById("kdv_amount_outage" + no_info) == undefined) kdv_amount_outage =""; else kdv_amount_outage = document.getElementById("kdv_amount_outage" + no_info).value;
		if (document.getElementById("stock_id_outage" + no_info) == undefined) stock_id_outage =""; else stock_id_outage = document.getElementById("stock_id_outage" + no_info).value;
		if (document.getElementById("product_name_outage" + no_info) == undefined) product_name_outage =""; else product_name_outage = document.getElementById("product_name_outage" + no_info).value;
		if (document.getElementById("spect_id_outage" + no_info) == undefined) spect_id_outage =""; else spect_id_outage = document.getElementById("spect_id_outage" + no_info).value;
		if (document.getElementById("spect_name_outage" + no_info) == undefined) spect_name_outage =""; else spect_name_outage = document.getElementById("spect_name_outage" + no_info).value;
		if (document.getElementById("serial_no_outage" + no_info) == undefined) serial_no_outage =""; else serial_no_outage = document.getElementById("serial_no_outage" + no_info).value;
		if (document.getElementById("is_manual_cost_outage" + no_info) == undefined) is_manual_cost_outage =""; else is_manual_cost_outage = document.getElementById("is_manual_cost_outage" + no_info).value;
		 add_row_outage(stock_id_outage,product_id_outage,stock_code_outage,product_name_outage,'',barcode_outage,unit_outage,unit_id_outage,amount_outage,kdv_amount_outage,cost_id_outage,cost_price_outage,money_outage,cost_price_outage_2,purchase_extra_cost_outage_2,money_outage_2,cost_price_system_outage,money_system_outage,purchase_extra_cost_outage,purchase_extra_cost_system_outage,product_cost_outage,product_cost_money_outage,serial_no_outage,'',dimention_outage,spect_id_outage,spect_name_outage);
 	}
	function pencere_ac_alternative(type,no,pid,sid)//ürünlerin alternatiflerini açıyor
	{
		if(type == 1)
		{
		form_stock = document.getElementById("stock_id_exit"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
			<cfif is_add_alternative_product eq 0>
				//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
				url_str='&tree_info_null_=1&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_exit'+no+'</cfif>&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&tree_stock_id='+sid+'&is_form_submitted=1&is_only_alternative=1';
			<cfelse>
				sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ sid +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
				my_query = wrk_query(sqlstr,'dsn3');
				if(my_query.recordcount)
				sid = my_query.STOCK_ID;
				url_str='&tree_stock_id='+sid+'&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_exit'+no+'</cfif>&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
			</cfif>
		//console.log(url_str);
		}
		else
		{
		form_stock = document.getElementById("stock_id_outage"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
		<cfif is_add_alternative_product eq 0>
				//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
				url_str='&tree_info_null_=1&form_basket.is_production_spect_outage'+no+'&field_tax_purchase=form_basket.kdv_amount_outage'+no+'&product_id=form_basket.product_id_outage'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_outage'+no+'</cfif>&field_id=form_basket.stock_id_outage'+no+'&field_unit_name=form_basket.unit_outage'+no+'&field_code=form_basket.stock_code_outage'+no+'&field_name=form_basket.product_name_outage' + no + '&field_unit=form_basket.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&tree_stock_id='+sid+'&is_form_submitted=1&is_only_alternative=1';
			<cfelse>
				sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ sid +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
				my_query = wrk_query(sqlstr,'dsn3');
				if(my_query.recordcount)
				sid = my_query.STOCK_ID;
				url_str='&tree_stock_id='+sid+'&form_basket.is_production_spect_outage'+no+'&field_tax_purchase=form_basket.kdv_amount_outage'+no+'&product_id=form_basket.product_id_outage'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_outage'+no+'</cfif>&field_id=form_basket.stock_id_outage'+no+'&field_unit_name=form_basket.unit_outage'+no+'&field_code=form_basket.stock_code_outage'+no+'&field_name=form_basket.product_name_outage' + no + '&field_unit=form_basket.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
			</cfif>
		
			}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
	{
		if(type == 2)
		{//sarf ise type 2
			form_stock_code = document.getElementById("stock_code_exit"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
		else if(type == 3)
		{//fire ise type 3
			form_stock_code = document.getElementById("stock_code_outage"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=form_basket.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
	}
	function alternative_product_cost(pid,no)
		{
			var new_sql = "SELECT TOP 1 PRODUCT_COST_ID,PURCHASE_NET,PURCHASE_NET_MONEY,PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST,PURCHASE_EXTRA_COST_SYSTEM,PRODUCT_COST,MONEY FROM PRODUCT_COST WHERE PRODUCT_ID = "+pid+" AND START_DATE <= <cfoutput>#createodbcdate(GET_DETAIL.finish_date)#</cfoutput> ORDER BY START_DATE DESC,RECORD_DATE DESC";	
			var listParam = pid + "*" + "<cfoutput>#createodbcdate(GET_DETAIL.finish_date)#</cfoutput>";
			var GET_PRODUCT_COST = wrk_safe_query("prdp_GET_PRODUCT_COST",'dsn3',0,listParam);
			if(!GET_PRODUCT_COST.recordcount)
			{
					cost_id = 0;
					purchase_extra_cost = 0;
					product_cost = 0;
					product_cost_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price = 0;
					cost_price_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price_system = 0;
					cost_price_system_money = '<cfoutput>#session.ep.money#</cfoutput>';
					purchase_extra_cost_system = 0;
			}
			else
			{
				cost_id = GET_PRODUCT_COST.PRODUCT_COST_ID;
				purchase_extra_cost = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
				product_cost = GET_PRODUCT_COST.PRODUCT_COST;
				product_cost_money = GET_PRODUCT_COST.MONEY;
				cost_price = GET_PRODUCT_COST.PURCHASE_NET;
				cost_price_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
				cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
				cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
				purchase_extra_cost_system = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
			}
			//Ürünün maliyet değerleri
			document.getElementById("purchase_extra_cost_exit"+no).value = purchase_extra_cost;
			document.getElementById("cost_price_exit"+no).value = commaSplit(cost_price,round_number);
			document.getElementById("money_exit"+no).value = cost_price_money;
			document.getElementById("cost_price_system_exit"+no).value =  cost_price_system;
			document.getElementById("money_system_exit"+no).value = cost_price_system_money;
			document.getElementById("purchase_extra_cost_system_exit"+no).value =  purchase_extra_cost_system;
			//ürün değiştiği için spectler sıfırlanıyor
			document.getElementById("spect_id_exit_"+no).value = "";
			document.getElementById("spect_id_exit"+no).value = "";
			document.getElementById("spect_name_exit"+no).value = "";
	
		}
	function pencere_ac_spect(no,type)
	{
		_department_id_="";
		var exit_department_id_ = document.getElementById('exit_department_id').value;
		var exit_location_id_ = document.getElementById('exit_location_id').value;
		if(exit_department_id_ != "")
		_department_id_ = exit_department_id_;
		if(exit_department_id_ != "" && exit_location_id_!= "")
		_department_id_ +='-'+exit_location_id_;
	
		if(type==4 && document.getElementById("spect_id"+no).value != "")//Type'nin 4 olması açılacak olan sayfanın GÜNCELLEME sayfası olduğunu gösteriyor.
		{
			if(document.getElementById("stock_id"+no) == undefined || document.getElementById("stock_id"+no) == "")
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'>");
			else
			 url_str='&id='+document.getElementById("spect_id"+no).value;
			 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_spec&is_spec=1' + url_str,'list');<!--- objects.popup_list_spect_main --->
		}
		else
		{	
		<cfif (not get_fis.recordcount or not get_fis_sarf.recordcount)>//stok fişi oluşturulmamış ise
			if(type==2)
			{	
				form_stock = document.getElementById("stock_id_exit"+no);
				<cfif GET_DETAIL.IS_DEMONTAJ eq 1>
					url_str='&field_var_id=form_basket.spect_id_exit'+no+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&is_demontaj=1&p_order_id=<cfoutput>#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				<cfelse>
					url_str='&field_var_id=form_basket.spect_id_exit'+no+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value+'&last_spect=1&create_main_spect_and_add_new_spect_id=1';
				</cfif>
				
			}
			else if(type==3)
			{
				form_stock = document.getElementById("stock_id_outage"+no);
				if(<cfoutput>#GET_DETAIL.is_demontaj#</cfoutput> == 1)
				url_str='&field_var_id=form_basket.spect_id_outage'+no+'&field_main_id=form_basket.spec_main_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&party_id=<cfoutput>#attributes.party_id#</cfoutput>';
				else
				url_str='&field_var_id=form_basket.spect_id_outage'+no+'&field_main_id=form_basket.spec_main_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1';

				//url_str='&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value+'&last_spect=1';
			
			}
			else
			{
				form_stock = document.getElementById("stock_id"+no);
				<cfif GET_DETAIL.IS_DEMONTAJ eq 1>
					url_str='&field_var_id=form_basket.spect_id'+no+'&field_main_id=form_basket.spec_main_id'+no+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value +'&create_main_spect_and_add_new_spect_id=1&last_spect=1&<cfoutput>p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				<cfelse>
					url_str='&field_var_id=form_basket.spect_id'+no+'&field_main_id=form_basket.spec_main_id'+no+'&p_order_row_id='+document.getElementById('order_row_id').value+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&<cfoutput>party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				</cfif>
			}
			if(form_stock.value == "")
				alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'>");
			else
				 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
		<cfelse>
			alert("<cf_get_lang no ='570.Stok Fişi Oluşturulduğu için spectlerde herhangi bi değişiklik yapamazsınız'>");
		</cfif>
		}
	}
	
	function pencere_ac_serial_no(no)
	{
		form_serial_no_exit = document.getElementById("serial_no_exit"+no);
		if(form_serial_no_exit.value == "")
			alert("<cf_get_lang no='462.Lütfen Seri No Giriniz'> !");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&product_serial_no=' + form_serial_no_exit.value,'list');	
	}
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ],  `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 2)
			lot_no = document.getElementById('lot_no_exit'+crntrow);
		else if(type ==3)
			lot_no = document.getElementById('lot_no_outage'+crntrow);
		else
			lot_no = document.getElementById('lot_no');
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
	
	function hesapla_deger(value,id)
	{
		if(id==0)
		{
			var value_amount_exit = document.getElementById("amount_exit"+value);
			if((value_amount_exit.value == "") || (value_amount_exit.value == 0))
			{
				value_amount_exit.value = 1;
			}
		}
		else if(id==1)
		{
			var value_amount = document.getElementById("amount"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 1;
			}
		}else if(id==2)
		{
			var value_amount = document.getElementById("amount_outage"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 1;
			}
		}
		else if(id==3)
		{
			var value_amount = document.getElementById("fire_amount_"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 0;
			}
		}
	}
	function kontrol()
	{
		//if( document.getElementById('is_delstock') && document.getElementById('is_delstock').checked == true || document.getElementById('is_delstock') == undefined){//Üretime sonuç girilmiş ise güncelleme yapılamasın üretim emrinde.
		    var round_number = document.getElementById('round_number').value;
			if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
			if(!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if (!process_cat_control()) return false;
			if(document.getElementById("production_result_no").value != '')
			{
				var listParam = document.getElementById("production_result_no").value + "*" + "<cfoutput>#attributes.pr_order_id#</cfoutput>";
				var doc_no_control = wrk_safe_query("prdp_doc_no_control","dsn3",0,listParam);
				if(doc_no_control.recordcount > 0)
				{
					alert("<cf_get_lang_main no='710.Girdiğiniz Belge No Kullanılıyor'>!");
					return false;
				}
			}
			if(document.getElementById("station_id").value == "" || document.getElementById("station_name").value == "")
			{
				alert("<cf_get_lang_main no='1425.Lütfen İstasyon Seçiniz'> !");
				return false;
			}
			tarih1_ = form_basket.start_date.value.substr(6,6) + form_basket.start_date.value.substr(3,2) + form_basket.start_date.value.substr(0,2);
			tarih2_ = form_basket.finish_date.value.substr(6,6) + form_basket.finish_date.value.substr(3,2) + form_basket.finish_date.value.substr(0,2);
		
			if (form_basket.start_h.value.length < 2) saat1_ = '0' + form_basket.start_h.value; else saat1_ = form_basket.start_h.value;
			if (form_basket.start_m.value.length < 2) dakika1_ = '0' + form_basket.start_m.value; else dakika1_ = form_basket.start_m.value;
			if (form_basket.finish_h.value.length < 2) saat2_ = '0' + form_basket.finish_h.value; else saat2_ = form_basket.finish_h.value;
			if (form_basket.finish_m.value.length < 2) dakika2_ = '0' + form_basket.finish_m.value; else dakika2_ = form_basket.finish_m.value;
		
			tarih1_ = tarih1_ + saat1_ + dakika1_;
			tarih2_ = tarih2_ + saat2_ + dakika2_;	
			
			if (tarih1_ >= tarih2_) 
			{
				alert("<cf_get_lang no='463.Başlangıç Tarihi Bitiş Tarihinden Büyük'> !");
				return false;
			}
			var row_count_ = 0;
			for (var r=1;r<=row_count;r++)
			{
				if(document.getElementById("row_kontrol"+r).value==1)//En az bir ana ürün satırı olması için kontrol eklendi.
				{
					row_count_ = row_count_ + 1;
					if(filterNum(document.getElementById("amount"+r).value,round_number) <= 0)
					{
						alert("Ürün Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
						return false;
					}
				}
			}
			if(row_count_ == 0)
			{
				alert("Lütfen Ana Ürün Seçiniz!");
				return false;
			}
			var row_count_exit_ = 0;
			for (var k=1;k<=row_count_exit;k++)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)//En az bir sarf ürün satırı olması için kontrol eklendi.
				{
					row_count_exit_ = row_count_exit_ + 1;
					if(filterNum(document.getElementById("amount_exit_"+k).value,round_number) <= 0)
					{
						alert("Sarf Miktarı 0 Olamaz , Lütfen Miktarları Kontrol Ediniz !");
						return false;
					}
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_exit"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_exit"+k).value == '')
								{
									alert(row_count_exit_+'. sarf satırındaki '+ document.getElementById("product_name_exit"+k).value + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			if(row_count_exit_ == 0)
			{
				alert("Lütfen Sarf Ürünü Seçiniz!");
				return false;
			}	
			for (var k=1;k<=row_count_exit;k++)//eğer sarfların içinde üretilen bir ürün varsa onun için spect seçilmesini zorunlu kılıyor.Onun kontrolü
			{	
				if((document.getElementById("is_delstock") == undefined) || (document.getElementById("is_delstock") != undefined && document.getElementById("is_delstock").checked == false))//Stok Fişleri Silinsin tanımlı değilse yada tanımlı ancak seçili değilse,eğer seçili ise kontrole sokmuyoruz ve direkt olarak siliyoruz.
				{	
					if((document.getElementById("spec_main_id_exit"+k).value == "" || document.getElementById("spect_name_exit"+k).value == "") && (document.getElementById("is_production_spect_exit"+k)!= undefined && document.getElementById("is_production_spect_exit"+k).value == 1) && document.getElementById("row_kontrol_exit"+k).value==1)//spect id ve spect name varsa vede ürtilen bir ürünse//vede 
					{
						//alert("<cf_get_lang no ="571.Üretilen Ürünler İçin Spec Seçmeniz Gerekmektedir">.(' + eval("document.form_basket.product_name_exit"+k).value + ')");
						alert('<cf_get_lang no ="571.Üretilen Ürünler İçin Spec Seçmeniz Gerekmektedir">.(' + document.getElementById("product_name_exit"+k).value + ')');
						return false;
					}
				}
			}
			row_count_outage_ = 0;
			for (var k=1;k<=row_count_outage;k++)
			{
				if(document.getElementById("row_kontrol_outage"+k).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					row_count_outage_ = row_count_outage_ + 1;
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_outage"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_outage"+k).value == '')
								{
									alert(row_count_outage_+'. fire satırındaki '+ document.getElementById("product_name_outage"+k).value + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			<cfif get_fis.recordcount or get_fis_sarf.recordcount>
				<cfif isdefined("x_update_result") and x_update_result eq 1>
					if(document.getElementById("is_delstock").checked == false)
					{
						alert("Stok Fişleri Silinsin Seçeneğini Seçmeden Güncelleme Yapamazsınız !");
						return false;
					}
				</cfif>
				if(document.getElementById("is_delstock").checked == true)
				{
					if(! confirm("<cf_get_lang no='470.Fişleri Siliyorsunuz'>. <cf_get_lang no ='572.Yaptığınız Değişiklikler Stok ve İrsaliye Fişlerinin Silinmesine Neden Olacak Kayda Devam Etmek İstediğinizden Emin misiniz'> ! ")) return false;
				}
				for (var r=1;r<=row_count;r++)
				{
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
					if(document.getElementById("amount2_"+r))
						document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
					document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
					document.getElementById("purchase_extra_cost"+r).value = filterNum(document.getElementById("purchase_extra_cost"+r).value,round_number);
					document.getElementById("purchase_extra_cost_system"+r).value = filterNum(document.getElementById("purchase_extra_cost_system"+r).value,round_number);
					if(document.getElementById("cost_price_2"+r) != undefined)
						document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
					if(document.getElementById("cost_price_extra_2"+r) != undefined)
						document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
					<cfif x_is_fire_product eq 1>
						document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
					</cfif>
				}
				for (var k=1;k<=row_count_exit;k++)
				{
					document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
					if(document.getElementById("amount_exit2_"+k))
						document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
					document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
	
					document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
					//document.getElementById("purchase_extra_cost_system_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_exit"+k).value,8);
					if(document.getElementById("cost_price_exit_2"+k) != undefined)
						document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
				}
				for (var k=1;k<=row_count_outage;k++)
				{
					document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
					if(document.getElementById("amount_outage2_"+k))
						document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
					document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
					if(document.getElementById("cost_price_outage_2"+k) != undefined)
						document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
					document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
					//document.getElementById("purchase_extra_cost_system_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_outage"+k).value,8);
				}			
			<cfelse>
				for (var r=1;r<=row_count;r++)
				{
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
					if(document.getElementById("amount2_"+r))
						document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
					document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
					document.getElementById("purchase_extra_cost"+r).value = filterNum(document.getElementById("purchase_extra_cost"+r).value,round_number);
					if(document.getElementById("cost_price_2"+r) != undefined)
						document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
					if(document.getElementById("cost_price_extra_2"+r) != undefined)
						document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
					<cfif x_is_fire_product eq 1>
						document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
					</cfif>
				}
				for (var k=1;k<=row_count_exit;k++)
				{
					document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
					if(document.getElementById("amount_exit2_"+k))
						document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
					document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
	
					document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
					if(document.getElementById("cost_price_exit_2"+k) != undefined)
						document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
				}
				for (var k=1;k<=row_count_outage;k++)
				{
					document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
					if(document.getElementById("amount_outage2_"+k))
						document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
					document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
					if(document.getElementById("cost_price_outage_2"+k) != undefined)
						document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
					document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
				}			
			</cfif>
			return true;
		/*}
		else
			alert('Sonuç Girilmiş Üretim Emri Güncellenemez!');
			return false;*/
	}
	<!--- todo --->
	function zero_stock_control()
	{
		var hata = '';
		var lotno_hata = '';
		var stock_list = 0;
		var stock_type = 0;
		var is_update = 0;
		var round_number = document.getElementById('round_number').value;
		var stock_id_list='0';
		var stock_amount_list='0';
		var spec_id_list='0';
		var spec_amount_list='0';
		var main_spec_id_list='0';
		var main_spec_amount_list='0';
		var popup_spec_type=<cfoutput>#is_stock_control_with_spec#</cfoutput>;//specli mi normal stokmu
		//stok kontrollerinin hangi tarihe gore yapılacagi XML parametresi ile belirlenir
		var loc_id = form_basket.exit_location_id.value;
		var dep_id = form_basket.exit_department_id.value;
		zero_stock_control_date = <cfoutput>'#zero_stock_control_date#'</cfoutput>;
		<cfif isdefined('zero_stock_control_date') and zero_stock_control_date eq 1>
			var paper_date_kontrol = js_date(document.getElementById('finish_date').value.toString());	
		<cfelse>
			var paper_date_kontrol = js_date(document.getElementById('today_date_').value.toString());	
		</cfif>
		<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
			if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
			{
				for (var k=1;k<=row_count_exit;k++)
				{//sarf
					if(document.getElementById("row_kontrol_exit"+k).value==1)
					{
						varName = "lot_no_" + document.getElementById("stock_id_exit"+k).value + document.getElementById("lot_no_exit"+k).value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
						stock_list=stock_list+';'+document.getElementById("stock_id_exit"+k).value+'§'+document.getElementById("lot_no_exit"+k).value+'§'+document.getElementById("amount_exit_"+k).value;
					}
				}
				for (var k=1;k<=row_count_outage;k++)
				{//fire
					if(document.getElementById("row_kontrol_outage"+k).value==1)
					{
						varName = "lot_no_" + document.getElementById("stock_id_outage"+k).value + document.getElementById("lot_no_outage"+k).value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
						stock_list=stock_list+';'+document.getElementById("stock_id_outage"+k).value+'§'+document.getElementById("lot_no_outage"+k).value+'§'+document.getElementById("amount_outage"+k).value;
					}
				}
			}
			if(stock_list != undefined && stock_list != 0)
			{
				//var xx = '';
				var myarray = stock_list.split(';');
				for(var ss=1;ss<=myarray.length;ss++)
				{
					if(myarray[ss] != undefined && myarray[ss] != 0)
					{
						var stock_id = list_getat(myarray[ss],1,'§');
						var lot_no = list_getat(myarray[ss],2,'§');
						var stock_amount = list_getat(myarray[ss],3,'§');
						if(stock_id != '' )
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,stock_id);
							if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
							{
								varName = "lot_no_" + stock_id + lot_no.replace(/-/g, '_').replace(/\./g, '_');
								var xxx = commaSplit(String(this[varName]),round_number);
								var yyy = stock_amount;
								this[varName] = parseFloat( filterNum(xxx,round_number) ) + parseFloat( filterNum(yyy,round_number) );
								if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
								{
									if(stock_type==undefined || stock_type==0)
									{
										if(is_update != 0)
											url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
										else
											url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
									}
									else
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id;
								}
								else
								{
									if(is_update != 0)
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									else
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
								}
								//$('#reference_no').val(url_);
								$.ajax({
										url: url_,
										dataType: "text",
										cache:false,
										async: false,
										success: function(read_data) {
										data_ = jQuery.parseJSON(read_data);
										if(data_.DATA.length != 0)
										{
											$.each(data_.DATA,function(i){
												var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
												var STOCK_ID = data_.DATA[i][1];
												var STOCK_CODE = data_.DATA[i][2];
												var PRODUCT_NAME = data_.DATA[i][3];
												if(eval(varName) > PRODUCT_TOTAL_STOCK)
												{
													lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												}
											});
										}
										else if(data_.DATA.length == 0)
										{
											lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										}
										else
										{
											if(parseFloat(eval(varName))< 0)
												lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										}
									}
								});
							}
						}
					}
				}
			}
		</cfif>
		for (var k=1;k<=row_count_exit;k++)
		{//sarf
			if(document.getElementById('is_sevkiyat'+k).value != undefined && document.getElementById('is_sevkiyat'+k).value != 0) 
				var sb=document.getElementById('is_sevkiyat'+k).checked; 
			else 
				var sb=false;
			if(sb!=true)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)
				{
					if(document.getElementById('spec_main_id_exit'+k).value != undefined && document.getElementById('spec_main_id_exit'+k).value != '')
					{
						var yer=list_find(spec_id_list,document.getElementById('spec_main_id_exit'+k).value,',');
						if(yer)
						{
							top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_exit_"+k).value));
							spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
						}else{
							spec_id_list=spec_id_list+','+document.getElementById('spec_main_id_exit'+k).value;
							spec_amount_list=spec_amount_list+','+filterNum(document.getElementById("amount_exit_"+k).value);
						}
					}
					//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
					var yer=list_find(stock_id_list,document.getElementById("stock_id_exit"+k).value,',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_exit_"+k).value));
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else
					{
						stock_id_list=stock_id_list+','+document.getElementById("stock_id_exit"+k).value;
						stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("amount_exit_"+k).value);
					}
				}
			}			
		}
		for (var k=1;k<=row_count_outage;k++)
		{//fire
			if(document.getElementById("row_kontrol_outage"+k).value==1)
			{
				if(document.getElementById('spec_main_id_outage'+k).value != undefined && document.getElementById('spec_main_id_outage'+k).value != '')
				{
					var yer=list_find(spec_id_list,document.getElementById('spec_main_id_outage'+k).value,',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_outage"+k).value));
						spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
					}else{
						spec_id_list=spec_id_list+','+document.getElementById('spec_main_id_outage'+k).value;
						spec_amount_list=spec_amount_list+','+filterNum(document.getElementById("amount_outage"+k).value);
					}
				}
				//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
				var yer=list_find(stock_id_list,document.getElementById("stock_id_outage"+k).value,',');
				if(yer)
				{
					top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_outage"+k).value));
					stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
				}
				else
				{
					stock_id_list=stock_id_list+','+document.getElementById("stock_id_outage"+k).value;
					stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("amount_outage"+k).value);
				}
			}
		}
		main_spec_id_list = spec_id_list;
		main_spec_amount_list = spec_amount_list;
		get_spect='';
		var stock_id_count=list_len(stock_id_list,',');
		//stock kontrolleri
		if(stock_id_count >1)
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)//departman ve lokasyon yok ise
			{
				if(stock_type==undefined || stock_type==0)
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock';
					else
						var new_sql = 'prdp_get_total_stock_2';			
				}
				else
				{
					var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>" + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql='prdp_get_total_stock_3';						
					else
						var new_sql='prdp_get_total_stock_4';
				}
			}
			else
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + loc_id + "*" + dep_id + "*" + is_update  + "*" + paper_date_kontrol;
				if(is_update != 0)
					var new_sql = 'prdp_get_total_stock_5';
				else
					var new_sql = 'prdp_get_total_stock_6';
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			if(get_total_stock.recordcount)
			{
				var query_stock_id_list='0';
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+')\n';
				}
			}
			var diff_stock_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
			{
				var stk_id=list_getat(stock_id_list,lst_cnt,',')
				if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
					diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
			}
			if(list_len(diff_stock_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
				var get_stock = wrk_safe_query('prdp_get_stock','dsn3',0,diff_stock_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+')\n';
			}
			get_total_stock='';
			//document.getElementById('product_name_exit1').value =new_sql;
		}
		//specli stok kontrolleri
		if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//sepcli stok bakılacaksa 
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			{
				
				if(stock_type==undefined || stock_type==0)
				{
					var listParam2 = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock_7';
					else
						var new_sql = 'prdp_get_total_stock_8';
				}
				else
				{
					var listParam = main_spec_id_list + "*" + <cfoutput>#dsn3_alias#</cfoutput> + "*" + <cfoutput>#dsn_alias#</cfoutput> + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
					{
						var new_sql='prdp_get_total_stock_9';
					}
					else
					{					
						var new_sql='prdp_get_total_stock_10';
					}
				}
			}
			else
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol;
				if(is_update != 0)
					var new_sql = 'prdp_get_total_stock_11';
				else
					var new_sql = 'prdp_get_total_stock_12';
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			var query_spec_id_list='0';
			if(get_total_stock.recordcount)
			{
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
					//alert(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]);
					//alert(main_spec_amount_list);
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+') (main spec id: '+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
				}
			}
			var diff_spec_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
			{
				var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
				if(!list_find(query_spec_id_list,spc_id,','))
					diff_spec_id=diff_spec_id+','+spc_id;//kayıt ge"lmeyen urunler
			}
			if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
				var get_stock = wrk_safe_query('prdp_get_stock_2','dsn3',0,diff_spec_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+') (main spec id: '+get_stock.SPECT_MAIN_ID[cnt]+')\n';
			}
			get_total_stock='';
		}
	
		if(lotno_hata != '')
		{
			if(stock_type==undefined || stock_type==0)
				alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
			else
				alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
			lotno_hata='';
			return false;
		}
		else if(hata!='')
		{
			if(stock_type==undefined || stock_type==0)
				alert(hata+"\n\n<cf_get_lang no ='575.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'> ");
			else
				alert(hata+"\n\n<cf_get_lang no ='574.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz'>");
			hata='';
			return false;
		}
		else
			return true;
	}
	<!--- todo --->	
	function kontrol_et()
	{
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		if((document.getElementById("exit_department_id").value == "") || (document.getElementById("production_department_id").value == ""))
		{
			alert("<cf_get_lang no='468.Stok Fişi Oluşturuyorsunuz'> !. <cf_get_lang no='469.Lütfen Giriş ve Çıkış Depolarınız Seçiniz'> !");
			return false;
		}
		<cfif isdefined('x_quality_control') and x_quality_control eq 1>
			<cfoutput query="get_row_enter">
				var pr_order_id_ = #pr_order_id#;
				if(document.getElementById("is_success_type_"+pr_order_id_) != undefined && document.getElementById("is_success_type_"+pr_order_id_).value != 1)
				{
					alert("Kalite Kontrol İşlemi Tamamlanmadan Sevk Edemezsiniz!");
					return false;
				}
			</cfoutput>
		</cfif>
		var get_process = wrk_safe_query('prdp_get_process','dsn3',0,document.getElementById("process_cat").value);
		if(get_process.IS_ZERO_STOCK_CONTROL == 1)
		{
			if(!zero_stock_control()) return false; //todo
			//if(!zero_stock_control(form_basket.exit_department_id.value,form_basket.exit_location_id.value,0,'form_basket.record_num_exit','form_basket.product_id_exit','form_basket.stock_id_exit','form_basket.amount_exit_','form_basket.product_name_exit','form_basket.is_sevkiyat','form_basket.row_kontrol_exit','form_basket.spec_main_id_exit',0,'form_basket.lot_no_exit')) return false;
			//if(!zero_stock_control(form_basket.exit_department_id.value,form_basket.exit_location_id.value,0,'form_basket.record_num_outage','form_basket.product_id_outage','form_basket.stock_id_outage','form_basket.amount_outage','form_basket.product_name_outage',0,'form_basket.row_kontrol_outage','form_basket.spec_main_id_outage',0,'form_basket.lot_no_outage')) return false;
		}
		_sesion_control_();
		form_basket.action='<cfoutput>#request.self#</cfoutput>?fuseaction=textile.emptypopup_add_production_result_to_stock';
		form_basket.submit();
		return false;
	}
	
	function temizle(id)
	{
		if(id==0)
		{
			document.getElementById("station_id").value = "";
			document.getElementById("station_name").value = "";
		}
	}
	function aktar(p_order_id,satir)
	{
		var round_number = document.getElementById('round_number').value;
		if(document.getElementById("fire_recordcount"))
			var fire_uzunluk=document.getElementById("fire_recordcount").value;
		else
			var fire_uzunluk=0;
		var sarf_uzunluk=parseInt(document.getElementById("sarf_recordcount").value);/*Toplam alt ürünlerin sayısı*/
		var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
		var emir=parseFloat(<cfoutput>#GET_DETAIL.AMOUNT#</cfoutput>);
		var kalan=wrk_round(parseFloat(emir)-parseFloat(toplam),round_number);
		<cfif x_por_amount_lte_po eq 0>//<!--- XML ayarlarında üretim sonuçlarının toplamı üretim emrinin miktarından fazla olamaz denildi ise.... --->
			<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('GET_SUM_AMOUNT')>
				var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_exit_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
				if(filterNum(document.getElementById("amount"+1).value,round_number)>(kalan))
					{
					alert("<cf_get_lang no ='573.Girilen Üretim Miktarı,Belirtilen Emir Miktarını Geçmektedir,Değerlerinizi Kontrol Ediniz Max Üretim Miktarı'>: "+kalan);
					document.getElementById("amount"+1).value = document.getElementById("amount_"+1).value;
					}
			<cfelseif GET_DETAIL.IS_DEMONTAJ eq 1 and isdefined('GET_SUM_AMOUNT')>
				var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
				if(filterNum(document.getElementById("amount_exit"+1).value,round_number)>(kalan))
					{
					alert("<cf_get_lang no ='573.Girilen Üretim Miktarı,Belirtilen Emir Miktarını Geçmektedir,Değerlerinizi Kontrol Ediniz Max Üretim Miktarı'>: "+kalan);
					document.getElementById("amount_exit"+1).value = document.getElementById("amount_exit_"+1).value;
					}
			</cfif>
		</cfif>
		<cfif get_detail.is_demontaj eq 0>
		
			if(sarf_uzunluk>0)
			{
			
				sarf_miktar_hesapla(satir);
			}
		
			<!---for (i=1;i<=sarf_uzunluk;i++)
			{
				if(document.getElementById("is_free_amount"+i).value == 0)
				{
					<cfif isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								<cfif x_is_fire_product eq 1>
									var a=document.getElementById("amount_exit"+i).value=(parseFloat(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/parseFloat(filterNum(document.getElementById("amount_"+1).value,round_number)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
								<cfelse>
									var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
								</cfif>
								var b=commaSplit(a,round_number);
								document.getElementById("amount_exit"+i).value=b;
							}
					<cfelseif not isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								<cfif x_is_fire_product eq 1>
									var a=document.getElementById("amount_exit"+i).value=parseFloat((filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
								<cfelse>
									var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
								</cfif>
								var b=commaSplit(a,round_number);
								document.getElementById("amount_exit"+i).value=b;
								
							}	
					</cfif>
				}
			}--->
			if(fire_uzunluk>0)
			{
				for (i=1;i<=fire_uzunluk;i++)
				{	
					<cfif get_detail.is_demontaj eq 0 and isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
								{
									<cfif x_is_fire_product eq 1>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
									<cfelse>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
									</cfif>
								}
								else
								{
									var c=0;
								}
								var d=commaSplit(c,round_number);
								document.getElementById("amount_outage"+i).value=d;
							}
					<cfelseif get_detail.is_demontaj eq 0 and not isdefined('GET_SUM_AMOUNT')>
						var x=parseInt(document.getElementById("amount"+1).value);
						if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
							{
								if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
								{
									<cfif x_is_fire_product eq 1>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
									<cfelse>
										var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
									</cfif>
								}
								else
								{
									var c=0;
								}
								var d=commaSplit(c,round_number);
								document.getElementById("amount_outage"+i).value=d;
							}	
					</cfif>
				}
			}	
		</cfif>
	}
	function spect_degistir()
		{
			<cfif GET_DETAIL.IS_DEMONTAJ eq 0>
				if(document.getElementById("spect_id_1").value!= document.getElementById("spect_id1").value)
				window.location.reload();
			<cfelse><!--- Eğer demontaj ise --->
				if(document.getElementById("spect_id_exit_1").value!= document.getElementById("spect_id_exit1").value)
				window.location.reload();
			</cfif>
		}
	function get_stok_spec_detail_ajax(product_id){
		goster(prod_stock_and_spec_detail_div);
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
		document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
		document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
	}
	function send_dep_loc(){	
		var station_id=document.getElementById('station_id').value;
		if(station_id!="")
		{
			var GET_STATION=wrk_safe_query('prdp_get_station','dsn3',0,station_id);
			var exit_dep_id=GET_STATION.EXIT_DEP_ID;
			var exit_loc_id=GET_STATION.EXIT_LOC_ID;
			var production_dep_id=GET_STATION.PRODUCTION_DEP_ID;
			var production_loc_id=GET_STATION.PRODUCTION_LOC_ID;
			var enter_dep_id=GET_STATION.ENTER_DEP_ID;
			var enter_loc_id=GET_STATION.ENTER_LOC_ID;
			if(exit_dep_id!="" && exit_loc_id!="" ){
					var exit_dep_query=workdata('get_department_id',exit_dep_id);
					var exit_loc_query=workdata('get_location_id',exit_loc_id,exit_dep_id);
					document.getElementById('exit_department_id').value=exit_dep_query.DEPARTMENT_ID;
					document.getElementById('exit_location_id').value=exit_loc_query.LOCATION_ID;
					document.getElementById('exit_department').value=exit_dep_query.DEPARTMENT_HEAD +'-' + exit_loc_query.COMMENT;
				}
			else{
					document.getElementById('exit_department_id').value="";
					document.getElementById('exit_location_id').value="";
					document.getElementById('exit_department').value="";
				}
		  if(production_dep_id!="" && production_loc_id!="" ){
					var production_dep_query=workdata('get_department_id',production_dep_id);
					var production_loc_query=workdata('get_location_id',production_loc_id,production_dep_id);
					document.getElementById('production_department_id').value=production_dep_query.DEPARTMENT_ID;
					document.getElementById('production_location_id').value=production_loc_query.LOCATION_ID;
					document.getElementById('production_department').value=production_dep_query.DEPARTMENT_HEAD +'-'+ production_loc_query.COMMENT;
				}
			else{
					document.getElementById('production_department_id').value="";
					document.getElementById('production_location_id').value="";
					document.getElementById('production_department').value="";
				}
			if(enter_dep_id!="" && enter_loc_id!="" ){
					var enter_dep_query=workdata('get_department_id',enter_dep_id);
					var enter_loc_query=workdata('get_location_id',enter_loc_id,enter_dep_id);
					document.getElementById('enter_department_id').value=enter_dep_query.DEPARTMENT_ID;
					document.getElementById('enter_location_id').value=enter_loc_query.LOCATION_ID;
					document.getElementById('enter_department').value=enter_dep_query.DEPARTMENT_HEAD +'-' + enter_loc_query.COMMENT;
				}
			else{
					document.getElementById('enter_department_id').value="";
					document.getElementById('enter_location_id').value="";
					document.getElementById('enter_department').value="";
				}
		}
		else
		return false;
	} 
	function open_station(){
		<cfoutput>
			stock_id = document.getElementById('stock_id1').value ;
			str = '#request.self#?fuseaction=prod.popup_list_workstation&field_name=form_basket.station_name&field_id=form_basket.station_id';
			<cfif isdefined("is_product_station_relation") and is_product_station_relation eq 1>
				str = str + '&stock_id='+stock_id ;
			</cfif>
			windowopen(str,'list');
		</cfoutput>
		}
		function sarf_miktar_hesapla(satir)
		{
		<cfoutput query="GET_ROW_EXIT">
		<cfif not len(GET_ROW_EXIT.p_order_id)>
			
		
				var sarfmiktar=0;
							var sid='#stock_id#';
						<cfloop query="get_row_enter">
						
									var eski_mamul_miktar='#get_row_enter.amount#'; 
									var yeni_mamul_miktar=parseFloat(filterNum(document.getElementById("amount"+'#get_row_enter.currentrow#').value,8));
				
								/*sql='select AMOUNT from PRODUCTION_ORDERS_STOCKS WHERE TYPE=2 AND STOCK_ID='+sid+' AND P_ORDER_ID='+'#get_row_enter.p_order_id#';
								query_=wrk_query(sql,'dsn3');*/
									var p_order_id=document.getElementById("sub_p_order_id"+'#get_row_enter.currentrow#').value;
									var row_status=document.getElementById("row_kontrol"+'#get_row_enter.currentrow#').value;
							if(row_status==1)
							{
									
									
												if(p_order_id!='#get_row_enter.p_order_id#')
												{
													alert('OrderId Eşit Değil');
													return;
												}
												
											<cfquery name="get_s" dbtype="query">
												select AMOUNT FROM get_sarf_ WHERE P_ORDER_ID=#get_row_enter.p_order_id# AND STOCK_ID=#GET_ROW_EXIT.stock_id#
											</cfquery>
											
											var emir_sarfamount=0;
											<cfif get_s.recordcount gt 0>
													emir_sarfamount='#get_s.AMOUNT#';
											</cfif>
											if(document.getElementById("is_free_amount"+'#get_row_enter.currentrow#').value == 0)
															{
																if(yeni_mamul_miktar>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
																	{
																		if(parseFloat(document.getElementById("amount_"+'#get_row_enter.currentrow#').value) != 0 && parseFloat(document.getElementById("amount"+'#get_row_enter.currentrow#').value) != 0 && emir_sarfamount>0)
																		{

																			var fire_miktar=parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,8));
																			
																			sarfmiktar+=(parseFloat(emir_sarfamount)/parseFloat(eski_mamul_miktar))*(parseFloat(yeni_mamul_miktar)+parseFloat(fire_miktar));
																		}
																		else
																		{
																		;
																		//	var sarfmiktar=0;
																		}
																		var b=commaSplit(sarfmiktar,8);
																	
																		document.getElementById("amount_exit"+'#GET_ROW_EXIT.currentrow#').value=b;
																	}
														

															}
							}			
						</cfloop>
		</cfif>
		</cfoutput>
			
			//alert('Sarf Miktar Hesaplama Tamamlandı!');
		}
	
	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->