<cfif isdefined("attributes.is_user_friendly_url") and attributes.is_user_friendly_url eq 1>
	<cfset comp = createObject("component","V16.objects2.product.cfc.productOther") />
	<cfset mixed_cont = comp.GET_RELATED_MIXED_CONTENT(
		pid : attributes.pid,
		site: GET_PAGE.PROTEIN_SITE
	)/>
	<cfif mixed_cont.recordcount>
		<div class="product_detail" style="padding: 0px 13px;">
			<cfoutput query="mixed_cont">
				<cfif attributes.list_content_image eq 1>
					<div class="content_item_img">
						<cfif len(CONTIMAGE_SMALL_NEW)><img src="/documents/content/#CONTIMAGE_SMALL_NEW#"/></cfif>
					</div>
				</cfif>
				<div class="details" style="border-bottom:0.1px solid ##eee;<cfif attributes.list_content_image eq 1>padding-top:30px;</cfif>">
					<p><a class="none-decoration">#cont_head#</a></p>					
					<cfset cont_sum= left(cont_summary,400)> 
					<small>#cont_sum#...</small> 
				</div>			
			</cfoutput>
		</div>
	<cfelse>
	    <cfset widget_live = "die">
	</cfif>
<cfelse>
	<cfif isdefined("attributes.list_content_maxrow") and isnumeric(attributes.list_content_maxrow)>
		<cfset max_ = attributes.list_content_maxrow>
	<cfelse>
		<cfset max_ = 5>
	</cfif>
	<cfif isdefined("attributes.list_content_width") and isnumeric(attributes.list_content_width)>
		<cfset width = attributes.list_content_width>
		<cfset my_width = 12 / width>
	<cfelse>
		<cfset my_width = 4>
	</cfif>
	<cfif isdefined("attributes.product_id")>
		<cfset attributes.pid = attributes.product_id>
	</cfif>
	<cfinclude template="../query/get_content_relation.cfm">
	<cfparam name="attributes.page" default='1'>

	<cfset attributes.maxrows = max_>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif get_content_relation.recordcount>
		<cfif isdefined("attributes.type_content") and attributes.type_content eq 1>
			<div class="list_content" >
				<cfoutput query="get_content_relation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">								
					<div class="col-lg-#my_width# col-md-6 col-sm-12 col-12">
						<div class="list_content_item">					
							<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
								<div class="list_content_item_title">
									#cont_head#
								</div>
							</cfif>
							<cfif isdefined("attributes.is_list_content_summary") and attributes.is_list_content_summary eq 1>
								<div class="list_content_item_text" id="list_content_item_text">									
									<cfset cont_sum= left(cont_summary,400)> 
									<p>#cont_sum#...</p> 
								</div>
							</cfif>	
							<cfif isdefined("attributes.is_list_content_body") and attributes.is_list_content_body eq 1>
								<div class="list_content_item_text" id="list_content_item_text">							
									<p>#cont_body#</p> 
								</div>
							</cfif>											
						</div>
					</div>				
				</cfoutput>
			</div>
		<cfelse>
			<div class="list_content list_content-type2" style="justify-content:center;">
				<cfoutput query="get_content_relation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">								
					<div class="col-lg-#my_width# col-md-6 col-sm-12 col-12">
						<div class="list_content_item">					
							<cfif isdefined("attributes.is_list_content_header") and attributes.is_list_content_header eq 1>
								<div class="list_content_item_title">
									#cont_head#
								</div>
							</cfif>
							<cfif isdefined("attributes.is_list_content_summary") and attributes.is_list_content_summary eq 1>
								<div class="list_content_item_text" id="list_content_item_text">									
									<cfset cont_sum= left(cont_summary,400)> 
									<p>#cont_sum#...</p> 
								</div>
							</cfif>	
							<cfif isdefined("attributes.is_list_content_body") and attributes.is_list_content_body eq 1>
								<div class="list_content_item_text" id="list_content_item_text">							
									<p>#cont_body#</p> 
								</div>
							</cfif>												
						</div>
					</div>				
				</cfoutput>
			</div>
		</cfif>
	</cfif>
</cfif>