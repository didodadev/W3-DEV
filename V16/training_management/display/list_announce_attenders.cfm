<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_ANNOUNCE_ATTS WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_par_att" datasource="#dsn#">
	SELECT PAR_ID FROM TRAINING_CLASS_ANNOUNCE_ATTS WHERE CLASS_ID=#attributes.CLASS_ID# AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_con_att" datasource="#dsn#">
	SELECT CON_ID FROM TRAINING_CLASS_ANNOUNCE_ATTS WHERE CLASS_ID=#attributes.CLASS_ID# AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<cfset att_list = ''>
<cfif get_emp_att.RECORDCOUNT>
	<cfloop query="get_emp_att">
		<cfset att_list = listappend(att_list,"emp-#get_emp_att.EMP_ID#",",")>
	</cfloop>
</cfif>
<cfif get_par_att.RECORDCOUNT>
	<cfloop query="get_par_att">
		<cfset att_list = listappend(att_list,"par-#get_par_att.PAR_ID#",",")>
	</cfloop>
</cfif>
<cfif get_con_att.RECORDCOUNT>
	<cfloop query="get_con_att">
		<cfset att_list = listappend(att_list,"con-#get_con_att.CON_ID#",",")>
	</cfloop>
</cfif>
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
<cfinclude template="../query/get_class_announce_attenders.cfm">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang_main no='178.katılımcılar'></td>
  </tr>
</table>
	<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
	<tr class="color-border">
	<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
		<tr class="color-header" height="22">
			<td class="form-title" width="125">Adı Soyadı</td>
			<td class="form-title">Şirket</td>
			<td class="form-title">Departman</td>
			<td class="form-title">Pozisyon</td>
			<td width="15" align="center">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions_multiuser&url_direction=training_management.emptypopup_add_class_potential_attenders&class_id=#attributes.class_id#&url_params=class_id&select_list=1,7,8','list'</cfoutput>);"><img src="/images/plus_square.gif" title="<cf_get_lang_main no='170.Ekle'>" align="center" border="0"></a><!---Potansiyel Katılımcı ekleme --->
			</td>
		</tr>
		<cfif get_class_attender.recordcount>
			<cfoutput query="get_class_attender">
			  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			  	<td>
					<cfif type eq 'employee'>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_class_attender.ids#','project');" class="tableyazi">#ad#&nbsp;#soyad#</a>
					<cfelseif type eq 'partner'>
					<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_class_attender.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
					<cfelseif type eq 'consumer'>
					<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_class_attender.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
					<cfelse>
					#ad#&nbsp;#soyad#
					</cfif>
				</td>
				<td>#nick_name#</td>
				<td>#departman#</td>
				<td>#position#</td>
				<td width="15">
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.emptypopup_del_attenders&id=#K_ID#&class_id=#attributes.class_id#&type=#get_class_attender.type#','small');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.sil'>" align="absmiddle"></a>
				</td>
			  </tr>
			</cfoutput>
			<cfelse>
			<tr class="color-row">
				<td colspan="5">Kayıt yok!</td>
			</tr>
		</cfif>
	</table>			
	</td>
	</tr>
</table>
