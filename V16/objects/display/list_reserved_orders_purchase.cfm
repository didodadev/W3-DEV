<cfsetting showdebugoutput="NO"><!--- BURAYI KALDIRMAYIN SAYFA AJAX İLEDE ÇAĞIRILIYOR.--->
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.listing_type" default="#x_list_type#">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.page" default=1>
<cfif isdefined("attributes.is_from_stock")>
	<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
		SELECT
			O.ORDER_DATE,
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.PARTNER_ID,
			O.COMPANY_ID,
			O.CONSUMER_ID,
			O.DELIVERDATE,
			O.SHIP_METHOD,
			O.ORDER_STAGE,
			O.DELIVER_DEPT_ID,
			O.LOCATION_ID,
			(ORR.QUANTITY* PU.MULTIPLIER) QUANTITY,
			PU.MAIN_UNIT UNIT,
			(QUANTITY -
			(SELECT 
				  ISNULL(SUM(SR.AMOUNT),0)
			FROM 
				  #dsn2_alias#.SHIP_ROW SR
			WHERE
				SR.WRK_ROW_RELATION_ID IS NOT NULL  AND
				(
					SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID 
					OR 
					SR.WRK_ROW_RELATION_ID IN (SELECT IRR.WRK_ROW_ID FROM #dsn2_alias#.INVOICE_ROW IRR WHERE IRR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID)
				)
			)) KALAN
		FROM
			STOCKS S,
			ORDERS O,
			PRODUCT_UNIT PU,
			ORDER_ROW ORR
		WHERE
			O.ORDER_STATUS = 1 AND
			ORR.ORDER_ID = O.ORDER_ID AND
			O.PURCHASE_SALES = 0 AND
			O.ORDER_ZONE = 0 AND	
			S.STOCK_ID = ORR.STOCK_ID AND 
			S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
			ORR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> AND
			<cfif attributes.spect_var_id neq 0>
				ORR.SPECT_VAR_ID IN
				(
					SELECT 
						SPECTS.SPECT_VAR_ID
					FROM
						SPECTS
					WHERE
						SPECTS.SPECT_MAIN_ID = (SELECT SPP.SPECT_MAIN_ID FROM SPECTS SPP WHERE SPP.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_var_id#">)
				) AND
			</cfif>
			<cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>
				ORR.SPECT_VAR_ID IN
				(
					SELECT 
						SPECTS.SPECT_VAR_ID
					FROM
						SPECTS
					WHERE
						SPECTS.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">)
				) AND
			</cfif>
			<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
				AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
			</cfif>
			<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
				AND O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
			</cfif>
			ORR.ORDER_ROW_CURRENCY NOT IN (-9,-10,-3,-8)
		ORDER BY
			O.ORDER_DATE
	</cfquery>
<cfelse>
	<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
		SELECT
			<cfif attributes.listing_type neq 2>
				SUM(QUANTITY) QUANTITY,
				ORDER_ID,
				ORDER_NUMBER,
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				SHIP_METHOD,
				ORDER_STAGE,
				UNIT,
				DELIVER_DEPT_ID,
				LOCATION_ID,
				DELIVERDATE
			<cfelse>
				*
			</cfif>
		FROM
		(
            SELECT
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.PARTNER_ID,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.SHIP_METHOD,
                O.ORDER_STAGE,
                PU.MAIN_UNIT UNIT
                <cfif attributes.listing_type eq 2>
                    ,OR_R.ORDER_ROW_ID
                    ,SUM(OR_R.QUANTITY-ORR.STOCK_IN) QUANTITY
                    ,ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) DELIVER_DEPT_ID
                    ,ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) LOCATION_ID
                    ,ISNULL(OR_R.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE
                <cfelse>
                	,SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) QUANTITY 
                    ,O.DELIVER_DEPT_ID
                    ,O.LOCATION_ID
                    ,O.DELIVERDATE
                </cfif>
            FROM
                STOCKS S 
                INNER JOIN GET_ORDER_ROWS_RESERVED ORR ON S.STOCK_ID = ORR.STOCK_ID 
                INNER JOIN ORDERS O ON ORR.ORDER_ID = O.ORDER_ID
                <cfif attributes.listing_type eq 2>
                INNER JOIN ORDER_ROW OR_R ON OR_R.ORDER_ID = O.ORDER_ID AND ORR.STOCK_ID = OR_R.STOCK_ID
                </cfif>
                INNER JOIN PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                <cfif isdefined('attributes.nosale_order_location')>
                    INNER JOIN #dsn_alias#.STOCKS_LOCATION SL ON O.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND O.LOCATION_ID = SL.LOCATION_ID
                </cfif>
            WHERE
                <cfif attributes.listing_type eq 2>
					OR_R.WRK_ROW_ID = ORR.ORDER_WRK_ROW_ID AND
				</cfif>
                O.RESERVED = 1 AND
                O.ORDER_STATUS = 1 AND
                O.PURCHASE_SALES = 0 AND
                O.ORDER_ZONE = 0 AND
                 <cfif attributes.listing_type eq 2>
               OR_R.RESERVE_TYPE <> -3 AND
               OR_R.ORDER_ROW_CURRENCY NOT IN(-9,-10,-8,-3) AND
           		</cfif>
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) > 0 AND
                ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                <cfif isdefined('attributes.nosale_order_location')>
                    AND O.DELIVER_DEPT_ID IS NOT NULL 
                    <cfif attributes.nosale_order_location eq 1><!--- satış yapılamaz lokasyondaki siparişler --->
                        AND SL.NO_SALE = 1
                    <cfelse>
                        AND SL.NO_SALE = 0
                    </cfif>
                </cfif>
                <cfif len(attributes.keyword)>
                	AND O.ORDER_NUMBER LIKE  '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
                </cfif>
                <cfif len(attributes.order_stage)>
                	AND O.ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_stage#"> 
                </cfif>
                <cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>
                	AND	ORR.SPECT_VAR_ID IN
                    (
                        SELECT 
                            SPECTS.SPECT_VAR_ID
                        FROM
                            SPECTS
                        WHERE
                            SPECTS.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">
                    ) 
                </cfif>
                <cfif attributes.listing_type eq 2>
                    <cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
                        AND ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
                    </cfif>
                    <cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
                        AND ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
                    </cfif>
                <cfelse>
                    <cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
                        AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
                    </cfif>
                    <cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
                        AND O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
                    </cfif>
                </cfif>
            GROUP BY            	
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.PARTNER_ID,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.SHIP_METHOD,
                O.ORDER_STAGE,
                PU.MAIN_UNIT
                <cfif attributes.listing_type eq 2>
                    ,OR_R.ORDER_ROW_ID
                    ,ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID)
                    ,ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID)
                    ,ISNULL(OR_R.DELIVER_DATE,O.DELIVERDATE)
                <cfelse>
                    ,O.DELIVER_DEPT_ID
                    ,O.LOCATION_ID
                    ,O.DELIVERDATE
                </cfif>            	   
        	UNION ALL
            SELECT
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.PARTNER_ID,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.SHIP_METHOD,
                O.ORDER_STAGE,
                PU.MAIN_UNIT UNIT
                <cfif attributes.listing_type eq 2>
                    ,OR_R.ORDER_ROW_ID
                    ,SUM(OR_R.QUANTITY-ORR.STOCK_IN) QUANTITY
                    ,ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) DELIVER_DEPT_ID
                    ,ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) LOCATION_ID
                    ,ISNULL(OR_R.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE
                <cfelse>
                    ,O.DELIVER_DEPT_ID
                    ,SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) QUANTITY
                    ,O.LOCATION_ID
                    ,O.DELIVERDATE
                </cfif>
            FROM
                STOCKS S 
                INNER JOIN SPECTS_ROW SR ON SR.STOCK_ID = S.STOCK_ID
                INNER JOIN GET_ORDER_ROWS_RESERVED ORR ON SR.SPECT_ID = ORR.SPECT_VAR_ID
                INNER JOIN ORDERS O ON ORR.ORDER_ID = O.ORDER_ID 
                <cfif attributes.listing_type eq 2>
                INNER JOIN ORDER_ROW OR_R ON O.ORDER_ID = OR_R.ORDER_ID AND ORR.STOCK_ID = OR_R.STOCK_ID 
                </cfif>
                INNER JOIN PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID                
                <cfif isdefined('attributes.nosale_order_location')>
                    INNER JOIN #dsn_alias#.STOCKS_LOCATION SL ON O.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND O.LOCATION_ID = SL.LOCATION_ID
                </cfif>
             WHERE
                <cfif attributes.listing_type eq 2>
					OR_R.WRK_ROW_ID = ORR.ORDER_WRK_ROW_ID AND
				</cfif>
                SR.IS_SEVK = 1 AND
                O.RESERVED = 1 AND
                O.ORDER_STATUS = 1 AND
                O.PURCHASE_SALES = 0 AND
                O.ORDER_ZONE = 0 AND
                <cfif attributes.listing_type eq 2>
                OR_R.RESERVE_TYPE <> -3 AND
               	OR_R.ORDER_ROW_CURRENCY NOT IN(-9,-10,-8,-3) AND
           		</cfif>
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) > 0 AND
                SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
                <cfif isdefined('attributes.nosale_order_location')>
                    AND O.DELIVER_DEPT_ID IS NOT NULL 
                    <cfif attributes.nosale_order_location eq 1><!--- satış yapılamaz lokasyondaki siparişler --->
                        AND SL.NO_SALE = 1
                    <cfelse>
                        AND SL.NO_SALE = 0
                    </cfif>
                </cfif>
				<cfif len(attributes.keyword)>
                    AND O.ORDER_NUMBER LIKE  '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
                </cfif>
                <cfif len(attributes.order_stage)>
                    AND O.ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_stage#"> 
                </cfif>
                <cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>
                    AND	ORR.SPECT_VAR_ID IN
                    (
                        SELECT 
                            SPECTS.SPECT_VAR_ID
                        FROM
                            SPECTS
                        WHERE
                            SPECTS.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">
                    ) 
                </cfif>
                <cfif attributes.listing_type eq 2>
                    <cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
                        AND ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
                    </cfif>
                    <cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
                        AND ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
                    </cfif>
                <cfelse>
                    <cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
                        AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
                    </cfif>
                    <cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
                        AND O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
                    </cfif>
                </cfif>
            GROUP BY
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.PARTNER_ID,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.SHIP_METHOD,
                O.ORDER_STAGE,
                PU.MAIN_UNIT
                <cfif attributes.listing_type eq 2>
                    ,OR_R.ORDER_ROW_ID
                    ,ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID)
                    ,ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID)
                    ,ISNULL(OR_R.DELIVER_DATE,O.DELIVERDATE)
                <cfelse>
                    ,O.DELIVER_DEPT_ID
                    ,O.LOCATION_ID
                    ,O.DELIVERDATE
                </cfif>   
		)T1
		<cfif attributes.listing_type neq 2>
            GROUP BY
                ORDER_ID,
                ORDER_NUMBER,
                PARTNER_ID,
                COMPANY_ID,
                CONSUMER_ID,
                SHIP_METHOD,
                ORDER_STAGE,
                UNIT,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                DELIVERDATE
        </cfif>
        ORDER BY
            DELIVERDATE
	</cfquery>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_order_list.recordcount#>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset sayac = 0 >
<cfset toplam_stok = 0>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfsavecontent variable="is_closable"><cfif not isdefined('attributes.sid')>0<cfelse>1</cfif></cfsavecontent>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='58119.Beklenen'> <cf_get_lang dictionary_id='45228.Siparişler'></cfsavecontent>
<cf_box closable= "#is_closable#" id="list_order_comp_det#attributes.row_id#" title="#title# - #get_product_name.PRODUCT_NAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif not isdefined('attributes.sid')>
        <cfform name="search_reserved_orders" id="search_reserved_orders" action="#request.self#?fuseaction=objects.popup_reserved_orders&taken=#attributes.taken#&pid=#attributes.pid#" method="post">
            <cf_box_search more="0">
                <input type="hidden" name="nosale_order_location" id="nosale_order_location" value="<cfif isDefined('attributes.nosale_order_location') and len(attributes.nosale_order_location)><cfoutput>#attributes.nosale_order_location#</cfoutput></cfif>" />
                <input type="hidden" name="dept_id" id="dept_id" value="<cfif isDefined('attributes.dept_id') and len(attributes.dept_id)><cfoutput>#attributes.dept_id#</cfoutput></cfif>" />
                <input type="hidden" name="loc_id" id="loc_id" value="<cfif isDefined('attributes.loc_id') and len(attributes.loc_id)><cfoutput>#attributes.loc_id#</cfoutput></cfif>" />
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='33419.Verilen Siparişler'></cfsavecontent>
                <div class="form-group" id="item-keyword">	
                    <cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
                </div>
                <div class="form-group" id="item-order_stage">
                    <select name="order_stage" id="order_stage">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_process_type">
                            <option value="#process_row_id#"<cfif attributes.order_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-listing_type">
                    <select name="listing_type" id="listing_type">
                        <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                        <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_reserved_orders' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
    <cfelse>
        <cfset attributes.maxrows = get_order_list.recordcount>
    </cfif>

    <cf_grid_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='57487.no'></th>
                <th><cf_get_lang dictionary_id='57519.cari Hesap'></th>
                <cfif isdefined("attributes.is_from_stock")>
                    <th><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
                <cfelse>
                    <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                </cfif>
                <th><cf_get_lang dictionary_id='58524.Depo Lokasyon'></th>
                
                <cfif isdefined("attributes.is_from_stock")>
                    <th class="text-right"><cf_get_lang dictionary_id='58444.Kalan'></th>
                    <th class="text-right"><cf_get_lang dictionary_id='32777.Kümülatif Kalan'></th>
                <cfelse>
                    <th><cf_get_lang dictionary_id='29500.Sevk Yönetmi'></th>
                    <th align="left"><cf_get_lang dictionary_id='58859.Süreç'></th>
                </cfif>  
                <th class="text-right"><cf_get_lang dictionary_id='57635.miktar'></th>
                <th class="text-right" nowrap="nowrap"><cf_get_lang dictionary_id='40163.Toplam Miktar'></th>                          
                
            </tr>
        </thead>
        <tbody>             
            <cfif get_order_list.recordcount>
                <cfset order_stage_list=''>
                <cfset dept_id_list=''>                                                      
                <cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">                           
                    <cfif len(order_stage) and not listfind(order_stage_list,order_stage)>
                        <cfset order_stage_list=listappend(order_stage_list,order_stage)>
                    </cfif>
                    <cfif len(DELIVER_DEPT_ID) and not listfind(dept_id_list,DELIVER_DEPT_ID)>
                        <cfset dept_id_list=listappend(dept_id_list,DELIVER_DEPT_ID)>
                    </cfif>
                </cfoutput>
                <cfif len(order_stage_list)>
                    <cfset order_stage_list=listsort(order_stage_list,"numeric","ASC",",")>
                    <cfquery name="ORDER_PROCESS_TYPE" datasource="#DSN#">
                        SELECT
                            STAGE,
                            PROCESS_ROW_ID
                        FROM
                            PROCESS_TYPE_ROWS
                        WHERE
                            PROCESS_ROW_ID IN(#order_stage_list#)
                        ORDER BY
                            PROCESS_ROW_ID
                    </cfquery>
                </cfif>
                <cfif listlen(dept_id_list)>
                    <cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_LOC_DETAIL" datasource="#DSN#">
                        SELECT 
                            (SELECT D.DEPARTMENT_HEAD FROM DEPARTMENT D WHERE D.DEPARTMENT_ID = SL.DEPARTMENT_ID) AS DEPARTMENT_HEAD,
                            SL.DEPARTMENT_ID,
                            SL.COMMENT,
                            SL.LOCATION_ID
                        FROM 
                            STOCKS_LOCATION SL
                        WHERE
                            DEPARTMENT_ID IN (#dept_id_list#)	
                    </cfquery>
                    <cfif GET_LOC_DETAIL.recordcount>
                        <cfloop query="GET_LOC_DETAIL">
                            <cfset 'dep_loc_#DEPARTMENT_ID#_#LOCATION_ID#' = '#DEPARTMENT_HEAD#-#COMMENT#'>
                        </cfloop>
                    </cfif>
                </cfif>
                <cfset toplam_kalan = 0>         
                <cfif attributes.totalrecords gt attributes.maxrows>
                    <cfif attributes.page neq 1>
                        <cfset max_ = (attributes.page-1)*attributes.maxrows>
                        <cfoutput query="get_order_list" startrow="1" maxrows="#max_#">					
                                    <cfset toplam_stok = toplam_stok + QUANTITY>						
                        </cfoutput>
                    </cfif>
                </cfif>		
                <tr>
                    <td colspan="7" class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'></td>                                
                        <td class="text-right">               
                    <cfoutput>  #tlFormat(toplam_stok)#    </cfoutput>           
                        </td>                              
                </tr>                     
                <cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                
                    <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='#body_class#';" class="#body_class#">
                        <td height="22" nowrap>
                            <a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi" target="_blank">#order_number#</a>
                        </td>
                        <cfif len(get_order_list.partner_id)>
                            <td>#get_par_info(get_order_list.partner_id,0,0,0)#</td>
                        <cfelseif len(get_order_list.company_id)>
                            <td>#get_par_info(get_order_list.company_id,1,0,0)#</td>				
                        <cfelseif len(consumer_id)>
                            <td>#get_cons_info(consumer_id,1,0)#</a></td>
                        </cfif>
                        <cfif isdefined("attributes.is_from_stock")>
                            <td nowrap>#dateformat(ORDER_DATE,dateformat_style)#</td>
                        <cfelse>
                            <td nowrap>#dateformat(DELIVERDATE,dateformat_style)#</td>
                        </cfif>
                        <td>
                            <cfif isdefined('dep_loc_#DELIVER_DEPT_ID#_#LOCATION_ID#')>
                                #Evaluate('dep_loc_#DELIVER_DEPT_ID#_#LOCATION_ID#')#
                            </cfif>
                        </td>
                        
                        <cfif isdefined("attributes.is_from_stock")>
                            <cfset toplam_kalan = toplam_kalan + KALAN>
                            <td class="text-right">#numberformat(KALAN)#</td>
                            <td class="text-right">#numberformat(toplam_kalan)#</td>
                        <cfelse>
                            <td align="left">
                                <cfif len(SHIP_METHOD)>
                                    <cfquery name="g_s" dbtype="query">
                                        SELECT * FROM get_s WHERE SHIP_METHOD_ID=#SHIP_METHOD#
                                    </cfquery>
                                    #g_s.SHIP_METHOD#
                                </cfif>
                            </td>
                            <td nowrap align="left"><cfif len(ORDER_STAGE)>#order_process_type.stage[listfind(order_stage_list,ORDER_STAGE,',')]#</cfif></td>
                        </cfif>
                            <td class="text-center">#TlFormat(QUANTITY)# #UNIT#</td>
                        <td class="text-right"><cfset toplam_stok = toplam_stok + QUANTITY> #TlFormat(toplam_stok)# #UNIT#</td>
                        
                    </tr>                                
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                </tr>
            </cfif>
        </tbody>
        <cfoutput>
            <tfoot>
            <tr>
                <td colspan="7"><b><cf_get_lang dictionary_id='57492.Toplam'></b></td>
                    <td class="text-right"><b>
                    #TlFormat(toplam_stok)#
                    </td>
                </tr>
            </tfoot>
        </cfoutput>
    </cf_grid_list>

    <cfif attributes.totalrecords gt attributes.maxrows and not isdefined('attributes.sid')>
        <cfset adres = attributes.fuseaction & "&taken=#attributes.taken#&pid=#attributes.pid#">
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.order_stage") and len(attributes.order_stage)>
            <cfset adres ="#adres#&order_stage=#attributes.order_stage#">
        </cfif>
        <cfif isdefined("attributes.nosale_order_location") and len(attributes.nosale_order_location)>
            <cfset adres ="#adres#&nosale_order_location=#attributes.nosale_order_location#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#"
            isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cfif>
</cf_box>
