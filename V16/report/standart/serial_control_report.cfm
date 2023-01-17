<cfparam name="attributes.module_id_control" default="14">
<cfsetting showdebugoutput="yes">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default=20>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.filter" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_hierarchy" default="">
<cfform name="serial_control_rep" method="post" action="#request.self#?fuseaction=report.serial_control_report">
   <input name="form_submitted" id="form_submitted" value="1" type="hidden">
     <cf_report_list_search title="#getLang('report',430)#">
        <cf_report_list_search_area>
            <cf_box_elements vertical="1">
                    <cfoutput> 
                        <div class="col col-3 col-md-12 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label><cf_get_lang_main no='48.Filtre'></label>
                            <cfinput type="text" name="filter" id="filter" value="#attributes.filter#" maxlength="50"  placeholder="#getLang(48,'Keyword',47046)#">
                        </div>
                        <div class="form-group">
                            <label><cf_get_lang_main no='245.Ürün'></label>
                            <div class="input-group">
                                <input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id")>#attributes.product_id#</cfif>">
                                <input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined("attributes.stock_id")>#attributes.stock_id#</cfif>">
                                <input type="text" name="product" id="product"  onfocus="AutoComplete_Create('product','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off" value="<cfif isdefined("attributes.product")>#attributes.product#</cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=serial_control_rep.stock_id&product_id=serial_control_rep.product_id&field_name=serial_control_rep.product','list');"></span>
                            </div>
                         </div>
                    <div class="form-group">
                        <label><cf_get_lang_main no='74.Kategori'></label>
                        <div class="input-group">
                            <input type="hidden" name="product_hierarchy" id="product_hierarchy" value="<cfif isdefined("attributes.product_hierarchy")>#attributes.product_hierarchy#</cfif>">
                            <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined("attributes.product_catid")>#attributes.product_catid#</cfif>">
                            <input type="text" name="product_cat" id="product_cat" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');" autocomplete="off" value="<cfif isdefined("attributes.product_cat")>#attributes.product_cat#</cfif>">
                            <span class="input-group-addon btnPointer icon-ellipsis"onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&is_form_submitted=1&field_id=serial_control_rep.product_catid&field_name=serial_control_rep.product_cat&field_hierarchy=serial_control_rep.product_hierarchy');"></span>
                        </div>
                    </div> 
              
                    </cfoutput>	
                  </cf_box_elements>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            	 <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><label><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></label></cfsavecontent>
                                <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                                <cfelse>
                                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                                </cfif>
                            <cf_wrk_search_button button_type="1" search_function='kontrol()' is_excel='1' >
                        </div>
                    </div>
                 </div>
        </cf_report_list_search_area>
    </cf_report_list_search> 
</cfform>

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_search_results_" datasource="#dsn3#">
    SELECT DISTINCT
        1 BLOCK_TYPE,
        SHIP_ROW.STOCK_ID,
        SHIP_ROW.PRODUCT_ID,
        SUM(SHIP_ROW.AMOUNT) QUANTITY,
        SHIP.SHIP_ID PROCESS_ID,
        SHIP.SHIP_TYPE PROCESS_CAT,
        SHIP.PURCHASE_SALES,
        SHIP.SHIP_NUMBER PROCESS_NUMBER,
        SHIP.SHIP_DATE PROCESS_DATE,
        SHIP.DELIVER_DATE,
        SHIP.COMPANY_ID,
        SHIP.PARTNER_ID,
        SHIP.CONSUMER_ID,
        SHIP.LOCATION_IN LOCATION_IN,
        SHIP.DEPARTMENT_IN DEPARTMENT_IN,
        SHIP.LOCATION LOCATION_OUT,
        SHIP.DELIVER_STORE_ID DEPARTMENT_OUT,
        SHIP_ROW.SPECT_VAR_ID SPECT_ID,
        '' AS SPECT_OUT_ID,
        STOCKS.PRODUCT_NAME,
        STOCKS.STOCK_CODE,
        STOCKS.PRODUCT_CODE_2
    FROM
        #dsn2_alias#.SHIP SHIP,
        #dsn2_alias#.SHIP_ROW SHIP_ROW,
        STOCKS
    WHERE
        SHIP_ROW.STOCK_ID NOT IN (SELECT SG2.STOCK_ID FROM SERVICE_GUARANTY_NEW SG2 WHERE SG2.PROCESS_ID = SHIP.SHIP_ID AND SG2.PROCESS_CAT = SHIP.SHIP_TYPE AND SG2.PERIOD_ID = #session.ep.period_id#) AND
        SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
        SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND
        STOCKS.IS_SERIAL_NO = 1 AND
        SHIP.SHIP_STATUS = 1
         AND IS_SHIP_IPTAL = 0
        <cfif len(attributes.filter)>
        	AND (
                    SHIP.SHIP_NUMBER = '#attributes.filter#'
                    OR 
                    STOCKS.STOCK_CODE LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                    OR
                    STOCKS.PRODUCT_CODE_2 LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                )
        </cfif>
		<cfif len(attributes.product_id) and len(attributes.product)>
        	AND STOCKS.PRODUCT_ID = #attributes.product_id# 
        </cfif>
        <cfif len(attributes.product_catid) and len(attributes.product_hierarchy) and len(attributes.product_cat)>
            AND STOCKS.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_hierarchy#.%">
        </cfif>
    GROUP BY
        SHIP_ROW.STOCK_ID,
        SHIP_ROW.PRODUCT_ID,
        SHIP.SHIP_ID,
        SHIP.SHIP_TYPE,
        SHIP.PURCHASE_SALES,
        SHIP.SHIP_NUMBER,
        SHIP.SHIP_DATE,
        SHIP.DELIVER_DATE,
        SHIP.COMPANY_ID,
        SHIP.PARTNER_ID,
        SHIP.CONSUMER_ID,
        SHIP.LOCATION_IN,
        SHIP.DEPARTMENT_IN,
        SHIP.LOCATION,
        SHIP.DELIVER_STORE_ID,
        SHIP_ROW.SPECT_VAR_ID,
        STOCKS.PRODUCT_NAME,
        STOCKS.STOCK_CODE,
        STOCKS.PRODUCT_CODE_2
    UNION
    SELECT
        2 BLOCK_TYPE,
        STOCK_FIS_ROW.STOCK_ID,
        1 PRODUCT_ID,
        SUM(STOCK_FIS_ROW.AMOUNT) QUANTITY,
        STOCK_FIS.FIS_ID PROCESS_ID,
        STOCK_FIS.FIS_TYPE PROCESS_CAT,
        3 AS PURCHASE_SALES,
        STOCK_FIS.FIS_NUMBER PROCESS_NUMBER,
        STOCK_FIS.FIS_DATE PROCESS_DATE,
        STOCK_FIS.DELIVER_DATE,
        -1 AS COMPANY_ID,
        -1 AS PARTNER_ID,
        -1 AS CONSUMER_ID,
        STOCK_FIS.LOCATION_IN LOCATION_IN,
        STOCK_FIS.DEPARTMENT_IN DEPARTMENT_IN,
        STOCK_FIS.LOCATION_OUT LOCATION_OUT,
        STOCK_FIS.DEPARTMENT_OUT DEPARTMENT_OUT,
        STOCK_FIS_ROW.SPECT_VAR_ID SPECT_ID,
        '' AS SPECT_OUT_ID,
        STOCKS.PRODUCT_NAME,
        STOCKS.STOCK_CODE,
        STOCKS.PRODUCT_CODE_2
    FROM
        #dsn2_alias#.STOCK_FIS STOCK_FIS,
        #dsn2_alias#.STOCK_FIS_ROW STOCK_FIS_ROW,
        STOCKS
    WHERE
        STOCK_FIS_ROW.STOCK_ID NOT IN (SELECT SG2.STOCK_ID FROM SERVICE_GUARANTY_NEW SG2 WHERE SG2.PROCESS_ID = STOCK_FIS.FIS_ID AND SG2.PROCESS_CAT = STOCK_FIS.FIS_TYPE AND SG2.PERIOD_ID = #session.ep.period_id#) AND
        STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
        STOCK_FIS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
        STOCKS.IS_SERIAL_NO = 1
		<cfif len(attributes.filter)>
        	AND (
                    STOCK_FIS.FIS_NUMBER = '#attributes.filter#'
                    OR 
                    STOCKS.STOCK_CODE LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                    OR
                    STOCKS.PRODUCT_CODE_2 LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                )
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product)>
        	AND STOCKS.PRODUCT_ID = #attributes.product_id#
        </cfif>
         <cfif len(attributes.product_catid) and len(attributes.product_hierarchy) and len(attributes.product_cat)>
            AND STOCKS.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_hierarchy#.%">
        </cfif>
    GROUP BY
        STOCK_FIS_ROW.STOCK_ID,
        STOCK_FIS.FIS_ID,
        STOCK_FIS.FIS_TYPE,
        STOCK_FIS.FIS_NUMBER,
        STOCK_FIS.FIS_DATE,
        STOCK_FIS.DELIVER_DATE,
        STOCK_FIS.LOCATION_IN,
        STOCK_FIS.DEPARTMENT_IN,
        STOCK_FIS.LOCATION_OUT,
        STOCK_FIS.DEPARTMENT_OUT,
        STOCK_FIS_ROW.SPECT_VAR_ID,
        STOCK_FIS_ROW.STOCK_FIS_ROW_ID,
        STOCKS.PRODUCT_NAME,
        STOCKS.STOCK_CODE,
        STOCKS.PRODUCT_CODE_2
    UNION
    SELECT
        3 BLOCK_TYPE,
        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
        PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
        SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT) QUANTITY,
        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID PROCESS_ID,
        171 PROCESS_CAT,
        0 AS PURCHASE_SALES,
        PRODUCTION_ORDER_RESULTS.RESULT_NO PROCESS_NUMBER,
        PRODUCTION_ORDER_RESULTS.FINISH_DATE PROCESS_DATE,
        PRODUCTION_ORDER_RESULTS.START_DATE DELIVER_DATE,
        -1 COMPANY_ID,
        -1 PARTNER_ID,
        -1 CONSUMER_ID,
        PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID LOCATION_IN,
        PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID DEPARTMENT_IN,
        PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID LOCATION_OUT,
        PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID DEPARTMENT_OUT,		
        PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID SPECT_ID,
        '' AS SPECT_OUT_ID,
        STOCKS.PRODUCT_NAME,
        STOCKS.STOCK_CODE,
        STOCKS.PRODUCT_CODE_2
    FROM
        PRODUCTION_ORDER_RESULTS,
        PRODUCTION_ORDER_RESULTS_ROW,
        STOCKS
    WHERE
        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID NOT IN (SELECT SG2.STOCK_ID FROM SERVICE_GUARANTY_NEW SG2 WHERE SG2.PROCESS_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID AND SG2.PROCESS_CAT = 171 AND SG2.PERIOD_ID = #session.ep.period_id#) AND
        PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID IS NOT NULL AND
        PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID IS NOT NULL AND
        PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND
        PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID AND
        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
        STOCKS.IS_SERIAL_NO = 1
		<cfif len(attributes.filter)>
        	AND (
                    PRODUCTION_ORDER_RESULTS.RESULT_NO = '#attributes.filter#'
                    OR 
                    STOCKS.STOCK_CODE LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                    OR
                    STOCKS.PRODUCT_CODE_2 LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                )
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product)>
        	AND STOCKS.PRODUCT_ID = #attributes.product_id#
        </cfif>
		 <cfif len(attributes.product_catid) and len(attributes.product_hierarchy) and len(attributes.product_cat)>
            AND STOCKS.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_hierarchy#.%">
        </cfif>

    GROUP BY 
        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
        PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
        PRODUCTION_ORDER_RESULTS.RESULT_NO,
        PRODUCTION_ORDER_RESULTS.FINISH_DATE,
        PRODUCTION_ORDER_RESULTS.START_DATE,		
        PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID,
        PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID,
        PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
        PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
        PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID,
        PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
        STOCKS.PRODUCT_NAME,
        STOCKS.STOCK_CODE,
        STOCKS.PRODUCT_CODE_2
    UNION
    SELECT
        5 BLOCK_TYPE,
        STOCK_EXCHANGE.STOCK_ID,
        S.PRODUCT_ID,
        1 AS QUANTITY,
        STOCK_EXCHANGE.PROCESS_TYPE AS PROCESS_CAT,
        STOCK_EXCHANGE.PROCESS_CAT AS PROCESS_ID,
        0 AS PURCHASE_SALES,
        STOCK_EXCHANGE.EXCHANGE_NUMBER AS PROCESS_NUMBER,
        STOCK_EXCHANGE.RECORD_DATE AS PROCESS_DATE,
        '' AS DELIVER_DATE,
        -1 AS COMPANY_ID,
        -1 AS PARTNER_ID,
        -1 AS CONSUMER_ID,
        STOCK_EXCHANGE.DEPARTMENT_ID AS DEPARTMENT_IN,
        STOCK_EXCHANGE.LOCATION_ID AS LOCATION_IN,
        STOCK_EXCHANGE.EXIT_DEPARTMENT_ID AS DEPARTMENT_OUT,
        STOCK_EXCHANGE.EXIT_LOCATION_ID AS LOCATION_OUT,
        STOCK_EXCHANGE.SPECT_MAIN_ID AS SPECT_ID,
        STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID AS SPECT_OUT_ID,
        S.PRODUCT_NAME,
        S.STOCK_CODE,
        S.PRODUCT_CODE_2
    FROM
        #dsn2_alias#.STOCK_EXCHANGE AS STOCK_EXCHANGE,
        #dsn3_alias#.STOCKS S
    WHERE
        S.STOCK_ID NOT IN (SELECT SG2.STOCK_ID FROM SERVICE_GUARANTY_NEW SG2 WHERE SG2.PROCESS_ID = STOCK_EXCHANGE.STOCK_EXCHANGE_ID AND SG2.PROCESS_CAT = STOCK_EXCHANGE.PROCESS_TYPE AND SG2.PERIOD_ID = #session.ep.period_id#) AND
        S.STOCK_ID = STOCK_EXCHANGE.STOCK_ID
		<cfif len(attributes.filter)>
        	AND (
                    STOCK_EXCHANGE.EXCHANGE_NUMBER = '#attributes.filter#'
                    OR 
                    S.STOCK_CODE LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                    OR
                    S.PRODUCT_CODE_2 LIKE '<cfif len(attributes.filter) gt 2>%</cfif>#attributes.filter#%'
                )
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product)>
        	AND S.PRODUCT_ID = #attributes.product_id#
        </cfif>
		 <cfif len(attributes.product_catid) and len(attributes.product_hierarchy) and len(attributes.product_cat)>
            AND S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_hierarchy#.%">
        </cfif>

    ORDER BY
        BLOCK_TYPE,
        PROCESS_DATE DESC,
        PROCESS_CAT,
        PROCESS_ID
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.totalrecords" default="#get_search_results_.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
 <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
     <cfset filename="system_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
     <cfheader name="Expires" value="#Now()#">
     <cfcontent type="application/vnd.msexcel; charset=utf-16">
     <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
     <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
   <cfset type_ = 1>
     <cfset attributes.startrow=1>
     <cfset attributes.maxrows=get_search_results_.recordcount>	
   <cfelse>
     <cfset type_ = 0>
     <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
     <cfset attributes.maxrows=attributes.maxrows>
 </cfif>      <!-- sil -->
        <cf_report_list> 
            <thead>
                <th width="175"><cf_get_lang_main no='388.İşlem Tipi'></th>
                <th width="100"><cf_get_lang_main no='468.Belge No'></th>
                <th><cf_get_lang_main no="106.stok kodu"></th>
                <th><cf_get_lang_main no="377.özel kodu"></th>
                <th><cf_get_lang_main no='245.Ürün'></th>
                <th width="50"><cf_get_lang_main no='223.Miktar'></th>
                <th width="85"><cf_get_lang_main no='500.İşlem Tarihi'></th>
            </thead>
            <tbody>
                <cfif get_search_results_.recordcount>
                    <cfoutput query="get_search_results_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
                            <td>#get_process_name(PROCESS_CAT)#</td>
                            <td><a href="#request.self#?fuseaction=stock.list_serial_operations&event=det&product_amount=#QUANTITY#&recorded_count=0&product_id=#product_id#&stock_id=#stock_id#&process_number=#PROCESS_NUMBER#&process_date=#process_date#&process_cat=#process_cat#&process_id=#process_id#&sale_product=#PURCHASE_SALES#&company_id=#COMPANY_ID#&con_id=#CONSUMER_ID#&location_out=#location_out#&department_out=#department_out#&location_in=#location_in#&department_in=#department_in#&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id=#spect_id#" class="tableyazi">#PROCESS_NUMBER#</a></td>
                            <td>#stock_code#</td>
                            <td>#PRODUCT_CODE_2#</td>
                            <td>#product_name#</td>
                            <td style="text-align:right;">#QUANTITY#</td>
                            <td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
                        </tr>
                    </cfoutput>
          
                <cfelse>
                    <tr>
                        <td colspan="17"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
                    </tr>
                </cfif> 
            </tbody>
     </cf_report_list>  
	<cfif attributes.totalrecords gt attributes.maxrows>
        <cfset adres="report.serial_control_report">
        <cfif len(attributes.form_submitted)>
            <cfset adres = adres & '&form_submitted=#attributes.form_submitted#'>
        </cfif>
        <cfif len(attributes.product_id)>
            <cfset adres = adres & '&product_id=#attributes.product_id#'>
        </cfif>
        <cfif len(attributes.product_catid)>
            <cfset adres = adres & '&product_catid=#attributes.product_catid#'>
        </cfif>
        <cfif len(attributes.product)>
            <cfset adres = adres & '&product=#attributes.product#'>
        </cfif>
        <cfif len(attributes.product_cat)>
            <cfset adres = adres & '&product_cat=#attributes.product_cat#'>
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
    </cfif>
</cfif>
<script language="javascript">
    function kontrol(){
        if(document.serial_control_rep.is_excel.checked==false)
			{
				document.serial_control_rep.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.serial_control_report"
				return true;
			}
			else
			{
				document.serial_control_rep.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_serial_control_report</cfoutput>"
            }
    }
</script>
