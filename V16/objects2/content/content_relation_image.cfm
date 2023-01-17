<cfif len(attributes.content_image_maxrows)>
	<cfset content_maxrows = #attributes.content_image_maxrows#>
<cfelse>
	<cfset content_maxrows = ''>
</cfif>

<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="#content_maxrows#">
	SELECT 
		CONTIMAGE_ID,
		IMAGE_SERVER_ID,
		CNT_IMG_NAME,
		CONTIMAGE_SMALL,
		DETAIL,
		IMAGE_SIZE
	FROM
		CONTENT_IMAGE
	WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
		<cfif attributes.content_image_size eq 0>
			AND IMAGE_SIZE = 0
		<cfelseif attributes.content_image_size eq 1>
			AND IMAGE_SIZE = 1
		<cfelseif attributes.content_image_size eq 2>
			AND IMAGE_SIZE = 2
		</cfif>
	ORDER BY 
	 	UPDATE_DATE
</cfquery>

<cfif GET_IMAGE_CONT.recordcount>
	<cfif attributes.content_image_view eq 1>
		<table width="100%"> 
		<cfoutput query="GET_IMAGE_CONT">
			<tr> 
				<td align="center">
					<cfif isdefined("attributes.content_image_id") and attributes.content_image_id eq 1>
						<!--- <cfset small_image_server = listgetat(fusebox.server_machine_list,get_image_cont.IMAGE_SERVER_ID,';')> --->
						<a href="javascript://" title="<cf_get_lang no='207.Fotoğraf'>" onClick="windowopen('documents/content/#contimage_small#','medium');">
						<img src="/documents/content/#get_image_cont.contimage_small#" border="0" alt="<cf_get_lang no='207.Fotoğraf'>"
						<cfif isdefined("attributes.content_image_width") and len(attributes.content_image_width)> width="#attributes.content_image_width#"</cfif> 
						<cfif isdefined("attributes.content_image_height") and len(attributes.content_image_height)> height="#attributes.content_image_height#"</cfif> /><br/>
						</a>
					</cfif>
					<cfif isdefined("attributes.content_image_name") and attributes.content_image_name eq 1>
						<a href="javascript://" onClick="windowopen('documents/content/#contimage_small#','medium');" class="tableyazi">#cnt_img_name#</a><br/>
					</cfif>
				</td>
			</tr>
			<cfif GET_IMAGE_CONT.recordcount neq currentrow>
				<tr>
					<td><hr style="height:0.3px;" color="cccccc"></td>
				</tr>
			</cfif>
		</cfoutput>	 
		</table>
	<cfelse>
		<cfset my_cnt_this_row = 0>
		<table width="100%">
			<cfoutput query="GET_IMAGE_CONT">
			<cfset my_cnt_this_row = my_cnt_this_row + 1>
			 <cfif my_cnt_this_row mod attributes.cnt_image_mode eq 1><tr></cfif>
			 <cfset my_cnt_width_ = 100/attributes.cnt_image_mode>
				<td valign="top" width="#my_cnt_width_#%" align="center">
					<cfif isdefined("attributes.content_image_id") and attributes.content_image_id eq 1>
						<!--- <cfset small_image_server = listgetat(fusebox.server_machine_list,get_image_cont.IMAGE_SERVER_ID,';')> --->
						<a href="javascript://" title="<cf_get_lang no='207.Fotoğraf'>" onClick="windowopen('documents/content/#contimage_small#','medium');">
						<img src="/documents/content/#get_image_cont.contimage_small#" border="0" alt="<cf_get_lang no='207.Fotoğraf'>"
						<cfif isdefined("attributes.content_image_width") and len(attributes.content_image_width)> width="#attributes.content_image_width#"</cfif> 
						<cfif isdefined("attributes.content_image_height") and len(attributes.content_image_height)> height="#attributes.content_image_height#"</cfif> /><br/>
						</a>
					</cfif>
					<cfif isdefined("attributes.content_image_name") and attributes.content_image_name eq 1>
						<a href="javascript://" onClick="windowopen('documents/content/#contimage_small#','medium');" class="tableyazi">#cnt_img_name#</a><br/>
					</cfif>
				</td>
				<cfif content_maxrows neq currentrow>
					<td width="10"><div class="ayrac">&nbsp;</div></td>
				</cfif>
			 <cfif my_cnt_this_row mod attributes.cnt_image_mode eq 0></tr></cfif>
		</cfoutput>
		</table>
	</cfif>
</cfif>
