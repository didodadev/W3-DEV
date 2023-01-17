<!--- Sosyal Medya Ajax --->
<cfsetting showdebugoutput="no">
<cfquery name="get_company_social_media" datasource="#DSN#">
	SELECT 
		SM.LINK_2, 
		SSM.SMCAT, 
		SSM.SMCAT_LINK_TYPE,
		SSM.SMCAT_ICON
	FROM 
		SOCIAL_MEDIA SM, 
		SETUP_SOCIAL_MEDIA_CAT SSM
	WHERE  
		SM.SMCAT_ID = SSM.SMCAT_ID AND 
		SM.LINK_2<>'' AND 
		SM.LINK_2 IS NOT NULL AND 
		SM.ACTION_ID = #attributes.action_type_id#
</cfquery>

<cf_ajax_list>
	<tbody>
	<cfif get_company_social_media.recordcount>
		<cfoutput query="get_company_social_media">
			
				<tr>
					<td>#smcat#</td>
					<td><a href="#link_2#" target="_blank">#link_2#</a></td>	
					<td><a href="#link_2#" target="_blank"><img align="absbottom" width="20" height="20" src="../documents/settings/#SMCAT_ICON#"></a></td>	
				</tr>
			
		</cfoutput>	
	<cfelse>
		<tr>
			<td colspan="2">
				<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
			</td>
		</tr> 
	</cfif>
    </tbody>  
</cf_ajax_list>
