<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfif not isdefined("attributes.cat")>
  <cfset attributes.cat=''>
</cfif>
<cfif isdefined("attributes.cat") and len(attributes.cat)>
	<cfif listgetat(attributes.cat,1,"-") is "cat">
		<cfset cont_st = "cat">
	<cfelse>
		<cfset cont_st = "ch">
	</cfif>
</cfif>

<cfquery name="GET_CHAPTER_HIER" datasource="#DSN#">
	SELECT 
		CC.CONTENTCAT, 
		CC.CONTENTCAT_ID, 
		CH.CHAPTER_ID, 
		CH.CHAPTER
	FROM 
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CH 
	WHERE 
		CC.CONTENTCAT_ID = CH.CONTENTCAT_ID 
	ORDER BY
		CC.CONTENTCAT,CH.CHAPTER
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_comments.cfm">
<cfelse>
	<cfset get_comments.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_comments.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=content.list_comments" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">	
<cf_big_list_search title="#getLang('content',84)#">
	<cf_big_list_search_area>		
		<table>
			<tr> 
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td astyle="text-align:right;"><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:100px;" maxlength="255"></td>
				<td>
					<select name="cat" id="cat">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_chapter_hier">
								<cfif currentrow is 1>
									<option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#"> selected</cfif> >#contentcat#</option>
									<option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#"> selected</cfif>>&nbsp;&nbsp;#chapter#</option>
								<cfelse>
									<cfset old_row = currentrow -1>
									<cfif contentcat_id is contentcat_id[old_row]>
										<option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>
									<cfelse>
										<option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#">selected</cfif>>#contentcat#</option>
										  <option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#
									</cfif>
								</cfif>
							</cfoutput>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
		
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
			<tr> 
				<th><cf_get_lang_main no='241.İçerik'></th>
				<th><cf_get_lang_main no='1572.Puan'></th>
				<th><cf_get_lang no='145.Yorum Tarihi'></th>
				<th><cf_get_lang no='146.Yorum Yapan'></th>
				<th><cf_get_lang_main no='344.Durum'></th>
				<th class="header_icn_none"></th>
			</tr>
	</thead>
	<tbody>
		<cfif get_comments.recordcount>
			<cfoutput query="get_comments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr> 
					<td><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#content_id#" class="tableyazi">#cont_head#</a></td>
					<td>#content_comment_point#</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td>#name# #surname#</td>
					<td><cfif stage_id eq -1>
							<cf_get_lang no='77.Hazırlık'>
						<cfelseif stage_id eq -2>
							<cf_get_lang_main no='1682.Yayın'>
						<cfelseif stage_id eq 0>
							<cf_get_lang_main no='1740.Red'>
						</cfif>
					</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=content.popup_upd_content_comment&content_id=#content_id#&content_comment_id=#content_comment_id#','large');"><img src="/images/update_list.gif" alt="<cf_get_lang no='124.Yorum Düzenle'>" title="<cf_get_lang no='124.Yorum Düzenle'>"></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr> 
		</cfif>
	</tbody>
</cf_big_list>
<cfif attributes.maxrows lt attributes.totalrecords>
	<table cellpadding="0" cellspacing="0" border="0" style="width:98%; height:35px; text-align:center">
		<tr>
			<td>
				<cfset adres = "content.list_comments&form_submitted=1&keyword=#attributes.keyword#">
				<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#">
			</td>
			<td style="text-align:right;"> 
				<cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#</cfoutput>&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput>
			</td>
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
