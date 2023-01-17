<!--- Detayli Uye Analizi Raporu icin eklenmistir (detail_member_report) FBS 20100513 --->
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfquery name="get_member_analysis" datasource="#DSN#">
	SELECT * FROM  MEMBER_ANALYSIS <cfif Len(attributes.keyword)>WHERE ANALYSIS_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%"></cfif>
</cfquery>
<cfif not get_member_analysis.recordcount>
	<cfset get_member_analysis.recordcount = 0>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_member_analysis.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Analizler','58799')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_analysis" method="post" action="#request.self#?fuseaction=report.popup_list_member_analysis">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
				</div>
				
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_analysis' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
				
		<cf_grid_list>
			<thead> 
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='29764.Form'></th>
				<th width="150"><cf_get_lang dictionary_id='30277.Amaç'></th>
				<th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
				<th width="65"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				<th width="50"><cf_get_lang dictionary_id='57756.Durum'></th>
				<th width="90"><cf_get_lang dictionary_id='29479.Yayın'></th>
				<th widt="20"><i class="fa fa-pencil"></i></th>
			</thead>
			<tbody>
				<cfif get_member_analysis.recordcount>
					<cfoutput query="get_member_analysis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td height="22"><a href="javascript://" onclick="send_analyse('#analysis_id#','#analysis_head#');" class="tableyazi">#analysis_head#</a></td>
							<td>#analysis_objective#</td>
							<td>#get_emp_info(get_member_analysis.record_emp,0,1)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td><cfif is_active><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td><cfif is_published><cf_get_lang dictionary_id='30412.Yayınlanıyor'><cfelse><cf_get_lang dictionary_id='30413.Yayınlanmıyor'></cfif></td>
							<td style="text-align:center;"><a href="javascript://"onclick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&analysis_id=#analysis_id#&is_report=1')" class="tableyazi"><i class="fa fa-pencil"></i></a></td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr>
						<td height="20" colspan="12"><cfif not isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="report.popup_list_member_analysis#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function send_analyse(id,head)
{
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('analyse_answer').value = -1;
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('analyse_id').value = id;
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('analyse_name').value = head;
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
