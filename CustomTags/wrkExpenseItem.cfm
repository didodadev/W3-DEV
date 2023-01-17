<!--- 
	Gelir\Gider kalemi seçme custom tagi..
	20100125 Aysenur
 --->
<cfparam name="attributes.form_name" default='add_gelenh'>
<cfparam name="attributes.expense_item_id" default=''>
<cfparam name="attributes.expense_item_name" default=''>
<cfparam name="attributes.income_type_info" default=''><!--- 1:gelir, 0:gider, boşsa bütçe kalemleri--->
<cfparam name="attributes.width_info" default='100%'>
<cfparam name="attributes.img_info" default='plus_list'>
<cfparam name="attributes.fieldId" default="expense_item_id">
<cfparam name="attributes.fieldName" default="expense_item_name">
<cfparam name="attributes.is_value" default="0"><!---Search den sonra input taki value nun silinmesi için eklendi--->
<cfparam name="attributes.acc_code" default=''>
<cfif len(attributes.expense_item_id) and not len(attributes.expense_item_name) and attributes.is_value eq 0>
	<cfquery name="ct_get_exp_item" datasource="#CALLER.DSN2#">
		SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
	</cfquery>
	<cfset attributes.expense_item_name = ct_get_exp_item.expense_item_name>
</cfif>
<cfoutput>
	<div class="input-group">
		<input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" value="#attributes.expense_item_id#">
		<cfif len(attributes.acc_code)>
			<input type="text" name="#attributes.fieldName#" data-msg="<cf_get_lang_main no='825.Bütçe Kalemi Seçiniz'>" placeholder="<cf_get_lang_main no='822.Bütçe Kalemi'>" id="#attributes.fieldName#" value="#attributes.expense_item_name#" style="width:#attributes.width_info#px" onFocus="AutoComplete_Create('#attributes.fieldName#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','<cfif len(attributes.income_type_info)>#attributes.income_type_info#</cfif>','EXPENSE_ITEM_ID,ACCOUNT_CODE','#attributes.fieldId#,#attributes.acc_code#','','3','200',true,'compenentInputValueEmptying_expitem(this)');" autocomplete="off">
		<cfelse>
			<input type="text" name="#attributes.fieldName#" data-msg="<cf_get_lang_main no='825.Bütçe Kalemi Seçiniz'>" placeholder="<cf_get_lang_main no='822.Bütçe Kalemi'>" id="#attributes.fieldName#" value="#attributes.expense_item_name#" style="width:#attributes.width_info#px" onFocus="AutoComplete_Create('#attributes.fieldName#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','<cfif len(attributes.income_type_info)>#attributes.income_type_info#</cfif>','EXPENSE_ITEM_ID','#attributes.fieldId#','','3','200',true,'compenentInputValueEmptying_expitem(this)');" autocomplete="off">
		</cfif>	
		<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=#attributes.form_name#.#attributes.fieldId#&field_name=#attributes.form_name#.#attributes.fieldName#<cfif len(attributes.income_type_info) and attributes.income_type_info>&is_income=1<cfelseif not len(attributes.income_type_info)>&is_budget_items=1</cfif>');"></span>
	</div>
</cfoutput>
<script type="text/javascript">
function compenentInputValueEmptying_expitem(object_1)
{
	var keyword_1 = object_1.value;
	if(keyword_1.length == 0)
	{
		document.getElementById('<cfoutput>#attributes.fieldId#</cfoutput>').value ='';
		document.getElementById('<cfoutput>#attributes.fieldName#</cfoutput>').value='';
	}
}
</script>
