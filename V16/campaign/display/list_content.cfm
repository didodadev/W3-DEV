<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.camp_id" default="">
<cfif isdefined("attributes.form_submit")>
<cfinclude template="../query/get_content.cfm">
<cfelse>
<cfset get_content.recordcount =0> 
</cfif>
<cfparam name="attributes.totalrecords" default=#get_content.recordcount#>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('main',633)#">
	<cf_medium_list_search_area>
		<cfform name="list_content" method="post" action="#request.self#?fuseaction=campaign.popup_list_content">
			<table>
			<input type="hidden" name="form_submit" id="form_submit" value="1">
				<tr>
					<td>
					
					<cf_get_lang_main no ='48.Filtre'><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					<td><cf_wrk_search_button></td>
					
					</td>
				</tr>
			</table>
		</cfform>  
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang_main no='75.No'></th>
			<th><cf_get_lang_main no ='34.Kampanya'></th>
			<th><cf_get_lang_main no ='241.İçerik'></th>
			<th width="150"><cf_get_lang_main no='487.Kaydeden'></th>
			<th width="100"><cf_get_lang_main no='330.Tarih'></th>
		</tr>
	</thead>
	<tbody>
		<cfif isdefined("attributes.form_submit")>
		<cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td>#CAMP_HEAD#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_form_upd_email_cont&email_cont_id=#content_id#&camp_id=#camp_id#','page');" class="tableyazi">#cont_head#</a></td>
				<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
				<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cf_get_lang_main no ='289.Filte Ediniz'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
	<cfif isdefined("attributes.form_submit") and get_content.recordcount>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table cellpadding="1" cellspacing="1" border="0" width="99%" height="20" align="center">
				<tr>
					<td><cf_pages 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="campaign.popup_list_content&form_submit=1&keyword=#attributes.keyword#"></td>
					<!-- sil --><td  style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
					</tr>
			</table>
		</cfif>
	</cfif>
