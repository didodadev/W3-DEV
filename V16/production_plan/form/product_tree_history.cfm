<cfset stock_id_ary=''>
<cfset plus=0>
<cfquery name="HISTORY_DATE" datasource="#DSN3#">
	SELECT 
        DISTINCT(HISTORY_DATE) AS DATE,
        (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PRODUCT_TREE_HISTORY.HISTORY_EMP) AS UPDATE_NAME
    FROM 
    	PRODUCT_TREE_HISTORY 
    WHERE 
    	STOCK_ID=#attributes.stock_id# 
    ORDER BY 
    	HISTORY_DATE
	DESC
</cfquery>
<cfquery name="history_sub_product" datasource="#DSN3#">
	SELECT PRODUCT_TREE_ID 	FROM PRODUCT_TREE_HISTORY WHERE STOCK_ID=#attributes.stock_id# 
</cfquery>
<cfoutput query="history_sub_product">
	<cfscript>//query/get_phantom_product_list.cfm
		Relation_IDs(PRODUCT_TREE_ID,dsn3);
	</cfscript>
</cfoutput>
<cfquery name="PRODUCT_" datasource="#DSN3#">
	SELECT
		S.PRODUCT_NAME,
        S.STOCK_CODE,
		(SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =S.STOCK_ID) SPEC
    FROM
        STOCKS S,
        PRODUCT_UNIT PU
    WHERE
        PU.IS_MAIN =1 AND
        PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
        S.STOCK_ID = #attributes.stock_id#
</cfquery>
<cfquery name="GET_PRODUCT_TREE_HISTORY" datasource="#DSN3#">
	SELECT 
        PRODUCT_TREE_ID, 
        RELATED_ID, 
        PRODUCT_ID, 
        AMOUNT, 
		IS_PHANTOM,
        UNIT_ID, 
        STOCK_ID, 
        SPECT_MAIN_ID, 
        OPERATION_TYPE_ID, 
        RELATED_PRODUCT_TREE_ID, 
        MAIN_STOCK_ID, 
        UPDATE_IP,        
        SPECT_MAIN_ID AS m_SPECT_MAIN_ID_,
        (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =PRODUCT_TREE_HISTORY.STOCK_ID) SPECT_MAIN_ID_,  
        (SELECT PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID=PRODUCT_TREE_HISTORY.STOCK_ID) PRODUCT_NAME_,
        (SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PRODUCT_TREE_HISTORY.OPERATION_TYPE_ID) AS OPERATION_TYPE,
        (SELECT OPERATION_CODE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID=PRODUCT_TREE_HISTORY.OPERATION_TYPE_ID) AS OPERATION_CODE,
        (SELECT PRODUCT.PRODUCT_NAME FROM PRODUCT,STOCKS WHERE PRODUCT.PRODUCT_ID=STOCKS.PRODUCT_ID AND STOCKS.STOCK_ID=PRODUCT_TREE_HISTORY.RELATED_ID) AS P_PRODUCT_NAME,
        (SELECT PRODUCT.PRODUCT_CODE FROM PRODUCT,STOCKS WHERE PRODUCT.PRODUCT_ID=STOCKS.PRODUCT_ID AND STOCKS.STOCK_ID=PRODUCT_TREE_HISTORY.RELATED_ID) AS P_PRODUCT_CODE,
        (SELECT MAIN_UNIT FROM PRODUCT_UNIT,PRODUCT,STOCKS WHERE PRODUCT.PRODUCT_ID=STOCKS.PRODUCT_ID AND STOCKS.STOCK_ID=PRODUCT_TREE_HISTORY.RELATED_ID AND PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID AND PRODUCT_UNIT.IS_MAIN=1) AS MAIN_UNIT_, 
	 	RECORD_DATE,
        UPDATE_DATE,
        HISTORY_DATE
    FROM 
        PRODUCT_TREE_HISTORY 
    WHERE 
        STOCK_ID =#attributes.stock_id# 
       	<cfif isdefined('stock_id_ary') and len(stock_id_ary)>OR PRODUCT_TREE_ID IN (#stock_id_ary#)</cfif> 
</cfquery>
<cf_box title="#getLang('','Tarihçe','57473')#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif GET_PRODUCT_TREE_HISTORY.recordcount>
    <cfset temp_ = 0>
        <cfoutput query="history_date">
         <cfset temp_ = temp_ +1>
             <cfquery name="history_date_product1" dbtype="query">
                SELECT * FROM GET_PRODUCT_TREE_HISTORY WHERE HISTORY_DATE='#HISTORY_DATE.DATE#'
             </cfquery>
             <CFSET plus=currentrow>
             <cfif plus neq history_date.recordcount>
                 <cfquery name="history_date_product2" dbtype="query">
                    SELECT UPDATE_DATE,PRODUCT_TREE_ID,* FROM GET_PRODUCT_TREE_HISTORY WHERE HISTORY_DATE='#HISTORY_DATE.DATE[plus+1]#' 
                 </cfquery>
            </cfif>
            <cf_seperator id="history_#temp_#" header="#dateformat(history_date.date,dateformat_style)# (#timeformat(history_date.date,timeformat_style)#) - #history_date.update_name#" is_closed="1">
            <table id="history_#temp_#" style="display:none;" height="10%">
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='58221.Ürün Adı'>:</td>
                    <td nowrap="nowrap">#PRODUCT_.STOCK_CODE# #PRODUCT_.PRODUCT_NAME# </td>
                    <td style="width:5px"></td>
                    <td class="txtbold"><cf_get_lang dictionary_id="34299.Spec">:</td>
                    <td nowrap="nowrap">#PRODUCT_.SPEC#</td>
                    <td style="width:50%"></td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57891.Güncelleyen'>:</td>
                    <td>#history_date.update_name#</td>
                    <td style="width:5px"></td>
                    <td class="txtbold"><cf_get_lang dictionary_id="30631.Tarih">:</td>
                    <td nowrap="nowrap">
                        <cfif len(history_date.date)>
                            <cfset temp_update = date_add('h',session.ep.time_zone,history_date.date)>
                            #dateformat(temp_update,dateformat_style)# (#timeformat(temp_update,timeformat_style)#)
                        </cfif>
                    </td>
                    <td></td>
                </tr>
                
                 <cfloop query="history_date_product1">
						<cfif isdefined('history_date_product2')>
							<cfquery name="_TREE_ID" dbtype="query">
								SELECT UPDATE_DATE FROM history_date_product2 WHERE PRODUCT_TREE_ID=#PRODUCT_TREE_ID# 
							</cfquery>
						</cfif>
                
                <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id ='36377.Operasyon Kodu'></td>
                        <td>#operation_code#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='29419.Operasyon'><cf_get_lang dictionary_id ='57897.Adı'></td>
                         <td>#operation_type#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='58800.Ürün Kodu'></td>
                        <td>#p_product_code#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='58221.Ürün Adı'></td>
                        <td>#p_product_name#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='57647.Spec'></td>
                        <td>#m_spect_main_id_#</td>
                        <td class="txtbold" style="width:10px">P</td>
                        <td> <cfif IS_PHANTOM eq 1><img src="/images/enabled.gif"></cfif></td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='57635.Miktar'></td>
                        <td>#amount#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='57636.Birim'></td>
                        <td>#main_unit_#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id ='36317.Değişiklik'></td>
                        <td style="text-align:center; color:red; font-size:15px;">
                                <cfif isdefined('history_date_product2')  and (update_date neq _tree_id.update_date)><img src="/images/enabled.gif"><cfelse><strong>x</strong></cfif>
                            </td>
                    </tr>                              
              </cfloop>
            </table>
           <!--- <cf_medium_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='64.Operasyon Kodu'></th>
                        <th><cf_get_lang dictionary_id ='1622.Operasyon'><cf_get_lang dictionary_id ='485.Adı'></th>
                        <th><cf_get_lang dictionary_id ='1388.Ürün Kodu'></th>
                        <th><cf_get_lang dictionary_id ='809.Ürün Adı'></th>
                        <th><cf_get_lang dictionary_id ='235.Spec'></th>
                        <th style="width:10px">P</th>
                        <th><cf_get_lang dictionary_id ='223.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='224.Birim'></th>
                        <th><cf_get_lang dictionary_id ='4.Değişiklik'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="history_date_product1">
						<cfif isdefined('history_date_product2')>
							<cfquery name="_TREE_ID" dbtype="query">
								SELECT UPDATE_DATE FROM history_date_product2 WHERE PRODUCT_TREE_ID=#PRODUCT_TREE_ID# 
							</cfquery>
						</cfif>
                        <tr>
                            <td>#operation_code#</td>
                            <td>#operation_type#</td>
                            <td>#p_product_code#</td>
                            <td>#p_product_name#</td>
                            <td>#m_spect_main_id_#</td>
                            <td> <cfif IS_PHANTOM eq 1><img src="/images/enabled.gif"></cfif></td>
                            <td>#amount#</td>
                            <td>#main_unit_#</td>
                            <td style="text-align:center; color:red; font-size:15px;">
                                <cfif isdefined('history_date_product2')  and (update_date neq _tree_id.update_date)><img src="/images/enabled.gif"><cfelse><strong>x</strong></cfif>
                            </td>
                        </tr> 
                    </cfloop>
                </tbody>
            </cf_medium_list>--->	
        </cfoutput> 
	<cfelse>
    	<table>
            <tr>
                <td><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
            </tr>
        </table>
    </cfif>
</cf_box>
