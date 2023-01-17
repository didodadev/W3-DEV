<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#dsn_expense#">
	SELECT
		*
	FROM
		EXPENSE_CENTER
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		WHERE
			EXPENSE LIKE '%#attributes.keyword#%' OR
			DETAIL LIKE '%#attributes.keyword#%' OR
			EXPENSE_CODE LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif isdefined("attributes.EXPENSE_ID")>
		WHERE 
			EXPENSE_ID <> #attributes.EXPENSE_ID#
	</cfif>
	ORDER BY
		EXPENSE_CODE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="54260.Masraf Merkezi Ekle"></cfsavecontent>
	<cf_box title="#message#" scroll="1" closable="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_expense"  method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_expense_center">
		<cf_box_elements>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-get_expense">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='54287.Üst Masraf Merkezi'></label>
			<div class="col col-8 col-md-8 col-xs-8">
				<select name="exp_cntr_code" id="exp_cntr_code" onChange="setHeadExpenseCode()" style="width:200px;">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput  query="get_expense">
						<option value="#expense_code#">
							<cfif ListLen(expense_code,".") neq 1>
							<cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop>
						</cfif>
						#expense#
					</option>
				</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group" id="item-exp_code">
		<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='54288.Alt Masraf Merkezi Kodu'>*</label>
			<div class="col col-8 col-md-8 col-xs-8">
				<div class="col col-3 col-md-3 col-xs-3"><input type="text" name="head_exp_code" id="head_exp_code" readonly></div>
				<div class="col col-9 col-md-9 col-xs-9"><cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='54288.Alt Masraf Merkezi Kodu'></cfsavecontent>
					<cfinput type="text" name="exp_code" style="width:145px;" required="yes" message="#message#"></div>
			</div>
		</div>
		<div class="form-group" id="item-expense_name">
		<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='54289.Alt Masraf Merkezi Adı'>*</label>
			<div class="col col-8 col-md-8 col-xs-8">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='54289.Alt Masraf Merkezi Adı'></cfsavecontent>
				<cfinput type="Text" name="expense_name"  required="Yes" maxlength="50" message="#message#">
			</div>
		</div>
		<div class="form-group" id="item-activity_id">
		<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id="49184.Aktivite Tipi"></label>
			<div class="col col-8 col-md-8 col-xs-8">
				<select name="activity_id" id="activity_id">
				<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
				<cfoutput  query="getActivity">
					<option value="#activity_id#">#activity_name#</option>
				</cfoutput>
			</select>
			</div>
		</div>
		<div class="form-group" id="item-expense_detail">
		<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
			<div class="col col-8 col-md-8 col-xs-8">
				<textarea name="expense_detail" id="expense_detail" style="width:200px;height:60px;"></textarea>
			</div>
		</div>
		</div>
		<div class="row">
		<cf_box_footer>
		<cf_workcube_buttons is_upd='0' add_function="kontrol()"></cf_box_footer>
		</div>
		</cf_box_elements>
	</cfform>
<script type="text/javascript">
function kontrol()
{
	if(add_expense.expense.value =='')
	{
		alert("<cf_get_lang dictionary_id='54262.Lütfen Masraf alanını doldurunuz'> !");			
		return false;
	}
	if(add_expense.expense_code.value =='')
	{
		alert("<cf_get_lang dictionary_id='54261.Lütfen kod alanını doldurunuz'> !");			
		return false;
	}
	return true;
}
function setHeadExpenseCode()
{
	if(document.getElementById('exp_cntr_code').value.length)
		document.getElementById('head_exp_code').value=document.getElementById('exp_cntr_code').value;
	else
		document.getElementById('head_exp_code').value = '';
}
</script>
