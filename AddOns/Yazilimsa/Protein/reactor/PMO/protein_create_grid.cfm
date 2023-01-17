<!--- 
Description :
Grid yapısını oluşturur widgetletı gridlere doldurur, BODY_DESIGN.GRID ve INSIDE_DESIGN.GRID değişkenleri application onRequest'te set edilir.
Parameters :
container_class ==> grid yapısını kapsayan class etiketi
container_style ==> container özel css style
row_class ==> row class
row_style ==> row özel css style
col_class ==> col class col sıze önüne gelir ÖR: col-8
col_style ==> col özel css style
Syntax : <cfinclude template = "/PMO/protein_create_grid.cfm">
Created :   SA20200705
--->
<cfparam name="attributes.container_class" type="string" default="container">
<cfparam name="attributes.containiner_style" type="string" default="">
<cfparam name="attributes.row_class" type="string" default="row">
<cfparam name="attributes.row_style" type="string" default="">
<cfparam name="attributes.col_class" type="string" default="col">
<cfparam name="attributes.col_style" type="string" default="">
<cfparam name="attributes.col_style2" type="string" default="">
<cfparam name="attributes.fuseaction" type="string" default="">
<cfscript>
	StructAppend(attributes,form,true);
	StructAppend(attributes,url,true);
</cfscript>
<cffunction name="renderColJustify" returntype="any">
	<cfargument  name="justify" default="0">	
	<cfswitch expression="#justify#">
		<cfcase value="1">
			<cfset justifyContent = "justify-content-center">
		</cfcase>
		<cfcase value="2">
			<cfset justifyContent = "justify-content-start">
		</cfcase>
		<cfcase value="3">
			<cfset justifyContent = "justify-content-end">
		</cfcase>
		<cfdefaultcase>
			<cfset justifyContent = "normal">
		</cfdefaultcase>
	</cfswitch>
	<cfreturn justifyContent>
</cffunction>
<cfoutput> 
	<main role="main" class="#attributes.container_class#" style="#attributes.containiner_style#"><!--- ~ THEME LAYOUT.CFM'DE SET EDİLİR ~ --->
		<div id="working_div_main"></div>
		<cfif GET_PAGE_DENIED.recordcount eq 0 OR GET_PAGE_DENIED.IS_VIEW eq 1>
			<cfloop array="#BODY_DESIGN.GRID#" item="ROW">
				<!--- Dynamic Content Layout --->
				<div class="#attributes.row_class#" style="#attributes.row_style#">
				<cfloop array="#ROW.COLS#" item="COL">
					<div class="#attributes.col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.col_style2#">
					<cfloop array="#COL.WIDGET#" item="WIDGET">
						<cfif WIDGET.ID EQ 0>
							<!--- Dynamic Content Template --->
							<cfloop array="#INSIDE_DESIGN.GRID#" item="ROW">
								<div class="#attributes.row_class#" style="#attributes.row_style#">
								<cfloop array="#ROW.COLS#" item="COL">
									<div class="#attributes.col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.col_style2#">
									<cfloop array="#COL.WIDGET#" item="WIDGET">
										<cfset GET_WIDGET = deserializeJSON(MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:GET_SITE.SITE_ID))>
										<cfif GET_WIDGET.STATUS EQ true AND WIDGET.ID NEQ -1>										
											<cftry>
												<cfset new_attr = deserializeJSON(GET_WIDGET.DATA[1].WIDGET_DATA)>												 
												<cfscript>
													StructAppend(attributes,new_attr,true);
												</cfscript>	
												<cfcatch type="any">
												</cfcatch>
											</cftry>
											<cfif IsJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND)>
												<cfset GET_EXTEND = deserializeJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND)>
											<cfelse>
												<cfset GET_EXTEND = "">
											</cfif>
											<cfif IsJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND.CSS)>
												<style>#GET_EXTEND.CSS#</style>
											</cfif>
											<div id="protein_widget_#WIDGET.ID#"><!--- ? Template'ta set edilen widgetlar --->	
												<cftry>	
													<cfsavecontent  variable="create_widget">																																	
														<cfif IsJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND) AND isDefined(GET_EXTEND.BEFORE) AND len(GET_EXTEND.BEFORE)>
															<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
														</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
														<script>console.log("DCT :#GET_WIDGET.DATA[1].WIDGET_FILE_PATH#");</script>
														<cfset widget_box_data = len(GET_WIDGET.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET.DATA[1].WIDGET_BOX_DATA) : ''>
														<!--- ^ BOX LOAD == 0 ise box olmadan yüklenir --->
														<cfif IsStruct(widget_box_data) AND StructKeyExists(widget_box_data, "box_load") AND len(widget_box_data.box_load) AND widget_box_data.box_load EQ 1>
															<cf_box 
																title="#IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''#"
																class="#IsStruct(widget_box_data) && len(widget_box_data.class) ? widget_box_data.class : ''#"
																id = "#WIDGET.ID#"
															>
																<cfinclude template="/catalyst/#GET_WIDGET.DATA[1].WIDGET_FILE_PATH#">
															</cf_box>																				
														<cfelse>
															<cfinclude template="/catalyst/#GET_WIDGET.DATA[1].WIDGET_FILE_PATH#">
														</cfif>
														<cfif IsJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND) AND  isDefined(GET_EXTEND.AFTER) AND len(GET_EXTEND.AFTER)>
															<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
														</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
													</cfsavecontent>	
													#create_widget#
													<cfcatch>
														<div style="display: flex;justify-content: center;flex-direction: column;align-items: center;padding: 10px;border: 4px dashed ##ffcc80;">
															<i class="fas fa-tools" title="Template" style="font-size: 40px;color: ##ffc107;margin-bottom: 10px;"></i>
															<p style="text-align: center;font-weight: 500;color: ##424242;">
															Bu Box'ta Çalışma Var, verdiğimiz rahatsızlıktan dolayı özür dileriz...
															</p>															
														</div>
														<div style="display:none;">
															<cfdump  var="#GET_WIDGET#" label="GET_WIDGET_DCP">
															<cfdump  var="#new_attr#" label="widget_attr">
															<cfdump  var="#cfcatch#" label="cfcatch">
														</div>
													</cfcatch>
												</cftry>
											</div>
										<cfelse>
											<!--- Dynamic Content Page --->
											<cfloop array="#PAGE_DATA.GRID#" item="ROW">
												<section class="<cfif StructKeyExists(ROW, "ROW_PARAMS")>#ROW.ROW_PARAMS.container#</cfif>">
													<div class="#attributes.row_class# <cfif StructKeyExists(ROW, "ROW_PARAMS")>#renderColJustify(ROW.ROW_PARAMS.col_justify)#</cfif>" style="#attributes.row_style#">
														<cfloop array="#ROW.COLS#" item="COL">
															<div class="#attributes.col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.col_style#">
																<cfloop array="#COL.WIDGET#" item="WIDGET">
																	<cfset GET_WIDGET_DCP = deserializeJSON(MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:GET_SITE.SITE_ID))>
																	<cfif GET_WIDGET_DCP.STATUS EQ true AND ArrayLen(GET_WIDGET_DCP.DATA)>
																		<cftry>
																			<cfset new_attr = deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_DATA)>
																			<cfscript>
																				StructAppend(attributes,new_attr,true);
																			</cfscript>
																			<cfcatch type="any">	
																			</cfcatch>
																		</cftry>
																		<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND)>
																			<cfset GET_EXTEND_DCP = deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND)>
																		<cfelse>
																			<cfset GET_EXTEND_DCP = "">
																		</cfif>
																		<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCP.CSS)>
																			<style>#GET_EXTEND_DCP.CSS#</style>
																		</cfif>
																		<cfif StructKeyExists(session, "ADMIN_PASSWORD") AND  session.ADMIN_PASSWORD EQ PRIMARY_DATA.MAINTENANCE_PASSWORD>
																			<style>
																				span##protein-admin-mode-widget-config-button_#WIDGET.ID#:hover ~ div##protein_widget_#WIDGET.ID# {
																					border: 2px dotted ##03A9F4;
																					margin: -2px -2px 0px -2px;
																				}
																			</style>
																			<span class="protein-admin-mode-widget-config-button" id="protein-admin-mode-widget-config-button_#WIDGET.ID#" style=" "> 
																				<a href="http://#application.systemParam.employee_url#/index.cfm?fuseaction=protein.widgets&event=upd&widget=#WIDGET.ID#&site=#GET_SITE.SITE_ID#" target="_blank"> 
																					<span class="protein-admin-item-icon fa fa-cog"></span>
																				</a>
																			</span>
																			<cfset adminmode="true">
																		<cfelse>
																			<cfset adminmode="false">
																		</cfif>
																		<div id="protein_widget_#WIDGET.ID#" class="protein-widget-container-no-style"><!--- ? Page'te set edilen widgetlar --->
																			<cftry>	
																				<cfset widget_live = "live">
																				<cfsavecontent  variable="create_widget">																																						
																					<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_SEO_DATA) AND len(deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_SEO_DATA).SCHEMA_ORG)>
																						<cfset SCHEMA_TYPE =  (len(deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_SEO_DATA).SCHEMA_ORG)?deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_SEO_DATA).SCHEMA_ORG:"protein")>
																					<cfelse>
																						<cfset SCHEMA_TYPE = "protein">
																					</cfif>
																					<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCP.BEFORE)>
																						<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
																					</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
																					<script>console.log("#GET_WIDGET_DCP.DATA[1].WIDGET_FILE_PATH#");</script>
																					<cfset widget_box_data = len(GET_WIDGET_DCP.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_BOX_DATA) : ''>
																					<!--- ^ BOX LOAD == 0 ise box olmadan yüklenir --->
																					<cfif IsStruct(widget_box_data) AND StructKeyExists(widget_box_data, "box_load") AND len(widget_box_data.box_load) AND widget_box_data.box_load EQ 1>
																						
																						<cfset widget_title = IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''>
																						<cfif structKeyExists(widget_box_data, "box_title_from_widget_title")>
																							<cfset widget_title =  widget_box_data.box_title_from_widget_title eq 1 ? GET_WIDGET_DCP.DATA[1].TITLE:widget_title>
																						</cfif>																						
																						
																						<cf_box 
																							title="#len(widget_title) ? widget_title : ''#"
																							class="#IsStruct(widget_box_data) && len(widget_box_data.class) ? widget_box_data.class : ''#"
																							id = "#WIDGET.ID#"
																						>
																							<cfif GET_WIDGET_DCP.DATA[1].WIDGET_NAME neq "-2">
																								<cfinclude template="/catalyst/#GET_WIDGET_DCP.DATA[1].WIDGET_FILE_PATH#">
																							<cfelse>
																								<cfset GET_WIDGET_DCP_DESIGN_BLOCK = MAIN.GET_DESIGN_BLOCK(WIDGET:WIDGET.ID)>												
																								<cftry>
																									<cfset DESIGN_BLOCK_CONTENT = deserializeJSON(GET_WIDGET_DCP_DESIGN_BLOCK)>
																									#evaluate("DESIGN_BLOCK_CONTENT.design_block_#session_base.language#")#
																									<cfcatch type="any">
																										#GET_WIDGET_DCP_DESIGN_BLOCK#
																									</cfcatch>																									
																								</cftry>
																							</cfif>																							
																						</cf_box>																				
																					<cfelse>
																						<cfif GET_WIDGET_DCP.DATA[1].WIDGET_NAME neq "-2">
																							<cfinclude template="/catalyst/#GET_WIDGET_DCP.DATA[1].WIDGET_FILE_PATH#">
																						<cfelse>
																							<cfset GET_WIDGET_DCP_DESIGN_BLOCK = MAIN.GET_DESIGN_BLOCK(WIDGET:WIDGET.ID)>													
																								<cftry>
																									<cfset DESIGN_BLOCK_CONTENT = deserializeJSON(GET_WIDGET_DCP_DESIGN_BLOCK)>
																									#evaluate("DESIGN_BLOCK_CONTENT.design_block_#session_base.language#")#
																									<cfcatch type="any">
																										#GET_WIDGET_DCP_DESIGN_BLOCK#
																									</cfcatch>																									
																								</cftry>
																						</cfif>
																					</cfif>
																					<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCP.AFTER)>
																						<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
																					</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
																				</cfsavecontent>
																				<cfif widget_live eq "live">																					
																					#create_widget#
																				</cfif>
																				<cfcatch>
																					<div style="display: flex;justify-content: center;flex-direction: column;align-items: center;padding: 10px;border: 4px dashed ##ffcc80;">
																						<i class="fas fa-tools" title="Page" style="font-size: 40px;color: ##ffc107;margin-bottom: 10px;"></i>
																						<p style="text-align: center;font-weight: 500;color: ##424242;">
																						Bu Box'ta Çalışma Var, verdiğimiz rahatsızlıktan dolayı özür dileriz...
																						</p>
																						<div style='display:#((adminmode eq "true")?"block":"none")#;'>
																							<cfdump  var="#GET_WIDGET_DCP#" label="GET_WIDGET_DCP">
																							<cfdump  var="#new_attr#" label="widget_attr">
																							<cfdump  var="#cfcatch#" label="cfcatch">
																						</div>
																					</div>	
																				</cfcatch>
																			</cftry>
																		</div>
																	</cfif>
																</cfloop>
															</div>
														</cfloop>
													</div>
												</section>
											</cfloop>
										</cfif>
									</cfloop>
									</div>
								</cfloop>
								</div>
							</cfloop>
						<cfelse>
							<cfset GET_WIDGET_DCL = deserializeJSON(MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:GET_SITE.SITE_ID))>
							<cftry>
								<cfset new_attr = deserializeJSON(GET_WIDGET.DATA[1].WIDGET_DATA)>
								<cfscript>
									StructAppend(attributes,new_attr,true);
								</cfscript>	
								<cfcatch type="any">
								</cfcatch>
							</cftry>
							<cfif IsJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND)>
								<cfset GET_EXTEND_DCL = deserializeJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND)>
							<cfelse>
								<cfset GET_EXTEND_DCL = "">
							</cfif>							
							<cfif IsJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCL.CSS)>
								<style>#GET_EXTEND_DCL.CSS#</style>
							</cfif>
							<div id="protein_widget_#WIDGET.ID#"><!--- ? Layout'ta set edilen widgetlar --->
								<cftry>
									<cfsavecontent  variable="create_widget">															
										<cfif IsJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCL.BEFORE)>
											<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
										</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
										<script>console.log("DCL :#GET_WIDGET_DCL.DATA[1].WIDGET_FILE_PATH#");</script>
										<cfset widget_box_data = len(GET_WIDGET_DCL.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET_DCL.DATA[1].WIDGET_BOX_DATA) : ''>
										<cf_box title="#IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''#" id = "#WIDGET.ID#">	
											<cfinclude template="/catalyst/#GET_WIDGET_DCL.DATA[1].WIDGET_FILE_PATH#">	
										</cf_box>						
										<cfif IsJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCL.AFTER)>
											<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
										</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
									</cfsavecontent>
									#create_widget#	
									<cfcatch>
										<div style="display: flex;justify-content: center;flex-direction: column;align-items: center;padding: 10px;border: 4px dashed ##ffcc80;">
											<i class="fas fa-tools" title="Layout" style="font-size: 40px;color: ##ffc107;margin-bottom: 10px;"></i>
											<p style="text-align: center;font-weight: 500;color: ##424242;">
											Bu Box'ta Çalışma Var, verdiğimiz rahatsızlıktan dolayı özür dileriz...
											</p>											
										</div>
										<div style="display:none;">
											<cfdump  var="#GET_WIDGET_DCL#" label="GET_WIDGET_DCP">
											<cfdump  var="#new_attr#" label="widget_attr">
											<cfdump  var="#cfcatch#" label="cfcatch">
										</div>										
									</cfcatch>
								</cftry>
							</div>
						</cfif>                  
					</cfloop>
					</div>
				</cfloop>
				</div>
			</cfloop>
		<cfelse>				
			<cfinclude template="/themes/shared_template/denied_page.cfm">
		</cfif> 
	</main>
</cfoutput> 