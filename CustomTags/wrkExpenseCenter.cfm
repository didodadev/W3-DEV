<!--- 
	Masraf-Gelir Merkezi seçme custom tagi..
	20100125 Aysenur
 --->
<cfparam name="attributes.form_name" default='add_gelenh'>
<cfparam name="attributes.expense_center_id" default=''>
<cfparam name="attributes.expense_center_name" default=''>
<cfparam name="attributes.width_info" default='100%'>
<cfparam name="attributes.img_info" default='plus_list'>
<cfparam name="attributes.fieldId" default="expense_center_id">
<cfparam name="attributes.fieldName" default="expense_center_name">
<cfparam name="attributes.x_authorized_branch_department" default="x_authorized_branch_department">
<cfparam name="attributes.is_value" default="0"><!---Search den sonra input taki value nun silinmesi için eklendi--->
<cfif len(attributes.expense_center_id) and	not len(attributes.expense_center_name) and attributes.is_value eq 0>
	<cfquery name="ct_get_exp_center" datasource="#CALLER.DSN2#">
		SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
	</cfquery>
	<cfset attributes.expense_center_name =ct_get_exp_center.expense>
</cfif>
<cfoutput>
    <div class="input-group">
		<input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" value="#attributes.expense_center_id#">
		<input type="text" name="#attributes.fieldName#" data-msg="<cf_get_lang dictionary_id='58236.Masraf\Gelir Merkezi Seçiniz'>" placeholder="<cf_get_lang dictionary_id='58236.Masraf gelir merkezi'>" id="#attributes.fieldName#" style="width:#attributes.width_info#px" value="#attributes.expense_center_name#" onFocus="AutoComplete_Create('#attributes.fieldName#','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','#attributes.fieldId#','','3','200',true,'compenentInputValueEmptying_exp(this)');"  autocomplete="off">
		<span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_expense_center&field_id=#attributes.form_name#.#attributes.fieldId#&field_name=#attributes.form_name#.#attributes.fieldName#&is_invoice=1<cfif isdefined("attributes.x_authorized_branch_department")>&x_authorized_branch_department=#attributes.x_authorized_branch_department#</cfif>');"></span>
	</div>
</cfoutput>
<script type="text/javascript">
function compenentInputValueEmptying_exp(object_)
{
	var keyword_ = object_.value;
	if(keyword_.length == 0)
	{
		document.getElementById('<cfoutput>#attributes.fieldId#</cfoutput>').value ='';
		document.getElementById('<cfoutput>#attributes.fieldName#</cfoutput>').value='';
	}
}
</script>

