<cfinclude template="../query/get_content_relation.cfm">
<cfif get_content_relation.recordcount>
	<cfif len(attributes.product_relation_cnt_maxrows)>
		<cfset product_relation_maxrows = #attributes.product_relation_cnt_maxrows#>
	<cfelse>
		<cfset product_relation_maxrows = ''>
	</cfif>
	<cfif attributes.product_relation_image_view eq 1>
		<cfif attributes.prod_cont_body eq 0>
			<table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
			  <cfoutput query="get_content_relation" maxrows="#product_relation_maxrows#">
			   <cfif isdefined("attributes.product_relation_cnt_image") and attributes.product_relation_cnt_image eq 1>
					<cfquery name="get_content_relation_image_" datasource="#dsn#" maxrows="1">
						SELECT * FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_relation.content_id#"> AND IMAGE_SIZE = 0
					</cfquery>
					<cfif get_content_relation_image_.RECORDCOUNT>
					<tr>
						<cfif len(get_content_relation_image_.CONTIMAGE_SMALL)>
							<td rowspan="3" valign="top" width="75">
								<cf_get_server_file output_file="content/#get_content_relation_image_.CONTIMAGE_SMALL#" output_server="#get_content_relation_image_.IMAGE_SERVER_ID#" image_width="75" imageheight="75" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#">
							</td>
						<cfelse>
							<td rowspan="3" valign="top" width="75"></td>
						</cfif>
					</tr>
					</cfif>
				</cfif>
			  <tr valign="top">
				<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#USER_FRIENDLY_URL#')#" class="tableyazi">#CONT_HEAD#</a></td>
			  </tr>
			  <cfif attributes.product_relation_cnt_summary eq 1>
				  <tr valign="top">
					<td>#cont_summary#</td>
				  </tr>
			  </cfif>
				<cfif get_content_relation.recordcount neq currentrow>
					<tr valign="top">
						<td colspan="2"><hr style="height:0.2px;" color="CCCCCC"></td>
					</tr>
				</cfif>
			 </cfoutput>
			</table>
		<cfelse>
			<cfoutput query="GET_CONTENT_RELATION">
				<table width="100%" align="center">
				<cfif len(CONTENT_PROPERTY_ID)>
					<cfquery name="GET_PROPERTY_NAME" datasource="#DSN#">
						SELECT 
							NAME
						FROM
							CONTENT_PROPERTY
						WHERE 
							CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_property_id#">
					</cfquery>
					  <tr>
						<td class="headbold">#GET_PROPERTY_NAME.NAME#<br /></td>
					  </tr>
				  </cfif>
				  <tr>
					<td>
						<cfif GET_CONTENT_RELATION.is_dsp_header eq 0>
						  <span class="txtbold">#cont_head#</span><br/>
						</cfif>
						<cfif attributes.product_relation_cnt_summary eq 1>
							#cont_summary#<br/><br/>
						</cfif>
						#cont_body#
					</td>
				  </tr>
				  <tr>
					<cfif attributes.prod_cnt_webmail eq 1>
						<td valign="top"><cfinclude template="../content/content_webmail.cfm"></td>
					</cfif>
					<cfif attributes.prod_cnt_print eq 1>
						<td valign="top" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#content_id#&module=objects2','page');return false;" class="headerprint"><cf_get_lang_main no='62.Yazdir'></a></td>
					</cfif>
				  </tr>
				  <tr>
					<td><br/></td>
				  </tr>
				</table>
			</cfoutput>
		</cfif>
	<cfelse>
		<table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
		  <tr>
		  	<cfoutput query="get_content_relation" maxrows="#product_relation_maxrows#">
			<td>
				<table>
					<tr>
						<td>
						   <cfif isdefined("attributes.product_relation_cnt_image") and attributes.product_relation_cnt_image eq 1>
								<cfquery name="get_content_relation_image_" datasource="#dsn#" maxrows="1">
									SELECT * FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_relation.content_id#"> AND IMAGE_SIZE = 0
								</cfquery>
								<cfif get_content_relation_image_.RECORDCOUNT>
								<tr>
									<cfif len(get_content_relation_image_.CONTIMAGE_SMALL)>
										<td rowspan="3" valign="top" width="75">
											<cf_get_server_file output_file="content/#get_content_relation_image_.CONTIMAGE_SMALL#" output_server="#get_content_relation_image_.IMAGE_SERVER_ID#" image_width="75" imageheight="75" output_type="0" alt="#getLang('main',668)" title="#getLang('main',668)#">
										</td>
									<cfelse>
										<td rowspan="3" valign="top" width="75"></td>
									</cfif>
								</tr>
								</cfif>
							</cfif>
						  <tr valign="top">
							<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#USER_FRIENDLY_URL#')#" class="tableyazi">#CONT_HEAD#</a></td>
						  </tr>
						  <cfif attributes.product_relation_cnt_summary eq 1>
							  <tr valign="top">
								<td>#cont_summary#</td>
							  </tr>
						  </cfif>
						</td>
					</tr>
				</table>
			</td>
			 </cfoutput>
		  </tr>
		</table>
	</cfif>
</cfif>

