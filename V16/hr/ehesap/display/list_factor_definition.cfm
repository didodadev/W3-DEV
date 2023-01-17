<cfset in_out_cmp = createObject("component","V16.hr.ehesap.cfc.employees_in_out") />
<cfset get_factor_definition = in_out_cmp.get_factor_definition()>
<cf_grid_list>
	<thead>
		<tr>
			<th width="150"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
			<th width="150"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			<th width="150" style="text-align:right;"><cf_get_lang dictionary_id="59313.Aylık Katsayı"></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id="59314.Taban Aylık Katsayı"></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id="59315.Yan Ödeme Katsayısı"></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='62934.Aile Yardımı Puanı'></th>
			<th style="text-align:right;">1. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'></th>
			<th style="text-align:right;">2. <cf_get_lang dictionary_id='62935.Çocuk Yardımı Puanı'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='63763.En Yüksek Devlet Memuru Aylığı'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='63761.Toplu Sözleşme İkramiyesi Tutarı'></th>
			<th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_factor_definition&draggable=1','add_factor_box','ui-draggable-box-medium');" title="<cf_get_lang dictionary_id='46447.Katsayı Ekle'>"><i class="fa fa-plus"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_factor_definition">
			<tr>
				<td>#dateformat(startdate,dateformat_style)# </td>
				<td> #dateformat(finishdate,dateformat_style)#</td>
				<td style="text-align:right;">#TLFormat(SALARY_FACTOR,7)#</td>
				<td style="text-align:right;">#TLFormat(BASE_SALARY_FACTOR,7)#</td>
				<td style="text-align:right;">#TLFormat(BENEFIT_FACTOR,7)#</td>
				<td style="text-align:right;">#TLFormat(FAMILY_ALLOWANCE_POINT,7)#</td>
				<td style="text-align:right;">#TLFormat(CHILD_BENEFIT_FIRST,7)#</td>
				<td style="text-align:right;">#TLFormat(CHILD_BENEFIT_SECOND,7)#</td>
				<td style="text-align:right;">#TLFormat(highest_civil_servant_salary,7)#</td>
				<td style="text-align:right;">#TLFormat(collective_agreement_bonus_amount,7)#</td>
				<td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_form_upd_factor_definition&id=#id#','add_factor_box','ui-draggable-box-medium');"title="<cf_get_lang dictionary_id='58718.Düzenle'>" ><i class="fa fa-pencil"></i></a></td>
			</tr>
		</cfoutput>
	</tbody>
</cf_grid_list>