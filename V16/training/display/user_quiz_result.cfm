<cfinclude template="../query/get_result_detail.cfm">
<cfoutput query="RESULT_DETAIL">
	<cfsavecontent variable="message">
		<cfif len(emp_id)>#get_emp_info(emp_id,0,0)#
		<cfelseif len(partner_id)>#get_par_info(partner_id,0,0,0)#
		<cfelseif len(consumer_id)>#get_cons_info(consumer_id,1,0)#
		</cfif>
	</cfsavecontent>
</cfoutput>
<cf_box title="#message#" scroll="1" collapsable="0" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th style="width:10px;text-align:center;"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58810.Soru'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='58654.Cevap'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='46042.Doğru şık'></th>
				<th style="width:20px;"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
			</tr>
		</thead>
		<cfoutput query="get_result_detail">
			<tbody>
				<tr>
					<td style="text-align:center">#currentrow#</td>
					<td>#question#</td>
					<cfset user_answer = listToArray(QUESTION_USER_ANSWERS, ",", false, true)>
					<td style="text-align:center">#user_answer[2]#</td>
					<td style="text-align:center">#QUESTION_RIGHTS#</td>
					<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_upd_question&question_id=#question_id#')"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
				</tr>
			</tbody>
		</cfoutput>
	</cf_grid_list>
</cf_box>