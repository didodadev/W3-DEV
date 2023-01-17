<cfquery name="GET_VISION_NAME" datasource="#DSN#">
	SELECT
		VISION_TYPE_ID,
		VISION_TYPE_NAME
	FROM  
		SETUP_VISION_TYPE
	WHERE 
		(
            <cfloop from="1"  to="#listlen(attributes.is_property_vision)#" index="vcat">
                VISION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_property_vision,vcat)#"> 
                <cfif vcat neq listlen(attributes.is_property_vision)>OR</cfif>
            </cfloop>
		)
	ORDER BY 
		VISION_TYPE_ID
</cfquery>
<cfoutput>
<table cellpadding="1" cellspacing="1" style="width:100%;">
	<tr>
		<td>
			<ul id="menu1" class="ajax_tab_menu">
				<cfloop query="get_vision_name">
					<cfif currentrow eq 1>
						<cfset birincil_ = vision_type_id>
					</cfif>
					<li <cfif currentrow eq 1>class="selected"</cfif> id="link#currentrow#_#this_row_id_#"><a onclick="visiontype_#this_row_id_#(#vision_type_id#,link#currentrow#_#this_row_id_#);">#vision_type_name#</a></link>
				</cfloop>
			</ul>
			<div id="vision_icerik_#this_row_id_#" class="icerik" style="width:100%;height:100%;"></div>
		</td>
		<script type="text/javascript">
			<cfif isdefined("birincil_")>
				<cfset url_str="">
				<cfset url_str = url_str&"&vision_position="&attributes.vision_position>
				<cfset url_str = url_str&"&mode="&attributes.mode>
				<cfset url_str = url_str&"&dongu="&attributes.dongu>
				<cfset url_str = url_str&"&is_sale="&attributes.is_sale>
				<cfset url_str = url_str&"&sellable_stock_control="&attributes.sellable_stock_control>
				<cfset url_str = url_str&"&vision_image_display="&attributes.vision_image_display>
				<cfset url_str = url_str&"&is_vision_prices="&attributes.is_vision_prices>
				<cfset url_str = url_str&"&is_vision_product_name="&attributes.is_vision_product_name>
				<cfset url_str = url_str&"&is_vision_product_detail="&attributes.is_vision_product_detail>
				<cfset url_str = url_str&"&is_vision_product_detail2="&attributes.is_vision_product_detail2>
				<cfif isdefined('attributes.is_vision_category') and len(attributes.is_vision_category)>
					<cfset url_str = url_str&"&is_vision_category="&attributes.is_vision_category>
				</cfif>
				<cfif isdefined('attributes.is_vision_brand') and len(attributes.is_vision_brand)>
					<cfset url_str = url_str&"&is_vision_brand="&attributes.is_vision_brand>
				</cfif>
				<cfif isdefined('attributes.last_user_price_list') and len(attributes.last_user_price_list)>
					<cfset url_str = url_str&"&last_user_price_list="&attributes.last_user_price_list>
				</cfif>
				<cfif isdefined('attributes.vision_image_width') and len(attributes.vision_image_width)>
					<cfset url_str = url_str&"&vision_image_width="&attributes.vision_image_width>
				<cfelse>
					<cfset url_str = url_str&"&vision_image_width=30">
				</cfif>
				<cfif isdefined('attributes.vision_image_height') and len(attributes.vision_image_height)>
					<cfset url_str = url_str&"&vision_image_height="&attributes.vision_image_height>
				<cfelse>
					<cfset url_str = url_str&"&vision_image_height=30">
				</cfif>
				<cfset url_str = url_str&"&this_row_id_="&this_row_id_>
				<cfset my_url_ = #url_str#>
				<cfset url_str = url_str&"&is_property_vision="&birincil_>
				AjaxPageLoad('#request.self#?fuseaction=objects2.emptypopup_get_vision_tabbed&#url_str#','vision_icerik_#this_row_id_#',1);
			</cfif>
		</script>
	</tr>
</table>
<script type="text/javascript">
	function visiontype_#this_row_id_#(type,_link_)
	{
		var url_str = "#request.self#?fuseaction=objects2.emptypopup_get_vision_tabbed&is_property_vision="+type+"&#my_url_#"
		AjaxPageLoad(url_str,'vision_icerik_#this_row_id_#' ,0,'Yükleniyor',_link_);
	}
</script>
</cfoutput>
