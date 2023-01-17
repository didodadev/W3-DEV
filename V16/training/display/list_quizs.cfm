<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_cat_id")>
  <cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
  <cfelse>
  <cfset attributes.training_cat_id = 0>
</cfif>
<cfif isdefined("attributes.attenders")>
  <cfset url_str = "#url_str#&attenders=#attenders#">
  <cfelse>
  <cfset attributes.attenders = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
  <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
</cfif>
<cfinclude template="../query/get_training_cats.cfm">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_quizs.cfm">
<cfelse>
	<cfset get_quizs.recordcount= 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quizs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform method="post" action="#request.self#?fuseaction=training.list_quizs">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('main',639)#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50"></td>
				<td>
				<select name="training_cat_id" id="training_cat_id" style="width:125px;">
				  <option value="" selected><cf_get_lang_main no='1739.Tum Kategoriler'> 
				  <cfoutput query="get_training_cats">
					<option value="#training_cat_id#" <cfif attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat# 
				  </cfoutput>
				</select>
				</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
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
			<th width="35"><cf_get_lang_main no='1165. Sıra'></th>
			<th width="300"><cf_get_lang_main no='1414.Test'></th>
			<th><cf_get_lang no='7.Amaç'></th>
			<th><cf_get_lang_main no='1716.Süre'></th>
			<th><cf_get_lang_main no='70.Aşama'></th>
			<th><cf_get_lang_main no='1978.Hazırlayan'></th>
			<th width="80"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_quizs.recordcount>              
		<cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset attributes.quiz_id = quiz_id>
			<cfinclude template="../query/get_user_join_quiz.cfm">
			<cfinclude template="../query/get_quiz_question_count.cfm">
				<tr>
					<td width="35">#currentrow#</td>
					<td height="22"><a href="#request.self#?fuseaction=training.quiz&quiz_id=#quiz_id#" class="tableyazi">#QUIZ_HEAD#</a></td>
					<td>#quiz_objective#</td>
					<td>#total_time# <cf_get_lang_main no='1415.dk'>.</td>
					<td>#stage_name#</td>
					<td>
						<cfif len(RECORD_EMP)>
							#get_emp_info(RECORD_EMP,0,1)#
						<cfelseif len(record_par)>
						<cfset attributes.partner_id = RECORD_PAR>
						<cfinclude template="../query/get_partner.cfm">
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id#','medium');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a>
						</cfif>
				</td>
			<td width="80">#dateformat(record_date,dateformat_style)#</td>
			</tr>				 
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7" class="color-row"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>             
	</tbody>
</cf_big_list>
<cf_paging
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="training.list_quizs#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
