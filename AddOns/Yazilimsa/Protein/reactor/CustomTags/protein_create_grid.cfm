<!--- 
Description :
Grid yapısını oluşturur widgetletı gridlere doldurur, BODY_DESIGN.GRID ve INSIDE_DESIGN.GRID değişkenleri application onRequest'te set edilir.
Syntax : 
<cf_protein_create_grid container_class="container-fluid" row_class="row" col_class="col"> 
Parameters :
container_class ==> grid yapısını kapsayan class etiketi
container_style ==> container özel css style
row_class ==> row class
row_style ==> row özel css style
col_class ==> col class col sıze önüne gelir ÖR: col-8
col_style ==> col özel css style
Created :   SA20200705
--->
<cfparam name="attributes.container_class" type="string" default="container">
<cfparam name="attributes.containiner_style" type="string" default="">
<cfparam name="attributes.row_class" type="string" default="row">
<cfparam name="attributes.row_style" type="string" default="">
<cfparam name="attributes.col_class" type="string" default="col">
<cfparam name="attributes.col_style" type="string" default="">
<cfparam name="attributes.fuseaction" type="string" default="">

<!--- <cfif not isdefined("session_base")>
	<cfif isdefined("session.pp")>
		<cfset session_base = session.pp>
	<cfelseif isdefined("session.ww")>
		<cfset session_base = session.ww>
	<cfelseif isdfefined("session.cp")>
		<cfset session_base = session.cp>
	</cfif>
</cfif>
<cfset session_base.our_company_id = #Caller.GET_SITE.COMPANY#>
<cfset request = StructNew()>
<cfset request.self = "">
<cfset dsn = application.systemParam.systemParam().dsn>,
<cfset dsn1 = "#dsn#_product">
<cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
<cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />

--->
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn1_alias = "#dsn#_product">
<cfset dsn_alias = '#dsn#'>
<cfset dsn2 = dsn2_alias = '#dsn#_#caller.session_base.period_year#_#caller.session_base.OUR_COMPANY_ID#' />
<cfset dsn3 = dsn3_alias = '#dsn#_#caller.session_base.OUR_COMPANY_ID#' />
<cfset session_base = caller.session_base>
<cfset IS_ONLY_SHOW_PAGE = 0>
<cfset WORKCUBE_MODE  = 0>
<cfset use_https  = 0>

<cfscript>
	StructAppend(attributes,form,true);
	StructAppend(attributes,url,true);
</cfscript>
<cfinclude template="../cfc/functions.cfc">
<cfset request.self = "">

<cfoutput> 
	<main role="main" class="#attributes.container_class#" style="#attributes.containiner_style#"> 
		<div id="working_div_main"></div>
		<cfif caller.GET_PAGE_DENIED.recordcount eq 0 OR caller.GET_PAGE_DENIED.IS_VIEW eq 1>
			<cfloop array="#Caller.BODY_DESIGN.GRID#" item="ROW">
				<!--- Dynamic Content Layout --->
				<div class="#attributes.row_class#" style="#attributes.row_class#">
				<cfloop array="#ROW.COLS#" item="COL">
					<div class="#attributes.col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.col_style#">
					<cfloop array="#COL.WIDGET#" item="WIDGET">
						<cfif WIDGET.ID EQ 0>
							<!--- Dynamic Content Template --->
							<cfloop array="#Caller.INSIDE_DESIGN.GRID#" item="ROW">
								<div class="#attributes.row_class#" style="#attributes.row_class#">
								<cfloop array="#ROW.COLS#" item="COL">
									<div class="#attributes.col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.col_style#">
									<cfloop array="#COL.WIDGET#" item="WIDGET">
										<cfset GET_WIDGET = deserializeJSON(Caller.MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:Caller.GET_SITE.SITE_ID))>
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
												<cfif IsJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND) AND isDefined(GET_EXTEND.BEFORE) AND len(GET_EXTEND.BEFORE)>
													<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
												</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
												<script>console.log("DCT :#GET_WIDGET_DCP.DATA[1].WIDGET_FILE_PATH#");</script>
												<cfset widget_box_data = len(GET_WIDGET_DCP.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_BOX_DATA) : ''>
												<cf_box 
													title="#IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''#" 
													class="#IsStruct(widget_box_data) && len(widget_box_data.class) ? widget_box_data.class : ''#" 
												>
												<cfinclude template="/catalyst/#GET_WIDGET.DATA[1].WIDGET_FILE_PATH#">
												</cf_box>
												<cfif IsJSON(GET_WIDGET.DATA[1].WIDGET_EXTEND) AND  isDefined(GET_EXTEND.AFTER) AND len(GET_EXTEND.AFTER)>
													<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
												</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
											</div>
										<cfelse>
											<!--- Dynamic Content Page --->
											<cfloop array="#Caller.PAGE_DATA.GRID#" item="ROW">
												<div class="#attributes.row_class#" style="#attributes.row_class#">
													<cfloop array="#ROW.COLS#" item="COL">
														<div class="#attributes.col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.col_style#">
															<cfloop array="#COL.WIDGET#" item="WIDGET">
																<cfset GET_WIDGET_DCP = deserializeJSON(Caller.MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:Caller.GET_SITE.SITE_ID))>
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
																	<div id="protein_widget_#WIDGET.ID#"><!--- ? Page'te set edilen widgetlar --->
																		<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCP.BEFORE)>
																			<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
																		</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
																		<script>console.log("#GET_WIDGET_DCP.DATA[1].WIDGET_FILE_PATH#");</script>
																		<cfset widget_box_data = len(GET_WIDGET_DCP.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET_DCP.DATA[1].WIDGET_BOX_DATA) : ''>
																		<cfdump  var="#widget_box_data#">
																		<cf_box 
																			title="#IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''#"
																			class="#IsStruct(widget_box_data) && len(widget_box_data.class) ? widget_box_data.class : ''#"
																		>
																		<cfinclude template="/catalyst/#GET_WIDGET_DCP.DATA[1].WIDGET_FILE_PATH#">
																		</cf_box>	
																		<cfif IsJSON(GET_WIDGET_DCP.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCP.AFTER)>
																			<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
																		</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
																	</div>
																</cfif>
															</cfloop>
														</div>
													</cfloop>
												</div>
											</cfloop>
										</cfif>
									</cfloop>
									</div>
								</cfloop>
								</div>
							</cfloop>
						<cfelse>
							<cfset GET_WIDGET_DCL = deserializeJSON(Caller.MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:Caller.GET_SITE.SITE_ID))>
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
								<cfif IsJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCL.BEFORE)>
									<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
								</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
								<script>console.log("DCL :#GET_WIDGET_DCL.DATA[1].WIDGET_FILE_PATH#");</script>
								<cfset widget_box_data = len(GET_WIDGET_DCL.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET_DCL.DATA[1].WIDGET_BOX_DATA) : ''>
								<cf_box title="#IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''#">	
									<cfinclude template="/catalyst/#GET_WIDGET_DCL.DATA[1].WIDGET_FILE_PATH#">	
								</cf_box>						
								<cfif IsJSON(GET_WIDGET_DCL.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_DCL.AFTER)>
									<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
								</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
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