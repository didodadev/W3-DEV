<STYLE TYPE="text/css">
.texttype{
font-family: Geneva, tahoma, arial, Helvetica, sans-serif;
}
</style>

<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.quality_type" default="">
<cfparam name="attributes.q_serial_no" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.controller_emp_id" default="">
<cfparam name="attributes.controller_emp" default="">
<cfparam name="attributes.pid" default="">
<cfif isDefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="pro_detail" datasource="#dsn3#">
		SELECT IS_SERIAL_NO FROM PRODUCT WHERE PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
</cfif>
<cfif isdefined('attributes.from_add_contol_page')>
	<!--- Kalite Ekleme Sayfasından Geliyorsa bu bölüme girer,bu kısım alt tarafta ilgili belgeye ait eklenen kaliteleri gösterir. --->
	<cfsetting showdebugoutput="no">
	<cf_get_lang_set module_name="prod">
	<cfset sum_control_amount = 0>
	<cfquery name="get_quality_list" datasource="#dsn3#">
		SELECT
			ORQ.OR_Q_ID,
			ORQ.Q_CONTROL_NO, 
			ORQ.SUCCESS_ID,
			ORQ.IS_REPROCESS,
			ORQ.IS_ALL_AMOUNT,
			ORQ.STOCK_ID,
			ORQ.PROCESS_ROW_ID,
			ORQ.CONTROL_AMOUNT,
			ORQ.CONTROL_DETAIL,
			ORQ.RECORD_DATE,
			ORQ.STAGE
		FROM 
			ORDER_RESULT_QUALITY ORQ 
		WHERE 
			ORQ.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id_#"> AND
			(
				(ORQ.PROCESS_CAT IN (76,811,171) AND ORQ.SHIP_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id_#">) OR
				(ORQ.PROCESS_CAT NOT IN (76,811,171) AND ORQ.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id_#">)
			)
	</cfquery>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="40"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th width="80"><cf_get_lang dictionary_id='36479.Kontrol No'></th>
				<th width="20"><cf_get_lang dictionary_id='36700.Kalite Sonucu'></th>
				<cfif pro_detail.IS_SERIAL_NO eq 1><th><cf_get_lang dictionary_id='57637.Seri No'></th></cfif>	
				<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<cfif not isDefined('attributes.is_upd_page')>
					<cfif get_quality_list.recordcount><th width="20"></th></cfif>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfset kalan_ = 0>
			<cfif get_quality_list.recordcount>
				<cfoutput query="get_quality_list">
					<cfquery name="get_stage" datasource="#dsn#">
						SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_quality_list.STAGE#">
					</cfquery>
					<cfquery name="get_serial" datasource="#dsn3#">
						SELECT QRR.SERIAL FROM ORDER_RESULT_QUALITY_ROW  QRR WHERE QRR.OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_quality_list.OR_Q_ID#">
					</cfquery>
					<tr>
						<td>#currentrow#</td>
						<td>#q_control_no#</td>
						<cfif isDefined('attributes.is_upd_page')>
							<td id="quality_rows#currentrow#" class="iconL" onClick="gizle_goster(quality_success_rows#currentrow#);gizle_goster(quality_result_show#currentrow#);gizle_goster(quality_result_hide#currentrow#);">
								<!-- sil -->
								<i class="fa fa-caret-right" id="quality_result_show#currentrow#" title="<cf_get_lang dictionary_id ='58596.Göster'>" alt="<cf_get_lang dictionary_id ='58596.Göster'>"></i>
								<i class="fa fa-caret-right" id="quality_result_hide#currentrow#" title="<cf_get_lang dictionary_id='58628.Gizle'>" alt="<cf_get_lang dictionary_id='58628.Gizle'>" style="display:none"></i>
								<!-- sil -->
								<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
								<cfset get_quality_success =get_queries.get_succes_name()>
								<cf_flat_list id="quality_success_rows#currentrow#" class="nohover" style="display:none;">
									<thead>
										<tr>
											<th width="150"><cf_get_lang dictionary_id='36700.Kalite Sonucu'></th>
											<th width="90" class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="get_quality_success">
											<tr>
												<td>
													#SUCCESS#
												</td>
												<td class="text-right">
													<cfquery name="get_succes_type" datasource="#dsn3#">
														SELECT ISNULL(AMOUNT,0) AMOUNT FROM ORDER_RESULT_QUALITY_SUCCESS_TYPE
														WHERE ORDER_RESULT_QUALITY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_quality_list.or_q_id#">
														AND SUCCESS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#SUCCESS_ID#">
													</cfquery>
													#get_succes_type.AMOUNT#
												</td>
											</tr>
										</cfloop>
									</tbody>
								</cf_flat_list>
							</td>
						</cfif>
						<cfif pro_detail.IS_SERIAL_NO eq 1><td>#get_serial.serial#</td></cfif>
						<td>#get_stage.stage#</td>
						<td>#control_detail#</td>
						<td align="center">#dateformat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)# </td>
						<td align="right" style="text-align:right;">#TLFormat(control_amount)#</td>
						<cfif not isDefined('attributes.is_upd_page')>
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=QualityControlDetails&is_box=1&or_q_id=#OR_Q_ID#')" ><i class="fa fa-pencil"></i></a></td>
						</cfif>
						<cfset sum_control_amount= sum_control_amount + control_amount>
					</tr>
					
				</cfoutput>
				</tbody>
					<cfif isdefined('attributes.from_add_contol_page')>
						<tfoot>
							<tr>
								<cfif not len(attributes.production_quantity)><cfset attributes.production_quantity= 0></cfif>
								<td colspan="9" class="txtbold" style="text-align:right;">
									<cfoutput>
										<cf_get_lang dictionary_id='36707.Kontrol Toplamı'> : #TLFORMAT(sum_control_amount)#
										-
										<cf_get_lang dictionary_id='58444.Kalan'>#TLFORMAT(attributes.production_quantity-sum_control_amount)#
										<cfset left=attributes.production_quantity-sum_control_amount>
										<input type="hidden" name="left_" id="left_" value="#left#">
									</cfoutput>
								</td>
							</tr>
						</tfoot>
					</cfif>
				</cfif>
		</tbody>
	</cf_grid_list>
	<cfif get_quality_list.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
		</div>
	</cfif>
<cfelse>
	<!--- Stok Yonetimi Kalite Islemleri Listeleme Sayfasi --->
	<cf_xml_page_edit fuseact="prod.list_quality_controls">
	<cf_get_lang_set module_name="prod">
	<cfparam name="attributes.process_id" default="">
	<cfparam name="attributes.related_success_id" default="">
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.employee" default="">
	<cfparam name="attributes.company_id" default="">
	<cfparam name="attributes.consumer_id" default="">
	<cfparam name="attributes.company" default="">
	<cfparam name="attributes.q_control_no" default="">
	<cfparam name="attributes.belge_no" default="">
	<cfparam name="attributes.group" default="">
	<cfparam name="attributes.date1" default="">
	<cfparam name="attributes.date2" default="">
	<cfparam name="attributes.stock_id" default="">
	<cfparam name="attributes.product_name" default="">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.sort_type" default="">
	<cfparam name="attributes.quality_stage" default="">

	<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
	<cfset get_succes_names =get_queries.get_succes_name()>
	<cfquery name="get_process_stage" datasource="#dsn#">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.popup_add_quality_control_report%">
		ORDER BY
			PTR.LINE_NUMBER
	</cfquery>
	<cfif get_succes_names.recordcount>
		<cfscript>
			for(xi=1;xi lte get_succes_names.recordcount;xi=xi+1)
			{
				'success_#get_succes_names.SUCCESS_ID[xi]#' = get_succes_names.SUCCESS[xi];
				'success_color_#get_succes_names.SUCCESS_ID[xi]#' = get_succes_names.QUALITY_COLOR[xi];
			}
		</cfscript>
	</cfif>
	<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
		<cf_date tarih="attributes.date2">
	<cfelse>
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.date2=''>
		<cfelse>
			<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih="attributes.date1">
	<cfelse>
		<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
			<cfset attributes.date1=''>
		<cfelse>
			<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
		</cfif>
	</cfif>
	<cfquery name="quality_control_type" datasource="#dsn3#">
		SELECT
			0 SORT_TYPE,
			'' AS RESULT_ID,
			TYPE_ID,
			#dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','QUALITY_CONTROL_TYPE','QUALITY_CONTROL_TYPE',NULL,NULL,QUALITY_CONTROL_TYPE) AS QUALITY_CONTROL_TYPE
		FROM
			QUALITY_CONTROL_TYPE
		WHERE
			TYPE_ID IN ( SELECT QUALITY_CONTROL_TYPE_ID FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID IS NOT NULL) 
	UNION ALL
		SELECT
			1 SORT_TYPE,
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW_ID RESULT_ID,
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID TYPE_ID,
			#dsn#.Get_Dynamic_Language(QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW_ID,'#session.ep.language#','QUALITY_CONTROL_ROW','QUALITY_CONTROL_ROW',NULL,NULL,QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW) AS QUALITY_CONTROL_TYPE
		FROM
			QUALITY_CONTROL_ROW,QUALITY_CONTROL_TYPE
		WHERE
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID = QUALITY_CONTROL_TYPE.TYPE_ID	
	UNION ALL		
		SELECT
			0 SORT_TYPE,
			'' AS RESULT_ID,
			TYPE_ID,
			#dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','QUALITY_CONTROL_TYPE','QUALITY_CONTROL_TYPE',NULL,NULL,QUALITY_CONTROL_TYPE) AS QUALITY_CONTROL_TYPE
		FROM
			QUALITY_CONTROL_TYPE
		WHERE
			TYPE_ID NOT IN ( SELECT QUALITY_CONTROL_TYPE_ID FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID IS NOT NULL) 
		ORDER BY
			TYPE_ID,SORT_TYPE 
	</cfquery>
	<cfif isdefined("attributes.is_filtre")>
		<cfquery name="GET_QUALITY_LIST" datasource="#dsn3#">
			SELECT
				*
			FROM
			(
				<cfif not Len(attributes.process_cat_id) or ListFind("76,811",attributes.process_cat_id)><!--- Mal Alım İrs. --->
				SELECT
					1 BLOCK_TYPE,
					ORQ.OR_Q_ID,
					ORQ.SUCCESS_ID,
					ORQ.Q_CONTROL_NO,
					ORQ.STAGE,
					SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
					TABLE1.AMOUNT QUANTITY,
					TABLE1.LOT_NO,
					TABLE1.STOCK_ID,
					TABLE1.COMPANY_ID,
					TABLE1.PARTNER_ID,
					TABLE1.CONSUMER_ID,
					TABLE1.LOCATION_IN LOCATION_IN,
					TABLE1.DEPARTMENT_IN DEPARTMENT_IN,
					TABLE1.LOCATION LOCATION_OUT,
					TABLE1.DELIVER_STORE_ID DEPARTMENT_OUT,
					TABLE1.SHIP_ID PROCESS_ID,
					TABLE1.SHIP_NUMBER PROCESS_NUMBER,
					TABLE1.SHIP_DATE PROCESS_DATE,
					TABLE1.PROCESS_CAT PROCESS_CAT,
					TABLE1.SHIP_ROW_ID AS PROCESS_ROW_ID,
					TABLE1.WRK_ROW_ID AS SHIP_WRK_ROW_ID,
					'' PR_ORDER_ROW_ID,
					'' PR_ORDER_ID
				FROM
					(
					SELECT
						SHIP_ROW.STOCK_ID,
						SHIP_ROW.AMOUNT,
						SHIP.SHIP_ID,
						SHIP.SHIP_NUMBER,
						SHIP.SHIP_DATE,
						SHIP.COMPANY_ID,
						SHIP.PARTNER_ID,
						SHIP.CONSUMER_ID,
						SHIP.LOCATION_IN LOCATION_IN,
						SHIP.DEPARTMENT_IN DEPARTMENT_IN,
						SHIP.LOCATION,
						SHIP.DELIVER_STORE_ID,
						SHIP_ROW.SHIP_ROW_ID,
						SHIP_ROW.WRK_ROW_ID,
                        SHIP_ROW.LOT_NO,
						ISNULL(SHIP.IS_SHIP_IPTAL,0) IS_SHIP_IPTAL,
						SHIP.SHIP_DATE AS FINISH_DATE,
						SHIP.SHIP_TYPE PROCESS_CAT
					FROM
						#dsn2_alias#.SHIP SHIP,
						#dsn2_alias#.SHIP_ROW SHIP_ROW
						LEFT JOIN STOCKS S ON S.STOCK_ID = SHIP_ROW.STOCK_ID
                        LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
					WHERE
						S.IS_QUALITY = 1 AND
						SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
						SHIP.SHIP_STATUS = 1 AND
                        (PRODUCT.QUALITY_START_DATE IS NULL OR SHIP.SHIP_DATE >= PRODUCT.QUALITY_START_DATE)
						<cfif len(attributes.process_cat_id)>
							AND SHIP.SHIP_TYPE = #attributes.process_cat_id#
						<cfelse>
							AND SHIP.SHIP_TYPE IN (76,811)
						</cfif>
						<cfif len(attributes.stock_id) and len(attributes.product_name)>
							AND SHIP_ROW.STOCK_ID = #attributes.stock_id#
						</cfif>
						<cfif isdefined("url.service_id")>
							AND SHIP_ROW.SERVICE_ID = #url.service_id#
						</cfif>
						<cfif isDefined("attributes.process_id") and len(attributes.process_id)>
							AND SHIP_ROW.SHIP_ID = #attributes.process_id#
						</cfif>
						<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
							AND SHIP.SHIP_NUMBER = '#attributes.belge_no#'
						</cfif>
						<cfif isdate(attributes.date1) and not Len(attributes.process_id)>
							AND SHIP.SHIP_DATE >= #attributes.date1#
						</cfif>
						<cfif isdate(attributes.date2) and not Len(attributes.process_id)>
							AND SHIP.SHIP_DATE <  #DATEADD("d",1,attributes.date2)#
						</cfif>
						<cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
							AND SHIP.COMPANY_ID = #attributes.company_id#
						<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company)>
							AND SHIP.CONSUMER_ID = #attributes.consumer_id#
						</cfif>
						<cfif len(attributes.project_id) and len(attributes.project_head)>
							AND SHIP.PROJECT_ID = #attributes.project_id#
						</cfif>
						<cfif len(attributes.q_serial_no)>
							AND SHIP.SHIP_ID IN (	SELECT 
														PROCESS_ID
													FROM
														SERVICE_GUARANTY_NEW
													WHERE
														SERVICE_GUARANTY_NEW.PROCESS_CAT IN (<cfif not Len(attributes.process_cat_id)>76,811<cfelse>#attributes.process_cat_id#</cfif>) AND
														SERVICE_GUARANTY_NEW.SERIAL_NO LIKE '%#attributes.q_serial_no#%'
												)
						</cfif>
						<cfif len(attributes.department_id)>
							<cfif listlen(attributes.department_id,'-') eq 1>
								AND ( SHIP.DEPARTMENT_IN = #attributes.department_id# OR SHIP.DELIVER_STORE_ID = #attributes.department_id#)
							<cfelse>
								AND 
								(
									(SHIP.DEPARTMENT_IN = #listfirst(attributes.department_id,'-')# AND SHIP.LOCATION_IN = #listlast(attributes.department_id,'-')#) OR 			
									(SHIP.DELIVER_STORE_ID = #listfirst(attributes.department_id,'-')# AND SHIP.LOCATION = #listlast(attributes.department_id,'-')#)
								)	
							</cfif>
						</cfif>	
					) TABLE1
					LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.SHIP_ID AND ORQ.SHIP_WRK_ROW_ID = TABLE1.WRK_ROW_ID AND ORQ.PROCESS_CAT IN (<cfif not Len(attributes.process_cat_id)>76,811<cfelse>#attributes.process_cat_id#</cfif>) AND ORQ.SHIP_PERIOD_ID = #session.ep.period_id#<!--- Sadece Mal Alımdan oluşanlar --->
				WHERE
					(	(TABLE1.IS_SHIP_IPTAL = 1 AND ORQ.SHIP_WRK_ROW_ID IS NOT NULL) OR TABLE1.IS_SHIP_IPTAL = 0	) <!--- Iptalse gelmesin ama islem yapmis olanlar gelsin --->
					<cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
						AND ORQ.OR_Q_ID IS NULL
					</cfif>
					<cfif Len(attributes.quality_stage)>
						AND ORQ.STAGE = #get_process_stage.process_row_id#	
					</cfif>
					<cfif len(attributes.quality_type)>
						AND OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
					</cfif>
					<cfif len(attributes.employee_id) and len(attributes.employee)>
						AND ORQ.RECORD_EMP = #attributes.employee_id#
					</cfif>
					<cfif Len(attributes.q_control_no)>
						AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
					</cfif>
					<cfif len(attributes.related_success_id)>
						AND ORQ.SUCCESS_ID = #attributes.related_success_id#
					</cfif>
					<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
						AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
					</cfif>
				GROUP BY
					ORQ.SUCCESS_ID,
					ORQ.OR_Q_ID,
					ORQ.Q_CONTROL_NO,
					ORQ.STAGE,
					TABLE1.STOCK_ID,
					TABLE1.AMOUNT,
					TABLE1.COMPANY_ID,
					TABLE1.PARTNER_ID,
					TABLE1.CONSUMER_ID,
					TABLE1.LOCATION_IN,
					TABLE1.DEPARTMENT_IN,
					TABLE1.LOCATION,
					TABLE1.DELIVER_STORE_ID,
					TABLE1.SHIP_ID,
					TABLE1.SHIP_NUMBER,
					TABLE1.SHIP_DATE,
					TABLE1.PROCESS_CAT,
					TABLE1.SHIP_ROW_ID,
					TABLE1.WRK_ROW_ID,
                    TABLE1.LOT_NO
				</cfif>
				<cfif not Len(attributes.process_cat_id)>
					UNION ALL
				</cfif>
				<cfif not Len(attributes.process_cat_id) or attributes.process_cat_id eq 171>
				SELECT
					3 BLOCK_TYPE, 
					ORQ.OR_Q_ID,
					ORQ.SUCCESS_ID,
					ORQ.Q_CONTROL_NO,
					ORQ.STAGE,
					SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
					TABLE1.AMOUNT QUANTITY,
					TABLE1.LOT_NO,
					TABLE1.STOCK_ID,
					'' COMPANY_ID,
					'' PARTNER_ID,
					'' CONSUMER_ID,
					TABLE1.LOCATION_IN,
					TABLE1.DEPARTMENT_IN,
					TABLE1.LOCATION_OUT,
					TABLE1.DEPARTMENT_OUT,
					TABLE1.P_ORDER_ID PROCESS_ID,
					TABLE1.RESULT_NO PROCESS_NUMBER,
					TABLE1.FINISH_DATE PROCESS_DATE,
					171 PROCESS_CAT,
					TABLE1.PR_ORDER_ROW_ID AS PROCESS_ROW_ID,
					TABLE1.WRK_ROW_ID SHIP_WRK_ROW_ID,
					TABLE1.PR_ORDER_ROW_ID PR_ORDER_ROW_ID,
					TABLE1.PR_ORDER_ID AS PR_ORDER_ID
				FROM
					(
					SELECT
						PORR.STOCK_ID,
						POR.P_ORDER_ID,
						POR.PR_ORDER_ID,
						PR_ORDER_ROW_ID,
						RESULT_NO,
						POR.FINISH_DATE,
						PORR.AMOUNT,
						POR.LOT_NO,
						POR.ENTER_LOC_ID LOCATION_IN,
						POR.ENTER_DEP_ID DEPARTMENT_IN,
						POR.EXIT_LOC_ID LOCATION_OUT,
						POR.EXIT_DEP_ID DEPARTMENT_OUT,
						PORR.WRK_ROW_ID
					FROM
						PRODUCTION_ORDER_RESULTS POR,
						PRODUCTION_ORDER_RESULTS_ROW PORR
						LEFT JOIN STOCKS S ON S.STOCK_ID = PORR.STOCK_ID
                        LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
					WHERE
						S.IS_QUALITY = 1 AND
						PORR.TYPE = 1
						AND PORR.PR_ORDER_ID = POR.PR_ORDER_ID
						AND POR.P_ORDER_ID NOT IN(SELECT P_ORDER_ID FROM PRODUCTION_ORDERS PO WHERE PO.IS_DEMONTAJ = 1)
                        AND (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= POR.FINISH_DATE)
						<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
							AND POR.RESULT_NO = '#attributes.belge_no#'
						</cfif>
						<cfif isDefined("attributes.process_id") and len(attributes.process_id)>
							AND PO.PR_ORDER_ID = #attributes.process_id#
						</cfif>
						<cfif len(attributes.stock_id) and len(attributes.product_name)>
							AND PORR.STOCK_ID = #attributes.stock_id#
						</cfif>
						<cfif isdate(attributes.date1) and not len(attributes.process_id)>
							AND POR.START_DATE >= #attributes.date1#
						</cfif>
						<cfif isdate(attributes.date2) and not len(attributes.process_id)>
							AND POR.START_DATE <  #DATEADD("d",1,attributes.date2)#
						</cfif>
						<cfif len(attributes.project_id) and len(attributes.project_head)>
							AND POR.P_ORDER_ID IN 	(	SELECT 
															P_ORDER_ID 
														FROM 
															PRODUCTION_ORDERS PO 
														WHERE 
															PO.P_ORDER_ID = POR.P_ORDER_ID AND
															PO.PROJECT_ID =	#attributes.project_id#
													)
						</cfif>
						<cfif len(attributes.q_serial_no)>
							AND POR.PR_ORDER_ID IN 	(	SELECT 
															PROCESS_ID
														FROM
															SERVICE_GUARANTY_NEW
														WHERE
															SERVICE_GUARANTY_NEW.PROCESS_CAT IN (<cfif not Len(attributes.process_cat_id)>171<cfelse>#attributes.process_cat_id#</cfif>) AND
															SERVICE_GUARANTY_NEW.SERIAL_NO LIKE '%#attributes.q_serial_no#%'
													)
						</cfif>
						<cfif len(attributes.department_id)>
							<cfif listlen(attributes.department_id,'-') eq 1>
								AND ( POR.ENTER_DEP_ID = #attributes.department_id# OR POR.EXIT_DEP_ID = #attributes.department_id# )
							<cfelse>
								AND 
								(
									(POR.ENTER_DEP_ID = #listfirst(attributes.department_id,'-')# AND POR.ENTER_LOC_ID = #listlast(attributes.department_id,'-')#) OR 			
									(POR.EXIT_DEP_ID = #listfirst(attributes.department_id,'-')# AND POR.EXIT_LOC_ID = #listlast(attributes.department_id,'-')#)
								)	
							</cfif>
						</cfif>			  
					) TABLE1
					LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.P_ORDER_ID AND ORQ.SHIP_WRK_ROW_ID = TABLE1.WRK_ROW_ID AND ORQ.PROCESS_CAT = 171<!--- Sadece Üretimden oluşanlar --->
				WHERE
					1 = 1
					AND ORQ.OR_Q_ID NOT IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW ORQR WHERE ORQR.OR_Q_ID = ORQ.OR_Q_ID AND IS_REPROCESS = 1) <!--- Yeniden Islemler Dikkate Alinmiyor --->
					<cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
						AND ORQ.OR_Q_ID IS NULL
					</cfif>
					<cfif Len(attributes.quality_stage)>
						AND ORQ.STAGE = #get_process_stage.process_row_id#	
					</cfif>
					<cfif len(attributes.quality_type)>
						AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
					</cfif>
					<cfif len(attributes.employee_id) and len(attributes.employee)>
						AND ORQ.RECORD_EMP = #attributes.employee_id#
					</cfif>
					<cfif len(attributes.q_control_no)>
						AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
					</cfif>
					<cfif len(attributes.related_success_id)>
						AND ORQ.SUCCESS_ID = #attributes.related_success_id#
					</cfif>
					<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
						AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
					</cfif>
				GROUP BY
					ORQ.SUCCESS_ID,
					ORQ.OR_Q_ID,
					ORQ.Q_CONTROL_NO,
					ORQ.STAGE,
					TABLE1.AMOUNT,
					TABLE1.STOCK_ID,
					TABLE1.P_ORDER_ID,
					TABLE1.PR_ORDER_ID,
					TABLE1.PR_ORDER_ROW_ID,
					TABLE1.WRK_ROW_ID,
					TABLE1.RESULT_NO,
					TABLE1.FINISH_DATE,
					TABLE1.LOCATION_IN,
					TABLE1.DEPARTMENT_IN,
					TABLE1.LOCATION_OUT,
					TABLE1.DEPARTMENT_OUT,
					TABLE1.LOT_NO
				</cfif>
				<cfif not Len(attributes.process_cat_id)>
					UNION ALL
				</cfif>
				<cfif not Len(attributes.process_cat_id) or attributes.process_cat_id eq -1>
					SELECT
						2 BLOCK_TYPE, 
						ORQ.OR_Q_ID,
						ORQ.SUCCESS_ID,
						ORQ.Q_CONTROL_NO,
						ORQ.STAGE,
						SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
						TABLE1.AMOUNT QUANTITY,
						'' LOT_NO,
						TABLE1.STOCK_ID,
						'' COMPANY_ID,
						'' PARTNER_ID,
						'' CONSUMER_ID,
						TABLE1.LOCATION_IN,
						TABLE1.DEPARTMENT_IN,
						TABLE1.LOCATION_OUT,
						TABLE1.DEPARTMENT_OUT,
						TABLE1.P_ORDER_ID AS PROCESS_ID,
						TABLE1.RESULT_NO AS PROCESS_NUMBER,
						TABLE1.FINISH_DATE AS PROCESS_DATE,
						-1 PROCESS_CAT,
						TABLE1.PR_ORDER_ROW_ID AS PROCESS_ROW_ID,
						'' SHIP_WRK_ROW_ID,
						TABLE1.PR_ORDER_ROW_ID PR_ORDER_ROW_ID,
						<cfif attributes.process_cat_id eq -1>
                        TABLE1.OPERATION_TYPE AS OPERATION_TYPE,
                        </cfif>
						'' PR_ORDER_ID
					FROM
						(
						SELECT
							POS.STOCK_ID,
							POS.P_ORDER_ID,
							'' PROCESS_ID,
							'' PR_ORDER_ID,
							PO.P_OPERATION_ID PR_ORDER_ROW_ID,
							POS.P_ORDER_NO RESULT_NO,
							POS.FINISH_DATE,
							PO.AMOUNT,
							'' LOCATION_IN,
							'' DEPARTMENT_IN,
							'' LOCATION_OUT,
							<cfif attributes.process_cat_id eq -1>
                            OPT.OPERATION_TYPE OPERATION_TYPE,
                            </cfif>
							'' DEPARTMENT_OUT
						FROM
							PRODUCTION_OPERATION_RESULT POR,
							PRODUCTION_OPERATION PO,
							<cfif attributes.process_cat_id eq -1>
                            OPERATION_TYPES OPT,
                            </cfif>
							PRODUCTION_ORDERS POS
								LEFT JOIN STOCKS S ON S.STOCK_ID = POS.STOCK_ID
                                LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
						WHERE
							S.IS_QUALITY = 1 AND
							POR.P_ORDER_ID = POS.P_ORDER_ID AND
							PO.P_OPERATION_ID = POR.OPERATION_ID AND
							<cfif attributes.process_cat_id eq -1>
                            PO.OPERATION_TYPE_ID = OPT.OPERATION_TYPE_ID AND
                            </cfif>
                            (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= POS.FINISH_DATE)
							<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
								AND POS.P_ORDER_NO = '#attributes.belge_no#'
							</cfif>
							<cfif isDefined("attributes.process_id") and len(attributes.process_id)>
								AND POS.P_ORDER_ID = #attributes.process_id#
							</cfif>
							<cfif len(attributes.stock_id) and len(attributes.product_name)>
								AND POS.STOCK_ID = #attributes.stock_id#
							</cfif>
							<cfif isdate(attributes.date1) and not len(attributes.process_id)>
								AND POS.START_DATE >= #attributes.date1#
							</cfif>
							<cfif isdate(attributes.date2) and not len(attributes.process_id)>
								AND POS.START_DATE <  #DATEADD("d",1,attributes.date2)#
							</cfif>
							<cfif len(attributes.project_id) and len(attributes.project_head)>
								AND POS.P_ORDER_ID IN 	(	SELECT 
																P_ORDER_ID 
															FROM 
																PRODUCTION_ORDERS PO 
															WHERE 
																PO.P_ORDER_ID = POS.P_ORDER_ID AND
																PO.PROJECT_ID =	#attributes.project_id#
														)
							</cfif>
						) TABLE1
							LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.P_ORDER_ID AND ORQ.PROCESS_ROW_ID = TABLE1.PR_ORDER_ROW_ID AND ORQ.PROCESS_CAT = -1<!--- Sadece Üretimden oluşanlar --->
					WHERE
						1 = 1
						<cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
							AND ORQ.OR_Q_ID IS NULL
						</cfif>
						<cfif Len(attributes.quality_stage)>
							AND ORQ.STAGE = #get_process_stage.process_row_id#	
						</cfif>
						<cfif len(attributes.quality_type)>
							AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
						</cfif>
						<cfif len(attributes.employee_id) and len(attributes.employee)>
							AND ORQ.RECORD_EMP = #attributes.employee_id#
						</cfif>
						<cfif len(attributes.q_control_no)>
							AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
						</cfif>
						<cfif len(attributes.related_success_id)>
							AND ORQ.SUCCESS_ID = #attributes.related_success_id#
						</cfif>
						<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
							AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
						</cfif>
					GROUP BY
						ORQ.SUCCESS_ID,
						ORQ.OR_Q_ID,
						ORQ.Q_CONTROL_NO,
						ORQ.STAGE,
						TABLE1.AMOUNT,
						TABLE1.STOCK_ID,
						TABLE1.PROCESS_ID,
						TABLE1.P_ORDER_ID,
						TABLE1.PR_ORDER_ID,
						TABLE1.PR_ORDER_ROW_ID,
						TABLE1.RESULT_NO,
						TABLE1.FINISH_DATE,
						TABLE1.LOCATION_IN,
						TABLE1.DEPARTMENT_IN,
						TABLE1.LOCATION_OUT,
						<cfif attributes.process_cat_id eq -1>
                        TABLE1.OPERATION_TYPE,
                        </cfif>
						TABLE1.DEPARTMENT_OUT
				</cfif>
				<cfif not Len(attributes.process_cat_id)>
					UNION ALL
				</cfif>
				<cfif not Len(attributes.process_cat_id) or attributes.process_cat_id eq -2>
				SELECT
					2 BLOCK_TYPE, 
					ORQ.OR_Q_ID,
					ORQ.SUCCESS_ID,
					ORQ.Q_CONTROL_NO,
					ORQ.STAGE,
					SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
					'' QUANTITY,
					'' LOT_NO,
					TABLE1.STOCK_ID,
					'' COMPANY_ID,
					'' PARTNER_ID,
					'' CONSUMER_ID,
					TABLE1.LOCATION_IN,
					TABLE1.DEPARTMENT_IN,
					TABLE1.LOCATION_OUT,
					TABLE1.DEPARTMENT_OUT,
					TABLE1.SERVICE_ID AS PROCESS_ID,
					TABLE1.RESULT_NO AS PROCESS_NUMBER,
					TABLE1.APPLY_DATE AS PROCESS_DATE,
					-2 PROCESS_CAT,
					TABLE1.SERVICE_ID AS PROCESS_ROW_ID,
					'' SHIP_WRK_ROW_ID,
					'' PR_ORDER_ROW_ID,
					'' AS PR_ORDER_ID
				FROM
					(
					SELECT
						SERVICE.STOCK_ID,
						SERVICE.SERVICE_ID,
						SERVICE.PRODUCT_NAME,
						SERVICE.SERVICE_HEAD RESULT_NO,
						SERVICE.APPLY_DATE,
						'' PROCESS_ID,
						'' PR_ORDER_ID,
						'' LOCATION_IN,
						'' DEPARTMENT_IN,
						'' LOCATION_OUT,
						'' DEPARTMENT_OUT
					FROM 
						SERVICE 
                        LEFT JOIN PRODUCT ON SERVICE.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID
					WHERE
						SERVICE.SERVICE_ACTIVE = 1 AND
                        (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= SERVICE.APPLY_DATE) AND
						<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
							SERVICE.SERVICE_NO = '#attributes.belge_no#' AND
						</cfif>
                        <cfif len(attributes.stock_id) and len(attributes.product_name)>
                            SERVICE.STOCK_ID = #attributes.stock_id# AND
                        </cfif>
						SERVICE.STOCK_ID IS NOT NULL
					)TABLE1
						LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.SERVICE_ID AND ORQ.PROCESS_CAT = -2<!--- Sadece Üretimden oluşanlar --->
					WHERE
						1 = 1
						<cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
							AND ORQ.OR_Q_ID IS NULL
						</cfif>
						<cfif Len(attributes.quality_stage)>
							AND ORQ.STAGE = #get_process_stage.process_row_id#	
						</cfif>
						<cfif len(attributes.quality_type)>
							AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
						</cfif>
						<cfif len(attributes.employee_id) and len(attributes.employee)>
							AND ORQ.RECORD_EMP = #attributes.employee_id#
						</cfif>
						<cfif len(attributes.q_control_no)>
							AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
						</cfif>
						<cfif len(attributes.related_success_id)>
							AND ORQ.SUCCESS_ID = #attributes.related_success_id#
						</cfif>
						<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
							AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
						</cfif>
					GROUP BY
						ORQ.SUCCESS_ID,
						ORQ.OR_Q_ID,
						ORQ.Q_CONTROL_NO,
						ORQ.STAGE,
						TABLE1.STOCK_ID,
						TABLE1.PROCESS_ID,
						TABLE1.SERVICE_ID,
						TABLE1.PR_ORDER_ID,
						TABLE1.RESULT_NO,
						TABLE1.APPLY_DATE,
						TABLE1.LOCATION_IN,
						TABLE1.DEPARTMENT_IN,
						TABLE1.LOCATION_OUT,
						TABLE1.DEPARTMENT_OUT 
				</cfif>
				<cfif attributes.process_cat_id eq -3><!--- lab işlemleri --->
					SELECT
					2 BLOCK_TYPE, 
					ORQ.OR_Q_ID,
					ORQ.SUCCESS_ID,
					ORQ.Q_CONTROL_NO,
					ORQ.STAGE,
					SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
					TABLE1.SAMPLE_AMOUNT QUANTITY,
					'' LOT_NO,
					TABLE1.STOCK_ID,
					'' COMPANY_ID,
					'' PARTNER_ID,
					'' CONSUMER_ID,
					TABLE1.LOCATION_IN,
					TABLE1.DEPARTMENT_IN,
					TABLE1.LOCATION_OUT,
					TABLE1.DEPARTMENT_OUT,
					TABLE1.REFINERY_LAB_TEST_ID AS PROCESS_ID,
					TABLE1.RESULT_NO AS PROCESS_NUMBER,
					TABLE1.NUMUNE_DATE AS PROCESS_DATE,
					-3 PROCESS_CAT,
					TABLE1.SAMPLING_ROW_ID AS PROCESS_ROW_ID,
					'' SHIP_WRK_ROW_ID,
					'' PR_ORDER_ROW_ID,
					'' AS PR_ORDER_ID
				FROM
					(
					SELECT
						LSR.STOCK_ID,
						RLT.REFINERY_LAB_TEST_ID,
						PRODUCT.PRODUCT_NAME,
						RLT.LAB_REPORT_NO RESULT_NO,
						RLT.NUMUNE_DATE,
						'' PROCESS_ID,
						'' PR_ORDER_ID,
						'' LOCATION_IN,
						'' DEPARTMENT_IN,
						'' LOCATION_OUT,
						'' DEPARTMENT_OUT,
						LSR.SAMPLE_AMOUNT,
						LSR.SAMPLING_ROW_ID
					FROM 
						#dsn#.LAB_SAMPLING_ROW LSR
                        LEFT JOIN PRODUCT ON LSR.PRODUCT_ID = PRODUCT.PRODUCT_ID
						LEFT JOIN #dsn#.LAB_SAMPLING LS ON LSR.SAMPLING_ID = LS.SAMPLING_ID
						LEFT JOIN #dsn#.REFINERY_LAB_TESTS RLT ON RLT.REFINERY_LAB_TEST_ID = LS.SAMPLE_ANALYSIS_ID
					WHERE
                        (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= RLT.NUMUNE_DATE) AND
						<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
							RLT.LAB_REPORT_NO = '#attributes.belge_no#' AND
						</cfif>
                        <cfif len(attributes.stock_id) and len(attributes.product_name)>
                            LSR.STOCK_ID = #attributes.stock_id# AND
                        </cfif>
							LSR.STOCK_ID IS NOT NULL
					)TABLE1
						LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.REFINERY_LAB_TEST_ID AND ORQ.PROCESS_CAT = -3
					WHERE
						TABLE1.RESULT_NO IS NOT NULL
						<cfif isDefined("attributes.no_result_quality")>
							AND ORQ.OR_Q_ID IS NULL
						</cfif>
						<cfif Len(attributes.quality_stage)>
							AND ORQ.STAGE = #get_process_stage.process_row_id#	
						</cfif>
						<cfif len(attributes.quality_type)>
							AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
						</cfif>
						<cfif len(attributes.employee_id) and len(attributes.employee)>
							AND ORQ.RECORD_EMP = #attributes.employee_id#
						</cfif>
						<cfif len(attributes.q_control_no)>
							AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
						</cfif>
						<cfif len(attributes.related_success_id)>
							AND ORQ.SUCCESS_ID = #attributes.related_success_id#
						</cfif>
						<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
							AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
						</cfif>
					GROUP BY
						ORQ.SUCCESS_ID,
						ORQ.OR_Q_ID,
						ORQ.Q_CONTROL_NO,
						ORQ.STAGE,
						TABLE1.STOCK_ID,
						TABLE1.PROCESS_ID,
						TABLE1.PR_ORDER_ID,
						TABLE1.RESULT_NO,
						TABLE1.LOCATION_IN,
						TABLE1.DEPARTMENT_IN,
						TABLE1.LOCATION_OUT,
						TABLE1.DEPARTMENT_OUT,
						TABLE1.REFINERY_LAB_TEST_ID,
						TABLE1.NUMUNE_DATE,
						TABLE1.SAMPLE_AMOUNT,
						TABLE1.SAMPLING_ROW_ID
				</cfif>
			) AS NEW_TABLE
			
			ORDER BY
				<cfif attributes.sort_type eq 6>
					(SELECT QS.SUCCESS FROM QUALITY_SUCCESS QS WHERE QS.SUCCESS_ID = NEW_TABLE.SUCCESS_ID) DESC,
				<cfelseif attributes.sort_type eq 5>
					(SELECT QS.SUCCESS FROM QUALITY_SUCCESS QS WHERE QS.SUCCESS_ID = NEW_TABLE.SUCCESS_ID),
				<cfelseif attributes.sort_type eq 4>
					Q_CONTROL_NO DESC,
				<cfelseif attributes.sort_type eq 3>
					Q_CONTROL_NO,
				<cfelseif attributes.sort_type eq 2 and ListFind("171,-1",attributes.process_cat_id)>
					NEW_TABLE.LOT_NO DESC,
				<cfelseif attributes.sort_type eq 1 and ListFind("171,-1",attributes.process_cat_id)>
					NEW_TABLE.LOT_NO,
				</cfif>
				<cfif ListFind("76,811",attributes.process_cat_id)>
					NEW_TABLE.PROCESS_ROW_ID DESC,
					<cfif not ListFind("3,4",attributes.sort_type)>
						NEW_TABLE.Q_CONTROL_NO,
					</cfif>
				<cfelseif attributes.process_cat_id eq 171>
					NEW_TABLE.PR_ORDER_ROW_ID DESC,
				<cfelseif attributes.process_cat_id eq -1>
					NEW_TABLE.PR_ORDER_ROW_ID DESC,
				</cfif>
				PROCESS_DATE DESC,
				SUCCESS_ID
		</cfquery>
	<cfelse>
		<cfset GET_QUALITY_LIST.recordcount = 0>
	</cfif>
	<cfset adres="&is_filtre=1">
	<cfif len(attributes.process_cat_id)>
		<cfset adres = "#adres#&process_cat_id=#attributes.process_cat_id#">
	</cfif>
	<cfif len(attributes.belge_no)>
		<cfset adres = "#adres#&belge_no=#attributes.belge_no#">
	</cfif>
	<cfif len(attributes.sort_type)>
		<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
	</cfif>
	<cfif isdate(attributes.date1)>
		<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
	</cfif>
	<cfif isdate(attributes.date2)>
		<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.company)>
		<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
	<cfelseif len(attributes.consumer_id) and len(attributes.company)>
		<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		<cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
	</cfif>
	<cfif len(attributes.stock_id) and len(attributes.product_name)>
		<cfset adres = "#adres#&stock_id=#attributes.stock_id#&product_name=#attributes.product_name#">
	</cfif>
	<cfif len(attributes.department_id)>
		<cfset adres = "#adres#&department_id=#attributes.department_id#">
	</cfif>
	<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
		<cfset adres = "#adres#&controller_emp_id=#attributes.controller_emp_id#&controller_emp=#attributes.controller_emp#">
	</cfif>
	<cfif isDefined("attributes.no_result_quality")><cfset adres = "#adres#&no_result_quality=#attributes.no_result_quality#"></cfif>
	<cfif Len(attributes.quality_stage)><cfset adres = "#adres#&quality_stage=#attributes.quality_stage#"></cfif>
	<cfset adres = "#adres#&related_success_id=#attributes.related_success_id#">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#GET_QUALITY_LIST.recordCount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
		SELECT 
			D.DEPARTMENT_HEAD,
			SL.DEPARTMENT_ID,
			SL.LOCATION_ID,
			SL.STATUS,
			SL.COMMENT
		FROM 
			STOCKS_LOCATION SL,
			DEPARTMENT D,
			BRANCH B
		WHERE
			D.IS_STORE <> 2 AND
			SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.DEPARTMENT_STATUS = 1 AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif session.ep.isBranchAuthorization>
				AND B.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
			</cfif>
			<cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
			</cfif>
			<cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
			</cfif>
		ORDER BY
			D.DEPARTMENT_HEAD,
			COMMENT
	</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="list_serial" id="list_serial" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls">
				<input type="hidden" name="is_filtre" id="is_filtre" value="1">
				<cf_box_search plus="0">
					<div class="form-group">
						<label>
							<input type="checkbox" name="no_result_quality" id="no_result_quality" value="1" <cfif isDefined("attributes.no_result_quality")>checked</cfif>><cf_get_lang dictionary_id="36797.Sonuc Girilmemişler">                      
						</label>
					</div>
					<div class="form-group">
						<cfif attributes.process_cat_id eq -1>
							<cfset style_type = 'none'>
						<cfelse>
							<cfset style_type = ''>
						</cfif>
						<div id="seri_no2">
							<cfsavecontent variable="place"><cf_get_lang dictionary_id='57637.Seri No'></cfsavecontent>
							<input type="text" name="q_serial_no" id="q_serial_no" placeholder="<cfoutput>#place#</cfoutput>"  value="<cfoutput>#attributes.q_serial_no#</cfoutput>">                       
						</div>
					</div>
					<div class="form-group">
						<cfsavecontent variable="place1"><cf_get_lang dictionary_id='36479.Kontrol No'></cfsavecontent>
						<input type="text" name="q_control_no" id="q_control_no" placeholder="<cfoutput>#place1#</cfoutput>"  value="<cfoutput>#attributes.q_control_no#</cfoutput>">                       
					</div>
					<div class="form-group">
						<cfsavecontent variable="place2"><cf_get_lang dictionary_id='60244.Kaynak Belge No'></cfsavecontent>
						<input type="text" name="belge_no" id="belge_no" placeholder="<cfoutput>#place2#</cfoutput>"  value="<cfoutput>#attributes.belge_no#</cfoutput>">                      
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">            
					</div>
					<div class="form-group">
						<cf_wrk_search_button search_function='input_control()' button_type="4">
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
						<cfif attributes.process_cat_id eq -1>
							<cfset style_type = 'none'>
						<cfelse>
							<cfset style_type = ''> 
						</cfif>
						<cfoutput><div id="dept_id_hidden" style="#style_type#"></div></cfoutput>
						<div class="form-group" id="item-sort_type">
							<label class="col col-12"><cf_get_lang dictionary_id="58924.Sıralama"></label>
							<div class="col col-12">
								<select name="sort_type" id="sort_type">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>                               
									<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id="36611.Lot No ya Göre Artan"></option>
									<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id="36620.Lot No'ya Göre Azalan"></option>                                
									<option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id="36653.Kontrol No ya Göre Artan"></option>
									<option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id="36672.Kontrol No ya Göre Azalan"></option>
									<option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang dictionary_id="36696.Kalite Sonucuna Göre Artan"></option>
									<option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cf_get_lang dictionary_id="36697.Kalite Sonucuna Göre Azalan"></option>
								</select>                
							</div>
						</div>
						<div class="form-group" id="item-process_cat_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
							<div class="col col-12">
								<select name="process_cat_id" id="process_cat_id" onChange="show_sort_type();">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="76" <cfif attributes.process_cat_id eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
									<option value="171" <cfif attributes.process_cat_id eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
									<option value="811" <cfif attributes.process_cat_id eq 811>selected</cfif>><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></option>
									<option value="-1" <cfif attributes.process_cat_id eq -1>selected</cfif>><cf_get_lang dictionary_id="36376.Operasyonlar"></option>
									<option value="-2" <cfif attributes.process_cat_id eq -2>selected</cfif>><cf_get_lang dictionary_id="57656.Servis"></option>
									<option value="-3" <cfif attributes.process_cat_id eq -3>selected</cfif>><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></option>
								</select>                
							</div>
						</div>
						<cfif attributes.process_cat_id eq -1>
							<cfset style_type = 'none'>
						<cfelse>
							<cfset style_type = ''>
						</cfif>
						<div class="form-group" id="item-department_id" style=<cfoutput>"#style_type#"</cfoutput>>
							<label class="col col-12" id="dept_id_3" style=<cfoutput>"#style_type#"</cfoutput>><cf_get_lang dictionary_id='58763.Depo'></label>
							<div class="col col-12">
								<div id="dept_id_2">
									<select name="department_id" id="department_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_all_location" group="department_id">
											<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
											<cfoutput>
											<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
											</cfoutput>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
						<div class="form-group" id="item-quality_type">
							<label class="col col-12"><cf_get_lang dictionary_id="36574.Üretim Kalite Tipleri"></label>
							<div class="col col-12">
								<select name="quality_type" id="quality_type">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="quality_control_type">
										<cfif sort_type eq 0>
											<optgroup label="#QUALITY_CONTROL_TYPE#">
										</cfif>
										<cfif sort_type eq 1>
											<option value="#result_id#-#type_id#" <cfif listfind(attributes.quality_type,'#result_id#-#type_id#',',')>selected</cfif>>#QUALITY_CONTROL_TYPE#</option>
										</cfif>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-quality_stage">
							<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
							<div class="col col-12">
								<select name="quality_stage" id="quality_stage" >
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_process_stage">
										<option value="<cfoutput>#process_row_id#</cfoutput>" <cfif get_process_stage.process_row_id eq attributes.quality_stage>selected</cfif>><cfoutput>#stage#</cfoutput></option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-related_success_id">
							<label class="col col-12"><cf_get_lang dictionary_id="36700.Kalite Sonucu"></label>
							<div class="col col-12">
								<select name="related_success_id" id="related_success_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_succes_names">
										<option value="#success_id#" <cfif attributes.related_success_id eq success_id>selected</cfif>>#SUCCESS#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
						<cfoutput>
							<div class="form-group" id="item-employee">
								<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
								<div class="col col-12">
									<div class="input-group">
										<input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">			
										<input type="text" name="employee" id="employee" value="#attributes.employee#" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','120');" autocomplete="off" >
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=list_serial.employee_id&field_name=list_serial.employee&select_list=1</cfoutput>');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-controller_emp">
								<label class="col col-12"><cf_get_lang dictionary_id='36566.Kontrol Eden'></label>
								<div class="col col-12">
									<div class="input-group">
										<input type="hidden" name="controller_emp_id" id="controller_emp_id" value="<cfif len(attributes.controller_emp_id)>#attributes.controller_emp_id#</cfif>">			
										<input type="text" name="controller_emp" id="controller_emp" value="<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>#attributes.controller_emp#</cfif>" onFocus="AutoComplete_Create('controller_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id','','3','130');" autocomplete="off" >
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_emps&field_id=list_serial.controller_emp_id&field_name=list_serial.controller_emp&select_list=1');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-date">
								<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
								<div class="col col-12">
									<div class="col col-6">
										<div class="input-group">
											<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
												<cfinput type="text" name="date1" id="date1" maxlength="10" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" >
											<cfelse>
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
												<cfinput type="text" name="date1" id="date1" maxlength="10" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" message="#message#" >
											</cfif>
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date1"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
												<cfinput type="text" name="date2" id="date2" maxlength="10" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" >
											<cfelse>
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
												<cfinput type="text" name="date2" id="date2" maxlength="10" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" message="#message#" >
											</cfif> 
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date2"></span>
										</div>
									</div>
								</div>
							</div>
						</cfoutput>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
						<cfoutput>
							<div class="form-group" id="item-company">
								<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
								<div class="col col-12">
									<div class="input-group">
										<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
										<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
										<input type="text" name="company" id="company" value="#attributes.company#" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','120');" autocomplete="off" >
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=list_serial.company&field_comp_id=list_serial.company_id&field_consumer=list_serial.consumer_id&field_member_name=list_serial.company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3&keyword='+encodeURIComponent(document.list_serial.company.value));"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-project">
								<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
								<div class="col col-12">
									<div class="input-group">
										<cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif>
										<input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)>#attributes.project_id#</cfif>">
										<input type="text" name="project_head" id="project_head" value="<cfif len(attributes.project_head)>#attributes.project_head#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','120');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=list_serial.project_id&project_head=list_serial.project_head');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-product">
								<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
								<div class="col col-12">
									<div class="input-group">
										<!--- <cf_wrk_products form_name ='list_serial' product_name='product_name' stock_id='stock_id'> --->
										<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
										<input type="text" name="product_name" id="product_name" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_name,stock_id','','2','200');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=list_serial.stock_id&field_name=list_serial.product_name&keyword='+encodeURIComponent(document.list_serial.product_name.value));"></span>
									</div>
								</div>
							</div>
						</cfoutput>
					</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='37001.Kalite İşlemler'></cfsavecontent>
		<cf_box title="#message#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
				<thead>
					<cf_get_lang_set module_name="stock">
					<tr>
						<cfif xml_show_no eq 1><th><cf_get_lang dictionary_id='57487.No'></th></cfif>
						<cfif xml_show_q_control_no eq 1><th><cf_get_lang dictionary_id='36479.Kontrol No'></th></cfif>
						<th><cf_get_lang dictionary_id='60244.Kaynak Belge No'></th>
						<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
						<cfif attributes.process_cat_id eq -1>
							<th><cf_get_lang dictionary_id='29419.Operasyon'></th>
						</cfif>
						<cfif attributes.process_cat_id eq 171>
							<th><cf_get_lang dictionary_id="45498.Lot No"></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						<cfif xml_show_barcod eq 1>
							<th><cf_get_lang dictionary_id='57633.Barkod'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<cfif attributes.process_cat_id neq -1>
							<th><cf_get_lang dictionary_id='45273.Giriş Depo'></th>
							<th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
						</cfif>
						<cfif attributes.process_cat_id neq -2>
							<th class="text-center"><cf_get_lang dictionary_id='57635.Miktar'></th>
						</cfif>
						<th class="text-center"><cf_get_lang dictionary_id='45358.Kontrol'></th>
						<th class="text-center"><cf_get_lang dictionary_id='45731.Kalite'></th>
						<cfif (xml_show_remaining_ship_purchase eq 1 and ListFind("76,811",attributes.process_cat_id)) or (xml_show_remaining_production_plan eq 1 and ListFind("171",attributes.process_cat_id)) or (not ListFind("76,811,171",attributes.process_cat_id)) and attributes.process_cat_id neq -2>
							<th class="text-center"><cf_get_lang dictionary_id='58444.Kalan'></th>
						</cfif>
						<!-- sil -->
						<th><cf_get_lang dictionary_id='57482.Aşama'></th>
						<th width="20" class="header_icn_none text-center"><i class="fa fa-check-square"></i></th>
						<th width="20" class="header_icn_none text-center"><i class="fa fa-print"></i></th>
						<!-- sil -->
					</tr>
					<cf_get_lang_set module_name="prod">
				</thead>
				<tbody>
					<cfif GET_QUALITY_LIST.recordcount>
						<cfset quality_stage_list = "">
						<cfset stock_list = ''>
						<cfset main_stock_list = ''>
						<cfset dept_id_list = ''>
						<cfset main_dept_id_list = ''>
						<cfset main_succes_id_list = listdeleteduplicates(ValueList(GET_QUALITY_LIST.SUCCESS_ID,','))>
						<cfoutput query="GET_QUALITY_LIST" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfset stock_list = listappend(stock_list,GET_QUALITY_LIST.stock_id,',')>
							<cfif block_type neq 3>
								<cfset dept_= department_in>
								<cfset dept2_= department_out>
							<cfelse>
								<cfset dept_= listfirst(department_in,'-')>
								<cfset dept2_= listfirst(department_out,'-')>
							</cfif>
							<cfif len(dept_) and not listfind(dept_id_list,dept_)>
								<cfset dept_id_list=listappend(dept_id_list,dept_)>
							</cfif>
							<cfif len(dept2_) and  not listfind(dept_id_list,dept2_)>
								<cfset dept_id_list=listappend(dept_id_list,dept2_)>
							</cfif>
							<cfif Len(stage) and not ListFind(quality_stage_list,stage)>
								<cfset quality_stage_list = ListAppend(quality_stage_list,stage,",")>
							</cfif>
						</cfoutput>
						<cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
						<cfquery name="GET_STOCK_INFO" datasource="#DSN3#">
							SELECT
								#dsn#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
								PRODUCT.PRODUCT_ID AS PID,
								STOCKS.STOCK_CODE,
								STOCKS.BARCOD,
								STOCKS.STOCK_ID,
								PRODUCT.MANUFACT_CODE
							FROM
								PRODUCT,
								STOCKS 
							WHERE 
								STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								STOCKS.STOCK_ID IN (#stock_list#)
							ORDER BY
								STOCKS.STOCK_ID
						</cfquery>
						<cfset main_stock_list = listsort(listdeleteduplicates(valuelist(get_stock_info.stock_id,',')),'numeric','ASC',',')>
						<cfif listlen(dept_id_list)>
							<cfset dept_id_list = listsort(dept_id_list,"numeric","ASC",",")>
							<cfquery name="GET_DEP_DETAIL" datasource="#DSN#" >
								SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
							</cfquery> 
							<cfset main_dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfif ListLen(quality_stage_list)>
							<cfquery name="get_quality_stage" datasource="#dsn#">
								SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#quality_stage_list#) ORDER BY PROCESS_ROW_ID
							</cfquery>
							<cfset quality_stage_list = ListSort(ListDeleteDuplicates(ValueList(get_quality_stage.process_row_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfoutput query="GET_QUALITY_LIST" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<cfif xml_show_no eq 1><td align="center">#currentrow#</td></cfif>
								<cfset attributes.stock_id = stock_id>
								<cfif xml_show_q_control_no eq 1>
									<td><a href="#request.self#?fuseaction=#fusebox.circuit#.list_quality_controls&event=upd&or_q_id=#OR_Q_ID#" class="tableyazi">#q_control_no#</a></td>
								</cfif>
								<td><cfif process_cat eq 76><!--- Mal Alım İrsaliyesi --->
										<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#process_id#" class="tableyazi">#process_number#</a>
									<cfelseif process_cat eq 171><!--- üretim sonucu --->
										<a href="#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#process_id#&pr_order_id=#pr_order_id#" class="tableyazi">#process_number#</a>
									<cfelseif process_cat eq 811><!--- ithal mal girişi --->
										<a href="#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id=#process_id#" class="tableyazi">#process_number#</a>
									<cfelseif process_cat eq -1><!--- organizasyonlar --->
										<a href="#request.self#?fuseaction=prod.demands&event=upd&upd=#process_id#"class="tableyazi">#process_number#</a>
									<cfelseif process_cat eq -2><!--- organizasyonlar --->
										<a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#process_id#"class="tableyazi">#process_number#</a>    
									<cfelseif  process_cat eq -3><!--- lab işlemleri --->
										<a href="#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#process_id#"class="tableyazi">#process_number#</a>    
									</cfif>
								</td>
								<td>
									<cfif process_cat eq 76><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></cfif>
									<cfif process_cat eq 171><cf_get_lang dictionary_id='29651.Üretim Sonucu'></cfif>
									<cfif process_cat eq 811><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></cfif>
									<cfif process_cat eq -1><cf_get_lang dictionary_id="36376.Operasyonlar"></cfif>
									<cfif process_cat eq -2><cf_get_lang dictionary_id="57656.Servis"></cfif>
									<cfif process_cat eq -3><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></cfif>
								</td>
								<cfif attributes.process_cat_id eq -1>
									<td>#OPERATION_TYPE#</td>
								</cfif>
								<cfif attributes.process_cat_id eq 171>
									<td>#lot_no#</td>
								</cfif>
								<td>#dateformat(process_date,dateformat_style)#</td>
								<td>#get_stock_info.stock_code[listfind(main_stock_list,stock_id,',')]#</td>
								<cfif xml_show_barcod eq 1><td>#get_stock_info.barcod[listfind(main_stock_list,stock_id,',')]#</td></cfif>
								<td>#get_stock_info.product_name[listfind(main_stock_list,stock_id,',')]#</td>
								<cfif attributes.process_cat_id neq -1>
									<td><cfif len(department_in) and listlen(dept_id_list)>#get_dep_detail.department_head[listfind(main_dept_id_list,listfirst(department_in,'-'),',')]#</cfif></td>
									<td><cfif len(department_out) and listlen(dept_id_list)>
											<cfif block_type neq 3>
												#get_dep_detail.department_head[listfind(main_dept_id_list,department_out,',')]#
											<cfelse>
												#get_dep_detail.department_head[listfind(main_dept_id_list,listfirst(department_out,'-'),',')]#
											</cfif>
										</cfif>	
									</td>
								</cfif>
								<cfif attributes.process_cat_id neq -2>
								<td align="center">#TLFormat(quantity)#</td>
								</cfif>
								<td align="center">#TLFormat(CONTROL_AMOUNT)#</td>
								
								<cfif isDefined('GET_QUALITY_LIST.or_q_id') and len(GET_QUALITY_LIST.or_q_id)>
									<td id="quality_rows#currentrow#" class="iconL" onClick="gizle_goster(quality_success_rows#currentrow#);gizle_goster(quality_result_show#currentrow#);gizle_goster(quality_result_hide#currentrow#);">
										<!-- sil -->
										<i class="fa fa-caret-right" id="quality_result_show#currentrow#" title="<cf_get_lang dictionary_id ='58596.Göster'>" alt="<cf_get_lang dictionary_id ='58596.Göster'>"></i>
										<i class="fa fa-caret-right" id="quality_result_hide#currentrow#" title="<cf_get_lang dictionary_id='58628.Gizle'>" alt="<cf_get_lang dictionary_id='58628.Gizle'>" style="display:none"></i>
										<!-- sil -->
										<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
										<cfset get_quality_success =get_queries.get_succes_name()>
										<cf_flat_list id="quality_success_rows#currentrow#" class="nohover" style="display:none;">
											<thead>
												<tr>
													<th width="150"><cf_get_lang dictionary_id='36700.Kalite Sonucu'></th>
													<th width="90" class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="get_quality_success">
													<tr>
														<td>
															#SUCCESS#
														</td>
														<td class="text-right">
															<cfquery name="get_succes_type" datasource="#dsn3#">
																SELECT ISNULL(AMOUNT,0) AMOUNT FROM ORDER_RESULT_QUALITY_SUCCESS_TYPE
																WHERE ORDER_RESULT_QUALITY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_QUALITY_LIST.or_q_id#">
																AND SUCCESS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#SUCCESS_ID#">
															</cfquery>
															#get_succes_type.AMOUNT#
														</td>
													</tr>
												</cfloop>
											</tbody>
										</cf_flat_list>
									</td>
								<cfelse>
									<td></td>
								</cfif>
								<cfif (xml_show_remaining_ship_purchase eq 1 and ListFind("76,811",attributes.process_cat_id)) or (xml_show_remaining_production_plan eq 1 and ListFind("171",attributes.process_cat_id)) or (not ListFind("76,811,171",attributes.process_cat_id)) and attributes.PROCESS_CAT_ID neq -2>
									<cfquery name="get_sub_list" dbtype="query">
										SELECT CONTROL_AMOUNT FROM GET_QUALITY_LIST WHERE PROCESS_ID = #PROCESS_ID# AND PROCESS_ROW_ID = #PROCESS_ROW_ID#
									</cfquery>
									<cfset sum_remaining = 0>
									<cfif not len(CONTROL_AMOUNT)>
										<cfset CONTROL_AMOUNT= 0>
									</cfif>
									<cfloop query="get_sub_list"><cfset sum_remaining = sum_remaining + CONTROL_AMOUNT></cfloop>
									<td align="center">
										<cfif len(quantity)>
											#TLFormat(quantity-sum_remaining)#
										</cfif>
									</td>
								</cfif>
								<!-- sil -->
								<td><cfif Len(stage)><cf_workcube_process type="color-status" process_stage="#stage#"></cfif></td>
								<!--- <td><cfif Len(stage)>#get_quality_stage.stage[ListFind(quality_stage_list,stage,',')]#</cfif></td> --->
								<cfif len(quantity)><cfset left=quantity-sum_remaining></cfif>
								<cfif not len(or_q_id)>
									<td align="center" width="20"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls&event=add&pr_order_id=#PR_ORDER_ID#&stock_id=#STOCK_ID#&process_id=#process_id#&is_detail=1&process_row_id=#PROCESS_ROW_ID#&ship_wrk_row_id=#SHIP_WRK_ROW_ID#&process_cat=#PROCESS_CAT#&left=#left#&pid=#get_stock_info.pid[listfind(main_stock_list,stock_id,',')]#"><i class="fa fa-check-square" title="<cf_get_lang dictionary_id='59157.Kalite'>" style="color:red!important"></i></a></td>
								<cfelse>
									<td align="center" width="20"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls&event=upd&or_q_id=#or_q_id#"><i class="fa fa-check-square" title="<cf_get_lang dictionary_id='59157.Kalite'>" style="color:green!important"></i></a></td>
								</cfif>
								<td align="center" width="20">
									<a href="#request.self#?fuseaction=objects.popup_print_files&action_type=#PROCESS_CAT#&action_row_id=#process_row_id#<cfif Len(or_q_id)>&action_id=#or_q_id#</cfif>&print_type=34" target="blank_"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
								</td>
								<!-- sil -->
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row">
							<td colspan="16"><cfif isdefined("attributes.is_filtre")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls#adres#">
			</cfif>
		</cf_box>
	</div>
	<script type="text/javascript">
		$(document).ready(function(){
			$("a.grey-cascade").remove();
		});
		document.getElementById('q_control_no').focus();
		function input_control()
		{
			/*
			if((list_serial.process_cat_id.value.length == 0))
			{
				alert("<cf_get_lang dictionary_id='59.Eksik Veri'> : <cf_get_lang dictionary_id='388.İşlem Tipi'>");
				return false;
			}
			
		
			if(	(list_serial.q_control_no.value.length == 0) && (list_serial.belge_no.value.length == 0) && (list_serial.date1.value.length == 0) && 
				(list_serial.date2.value.length == 0) && (list_serial.company.value.length == 0 || list_serial.company_id.value.length == 0) &&
				(list_serial.employee.value.length == 0 || list_serial.employee_id.value.length == 0) && (list_serial.process_cat_id.value.length == 0) && 
				list_serial.related_success_id.value.length == 0)
			{
				alert ("<cf_get_lang dictionary_id='1538.En Az Bir Alanda Filtre Etmelisiniz'> !"); 
				return false;
			}
			else
			*/
				return true;
		}
		function show_sort_type()
		{
			if(document.list_serial.process_cat_id.value == -1)
			{
				dept_id_2.style.display = 'none';
				dept_id_3.style.display = 'none';
				seri_no.style.display = 'none';				
				seri_no2.style.display = 'none';
				dept_id_hidden.style.display = '';
				<!---$("#sort_type").empty();
				$("#sort_type").append('<option value="">Sıralama</option>');
				$("#sort_type").append('<option value="1">Lot No ya Göre Artan</option><option value="2">Lot No ya Göre Azalan</option>');
				$("#sort_type").append('<option value="3">Kontrol No ya Göre Artan</option><option value="4">Kontrol No ya Göre Azalan</option>');
				$("#sort_type").append('<option value="5">Kalite Sonucuna Göre Artan</option><option value="6">Kalite Sonucuna Göre Azalan</option>');--->

			}
			else if(document.list_serial.process_cat_id.value == 171)
			{
					dept_id_2.style.display = '';
					dept_id_3.style.display = '';
					seri_no.style.display = '';
					seri_no2.style.display = '';
					dept_id_hidden.style.display = 'none';
					<!---$("#sort_type").empty();
					$("#sort_type").append('<option value="">Sıralama</option>');
					$("#sort_type").append('<option value="1">Lot No ya Göre Artan</option><option value="2">Lot No ya Göre Azalan</option>');
                    $("#sort_type").append('<option value="3">Kontrol No ya Göre Artan</option><option value="4">Kontrol No ya Göre Azalan</option>');
                    $("#sort_type").append('<option value="5">Kalite Sonucuna Göre Artan</option><option value="6">Kalite Sonucuna Göre Azalan</option>');--->

			}
			else
			{
				dept_id_2.style.display = '';
				dept_id_3.style.display = '';
				seri_no.style.display = '';
				seri_no2.style.display = '';
				dept_id_hidden.style.display = 'none';
				<!---$("#sort_type").empty();
				$("#sort_type").append('<option value="">Sıralama</option>');
				$("#sort_type").append('<option value="1">Lot No ya Göre Artan</option><option value="2">Lot No ya Göre Azalan</option>');
				$("#sort_type").append('<option value="3">Kontrol No ya Göre Artan</option><option value="4">Kontrol No ya Göre Azalan</option>');
				$("#sort_type").append('<option value="5">Kalite Sonucuna Göre Artan</option><option value="6">Kalite Sonucuna Göre Azalan</option>');--->
			}	
		}
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
