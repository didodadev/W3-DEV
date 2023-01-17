<!--- Sayfa Hem Stok Detayından Hemde ÜretimPlanlama=>Siparişler Sayfasından ajax ile çağırlıyor.Değişiklik yapılırken kontrol edilmelidir. --->
<!--- <cfsetting showdebugoutput="no"> --->
<!--- Üretim Emirleri
		type = 1 ise beklenen emirler
		type = 2 ise reserve emirler  --->
 <cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="objects.popup_reserved_production_orders">        
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.prod_order_stage" default="">
<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
	SELECT
		TOP 1
        PRODUCT_NAME,
        PRODUCT_ID
     FROM
		STOCKS S
	WHERE
    	<cfif isdefined('attributes.pid')>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        <cfelse>
	        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
        </cfif>
     ORDER BY STOCK_ID ASC 
</cfquery>
<cfif isdefined('attributes.sid')>
	<cfset body_class = "body">
    <cfset table_class="pod_box">
    <cfset tr_class="header">
    <cfset td_class="txtboldblue">
	<cfset attributes.pid = GET_PRODUCT_NAME.PRODUCT_ID>
<cfelse>
	<cfset body_class = "color-list">
	<cfset table_class="color-border">
    <cfset tr_class="color-list">
    <cfset td_class="txtboldblue">
</cfif>
<cfquery name="get_process_type" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_pro_orders" datasource="#dsn3#">
	SELECT
		SUM(AMOUNT) AMOUNT,
		S.STOCK_ID,
		S.PRODUCT_ID,
		P_ORDER_ID,
		P_ORDER_NO,
		PROD_ORDER_STAGE,
		STATION_ID,
        STATUS,
        IS_DEMONTAJ
        <cfif is_date eq 1>
            ,START_DATE,
            FINISH_DATE
        </cfif> 
        <cfif isdefined('attributes.type') and attributes.type eq 2>
        <cfif attributes.report_type eq 2> 
        ,SPEC_MAIN_ID
        </cfif>
        </cfif>
	FROM
	(
	<cfif isdefined('attributes.type') and attributes.type eq 1>	<!--- beklenen --->
        SELECT
        	IS_DEMONTAJ,
			(QUANTITY) AS AMOUNT,
			STOCK_ID,
			P_ORDER_ID,
			P_ORDER_NO,
			PROD_ORDER_STAGE,
			STATION_ID,
            STATUS
            <cfif is_date eq 1>
                ,START_DATE,
                FINISH_DATE
            </cfif>
		FROM
			PRODUCTION_ORDERS
		WHERE
			IS_STOCK_RESERVED = 1 AND
			IS_DEMONTAJ=0
			<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
				AND PRODUCTION_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
			</cfif>
			<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
				AND PRODUCTION_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
			</cfif>
            AND STATUS=1
	UNION ALL
		SELECT
        	IS_DEMONTAJ,
			(POS.AMOUNT) AS AMOUNT,
			POS.STOCK_ID,
			PO.P_ORDER_ID,
			PO.P_ORDER_NO,
			PO.PROD_ORDER_STAGE,
			PO.STATION_ID,
            PO.STATUS
            <cfif is_date eq 1>
                ,PO.START_DATE,
                PO.FINISH_DATE
            </cfif>
		FROM
			PRODUCTION_ORDERS PO,
            PRODUCTION_ORDERS_STOCKS POS
		WHERE
			PO.IS_STOCK_RESERVED = 1 AND
            POS.P_ORDER_ID = PO.P_ORDER_ID AND
			ISNULL(POS.STOCK_ID,0)>0 AND
            POS.IS_SEVK <> 1 AND
			PO.IS_DEMONTAJ=1 
			<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
				AND PO.PRODUCTION_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
			</cfif>
			<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
				AND PO.PRODUCTION_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
			</cfif>
             AND PO.STATUS=1
	UNION ALL
		SELECT
        	0 IS_DEMONTAJ, 
			(P_ORD_R_R.AMOUNT)*-1 AS  AMOUNT,
			P_ORD_R_R.STOCK_ID,
			P_ORD.P_ORDER_ID,
			P_ORD.P_ORDER_NO,
			P_ORD.PROD_ORDER_STAGE,
			P_ORD.STATION_ID,
            P_ORD.STATUS
            <cfif is_date eq 1>
                ,P_ORD.START_DATE,
                P_ORD.FINISH_DATE
            </cfif>
		FROM
			PRODUCTION_ORDER_RESULTS P_ORD_R,
			PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
			PRODUCTION_ORDERS P_ORD
		WHERE
			P_ORD.IS_STOCK_RESERVED=1 AND
			P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
			P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
			P_ORD_R_R.TYPE=1 AND
			P_ORD_R.IS_STOCK_FIS=1
			<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
				AND P_ORD.PRODUCTION_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
			</cfif>
			<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
				AND P_ORD.PRODUCTION_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
			</cfif>
             AND P_ORD.STATUS=1
	<cfelse><!--- rezerve --->
			SELECT
            	IS_DEMONTAJ,
				(QUANTITY) AS AMOUNT,
				STOCK_ID,
				P_ORDER_ID,
				P_ORDER_NO,
				PROD_ORDER_STAGE,
				STATION_ID,
                STATUS
                <cfif is_date eq 1>
                    ,START_DATE,
                    FINISH_DATE
                </cfif>
                ,SPEC_MAIN_ID
			FROM
				PRODUCTION_ORDERS
			WHERE
				IS_STOCK_RESERVED = 1 AND
				IS_DEMONTAJ=1
				<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
					AND PRODUCTION_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
				</cfif>
				<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
					AND PRODUCTION_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
				</cfif>
                AND STATUS=1
		UNION ALL
			SELECT
            	IS_DEMONTAJ,                
								 CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										
						THEN
						 (
											(
                                            	SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 						
                         (((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(NULLIF(PO.QUANTITY,0),1)))) END AS AMOUNT,
				POS.STOCK_ID,
				PO.P_ORDER_ID,
				PO.P_ORDER_NO,
				PO.PROD_ORDER_STAGE,
				PO.STATION_ID,
                PO.STATUS
               <cfif is_date eq 1>
                    ,PO.START_DATE
                    ,PO.FINISH_DATE
               </cfif>
               ,POS.SPECT_MAIN_ID      
			FROM
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDERS_STOCKS POS
			WHERE
				PO.IS_STOCK_RESERVED = 1 AND
				POS.P_ORDER_ID = PO.P_ORDER_ID AND
				PO.IS_DEMONTAJ=0 AND
				PO.SPEC_MAIN_ID IS NOT NULL AND
				ISNULL(POS.STOCK_ID,0)>0 AND
				ISNULL(IS_FREE_AMOUNT,0) = 0
				<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
					AND PO.PRODUCTION_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
				</cfif>
				<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
					AND PO.PRODUCTION_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
				</cfif>
                AND PO.STATUS=1
	</cfif>		
	) T1,
	#dsn1_alias#.STOCKS S
	WHERE
		S.STOCK_ID=T1.STOCK_ID
		AND S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>AND ((P_ORDER_NO LIKE '%#attributes.keyword#%')
        	<cfif isdefined('attributes.type') and attributes.type eq 2>
       			 <cfif attributes.report_type eq 2>
                    OR SPEC_MAIN_ID LIKE '%#attributes.keyword#%' 
                 <CFELSE>
                 OR S.STOCK_ID LIKE '%#attributes.keyword#%'                             
                 </cfif>                 
            </cfif> )       
        </cfif>
		<cfif isdefined("attributes.prod_order_stage") and len(attributes.prod_order_stage)>AND PROD_ORDER_STAGE = #attributes.prod_order_stage#</cfif>
	GROUP BY 
		S.STOCK_ID,
		S.PRODUCT_ID,
		P_ORDER_ID,
		P_ORDER_NO,
		PROD_ORDER_STAGE,
		STATION_ID,
        STATUS,
        IS_DEMONTAJ
        <cfif is_date eq 1>
            ,START_DATE,
            FINISH_DATE
        </cfif> 
         <cfif isdefined('attributes.type') and attributes.type eq 2>
        <cfif attributes.report_type eq 2>
        ,SPEC_MAIN_ID 
        </cfif>
        </cfif>
     ORDER BY 
     	<cfif is_date eq 1>
            START_DATE    
        <cfelse>
        	P_ORDER_ID
        </cfif>
</cfquery>
<cfset toplam_stok = 0>
<cfparam name="attributes.totalrecords" default='#get_pro_orders.recordcount#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif len(attributes.pid)>
	<cfset url_str = "#url_str#&pid=#attributes.pid#">
</cfif>
<cfif len(attributes.type)>
	<cfset url_str = "#url_str#&type=#attributes.type#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.prod_order_stage)>
	<cfset url_str = "#url_str#&prod_order_stage=#attributes.prod_order_stage#">
</cfif>

<cfsavecontent variable="head_">
	<cfif attributes.type eq 1><cf_get_lang dictionary_id='58119.Beklenen'><cfelse><cf_get_lang dictionary_id='40225.Reserve'></cfif>&nbsp;<cf_get_lang dictionary_id='33440.Üretim Emirleri'>
</cfsavecontent>
<cf_box title="#head_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif not isdefined('attributes.sid')>
		<cfform name="search_list" action="#request.self#?fuseaction=objects.popup_reserved_production_orders&type=#attributes.type#&pid=#attributes.pid#" method="post">
			<cf_box_search more="0">
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">	
				<div class="form-group">			
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group">
					<select name="prod_order_stage" id="prod_order_stage">
						<option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
						<cfoutput query="get_process_type">
						<option value="#process_row_id#"<cfif isdefined('attributes.prod_order_stage') and attributes.prod_order_stage eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<cfif isdefined('attributes.type') and attributes.type eq 2>
					<div class="form-group">
						<select name="report_type" id="report_type">
							<option value="1" <cfif attributes.report_type eq 1> selected</cfif>><cf_get_lang dictionary_id='45555.Stok Bazında'></option>
							<option value="2" <cfif attributes.report_type eq 2> selected</cfif>><cf_get_lang dictionary_id='60170.Spec Bazında'></option>
						</select>
					</div>
				</cfif>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_list' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
	<cfelse>
		<cfset attributes.maxrows = get_pro_orders.recordcount>
	</cfif>
	<cf_grid_list>
		<thead>
			<tr class="<cfoutput>#tr_class#</cfoutput>">
				<th colspan="<cfif is_date eq 1>8<cfelse>6</cfif>" height="22">
					<cfif isdefined('attributes.sid')><cf_get_lang dictionary_id='60171.Beklenen Üretim'>-&nbsp;<div style="float:right;margin-top:-15;"><a href="javascript://" onClick="gizle(show_rezerved_prod_detail<cfoutput>#attributes.row_id#</cfoutput>);"><img style="cursor:pointer;" src="images/pod_close.gif"></a></div></cfif>
					<cfoutput>#get_product_name.product_name#</cfoutput>
				</th>
			</tr>
			<tr>
				<th width="75"><cf_get_lang dictionary_id='29474.Emir No'></th>
				<th width="80"><cf_get_lang dictionary_id='58834.İstasyon'></th>
				<th width="90"><cf_get_lang dictionary_id='58859.Süreç'></th>
				<cfif isdefined('attributes.type') and attributes.type eq 2>
					<cfif attributes.report_type eq 1>
					<th width="75"><cf_get_lang dictionary_id='57452.Stok'> <cf_get_lang dictionary_id ='58527.ID'></th>
					</cfif>
				</cfif>
				<cfif isdefined('attributes.type') and attributes.type eq 2>
					<cfif attributes.report_type eq 2>
					<th width="75"><cf_get_lang dictionary_id='54850.Spec ID'></th>
					</cfif>
				</cfif>			
				<cfif is_date eq 1>
					<th style="text-align:left; width:90px"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
					<th style="text-align:left; width:70px"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				</cfif>
				<th width="50"  style="text-align:left; width:25px"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th width="50" style="text-align:left; width:25px"><cf_get_lang dictionary_id='40163.Toplam Miktar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_pro_orders.recordcount>
				<cfset prod_order_stage_list = "">
				<cfset station_id_list = "">
				<cfoutput query="get_pro_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(prod_order_stage) and not listfind(prod_order_stage_list,prod_order_stage)>
						<cfset prod_order_stage_list=listappend(prod_order_stage_list,prod_order_stage)>
					</cfif>
					<cfif len(station_id) and not listfind(station_id_list,station_id)>
						<cfset station_id_list=listappend(station_id_list,station_id)>
					</cfif>
				</cfoutput>
				<cfif len(prod_order_stage_list)>
					<cfset prod_order_stage_list=listsort(prod_order_stage_list,"numeric","ASC",",")>
					<cfquery name="process_type" datasource="#dsn#">
						SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#prod_order_stage_list#) ORDER BY PROCESS_ROW_ID
					</cfquery>
				</cfif>
				<cfif len(station_id_list)>
					<cfset station_id_list=listsort(station_id_list,"numeric","ASC",",")>
					<cfquery name="get_workstation" datasource="#dsn3#">
						SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID IN (#station_id_list#) ORDER BY STATION_ID
					</cfquery>
				</cfif>
				<cfif attributes.totalrecords gt attributes.maxrows>
					<cfif attributes.page neq 1>
						<cfset max_ = (attributes.page-1)*attributes.maxrows>
						<cfoutput query="get_pro_orders" startrow="1" maxrows="#max_#">					
						<cfif amount gt 0>					
							<cfset toplam_stok = toplam_stok + amount>	
						</cfif>											
						</cfoutput>
					</cfif>
				</cfif>		
				<tr>
					<td colspan="<cfif attributes.type eq 1 and is_date eq 1>6<cfelseif attributes.type eq 1 and is_date eq 0>4<cfelseif attributes.type eq 2 and is_date eq 1>7<cfelse>5</cfif>" class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'></td>                                
						<td align="right" style="text-align:left;">               
					<cfoutput>  #TlFormat(toplam_stok)#    </cfoutput>           
						</td>                              
				</tr>    
				<cfparam name="attributes.toplam" default="0">
				<cfoutput query="get_pro_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif amount gt 0>
						<tr>
							<td nowrap><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#p_order_id#" target="_blank" class="tableyazi">#p_order_no#</a></td>
							<td nowrap><cfif len(station_id)>#get_workstation.station_name[listfind(station_id_list,station_id,',')]#</cfif></td>
							<td nowrap><cfif len(prod_order_stage)>#process_type.stage[listfind(prod_order_stage_list,prod_order_stage,',')]#</cfif></td>
							<cfif isdefined('attributes.type') and attributes.type eq 2>
								<cfif attributes.report_type eq 1>
								<td width="65">#get_pro_orders.stock_id#</td>
								</cfif>
							</cfif>
							<cfif isdefined('attributes.type') and attributes.type eq 2>
								<cfif attributes.report_type eq 2>
									<td width="65">#SPEC_MAIN_ID#</td>
								</cfif>
							</cfif>                        
							<cfif is_date eq 1>
								<td>#dateformat(start_date,'dd/mm/yy')# #timeformat(start_date,timeformat_style)#</td>
								<td>#dateformat(finish_date,'dd/mm/yy')# #timeformat(finish_date,timeformat_style)#</td>
							</cfif>
							<td  nowrap style="text-align:left;">#TlFormat(amount)#</td>
							<td nowrap style="text-align:left;"><cfset toplam_stok = toplam_stok + amount> #TlFormat(toplam_stok)#</td>
						</tr>
					</cfif>
				</cfoutput>
			<cfelse>
				<tr class="<cfoutput>#tr_class#</cfoutput>" height="20">
					<td colspan="<cfif is_date eq 1>8<cfelse>6</cfif>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
		<cfoutput>
			<tfoot>
				<tr>
					<td colspan="<cfif attributes.type eq 1 and is_date eq 1>6<cfelseif attributes.type eq 1 and is_date eq 0>4<cfelseif attributes.type eq 2 and is_date eq 1>7<cfelse>5</cfif>"><b><cf_get_lang dictionary_id='57492.Toplam'></b></td>
					<td align="left" style="text-align:left;"><b/>
					#TlFormat(toplam_stok)#
					</td>
				</tr>
			</tfoot>
		</cfoutput>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows and not isdefined('attributes.sid')>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#get_pro_orders.recordcount#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_reserved_production_orders#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
