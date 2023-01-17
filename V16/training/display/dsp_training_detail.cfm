<cfscript>
	get_subject_action = CreateObject("component","V16.training.cfc.training_subject");
	get_subject_action.dsn = dsn;
	get_subject = get_subject_action.get_training_fnc(
	train_id : attributes.train_id
	);
</cfscript>
<cf_box title="#getLang('','Konu',57480)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cf_box_elements>
<cf_flat_list>

		<cfoutput>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='7.Eğitim'></td>
			<td>:</td>
			<td>#get_subject.train_head#</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='74.kategori'></td>
			<td>:</td>
			<td>#get_subject.training_cat#</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='583.bölüm'></td>
			<td>:</td>
			<td>#get_subject.section_name#</td>
		</tr>
		<tr>
			<td class="txtbold" valign="top"><cf_get_lang no='7.Amaç'></td>
			<td>:</td>
			<td>#get_subject.train_objective#</td>
		</tr>
		<tr>
			<td class="txtbold" valign="top"><cf_get_lang no='107.Eğitim İçeriği'></td>
			<td>:</td>
			<td valign="top">#get_subject.train_detail#</td>
		</tr>
		</cfoutput>
	</cf_flat_list>
</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="get_subject">
	</cf_box_footer>
</cf_box>
