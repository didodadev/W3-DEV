<cfquery name="GET_BASKET_HISTORY" datasource="#DSN3#">
    SELECT
    
        SBH.HISTORY_BASKET_ID, 
        SBH.RECORD_EMP,
        SBH.RECORD_IP,
        SBH.RECORD_DATE,       
    
        SBH.BASKET_ID,
		SBH.B_TYPE,
		SBH.PURCHASE_SALES,
		SBH.AMOUNT_ROUND,
		SBH.PRODUCT_SELECT_TYPE,
		SBH.PRICE_ROUND_NUMBER,
		SBH.BASKET_TOTAL_ROUND_NUMBER,
		SBH.BASKET_RATE_ROUND_NUMBER,
		SBH.USE_PROJECT_DISCOUNT,
        SBH.LINE_NUMBER,
		SBH.UPDATE_EMP  ,
		SBH.UPDATE_IP,
		SBH.UPDATE_DATE, 
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS UPDATE_NAME
        
    FROM
        SETUP_BASKET_HISTORY SBH  JOIN  #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = SBH.UPDATE_EMP
    WHERE
        BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.ID#"> 
        AND
        B_TYPE=1
         
    ORDER BY 
        HISTORY_BASKET_ID DESC
</cfquery>

<cf_popup_box title="#getLang('main',61)#"><!---<cf_get_lang_main no='61.Tarihçe'>--->
	<cfif GET_BASKET_HISTORY.recordcount>
		<cfset temp_ = 0>
        <cfoutput query="GET_BASKET_HISTORY">
        
        	<cfquery name="GET_BASKET_ROWS_HISTORY" datasource="#DSN3#">
                SELECT
                
                        BASKET_ROW_ID,  
                        LANGUAGE_ID, 
                        HISTORY_BASKET_ID,
                        
                        TITLE,
                        IS_SELECTED,
                        BASKET_ID,
                        LINE_ORDER_NO,
                        B_TYPE,
                        TITLE_NAME,
                        GENISLIK,
                        IS_READONLY,
                        HISTORY_BASKET_ROW_ID
                FROM
                    SETUP_BASKET_ROWS_HISTORY 
                WHERE
                    HISTORY_BASKET_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#HISTORY_BASKET_ID#"> 
                   <!--- AND--->
                   <!---B_TYPE=1--->
                    
                ORDER BY 
                    HISTORY_BASKET_ROW_ID DESC
            </cfquery>
        
            <cf_seperator id="history_#HISTORY_BASKET_ID#" header="#dateformat(update_date,dateformat_style)# (#timeformat(update_date,timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
            <table id="history_#HISTORY_BASKET_ID#" style="display:none;">
              <!---  <tr>
                    <td class="txtbold">BASKET ID</td>
                    <td colspan="5">#BASKET_ID#</td>
                    <td class="txtbold">HISTORY BASKET ID</td>
                    <td colspan="5">#HISTORY_BASKET_ID#</td>
                    
                </tr>--->
                <tr>
                    <td class="txtbold">B TYPE</td>
                    <td>#B_TYPE#</td>
                    <td class="txtbold">PURCHASE SALES</td>
                    <td>#PURCHASE_SALES#</td>
                    <td class="txtbold">AMOUNT ROUND</td>
                    <td>#AMOUNT_ROUND#</td>
                </tr>
                <tr>
                    <td class="txtbold">PRODUCT SELECT TYPE</td>
                    <td>#PRODUCT_SELECT_TYPE#</td>
                    <td class="txtbold">PRICE ROUND NUMBER</td>
                    <td>#PRICE_ROUND_NUMBER#</td>
                    <td class="txtbold">BASKET TOTAL ROUND NUMBER</td>
                    <td>#BASKET_TOTAL_ROUND_NUMBER#</td>
                </tr>
                <tr>
                    <td class="txtbold">BASKET RATE ROUND NUMBER</td>
                    <td>#BASKET_RATE_ROUND_NUMBER#</td>
                    <td class="txtbold">USE PROJECT DISCOUNT</td>
                    <td>#USE_PROJECT_DISCOUNT#</td>
                    <td class="txtbold">LINE NUMBER</td>
                    <td>#LINE_NUMBER# </td>
                </tr>
                 <tr>
                    <td class="txtbold">UPDATE EMP</td>
                    <td>#UPDATE_NAME#</td>
                    <td class="txtbold">UPDATE IP</td>
                    <td>#UPDATE_IP#</td>
                    <td class="txtbold">UPDATE DATE</td>
                    <td>#UPDATE_DATE# </td>
                </tr>
                <tr>
                    <td class="txtbold">RECORD EMP</td>
                    <td>#RECORD_EMP#</td>
                    <td class="txtbold">RECORD IP</td>
                    <td>#RECORD_IP#</td>
                    <td class="txtbold">RECORD DATE</td>
                    <td>#RECORD_DATE# </td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr>
                	<td colspan="7">
                    	<table>
                        	 <tr>
                                <td class="txtbold"><cf_get_lang_main no='1281.Seç'></td>
                                <td class="txtbold"><cf_get_lang_main no='1165.Sıra'></td>
                                <td class="txtbold"><cf_get_lang no='670.En'></td>
                                <td class="txtbold"><cf_get_lang no='818.Basket Adı'></td>
                                <td class="txtbold"><cf_get_lang no='819.Sistem Adı'></td>
                                <!---<td class="txtbold">B TYPE</td>
                                <td class="txtbold">IS READONLY</td>--->
                                
                            </tr>
                            <cfif GET_BASKET_ROWS_HISTORY.recordcount>
                                <cfloop query="GET_BASKET_ROWS_HISTORY">
                                <tr>
                                	<td>#IS_SELECTED#</td>
                                    <td>#LINE_ORDER_NO#</td>
                                    <td>#GENISLIK#</td>
                                    <td>#TITLE_NAME#</td>
                                    <td>#TITLE#</td>
                                    <!---<td>#B_TYPE#</td>
                                    <td>#IS_READONLY#</td>--->
                                   
                                </tr>
                                </cfloop>
                            </cfif>
                        </table>
                    </td>
                </tr>
            </table>	
        </cfoutput>
    </cfif>  
    
    
 </cf_popup_box>
 
