<cfsetting showdebugoutput="no">

<!---<cfdump var="#attributes#"><cfabort>--->
<cfset textile_round=4>
<cftransaction>

	<cfobject name="supplier" component="WBP.Fashion.files.cfc.supplier">
	<cfset supplier.dsn3 = dsn3>
		

	<cfset form_req_type=attributes.req_type>
	<cfif form_req_type eq 0>
		<cfif not DirectoryExists("#upload_folder#textile#dir_seperator#kumas#dir_seperator#")>
			<cfdirectory action="create" directory="#upload_folder#textile#dir_seperator#kumas#dir_seperator#">
		</cfif>
		<cfset upload_folder_ = "#upload_folder#textile#dir_seperator#kumas#dir_seperator#">
	<cfelse>
		<cfif not DirectoryExists("#upload_folder#textile#dir_seperator#aksesuar#dir_seperator#")>
			<cfdirectory action="create" directory="#upload_folder#textile#dir_seperator#aksesuar#dir_seperator#">
		</cfif>
		<cfset upload_folder_ = "#upload_folder#textile#dir_seperator#aksesuar#dir_seperator#">
	</cfif>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfset form_product="">
			<cfset form_workrequest="">
			<cfset form_product_id="">
			<cfset form_quantity ="">
			<cfset form_company_id ="">
			<cfset form_stock_id ="">
			<cfset form_product_id="">
			<cfset form_product="">
			<cfset form_unit_id="">
			<cfset form_unit="">
			<cfset form_product_catid="">
			<cfset form_product_cat="">
			<cfset form_operation_id="">
			<cfset form_rowid="">
			<cfset form_company_stock="">
			<cfset form_money="">
			<cfset form_price="">
			
			<cfset form_en="">
			<cfset form_revize_price="">
			<cfset form_revize_quantity ="">
			<cfset form_image="">
			<cfset form_row_detail="">
			<cfset form_row_status="">
			<cfset form_row_revize="">
			<cfset form_row_variant="">
			
			<cfset form_company_id = evaluate("attributes.company_id#i#")>
			<cfset form_stock_id = evaluate("attributes.stock_id#i#")>
			<cfset form_row_detail=evaluate("attributes.row_detail#i#")>
			<cfif isdefined("attributes.product#i#")>
				<cfset form_product_id = evaluate("attributes.product_id#i#")>
				<cfset form_product = evaluate("attributes.product#i#")>
				<cfset form_unit_id=evaluate("attributes.unit_id#i#")>
				<cfset form_unit=evaluate("attributes.unit_name#i#")>
			</cfif>
			<cfset attributes.photo_="">
				<cfif isdefined("attributes.image_#i#") and len(evaluate("attributes.image_#i#"))>
					
						<cftry>
							<cffile
								action="UPLOAD" 
								filefield="image_#i#" 
								destination="#upload_folder_#" 
								mode="777" 
								nameconflict="MAKEUNIQUE"
								>
						<cfcatch type="Any">
								<script type="text/javascript">
									alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
								</script>
								<cfabort>
							</cfcatch>  
						</cftry>
					
						<cfset file_name = '#createUUID()#'>
						<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#.#cffile.serverfileext#">
						<cfset attributes.photo_ = '#file_name#.#cffile.serverfileext#'>
					
				</cfif>
					<cfif isDefined("attributes.image_var#i#") and len(evaluate("attributes.image_var#i#")) and not len(attributes.photo_)>
						<cfset attributes.photo_ = evaluate("attributes.image_var#i#")>
					</cfif>
				
	
					<cfset form_image=attributes.photo_>
		
			<cfif isdefined("attributes.category#i#")>
				<cfset form_product_catid = evaluate("attributes.category#i#")>
			</cfif>
			<cfif isdefined("attributes.category_name#i#")>
				<cfset form_product_cat = evaluate("attributes.category_name#i#")>
			</cfif>
			<cfif isdefined("attributes.rowid#i#")>
				<cfset form_rowid=evaluate("attributes.rowid#i#")>
			</cfif>
			<cfif IsDefined("attributes.operation#i#")>
				<cfset form_operation_id=evaluate("attributes.operation#i#")>
			</cfif>
			<cfif IsDefined("attributes.demand_stock#i#")>
				<cfset form_company_stock=evaluate("attributes.demand_stock#i#")>
			</cfif>
	
			<cfif isdefined("attributes.money#i#")>
				<cfset form_money = evaluate("attributes.money#i#")>
			</cfif>
			<cfif isdefined("attributes.quantity#i#")>
				<cfset form_quantity = evaluate("attributes.quantity#i#")>
					<cfset form_quantity=filterNum(form_quantity,textile_round)>
			</cfif>
			<cfif isdefined("attributes.price#i#")>
				<cfset form_price = evaluate("attributes.price#i#")>
				<cfset form_price=filterNum(form_price,textile_round)>
			</cfif>
			
			<cfif isdefined("attributes.en#i#")>
				<cfset form_en=evaluate("attributes.en#i#")>
				<cfset form_en=filterNum(form_en,textile_round)>
			</cfif>
			<cfif isdefined("attributes.revize_price#i#")>
				<cfset form_revize_price = evaluate("attributes.revize_price#i#")>
				<cfset form_revize_price=filterNum(form_revize_price,textile_round)>
			</cfif>
			
			<cfif isdefined("attributes.revize_quantity#i#")>
				<cfset form_revize_quantity = evaluate("attributes.revize_quantity#i#")>
				<cfset form_revize_quantity=filterNum(form_revize_quantity,textile_round)>
			</cfif>
			<cfif isdefined("attributes.work_id#i#")>
				<cfset form_work_id = evaluate("attributes.work_id#i#")>
			</cfif>
			<cfif isdefined("attributes.wrk_row_id#i#")>
				<cfset form_wrk_row_id = evaluate("attributes.wrk_row_id#i#")>
			</cfif>
			<cfif isdefined("attributes.status#i#")>
				<cfset form_row_status=evaluate("attributes.status#i#")>
			</cfif>
			<cfif isdefined("attributes.revize#i#")>
				<cfset form_row_revize=evaluate("attributes.revize#i#")>
			</cfif>
			<cfif isdefined("attributes.workreques#i#")>
				<cfset form_workreques=evaluate("attributes.workreques#i#")>
			</cfif>
			<cfif isDefined("attributes.VARIANT#i#")>
				<cfset form_row_variant = evaluate("attributes.VARIANT#i#")>
			</cfif>
				<cfscript>
					if (not len(form_rowid))
					{
						query_supplier=supplier.add_supplier(
								req_id:attributes.req_id,
								form_company_id:form_company_id,
								form_stock_id:form_stock_id,
								form_product_id:form_product_id,
								form_product:form_product,
								form_unit_id:form_unit_id,
								form_unit:form_unit,
								form_product_catid:form_product_catid,
								form_product_cat:form_product_cat,
								form_money:form_money,
								form_operation_id:form_operation_id,
								form_company_stock:form_company_stock,
								form_req_type:form_req_type,
								form_quantity:form_quantity,
								form_price:form_price,
								form_en:form_en,
								form_revize_quantity:form_revize_quantity,
								form_revize_price:form_revize_price,
								form_work_id:form_work_id,
								form_wrk_row_id:form_wrk_row_id,
								form_image:form_image,
								form_row_detail:form_row_detail,
								form_row_status:form_row_status,
								form_row_revize:form_row_revize,
								form_row_variant:form_row_variant,
								form_workrequest:form_workrequest
								);
					}
					else
					{
						query_supplier=supplier.upd_supplier(
								form_rowid:form_rowid,
								req_id:attributes.req_id,
								form_company_id:form_company_id,
								form_stock_id:form_stock_id,
								form_product_id:form_product_id,
								form_product:form_product,
								form_unit_id:form_unit_id,
								form_unit:form_unit,
								form_product_catid:form_product_catid,
								form_product_cat:form_product_cat,
								form_money:form_money,
							    form_operation_id:form_operation_id,
								form_company_stock:form_company_stock,
								form_req_type:form_req_type,
								form_quantity:form_quantity,
								form_price:form_price,
								form_en:form_en,
								form_revize_quantity:form_revize_quantity,
								form_revize_price:form_revize_price,
								form_work_id:form_work_id,
								form_wrk_row_id:form_wrk_row_id,
								form_image:form_image,
								form_row_detail:form_row_detail,
								form_row_status:form_row_status,
								form_row_revize:form_row_revize,
								form_row_variant:form_row_variant,
								form_workrequest:form_workrequest
								);
					}
				</cfscript>
		<cfelse>
				<cfif isdefined("attributes.rowid#i#")>
					<cfset form_rowid=evaluate("attributes.rowid#i#")>
					<cfscript>
						delrow_supplier=supplier.delrow_supplier(
							form_rowid:form_rowid,
							req_id:attributes.req_id
						);
					</cfscript>
				</cfif>
		</cfif>
	</cfloop>
	
</cftransaction>
<script type="text/javascript">
<cfif attributes.supplier_page eq 'request_plan'><!---numune yonetiminden geliyor ise--->
	
		<cfif form_req_type eq 0 and attributes.other_process eq 0><!---urun yonetimine gonderilmediyse--->
			<cfset open_box="fabric">
		<cfelseif form_req_type eq 1 and attributes.other_process eq 0><!---urun yonetimine gonderilmediyse--->
			<cfset open_box="accessory">
		<cfelse>
			<cfset open_box="">
		</cfif>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#attributes.req_id#&referal_page=#open_box#</Cfoutput>';
<cfelseif  attributes.supplier_page eq 'product_plan'><!---ürün yonetiminden geliyor ise--->
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.product_plan&event=upd&plan_id=#attributes.plan_id#</Cfoutput>';
<cfelseif  attributes.supplier_page eq 'modelhouse_plan'><!---modelhane geliyor ise--->
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.pattern_plan&event=upd&plan_id=#attributes.plan_id#</Cfoutput>';
<cfelseif  attributes.supplier_page eq 'price_plan'><!---modelhane geliyor ise--->
			<cfif form_req_type eq 0>
						<cfset open_box="fabric">
			<cfelse>
						<cfset open_box="accessory">
			</cfif>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.#open_box#_price&event=upd&plan_id=#attributes.plan_id#</Cfoutput>';
</cfif>
</script>