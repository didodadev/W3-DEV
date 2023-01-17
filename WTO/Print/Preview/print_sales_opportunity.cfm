
<head>
	<style>
		
		.row_border{border-bottom:1px solid #c0c0c0;}
		table tr td img{max-width:200px;}
			.kutu{width: 220px;
				  height:200px;
				  border: 1px solid #c0c0c0;
				  width: 700px;
				  margin-left: 0px;
			}
			
			.ornek{
			width: 500px;
			margin:auto;
			}

			.sola-kaydir{
			float:left;
			padding:0 10px 10px 0;
			}
	  </style>
	</head>
	<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
		SELECT * , PS.PRODUCT_SAMPLE_NAME  , PS.CUSTOMER_MODEL_NO FROM  OPPORTUNITIES AS O	left join PRODUCT_SAMPLE AS PS ON O.OPP_ID = PS.OPPORTUNITY_ID WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> 
	</cfquery>

 <cfquery name="GET_SAMPLE_OPPORTUNITY_" datasource="#DSN3#">
	SELECT O.OPP_ID,
	 
                PS.PRODUCT_SAMPLE_ID 
                , PS.PRODUCT_SAMPLE_NAME 
                , PS.PRODUCT_SAMPLE_CAT_ID 
                , PS.PRODUCT_CAT_ID 
                , PS.BRAND_ID 
                , PS.DESIGNER_EMP_ID 
				,P.PRODUCT_CODE
                , PS.PROCESS_STAGE_ID 
                ,O.COMPANY_ID
                , O.PARTNER_ID
                , O.CONSUMER_ID
                ,O.SALES_CONSUMER_ID
                ,O.SALES_PARTNER_ID
                , PS.OPPORTUNITY_ID 
                , PS.OFFER_ID 
                , PS.ORDER_ID 
                , PS.SALES_PRICE
                , PS.SALES_PRICE_CURRENCY
                , PS.TARGET_PRICE 
                , PS.TARGET_PRICE_CURRENCY 
                , PS.TARGET_AMOUNT 
                , PS.TARGET_AMOUNT_UNITY 
                , PS.TARGET_DELIVERY_DATE as TARGET_DELIVERY_DATE
                , PS.PRODUCT_SAMPLE_DETAIL 
                , PS.RECORD_DATE 
              ,PS.TARGET_PRICE * PS.TARGET_AMOUNT AS TARGET_
                , PS.RECORD_EMP 
                , PS.RECORD_IP 
                , PS.UPDATE_DATE 
                , PS.UPDATE_EMP 
                , PS.UPDATE_IP 
                , PS.REFERENCE_PRODUCT_ID 
                , PS.CUSTOMER_MODEL_NO
				,SU.UNIT 
              
			FROM   PRODUCT_SAMPLE AS PS
			LEFT JOIN #DSN1#.PRODUCT AS P ON P.P_SAMPLE_ID = PS.PRODUCT_SAMPLE_ID
			left join OPPORTUNITIES AS O ON O.OPP_ID = PS.OPPORTUNITY_ID 
	  LEFT JOIN #dsn#.SETUP_UNIT AS  SU ON SU.UNIT_ID = PS.TARGET_AMOUNT_UNITY 
	  where PS.OPPORTUNITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_OPPORTUNITY.OPP_ID#"> 
	  AND P.P_SAMPLE_ID IS NOT NULL 
</cfquery>

<cfset comp = createObject("component","V16.product.cfc.product_sample") />
<cfset comp_ = createObject("component","Utility.DatabaseInfo") />
		
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	COMPANY_NAME,
	WEB,
	TAX_OFFICE,
	TAX_NO,
	ADDRESS
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
				COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
				COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = #session.cp.our_company_id#
			</cfif> 
		</cfif> 
</cfquery>

	
		<cf_woc_elements>
		
			<tr class="row_border">  
				<td  class="ornek" >
					<cfif len(check.asset_file_name2)>
						<cfset attributes.type = 1>
						<div class="sola-kaydir"><cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5"></div>
						<cfoutput query="check">
							<div style="padding-top:20px;">#COMPANY_NAME#<br>#ADDRESS#<br><cf_get_lang dictionary_id='65366.Web Sitesi'>: #WEB#<br><cf_get_lang dictionary_id='58762.Vergi Dairesi'>: #TAX_OFFICE#<br>VKN: #TAX_NO#</div>	
						</cfoutput>
					</cfif>
				</td>
				<td >
					<div class="col col-8"><label  style="color:black;font-size:25px;padding-top: 20px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='57545.Teklif'></label></br>
						<label  style="color:black;font-size:15px;padding-top: 20px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;">DOC NO:<cfoutput>#get_opportunity.opp_no#</cfoutput></label></br>
					</div>
					<cfif len(get_opportunity.partner_id)>
					<cfset musteri= get_par_info(get_opportunity.company_id,1,0,0)>
					<cfelseif len(get_opportunity.consumer_id)>
						<cfset musteri= get_cons_info(get_opportunity.consumer_id,1,0,0)>
					</cfif>
					<div class="col col-4">
						<cf_workcube_barcode show="1" type="qrcode" width="100" height="100" value="#get_opportunity.opp_no#-#musteri#">
					</div>
				</td>
			</tr>
			
			<cf_wuxi id="opp_date" data="#dateformat(get_opportunity.opp_date,dateformat_style)#" label="38655" type="cell">
			<cf_wuxi id="opp_action_date" data="#dateformat(get_opportunity.action_date,dateformat_style)#" label="58624" type="cell">
			<cfif len(get_opportunity.partner_id)>
				<cf_wuxi id="com_name" data="#get_par_info(get_opportunity.company_id,1,0,0)#" label="57457" type="cell"></cfif>
			<cfif len(get_opportunity.sales_emp_id)>
				<cf_wuxi id="sales_emp" data="#get_emp_info(get_opportunity.sales_emp_id,0,0)#" label="30613" type="cell"></cfif>
					
				
		</cf_woc_elements>
	<cf_woc_elements>
		
			<tr>
				<td ><label  class="bold" style="font-size:12px;width:700px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='58780.Sayın'> <cfif len(get_opportunity.partner_id)><cfoutput>#get_par_info(get_opportunity.partner_id,0,-1,0)#</cfoutput><cfelseif (get_opportunity.consumer_id)><cfoutput>#get_cons_info(get_opportunity.consumer_id,1,0,0)#</cfoutput></cfif> </label></td>
			</tr>
			<tr>
				<td ><label  class="bold" style="font-size:12px;width:700px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='58780.Sayın'> <cfif len(get_opportunity.ref_partner_id)><cfoutput>#get_par_info(get_opportunity.REF_PARTNER_ID,0,-1,0)#</cfoutput>
				<cfelseif len(get_opportunity.ref_consumer_id)><cfoutput>#get_cons_info(get_opportunity.ref_consumer_id,1,0,0)#</cfoutput></cfif></label></td>
			</tr>
			<tr>
				<td><label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65350.Talep etmiş olduğunuz ürünler için çalışmaları tamamladık. Detaylı teknik bilgi ve fiyatlarımızı bilgilerinize sunarız.'></label></td>
			</tr>
			<tr>
				<td><label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='48814.Saygılarımızla'>.</label></td>
			</tr>
		
	</cf_woc_elements>
		
		<cfset total = 0>
		
			<cfset toplam_tutar = 0>
			<Cfloop query="GET_SAMPLE_OPPORTUNITY_">
				<cfif not len(target_)><cfset target= 0><cfelse><cfset target= target_></cfif>
				
					<cfset toplam_tutar = toplam_tutar + target>
				
			</Cfloop>
			<cf_woc_elements>
				<cf_wuxi label="57564" type="cell" is_row="0" id="wuxi_57564" style_th="text-align:left;">
			
			<cf_woc_list id="product_" table_width="700">
				<thead>
					<tr>
						<cf_wuxi label="57487" type="cell" is_row="0" id="wuxi_57487"> 
						<cf_wuxi label="57024" type="cell" is_row="0" id="wuxi_57024"> 
						<cf_wuxi label="57657+36199" type="cell" is_row="0" id="wuxi_37249"> 
						<cf_wuxi label="37249" type="cell" is_row="0" id="wuxi_37249"> 
						<cf_wuxi label="57638" type="cell" is_row="0" id="wuxi_57638"> 
						<cf_wuxi label="57636" type="cell" is_row="0" id="wuxi_57636">  
						<cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635">  
						<cf_wuxi label="57492" type="cell" is_row="0" id="wuxi_57492">  
					</tr>
				</thead> 
				
			<cfif GET_SAMPLE_OPPORTUNITY_.recordcount>
				<cfquery dbtype="query" name="SAMPLE_TARGET">
					SELECT MAX(TARGET_DELIVERY_DATE) as TARGET_DELIVERY_DATE  FROM GET_SAMPLE_OPPORTUNITY_ 
				</cfquery>
				<cfset now= Now()>
				<cfif len(SAMPLE_TARGET.TARGET_DELIVERY_DATE)>
					<cfset fark_ = Ceiling(datediff('d',now,SAMPLE_TARGET.TARGET_DELIVERY_DATE))>
				<cfelse>
					<cfset fark_=0>
				</cfif>
				<cfset fark_toplam = fark_ / 7>
					<cfoutput query="GET_SAMPLE_OPPORTUNITY_">
						<cfset GET_STOCK_DETAIL = comp.GET_STOCK_DETAIL(PRODUCT_SAMPLE_ID : GET_SAMPLE_OPPORTUNITY_.PRODUCT_SAMPLE_ID )/>
					<tbody>
						<tr>
							<cf_wuxi data="#currentrow#" type="cell" is_row="0"> 
							<cfif len(GET_SAMPLE_OPPORTUNITY_.CUSTOMER_MODEL_NO)><cf_wuxi data="#GET_SAMPLE_OPPORTUNITY_.CUSTOMER_MODEL_NO#" type="cell" is_row="0"> <cfelse><cf_wuxi data="-" type="cell" is_row="0"></cfif>
							<cf_wuxi data="#product_sample_name#" type="cell" is_row="0">
							<cf_wuxi data="#GET_STOCK_DETAIL.recordcount#" type="cell" is_row="0" style_th="text-align:left"> 
							<cf_wuxi data="#TLFormat(target_price)# #target_price_currency# " type="cell" is_row="0">
							<cfif len(unit)><cf_wuxi data="#unit#" type="cell" is_row="0"><cfelse><cf_wuxi data="-" type="cell" is_row="0"></cfif>
							<cfif len(target_amount)><cf_wuxi data="#target_amount#" type="cell" is_row="0"  class="text-right"><cfelse><cf_wuxi data="-" type="cell" is_row="0"  class="text-right"></cfif>
							<cf_wuxi data="#target_price#-#target_price_CURRENCY#" type="cell" is_row="0"  class="text-right"> 			
						</tr> 
					</tbody>
				</cfoutput>
				<tbody>

					<tr >	<td colspan="7"></td>
					<cf_wuxi data="#toplam_tutar#" class="text-right" type="cell" is_row="8" colspan="8" style_td="text-align:right"></tr> 
				</tbody>
			
			<cfelse>
				<tbody><tr><cf_wuxi label="57484" type="cell" is_row="0" id="wuxi_42263" hint="dağılım" colspan="4"></tr></tbody>
			</cfif>
	
		</cf_woc_list>
		
	</cf_woc_elements>
	<cfif GET_SAMPLE_OPPORTUNITY_.recordcount>
	<cf_woc_elements>
		<div class="col col-12">
			<label class="col col-2" style="color:black;line-height: 18px !important;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='57645.Teslim Tarihi'>	</label>
			<label class=" col col-8"  style="color:black;line-height: 18px !important;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;"><cfif fark_toplam gte 0  and fark_ gte 7><cfoutput>#wrk_round(fark_toplam,0)#</cfoutput> <cf_get_lang dictionary_id='58734.Hafta'><cfelseif fark_ lte 7 and fark_ gte 0 and len(SAMPLE_TARGET.TARGET_DELIVERY_DATE)><cfoutput>#wrk_round(fark_,0)#</cfoutput> <cf_get_lang dictionary_id='57490.Gün'><cfelseif not  len(SAMPLE_TARGET.TARGET_DELIVERY_DATE)><cf_get_lang dictionary_id='57645.Teslim Tarihi'><cf_get_lang dictionary_id='47295.bulunmamakta'>!<cfelse><cf_get_lang dictionary_id='45261.Teslim edilecek tarihi geçtiniz !'></cfif></label>
		</div>
		</br>
		<div class="col col-12">
			<label class="col col-2" style="color:black;line-height: 18px !important;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='45361.Sevk Yönetimi'>
			</label>
			<label class=" col col-8" style="color:black;line-height: 18px !important;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;">Ex-Work Multi Loading
			</label>
		</div>
	</cf_woc_elements>
	</cfif>
					
	</br>



			
				
	<cf_woc_elements style="page-break-after:always;" id="aaa">
		<h3><cf_get_lang dictionary_id='51093.Ekler'></h3>
		<label style="line-height: 18px !important;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;"><cfoutput>#GET_SAMPLE_OPPORTUNITY_.recordcount# </cfoutput><cf_get_lang dictionary_id='58082.Adet'> <cf_get_lang dictionary_id='40890.Ürün Teknik Föyü'></label>
		<h3><cf_get_lang dictionary_id='65360.Kontrol ve Onay Süreci'></h3>
		<label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65361.Sipariş öncesi her bir ürüne ait  teknik föyü lütfen kontrol ediniz.'></label></br>
		<label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65362.Her bir ürün aşağıdaki 5 kritere göre onaylanması veya geri bildirim yapılması gereklidir.'></label></br>
		<label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65363.1- Tasarım,  2-Material, 3- Ölçü ve Dağılım Tablosu, 4- Test ve Kalite, 5- Ambalaj ve Etiket'></label>
	</cf_woc_elements>
		
<cfif LEN(GET_OPPORTUNITY.PRODUCT_SAMPLE_ID)>

	<Cfloop query="get_opportunity">
	
		<cfset sample_relation = comp.get_relation_sample(product_sample_id : GET_OPPORTUNITY.product_sample_id)>
		<cfif sample_relation.recordcount>
			<cfset get_stock = comp.get_stock(product_id : sample_relation.product_id, barcod : sample_relation.barcod )>
			<cfquery name="GET_PROD_TREE" datasource="#DSN3#">
				SELECT
					PT.*,
					PTT.TYPE_ID,
					PTT.TYPE,
					OP.OPERATION_TYPE_ID,
					OP.OPERATION_TYPE,
					P.PRODUCT_NAME,
					PU.MAIN_UNIT
				FROM 
					PRODUCT_TREE PT
					LEFT JOIN #DSN#.PRODUCT_TREE_TYPE AS PTT ON PTT.TYPE_ID= PT.TREE_TYPE
					LEFT JOIN OPERATION_TYPES AS OP ON OP.OPERATION_TYPE_ID=PT.OPERATION_TYPE_ID
					LEFT JOIN #dsn1#.PRODUCT AS P ON P.PRODUCT_ID=PT.PRODUCT_ID
					LEFT JOIN #dsn1#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=P.PRODUCT_ID
				WHERE
					PT.STOCK_ID=#get_stock.STOCK_ID# 
			
			</cfquery>

			<cfset get_product = comp.get_product(stock_id: get_stock.stock_id)>
			<cfquery name="sample_image" datasource="#dsn3#">
				SELECT 
					  *
					   FROM 
					   PRODUCT_IMAGES 
					   WHERE 
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#">
	  		</cfquery> 
			<cfif isDefined("GET_OPPORTUNITY.product_sample_id") and len(GET_OPPORTUNITY.product_sample_id)>
				
				<cfset Query_result = comp_.Query_result(q : 'SELECT SAMPLE_ASORTI_JSON,PRODUCT_SAMPLE_NAME FROM #dsn3#.PRODUCT_SAMPLE where PRODUCT_SAMPLE_ID = #GET_OPPORTUNITY.product_sample_id#')/>					
			</cfif>
			<cfquery name="get_Product_Cat_Quality_Types" datasource="#dsn3#">
					SELECT 
					QT.QUALITY_CONTROL_TYPE,
					QT.TYPE_ID,
					PO.PROCESS_CAT AS PROCESS_CAT,
					PO.ORDER_NO,
					PO.QUALITY_TYPE_ID,
					PO.PRODUCT_ID,
					QT.CONTENT_ID,
					C.CONT_HEAD,
					PO.PRODUCT_QUALITY_ID
				FROM 
					PRODUCT_QUALITY PO
					LEFT JOIN QUALITY_CONTROL_TYPE  AS QT ON QT.TYPE_ID = PO.QUALITY_TYPE_ID
					LEFT JOIN #dsn#.CONTENT AS C ON C.CONTENT_ID=QT.CONTENT_ID
				
				WHERE
					po.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#">
			</cfquery>
		
			<cfset file_web_path = "#file_web_path#">
			<cfset image_type = "product">
				<table >
					
					<tr class="row_border">  
					
					<td  class="ornek" >
						<cfif len(check.asset_file_name2)>
							<cfset attributes.type = 1>
						<div class="sola-kaydir"><cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5"></div>
								<cfoutput query="check">
								<div style="padding-top:20px;"><cfif len(get_opportunity.partner_id)><cfoutput>#get_par_info(get_opportunity.company_id,1,0,0)#</cfoutput><cfelseif (get_opportunity.consumer_id)><cfoutput>#get_cons_info(get_opportunity.consumer_id,1,0,0)#</cfoutput></cfif><br>DOC NO:#get_opportunity.opp_no#<br>#dateformat(get_opportunity.opp_date,dateformat_style)#<br></div>	
								</cfoutput>
						</cfif>
					</td>
					<td >
						<div class="col col-8"><label  style="color:black;font-size:25px;padding-top: 20px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cfoutput>#GET_OPPORTUNITY.CUSTOMER_MODEL_NO#</cfoutput></label></br>
							<label  style="color:black;font-size:15px;padding-top: 20px;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cfoutput>#GET_OPPORTUNITY.PRODUCT_SAMPLE_NAME#</cfoutput></label></br>
						</div>
						<div class="col col-4">
							<cf_workcube_barcode show="1" type="qrcode" width="100" height="100" value="#get_opportunity.opp_no#+#GET_OPPORTUNITY.CUSTOMER_MODEL_NO#">
						</div>

						</td>
					</tr>
				</table>
				</br>
				<table class="table table-bordered print_border"  border="1" style="width:700px;">
					<tr><td style="text-align:left;color:black;font-weight:bold;font-size:18px!important;" ><cfoutput>#Query_result.PRODUCT_SAMPLE_NAME#</cfoutput></td></tr>
					<tr><td style="text-align:left;color:black;font-weight:bold;font-size:12px!important;"><cf_get_lang dictionary_id='30817.Customer No'><cfif len(GET_OPPORTUNITY.CUSTOMER_MODEL_NO)><cfoutput>#GET_OPPORTUNITY.CUSTOMER_MODEL_NO#</cfoutput><cfelse>-</cfif></td></tr>
				</table>
				
				<h3>1.<cf_get_lang dictionary_id='29792.Tasarım'></h3>
				<div class="kutu" >
					<cfif isdefined("sample_image.path") and len(sample_image.path)><cfoutput><img src="#file_web_path##image_type#/#sample_image.path#" class="" style=" max-width:180px;max-height: 180px;float:left;padding:10px 30px 10px 10px;"></cfoutput></cfif>
					<h4><cf_get_lang dictionary_id='65344.Ürün Dijital Dosyaları'></h4>
					<label class="bold" style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;">1.</label><label style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65345.3d Tasarım- Format :Clo3D'></label></br>
					<label class="bold" style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;">2.</label><label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65347.2D Tasarım-Format:PDF'></label></br>
					<label class="bold" style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;">3.</label><label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='65348.2D Tasarım-Format:DXF - Gerber'></label></br>
						<label class="bold" style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;">4.</label><label  style="line-height: 18px !important;font-family: Geneva, tahoma, arial, Helvetica, sans-serif;"><cf_get_lang dictionary_id='62603.Numune'><cf_get_lang dictionary_id='65349.Resimler'>,<cf_get_lang dictionary_id='52566.Videolar'></label></br>
				</div>
			<cf_woc_elements>
				<cf_wuxi label="444" type="cell" is_row="0" id="wuxi_444" style_th="text-align:left;">
					<cf_woc_list id="material_" table_width="700">
						<thead>
							<tr>
								<cf_wuxi label="57487" type="cell" is_row="0" id="wuxi_57487"> 
								<cf_wuxi label="63502" type="cell" is_row="0" id="wuxi_63502"> 
								<cf_wuxi label="444" type="cell" is_row="0" id="wuxi_444"> 
								<cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
								<cf_wuxi label="57636" type="cell" is_row="0" id="wuxi_57636"> 
							</tr>
						</thead>
						
						<cfoutput  query="GET_PROD_TREE">
							<tbody>
								<tr>
									<cf_wuxi data="#currentrow#" type="cell" is_row="0"> 
									<cfif len(TYPE)><cf_wuxi data="#GET_PROD_TREE.TYPE#" type="cell" is_row="0"> <cfelse><cf_wuxi data="-" type="cell" is_row="0"> </cfif>
									<cfif len(RELATED_ID)><cf_wuxi data="#GET_PROD_TREE.product_name#" type="cell" is_row="0"> <cfelseif len(OPERATION_TYPE)><cf_wuxi data="#OPERATION_TYPE#" type="cell" is_row="0"><cfelse><cf_wuxi data="-" type="cell" is_row="0"> </cfif>
									<cfif len(amount)><cf_wuxi data="#GET_PROD_TREE.amount#" type="cell" is_row="0"> <cfelse><cf_wuxi data="-" type="cell" is_row="0"> </cfif>
									<cfif len(RELATED_ID)><cf_wuxi data="#GET_PROD_TREE.main_unit#" type="cell" is_row="0"> <cfelse><cf_wuxi data="-" type="cell" is_row="0"></cfif>
									            
								</tr>
							</tbody>
						</cfoutput>
					
					</cf_woc_list>
				</cf_woc_elements>
			<cf_woc_elements>
				<cf_wuxi label="63452" type="cell" is_row="0" id="wuxi_63452" style_th="text-align:left;">
					<cf_woc_list id="olcu_" table_width="700">
						<cfif len(Query_result.SAMPLE_ASORTI_JSON)>
							<cfset colspan = 1>
							<cfset asorti_json = deserializeJSON(Query_result.SAMPLE_ASORTI_JSON)>
							<cfset asorti_header = asorti_json.headers>
							<cfset asorti_content = asorti_json.content>
							<thead>
								<tr>
									<cf_wuxi label="42263" type="cell" is_row="0" id="wuxi_42263" hint="dağılım"> 
									<cfloop from="1" to="#arrayLen(asorti_header)#" index="i">
										<cf_wuxi data="#asorti_header[i]#" type="cell" is_row="0" id="wuxi_42263" > 
										<cfset colspan = colspan + 1>
									</cfloop>
								</tr>
							</thead><cfset toplam_tutar_ = 0>
								<cfloop from="1" to="#arrayLen(asorti_content)#" index="i">
									<cfset color_counter = 1>
									<tbody>
											<tr id="tr_<cfoutput>#i#</cfoutput>" >
											<cfloop from="1" to="#arrayLen(asorti_content[i])#" index="j">
												<cfif j eq 1>
													<cf_wuxi data="#asorti_content[i][j]["title"]#" type="cell" is_row="0"> 
												<cfelse>
													<cf_wuxi data="#asorti_content[i][j]["assortment"]#" type="cell" is_row="0"> 
													<cfset color_counter++>
													<cfset aaa ="#asorti_content[i][j]["assortment"]#">
												
												<cfset toplam_tutar_= toplam_tutar_ + aaa>
												</cfif>
											</cfloop>
										</tr>
									</tbody>
								</cfloop>
							<cfelse>
								<tbody><tr><cf_wuxi label="57484" type="cell" is_row="0" id="wuxi_42263"  colspan="4"></tr></tbody>
							</cfif>
							
					</cf_woc_list>
					<table>
						<cfif len(Query_result.SAMPLE_ASORTI_JSON)>
							<cf_wuxi label="46223" type="cell" is_row="0" id="wuxi_42263"data="#toplam_tutar_#"  colspan="4"></br>
						</cfif>
					</table>
				</cf_woc_elements>
				<cf_woc_elements style="page-break-after:always;">
					<cf_wuxi label="58826+57989+45359" type="cell" is_row="0" id="wuxi_63452" style_th="text-align:left;">
					<cf_woc_list id="olcu_" table_width="700">
						<thead>
							<tr>
								<cf_wuxi label="57487" type="cell" is_row="0" id="wuxi_57487">
								<cf_wuxi label="45359" type="cell" is_row="0" id="wuxi_57487">
								<cf_wuxi label="35524" type="cell" is_row="0" id="wuxi_57487">
								<cf_wuxi label="63477" type="cell" is_row="0" id="wuxi_57487">
								<cf_wuxi label="65377" type="cell" is_row="0" id="wuxi_57487">
							</tr>
						</thead>
						<cfif get_Product_Cat_Quality_Types.recordcount>
							<cfoutput query="get_Product_Cat_Quality_Types">
								<cfquery name="get_Product_Sub_Cat_Quality_Types" datasource="#dsn3#">
									SELECT 
										QR.SAMPLE_NUMBER,
										QR.QUALITY_CONTROL_TYPE_ID
									FROM 
										QUALITY_CONTROL_ROW as QR
										
									WHERE
											QR.QUALITY_CONTROL_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_Product_Cat_Quality_Types.TYPE_ID#">
										
								</cfquery> 
								<cfquery name="get_price_exceptions" dbtype="query">
									SELECT  SUM(SAMPLE_NUMBER) AS SAMPLE_NUMBER FROM get_Product_Sub_Cat_Quality_Types
								</cfquery>
								<tbody>
									<tr>
										<cf_wuxi data="#currentrow#" type="cell" is_row="0">
										<cf_wuxi data="#QUALITY_CONTROL_TYPE#" type="cell" is_row="0">
										<cfif len(CONT_HEAD)><cf_wuxi data="#CONT_HEAD#" type="cell" is_row="0"><cfelse><cf_wuxi data="-" type="cell" is_row="0"></cfif>
										<cfif len(get_price_exceptions.SAMPLE_NUMBER)><cf_wuxi data="#get_price_exceptions.SAMPLE_NUMBER#" type="cell" is_row="0"><cfelse><cf_wuxi data="-" type="cell" is_row="0"></cfif>
											<cfif  process_cat is 76><cf_wuxi label="29581" type="cell" is_row="0" id="wuxi_57487">
										<cfelseif  process_cat is 171><cf_wuxi label="29651" type="cell" is_row="0" id="wuxi_57487">
										<cfelseif  process_cat is  811><cf_wuxi label="29651" type="cell" is_row="0" id="wuxi_57487">
										<cfelseif  process_cat is  -1><cf_wuxi label="36376" type="cell" is_row="0" id="wuxi_57487">
										<cfelseif  process_cat is  -2><cf_wuxi label="57656" type="cell" is_row="0" id="wuxi_57487">
										<cfelseif  process_cat is -3><cf_wuxi label="64426" type="cell" is_row="0" id="wuxi_57487">
										<cfelse><cf_wuxi data="-" type="cell" is_row="0">
										</cfif>
									</tr>
								</tbody>
							</cfoutput>
						<cfelse>
							<tr> <td style="font-size:12px!important;" colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td></tr>
						</cfif>
					</cf_woc_list>
				</cf_woc_elements>
	
		</cfif>
	
	</Cfloop>
</cfif> 