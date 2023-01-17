<cfquery name="get_password_maker" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		PASSWORD_MAKER 
	WHERE 
		<cfif isdefined("attributes.employee_id")>
			EMPLOYEE_ID=#attributes.employee_id#
		<cfelse>
			PARTNER_ID=#attributes.partner_id#
		</cfif>
	ORDER BY 
		PASSWORD_MAKER_ID DESC 
</cfquery>
<cfsavecontent variable="head">
	<cf_get_lang dictionary_id='29506.Şifrematik'>: 
	<cfif isdefined("attributes.employee_id")>
		<cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>
	<cfelse>
		<cfoutput>#get_par_info(attributes.partner_id,0,-1,0)#</cfoutput>
	</cfif>	
</cfsavecontent>
<cf_box id="password_maker" title="#head#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id ='29507.Şifrematik No'></th>
				<th width="60"><cf_get_lang dictionary_id ='57483.Kayıt'></th>
				<th width="50"><cf_get_lang dictionary_id ='57756.Durum'></th>
				<th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_password_maker<cfif isdefined("attributes.employee_id")>&employee_id=#attributes.employee_id#<cfelse>&partner_id=#attributes.partner_id#</cfif></cfoutput>','','ui-draggable-box-small')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_password_maker.recordcount>
				<cfoutput query="get_password_maker">
					<tr>
						<td>#currentrow#</td>
						<td>#password_maker_no#</td>
						<td>#dateformat(dateadd('h',session.ep.time_zone,record_date),dateformat_style)#</td>
						<td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_upd_password_maker&pass_id=#password_maker_id#','','ui-draggable-box-small')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
