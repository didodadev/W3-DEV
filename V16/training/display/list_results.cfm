<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_quiz_results_emp.cfm">
<cfelse>
	<cfset get_quiz_results.recordcount = 0>
</cfif>
<cfinclude template="../query/get_training_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quiz_results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script src="../../../JS/Chart.min.js"></script>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_cat_id")>
  <cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
  <cfelse>
  <cfset attributes.training_cat_id = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
	<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
</cfif>
<cfform method="post" action="#request.self#?fuseaction=training.list_results">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('training',21)#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#">
				</td>
				<td>
				<select name="training_cat_id" id="training_cat_id" style="width:125px;">
					<option value="0" selected><cf_get_lang_main no='1739.Tum Kategoriler'> 
					<cfoutput query="get_training_cats">
						<option value="#training_cat_id#" <cfif attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat# 
					</cfoutput>
				</select>
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
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
			<th><cf_get_lang_main no='1414.Test'></th>
			<th><cf_get_lang_main no='330.Tarih'></th>
			<th><cf_get_lang no='56.Toplam Soru'></th>
			<th><cf_get_lang no='57.Doğru'></th>
			<th><cf_get_lang no='58.Yanlış'></th>
			<th><cf_get_lang_main no='1572.Puan'></th>
			<th class="header_icn_text" nowrap="nowrap"><cf_get_lang no='60.Sınav Kağıdı'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_quiz_results.recordcount>
			<cfoutput query="get_quiz_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="35">#currentrow#</td>
					<td height="22">
					<a href="#request.self#?fuseaction=training.quiz&quiz_id=#quiz_id#" class="tableyazi">#QUIZ_HEAD#</a></td>
					<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#TIMEFORMAT(date_add('h',session.ep.time_zone,RECORD_DATE),timeformat_style)#)</td>
					<td>#question_count#</td>
					<td>#user_right_count#</td>
					<td>#user_wrong_count#</td>
					<td>#user_point#</td>
					<!-- sil --><td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_user_quiz_result&result_id=#result_id#','medium');"><img src="/images/file.gif"></a></td><!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="training.list_results#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
