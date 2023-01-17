<!--- 
Description :
Mega Menü Grid yapısını oluşturur widgetletı gridlere doldurur
Parameters :

mm_row_class ==> row class
mm_row_style ==> row özel css style
mm_col_class ==> col class col sıze önüne gelir ÖR: col-8
mm_col_style ==> col özel css style
Syntax : <cfinclude template = "/PMO/protein_mega_menu_cereate_grid.cfm">
Created :   SA20210605
--->
<cfparam name="attributes.mm_container_class" type="string" default="container">
<cfparam name="attributes.mm_containiner_style" type="string" default="">
<cfparam name="attributes.mm_row_class" type="string" default="row">
<cfparam name="attributes.mm_row_style" type="string" default="">
<cfparam name="attributes.mm_col_class" type="string" default="col">
<cfparam name="attributes.mm_col_style" type="string" default="">
<cfscript>
	StructAppend(attributes,form,true);
	StructAppend(attributes,url,true);
</cfscript>
<cfset MEGAMENU_DATA = deserializeJSON(megamenu.MEGAMENU_DATA)>
<cfoutput> 
	<div role="megamenu" class="#attributes.mm_container_class#" style="#attributes.mm_container_class#">		
		<cfloop array="#MEGAMENU_DATA.GRID#" item="ROW">
			<div class="#attributes.mm_row_class#" style="#attributes.mm_row_style#">
				<cfloop array="#ROW.COLS#" item="COL">
					<div class="#attributes.mm_col_class#-#COL.SIZE#" data-col-no="#COL.NO#" style="#attributes.mm_col_style#">
						<cfloop array="#COL.WIDGET#" item="WIDGET">
							<cfif WIDGET.ID eq -2>
								<cfif StructKeyExists(ITEM,"CHILDREN")>  
									<div class="dropdown_menu_flex">
										<div>
											<h1></h1>
											<ul>
												<li>
													<cfloop array="#ITEM.CHILDREN#" item="ITEM">
														<a href="#ITEM.url#">#ITEM.name#</a>
													</cfloop>
												</li>
											</ul>
										</div>  
									</div> 
								</cfif>
							<cfelse>							
								<cfset GET_WIDGET_MEGAMENU = deserializeJSON(MAIN.GET_WIDGET(WIDGET:WIDGET.ID ,SITE:GET_SITE.SITE_ID))>
								<cfif GET_WIDGET_MEGAMENU.STATUS EQ true AND ArrayLen(GET_WIDGET_MEGAMENU.DATA)>
									<cftry>
										<cfset new_attr = deserializeJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_DATA)>
										<cfscript>
											StructAppend(attributes,new_attr,true);
										</cfscript>
										<cfcatch type="any">	
										</cfcatch>
									</cftry>
									<cfif IsJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_EXTEND)>
										<cfset GET_EXTEND_MEGAMENU = deserializeJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_EXTEND)>
									<cfelse>
										<cfset GET_EXTEND_MEGAMENU = "">
									</cfif>
									<cfif IsJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_MEGAMENU.CSS)>
										<style>#GET_EXTEND_MEGAMENU.CSS#</style>
									</cfif>
									<div id="protein_widget_#WIDGET.ID#">
										<cfif IsJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_MEGAMENU.BEFORE)>
											<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.BEFORE#">
										</cfif><!--- * Widget Extend Before: Widget'tan Önce Yüklenir  --->		
										<script>console.log("#GET_WIDGET_MEGAMENU.DATA[1].WIDGET_FILE_PATH#");</script>
										<cfset widget_box_data = len(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_BOX_DATA) ? deserializeJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_BOX_DATA) : ''>
										<!--- ^ BOX LOAD == 0 ise box olmadan yüklenir --->
										<cfif IsStruct(widget_box_data) AND StructKeyExists(widget_box_data, "box_load") AND len(widget_box_data.box_load) AND widget_box_data.box_load EQ 1>
											<cf_box 
												title="#IsStruct(widget_box_data) && len(widget_box_data.title) ? widget_box_data.title : ''#"
												class="#IsStruct(widget_box_data) && len(widget_box_data.class) ? widget_box_data.class : ''#"
											>
												<cfif GET_WIDGET_MEGAMENU.DATA[1].WIDGET_NAME neq "-2">
													<cfinclude template="/catalyst/#GET_WIDGET_MEGAMENU.DATA[1].WIDGET_FILE_PATH#">
												<cfelse>
													<cfset GET_WIDGET_DESIGN_BLOCK = MAIN.GET_DESIGN_BLOCK(WIDGET:WIDGET.ID)>												
													<cftry>
														<cfset DESIGN_BLOCK_CONTENT = deserializeJSON(GET_WIDGET_DESIGN_BLOCK)>
														#evaluate("DESIGN_BLOCK_CONTENT.design_block_#session_base.language#")#
														<cfcatch type="any">
															#GET_WIDGET_DESIGN_BLOCK#
														</cfcatch>														
													</cftry>
													
													
												</cfif>
											</cf_box>																				
										<cfelse>
											<cfif GET_WIDGET_MEGAMENU.DATA[1].WIDGET_NAME neq "-2">
												<cfinclude template="/catalyst/#GET_WIDGET_MEGAMENU.DATA[1].WIDGET_FILE_PATH#">
											<cfelse>
												<cfset GET_WIDGET_DESIGN_BLOCK = MAIN.GET_DESIGN_BLOCK(WIDGET:WIDGET.ID)>												
												<cftry>
													<cfset DESIGN_BLOCK_CONTENT = deserializeJSON(GET_WIDGET_DESIGN_BLOCK)>
													#evaluate("DESIGN_BLOCK_CONTENT.design_block_#session_base.language#")#
													<cfcatch type="any">
														#GET_WIDGET_DESIGN_BLOCK#
													</cfcatch>													
												</cftry>
											</cfif>
											
										</cfif>
										<cfif IsJSON(GET_WIDGET_MEGAMENU.DATA[1].WIDGET_EXTEND) AND len(GET_EXTEND_MEGAMENU.AFTER)>
											<cfinclude template="/catalyst/AddOns/Yazilimsa/Protein/extend_files/widget/#GET_EXTEND.AFTER#">
										</cfif><!--- * Widget Extend After: Widget'tan Sonra Yüklenir  --->
									</div>
								</cfif>
							</cfif>
						</cfloop>
					</div>
				</cfloop>
			</div>
		</cfloop>
	</main>
</cfoutput> 