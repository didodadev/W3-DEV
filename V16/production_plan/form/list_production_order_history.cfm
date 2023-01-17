
<cfquery name="get_history" datasource="#dsn3#">
	SELECT
    ISNULL(PRODUCTION_ORDERS_HISTORY.UPDATE_DATE,PRODUCTION_ORDERS_HISTORY.RECORD_DATE) UPDATE_DATE,
    STATION_ID,
    (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=ISNULL(PRODUCTION_ORDERS_HISTORY.UPDATE_EMP,PRODUCTION_ORDERS_HISTORY.RECORD_EMP)) AS UPDATE_NAME,
    	* 
    FROM 
    	PRODUCTION_ORDERS_HISTORY
    WHERE
    	P_ORDER_ID = #attributes.upd#
	ORDER BY
		HISTORY_ID DESC
</cfquery>
<cf_box title="#getLang('','Tarihçe','57473')#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif get_history.recordcount>
        <cfset temp_ = 0>
        <cfoutput query="get_history">
            <cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
            <table id="history_#temp_#" style="display:none;" height="10%">
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='59088.Tip'></td>
                    <td>
                        <cfif len(DEMAND_NO) and IS_STAGE eq -1 and IS_STOCK_RESERVED eq 0><cf_get_lang dictionary_id='40722.Talep'><cfelse><cf_get_lang dictionary_id='57123.Emir'></cfif>
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="txtbold"><cfif len(DEMAND_NO) and IS_STAGE eq -1 and IS_STOCK_RESERVED eq 0><cf_get_lang dictionary_id='56879.Talep No'><cfelse><cf_get_lang dictionary_id='45276.Üretim Emir No'></cfif></td>
                    <td><cfif len(DEMAND_NO) and IS_STAGE eq -1 and IS_STOCK_RESERVED eq 0>#DEMAND_NO#<cfelse>#P_ORDER_NO#</cfif></td>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='45498.Lot No'></td>
                    <td>#LOT_NO#</td>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='40587.Demontaj'>/<cf_get_lang dictionary_id='40225.Reserve'></td>
                    <td>#is_demontaj#/#is_stock_reserved#</td>
                </tr>
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='58784.Referans'></td>
                    <td>#REFERENCE_NO#</td>
                    <cfif len(STATION_ID)>
                    <cfquery name="GET_W" datasource="#DSN3#">
                        SELECT 
                            STATION_NAME 
                        FROM 
                            WORKSTATIONS 
                        WHERE 
                            STATION_ID=#get_history.STATION_ID#
                    </cfquery>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='58834.İstasyon'></td>
                    <td>#GET_W.STATION_NAME#</td>
                    <cfelse>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='58834.İstasyon'></td>
                    <td>-</td>
                    </cfif>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='57635.Miktar'></td>
                    <td>#result_amount#</td>
                </tr>
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></td>
                    <td>#dateformat(start_date,dateformat_style)#</td>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
                    <td>#dateformat(finish_date,dateformat_style)#</td>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='57482.Aşama'></td>
                    <cfquery name="GET_STAGE" datasource="#DSN#">
                        SELECT STAGE from PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #prod_order_stage#
                    </cfquery>
                    <td>#GET_STAGE.STAGE#</td>
                </tr>
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='57416.Proje'></td>
                    <td><cfif len(project_id)>#get_project_name(project_id)#</cfif></td>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='58445.İş'></td>
                    <cfif len(WORK_ID)>
                    <cfquery name="GET_WORK" datasource="#DSN#">
                        SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = #WORK_ID#
                    </cfquery>
                    <td>#GET_WORK.WORK_HEAD#</td>
                    <cfelse>
                    <td>&nbsp;</td>
                    </cfif>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></td>
                    <td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                </tr>
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td>#detail#</td>
                </tr>
                <tr>
                    <td colspan="6" class="txtbold" valign="top">
                        <cfif len(update_emp) and len(update_date)><cf_get_lang dictionary_id='57703.Güncelleme'>: #get_emp_info(update_emp,0,0)# - #dateformat(dateadd('h',session.ep.time_zone,update_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#</cfif>
                    </td>
                </tr>
                <tr>
                    <td colspan="6"><hr /></td>
                </tr>
            
            </table>
        </cfoutput>
        <cfelse>
        <tr>
            <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</cf_box>
