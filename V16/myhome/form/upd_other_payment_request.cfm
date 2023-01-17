<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
</cfif>
<cfquery name="get_payment_request" datasource="#DSN#">
	SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31574.Taksitli Avans Talebi'></cfsavecontent>
<cf_box id="other_payment_request" title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" print_href="#request.self#?fuseaction=objects.popup_print_files&print_type=183&action_id=#attributes.id#&iid=1" print_title="#getLang('','Yazdır',57474)#">
	<cfform name="form_upd_payment_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_other_payment_request">
		<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="draggable" id="draggable" value="<cfif isdefined('attributes.draggable')><cfoutput>#attributes.draggable#</cfoutput></cfif>">
		<input type="hidden" name="modal_id" id="modal_id" value="<cfif isdefined('attributes.modal_id')><cfoutput>#attributes.modal_id#</cfoutput></cfif>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
					<div class="col col-8 col-xs-12">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_payment_request.EMPLOYEE_ID#</cfoutput>">
						<input type="text" name="employee_name" id="employee_name" value="<cfoutput><cfif len(get_payment_request.EMPLOYEE_ID)>#get_emp_info(get_payment_request.EMPLOYEE_ID,0,0)#</cfif></cfoutput>"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','140');" autocomplete="off">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="amount_get" id="amount_get" value="#tlformat(get_payment_request.AMOUNT_GET)#" required="yes" onkeyup="return(FormatCurrency(this,event));" message="#message#" class="moneybox">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='31550.Taksit Sayısı'></label>
					<div class="col col-8 col-xs-12">
						<input type="number" name="taksit" id="taksit" value="<cfoutput>#get_payment_request.TAKSIT_NUMBER#</cfoutput>" max="99" min="1" required="required">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail"><cfoutput>#get_payment_request.DETAIL#</cfoutput></textarea>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57500.Onay'>1</label>
					<div class="col col-8 col-xs-12">
						<cfif not(isdefined("get_payment_request.validator_position_code_1") and len(get_payment_request.validator_position_code_1))><div class="input-group"></cfif>
							<input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfif  isdefined("get_payment_request.validator_position_code_1") and len(get_payment_request.validator_position_code_1)><cfoutput>#get_payment_request.validator_position_code_1#</cfoutput></cfif>">
							<input type="text" name="valid_name" id="valid_name" readonly="yes" value="<cfif isdefined("get_payment_request.validator_position_code_1") and len(get_payment_request.validator_position_code_1)><cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput></cfif>">
							<cfif not(isdefined("get_payment_request.validator_position_code_1") and len(get_payment_request.validator_position_code_1))><span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_upd_payment_request.validator_pos_code&field_name=form_upd_payment_request.valid_name</cfoutput>','list');"></span>
						</div></cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57500.Onay'>2</label>
					<div class="col col-8 col-xs-12">
						<cfif not(isdefined("get_payment_request.validator_position_code_2") and len(get_payment_request.validator_position_code_2))><div class="input-group"></cfif>
							<input type="hidden" name="validator_pos_code2" id="validator_pos_code2" value="<cfif isdefined("get_payment_request.validator_position_code_2") and len(get_payment_request.validator_position_code_2)><cfoutput>#get_payment_request.validator_position_code_2#</cfoutput></cfif>">
							<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="<cfif isdefined("get_payment_request.validator_position_code_2") and len(get_payment_request.validator_position_code_2)><cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput></cfif>">
							<cfif not(isdefined("get_payment_request.validator_position_code_2") and len(get_payment_request.validator_position_code_2))><span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_upd_payment_request.validator_pos_code2&field_name=form_upd_payment_request.valid_name2</cfoutput>','list');"></span>
						</div></cfif>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_payment_request">
			<cf_workcube_buttons is_upd='1' type_format="1" is_delete ='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('form_upd_payment_request' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function unformatFields()
{
	form_upd_payment_request.AMOUNT_GET.value = filterNum(form_upd_payment_request.AMOUNT_GET.value);
}
function kontrol()
{
	if (form_upd_payment_request.AMOUNT_GET.value =='' || form_upd_payment_request.AMOUNT_GET.value ==0)
	{
		alert("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>");
		return false;		
	}
	if (document.getElementById('taksit').value == "")
	{
		alert("<cf_get_lang dictionary_id='31411.Taksit Sayısı Giriniz'>");
		return false;
	}
return true;
}
</script>
