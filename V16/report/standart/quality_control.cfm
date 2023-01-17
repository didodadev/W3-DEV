<style>
	a.txtboldblue:link {  color: #ff692f; }
</style>
<cfif not isdefined("attributes.is_excel")>
	<cfsetting showdebugoutput="yes">
</cfif>
<cfparam name="attributes.process_cat_id"  default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.process_date" default="">
<cfparam name="attributes.stage" default="">
<cfparam name="attributes.controller_emp_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_filtre" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.controller_emp" default="">
<cfparam name="attributes.related_success_id" default="">
<cfparam name="attributes.error_type" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.process_date_fin" default="">
<cfif  isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif  isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdate(attributes.process_date)>
	<cf_date tarih="attributes.process_date">
</cfif>
<cfif isdate(attributes.process_date_fin)>
	<cf_date tarih="attributes.process_date_fin">
</cfif>
<cfquery name="get_stage" datasource="#dsn#">
	SELECT
		DISTINCT PTR.PROCESS_ROW_ID, 
		#dsn_alias#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'tr','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
      	PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.popup_add_quality_control_report%">
</cfquery>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
<cfset get_succes_names =get_queries.get_succes_name()>

<cfquery name="get_control_type" datasource="#dsn3#">
	SELECT TYPE_ID,QUALITY_CONTROL_TYPE FROM QUALITY_CONTROL_TYPE WHERE IS_ACTIVE = 1
</cfquery>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT
		PC.HIERARCHY,
		PC.PRODUCT_CAT,
		PC.IS_SUB_PRODUCT_CAT,
		PC.PRODUCT_CATID
	FROM
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PC.PRODUCT_CATID IS NOT NULL AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		PC.HIERARCHY
</cfquery>
<cfif isdefined("attributes.form_varmi")>
<cfquery name="quality_row" datasource="#dsn3#">
<cfif not isdefined("attributes.is_excel")>
 	WITH CTE1 AS(
</cfif>
	<cfif attributes.process_cat_id eq 76 or attributes.process_cat_id eq 811>
      	SELECT <!--- irsaliye/ithal mal girişi --->
			DISTINCT ORQ.OR_Q_ID,
			QS.SUCCESS,
			ORQ.Q_CONTROL_NO,
			ORQ.RECORD_DATE,
			ORQ.CONTROL_AMOUNT,
			QCR.QUALITY_CONTROL_ROW,
			QRQR.QUALITY_DETAIL,
			SR.LOT_NO,
			ISNULL(ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE),0) DEFAULT_VALUE,
			ISNULL(PQ.TOLERANCE,QCR.TOLERANCE) TOLERANCE,
			ISNULL(PQ.TOLERANCE_2,QCR.TOLERANCE_2) TOLERANCE_2,
			SR.AMOUNT,
			S.SHIP_ID,
			S.SHIP_NUMBER PAPER_NO,
			S.DELIVER_DATE PAPER_DATE,
			SR.AMOUNT PAPER_AMOUNT,
			QCT.QUALITY_CONTROL_TYPE,
			ISNULL(QRQR.CONTROL_RESULT,0) CONTROL_RESULT,
			P.PRODUCT_NAME,
			SS.PRODUCT_NAME AS PRODUCT_NAME_,
			CASE WHEN ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)<>0 AND  ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)<>NULL THEN
				(QRQR.CONTROL_RESULT/ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)) 
			ELSE
				QRQR.CONTROL_RESULT 
			END SAPMA,
			--(QRQR.CONTROL_RESULT/ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)) SAPMA,
			(SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID=ORQ.STAGE) AS STAGE,
			(SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE ORQ.CONTROLLER_EMP_ID=E.EMPLOYEE_ID) CONTROLLER_EMP_NAME
		FROM 
			ORDER_RESULT_QUALITY ORQ
			LEFT JOIN STOCKS SS ON SS.STOCK_ID = ORQ.STOCK_ID
			LEFT JOIN #dsn2_alias#.SHIP S ON S.SHIP_ID=ORQ.PROCESS_ID
			LEFT JOIN #dsn2_alias#.SHIP_ROW SR ON SR.SHIP_ID=S.SHIP_ID AND S.SHIP_STATUS = 1 AND S.SHIP_TYPE = ORQ.PROCESS_CAT AND ORQ.SHIP_WRK_ROW_ID=SR.WRK_ROW_ID
			LEFT JOIN #dsn3_alias#.PRODUCT_QUALITY PQ ON PQ.PRODUCT_ID=SR.PRODUCT_ID AND SR.STOCK_ID=SR.STOCK_ID AND PQ.PROCESS_CAT=ORQ.PROCESS_CAT
			LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QCT ON QCT.TYPE_ID=PQ.QUALITY_TYPE_ID
			LEFT JOIN ORDER_RESULT_QUALITY_ROW QRQR ON QRQR.OR_Q_ID=ORQ.OR_Q_ID AND QRQR.CONTROL_TYPE_ID=QCT.TYPE_ID
			LEFT JOIN QUALITY_SUCCESS QS ON ORQ.SUCCESS_ID=QS.SUCCESS_ID
			LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID=PQ.PRODUCT_ID
			LEFT JOIN QUALITY_CONTROL_ROW QCR ON QCR.QUALITY_CONTROL_TYPE_ID= QCT.TYPE_ID AND QCR.QUALITY_CONTROL_ROW_ID = QRQR.CONTROL_ROW_ID
		WHERE
			<cfif attributes.process_cat_id eq 76>
				ORQ.PROCESS_CAT=76
			<cfelseif attributes.process_cat_id eq 811>
				ORQ.PROCESS_CAT=811
			</cfif>
			<cfif len(attributes.is_filtre)>
				AND S.SHIP_NUMBER LIKE '%#attributes.is_filtre#%'
			</cfif>
			<cfif len(attributes.lot_no)>
				AND SR.LOT_NO LIKE '%#attributes.lot_no#%'
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				AND PQ.PRODUCT_ID=#attributes.product_id#
			</cfif>
			<cfif len(attributes.related_success_id)>
				AND QCT.TYPE_ID=#attributes.related_success_id#
			</cfif>
			<cfif len(attributes.error_type)>
				AND QS.SUCCESS_ID=#attributes.error_type#
			</cfif>
			<cfif len(attributes.process_date)>
				AND S.SHIP_DATE > #dateadd('d',-1,attributes.process_date)#
			</cfif>
            <cfif len(attributes.process_date_fin)>
				AND S.SHIP_DATE < #dateadd('d',1,attributes.process_date_fin)#
			</cfif>
			<cfif len(attributes.start_date)>
				AND ORQ.RECORD_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND ORQ.RECORD_DATE <= #attributes.finish_date#
			</cfif>
			<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
				AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
			</cfif>
			<cfif len(attributes.category)>
				AND(
				<cfloop list="#attributes.category#" delimiters="," index="i">
					P.PRODUCT_CODE LIKE '#i#.%'
					<cfif listlast(attributes.category) neq i>
						OR
					</cfif>
				</cfloop>
				)
			</cfif>
			<cfif len(attributes.stage)>
				AND ORQ.STAGE=#attributes.stage#			
			</cfif>
	<cfelseif attributes.process_cat_id eq 171>
		SELECT <!--- uretim sonucu --->
			DISTINCT ORQ.OR_Q_ID,
			QS.SUCCESS,
			ORQ.Q_CONTROL_NO,
			ORQ.RECORD_DATE,
			ORQ.CONTROL_AMOUNT,
			QCR.QUALITY_CONTROL_ROW,
			QRQR.QUALITY_DETAIL,
			POR.LOT_NO,
			ISNULL(ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE),0) DEFAULT_VALUE,
			ISNULL(PQ.TOLERANCE,QCR.TOLERANCE) TOLERANCE,
			ISNULL(PQ.TOLERANCE_2,QCR.TOLERANCE_2) TOLERANCE_2,
			PORR.AMOUNT,
			POR.P_ORDER_ID,
			POR.PR_ORDER_ID,
			POR.RESULT_NO PAPER_NO,
			POR.FINISH_DATE PAPER_DATE,
			PORR.AMOUNT PAPER_AMOUNT,
			QCT.QUALITY_CONTROL_TYPE,
			ISNULL(QRQR.CONTROL_RESULT,0) CONTROL_RESULT,
			P.PRODUCT_NAME,
			SS.PRODUCT_NAME AS PRODUCT_NAME_,
			CASE WHEN ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)<>0 AND  ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)<>NULL THEN
				(QRQR.CONTROL_RESULT/ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)) 
			ELSE
				QRQR.CONTROL_RESULT 
			END SAPMA,
			(SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID=ORQ.STAGE) AS STAGE,
			(SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE ORQ.CONTROLLER_EMP_ID=E.EMPLOYEE_ID) CONTROLLER_EMP_NAME
		FROM 
			ORDER_RESULT_QUALITY ORQ
			LEFT JOIN STOCKS SS ON SS.STOCK_ID = ORQ.STOCK_ID
			LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW PORR ON PORR.PR_ORDER_ROW_ID=ORQ.PROCESS_ROW_ID 
			LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PORR.PR_ORDER_ID = POR.PR_ORDER_ID 
		--	LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON  ORQ.PROCESS_ROW_ID = POR.PR_ORDER_ID 
		--	LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW PORR ON POR.PR_ORDER_ID=PORR.PR_ORDER_ID
			LEFT JOIN #dsn3_alias#.PRODUCT_QUALITY PQ ON PQ.PRODUCT_ID=PORR.PRODUCT_ID AND PQ.PROCESS_CAT=ORQ.PROCESS_CAT
			LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QCT ON QCT.TYPE_ID=PQ.QUALITY_TYPE_ID 
			LEFT JOIN ORDER_RESULT_QUALITY_ROW QRQR ON QRQR.OR_Q_ID=ORQ.OR_Q_ID AND QRQR.CONTROL_TYPE_ID=QCT.TYPE_ID
			LEFT JOIN QUALITY_SUCCESS QS ON ORQ.SUCCESS_ID=QS.SUCCESS_ID
			LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID=PQ.PRODUCT_ID 
			LEFT JOIN QUALITY_CONTROL_ROW QCR ON QCR.QUALITY_CONTROL_TYPE_ID= QCT.TYPE_ID AND QCR.QUALITY_CONTROL_ROW_ID = QRQR.CONTROL_ROW_ID
		WHERE
			ORQ.PROCESS_CAT=171
			AND P.PRODUCT_ID IS NOT NULL
			<cfif len(attributes.is_filtre)>
				AND 
				(
					POR.RESULT_NO LIKE '%#attributes.is_filtre#%'
					OR ORQ.Q_CONTROL_NO LIKE '%#attributes.is_filtre#%'
				
				)
			</cfif>
			<cfif len(attributes.lot_no)>
				AND POR.LOT_NO LIKE '%#attributes.lot_no#%'
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				AND PQ.PRODUCT_ID=#attributes.product_id#
			</cfif>
			<cfif len(attributes.related_success_id)>
				AND QCT.TYPE_ID=#attributes.related_success_id#
			</cfif>
			<cfif len(attributes.error_type)>
				AND QS.SUCCESS_ID=#attributes.error_type#
			</cfif>
			<cfif len(attributes.process_date)>
				AND POR.START_DATE > #dateadd('d',-1,attributes.process_date)#
			</cfif>
			<cfif len(attributes.process_date_fin)>
				AND POR.START_DATE < #dateadd('d',1,attributes.process_date_fin)#
			</cfif>
			<cfif len(attributes.start_date)>
				AND ORQ.RECORD_DATE >=#attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND ORQ.RECORD_DATE <=#attributes.finish_date#
			</cfif>
			<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
				AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
			</cfif>
			<cfif len(attributes.category)>
				AND(
				<cfloop list="#attributes.category#" delimiters="," index="i">
					P.PRODUCT_CODE LIKE '#i#.%'
					<cfif listlast(attributes.category) neq i>
						OR
					</cfif>
				</cfloop>
				)
			</cfif>
			<cfif len(attributes.stage)>
				AND ORQ.STAGE=#attributes.stage#			
			</cfif>
	<cfelseif attributes.process_cat_id eq -1>
		SELECT<!--- operasyonlar --->
			DISTINCT ORQ.OR_Q_ID,
			ORQ.SUCCESS_ID,
			ORQ.Q_CONTROL_NO,
			POS.P_ORDER_NO PAPER_NO,
			QRQR.QUALITY_DETAIL, 
			POS.P_ORDER_ID,
			POS.FINISH_DATE PAPER_DATE,
			QCR.QUALITY_CONTROL_ROW,
			ORQ.RECORD_DATE,
			ORQ.CONTROL_AMOUNT,
			ORQ.PROCESS_CAT,
			QS.SUCCESS,
			POS.LOT_NO,
			SO.PRODUCT_NAME,
			SS.PRODUCT_NAME AS PRODUCT_NAME_,
			ISNULL(ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE),0) DEFAULT_VALUE,
			ISNULL(PQ.TOLERANCE,QCR.TOLERANCE) TOLERANCE,
			ISNULL(PQ.TOLERANCE_2,QCR.TOLERANCE_2) TOLERANCE_2,
			PO.AMOUNT PAPER_AMOUNT,
			QCT.QUALITY_CONTROL_TYPE,
			ISNULL(QRQR.CONTROL_RESULT,0) CONTROL_RESULT,
			CASE WHEN ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)<>0 AND  ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)<>NULL THEN
				(QRQR.CONTROL_RESULT/ISNULL(PQ.DEFAULT_VALUE,QCR.QUALITY_VALUE)) 
			ELSE
				QRQR.CONTROL_RESULT 
			END SAPMA, 
			(SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID=ORQ.STAGE) AS STAGE,
			(SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE ORQ.CONTROLLER_EMP_ID=E.EMPLOYEE_ID) CONTROLLER_EMP_NAME
		FROM 
			ORDER_RESULT_QUALITY ORQ
			LEFT JOIN STOCKS SS ON SS.STOCK_ID = ORQ.STOCK_ID
			LEFT JOIN PRODUCTION_ORDERS POS ON  ORQ.PROCESS_ID = POS.P_ORDER_ID
			LEFT JOIN STOCKS SO ON SO.STOCK_ID=POS.STOCK_ID
			LEFT JOIN PRODUCT P ON P.PRODUCT_ID=SO.PRODUCT_ID
			LEFT JOIN #dsn3_alias#.PRODUCT_QUALITY PQ ON PQ.PRODUCT_ID=SO.PRODUCT_ID  AND PQ.PROCESS_CAT=ORQ.PROCESS_CAT
			LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QCT ON QCT.TYPE_ID=PQ.QUALITY_TYPE_ID 
			LEFT JOIN ORDER_RESULT_QUALITY_ROW QRQR ON QRQR.OR_Q_ID=ORQ.OR_Q_ID AND QRQR.CONTROL_TYPE_ID=QCT.TYPE_ID
			LEFT JOIN QUALITY_SUCCESS QS ON ORQ.SUCCESS_ID=QS.SUCCESS_ID
			LEFT JOIN PRODUCTION_OPERATION_RESULT POR ON POR.P_ORDER_ID=POS.P_ORDER_ID
			LEFT JOIN PRODUCTION_OPERATION PO ON PO.P_OPERATION_ID=POR.OPERATION_ID
			LEFT JOIN QUALITY_CONTROL_ROW QCR ON QCR.QUALITY_CONTROL_TYPE_ID= QCT.TYPE_ID AND QCR.QUALITY_CONTROL_ROW_ID = QRQR.CONTROL_ROW_ID
		WHERE
			ORQ.PROCESS_CAT = -1
			<cfif len(attributes.is_filtre)>
				AND POS.P_ORDER_NO LIKE '%#attributes.is_filtre#%'
			</cfif>
			<cfif len(attributes.lot_no)>
				AND POS.LOT_NO LIKE '%#attributes.lot_no#%'
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				AND PQ.PRODUCT_ID=#attributes.product_id#
			</cfif>
			<cfif len(attributes.related_success_id)>
				AND QCT.TYPE_ID=#attributes.related_success_id#
			</cfif>
			<cfif len(attributes.error_type)>
				AND QS.SUCCESS_ID=#attributes.error_type#
			</cfif>
			<cfif len(attributes.process_date)>
				AND POS.START_DATE > #dateadd('d',-1,attributes.process_date)#
			</cfif>
			<cfif len(attributes.process_date_fin)>
				AND POS.START_DATE < #dateadd('d',1,attributes.process_date_fin)#
			</cfif>
			<cfif len(attributes.start_date)>
				AND ORQ.RECORD_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND ORQ.RECORD_DATE <= #attributes.finish_date#
			</cfif>
			<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
				AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
			</cfif>
			<cfif len(attributes.category)>
				AND(
				<cfloop list="#attributes.category#" delimiters="," index="i">
					P.PRODUCT_CODE LIKE '#i#.%'
					<cfif listlast(attributes.category) neq i>
						OR
					</cfif>
				</cfloop>
				)
			</cfif>
			<cfif len(attributes.stage)>
				AND ORQ.STAGE=#attributes.stage#			
			</cfif>
		</cfif>
        <cfif not isdefined("attributes.is_excel")>
        ),CTE2 AS 
		(
        SELECT
            CTE1.*,
            ROW_NUMBER() OVER (ORDER BY OR_Q_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
        FROM
            CTE1
		)
		SELECT
			CTE2.*
		FROM
			CTE2
		WHERE
			RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) 
       </cfif>
</cfquery>
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfif not isdefined("quality_row.QUERY_COUNT")>
    	<cfparam name="attributes.totalrecords" default="#quality_row.recordcount#">
    <cfelse>
    	<cfparam name="attributes.totalrecords" default="#quality_row.QUERY_COUNT#">
    </cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>

<cfform name="quality_control" id="quality_control" method="post" action="#request.self#?fuseaction=report.quality_control_report">
	<input name="form_varmi" id="form_varmi" value="1" type="hidden">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40589.Kalite Kontrol Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<cfoutput>
								<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" name="is_filtre" id="is_filtre" style="width:90px;" value="#attributes.is_filtre#">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='40663.Lot No'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
											   <input type="text" name="lot_no" id="lot_no" style="width:90px;" value="#attributes.lot_no#">
											</div>
										</div>
										<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<select name="category" id="category" multiple="multiple" style="width:170px;">
														<cfloop query="get_product_cat">
															<option value="#hierarchy#" <cfif listfind(attributes.category,hierarchy,',')>selected</cfif>>
																#hierarchy# - #product_cat#
															</option>
														</cfloop>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="product_id" id="product_id" value="#attributes.product_id#">
													<input type="text" name="product_name" id="product_name" style="width:100px;" value="#attributes.product_name#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');" style="width:100px;">
													<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=quality_control.product_id&field_name=quality_control.product_name','list');"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
							 	<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58684.Hata Tipi'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<select name="error_type" id="error_type" style="width:110px;">
                                                    <option value=""><cf_get_lang dictionary_id='58684.Hata Tipi'></option>
                                                    <cfloop query="get_succes_names">
														<option value="#success_id#" <cfif attributes.error_type eq success_id>selected</cfif>>#SUCCESS#</option>
													</cfloop>
                                                </select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<select name="process_cat_id" id="process_cat_id" style="width:100px;">
													<option value="76" <cfif attributes.process_cat_id eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
													<option value="171" <cfif attributes.process_cat_id eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
													<option value="811" <cfif attributes.process_cat_id eq 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></option>
													<option value="-1" <cfif attributes.process_cat_id eq -1>selected</cfif>><cf_get_lang dictionary_Id='54365.Operasyonlar'></option>
												</select>
											</div>	
										</div>
										<div class="col col-12 col-xs-12 surec">
											<div class="form-group">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58054.Süreç/Aşama'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<select name="stage" id="stage" style="width:110px;">
														<option value=""><cf_get_lang dictionary_id='58054.Süreç/Aşama'></option>
														<cfloop query="get_stage">
															<option value="#PROCESS_ROW_ID#" <cfif attributes.stage eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
														</cfloop>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='40004.Kalite Tipi'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<select name="related_success_id" id="related_success_id" style="width:110px;">
														<option value=""><cf_get_lang dictionary_id='40004.Kalite Tipi'></option>
														<cfloop query="get_control_type">
															<option value="#type_id#" <cfif attributes.related_success_id eq type_id>selected</cfif>>#quality_control_type#</option>
														</cfloop>
													</select>
												</div>
											</div>
										</div>
								    </div>
								</div>
								<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='40001.Kontrol Eden'></label>
										<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="controller_emp_id" id="controller_emp_id" value="<cfif len(attributes.controller_emp_id)>#attributes.controller_emp_id#</cfif>">			
												<input type="text" name="controller_emp" id="controller_emp" value="<cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>#attributes.controller_emp#</cfif>" onfocus="AutoComplete_Create('controller_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id','','3','130');" autocomplete="off" style="width:100px;">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=quality_control.controller_emp_id&field_name=quality_control.controller_emp&select_list=1</cfoutput>','list');"></span>
											</div>
										</div>
									</div>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="process_date" id="process_date"  value="#dateformat(attributes.process_date,dateformat_style)#" style="width:65px;" validate="#validate_style#"  maxlength="10">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="process_date">
													</span>	
												</div>	
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="process_date_fin" id="process_date_fin"  value="#dateformat(attributes.process_date_fin,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="process_date_fin">
													</span>	
												</div>		
											</div>	
										</div>
									</div>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_Id='47396.Kontrol'><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="start_date" id="start_date"  value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="start_date">
													</span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_Id='47396.Kontrol'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="finish_date" id="finish_date"  value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finish_date">
													</span>		
												</div>
											</div>
										</div>
									</div>	
								</div>	 
						   </cfoutput>
						</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent></label>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="form_varmi" id="form_varmi" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>					
						</div> 
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search> 
</cfform>
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset filename= "#dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmm')#">
        <cfheader name="Expires" value="#Now()#">
      <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <cfset attributes.startrow=1>
        <cfset attributes.maxrows =attributes.totalrecords>
	</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='58054.Süreç/Aşama'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='40008.Kontrol Tipi'></th>
				<th><cf_get_lang dictionary_id='57756.Durum'></th>
				<th><cf_get_lang dictionary_id='40009.Kalite'></th>
				<th><cf_get_lang dictionary_id='40010.Kontrol Numarası'></th>
				<th><cf_get_lang dictionary_id='40011.Kontrol Tarihi'></th>
				<th><cf_get_lang dictionary_id='40001.Kontrol Eden'></th>
				<th><cf_get_lang dictionary_id='40012.Kontrol Edilen Miktar'></th>
				<th><cf_get_lang dictionary_Id='30868.Parti'>/<cf_get_lang dictionary_id='29412.seri'><cf_get_lang dictionary_Id='32916.lot no'></th>
				<th>std. <cf_get_lang dictionary_id='58660.değer'></th>
				<th><cf_get_lang dictionary_id='40013.Alt Sınır'></th>
				<th><cf_get_lang dictionary_id='40014.Üst Sınır'></th>
				<th><cf_get_lang dictionary_id='56089.Üst Sınır'> <cf_get_lang dictionary_id='58660.Değer'></th>
				<th><cf_get_lang dictionary_id='58660.Değer'></th>
				<th>
					<cfif attributes.process_cat_id eq 811>
						<cf_get_lang dictionary_id='29588.ithal mal girişi'><cf_get_lang dictionary_id='57487.No'>
					<cfelseif attributes.process_cat_id eq 171>
						<cf_get_lang dictionary_id='40015.Üretim No'>
					<cfelseif attributes.process_cat_id eq -1>
					<cf_get_lang dictionary_id='29588.ithal mal girişi'><cf_get_lang dictionary_id='57487.No'>
					<cfelse>
					<cf_get_lang dictionary_id='58138.irsaliye No'>
					</cfif>
				</th>
				<th>
					<cfif attributes.process_cat_id eq 811>
						<cf_get_lang dictionary_id='29588.ithal mal girişi'> <cf_get_lang dictionary_id='40730.Sonuç tarihi'>
					<cfelseif attributes.process_cat_id eq 171>
						<cf_get_lang dictionary_id='57456.Üretim'> <cf_get_lang dictionary_id='40730.Sonuç tarihi'>
					<cfelseif attributes.process_cat_id eq -1>
						<cf_get_lang dictionary_id='29419.Operasyon'> <cf_get_lang dictionary_id='40730.Sonuç tarihi'>
					<cfelse>
						<cf_get_lang dictionary_id='39286.İrsaliye tarihi'>
					</cfif>
				</th>
				<th>
					<cfif attributes.process_cat_id eq 811>
						<cf_get_lang dictionary_id='29588.ithal mal girişi'> <cf_get_lang dictionary_id='57635.Miktar'>
					<cfelseif attributes.process_cat_id eq 171>
						<cf_get_lang dictionary_id='57456.Üretim'></br><cf_get_lang dictionary_id='57635.Miktar'>
					<cfelseif attributes.process_cat_id eq -1>
					<cf_get_lang dictionary_id='29419.Operasyon'></br><cf_get_lang dictionary_id='57635.Miktar'>
					<cfelse>
						<cf_get_lang dictionary_id='57773.irsaliye'></br><cf_get_lang dictionary_id='57635.Miktar'>
					</cfif>
				</th>
				<th></br><cf_get_lang dictionary_id='57629.Açıklama'></th>
		    </tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.form_varmi") and quality_row.recordcount>
				<cfoutput query="quality_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr class="color-row">
						<td><cfif isdefined("attributes.is_excel")>#currentrow#<cfelse>#RowNum#</cfif></td>
						<td>#STAGE#</td>
						<td><cfif len(product_name)>#product_name#<cfelse>#product_name_#</cfif></td>
						<td>#quality_control_type#</td>
						<td>#quality_control_row#</td>
						<td>#success#</td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.list_quality_controls&event=upd&or_q_id=#OR_Q_ID#','list')">#q_control_no#</a></td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<td>#controller_emp_name#</td>
						<td>#control_amount#</td>
						<td>#lot_no#</td>
						<td>#default_value#</td>
						<td>#tolerance#</td>
						<td>#tolerance_2#</td>
						<td>#control_result#</td>
						<td>#default_value-control_result#</td>
						<td>
							<cfif attributes.process_cat_id eq 76><!--- Mal Alım İrsaliyesi --->
								<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#ship_id#">#paper_no#</a>
							<cfelseif attributes.process_cat_id eq 171><!--- üretim sonucu --->
								<a href="#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#p_order_id#&pr_order_id=#pr_order_id#" >#paper_no#</a>
							<cfelseif attributes.process_cat_id eq 811><!--- ithal mal girişi --->
								<a href="#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id=#ship_id#">#paper_no#</a>
							<cfelseif attributes.process_cat_id eq -1><!--- operasyonlar --->
								<a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#p_order_id#">#paper_no#</a>
							</cfif>
						</td>
						<td>#dateformat(paper_date,dateformat_style)#</td>
						<td>#paper_amount#</td>
						<td>#quality_detail#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td></tr>
			</cfif>
		</tbody>
	</cf_report_list>

    <cfset url_str = "report.quality_control_report">
	<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            <cfset url_str = "#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
        </cfif>
        <cfif len(attributes.is_filtre)>
            <cfset url_str = "#url_str#&is_filtre=#attributes.is_filtre#">
        </cfif>
        <cfif len(attributes.related_success_id)>
            <cfset url_str = "#url_str#&related_success_id=#attributes.related_success_id#">
        </cfif>
        <cfif len(attributes.start_date)>
            <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
        </cfif>
        <cfif len(attributes.process_cat_id)>
            <cfset url_str = "#url_str#&process_cat_id=#attributes.process_cat_id#">
        </cfif>
        <cfif len(attributes.process_date)>
            <cfset url_str = "#url_str#&process_date=#dateFormat(attributes.process_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.process_date_fin)>
			<cfset url_str = "#url_str#&process_date_fin=#dateFormat(attributes.process_date_fin,dateformat_style)#">
		</cfif>
        <cfif len(attributes.error_type)>
            <cfset url_str = "#url_str#&error_type=#attributes.error_type#">
        </cfif>
        <cfif len(attributes.lot_no)>
            <cfset url_str = "#url_str#&lot_no=#attributes.lot_no#">
        </cfif>
          <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#&form_varmi=1">
   
    </cfif>
</cfif>
<script>
    function control(){   
		if(!date_check(quality_control.process_date,quality_control.process_date_fin,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}  
		if(!date_check(quality_control.start_date,quality_control.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}  		
		if(document.quality_control.is_excel.checked==false)
			{
				document.quality_control.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
				return true;
			}
			else
				document.quality_control.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_quality_control_report</cfoutput>"
	}
	$( window ).resize(function() {
		$('.msnry').masonry();
	});
</script>