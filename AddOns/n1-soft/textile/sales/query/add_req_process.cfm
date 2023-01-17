
<!---<cfquery name="del_process" datasource="#dsn3#">
	DELETE TEXTILE_SR_PROCESS WHERE REQUEST_ID=#attributes.req_id# and PRODUCT_CATID=#attributes.product_catid#
</cfquery>--->
	<cfset upload_folder = "#upload_folder#textile#dir_seperator#iscilik#dir_seperator#">
	<cfset textile_round=3>
<cfloop from="1" to="#attributes.record_num#" index="i">
	
	<cfset form_image="">
	
		<cfset attributes.photo_="">
	<cfif isdefined("attributes.image_#i#") and len(evaluate("attributes.image_#i#"))>
			
				
			
					<cftry>
						<cffile
							action="UPLOAD" 
							filefield="image_#i#" 
							destination="#upload_folder#" 
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
					<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
					<cfset attributes.photo_ = '#file_name#.#cffile.serverfileext#'>
				</cfif>
					<cfif isDefined("attributes.image_var#i#") and len(evaluate("attributes.image_var#i#")) and not len(attributes.photo_)>
						<cfset attributes.photo_ = evaluate("attributes.image_var#i#")>
					</cfif>
	
					<cfset form_image=attributes.photo_>
	
	
<cfif attributes.supplier_page neq 'workmanship_plan'>
	<cfif isdefined("attributes.chk_proc#i#") and not len(evaluate("attributes.row_id#i#"))>
		<cfquery name="add_process" datasource="#dsn3#">
			INSERT INTO TEXTILE_SR_PROCESS
				   ([REQUEST_ID]
				   ,[DETAIL]
				   ,[IMAGE_PATH]
				   ,[PRICE]
				     <cfif isdefined("attributes.money#i#")>,MONEY</cfif>
				   ,STOCK_ID
				   ,PRODUCT_ID
				   ,PRODUCT_CATID
				   ,IS_ORJINAL
				   ,IS_STATUS
				   ,IS_REVISION
				   ,OPERATION_ID
				   )
			 VALUES
				   (
					#attributes.req_id#
					,<cfif isdefined("attributes.detail#i#") and len(evaluate("attributes.detail#i#"))>'#evaluate("attributes.detail#i#")#'<cfelse>NULL</cfif>
					,<cfif len(form_image)>'#form_image#'<cfelse>Null</cfif>
				   ,#filterNum(evaluate("attributes.price#i#"),textile_round)#
				   <cfif isdefined("attributes.money#i#")>,'#evaluate("attributes.money#i#")#'</cfif>
				   ,#evaluate("attributes.stock_id#i#")#
				   ,#evaluate("attributes.product_id#i#")#
				   ,#attributes.product_catid#
				   ,<cfif isdefined("attributes.chk_orj#i#")>1<cfelse>0</cfif>
				   ,<cfif isdefined("attributes.status#i#") and  len(evaluate("attributes.status#i#"))>#evaluate("attributes.status#i#")#<cfelse>0</cfif>
				   ,<cfif isdefined("attributes.revize#i#") and len(evaluate("attributes.revize#i#"))>#evaluate("attributes.revize#i#")#<cfelse>0</cfif>
				   ,<cfif IsDefined("attributes.operation#i#")>#evaluate("attributes.operation#i#")#<cfelse>NULL</cfif>
				   )
			
		</cfquery>
	<cfelseif isdefined("attributes.chk_proc#i#") and len(evaluate("attributes.row_id#i#"))>
		<cfquery name="upd_process" datasource="#dsn3#">
			update
				 TEXTILE_SR_PROCESS
			SET 
				[DETAIL]=<cfif isdefined("attributes.detail#i#") and len(evaluate("attributes.detail#i#"))>'#evaluate("attributes.detail#i#")#'<cfelse>NULL</cfif>,
				[IMAGE_PATH]=<cfif len(form_image)>'#form_image#'<cfelse>Null</cfif>,
					[PRICE]=#filterNum(evaluate("attributes.price#i#"),textile_round)#,
				<cfif isdefined("attributes.money#i#")>MONEY='#evaluate("attributes.money#i#")#',</cfif>
				STOCK_ID=#evaluate("attributes.stock_id#i#")#,
				PRODUCT_ID=#evaluate("attributes.product_id#i#")#,
				PRODUCT_CATID=#attributes.product_catid#,
				IS_ORJINAL=<cfif isdefined("attributes.chk_orj#i#")>1<cfelse>0</cfif>,
				IS_STATUS=<cfif isdefined("attributes.status#i#") and len(evaluate("attributes.status#i#"))>#evaluate("attributes.status#i#")#<cfelse>0</cfif>,
				IS_REVISION=<cfif isdefined("attributes.revize#i#") and len(evaluate("attributes.revize#i#"))>#evaluate("attributes.revize#i#")#<cfelse>0</cfif>,
				OPERATION_ID=<cfif IsDefined("attributes.operation#i#")>#evaluate("attributes.operation#i#")#<cfelse>NULL</cfif>
			WHERE
			[REQUEST_ID]=#attributes.req_id# AND 
			ID=#evaluate("attributes.row_id#i#")#
		</cfquery>
	</cfif>
<cfelse>
		<cfif  len(evaluate("attributes.row_id#i#"))>
			<cfquery name="upd_process" datasource="#dsn3#">
				update
					TEXTILE_SR_PROCESS
				SET 
					[DETAIL]=<cfif isdefined("attributes.detail#i#") and len(evaluate("attributes.detail#i#"))>'#evaluate("attributes.detail#i#")#'<cfelse>NULL</cfif>,
					[IMAGE_PATH]=<cfif len(form_image)>'#form_image#'<cfelse>Null</cfif>,
						[PRICE]=#filterNum(evaluate("attributes.price#i#"),textile_round)#,
					MONEY='#evaluate("attributes.money#i#")#',
					STOCK_ID=#evaluate("attributes.stock_id#i#")#,
					PRODUCT_ID=#evaluate("attributes.product_id#i#")#,
					PRODUCT_CATID=#attributes.product_catid#,
					IS_ORJINAL=<cfif isdefined("attributes.chk_orj#i#")>1<cfelse>0</cfif>
				WHERE
				[REQUEST_ID]=#attributes.req_id# AND 
				ID=#evaluate("attributes.row_id#i#")#
			</cfquery>
		</cfif>
</cfif>

</cfloop>

<script>
	<cfif attributes.supplier_page eq 'request_plan'><!---numune yonetiminden geliyor ise--->	
		window.location.href= '<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#attributes.req_id#&referal_page=#attributes.referal_page#</Cfoutput>';
	<cfelse>
		window.location.href= '<cfoutput>#request.self#?fuseaction=textile.workmanship_plan&event=upd&plan_id=#attributes.plan_id#</Cfoutput>';
	</cfif>
</script>
