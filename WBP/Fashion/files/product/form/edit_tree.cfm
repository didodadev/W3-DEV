<cfparam name="attributes.beden_id" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfparam name="attributes.action" default="">

<cf_xml_page_edit>

<cfif attributes.action eq "stocklist">
	<cfset GetPageContext().getCFOutput().clear()>
	<cfquery name="query_stock" datasource="#dsn1#">
		SELECT * FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.productid#'> AND STOCK_STATUS = 1
	</cfquery>
	<cfoutput query="query_stock">
		<option value="#STOCK_ID#">#PROPERTY#</option>
	</cfoutput>
	<cfabort>
</cfif>

<cfquery name="get_main_stock" datasource="#dsn3#">
	select TOP 1 * from STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.pid#'> ORDER BY STOCK_ID	
</cfquery>
<cfquery name="get_stock_property" datasource="#dsn3#">
	SELECT
		RENK.PROPERTY_DETAIL AS RENK_,
		RENK.PROPERTY_DETAIL_ID AS RENK_ID,
		BEDEN.PROPERTY_DETAIL AS BEDEN_,
		BEDEN.PROPERTY_DETAIL_ID AS BEDEN_ID,
		BEDEN.PROPERTY_DETAIL_CODE,
		BOY.PROPERTY_DETAIL AS BOY_,
		BOY.PROPERTY_DETAIL_ID AS BOY_ID,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_NAME
	FROM 
		STOCKS
		OUTER APPLY
		(
			SELECT 
				PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
				PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
				PPD.PRPT_ID,
				PPD.PROPERTY_DETAIL_CODE
			FROM
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn1#.PRODUCT_PROPERTY PRP,
				STOCKS_PROPERTY SP
			WHERE
				PRP.PROPERTY_ID = PPD.PRPT_ID AND
				SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
				PRP.PROPERTY_COLOR = 1 AND 
				SP.STOCK_ID = STOCKS.STOCK_ID 
		) AS RENK
		OUTER APPLY
		(
			SELECT 
				PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
				PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
				PPD.PRPT_ID,
				PPD.PROPERTY_DETAIL_CODE
			FROM
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn1#.PRODUCT_PROPERTY PRP,
				STOCKS_PROPERTY SP
			WHERE
				PRP.PROPERTY_ID = PPD.PRPT_ID AND
				SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
				PRP.PROPERTY_SIZE = 1 AND 
				SP.STOCK_ID = STOCKS.STOCK_ID 
		) AS BEDEN
		OUTER APPLY
		(
			SELECT 
				PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
				PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
				PPD.PRPT_ID,
				PPD.PROPERTY_DETAIL_CODE
			FROM
				#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
				#dsn1#.PRODUCT_PROPERTY PRP,
				STOCKS_PROPERTY SP
			WHERE
				PRP.PROPERTY_ID = PPD.PRPT_ID AND
				SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
				PRP.PROPERTY_LEN = 1 AND 
				SP.STOCK_ID = STOCKS.STOCK_ID 
		) AS BOY
	WHERE 
		STOCKS.STOCK_STATUS = 1 AND
		STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.pid#'> AND
		RENK.PROPERTY_DETAIL_ID IS NOT NULL AND
		BEDEN.PROPERTY_DETAIL IS NOT NULL
	ORDER BY BEDEN.PROPERTY_DETAIL_CODE 
</cfquery>

<cfquery name="stokOzellikRenk" dbtype="query">
		select DISTINCT RENK_,RENK_ID from get_stock_property
</cfquery>

<cfquery name="stokOzellikBeden" dbtype="query">
		select DISTINCT BEDEN_,BEDEN_ID from get_stock_property
</cfquery>

<cfquery name="stokOzellikBoy" dbtype="query">
		select DISTINCT BOY_,BOY_ID from get_stock_property
</cfquery>

<cfset pageHead = 'Ürün Ağacı Kopyala - Ürün Adı:#get_main_stock.product_name#'>
<cf_catalystHeader>
			
<!---<cfif IsDefined("attributes.submit_form_search")>--->
<cfquery name="get_stock_size" dbtype="query">
	select  RENK_,BEDEN_,BOY_,STOCK_ID,PRODUCT_NAME from get_stock_property 
	where 1=1
	<cfif isdefined("attributes.stock_color") and len(attributes.stock_color)>
		and  RENK_ID = #attributes.stock_color#
	</cfif>
	<cfif isdefined("attributes.stock_size") and len(attributes.stock_size)>
		and  BEDEN_ID = #attributes.stock_size#
	</cfif>
	<cfif isdefined("attributes.stock_len") and len(attributes.stock_len)>
		and  BOY_ID = #attributes.stock_len#
	</cfif>
</cfquery>
					
<cfset stocklist = ValueList(get_stock_size.stock_id)>
<cfset stocklist=ListAppend(stocklist,get_main_stock.stock_id)>

<cfquery name="get_tree" datasource="#dsn3#">
	SELECT *
	FROM (
		SELECT
			0 AS SPECT_MAIN_ID,
			0 AS STOCK_ID,
			OP.OPERATION_TYPE AS STOCK_CODE,
			'-' AS PRODUCT_NAME,
			'-' AS PROPERTY,
			'-' AS MAIN_UNIT,
			1 AS IS_PRODUCTION,
			0 AS IS_CONFIGURE,
			ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
			0 AS PRODUCT_ID,
			ISNULL(PT.AMOUNT,0) AS AMOUNT,
			PT.PRODUCT_TREE_ID,
			ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
			ISNULL(PT.IS_TREE,0) AS IS_TREE,
			ISNULL(PT.PROCESS_STAGE,0) AS PROCESS_STAGE,
			0 AS IS_PHANTOM,
			ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
			OP.OPERATION_TYPE_ID,
			0 FIRE_RATE,
			0 FIRE_AMOUNT,
			0 REJECT_RATE,
			PT.DETAIL,
			PT.STOCK_ID TREE_STOCK_ID,
			PT.UNIT_ID
		FROM 
			OPERATION_TYPES OP,
			PRODUCT_TREE PT
		WHERE 
			OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
			PT.STOCK_ID IN(#stocklist#) 
		
		UNION ALL
		
		SELECT 
			ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
			STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_NAME+ ' '+STOCKS.PROPERTY AS PRODUCT_NAME,
			STOCKS.PROPERTY,
			PRODUCT_UNIT.MAIN_UNIT,
			STOCKS.IS_PRODUCTION,
			ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
			ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
			STOCKS.PRODUCT_ID,
			ISNULL(PT.AMOUNT,0) AS AMOUNT,
			PT.PRODUCT_TREE_ID,
			ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
				ISNULL(PT.IS_TREE,0) AS IS_TREE,
			ISNULL(PT.PROCESS_STAGE,0) AS PROCESS_STAGE,
			ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
			ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
			0 AS OPERATION_TYPE_ID,
			ISNULL(FIRE_RATE,0) FIRE_RATE,
			ISNULL(FIRE_AMOUNT,0) FIRE_AMOUNT,
			ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
			PT.DETAIL,
			PT.STOCK_ID TREE_STOCK_ID,
			PT.UNIT_ID
		FROM
			STOCKS,
			PRODUCT_TREE PT,
			PRODUCT_UNIT
		WHERE
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PT.UNIT_ID AND
			PT.RELATED_ID = STOCKS.STOCK_ID AND
			
			STOCKS.STOCK_ID IN (
				SELECT STOCK_ID FROM TEXTILE_SR_SUPLIERS 
				WHERE
				TEXTILE_SR_SUPLIERS.REQ_ID=#attributes.req_id# AND
				ISNULL(TEXTILE_SR_SUPLIERS.IS_STATUS,1)=1
					<cfif isDefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
						AND TEXTILE_SR_SUPLIERS.OPERATION_ID=#attributes.operation_type_id#
					</cfif>
			)
			AND 
			PT.STOCK_ID IN(#stocklist#) 
			
		UNION
		
		SELECT 
			ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
			STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_NAME+ ' '+STOCKS.PROPERTY AS PRODUCT_NAME,
			STOCKS.PROPERTY,
			PRODUCT_UNIT.MAIN_UNIT,
			STOCKS.IS_PRODUCTION,
			ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
			ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
			STOCKS.PRODUCT_ID,
			ISNULL(PT.AMOUNT,0) AS AMOUNT,
			PT.PRODUCT_TREE_ID,
			ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
				ISNULL(PT.IS_TREE,0) AS IS_TREE,
			ISNULL(PT.PROCESS_STAGE,0) AS PROCESS_STAGE,
			ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
			ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
			0 AS OPERATION_TYPE_ID,
			ISNULL(FIRE_RATE,0) FIRE_RATE,
			ISNULL(FIRE_AMOUNT,0) FIRE_AMOUNT,
			ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
			PT.DETAIL,
			PT.STOCK_ID TREE_STOCK_ID,
			PT.UNIT_ID
		FROM
			STOCKS,
			PRODUCT_TREE PT,
			PRODUCT_UNIT
		WHERE
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PT.UNIT_ID AND
			PT.RELATED_ID = STOCKS.STOCK_ID AND
			STOCKS.STOCK_ID IN(
				SELECT STOCK_ID FROM TEXTILE_SR_PROCESS 
				where
				TEXTILE_SR_PROCESS.REQUEST_ID=#attributes.req_id# AND
				ISNULL(TEXTILE_SR_PROCESS.IS_STATUS,1)=1 AND
				ISNULL(STOCK_ID,0)>0
		)
		AND PT.STOCK_ID IN(#stocklist#)
	)
	AS T
	ORDER BY  T.LINE_NUMBER ASC
</cfquery>
					
<!---
	<cfdump var="#get_tree#" ABORT>
--->
					
<cfset tree_stocklist=ValueList(get_tree.TREE_STOCK_ID)>
<cfset query_name="get_stock_size">
			
<cfif IsDefined("attributes.agac_yok")>
	<cfquery name="get_stock_size2" dbtype="query">
		select * from get_stock_size WHERE STOCK_ID NOT IN(#tree_stocklist#) <!---urun agaci olmayan stokları getirir--->
	</cfquery>
	<cfset query_name="get_stock_size2">
</cfif>

<cfquery name="get_max_linenumber" dbtype="query">
	select MAX(LINE_NUMBER) AS MAX_LINE_NUMBER from get_tree <!---stok agacına yeni eklenecek hm ler için devam line_number degeri tesbit ediliyor--->
</cfquery>

<cfquery name="get_tree_count" dbtype="query">
		select COUNT(*) SAY from get_tree  group by TREE_STOCK_ID ORDER BY SAY desc <!---mamul stoklara ait hammadde sayisini getirir--->
</cfquery>

<!---<cfdump var="#get_tree_count#">--->
					
<cfquery name="get_main_tree" datasource="#dsn3#">
	<!---select *from get_tree where TREE_STOCK_ID=#get_main_stock.stock_id# ORDER BY  LINE_NUMBER ASC---> <!---kopyalacanak ana mamule ait agaci getirir--->
	select 
		0 AS SPECT_MAIN_ID,
		S.STOCK_ID,
		S.STOCK_CODE,
		S.PRODUCT_NAME+ ' '+S.PROPERTY AS PRODUCT_NAME,
		S.PROPERTY,
		PRODUCT_UNIT.MAIN_UNIT,
		S.IS_PRODUCTION,
		0 AS IS_CONFIGURE,
		0 AS QUESTION_ID,
		STOCKS.PRODUCT_ID,
		ISNULL(TEXTILE_SR_SUPLIERS.QUANTITY,1) AS AMOUNT,
		'' PRODUCT_TREE_ID,
		0 AS IS_SEVK,
		0 AS IS_TREE,
		0 AS PROCESS_STAGE,
		0 AS IS_PHANTOM,
		0 AS LINE_NUMBER,
		0 AS OPERATION_TYPE_ID,
		0 FIRE_RATE,
		0 FIRE_AMOUNT,
		ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
		'numuneden olusturulan' DETAIL,
		STOCKS.STOCK_ID TREE_STOCK_ID,
		TEXTILE_SR_SUPLIERS.UNIT_ID
	from 
		STOCKS,
		STOCKS S,
		TEXTILE_SR_SUPLIERS,
		PRODUCT_UNIT
	WHERE 
		REQ_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.req_id#'>  AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = TEXTILE_SR_SUPLIERS.UNIT_ID AND
		STOCKS.STOCK_ID = #get_main_stock.stock_id# AND
		TEXTILE_SR_SUPLIERS.STOCK_ID = S.STOCK_ID
		<cfif isDefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
			AND TEXTILE_SR_SUPLIERS.OPERATION_ID = #attributes.operation_type_id#
		</cfif>
		AND ISNULL(TEXTILE_SR_SUPLIERS.IS_STATUS,1) = 1
		AND STOCKS.PRODUCT_ID <> 1341
	
	UNION ALL
	
	SELECT 
		0 AS SPECT_MAIN_ID,
		S.STOCK_ID,
		S.STOCK_CODE,
		S.PRODUCT_NAME+ ' '+S.PROPERTY AS PRODUCT_NAME,
		S.PROPERTY,
		PRODUCT_UNIT.MAIN_UNIT,
		S.IS_PRODUCTION,
		0 AS IS_CONFIGURE,
		0 AS QUESTION_ID,
		STOCKS.PRODUCT_ID,
		1 AS AMOUNT,
		'' PRODUCT_TREE_ID,
		0 AS IS_SEVK,
		0 AS IS_TREE,
		0 AS PROCESS_STAGE,
		0 AS IS_PHANTOM,
		0 AS LINE_NUMBER,
		0 AS OPERATION_TYPE_ID,
		0 FIRE_RATE,
		0 FIRE_AMOUNT,
		ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
		'numuneden olusturulan' DETAIL,
		STOCKS.STOCK_ID TREE_STOCK_ID,
		S.PRODUCT_UNIT_ID UNIT_ID
	FROM 
		STOCKS,
		STOCKS S,
		TEXTILE_SR_PROCESS,
		PRODUCT_UNIT
	WHERE 
		TEXTILE_SR_PROCESS.REQUEST_ID = #attributes.req_id# AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
		STOCKS.STOCK_ID = #get_main_stock.stock_id# AND
		TEXTILE_SR_PROCESS.STOCK_ID = S.STOCK_ID
		<cfif isDefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
			AND TEXTILE_SR_PROCESS.OPERATION_ID = #attributes.operation_type_id#
		</cfif>
		AND ISNULL(TEXTILE_SR_PROCESS.IS_STATUS,1) = 1
</cfquery>

<cfquery name="query_fermuar_catids" datasource="#dsn1#">
	SELECT PRODUCT_CATID FROM PRODUCT_CAT WHERE HIERARCHY LIKE '#fermuar_category_code#%'
</cfquery>
<cfset fermuar_catids = "">
<cfif query_fermuar_catids.recordCount>
	<cfset fermuar_catids = valueList(query_fermuar_catids.PRODUCT_CATID)> 
</cfif>

<cfquery name="query_textile_tree" datasource="#dsn3#">
	SELECT * FROM TEXTILE_PRODUCT_TREE
	WHERE PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.pid#'>
		AND REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.req_id#'>
</cfquery>
							
<cfform name="all_tree" action="#request.self#?fuseaction=textile.empty_tree_copy" method="post" >			
	<input type="hidden" name="row_count_stock" id="row_count_stock" value="<cfoutput>#Evaluate("#query_name#.recordcount")#</cfoutput>">
	<input type="hidden" name="row_start" id="row_start" value="1">
	<input type="hidden" name="max_line" id="max_line" value="<cfoutput>#get_max_linenumber.MAX_LINE_NUMBER#</cfoutput>">
	<input type="hidden" name="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
	<input type="hidden" name="stock_color" value="<cfif isdefined("attributes.stock_color") and len(attributes.stock_color)><cfoutput>#attributes.stock_color#</cfoutput></cfif>">
	<input type="hidden" name="stock_len" value="<cfif isdefined("attributes.stock_len") and len(attributes.stock_len)><cfoutput>#attributes.stock_len#</cfoutput></cfif>">
	<input type="hidden" name="stock_size" value="<cfif isdefined("attributes.stock_size") and len(attributes.stock_size)><cfoutput>#attributes.stock_size#</cfoutput></cfif>">
	<input type="hidden" name="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
		
		<div class="col col-6">
			<div class="form-group" id="item-process_stage">
				<label class="col col-4 col-xs-12">Süreç</label>
				<div class="col col-8 col-xs-12">
					<cf_workcube_process is_upd='0' is_detail='1' select_value="#query_textile_tree.PROCESS_STAGE#">
				</div>
			</div>
		</div>
		<div class="col col-6" > 
			<cfsavecontent variable="insert_info">Tümünü Kaydet</cfsavecontent>
			<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#insert_info#'>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12" > 
			<cf_basket>
				<table>
					<tbody>
						<tr>
						
							<cfif evaluate("#query_name#").recordcount>				
						
								<cfoutput query="#query_name#"><!---asorti stokları döngüde--->
								<td>	
								
									<cfquery name="get_tree_" dbtype="query">
										SELECT * FROM get_tree where TREE_STOCK_ID = #stock_id# ORDER BY LINE_NUMBER ASC <!---stok agaci alinıyor--->
									</cfquery>
					
									<cfset agac_varmi = 0>
									
									<cfif get_tree_.recordcount gt 0>
										<cfset agac_varmi = 1>
									</cfif>
										
									<!---<cfform name="form_tree_#stock_id#" id="form_tree_#stock_id#" action="#urll#" method="post">--->
											
											
									<input type="hidden" name="stock_id#currentrow#" value="#stock_id#">
									
									<table border="1" valign="top" class="basket_list" >
									<cf_ajax_list>
										<thead>
											<tr id="frm_row0" name="frm_row0">
												<th width="50" colspan="3">
													<a href="javascript://" onclick="add_row('#stock_id#');">
														<img src="images/plus_list.gif">
													</a>
												</th>
												<th width="150">
													<cfif agac_varmi eq 0>
														<div style="position:absolute;margin-left:50px;" id="userSuccesMessage_#stock_id#"></div>
														<font color="red">#RENK_# #BOY_# #BEDEN_#</font>
													<cfelse>
														<div style="position:absolute;margin-left:50px;" id="userSuccesMessage_#stock_id#"></div>
														#RENK_# #BOY_# #BEDEN_#
													</cfif>
												</th>
												<th width="20">
												<cfif agac_varmi eq 1>
													<!---
													<a href="javascript://"  onclick="kaydet('#stock_id#','#currentrow#');">
														<img src="images/update_list.gif" align="right" title="Ağaç güncelle" style="align:right;">
													</a>
													--->
													<input type="hidden" name="update#currentrow#" value="#agac_varmi#">
												<cfelse>
													<a href="javascript://"  onclick="kaydet('#stock_id#','#currentrow#');">
														<img src="images/save.gif" align="right" title="Ağaç Kaydet" style="align:right;">
													</a>
														<input type="hidden" name="update#currentrow#" value="#agac_varmi#">
												</cfif>
												</th>
												<th width="30">
													<cfif agac_varmi eq 0>
														<font color="red">Miktar</font>
													<cfelse>
														Miktar
													</cfif>
												</th>
											</tr>
										</thead>
										
										<cfset agac_satirsayisi = 0>

										<cfquery name="qdigerleri" datasource="#dsn3#">
											SELECT 
												ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
												STOCKS.STOCK_ID,
												STOCKS.STOCK_CODE,
												STOCKS.PRODUCT_NAME+ ' '+STOCKS.PROPERTY AS PRODUCT_NAME,
												STOCKS.PROPERTY,
												PRODUCT_UNIT.MAIN_UNIT,
												STOCKS.IS_PRODUCTION,
												ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
												ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
												STOCKS.PRODUCT_ID,
												ISNULL(PT.AMOUNT,0) AS AMOUNT,
												PT.PRODUCT_TREE_ID,
												ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
													ISNULL(PT.IS_TREE,0) AS IS_TREE,
												ISNULL(PT.PROCESS_STAGE,0) AS PROCESS_STAGE,
												ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
												ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
												0 AS OPERATION_TYPE_ID,
												ISNULL(FIRE_RATE,0) FIRE_RATE,
												ISNULL(FIRE_AMOUNT,0) FIRE_AMOUNT,
												ISNULL((SELECT TOP 1 REJECT_RATE FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = STOCKS.PRODUCT_ID),0) REJECT_RATE,
												PT.DETAIL,
												PT.STOCK_ID TREE_STOCK_ID,
												PT.UNIT_ID
											FROM
												STOCKS,
												PRODUCT_TREE PT,
												PRODUCT_UNIT
											WHERE
												PRODUCT_UNIT.PRODUCT_UNIT_ID = PT.UNIT_ID AND
												PT.RELATED_ID = STOCKS.STOCK_ID AND
												PT.STOCK_ID IN(#stock_id#)
												AND STOCKS.STOCK_ID NOT IN (SELECT STOCK_ID FROM TEXTILE_SR_SUPLIERS WHERE REQ_ID=#attributes.req_id#)
												AND STOCKS.STOCK_ID NOT IN (SELECT STOCK_ID FROM TEXTILE_SR_PROCESS WHERE REQUEST_ID=#attributes.req_id#)
												<cfif isDefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
												AND STOCKS.STOCK_ID NOT IN (SELECT STOCK_ID FROM TEXTILE_SR_SUPLIERS WHERE OPERATION_ID=#attributes.operation_type_id#)
												AND STOCKS.STOCK_ID NOT IN (SELECT STOCK_ID FROM TEXTILE_SR_PROCESS WHERE OPERATION_ID=#attributes.operation_type_id#)	
												</cfif>

										</cfquery>
										
										<tbody id="table_#stock_id#" name="table_#stock_id#">
											<cfif get_tree_count.recordcount>
												<cfset agac_satirsayisi=get_tree_count.say>
												
											<cfelseif not get_tree_count.recordcount && get_main_tree.recordCount>
												<cfset agac_satirsayisi=get_main_tree.recordCount>	 
											</cfif>

											<cfif get_tree_.recordCount>
												<cfquery name="query_descrease_tree_count" dbtype="query">
													SELECT * FROM qdigerleri WHERE PRODUCT_TREE_ID IN (#listLen(valueList(get_tree_.product_tree_id)) ? valueList(get_tree_.product_tree_id) : '0'#)
												</cfquery>

												<cfset agac_satirsayisi = agac_satirsayisi - query_descrease_tree_count.recordCount>
											</cfif>
											
											<cfif agac_satirsayisi gt 0>
												<cfloop  from="1" to="#agac_satirsayisi#" index="i">
																	
													<cfif agac_varmi eq 1>
														<cfscript>
															if (get_tree_.product_name[i] neq '-')
																product_name_ = get_tree_.product_name[i];
															else
																product_name_ = get_tree_.stock_code[i];

															old_product_name_ 		= get_tree_.product_name[i];
															process_stage_ 			= get_tree_.process_stage[i];
															is_phantom_ 			= get_tree_.is_phantom[i];
															operation_type_id_		= get_tree_.operation_type_id[i];
															old_operation_type_id_	= get_tree_.operation_type_id[i];
															line_number_			= get_tree_.line_number[i];
															spect_main_id_			= get_tree_.spect_main_id[i];
															is_configure_			= get_tree_.is_configure[i];
															is_sevk_				= get_tree_.is_sevk[i];
															unit_id_				= get_tree_.unit_id[i];
															unit_					= get_tree_.unit_id[i];
															is_tree_				= get_tree_.is_tree[i];
															related_id_				= get_tree_.stock_id[i];
															amount_					= get_tree_.amount[i];
															old_related_id_			= get_tree_.stock_id[i];
															stock_code_				= get_tree_.stock_id[i];
															product_id_				= get_tree_.product_id[i];
															old_product_id_			= get_tree_.product_id[i];
															product_tree_id_		= get_tree_.product_tree_id[i];
															temp_product_tree_id	= product_tree_id_;
														</cfscript>
													<cfelse>
														<cfscript>
															if (get_main_tree.product_name[i] neq '-')
																product_name_ = get_main_tree.product_name[i];
															else
																product_name_ = get_main_tree.stock_code[i];
																				
																			
															amount_					= get_main_tree.amount[i];
															old_product_name_		= get_main_tree.product_name[i];
															process_stage_			= get_main_tree.process_stage[i];
															is_phantom_				= get_main_tree.is_phantom[i];
															operation_type_id_		= get_main_tree.operation_type_id[i];
															old_operation_type_id_	= get_main_tree.operation_type_id[i];
															line_number_			= get_main_tree.line_number[i];
															spect_main_id_			= get_main_tree.spect_main_id[i];
															is_configure_			= get_main_tree.is_configure[i];
															is_sevk_				= get_main_tree.is_sevk[i];
															unit_id_				= get_main_tree.unit_id[i];
															unit_					= get_main_tree.unit_id[i];
															is_tree_				= get_main_tree.is_tree[i];
															related_id_				= get_main_tree.stock_id[i];
															old_related_id_			= get_main_tree.stock_id[i];
															stock_code_				= get_main_tree.stock_id[i];
															product_id_				= get_main_tree.product_id[i];
															old_product_id_			= get_main_tree.product_id[i];
															product_tree_id_		= "";
															temp_product_tree_id	= 0;
														</cfscript>
													</cfif>

													<cfquery name="query_descrease_tree_count" dbtype="query">
														SELECT 1 FROM qdigerleri WHERE PRODUCT_TREE_ID = #len(temp_product_tree_id) ? temp_product_tree_id : 0#
													</cfquery>

													<cfif query_descrease_tree_count.recordCount gt 0><cfcontinue></cfif>

													<cfset row_status_ = 1>
													<cfif len(product_id_) and len(fermuar_catids)>
														<cfquery name="query_row_status" datasource="#dsn3#">
															SELECT 1 FROM STOCKS
															WHERE PRODUCT_CATID IN (#fermuar_catids#)
																AND STOCK_ID = #stock_code_#
														</cfquery>
														<cfif query_row_status.recordCount>
															<cfset row_status_ = 0>
														</cfif>
													</cfif>
													
													<cfif not len(line_number_)>
														<cfset sayac = get_tree_count.say-i>
														<cfset line_number_ = get_max_linenumber.MAX_LINE_NUMBER-sayac>
													</cfif>
													
													<tr id="frm_row#i#" name="frm_row#i#">
														<td >#i#</td>
														<td><!---<a href="javascript://" onClick="del_stock(#stock_id#,'#currentrow#','#i#');"><img src="images/delete_list.gif"></a>---></td>
														<td><!---<input type="checkbox" name="stock_fix_#currentrow#_#i#" value="1" title="Diğer ağaçlara uygula" onclick="stock_fix(this,'#currentrow#','#i#');">---></td>
														<td>
															<cfif operation_type_id_ eq 0>
																<input type="text" readonly class="boxtext" style="width:150px;" name="product_name_#currentrow#_#i#" value="#product_name_#">
																<input type="hidden" class="boxtext" style="width:150px;" name="old_product_name_#currentrow#_#i#" value="#product_name_#">
															<cfelse>
																#product_name_#
																<input type="text" readonly class="boxtext" style="width:150px;color:purple;" name="product_name_#currentrow#_#i#" value="#product_name_#">
																<input type="hidden" class="boxtext" style="width:150px;" name="old_product_name_#currentrow#_#i#" value="#product_name_#">
															</cfif>
														</td>
														<td>	
															<!---
															<cfif operation_type_id_ eq 0>
																	<a href="javascript://" onClick="open_product('#stock_id#','#i#','#currentrow#','#product_id_#')"><img src="/images/plus_thin.gif"  align="right" border="0" title="Stok Çeşitleri"></a>
																<cfelseif operation_type_id_ eq 1>
																	<a href="javascript://" onClick="open_op(#stock_id#,'#i#',#currentrow#);"><img src="images/plus_thin_p.gif"></a>
																<cfelseif not len(operation_type_id_)>
																	<a href="javascript://" onClick="open_product('#stock_id#','#i#','#currentrow#','#product_id_#')"><img src="/images/plus_thin.gif"  align="right" border="0" title="Stok Çeşitleri"></a>
																		<a href="javascript://" onClick="open_op(#stock_id#,'#i#',#currentrow#);"><img src="images/plus_thin_p.gif"></a>
																		<input type="hidden" name="new_row_#currentrow#_#i#" id="new_row_#currentrow#_#i#" value="">
																</cfif>
															--->
														</td>
														<td style="text-align:right;">
															<input type="text" style="width:10mm;text-align:right;" name="amount_#currentrow#_#i#" onkeyup="FormatCurrency(this,event);" class="boxtext" value="#tlformat(amount_)#" readonly>
														</td>
														<input type="hidden" name="row_status_#currentrow#_#i#" id="row_status_#currentrow#_#i#" value="#row_status_#">
														<input type="hidden" name="process_stage_#currentrow#_#i#" value="#process_stage_#">
														<input type="hidden" name="is_phantom_#currentrow#_#i#" value="#is_phantom_#">
														<input type="hidden" name="operation_type_id_#currentrow#_#i#" value="#operation_type_id_#">
														<input type="hidden" name="old_operation_type_id_#currentrow#_#i#" value="#old_operation_type_id_#">
														<input type="hidden" name="line_number_#currentrow#_#i#" value="#line_number_#">
														<input type="hidden" name="spect_main_id_#currentrow#_#i#" value="#spect_main_id_#">
														<input type="hidden" name="is_configure_#currentrow#_#i#" value="#is_configure_#">
														<input type="hidden" name="is_sevk_#currentrow#_#i#" value="#is_sevk_#">
														<input type="hidden" name="unit_id_#currentrow#_#i#" id="unit_id_#currentrow#_#i#" value="#unit_id_#">
														<input type="hidden" name="unit_#currentrow#_#i#" id="unit_#currentrow#_#i#" value="#unit_#">
														<input type="hidden" name="is_tree_#currentrow#_#i#" value="#get_tree_.is_tree[i]#">
														<input type="hidden" name="related_id_#currentrow#_#i#" id="related_id_#currentrow#_#i#" value="#related_id_#">
														<input type="hidden" name="old_related_id_#currentrow#_#i#" id="old_related_id_#currentrow#_#i#" value="#old_related_id_#">
														<input type="hidden" name="stock_code_#currentrow#_#i#" id="stock_code_#currentrow#_#i#" value="#old_related_id_#">
														<input type="hidden" name="product_id_#currentrow#_#i#" id="product_id_#currentrow#_#i#" value="#product_id_#">
														<input type="hidden" name="old_product_id_#currentrow#_#i#" id="old_product_#currentrow#_id_#i#" value="#old_product_id_#">
														<input type="hidden" name="product_tree_id_#currentrow#_#i#" value="#product_tree_id_#">
																					
																					
													</tr>
												</cfloop>
											</cfif>
											
											
											
											<cfloop from="1" to="#qdigerleri.recordCount#" index="ij">
												<cfscript>
													if (qdigerleri.product_name[ij] neq '-')
															product_name_ = qdigerleri.product_name[ij];
													else
															product_name_ = qdigerleri.stock_code[ij];
									
														old_product_name_		= qdigerleri.product_name[ij];
														process_stage_			= qdigerleri.process_stage[ij];
														is_phantom_				= qdigerleri.is_phantom[ij];
														operation_type_id_		= qdigerleri.operation_type_id[ij];
														old_operation_type_id_	= qdigerleri.operation_type_id[ij];
														line_number_			= qdigerleri.line_number[ij];
														spect_main_id_			= qdigerleri.spect_main_id[ij];
														is_configure_			= qdigerleri.is_configure[ij];
														is_sevk_				= qdigerleri.is_sevk[ij];
														unit_id_				= qdigerleri.unit_id[ij];
														unit_					= qdigerleri.unit_id[ij];
														is_tree_				= qdigerleri.is_tree[ij];
														related_id_				= qdigerleri.stock_id[ij];
														amount_					= qdigerleri.amount[ij];
														old_related_id_			= qdigerleri.stock_id[ij];
														stock_code_				= qdigerleri.stock_id[ij];
														product_id_				= qdigerleri.product_id[ij];
														old_product_id_			= qdigerleri.product_id[ij];
														product_tree_id_		= qdigerleri.product_tree_id[ij];
												</cfscript>
															
												<tr name="frm_row#i+ij-1#" id="frm_row#i+ij-1#">
													<td>#i+ij-1#</td>
													<td></td>
													<td><input type="checkbox" name="stock_fix_#currentrow#_#i+ij-1#" value="1" title="Diğer ağaçlara uygula" onclick="stock_fix(this,#currentrow#,#i+ij-1#);"></td>
													<td>
														<input type="text" style="width:calc(100% - 20px);text-align:right;" class="boxtext" readonly="" name="product_name_#currentrow#_#i+ij-1#" value="#product_name_#"><a href="javascript://" onclick="open_product(#stock_id#,#i+ij-1#,#currentrow#,0);"><img src="images/plus_thin.gif"></a><input type="hidden" style="width:30mm;text-align:right;" class="boxtext" name="old_product_name_#currentrow#_#i+ij-1#" value="#product_name_#">
													</td>
													<td>
														<cfquery name="query_stock" datasource="#dsn1#">
															SELECT * FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#product_id_#'> AND STOCK_STATUS = 1
														</cfquery>
														<select name="related_id_#currentrow#_#i+ij-1#" id="related_id_#currentrow#_#i+ij-1#">
														<cfloop query="query_stock">
															<option value="#query_stock.STOCK_ID#"<cfif query_stock.STOCK_ID eq related_id_> selected</cfif>>#query_stock.PROPERTY#</option>
														</cfloop>
														</select>
													</td>
													<td>
														<input type="text" style="width:5mm;text-align:right;" class="boxtext" name="amount_#currentrow#_#i+ij-1#" value="1">
														<input type="hidden" name="process_stage_#currentrow#_#i+ij-1#" id="process_stage_#currentrow#_#i+ij-1#" value="">
														<input type="hidden" name="is_phantom_#currentrow#_#i+ij-1#" id="is_phantom_#currentrow#_#i+ij-1#" value="#is_phantom_#">
														<input type="hidden" name="operation_type_id_#currentrow#_#i+ij-1#" id="operation_type_id_#currentrow#_#i+ij-1#" value="#operation_type_id_#">
														<input type="hidden" name="old_operation_type_id_#currentrow#_#i+ij-1#" id="old_operation_type_id_#currentrow#_#i+ij-1#" value="#operation_type_id_#">
														<input type="hidden" name="line_number_#currentrow#_#i+ij-1#" id="line_number_#currentrow#_#i+ij-1#" value="#line_number_#">
														<input type="hidden" name="spect_main_id_#currentrow#_#i+ij-1#" value="#spect_main_id_#">
														<input type="hidden" name="is_configure_#currentrow#_#i+ij-1#" id="is_configure_#currentrow#_#i+ij-1#" value="#is_configure_#">
														<input type="hidden" name="is_sevk_#currentrow#_#i+ij-1#" id="is_sevk_#currentrow#_#i+ij-1#" value="#is_sevk_#">
														<input type="hidden" name="unit_id_#currentrow#_#i+ij-1#" id="unit_id_#currentrow#_#i+ij-1#" value="#unit_id_#">
														<input type="hidden" name="unit_#currentrow#_#i+ij-1#" id="unit_#currentrow#_#i+ij-1#" value="#unit_#">
														<input type="hidden" name="stock_code_#currentrow#_#i+ij-1#" id="stock_code_#currentrow#_#i+ij-1#" value="#old_related_id_#">
														<input type="hidden" name="is_tree_#currentrow#_#i+ij-1#" id="is_tree_#currentrow#_#i+ij-1#" value="#get_tree_.is_tree[ij]#">
														<input type="hidden" name="old_related_id_#currentrow#_#i+ij-1#" id="old_related_id_#currentrow#_#i+ij-1#" value="#old_related_id_#">
														<input type="hidden" name="product_id_#currentrow#_#i+ij-1#" id="product_id_#currentrow#_#i+ij-1#" value="#product_id_#">
														<input type="hidden" name="old_product_id_#currentrow#_#i+ij-1#" id="old_product_id_#currentrow#_#i+ij-1#" value="#old_product_id_#">
														<input type="hidden" name="row_status_#currentrow#_#i+ij-1#" id="row_status_#currentrow#_#i+ij-1#" value="1">
														<input type="hidden" name="product_tree_id_#currentrow#_#i+ij-1#" value="#product_tree_id_#">
													</td>
												</tr>
											</cfloop>
											
											<cfif get_tree_count.recordcount>
												<cfset agac_satirsayisi=get_tree_count.say + qdigerleri.recordCount>
												<input type="hidden" name="row_count_#currentrow#_#stock_id#" id="row_count_#currentrow#_#stock_id#" value="#agac_satirsayisi#">
											<cfelseif not get_tree_count.recordcount && get_main_tree.recordCount>
												<cfset agac_satirsayisi=get_main_tree.recordCount + qdigerleri.recordCount>	 
												<input type="hidden" name="row_count_#currentrow#_#stock_id#" id="row_count_#currentrow#_#stock_id#" value="#agac_satirsayisi#">
											</cfif>
										</tbody>
										
										<tfoot>
											<tr>
												<td colspan="6">
													<cfif agac_varmi eq 1>
														<button class="btn btn-warning" onclick="kaydet('#stock_id#','#currentrow#');">#RENK_# #BOY_# #BEDEN_# Ağaç Güncelle</button>
													<cfelse>
														<button class="btn btn-warning" onclick="kaydet('#stock_id#','#currentrow#');">#RENK_# #BOY_# #BEDEN_# Ağaç Kaydet</button>
													</cfif>	
												</td>
											</tr>
										</tfoot>
									</table>
									
									<cfquery name="q_measurement" datasource="#dsn3#">
										SELECT * FROM TEXTILE_MEASUREMENT_ITEMS 
										WHERE REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.req_id#'> 
											AND EBTYPE = '0'
											AND BOY_ID = '#BOY_#'
											AND STOCK_ID = '#BEDEN_#' 
										ORDER BY MEASURE_POINT
									</cfquery>

									<table border="1" class="basket_list" id="dtablelist" style="width: 100%; margin-top: 16px;">
										<thead>
											<tr>
												<th>ÖLÇÜM YERİ</th>
												<th style="text-align: center;">#BOY_# - #BEDEN_#</th>
											</tr>
										</thead>
										<tbody>
											<cfset last_olcumyeri = "">
											<tr>
												<cfloop query="q_measurement">
												<cfif last_olcumyeri neq q_measurement.MEASURE_POINT>
												</tr>
												<tr>
												<td style="text-align: left;">#q_measurement.MEASURE_POINT#</td>
												</cfif>
												<td>#q_measurement.TARGET#</td>
												<cfset last_olcumyeri = q_measurement.MEASURE_POINT>
												</cfloop>
											</tr>
										</tbody>
									</table>
								</td>
								</cfoutput>	
							<cfelse>
								
								<td><cfif isdefined("attributes.agac_yok")>Ağacı olmayan stok bulunamadı!<cfelse>Ürüne Asorti tanımlayınız!</cfif> </td>
							</cfif>	
						</tr>
					</tbody>
					<!---<tfoot>
						<tr>
							<td style="text-align:left;" align="left">
								<cfsavecontent variable="insert_info">Tümünü Kaydet</cfsavecontent>
								<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info = '#insert_info#'>	
							</td>
							<td colspan="<cfoutput>#evaluate('#query_name#').recordcount#</cfoutput>"></td>
						</tr>
					</tfoot>--->
				</table>
							
			</cf_basket>
		</div>
</cfform>

<!---</cfif>--->

<script>
	function kaydet(stock_id,kolonno)
	{
		
		document.all_tree.row_start.value=kolonno;
		document.all_tree.row_count_stock.value=kolonno;
		document.all_tree.submit();
				//AjaxFormSubmit('form_tree_'+stock_id,'userSuccesMessage_'+stock_id,1,'Kayıt Başarılı!','','','',1);
	}
	
	function stock_fix(chkobje,kolonno,satir)
	{
							
						
	<cfif IsDefined("get_stock_size")>
		rcount='<cfoutput>#get_stock_size.recordcount#</cfoutput>';
		if(chkobje.checked)
		{
			for(var i=1;i<=rcount;i++)
			{
											
				eval('document.all_tree.related_id_'+i+'_'+satir).value=eval('document.all_tree.related_id_'+kolonno+'_'+satir).value;
				eval('document.all_tree.product_id_'+i+'_'+satir).value=eval('document.all_tree.product_id_'+kolonno+'_'+satir).value;
				eval('document.all_tree.product_name_'+i+'_'+satir).value=eval('document.all_tree.product_name_'+kolonno+'_'+satir).value;
				eval('document.all_tree.operation_type_id_'+i+'_'+satir).value=eval('document.all_tree.operation_type_id_'+kolonno+'_'+satir).value;
		
				eval('document.all_tree.row_status_'+i+'_'+satir).value=eval('document.all_tree.row_status_'+kolonno+'_'+satir).value;
				eval('document.all_tree.unit_id_'+i+'_'+satir).value=eval('document.all_tree.unit_id_'+kolonno+'_'+satir).value;
				eval('document.all_tree.is_sevk_'+i+'_'+satir).value=eval('document.all_tree.is_sevk_'+kolonno+'_'+satir).value;
		
				eval('document.all_tree.process_stage_'+i+'_'+satir).value=eval('document.all_tree.process_stage_'+kolonno+'_'+satir).value;
				eval('document.all_tree.is_phantom_'+i+'_'+satir).value=eval('document.all_tree.is_phantom_'+kolonno+'_'+satir).value;
				eval('document.all_tree.is_configure_'+i+'_'+satir).value=eval('document.all_tree.is_configure_'+kolonno+'_'+satir).value;
				
				eval('document.all_tree.spect_main_id_'+i+'_'+satir).value=eval('document.all_tree.spect_main_id_'+kolonno+'_'+satir).value;
				eval('document.all_tree.unit_'+i+'_'+satir).value=eval('document.all_tree.unit_'+kolonno+'_'+satir).value;
				eval('document.all_tree.is_tree_'+i+'_'+satir).value=eval('document.all_tree.is_tree_'+kolonno+'_'+satir).value;		
				
				eval('document.all_tree.stock_code_'+i+'_'+satir).value=eval('document.all_tree.stock_code_'+kolonno+'_'+satir).value;	
											
				if(eval('document.all_tree.amount_'+i+'_'+satir).value=="")
					eval('document.all_tree.amount_'+i+'_'+satir).value=1;
						
			}
			
			var firstProductId = eval('document.all_tree.product_id_'+kolonno+'_'+satir).value;
			$.get(<cfoutput>"#request.self#?fuseaction=#attributes.fuseaction#&event=#attributes.event#&isajax=1&ajax=1&action=stocklist&productid="</cfoutput>+firstProductId, function(data) {
				for(var i=1;i<=rcount;i++)
				{
					eval('document.all_tree.related_id_'+i+'_'+satir).innerHTML = data;
				}
			});
		}
		/*else
		{
			for(var i=1;i<=rcount;i++)
			{
				eval('document.all_tree.related_id_'+i+'_'+satir).value=eval('document.all_tree.old_related_id_'+kolonno+'_'+satir).value;
				eval('document.all_tree.product_id_'+i+'_'+satir).value=eval('document.all_tree.old_product_id_'+kolonno+'_'+satir).value;
				eval('document.all_tree.product_name_'+i+'_'+satir).value=eval('document.all_tree.old_product_name_'+kolonno+'_'+satir).value;
				eval('document.all_tree.operation_type_id_'+i+'_'+satir).value=eval('document.all_tree.old_operation_type_id_'+kolonno+'_'+satir).value;
					
			}
		}*/
	</cfif>
							
	}

	function del_stock(stock_id,kolonno,satir)
	{
		if(confirm('Ağaçtan çıkartılacak eminmisiniz?'))
		{
			eval('document.all_tree.row_status_'+kolonno+'_'+satir).value=0;
			eval('document.all_tree.product_name_'+kolonno+'_'+satir).value='';
		}
	}
	
	function add_row(stock_id)
	{
				
	<cfif IsDefined("get_stock_size")>
					
		<cfoutput query="get_stock_size">
						
		row_count=eval("document.getElementById('row_count_#currentrow#_#stock_id#')").value;
	
		max_line=document.all_tree.max_line.value;
		max_line++;
		document.all_tree.max_line.value=max_line;
		row_count++;
		var newRow;
		var newCell;
		var table=eval("document.getElementById('table_#stock_id#')");
		newRow =table.insertRow(table.rows.length);	
		newRow.setAttribute("name","frm_row"+row_count);
		newRow.setAttribute("id","frm_row"+row_count);		
		newRow.setAttribute("NAME","frm_row"+row_count);
		newRow.setAttribute("ID","frm_row"+row_count);
		eval("document.getElementById('row_count_#currentrow#_#stock_id#')").value=row_count;
		
		newCell = newRow.insertCell();
		newCell.innerHTML=row_count;

		newCell = newRow.insertCell();
		newCell.innerHTML='';
	
		newCell = newRow.insertCell();
		newCell.innerHTML='<input type="checkbox" name="stock_fix_#currentrow#_'+row_count+'" value="1" title="Diğer ağaçlara uygula" onclick="stock_fix(this,#currentrow#,'+row_count+');">';

		newCell = newRow.insertCell();
		newCell.innerHTML= '<input type="text" style="width:calc(100% - 20px);text-align:right;" class="boxtext" readonly name="product_name_#currentrow#_'+row_count+'"  value=""><a href="javascript://" onClick="open_product(#stock_id#,'+row_count+',#currentrow#,0);"><img src="images/plus_thin.gif"></a><input type="hidden" style="width:30mm;text-align:right;" class="boxtext" name="old_product_name_#currentrow#_'+row_count+'"  value="">';

		newCell = newRow.insertCell();
		newCell.innerHTML='<select name="related_id_#currentrow#_'+row_count+'" id="related_id_#currentrow#_'+row_count+'"></select>';

		newCell = newRow.insertCell();
		newCell.innerHTML= '<input type="text" style="width:5mm;text-align:right;" class="boxtext" name="amount_#currentrow#_'+row_count+'"  value="1">';	
		newCell.innerHTML+= '<input type="hidden" name="process_stage_#currentrow#_'+row_count+'" id="process_stage_#currentrow#_'+row_count+'" value="">';
		newCell.innerHTML+='<input type="hidden" name="is_phantom_#currentrow#_'+row_count+'" id="is_phantom_#currentrow#_'+row_count+'" value=""><input type="hidden" name="operation_type_id_#currentrow#_'+row_count+'" id="operation_type_id_#currentrow#_'+row_count+'" value=""><input type="hidden" name="old_operation_type_id_#currentrow#_'+row_count+'" id="old_operation_type_id_#currentrow#_'+row_count+'" value=""><input type="hidden" name="new_row_#currentrow#_'+row_count+'" id="new_row_#currentrow#_'+row_count+'" value="">';
		newCell.innerHTML+='<input type="hidden" name="line_number_#currentrow#_'+row_count+'" id="line_number_#currentrow#_'+row_count+'" value="'+max_line+'"><input type="hidden" name="spect_main_id_#currentrow#_'+row_count+'" value="">';
		newCell.innerHTML+='<input type="hidden" name="is_configure_#currentrow#_'+row_count+'" id="is_configure_#currentrow#_'+row_count+'" value="1"><input type="hidden" name="is_sevk_#currentrow#_'+row_count+'" id="is_sevk_#currentrow#_'+row_count+'" value=""><input type="hidden" name="unit_id_#currentrow#_'+row_count+'" id="unit_id_#currentrow#_'+row_count+'" value=""><input type="hidden" name="unit_#currentrow#_'+row_count+'" id="unit_#currentrow#_'+row_count+'" value=""><input type="hidden" name="stock_code_#currentrow#_'+row_count+'" id="stock_code_#currentrow#_'+row_count+'" value=""><input type="hidden" name="is_tree_#currentrow#_'+row_count+'" id="is_tree_#currentrow#_'+row_count+'" value="0"><input type="hidden" name="old_related_id_#currentrow#_'+row_count+'" id="old_related_id_#currentrow#_'+row_count+'" value=""><input type="hidden" name="product_id_#currentrow#_'+row_count+'" id="product_id_#currentrow#_'+row_count+'" value=""><input type="hidden" name="old_product_id_#currentrow#_'+row_count+'" id="old_product_id_#currentrow#_'+row_count+'" value=""><input type="hidden" name="row_status_#currentrow#_'+row_count+'" id="row_status_#currentrow#_'+row_count+'" value="1">';
					
		</cfoutput>
	</cfif>
	}
	
	function open_product(stock_id,no,satir,pid)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_spect_main_id=all_tree.spect_main_id_'+satir+'_'+no+'&field_spect_main_name=all_tree.product_name_'+satir+'_'+no+'&field_id=all_tree.related_id_'+satir+'_'+no+'&field_name=all_tree.product_name_'+satir+'_'+no+'&product_id=all_tree.product_id_'+satir+'_'+no+'&field_unit=all_tree.unit_id_'+satir+'_'+no,'page');
	}
	
	function open_op(stock_id,no,satir)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_operation_type&field_id=all_tree.operation_type_id_'+satir+'_'+no+'&field_name=all_tree.product_name_'+satir+'_'+no+'&is_submitted=1&keyword=','page');
	
	}
	
	function pencere_ac_alternative(no,pid,sid,msid)//ürünlerin alternatiflerini açıyor
	{
		stock_id=msid;
		form_name=eval("document.getElementById('form_tree_"+stock_id+"')");
		obje="document."+form_name.name+".related_id_"+no;
		form_stock=eval(obje);

	
		url_str='&tree_info_null_=1&product_id=all_tree.product_id_'+no+'&call_function=calc_amount_exit&call_function_paremeter='+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=all_tree.related_id_'+no+'&field_unit_name=all_tree.unit_'+no+'&field_code=all_tree.stock_code_'+no+'&field_name=all_tree.product_name_' + no + '&field_amount=all_tree.amount_' + no + '&field_unit=all_tree.unit_id_'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';

		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}
	
	function renk_kontrol()
	{
		if(document.all.stock_color.value=='')
		{
			alert('Renk Seçiniz!');
			return false;
		}
		return true;
	}
	
	function calc_amount_exit()
	{
	;}

	$(document).ready(function() {
		if ($("#process_stage").val() == "") {
			$("#process_stage option").eq(1).attr('selected', 'selected');
		}
	});
</script>
			
			
			