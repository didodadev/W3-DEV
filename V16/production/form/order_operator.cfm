<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.station_id" default="0">
<cfparam name="_p_order_number_list_" default="">
<cfparam name="p_order_number_list" default="">
<cfparam name="get_production_orders.DETAIL" default="">
<cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>
	<cfquery name="get_production_orders" datasource="#dsn3#">
        SELECT 
              P_ORDER_ID,
              DETAIL,
              START_DATE,
              FINISH_DATE,
              LOT_NO,
              P_ORDER_NO,
              SPECT_VAR_ID,
              SPECT_VAR_NAME,
              SPEC_MAIN_ID,
              STATION_ID,
              STOCK_ID
        FROM 
            PRODUCTION_ORDERS
        WHERE
        	LOT_NO = '#attributes.lot_no#' AND
            STATION_ID = #attributes.station_id#
    </cfquery>
    <cfset _p_order_id_list_ = ValueList(get_production_orders.P_ORDER_ID,',')>
    <cfset _p_order_number_list_ = listdeleteduplicates(valuelist(get_production_orders.P_ORDER_NO,','))>
<cfelse>
    <cfset _p_order_id_list_ = "">
    <cfset _p_order_number_list_ = "">
    <cfset get_production_orders.recordcount = 0>
</cfif>
<cfquery name="get_workstation" datasource="#dsn3#">
	SELECT * FROM WORKSTATIONS WHERE STATION_ID = #attributes.station_id#
   and DEPARTMENT IN (SELECT DEPARTMENT_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>

<cfif listlen(_p_order_id_list_,',')>
    <cfquery name="get_production_orders_rel" datasource="#dsn3#"><!--- Emirlerler ilişkili Siparişleri Çekiyoruz. --->
        SELECT 
            (SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = POR.ORDER_ID) AS ORDER_NUMBER
        FROM 
            PRODUCTION_ORDERS_ROW POR
        WHERE
            POR.PRODUCTION_ORDER_ID IN (#_p_order_id_list_#)
    </cfquery>
    <cfset p_order_number_list = listdeleteduplicates(ValueList(get_production_orders_rel.ORDER_NUMBER,','))>
</cfif>
<cf_catalystHeader>  

<cfif get_production_orders.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang("","",58834)# : #get_workstation.station_name# #getLang("","",38106)# : #dateFormat(get_production_orders.START_DATE,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_production_orders.START_DATE),timeformat_style)# -
        #dateFormat(get_production_orders.FINISH_DATE,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_production_orders.FINISH_DATE),timeformat_style)#" print_href ="#request.self#?fuseaction=objects.popup_print_files&action_id=#_p_order_id_list_#|#attributes.lot_no#&print_type=280">
        <div class="col col-6">
            <cfsavecontent  variable="variable">Üretim Detay</cfsavecontent>
            <cf_seperator title="#variable#" id="detail">
                <cf_ajax_list id="detail">
                    <tbody>
                        
                            <cfoutput>
                                <th><cf_get_lang dictionary_id="38109.Açıklama/Talimat">:</th><td>#get_production_orders.DETAIL#</td>
                                <th><cf_get_lang dictionary_id="38107.Lot">:</th><td>#attributes.lot_no#</td>
                                <th><cf_get_lang dictionary_id="57528.Emirler">:</th><td>#_p_order_number_list_#</td>
                                <th><cf_get_lang dictionary_id="38108.Siparişler">:</th><td>#p_order_number_list#</td>
                            </cfoutput>
                        
                    </tbody>
                </cf_ajax_list>           
        </div>
        <div class="col col-12">
        <div id="groups_p"></div>
        </div>
        </cf_box>
    </div>
    <!--- <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center">
        <tr>
            <cfoutput>
				<td height="50" class="headbold">
				   <cf_get_lang dictionary_id="58834.İstasyon">: #get_workstation.station_name# &nbsp;&nbsp;&nbsp;&nbsp;
				   <cf_get_lang dictionary_id="38106.Hedef Zaman">: 
				</td>
				<td style="text-align:right;"><a href="javascript://" onClick=""><img src="../images/print.gif" border="0"></a></td>
            </cfoutput>
        </tr>
    </table>
    <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr>
            <td class="color-row">
                
					<table>
						<tr>
							<td class="txtbold"></td>
							<td><input type="text" style="width:150px;" class="boxtext" value="">
							<td class="txtbold"></td>
							<td><input type="text" style="width:150px;" class="boxtext" value=""></td>
							<td class="txtbold"></td>
							<td><input type="text" style="width:150px;" class="boxtext" value=""></td>
						</tr>
						<tr>
							<td class="headbold" colspan="6">: <cfoutput>##</cfoutput></td>
						</tr>
						<tr id="p_order_results" style="display:none;"><!--- İlk olarak kapalı gelicek eğer sonuç varsa açılacak! --->
							<td class="txtbold"> <font color="red"><cf_get_lang dictionary_id="38092.Üretim Sonuçları"></font></td>
							<td colspan="5"><input type="text" style="width:450px;" class="boxtext"  name="_p_order_results_" id="_p_order_results_"></td>
						</tr>
					</table>
                </cfoutput>
            </td>
        </tr>
        <tr class="color-row">
            <td></td>
        </tr>
    </table>
    <br/> --->
    <script type="text/javascript">
        <cfoutput>
			AjaxPageLoad('#request.self#?fuseaction=production.popup_ajax_production_orders_groups_operator&lot_no=#attributes.lot_no#&station_id=#get_production_orders.station_id#&p_order_id_list=#_p_order_id_list_#','groups_p',1);
        </cfoutput>
    </script>

</cfif>
