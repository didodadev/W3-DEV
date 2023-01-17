<!--- Sayfa Kalite Konrol Yapmak için kullanılıyor,birçok yerden çağırılıyor,ama genel olarak 2 şekilde geliyor
1.Üretim Sonuç'dan Kalite Kontrol(171) ve Mal Alım İrsaliyesinden(76).Bu gelen PROCESS_CAT'lara görede sayfayı şekillendiriyoruz..--->
<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="prod">
<cf_xml_page_edit fuseact="prod.popup_add_quality_control_report">
<cfset get_quality_success =createObject("component","V16.production_plan.cfc.get_succes_name").get_succes_name()>
<!--- Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
<cfif attributes.process_cat eq 171><cfset paper_type_ = "PRODUCTION_QUALITY_CONTROL"><cf_papers paper_type="production_quality_control"></cfif>
<cfif not isDefined("paper_number") or not Len(paper_number)><cfset paper_type_ = "QUALITY_CONTROL"><cf_papers paper_type="quality_control"></cfif>
<!--- //Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.left" default="0">
<cfparam name="attributes.controller_emp_id" default="#session.ep.userid#">
<cfparam name="attributes.controller_emp" default="#get_emp_info(session.ep.userid,0,0)#">
<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
<cfquery name="get_order_no" datasource="#dsn3#">
	<cfif attributes.process_cat eq 171><!--- Üretim Sonucu --->
        SELECT
            ISNULL((SELECT AMOUNT FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = POR.PR_ORDER_ID AND TYPE=1 AND WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">),0) AS QUANTITY, <!--- SADECE ANA ÜRÜN İÇİN ÜRETİM MİKTARI --->
            PO.P_ORDER_NO,
            POR.RESULT_NO,
			0 AS COMPANY_ID
        FROM 
            PRODUCTION_ORDERS PO,
            PRODUCTION_ORDER_RESULTS POR
        WHERE
            POR.P_ORDER_ID = PO.P_ORDER_ID AND
            POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
    <cfelseif attributes.process_cat eq 76 or attributes.process_cat eq 811><!--- Mal Alım İrsaliyesi,İthal Mal Girişi --->
		SELECT 
			SR.AMOUNT AS QUANTITY,
			S.SHIP_NUMBER AS P_ORDER_NO,
			S.SHIP_NUMBER AS RESULT_NO,
			ISNULL(S.COMPANY_ID,0) AS COMPANY_ID 
		FROM 
			#dsn2_alias#.SHIP S,
            #dsn2_alias#.SHIP_ROW SR
		WHERE 
			S.SHIP_ID = SR.SHIP_ID AND 
			S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND 
			SR.SHIP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND
			S.SHIP_TYPE IN(76,811)
	<cfelseif attributes.process_cat eq -1><!--- Operasyonlar --->
		SELECT
			ISNULL(PO.AMOUNT,0) AS QUANTITY,
			POS.P_ORDER_NO,
			POS.P_ORDER_NO AS RESULT_NO ,
			0 AS COMPANY_ID
		FROM
			PRODUCTION_OPERATION_RESULT POR,
			PRODUCTION_OPERATION PO,
			PRODUCTION_ORDERS POS
		WHERE
			POR.P_ORDER_ID = POS.P_ORDER_ID AND
			PO.P_OPERATION_ID = POR.OPERATION_ID AND
			POR.OPERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
    <cfelseif attributes.process_cat eq -2><!--- Servis --->
		SELECT
			1 QUANTITY,
			SERVICE_HEAD P_ORDER_NO,
			SERVICE_HEAD  AS RESULT_NO,
			0 AS COMPANY_ID
		FROM 
			SERVICE
		WHERE	
			SERVICE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
	<cfelseif attributes.process_cat eq -3><!--- Lab İşlemleri --->
		SELECT
			LSR.SAMPLE_AMOUNT QUANTITY,
			RLT.LAB_REPORT_NO P_ORDER_NO,
			RLT.LAB_REPORT_NO  AS RESULT_NO,
			0 AS COMPANY_ID
		FROM 
			#dsn#.REFINERY_LAB_TESTS RLT
			LEFT JOIN #dsn#.LAB_SAMPLING LS ON RLT.REFINERY_LAB_TEST_ID = LS.SAMPLE_ANALYSIS_ID
			LEFT JOIN #dsn#.LAB_SAMPLING_ROW LSR ON LSR.SAMPLING_ID = LS.SAMPLING_ID
		WHERE	
			LSR.SAMPLING_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
	</cfif>
</cfquery>
<cfquery name="get_quality_list" datasource="#dsn3#">
	SELECT
		ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT
	FROM 
		ORDER_RESULT_QUALITY ORQ 
	WHERE
		IS_REPROCESS = 0 AND
		PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
		(
            (PROCESS_CAT IN(76,811,171) AND SHIP_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">) OR
            (PROCESS_CAT NOT IN(76,811,171) AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">)
		)
</cfquery>

<cfset pageHead = #getLang('prod',337)# & " : " & #get_order_no.P_ORDER_NO# >

<cfif fuseaction neq 'prod.popup_add_quality_control_report'>
	<cf_catalystHeader>
</cfif>
	<cfif len(attributes.stock_id)>
		<cfquery name="get_product_info" datasource="#dsn3#">
			SELECT PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfquery>
	</cfif>
	<cfquery name="pro_detail" datasource="#dsn3#">
		SELECT IS_SERIAL_NO FROM PRODUCT WHERE PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.PRODUCT_ID#">
	</cfquery>
	<cfparam name="process_cat" default="#attributes.process_cat#">
	<cfquery name="get_quality_type" datasource="#dsn3#">
		SELECT 
			CCT.QUALITY_CONTROL_TYPE,
			CCT.TYPE_ID,
			CCT.QUALITY_MEASURE,
			CCT.TYPE_DESCRIPTION,
			CCT.STANDART_VALUE,
			PQ.*
		FROM
			QUALITY_CONTROL_TYPE CCT,
			PRODUCT_QUALITY PQ
		WHERE 
			PQ.QUALITY_TYPE_ID = CCT.TYPE_ID AND
			<cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
				PQ.PRODUCT_ID IS NOT NULL AND
				PQ.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> AND
			<cfelse>
				1 = 0 AND	
			</cfif>
			PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat#">
			<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
				AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
			</cfif>
		ORDER BY
			PQ.PRODUCT_ID,
			PQ.PRODUCT_CAT_ID,
			PQ.ORDER_NO,
			PQ.QUALITY_TYPE_ID
	</cfquery>
	<cfif not get_quality_type.recordcount><!--- Urunde Yoksa Kategoriye Bakilir --->
		<cfquery name="get_quality_type" datasource="#dsn3#">
			SELECT 
				CCT.QUALITY_CONTROL_TYPE,
				CCT.TYPE_ID,
				CCT.QUALITY_MEASURE,
				CCT.TYPE_DESCRIPTION,
				CCT.STANDART_VALUE,
				PQ.*
			FROM
				QUALITY_CONTROL_TYPE CCT,
				PRODUCT_QUALITY PQ
			WHERE 
				PQ.QUALITY_TYPE_ID = CCT.TYPE_ID AND
				<cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
					PQ.PRODUCT_CAT_ID IS  NOT NULL AND PQ.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#"> AND
				<cfelse>
					1 = 0 AND	
				</cfif>
				PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat#">
				<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
					AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
				</cfif>
			ORDER BY
				PQ.PRODUCT_ID,
				PQ.PRODUCT_CAT_ID,
				PQ.ORDER_NO,
				PQ.QUALITY_TYPE_ID
		</cfquery>
	</cfif>
	<cfset new_round_num = 4>
	<cfif isDefined("attributes.or_q_id") and Len(attributes.or_q_id)>
		<cfquery name="get_order_result_quality_row" datasource="#dsn3#">
			SELECT * FROM ORDER_RESULT_QUALITY_ROW WHERE OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.or_q_id#">
		</cfquery>
		
		<cfset new_stock_id = get_quality_result.stock_id>
		<cfset new_process_id = get_quality_result.process_id>
		<cfset new_process_row_id = get_quality_result.process_row_id>
		<cfset new_process_cat = get_quality_result.process_cat>
		<cfset new_qid = get_quality_result.or_q_id>
	<cfelse>
		<cfset get_order_result_quality_row.recordcount = 0>
		<cfquery name="get_amount_control" datasource="#dsn3#" maxrows="1">
			SELECT
				IS_ALL_AMOUNT
			FROM
				ORDER_RESULT_QUALITY
			WHERE
				IS_ALL_AMOUNT = 1 AND
				PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
				(
					(PROCESS_CAT IN(76,811,171) AND SHIP_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">) OR
					(PROCESS_CAT NOT IN(76,811,171) AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">)
				)
		</cfquery>
		
		<cfset new_stock_id = attributes.stock_id>
		<cfset new_process_id = attributes.process_id>
		<cfset new_process_row_id = attributes.process_row_id>
		<cfset new_process_cat = attributes.process_cat>
		<cfset new_qid = "">
	</cfif>
	<!--- Kalan Miktar Kontrolu ---><!--- ??? KONTROL EDİLECEK... --->
	<cfquery name="get_diff_amount" datasource="#dsn3#">
		SELECT ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT FROM ORDER_RESULT_QUALITY WHERE IS_REPROCESS= 0 AND STOCK_ID = #new_stock_id# AND PROCESS_ID = #new_process_id# AND PROCESS_ROW_ID = #new_process_row_id# AND PROCESS_CAT = #new_process_cat# <cfif Len(new_qid)> AND OR_Q_ID <> #new_qid#</cfif>
	</cfquery>
	
	<cfset Sample_Count = 0>
	<cfif len(get_product_info.product_id) and len(get_order_no.company_id) and len(get_product_info.product_catid)>
		<cfquery name="get_paper_inspection" datasource="#dsn3#">
			SELECT INSPECTION_LEVEL_ID FROM PRODUCT_MEMBER_INSPECTION_LEVEL WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_no.company_id#"> AND (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> OR PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#">)
		</cfquery>
	<cfelse>
		<cfset get_paper_inspection.recordcount = 0>
	</cfif>
	
	<cfif not get_paper_inspection.recordcount>
		<cfquery name="get_paper_inspection" datasource="#dsn3#">
			SELECT INSPECTION_LEVEL_ID FROM SETUP_INSPECTION_LEVEL WHERE IS_DEFAULT = 1
		</cfquery>
	</cfif>
	
	<cfif Len(get_paper_inspection.inspection_level_id) and len(get_product_info.product_id) and len(get_order_no.quantity)>
		<cfquery name="Get_Inspection_Level_Info" datasource="#dsn3#">
			SELECT
				SAMPLE_QUANTITY,
				ACCEPTANCE_QUANTITY,
				REJECTION_QUANTITY
			FROM 
				PRODUCT_QUALITY_PARAMETERS PQP,
				SETUP_INSPECTION_LEVEL SIL
			WHERE
				PQP.INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_paper_inspection.inspection_level_id#"> AND
				PQP.INSPECTION_LEVEL_ID = SIL.INSPECTION_LEVEL_ID AND
				PQP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> AND
				PQP.MIN_QUANTITY <= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#"> AND PQP.MAX_QUANTITY >= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#">
		</cfquery>
		<cfif not Get_Inspection_Level_Info.RecordCount>
			<cfquery name="Get_Inspection_Level_Info" datasource="#dsn3#">
				SELECT
					SAMPLE_QUANTITY,
					ACCEPTANCE_QUANTITY,
					REJECTION_QUANTITY
				FROM 
					PRODUCT_QUALITY_PARAMETERS PQP,
					SETUP_INSPECTION_LEVEL SIL
				WHERE
					PQP.INSPECTION_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_paper_inspection.inspection_level_id#"> AND
					PQP.INSPECTION_LEVEL_ID = SIL.INSPECTION_LEVEL_ID AND
					PQP.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#"> AND
					PQP.MIN_QUANTITY <= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#"> AND PQP.MAX_QUANTITY >= <cfqueryparam cfsqltype="cf_sql_float" value="#get_order_no.quantity#">
			</cfquery>
		</cfif>
		<cfif Len(Get_Inspection_Level_Info.Sample_Quantity)><cfset Sample_Count = Get_Inspection_Level_Info.Sample_Quantity></cfif>
		<cfif not Get_Inspection_Level_Info.RecordCount><cfset Get_Inspection_Level_Info.acceptance_quantity = 0><cfset Get_Inspection_Level_Info.rejection_quantity = 0></cfif>
	</cfif>
	<cfif Sample_Count eq 0><cfset Sample_Count = 1></cfif><!--- attributes.process_cat eq 171 and --->
	<cfset serial_required = 0>
	<cfif isDefined("xml_required_serial_number") and Len(xml_required_serial_number)>
		<cfif xml_required_serial_number eq 1 and attributes.process_cat eq 171>
			<cfset serial_required = 1>
		<cfelseif xml_required_serial_number eq 2 and ListFind("76,811",attributes.process_cat)>
			<cfset serial_required = 1>
		<cfelseif xml_required_serial_number eq 3>
			<cfset serial_required = 1>
		</cfif>
	</cfif>
	
<div class="col col-12 col-xs-12">
	<cf_box title="#iif(isdefined("get_product_info.product_id") and len(get_product_info.product_id),DE("#get_product_info.PRODUCT_NAME#"),DE(""))# #iif(isdefined("pro_detail.IS_SERIAL_NO") and pro_detail.IS_SERIAL_NO eq 1,DE("-&nbsp#getLang('','Seri No Kontrol','63526')#"),DE(""))#">
		<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
		<cfform name="add_quality" id="add_quality" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_quality_control_report" method="post">
			<cfoutput>
				<!--- Tarih --->
				<cf_box_elements>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
						<div class="ui-info-bottom">
							<div class="form-group col col-3 col md-3 col-sm-3 col-xs-6" id="item-file_no">
								<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='60244.Kaynak Belge No'>:</label>
								<label class="col col-8 col-xs-12"><cfoutput>#get_order_no.result_no#</cfoutput></label>
							</div>
							<div class="form-group col col-3 col md-3 col-sm-3 col-xs-6" id="item-stock_no">
								<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57800.İşlem Tipi'>:</label>
								<label class="col col-6 col-xs-12">
									<cfif attributes.process_cat eq 76><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></cfif>
									<cfif attributes.process_cat eq 171><cf_get_lang dictionary_id='29651.Üretim Sonucu'></cfif>
									<cfif attributes.process_cat eq 811><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></cfif>
									<cfif attributes.process_cat eq -1><cf_get_lang dictionary_id="36376.Operasyonlar"></cfif>
									<cfif attributes.process_cat eq -2><cf_get_lang dictionary_id="57656.Servis"></cfif>
									<cfif attributes.process_cat eq -3><cf_get_lang dictionary_id='64426.Laboratuvar İşlemi'></cfif>
								</label>
							</div>
							<div class="form-group col col-3 col md-3 col-sm-3 col-xs-6" id="item-stock_no">
								<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57518.Stok Kodu'>:</label>
								<label class="col col-8 col-xs-12"><cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)><cfoutput>#get_product_info.stock_code#</cfoutput></cfif></label>
							</div>
							<div class="form-group col col-3 col md-3 col-sm-3 col-xs-6" id="item-quantity">
								<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='59084.Parti Miktarı'>:</label>
								<label class="col col-8 col-xs-12"><cfoutput>#get_order_no.quantity#</cfoutput></label>
							</div>
						</div>
					</div>
				</cf_box_elements>
			</cfoutput>
			<!--- Yatay --->
			<div id="control_def">
				<cf_box_elements>
					<cfinclude template="quality_control_report_horizontal.cfm">
				</cf_box_elements>
			</div>
			<cf_seperator id="doc_result" title="#getLang('','Başarım  Sonucu','64128')#">
			<div id="doc_result">
				<cfif not len(get_order_no.quantity)><cfset get_order_no_ = 0><cfelse><cfset get_order_no_ = get_order_no.quantity></cfif>
					<cfset control_amount_n=get_order_no_-get_diff_amount.control_amount>
					<input type="hidden" name="control_amount_" id="control_amount_" value="<cfif len(get_order_no.quantity) and len(get_diff_amount.control_amount)><cfoutput>#control_amount_n#</cfoutput></cfif>">
					<input type="hidden" name="quality_type_list" id="quality_type_list" value="<cfoutput>#ValueList(GET_QUALITY_TYPE.TYPE_ID,',')#</cfoutput>">
					<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
					<cfoutput>
						<input type="hidden" name="control_amount_old" id="control_amount_old" value="<cfif len(get_order_no.quantity) and len(get_quality_list.control_amount)>#get_order_no.quantity-get_quality_list.control_amount#<cfelse>#get_order_no.quantity#</cfif>">
						<input type="hidden" name="process_cat" id="process_cat" value="#attributes.process_cat#">
						<input type="hidden" name="process_id" id="process_id" value="#attributes.process_id#">
						<input type="hidden" name="process_row_id" id="process_row_id" value="#attributes.process_row_id#">
						<input type="hidden" name="ship_wrk_row_id" id="ship_wrk_row_id" value="#attributes.ship_wrk_row_id#">
						<input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
						<input type="hidden" name="result_no" id="result_no" value="#get_order_no.result_no#"><!--- Belge No --->
						<input type="hidden" name="qualtity_" id="qualtity_" value="#get_order_no.quantity#"><!--- parti no --->
						<input type="hidden" name="pid" id="pid" value="<cfif isdefined("attributes.pid")>#attributes.pid#</cfif>">
					</cfoutput>
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
							<cf_grid_list sort="0">
								<thead>
									<tr>
										<th width="150"><cf_get_lang dictionary_id='36468.Başarım'></th>
										<th width="90" class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
									</tr>
								</thead>
								<tbody>
									<cfoutput query="get_quality_success">
										<tr>
											<td>
												<cfinput type="hidden" name="q_success_id#currentrow#" id="q_success_id#currentrow#" value="#get_quality_success.SUCCESS_ID#">
												#SUCCESS#
											</td>
											<td class="text-right">
												<input type="text" name="success_amount#currentrow#" id="success_amount#currentrow#" value="" onblur="sum()" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox sum_">
											</td>
										</tr>
									</cfoutput>
									<tr>
										<td class="bold"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td class="text-right bold">
											<cfset kalan_ = get_order_no_- get_quality_list.control_amount>
											<cfinput type="text" name="control_amount_control" id="control_amount_control" value="#kalan_#" class="moneybox">
										</td>
										<cfinput type="hidden" name="row_count" id="row_count" value="#get_quality_success.recordcount#">
										
									</tr>
								</tbody>
							</cf_grid_list>							
						</div>
						<cfoutput>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
								<div class="form-group" id="item-q_control_no">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id='36479.Kontrol No'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12 ">
										<input type="text" name="q_control_no" id="q_control_no" value="#paper_code & '-' & paper_number#">
									</div>
								</div>
								<div class="form-group" id="item-date">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id='57094.Kontrol Tarihi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<cfinput type="text" name="control_date" id="control_date" maxlength="10" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="control_date"></span>
										</div>
									</div>									
								</div>									
								<div class="form-group" id="item-process_cat">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id="58859.Süreç"> *</label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12 ">
										<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
									</div>
								</div>
								<div class="form-group" id="item-controller_emp">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12 "><cf_get_lang dictionary_id='57032.Kontrol Eden'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12 ">
										<div class="input-group">
											<cfoutput>
												<input type="hidden" name="controller_emp_id" id="controller_emp_id" value="<cfif isDefined('get_quality_result.controller_emp_id')>#get_quality_result.controller_emp_id#<cfelse>#attributes.controller_emp_id#</cfif>">			
												<input type="text" name="controller_emp" id="controller_emp" value="<cfif isDefined('get_quality_result.controller_emp_id')>#get_emp_info(get_quality_result.controller_emp_id,0,0)#<cfelse>#attributes.controller_emp#</cfif>" onFocus="AutoComplete_Create('controller_emp_','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id','','3','130');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=add_quality.controller_emp_id&field_name=add_quality.controller_emp&select_list=1</cfoutput>');"></span>
											</cfoutput>
										</div>
									</div>
								</div>
							</div>
						</cfoutput>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-12">
							<cf_workcube_buttons type_format='1' id="kalite_button" is_upd="0" is_delete="0" is_cancel="0" add_function="unformat_fields()">
						</div>
					</cf_box_footer>
					<cfif isdefined("get_quality_list.control_amount") and get_quality_list.control_amount gte get_order_no.quantity>
						<script type="text/javascript">
							document.getElementById('wrk_submit_button').disabled = true;
							document.getElementById('wrk_submit_button').value = '<cf_get_lang dictionary_id='64385.Tüm Miktarlar Kontrol Edildi'>';
							document.getElementById("wrk_submit_button").className = 'ui-wrk-btn-extra';
						</script>
					</cfif>
			</div>
		</cfform>
	</cf_box>
	<cfif not attributes.fuseaction eq 'objects.widget_loader'>
		<cf_box title="#getLang('','Yapılan Kontroller','36668')#" box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_list_quality_controls&from_add_contol_page=1&process_id_=#attributes.process_id#&process_row_id_=#attributes.process_row_id#&ship_wrk_row_id_=#attributes.ship_wrk_row_id#&production_quantity=#get_order_no.quantity#&pid=#get_product_info.product_id#">
		</cf_box>
	</cfif>	
		
	
</div>
<script type="text/javascript">
	<cfoutput>
		<cfif isdefined('GET_QUALITY_TYPE_ROW') and GET_QUALITY_TYPE_ROW.recordcount>
			var quality_type_list = document.getElementById('quality_type_list').value;
		<cfelse>
			var quality_type_list = 0;
		</cfif>
	</cfoutput>
		function sum() {
			var sum = 0;
			$(".sum_").each(function() {   
				sum += +filterNum(this.value);
			});
			$('#control_amount_control').val(sum);
			$('#control_amount_control').attr('value', sum);
			
		}
		function unformat_fields()
		{
			return sum();
			var control_amount_filterrr = filterNum(document.getElementById('control_amount_control').value);
			if(control_amount_filterrr > document.getElementById('qualtity_').value)
				{
					alert("<cf_get_lang dictionary_id='63487.Kontrol edilen miktar parti miktarından büyük olamaz'>!");
				
					return false;
				}
		
			if(!paper_control(add_quality.q_control_no,'<cfoutput>#paper_type_#</cfoutput>',true,'','','','','','#dsn3#')) return false;
			//if (!chk_period(add_quality.record_date,"İşlem")) return false; //tabloda kalite tarihi olmadığı,kalite şirkette tutulduğu ve ayrıca period_id bilgisinide tuttuğumuz için tarih kontrolünü kaldırıyorum hgul20140122.
			if (!process_cat_control()) return false;
			if(document.getElementById('q_control_no').value == '')
			{
				alert("<cf_get_lang dictionary_id='36674.Kalite Belge Numaralarını Tanımlayınız'>!");
				return false;
			}
				
			if(document.getElementById("control_amount").value == '')
			{
				alert("<cf_get_lang dictionary_id='36675.Kontrol Miktarı Giriniz'>!");
				return false;
			}
			
				if(document.getElementById("success_id") != undefined && document.getElementById("success_id").value == "")
				{
					alert("<cf_get_lang dictionary_id='36679.Kontrol Tipi Girmelisiniz'>!");
					return false;
				}
				if(parseInt(filterNum(document.getElementById("control_amount").value)) > parseInt(document.getElementById("control_amount_old").value))
				{
					alert("<cf_get_lang dictionary_id='36676.Kontrol Miktarı Üretim Sonuc Miktarından Büyük Olamaz'>!");
					return false;
				}	
				if(parseInt(document.getElementById("control_amount").value) > document.getElementById("control_amount_old").value)
				{
					alert("<cf_get_lang dictionary_id='36681.Kontrol Miktarı'> <cf_get_lang dictionary_id='60593.Büyük Olamaz'> " + document.getElementById("control_amount_old").value);
					return false;
				}
			<cfoutput>
				if(quality_type_list)
				{
					for(x=1;x<=list_len(quality_type_list,',');x++)
					{
						if(!form_warning('result_'+list_getat(quality_type_list,x,','),"<cf_get_lang dictionary_id='36683.Sonuç Giriniz'>")) 
							return false;
						
						//document.getElementById("result_"+list_getat(quality_type_list,x,',')).value = filterNum(document.getElementById("result_"+list_getat(quality_type_list,x,',')).value,4);
					}
					//document.getElementById("control_amount").value = filterNum(document.getElementById("control_amount").value,4);
					/*amount imput u sayfadan bulunamadı. gittigi sayfada da kullanılmıyor. AjaxFormSubmit('add_quality','show_user_info',1,'Kaydediliyor','Kaydedildi..','#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_list_quality_controls&from_add_contol_page=1&process_id_=#attributes.process_id#&process_row_id_=#attributes.process_row_id#&ship_wrk_row_id_=#attributes.ship_wrk_row_id#&production_quantity='+document.getElementById("amount").value+'','show_list_quality');*/
					AjaxFormSubmit('add_quality','show_list_quality',1,'Kaydediliyor','Kaydedildi..','#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_list_quality_controls&from_add_contol_page=1&process_id_=#attributes.process_id#&process_row_id_=#attributes.process_row_id#&ship_wrk_row_id_=#attributes.ship_wrk_row_id#&production_quantity=#get_order_no.quantity#','show_list_quality');
					document.getElementById("control_amount_old").value = parseFloat(document.getElementById("control_amount_old").value) - parseFloat(filterNum(document.getElementById("control_amount").value,4));
					document.getElementById("control_amount").value = "";
					document.getElementById("success_id").value = "";
					if(quality_type_list)
					{
						for(x=1;x<=list_len(quality_type_list,',');x++)
						{
							document.getElementById("result_"+list_getat(quality_type_list,x,',')).value = "";
							<cfif xml_show_detail eq 1>
								document.getElementById("detail_"+list_getat(quality_type_list,x,',')).value = "";
							</cfif>
						}
				}			
					return false;
				}
				else
				{
					alert("<cf_get_lang dictionary_id='36686.Ürün İçin Tanımlı Kalite Kontrol Tipi Yok'>!");
					return false;
				} 
				
			<cfif pro_detail.IS_SERIAL_NO eq 1>
				if(document.getElementById('is_all_amount').checked ==false && document.getElementById('serial_number_').value === "")
					{
						alert("<cf_get_lang dictionary_id='33774.Seri No Girmelisiniz'>!");
						return false;
					}
			</cfif>
			
		}
	</cfoutput>
		
/* $('#is_all_amount').click(function(){
	if($('#is_all_amount').not(':checked')) {
		<cfif pro_detail.IS_SERIAL_NO eq 1>$('#is_serial_no').css('display','block');</cfif>
		$('#control_amount_control').val("");
		$('#control_amount_control').attr('readonly', false);
    }
	if($('#is_all_amount').is(':checked')) {
		$('#is_serial_no').css('display','none');
		$('#control_amount_control').val($('#left_').val());
		$('#control_amount_control').attr('readonly', true);
	}
}); */

</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes">
