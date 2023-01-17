<cfsavecontent variable="message"><cf_get_lang dictionary_id="29522.Sözleşme"></cfsavecontent>
<cf_box title="#message# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfquery name="get_employee_contract" datasource="#DSN#">
		SELECT
			EC.*,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES_CONTRACT EC,
			EMPLOYEES E
		WHERE
			EC.RECORD_EMP = E.EMPLOYEE_ID AND
			EC.EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
	<cf_grid_list>
		<thead>
		<tr>
			<th width="75"><cf_get_lang dictionary_id='30044.Sözleşme No'></th>
			<th width="100"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
			<th width="100"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			<th><cf_get_lang dictionary_id='57480.Konu'></th>
			<th width="100"><cf_get_lang dictionary_id='55812.Kayıt Eden'></th>
			<th width="100"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			<th width="15"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_add_employee_contract&employee_id=#attributes.employee_id#</cfoutput>','','ui-draggable-box-large')" title="<cf_get_lang_main no='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
		</tr>
		</thead>
		<tbody>
		<cfif get_employee_contract.recordcount>
			<cfoutput query="get_employee_contract">
				<tr>
					<td>#CONTRACT_NO#</td>
					<td>#dateformat(contract_date,dateformat_style)#</td>
					<td>#dateformat(contract_finishdate,dateformat_style)#</td>	
					<td><a href="#request.self#?fuseaction=hr.popup_upd_employee_contract&cont_id=#get_employee_contract.contract_id#" class="tableyazi">#CONTRACT_HEAD#</a></td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_employee_contract.RECORD_EMP#','medium');" class="tableyazi">#get_employee_contract.EMPLOYEE_NAME# #get_employee_contract.EMPLOYEE_SURNAME#</a></td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td><a title="<cf_get_lang_main no ='52.Güncelle'>" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_employee_contract&cont_id=#get_employee_contract.contract_id#&employee_id=#attributes.employee_id#', 'upd_contract_box','ui-draggable-box-large')"><i class="fa fa-pencil"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr> 
				<td colspan="7"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
			</tr>
		</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>