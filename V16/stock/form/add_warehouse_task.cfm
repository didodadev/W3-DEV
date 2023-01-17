<cfif isdefined("attributes.task_id") and isdefined("attributes.action_type") and attributes.action_type is 'copy'>
	<cfinclude template="../query/copy_warehouse_task.cfm">
<cfelseif isdefined("attributes.is_submit")>
	<cfinclude template="../query/add_warehouse_task.cfm">
<cfelse>
	<cfparam name="attributes.task_in_out" default="0">
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfset attributes.company = get_par_info(attributes.company_id,-1,0,0)>
	</cfif>
	<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
		<cfset attributes.project_head = get_project_name(attributes.project_id)>
	<cfelse>
		<cfset attributes.project_head = "">
		<cfset attributes.project_id= "">
	</cfif>
		<cfset one_document_no = 0>
	<cfquery name="get_companies" datasource="#dsn#">
		SELECT 
			C.ASSET_FILE_NAME2,
			C.NICKNAME,
			C.COMPANY_ID 
		FROM 
			COMPANY C,
			#dsn3_alias#.WAREHOUSE_RATES WR
		WHERE 
			WR.COMPANY_ID IS NOT NULL AND
			C.COMPANY_ID = WR.COMPANY_ID AND
			C.COMPANY_STATUS = 1 AND
			(WR.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) OR WR.BRANCH_ID=0)
		ORDER BY 
			C.NICKNAME
	</cfquery>
	<cfif isdefined("session.ep.userid")><cf_catalystHeader></cfif>
	<cfform name="add_packet_ship_" id="add_packet_ship_" method="post" action="#request.self#?fuseaction=stock.list_warehouse_tasks&event=add" enctype="multipart/form-data">
	<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
	<input type="hidden" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>">
	<input type="hidden" name="task_in_out" id="task_in_out" value="<cfoutput>#attributes.task_in_out#</cfoutput>">
	<div class="row" id="uploadfileform" style="display:none;">
		<div class="col col-12 uniqueRow">
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="48364.Dosya Yükle"></label>
						<div class="col col-9 col-xs-12">
								<cfinput type="file" name="fileToUpload" id="fileToUpload" required="yes" message="#getlang('','Dosya Yükle','48364')#!">
						</div>
						<br/>
						<br/>
						<div class="form-group" id="item-process_cat">
							<label class="col col-3 col-xs-12"></label>
							<div class="col col-9 col-xs-12">
								<input type="submit" value="Upload Excel" name="submit">
							</div>
						</div>
					</div>					
				</div>
			</div>
			<div class="row formContent">
				<a href="/documents/sample_service_excel.xlsx"><cf_get_lang dictionary_id="63878.Örnek Dosyayı İndir"></a>
				<br/><br/>
			</div>
		</div>
	</div>
	</cfform>
	
	<cfif isdefined("attributes.fileToUpload") and len(attributes.fileToUpload)>
		<cfset upload_folder = "#upload_folder#reserve_files#dir_seperator#">
		<cftry>
			<cffile action="UPLOAD"
					filefield="fileToUpload"
					destination="#upload_folder#"
					mode="777"
					nameconflict="MAKEUNIQUE">
				<cfset file_name = createUUID()>
				<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
				<cfset attributes.fileToUpload = '#file_name#.#cffile.serverfileext#'>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfspreadsheet action="read" src="#upload_folder##file_name#.#cffile.serverfileext#" query="get_excel" />
		<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset last_box = "">
		<cfset not_found_product = 0>
		<cfset not_found_message = "">
		<cfset get_products = QueryNew('PRODUCT_ID,STOCK_ID,QUANTITY,UPPER_QUANTITY,BATCH_NO,BOX_CODE,UNIT_TYPE','varchar,varchar,varchar,varchar,varchar,varchar,varchar')>
		<cfset row_count = 0>
		<cfoutput query="get_excel" startrow="2">
			<cfif len(col_3)>
				<cfset p_code = col_3>
				<cfset batch_no = col_5>
				<cfif len(col_2)>
					<cfset last_box = col_2>
				</cfif>
				<cfset box_code = last_box>
				<cfset quantity = trim(listfirst(col_6,'x'))>
				<cfquery name="get_product" datasource="#dsn3#">
					SELECT * FROM STOCKS WHERE PRODUCT_CODE_2 = '#p_code#'
				</cfquery>
				<cfif not get_product.recordcount>
					<cfset not_found_product = not_found_product + 1>
					<cfset not_found_message = "#not_found_message# #p_code#"&getlang('','Sistemde Bulunamadı','63890')&"!">
				<cfelse>
					<cfif isnumeric(box_code) or not len(box_code)>
						<cfset row_count = row_count + 1>
						<cfset QueryAddRow(get_products,1)>
						<cfset up_quantity = quantity>
						<cfif len(col_7) and isnumeric(col_7)>
							<cfset up_quantity = col_7>
						</cfif>
						<cfset unit_type_ = "Piece">
						<cfif len(col_4)>
							<cfset unit_type_ = col_4>
						</cfif>
						<cfset QuerySetCell(get_products,"PRODUCT_ID","#get_product.product_id#",row_count)>
						<cfset QuerySetCell(get_products,"STOCK_ID","#get_product.STOCK_ID#",row_count)>
						<cfset QuerySetCell(get_products,"QUANTITY","#quantity#",row_count)>
						<cfset QuerySetCell(get_products,"UPPER_QUANTITY","#up_quantity#",row_count)>
						<cfset QuerySetCell(get_products,"BATCH_NO","#batch_no#",row_count)>
						<cfset QuerySetCell(get_products,"BOX_CODE","#box_code#",row_count)>
						<cfset QuerySetCell(get_products,"UNIT_TYPE","#unit_type_#",row_count)>
					<cfelse>
						<cfset baslangic_ = trim(listfirst(box_code,'to'))>
						<cfset bitis_ = trim(listlast(box_code,'to'))>
						<cfset total_q_ = quantity>
						<cfset q_ = int(total_q_ / (bitis_ - baslangic_ + 1))>
						<cfset b_code = bitis_ - baslangic_ + 1>
						<cfset unit_type_ = "Piece">
						<cfif len(col_4) and isnumeric(col_4)>
							<cfset unit_type_ = col_4>
						</cfif>
						<cfloop from="#baslangic_#" to="#bitis_#" index="b_code">
							<cfset row_count = row_count + 1>
							<cfset QueryAddRow(get_products,1)>
							<cfset QuerySetCell(get_products,"PRODUCT_ID","#get_product.product_id#",row_count)>
							<cfset QuerySetCell(get_products,"STOCK_ID","#get_product.STOCK_ID#",row_count)>
							<cfset QuerySetCell(get_products,"QUANTITY","#q_#",row_count)>
							<cfset QuerySetCell(get_products,"UPPER_QUANTITY","#q_#",row_count)>
							<cfset QuerySetCell(get_products,"BATCH_NO","#batch_no#",row_count)>
							<cfset QuerySetCell(get_products,"BOX_CODE","#b_code#",row_count)>
							<cfset QuerySetCell(get_products,"UNIT_TYPE","Piece",row_count)>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cfoutput>
		
		<cfif not_found_product gt 0>
			<div class="row">
				<div class="col col-12 uniqueRow">
					<cfoutput>#not_found_message#</cfoutput>
					<br>
					<b style="color:red;"><cf_get_lang dictionary_id ='63879.Lütfen Sistemdeki Ürün Kayıtlarını Açın'></b>					
				</div>
			</div>
		</cfif>
	</cfif>
	<cf_box>
	<cfform name="add_packet_ship" id="add_packet_ship" method="post" action="#request.self#?fuseaction=stock.list_warehouse_tasks&event=add_service">
		<input type="hidden" name="task_no" id="task_no" value=""> 
		<input type="hidden" name="is_submit" id="is_submit" value="1">	
		<cf_box_elements>	
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<cfif isdefined("session.ep.userid")>
							<div class="form-group" id="item-process_cat" style="display:none;">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
								<div class="col col-9 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
							</div>
							</cfif>
							<div class="form-group" id="item-task_in_out" style="display:none;">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
								<div class="col col-9 col-xs-12">
									<select name="task_in_out">
										<option value="0" <cfif attributes.task_in_out eq 0>selected</cfif>><cf_get_lang dictionary_id="63877.Receiving"></option>
										<option value="1" <cfif attributes.task_in_out eq 1>selected</cfif>><cf_get_lang dictionary_id="63876.Shipment"></option>
										<option value="2" <cfif attributes.task_in_out eq 2>selected</cfif>><cf_get_lang dictionary_id="63874.Sayım Sonucu"></option>
										<option value="3" <cfif attributes.task_in_out eq 3>selected</cfif>><cf_get_lang dictionary_id="63875.Sayım"></option>
									</select>
								</div>
							</div>
								<div class="form-group" id="item-company">
									<label class="col col-12 col-xs-12">
										<b>
										<cfif attributes.task_in_out eq 1>
											<cf_get_lang dictionary_id="63876.Shipment">
										<cfelseif attributes.task_in_out eq 2>
											<cf_get_lang dictionary_id="63874.Sayım Sonucu">
										<cfelseif attributes.task_in_out eq 3>
											<cf_get_lang dictionary_id="63875.Sayım">
										<cfelse>
											<cf_get_lang dictionary_id="63877.Receiving">
										</cfif>
										</b>
									</label>
								</div>
							<div class="form-group" id="item-companies">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57519.Cari Hesap"></label>
								<div class="col col-9 col-xs-12">
									<select onchange="create_service();" id="company_id" name="company_id">
										<cfoutput query="get_companies">
											<option value="#company_id#">#NICKNAME#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item_project_head">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57416.Proje"></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" >
										<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');"  autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"></span>
									</div>
								</div>
							</div>
							<cfif isdefined("session.ep.userid")>
							<div class="form-group" id="item-location_id">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58763.Depo"> *</label>
								<div class="col col-9 col-xs-12">
										<cf_wrkdepartmentlocation
											returnInputValue="location_id,department_name,department_id,branch_id"
											returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldName="department_name"
											fieldid="location_id"
											department_fldId="department_id"
											branch_fldId="branch_id"
											user_level_control="#session.ep.our_company_info.is_location_follow#"
											width="150">
								</div>
							</div>
							</cfif>
							<div class="form-group" id="item-action_date">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57742.Tarih"></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id="57742.Tarih"> !</cfsavecontent>
										<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
										<cfoutput>
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
										</cfoutput>
									</div>
								</div>
							</div>
							<cfif isdefined("session.ep.userid")>
							<div class="form-group" id="item-employee_id">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
										<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly style="width:150px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=employee_id&field_name=employee_name&select_list=1','list');"></span>
									</div>
								</div>
							</div>
							</cfif>
							<cfif attributes.task_in_out eq 3>
							<div class="form-group" id="item-container">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63871.Sayım Tipi"></label>
								<div class="col col-9 col-xs-12">
										<select name="count_type" style="width:150px;">
											<option value="0"><cf_get_lang dictionary_id="63880.All Items"> </option>
											<option value="1"><cf_get_lang dictionary_id="63881.Selected Items"></option>
											<option value="2"><cf_get_lang dictionary_id="63882.Add Items to Inventory"></option>
											<option value="3"><cf_get_lang dictionary_id="63883.Label Only"></option>
										</select>
								</div>
							</div>
							</cfif>
							<div class="form-group" id="item-container" style="<cfif attributes.task_in_out eq 1>display:none;</cfif>">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='63850.Konteyner'></label>
								<div class="col col-9 col-xs-12">
										<cfinput type="text" name="container" id="container" value="" style="width:150px;"/>
								</div>
							</div>
							<div class="form-group" id="item-bl_number" style="<cfif attributes.task_in_out eq 0>display:none;</cfif>">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='63851.B/L No'></label>
								<div class="col col-9 col-xs-12">
										<cfinput type="text" name="bl_number" id="bl_number" value="" style="width:150px;"/>
								</div>
							</div>
							<div class="form-group" id="item-employee_id">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57422.Notlar"></label>
								<div class="col col-9 col-xs-12">
										<cftextarea type="text" name="detail" id="detail" value="" style="width:150px;" rows="3"/>
								</div>
							</div>
							<cfif attributes.task_in_out eq 1>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57716.Taşıyıcı"></label>
									<div class="col col-9 col-xs-12">
											<cfinput type="text" name="CARRIER_NAME" id="CARRIER_NAME" value="" style="width:150px;"/>
									</div>
								</div>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63861.Özel Talimatlar"></label>
									<div class="col col-9 col-xs-12">
											<cfinput type="text" name="SPECIAL_INS" id="SPECIAL_INS" value="" style="width:150px;"/>
									</div>
								</div>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63862.Navlun Ücreti Şartları"></label>
									<div class="col col-3 col-xs-12">
											<label><cf_get_lang dictionary_id="63863.Ön Ödemeli"> <input type="radio" value="1" name="FREIGHT"></label>
										</div><div class="col col-3 col-xs-12">
											<label><cf_get_lang dictionary_id="63864.Ödemeli"> <input type="radio" value="2" name="FREIGHT"></label>
										</div><div class="col col-3 col-xs-12">
											<label><cf_get_lang dictionary_id="63865.3. Şahıs"> <input type="radio" value="3" name="FREIGHT"></label>
									</div>
								</div>
							</cfif>
							<cfif one_document_no eq 1>
								<input type="hidden" name="document_count" value="1">
								<div class="form-group" id="item-document-no">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="40830.Satınalma Siparişi"><cf_get_lang dictionary_id="44867.Numarası"></label>
									<div class="col col-9 col-xs-12">										
											<input type="text" name="document_no_1" value="" style="width:150px;">
									</div>
								</div>
							</cfif>
						</div>
						<cfif attributes.task_in_out eq 1>
						<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true">							
							<div class="form-group" id="item-company">
								<label class="col col-12 col-xs-12">
									<b><cf_get_lang dictionary_id="63872.Gönderici Bilgileri"></b>
								</label>
							</div>
							<div id="cargo_sender_information">							
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
									<div class="col col-8 col-xs-12">									
											<input type="text" name="CARGO_MYCOMPANY"  style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="44592.İsim"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYNAME"  style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58723.Adres"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYADDRESS"  style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57499.Telefon"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYPHONE"  style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57472.Posta Kodu"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYPOSTCODE"  style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52661.Şehir"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYCOUNTY"  style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="44806.Devlet"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYCITY"  style="width:150px;">
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3">
							<div class="form-group" id="item-company">
								<label class="col col-12 col-xs-12">
									<b><cf_get_lang dictionary_id="63873.Alıcı Bilgileri"></b>
								</label>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63891.Sold To"></label>
								<div class="col col-8 col-xs-12">										
										<input type="text" name="CARGO_SHIP_RELATED_NUMBER" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63892.Sold To Zipcode"></label>
								<div class="col col-8 col-xs-12">											
										<input type="text" name="CARGO_SHIP_RELATED_POSTCODE" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-ship">
								<label class="col col-12 col-xs-12">
									<b><cf_get_lang dictionary_id="63991.Gönderim Bilgileri"></b>
								</label>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63893.Ship To"></label>
								<div class="col col-8 col-xs-12">										
										<input type="text" name="CARGO_SHIP_COMPANY" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63894.Ship To Attention"></label>
								<div class="col col-8 col-xs-12">							
										<input type="text" name="CARGO_SHIP_NAME" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63895.Ship To Address"></label>
								<div class="col col-8 col-xs-12">							
										<input type="text" name="CARGO_SHIP_ADDRESS" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63896.Ship To Phone"></label>
								<div class="col col-8 col-xs-12">						
										<input type="text" name="CARGO_SHIP_PHONE" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63897.Ship To PostCode"> </label>
								<div class="col col-8 col-xs-12">								
										<input type="text" name="CARGO_SHIP_POSTCODE" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63898.Ship To City"> </label>
								<div class="col col-8 col-xs-12">						
										<input type="text" name="CARGO_SHIP_COUNTY" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63899.Ship To State"> </label>
								<div class="col col-8 col-xs-12">							
										<input type="text" name="CARGO_SHIP_CITY" value="" style="width:150px;">
								</div>
							</div>
						</div>
						</cfif>
						<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="3" sort="true" id="SERVICE_PLACE">
						</div>
					</cf_box_elements>	
					<cf_seperator title="#getlang('','ITEMS','63900')#" id="items" is_closed="0">
						<div id="items">
						<cfif isdefined("get_products.recordcount") and get_products.recordcount gt 0>
							<cfset p_count = get_products.recordcount + 5>
						<cfelseif attributes.task_in_out eq 1>
							<cfset p_count = 15>
						<cfelse>
							<cfset p_count = 15>
						</cfif>
						<cfif one_document_no eq 0><cfinput type="hidden" name="document_count" value="#p_count#"></cfif>
						<cfinput type="hidden" name="product_count" value="#p_count#">
						<cf_grid_list>
						<thead>
							<tr>
								<cfif one_document_no eq 0><th width="200"><cf_get_lang dictionary_id="40830.Satınalma Siparişi"><cf_get_lang dictionary_id="44867.Numarası"></th></cfif>
								<th width="150"><cf_get_lang dictionary_id="57657.Ürün"></th>
								<th width="50"><cf_get_lang dictionary_id="57635.Miktar"></th>
								<th width="50">
									<cfif session.ep.language eq 'tr'>
									<cf_get_lang dictionary_id="37244.Palet">/<cf_get_lang dictionary_id="48312.Koli"><br>
									<cf_get_lang dictionary_id="63866.Başına"><cf_get_lang dictionary_id="57635.Miktar"> 
									<cfelse>
										<cf_get_lang dictionary_id="57635.Miktar"> 
											<cf_get_lang dictionary_id="63866.Başına"> 
										<br><cf_get_lang dictionary_id="37244.Palet">/<cf_get_lang dictionary_id="48312.Koli">
									</cfif>
								</th>
								<th width="50"><cf_get_lang dictionary_id="57492.Toplam"> <br><cf_get_lang dictionary_id="37244.Palet">/<cf_get_lang dictionary_id="48312.Koli"></th>
								<th width="60"></th>
								<th width="80"><cf_get_lang dictionary_id="48383.Ebat"></th>
								<th width="80"><cf_get_lang dictionary_id="63867.Koli Tipi"></th>
								<th width="50"><cf_get_lang dictionary_id="58585.Kod"></th>
								<th width="50"><cf_get_lang dictionary_id="29784.Ağırlık"></th>
								<th width="75"><cf_get_lang dictionary_id="63868.Boyut"></th>
								<th width="50"><cf_get_lang dictionary_id="63869.Batch No"></th>
								<th></th>
							</tr>
						</thead>
						<cfloop from="1" to="#p_count#" index="aa">
						<cfif isdefined("get_products.recordcount") and get_products.recordcount gte aa>
							<cfset product_id_ = "#get_products.product_id[aa]#-#get_products.stock_id[aa]#-1">
							<cfset product_amount_ = "#get_products.QUANTITY[aa]#">
							<cfset pallet_amount_ = "#get_products.UPPER_QUANTITY[aa]#">
							<cfset total_pallet_ = get_products.QUANTITY[aa] / get_products.UPPER_QUANTITY[aa]>
							<cfset total_unit_type_ = "#get_products.UNIT_TYPE[aa]#">
							<cfset pallet_code_ = "#get_products.BOX_CODE[aa]#">
							<cfset product_info_ = "#get_products.BATCH_NO[aa]#">
						<cfelse>
							<cfset product_id_ = "">
							<cfset product_amount_ = "">
							<cfset pallet_amount_ = "">
							<cfset total_pallet_ = "">
							<cfset total_unit_type_ = "">
							<cfset pallet_code_ = "">
							<cfset product_info_ = "">
						</cfif>
						<cfoutput>
							<tr>
								<cfif one_document_no eq 0><td><input type="text" name="document_no_#aa#" value="" style="width:200px;"></td></cfif>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="product_id_#aa#"  id="product_id_#aa#">
											<input type="text" readonly name="urun_#aa#"  id="urun_#aa#">
											<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac(#aa#);"></span>
										</div>
									</div>		

								
								</td>
								<td><cfinput type="text" name="product_amount_#aa#" value="#product_amount_#" style="width:50px" onkeyup="return(FormatCurrency(this,event,0,'float'));" onblur="hesapla_pallet('#aa#');"></td>
								<td><cfinput type="text" name="pallet_amount_#aa#" value="#pallet_amount_#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0,'float'));" onblur="hesapla_pallet('#aa#');"></td>
								<td><cfinput type="text" name="total_pallet_#aa#" value="#total_pallet_#" readonly="yes" style="width:50px;"></td>
								<td>
									<div class="form-group">
									<select name="total_unit_type_#aa#" id="unit_type_#aa#">
										<option value="Pallet" <cfif total_unit_type_ is 'Pallet'>selected</cfif>><cf_get_lang dictionary_id="37244.Palet"></option>
										<option value="Box" <cfif total_unit_type_ is 'Box'>selected</cfif>><cf_get_lang dictionary_id="48312.Koli"></option>
										<option value="Piece" <cfif total_unit_type_ is 'Piece'>selected</cfif>><cf_get_lang dictionary_id="45.Parça"></option>
										<option value="Roll" <cfif total_unit_type_ is 'Roll'>selected</cfif>><cf_get_lang dictionary_id="63870.Rulo"></option>
									</select>
								</div>
								</td>
								<td>	
									<div class="form-group">
									<select name="size_style_#aa#" id="size_style_#aa#">
										<option value="1"><cf_get_lang dictionary_id="56109.Standart"></option>
										<option value="2"><cf_get_lang dictionary_id="63856.Büyük Boy"></option>
									</select>	
								</div>
								</td>
								<td>
									<div class="form-group">
									<select name="box_style_#aa#" id="box_style_#aa#">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<option value="1"><cf_get_lang dictionary_id="63884.OverBox"></option>
										<option value="2"><cf_get_lang dictionary_id="63885.ImageBox"></option>
									</select>	
								</div>
								</td>
								<td><cfinput type="text" name="pallet_code_#aa#" value="#pallet_code_#" style="width:50px;"></td>
								<td><cfinput type="text" name="weight_#aa#" value="" style="width:50px;"></td>
								<td><cfinput type="text" name="dimension_#aa#" value="" style="width:75px;"></td>
								<td><cfinput type="text" name="product_info_#aa#" value="#product_info_#" style="width:100px;"></td>
								<td></td>
							</tr>
						</cfoutput>
						</cfloop>
						</cf_grid_list>
					</div>
					<cf_box_footer>
							<cf_workcube_buttons is_upd='0'  add_function='control()'>
					</cf_box_footer>
	</cfform>
</cf_box>
	<script type="text/javascript">
		function control()
		{
			return true;
		}
		
		function set_pallet(row)
		{
			deger_ = list_getat(document.getElementById('product_id_' + row).value,3,'-');
			document.getElementById('pallet_amount_' + row).value = deger_;
			
			/* if(deger_ != '')
			{
				product_id_ = list_getat(document.getElementById('product_id_' + row).value,1,'-');
				p_info_	= wrk_safe_query('get_p_dimensions','dsn3',1,product_id_);
				
				if(p_info_.WEIGHT != '')
					document.getElementById('weight_' + row).value = wrk_round(p_info_.WEIGHT);
				else
					document.getElementById('weight_' + row).value = '';
					
				if(p_info_.DIMENTION != '')
				{
					document.getElementById('dimension_' + row).value = p_info_.DIMENTION;
				}
				else
				{
					document.getElementById('dimension_' + row).value = '';
				}
			}
			else
			{
				document.getElementById('weight_' + row).value = '';
				document.getElementById('dimension_' + row).value = '';
			} */
			
			document.getElementById('weight_' + row).value = '';
				document.getElementById('dimension_' + row).value = '';
		}
		
		function hesapla_pallet(row)
		{	
			if(document.getElementById('product_id_' + row).value != '')
			{
				g_p_deger_ = list_getat(document.getElementById('product_id_' + row).value,3,'-');
				
				deger_ = filterNum(document.getElementById('product_amount_' + row).value);
				p_deger_ = filterNum(document.getElementById('pallet_amount_' + row).value);
				
				if(deger_ == '')
				{
					document.getElementById('pallet_amount_' + row).value = '';
					document.getElementById('total_pallet_' + row).value = '';
				}
				else if(deger_ != '' && p_deger_ == '')
				{
					document.getElementById('pallet_amount_' + row).value = commaSplit(g_p_deger_,0);
					document.getElementById('total_pallet_' + row).value = commaSplit(Math.ceil(deger_ / g_p_deger_),0);
				}
				else
				{
					document.getElementById('total_pallet_' + row).value = commaSplit(Math.ceil(deger_ / p_deger_),0);
					if(parseFloat(deger_) > 0 && parseFloat(deger_) < parseFloat(p_deger_))
					{
						document.getElementById('pallet_amount_' + row).value = commaSplit(deger_,0);
						document.getElementById('total_pallet_' + row).value = 1;
					}
				}
			}
			else
			{
				document.getElementById('pallet_amount_' + row).value = '';
				document.getElementById('total_pallet_' + row).value = '';
				document.getElementById('product_amount_' + row).value = '';
				
				document.getElementById('product_id_' + row).focus();
			}
		}
		function pencere_ac(no)
			{
				if($("#company_id :selected").val() != '')
				openBoxDraggable("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&3pl=1&rows="+no+"&company_id="+$("#company_id :selected").val()+"&product_id=add_packet_ship.product_id_"+no+"&field_name=add_packet_ship.urun_"+no);
				else
				alert("<cf_get_lang dictionary_id='33557.Cari Hesap Seçmelisiniz'>!");
			}

		function UploadFromFile()
		{
			show_hide('uploadfileform');
		}
		
		create_service();
		function create_service()
		{
		var send_address = "<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=get_services&company_id=</cfoutput>"+$("#company_id :selected").val()+"<cfoutput>&task_in_out=#attributes.task_in_out#</cfoutput>";
			AjaxPageLoad(send_address,'SERVICE_PLACE',1,'İlişkili Departmanlar');
		}
	</script>
</cfif>