<cf_get_lang_set module_name="prod">
<cfset e_branch_id = listgetat(session.ep.user_location,2,'-')>
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_form_submitted" default=1>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="get_orders" datasource="#dsn3#">
        SELECT
        ISNULL(
            (
            SELECT     
                SPECT_MAIN_ID
            FROM         
                SPECTS
            WHERE     
                SPECT_VAR_ID = ORR.SPECT_VAR_ID
            )
            , 0) AS SPECT_MAIN_ID, 
            ORR.PRODUCT_ID, 
            ORR.ORDER_ROW_ID, 
            ORR.QUANTITY, 
            ORR.UNIT, 
            ORR.ORDER_ROW_CURRENCY, 
            ORR.SPECT_VAR_ID, 
            S.PROPERTY, 
            CASE 
                WHEN S.STOCK_CODE = '' THEN '_' ELSE ISNULL(S.STOCK_CODE, '_') 
                END 
            AS STOCK_CODE, 
            ORR.DELIVER_DATE AS ROW_DELIVER_DATE, 
            S.STOCK_ID, 
            S.PRODUCT_NAME, 
            S.IS_PURCHASE,
            O.ORDER_ID, 
            O.ORDER_NUMBER, 
            O.ORDER_HEAD, 
            O.ORDER_DATE, 
            O.DELIVERDATE, 
            O.RECORD_EMP, 
            O.COMPANY_ID, 
            O.CONSUMER_ID, 
            O.PROJECT_ID, 
            ORR.WRK_ROW_ID, 
            ORR.RESERVE_TYPE, 
            CAST(O.ORDER_DETAIL AS NVARCHAR(250)) AS ORDER_DETAIL, 
            ORR.SPECT_VAR_NAME, 
            ORR.PRODUCT_NAME2, 
            O.EMPLOYEE_ID
        FROM         
            ORDERS AS O INNER JOIN
            PRODUCT_UNIT AS PU INNER JOIN
            STOCKS AS S ON PU.PRODUCT_ID = S.PRODUCT_ID INNER JOIN
            ORDER_ROW AS ORR ON S.STOCK_ID = ORR.STOCK_ID AND S.PRODUCT_ID = ORR.PRODUCT_ID ON O.ORDER_ID = ORR.ORDER_ID
        WHERE    
            (O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0 OR O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) AND 
            O.ORDER_STATUS = 1 AND 
            ORR.ORDER_ROW_ID NOT IN
                                    (
                                    SELECT     
                                        POR.ORDER_ROW_ID
                                    FROM          
                                        PRODUCTION_ORDERS_ROW AS POR INNER JOIN
                                        PRODUCTION_ORDERS AS PO ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
                                    WHERE      
                                    POR.ORDER_ROW_ID IS NOT NULL AND 
                                    PO.IS_STAGE <> - 1
                                    ) AND 
            ORR.ORDER_ROW_CURRENCY = - 5
        ORDER BY 
            O.RECORD_DATE
    </cfquery>
	<cfset arama_yapilmali=0>
<cfelse>
	<cfset arama_yapilmali=1>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_orders.recordcount#'>

<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <cf_big_list_search title="#getLang('main',3213)#" collapsed="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list id="list_product_big_list">
	<thead>
     	<tr>
        	<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
            <th width="50"><cf_get_lang_main no='199.Sipariş'></th>
            <th><cf_get_lang_main no='330.Tarih'></th>
			<th><cf_get_lang no='474.Teslim'></th>
            <th><cf_get_lang_main no='107.Cari Hesap'></th>
            <th><cf_get_lang_main no='106.Stok Kodu'></th>
            <th><cf_get_lang_main no='245.Ürün'></th>
            <th><cf_get_lang_main no='235.spec'></th>
            <th><cf_get_lang no="395.Sipariş Açıklaması"></th>
			<th><cf_get_lang_main no='223.Miktar'></th>
			<th><cf_get_lang_main no='224.Birim'></th>
            <th></th>
   		</tr>
   	</thead>
  	<tbody>
    	<cfif get_orders.recordcount>
        	<cfset company_name_list =''>
			<cfset consumer_name_list =''>

        	<cfoutput query="get_orders">
                <cfif len(COMPANY_ID) and not listfind(company_name_list,COMPANY_ID)>
                    <cfset company_name_list = ListAppend(company_name_list,COMPANY_ID)>
                </cfif>
                <cfif len(CONSUMER_ID) and not listfind(consumer_name_list,CONSUMER_ID)>
                      <cfset consumer_name_list = ListAppend(consumer_name_list,CONSUMER_ID)>
                </cfif>
            </cfoutput>
           	<cfif len(company_name_list)>
				<cfset company_name_list=listsort(company_name_list,"numeric","ASC",",")>
                <cfquery name="get_company_name" datasource="#DSN#">
                    SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_name_list#) ORDER BY COMPANY_ID
                </cfquery>
                <cfset company_name_list = listsort(listdeleteduplicates(valuelist(get_company_name.COMPANY_ID,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(consumer_name_list)>
                <cfset consumer_name_list=listsort(consumer_name_list,"numeric","ASC",",")>
                <cfquery name="get_consumer_name" datasource="#DSN#">
                    SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME AS CONSUMER_NAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_name_list#) ORDER BY CONSUMER_ID
                </cfquery>
                <cfset consumer_name_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.CONSUMER_ID,',')),'numeric','ASC',',')>
            </cfif>

        	<cfoutput query="get_orders">
                <tr> 
                    <td width="35">#currentrow#</td>
                    <td nowrap="nowrap">#order_number#</td>
                    <td>#dateformat(order_date,'dd/mm/yyyy')#</td>
                    <td>#dateformat(deliverdate,'dd/mm/yyyy')#</td>
                    <td>
						<cfif len(COMPANY_ID)>
                            #get_company_name.FULLNAME[listfind(company_name_list,get_orders.COMPANY_ID,',')]#
                        <cfelseif len(CONSUMER_ID)>
                            #get_consumer_name.CONSUMER_NAME[listfind(consumer_name_list,get_orders.CONSUMER_ID,',')]#
                        </cfif>
                    </td>
                    <td style="mso-number-format:\@;"><a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','wide');" class="tableyazi">
                    #stock_code#</a>	
                    
                    </td>
                    <td>#product_name# #property#</td>
                    <td>
                    	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect&id=#SPECT_VAR_ID#&stock_id=#stock_id#','list');" class="tableyazi">
							#SPECT_MAIN_ID#-#spect_var_id#
						</a>
                    </td>
                    <td>#product_name2#</td>
                    
                    <td style="text-align:right;">#tlformat(quantity)#</td>
					<td>#unit#</td>
                    <td>
                    	<cfif  IS_PURCHASE eq 1>
                    	</cfif>
                    </td>
                </tr>
            </cfoutput>
            <tfoot>
            	<tr>
                	<td colspan="12" style="text-align:right">
            		</td>
                </tr>
            </tfoot>
        <cfelse>
        	<tr> 
             	<td colspan="12" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
         	</tr>
        </cfif>
   	</tbody>
</cf_big_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">