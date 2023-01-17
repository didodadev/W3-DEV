<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.emp_par_name" default="">
<cfparam name="attributes.is_completed" default="">
<cfset url_str = "">
<cfset url_str = "#url_str#&organization_id=#attributes.organization_id#">
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.emp_id")>
	<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif isdefined("attributes.cons_id")>
	<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
</cfif>
<cfif isdefined("attributes.par_id")>
	<cfset url_str = "#url_str#&par_id=#attributes.par_id#">
</cfif>
<cfif isdefined("attributes.emp_par_name")>
	<cfset url_str = "#url_str#&emp_par_name=#attributes.emp_par_name#">
</cfif>
<cfparam name="attributes.is_completed" default="">
<cfinclude template="../query/get_upd_organization_queries.cfm">
<cfset attributes.partner_ids="">
<cfset attributes.employee_ids="">
<cfset attributes.consumer_ids="">
<cfset attributes.group_ids="">
<cfloop list="#evaluate("att_list")#" index="i" delimiters=",">
	<cfif i contains "par">
		<cfset attributes.partner_ids = LISTAPPEND(attributes.partner_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "emp">
		<cfset attributes.employee_ids = LISTAPPEND(attributes.employee_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "con">
		<cfset attributes.consumer_ids = LISTAPPEND(attributes.consumer_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "grp">
		<cfset attributes.group_ids = LISTAPPEND(attributes.group_ids,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop>
<cfinclude template="../query/get_organization_attenders.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Katılımcılar','57590')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="organization_attenders" id="organization_attenders" method="post" action="#request.self#?fuseaction=campaign.emptypopup_upd_attenders_detail&organization_id=#attributes.organization_id#">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="15" class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions_multiuser&org_id=#attributes.organization_id#&field_grp_id=to_grp_ids_1&field_wgrp_id=to_wgrp_ids_1&is_branch_control=1&url_direction=campaign.emptypopup_add_organization_potential_attenders&organization_id=#attributes.organization_id#&url_params=organization_id,draggable&select_list=1<cfif get_module_user(4)>,7,8</cfif>'</cfoutput>);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a><!---Potansiyel Katılımcı ekleme ---></th>
						<th width="125"><cf_get_lang dictionary_id='55757.Adı Soyadı'></th>
						<th><cf_get_lang dictionary_id='57574.Şirket'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='57572.Departman'></th>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th><cf_get_lang dictionary_id='46745.Self Servis'></th>
						<th><cf_get_lang dictionary_id='63732.Katılma Oranı'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					</tr>
				</thead>
				<tbody>
				<cfif get_organization_attender.recordcount>
					<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_organization_attender.recordcount#</cfoutput>">
				<cfoutput query="get_organization_attender">
					<tr>
						<td width="15" class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.emptypopup_del_attenders&id=#K_ID#&organization_id=#attributes.organization_id#&type=#get_organization_attender.type#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
						<td>
							<cfif type eq 'employee'>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_detail_emp&emp_id=#get_organization_attender.ids#','project');" class="tableyazi" <cfif status eq 0>style="color:red;"</cfif>>#ad#&nbsp;#soyad#</a>
							<cfelseif type eq 'partner'>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_organization_attender.ids#','medium');" class="tableyazi" <cfif status eq 0>style="color:red;"</cfif>>#ad#&nbsp;#soyad#</a>
							<cfelseif type eq 'consumer'>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_organization_attender.ids#','medium');" class="tableyazi" <cfif status eq 0>style="color:red;"</cfif>>#ad#&nbsp;#soyad#</a>
							<cfelse>
								#ad#&nbsp;#soyad#
						</cfif>
						</td>
						<td>#nick_name#</td>
						<td>#branch_name#</td>
						<td>#departman#</td>
						<td>#position#</td>
						<td><cfif self_service eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif></td>
						<td><cfinput type="text" name="participation_rate_#currentrow#" id="participation_rate_#currentrow#" value="#tlformat(participation_rate,2)#" maxlength="6" validate="float" style="width:70px;text-align:right;"></td>
						<td><input type="hidden" name="attender_id_#currentrow#" id="attender_id_#currentrow#" value="#organization_attender_id#"><input type="text" name="comment_#currentrow#" id="comment_#currentrow#" value="#comment#"></td>
					</tr>
				</cfoutput>
				</tbody>
				<cfelse>
				<tr>
					<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
				</cfif>
			</cf_grid_list>
			<input type="hidden" name="id_list" id="id_list" value="">
			<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' add_function="control()">
		</cfform>
	</cf_box>
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><div id="mail_gonder"></div></td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	function control()
	{
		row_count = $('#row_count').val();
		if (row_count > 0)
		{
			for (i=1;i<=row_count;i++)
			{
				$('#participation_rate_'+i).val(filterNum($('#participation_rate_'+i).val()));
			}
		}
	}
</script>