
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfset cfc= createObject("component","V16.objects.cfc.get_list_detail_survey")>
<cfset get_detail_survey=cfc.GetDetailSurvey(keyword:attributes.keyword,project_cat_id:attributes.project_cat_id,work_cat_id:attributes.work_cat_id,relation_type:attributes.relation_type,action_type:attributes.action_type)> 
<cfif attributes.relation_type eq 9><!--- eğitimden geliyorsa bu kontrole girecek SG20120718--->
	<cfset get_control=cfc.GetControl(relation_cat:attributes.relation_cat)> 
	<cfif isdefined("attributes.xml_is_survey_add") and attributes.xml_is_survey_add eq 1 and get_control.recordcount><!--- eğitimden geliyorsa ve eğitim detayındaki xml de sadece 1 adet eklenebilsin seçili ise bu kontrole girer SG20120717--->
		<script type="text/javascript">
			{
				alert("<cf_get_lang dictionary_id='29769.Eğitime bağlı 1 tane değerlendirme formu ekleyebilirsiniz.'>");
				window.close();
			}
		</script>	
	</cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_detail_survey.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Değerlendirme Formları','29744')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_detail_survey" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_detail_survey">
			<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_search>
				<cfinput type="hidden" name="relation_type" value="#attributes.relation_type#">
				<cfinput type="hidden" name="relation_cat" value="#attributes.relation_cat#">
				<cfinput type="hidden" name="action_type" value="#attributes.action_type#">
				<cfif isdefined("attributes.project_cat_id")>
					<cfinput type="hidden" name="project_cat_id" value="#attributes.project_cat_id#">
				</cfif>
				<cfif isdefined("attributes.work_cat_id")>
					<cfinput type="hidden" name="work_cat_id" value="#attributes.work_cat_id#">
				</cfif>
				<div class="form-group" id="item-keyword">
					<div class="input-group x-12">
						<cfinput type="text" name="keyword"  placeholder="#getLang('','Filtre','57460')#" maxlength="100" value="#attributes.keyword#">
					</div>
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_detail_survey' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cfset url_str = "">
			<cfset url_str = "#url_str#&relation_type=#attributes.relation_type#&relation_cat=#attributes.relation_cat#">           
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined('attributes.action_type')>
				<cfset url_str = "#url_str#&action_type=#attributes.action_type#">
			</cfif>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="25"><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang dictionary_id="29764.Form"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_detail_survey.recordcount>
					<cfoutput query="get_detail_survey" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td align="left">
								<input type="hidden" name="survey_main_id" id="survey_main_id" value="#decodeForHTML(survey_main_id)#">#currentrow#
							</td>
							<td height="2" nowrap="nowrap">
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_content_relation&survey_id=#survey_main_id#&relation_cat=#attributes.relation_cat#&relation_type=#type#&draggable=#draggable#" class="tableyazi" style="width:200px;">#decodeforHTML(survey_main_head)#</a>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif get_detail_survey.recordcount gt 0>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_detail_survey#url_str#" 
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			</cfif>
		</cfif>
	</cf_box>
</div>
