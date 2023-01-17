<cfinclude template="../query/get_class_inform_queries.cfm">
<cfset attributes.inform_partner_ids="">
<cfset attributes.inform_employee_ids="">
<cfset attributes.inform_consumer_ids="">
<cfset attributes.inform_group_ids="">
<cfloop list="#evaluate("att_inform_list")#" index="i" delimiters=",">
	<cfif i contains "inf_par">
		<cfset attributes.inform_partner_ids = LISTAPPEND(attributes.inform_partner_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "inf_emp">
		<cfset attributes.inform_employee_ids = LISTAPPEND(attributes.inform_employee_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "inf_con">
		<cfset attributes.inform_consumer_ids = LISTAPPEND(attributes.inform_consumer_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "inf_grp">
		<cfset attributes.inform_group_ids = LISTAPPEND(attributes.inform_group_ids,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop>
<cfinclude template="../query/get_class_informs.cfm">
<cf_medium_list_search title="#getLang('main',1361)#"></cf_medium_list_search>
<cf_medium_list>
<thead>
		<tr>
			<th width="125"><cf_get_lang_main no='158.Adı Soyadı'></th>
			<th><cf_get_lang_main no='162.Şirket'></th>
			<th><cf_get_lang_main no='160.Departman'></th>
			<th><cf_get_lang_main no='1085.Pozisyon'></th>
			<th width="15" align="center"><cfif get_class_inform.recordcount><input type="checkbox" name="allSelect" id="allSelect" onClick="wrk_select_all('allSelect','row_demand_inf');"></cfif></th>
			<th width="15" align="center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions_multiuser&is_branch_control=1&url_direction=training_management.emptypopup_add_class_inform&class_id=#attributes.class_id#&url_params=class_id&select_list=1<cfif get_module_user(4)>,7,8</cfif>','list'</cfoutput>);"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>" align="center" border="0"></a><!---Bilgi verilecek ekleme ---></th>
		</tr>
	</thead>	
	<tbody>
		<cfif get_class_inform.recordcount>
		<cfoutput query="get_class_inform">
		<tr>
			<td>
				<cfif type eq 'inf_employee'>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_class_inform.ids#','project');" class="tableyazi">#ad#&nbsp;#soyad#</a>
				<cfelseif type eq 'inf_partner'>
					<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_class_inform.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
				<cfelseif type eq 'inf_consumer'>
					<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_class_inform.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
				<cfelse>
					#ad#&nbsp;#soyad#
			  </cfif>
			</td>
			<td>#nick_name#</td>
			<td>#departman#</td>
			<td>#position#</td>
			<td width="%1" align="center"><input type="checkbox" name="row_demand_inf" id="row_demand_inf" value="#type#;#ids#"></td>
			<td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.emptypopup_del_inform&del_id=#INF_ID#&inf_class_id=#attributes.class_id#&inf_type=#get_class_inform.type#','small');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.sil'>" align="absmiddle"></a></td>
		</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
		</cfif>
	</tbody>
</cf_medium_list>
