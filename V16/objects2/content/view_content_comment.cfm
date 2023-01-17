<cfif not isdefined("attributes.content_id")>
	<cfset attributes.CONTENT_ID = #attributes.cid#>
</cfif>
<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN#">
	SELECT 
		*
	FROM
		CONTENT_COMMENT
	WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#"> AND
		STAGE_ID = -2
</cfquery>
<cfinclude template="../query/get_content_head.cfm">

<table align="center" width="100%" cellpadding="2" cellspacing="1" border="0" height="100%" class="color-border">
	<tr class="color-list">
		<td height="35" class="headbold"><cf_get_lang no='353.İçerik Yorumları'></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
			<table width="99%">
				<tr>
					<td colspan="3" class="txtbold" height="35"><cfoutput>#get_content_head.cont_head#</cfoutput></td>
				</tr>
				<cfif GET_PRODUCT_COMMENT.RECORDCOUNT>
					<cfoutput query="GET_PRODUCT_COMMENT">
					<tr class="color-list">
						<td width="20"><img src="/images/notkalem.gif" title="<cf_get_lang_main no='2008.Yorum'>" alt="<cf_get_lang_main no='2008.Yorum'>" border="0" /></td> 
						<td>#name# #surname# - <a href="mailto:#mail_address#" class="label">#mail_address#</a></td>
						<td  style="text-align:right;"><strong><cf_get_lang_main no='1572.PUAN'> :  #content_comment_point#</strong></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="2">#content_comment#</td>
					</tr>			      
					</cfoutput>
				<cfelse>
					<tr class="color-list">
						<td width="20"><img src="/images/notkalem.gif" title="<cf_get_lang_main no='2008.Yorum'>" alt="<cf_get_lang_main no='2008.Yorum'>" border="0" /></td> 
						<td colspan="2"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
					 </tr>
				</cfif>
			</table>
		</td>
	 </tr>
</table>

