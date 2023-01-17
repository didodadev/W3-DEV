<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.listing_type" default="#x_list_type#">
<cfparam name="attributes.page" default=1>
<cfsetting showdebugoutput="no">
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
			ISNULL(O.IS_INSTALMENT,0) IS_INSTALMENT,
			(ORR.QUANTITY* PU.MULTIPLIER) QUANTITY,
			PU.MAIN_UNIT UNIT,
			(ORR.QUANTITY -
			(SELECT 
				  ISNULL(SUM(SR.AMOUNT),0)
			FROM 
				  #dsn2_alias#.SHIP_ROW SR
			WHERE
				SR.WRK_ROW_RELATION_ID IS NOT NULL  AND
				(
					SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID OR 
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
			(	
				(
					O.PURCHASE_SALES = 1 AND
					O.ORDER_ZONE = 0
				 )  
				OR
				(	O.PURCHASE_SALES = 0 AND
					O.ORDER_ZONE = 1
				)
			) AND		
			S.STOCK_ID = ORR.STOCK_ID AND 
			S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
            <cfif isdefined("attributes.sid") and len(attributes.sid)>
				ORR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> AND
            <cfelse>
	            ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
            </cfif>
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
				O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#"> AND
			</cfif>
			<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
				O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#"> AND
			</cfif>
			<cfif isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
				O.ORDER_ID NOT IN(SELECT OR_.ORDER_ID FROM ORDER_ROW OR_ WHERE OR_.ORDER_ROW_ID IN(#attributes.order_row_id#)) AND
			</cfif>
			ORR.ORDER_ROW_CURRENCY NOT IN(-9,-10,-3,-8)
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
				(
				(O.CONSUMER_ID IS NULL AND O.COMPANY_ID IS NULL) 
				OR (O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				) AND
			</cfif>
		ORDER BY
			O.ORDER_DATE
	</cfquery>
<cfelse>
	<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
		SELECT
        	<cfif attributes.listing_type eq 1>
        		SUM(QUANTITY) QUANTITY,
            <cfelse>
            	DISTINCT QUANTITY,
            </cfif>
            ORDER_DATE,
            ORDER_ID,
            ORDER_NUMBER,
            PARTNER_ID,
            COMPANY_ID,
            CONSUMER_ID,
            SHIP_METHOD,
            ORDER_STAGE,
            IS_INSTALMENT,
            UNIT
            <cfif attributes.listing_type eq 2>
                ,ORDER_ROW_ID
                ,DELIVER_DEPT_ID
                ,LOCATION_ID
                ,DELIVERDATE
            <cfelse>
                ,DELIVER_DEPT_ID
                ,LOCATION_ID
                ,DELIVERDATE
            </cfif>
		FROM
		(
			SELECT
				O.ORDER_DATE,
				O.ORDER_ID,
				O.ORDER_NUMBER,
				O.PARTNER_ID,
				O.COMPANY_ID,
				O.CONSUMER_ID,
				O.SHIP_METHOD,
				O.ORDER_STAGE,
				ISNULL(O.IS_INSTALMENT,0) IS_INSTALMENT,
				PU.MAIN_UNIT UNIT
				<cfif attributes.listing_type eq 2>
					,OR_R.ORDER_ROW_ID
					,(OR_R.QUANTITY-ORR.STOCK_OUT) QUANTITY
					,ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) DELIVER_DEPT_ID
					,ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) LOCATION_ID
					,ISNULL(OR_R.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE
				<cfelse>
					,((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* PU.MULTIPLIER) QUANTITY
					,O.DELIVER_DEPT_ID
					,O.LOCATION_ID
					,O.DELIVERDATE
				</cfif>
			FROM
				STOCKS S,
				GET_ORDER_ROW_RESERVED ORR, 
				ORDERS O,
				PRODUCT_UNIT PU
				<cfif attributes.listing_type eq 2>
					,ORDER_ROW OR_R
				</cfif>
			WHERE
				O.RESERVED = 1 AND
				O.ORDER_STATUS = 1 AND
				ORR.ORDER_ID = O.ORDER_ID AND
				(	
					(
						O.PURCHASE_SALES = 1 AND
						O.ORDER_ZONE = 0
					 )  
					OR
					(	O.PURCHASE_SALES = 0 AND
						O.ORDER_ZONE = 1
					)
				) AND		
				S.STOCK_ID = ORR.STOCK_ID AND 
				S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
				(ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) > 0 AND <!--- tamamen kapatılmıs satırların gelmemesi icin eklendi --->
                <cfif isdefined("attributes.sid") and  len(attributes.sid)>
					ORR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> 
                <cfelse>
                	ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
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
				<cfif isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
					AND O.ORDER_ID NOT IN(SELECT OR_.ORDER_ID FROM ORDER_ROW OR_ WHERE OR_.ORDER_ROW_ID IN(#attributes.order_row_id#))
				</cfif>
				<cfif attributes.listing_type eq 2>
                AND OR_R.RESERVE_TYPE <> -4 
					AND O.ORDER_ID = OR_R.ORDER_ID
					AND ORR.STOCK_ID = OR_R.STOCK_ID
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
					(
					(O.CONSUMER_ID IS NULL AND O.COMPANY_ID IS NULL) 
					OR (O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					) AND
				</cfif>
			UNION ALL
			SELECT	
				O.ORDER_DATE,
				O.ORDER_ID,
				O.ORDER_NUMBER,
				O.PARTNER_ID,
				O.COMPANY_ID,
				O.CONSUMER_ID,
				O.SHIP_METHOD,
				O.ORDER_STAGE,
				ISNULL(O.IS_INSTALMENT,0) IS_INSTALMENT,
				PU.MAIN_UNIT UNIT 
				<cfif attributes.listing_type eq 2>
					,OR_R.ORDER_ROW_ID
					,(OR_R.QUANTITY-ORR.STOCK_OUT) QUANTITY
					,ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) DELIVER_DEPT_ID
					,ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) LOCATION_ID
					,ISNULL(OR_R.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE
				<cfelse>
					,((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*SR.AMOUNT_VALUE * PU.MULTIPLIER) QUANTITY
					,O.DELIVER_DEPT_ID
					,O.LOCATION_ID
					,O.DELIVERDATE
				</cfif>
			FROM
				STOCKS S,
				GET_ORDER_ROW_RESERVED ORR, 
				ORDERS O,
				SPECTS_ROW SR,
				PRODUCT_UNIT PU
				<cfif attributes.listing_type eq 2>
					,ORDER_ROW OR_R
				</cfif>
			WHERE
				SR.SPECT_ID = ORR.SPECT_VAR_ID AND
				SR.IS_SEVK=1 AND
				O.RESERVED = 1 AND
				O.ORDER_STATUS = 1 AND
				(	
					(
						O.PURCHASE_SALES = 1 AND
						O.ORDER_ZONE = 0
					 )  
					OR
					(	O.PURCHASE_SALES = 0 AND
						O.ORDER_ZONE = 1
					)
				) AND
				ORR.ORDER_ID = O.ORDER_ID AND
				SR.STOCK_ID = S.STOCK_ID AND
				S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
				(ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) > 0 AND
                <cfif isdefined("attributes.sid") and  len(attributes.sid)>
					SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> 
                <cfelse>
                	SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
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
				<cfif isdefined("attributes.order_row_id") and len(attributes.order_row_id)>
					AND O.ORDER_ID NOT IN(SELECT OR_.ORDER_ID FROM ORDER_ROW OR_ WHERE OR_.ORDER_ROW_ID IN(#attributes.order_row_id#))
				</cfif>
				<cfif attributes.listing_type eq 2>
                	AND OR_R.RESERVE_TYPE <> -4 
					AND O.ORDER_ID = OR_R.ORDER_ID
					AND ORR.STOCK_ID = OR_R.STOCK_ID
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
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
					(
					(O.CONSUMER_ID IS NULL AND O.COMPANY_ID IS NULL) 
					OR (O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					) AND
				</cfif>
		)T1
        <cfif attributes.listing_type eq 1>
            GROUP BY
                ORDER_DATE,
                ORDER_ID,
                ORDER_NUMBER,
                PARTNER_ID,
                COMPANY_ID,
                CONSUMER_ID,
                SHIP_METHOD,
                ORDER_STAGE,
                IS_INSTALMENT,
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cf_box title="#getLang('','Alınan Siparişler',34049)# : #get_product_name.PRODUCT_NAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif not isdefined('attributes.sid')>
		<cfform name="search_list_reserved" id="search_list_reserved" action="#request.self#?fuseaction=objects.popup_reserved_orders&taken=#attributes.taken#&pid=#attributes.pid#" method="post">
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
				<input type="hidden" name="dept_id" id="dept_id" value="<cfif isDefined('attributes.dept_id') and len(attributes.dept_id)><cfoutput>#attributes.dept_id#</cfoutput></cfif>" />
				<input type="hidden" name="loc_id" id="loc_id" value="<cfif isDefined('attributes.loc_id') and len(attributes.loc_id)><cfoutput>#attributes.loc_id#</cfoutput></cfif>" />
				<div class="form-group" id="item-keyword">	
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#">
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
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_list_reserved' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
	<cfelse>
		<cfset attributes.maxrows = get_order_list.recordcount>
	</cfif>
	<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.no'></th>
					<th><cf_get_lang dictionary_id='57519.cari Hesap'></th>
					<th><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
					<th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
					<th><cf_get_lang dictionary_id='58524.Depo Lokasyon'></th>							
					<cfif isdefined("attributes.is_from_stock")>
						<th style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='32777.Kümülatif Kalan'></th>
					<cfelse>
						<th><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
						<th><cf_get_lang dictionary_id='57756.Süreç'></th>
					</cfif>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='40163.Toplam Miktar'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_order_list.recordcount>
					<cfset order_stage_list=''>
					<cfset dept_id_list=''>
					<cfset partner_id_list = "">
					<cfset consumer_id_list = "">
					<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(order_stage) and not listfind(order_stage_list,order_stage)>
							<cfset order_stage_list=listappend(order_stage_list,order_stage)>
						</cfif>
						<cfif len(deliver_dept_id) and not listfind(dept_id_list,deliver_dept_id)>
							<cfset dept_id_list=listappend(dept_id_list,deliver_dept_id)>
						</cfif>
						<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
							<cfset partner_id_list=listappend(partner_id_list,partner_id)>
						</cfif>
						<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
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
						<cfif get_loc_detail.recordcount>
							<cfloop query="get_loc_detail">
								<cfset 'dep_loc_#department_id#_#location_id#' = '#department_head#-#comment#'>
							</cfloop>
						</cfif>
					</cfif>
					<cfif ListLen(partner_id_list)>
						<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PARTNER_LIST" datasource="#DSN#">
							SELECT
								C.NICKNAME,
								CP.PARTNER_ID,
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME
							FROM
								COMPANY C,
								COMPANY_PARTNER CP
							WHERE
								C.COMPANY_ID = CP.COMPANY_ID AND
								CP.PARTNER_ID IN (#partner_id_list#)
							ORDER BY
								CP.PARTNER_ID
						</cfquery>
						<cfset partner_id_list = ListSort(ListDeleteDuplicates(ValueList(get_partner_list.partner_id,",")),"numeric","asc",",")>
					</cfif>
					<cfif ListLen(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER_LIST" datasource="#DSN#">
							SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_list.consumer_id,",")),"numeric","asc",",")>
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
						<td colspan="8" class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'></td>                                
							<td align="right" style="text-align:right;">               
						<cfoutput>  #TlFormat(toplam_stok)#    </cfoutput>           
							</td>                              
					</tr>                
					<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
								<cfif is_instalment eq 1>
									<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#order_id#" class="tableyazi" target="_blank">#order_number#</a>
								<cfelse>	
									<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" class="tableyazi" target="_blank">#order_number#</a>
								</cfif>			  
							</td>
							<td><cfif Len(partner_id)>
									#get_partner_list.nickname[ListFind(partner_id_list,partner_id,',')]# - #get_partner_list.company_partner_name[ListFind(partner_id_list,partner_id,',')]# #get_partner_list.company_partner_surname[ListFind(partner_id_list,partner_id,',')]#
								<cfelseif Len(consumer_id)>
									#get_consumer_list.consumer_name[ListFind(consumer_id_list,consumer_id,',')]# #get_consumer_list.consumer_surname[ListFind(consumer_id_list,consumer_id,',')]#
								</cfif>
							</td>
							<td nowrap>#DateFormat(order_date,dateformat_style)#</td>
							<td nowrap>#DateFormat(deliverdate,dateformat_style)#</td>
							<td>
								<cfif isdefined('dep_loc_#deliver_dept_id#_#location_id#')>
									#Evaluate('dep_loc_#deliver_dept_id#_#location_id#')#
								</cfif>
							</td>                                    
							<cfif isdefined("attributes.is_from_stock")>
								<cfset toplam_kalan = toplam_kalan + kalan>
								<td  style="text-align:right;">#NumberFormat(kalan)#</td>
								<td  style="text-align:right;">#NumberFormat(toplam_kalan)#</td>
							<cfelse>
								<td align="left">
									<cfif len(ship_method)>
										<cfquery name="G_S" dbtype="query">
											SELECT * FROM GET_S WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_method#">
										</cfquery>
										#g_s.ship_method#
									</cfif>
								</td>
								<td><cfif len(order_stage)>#order_process_type.stage[listfind(order_stage_list,order_stage,',')]#</cfif></td>
							</cfif>
							<td  style="text-align:right;">#TlFormat(quantity)# #unit#</td>
							<td style="text-align:right;"><cfset toplam_stok = toplam_stok + QUANTITY> #TlFormat(toplam_stok)# #UNIT#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
					</tr>
				</cfif>
			</tbody>
			<cfoutput>
			<tfoot>
			<tr>
				<td colspan="8" width="%100px"><b><cf_get_lang dictionary_id='57492.Toplam'></b></td>
					<td style="text-align:right;">
					#TlFormat(toplam_stok)#</b>
					</td>
			</tr>
			</tfoot>
		</cfoutput>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres = attributes.fuseaction & "&taken=#attributes.taken#&pid=#attributes.pid#">
		<cfif len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.order_stage") and len(attributes.order_stage)>
			<cfset adres ="#adres#&order_stage=#attributes.order_stage#">
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