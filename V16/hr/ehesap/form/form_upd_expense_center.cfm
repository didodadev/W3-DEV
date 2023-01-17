<cfinclude template="../query/get_expense_center.cfm">
<cfinclude template="../query/get_ssk_offices.cfm">
<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfquery name="GET_HIER" datasource="#dsn_expense#">
	SELECT EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_CODE LIKE '#GET_EXPENSE.EXPENSE_CODE#.%'
</cfquery>
<cfquery name="GET_MUCH_EXPENSE" datasource="#dsn_expense#">
	SELECT
		EXPENSE_CODE,
        EXPENSE
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
			EXPENSE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EXPENSE_ID#">
	</cfif>
	ORDER BY
		EXPENSE_CODE
</cfquery>
<cfsavecontent variable="rght"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_expense_center"> <img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='54259.Alt Hesap Ekle'>"></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="54263.Masraf Merkezi Güncelle"></cfsavecontent>
<cf_box title="#message#" scroll="1" closable="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="upd_expense" method="post">
	<cfset obj=0>
    <cfif isdefined("url.obj")>
		<cfset obj = url.obj>
        <cfset url_string = "">
		<cfif isdefined("field_id")>
            <cfset url_string = "#url_string#&field_id=#field_id#">
        </cfif>
        <cfif isdefined("field_name")>
            <cfset url_string = "#url_string#&field_name=#field_name#">
        </cfif>
        <cfif isdefined("code")>
            <cfset url_string = "#url_string#&code=#code#">
        </cfif>
		<cf_box_elements>
			<cfoutput>
				<input type="hidden" name="expense_id" id="expense_id" value="#attributes.expense_id#">
				<input type="hidden" name="field_id" id="field_id" value="<cfif isdefined("field_id")>#attributes.field_id#</cfif>">
				<input type="hidden" name="hierarchy" id="hierarchy" value="#get_expense.hierarchy#">
				<input type="hidden" name="old_expense" id="old_expense" value="#get_expense.expense_code#">
			</cfoutput>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-active">
					<label class="col col-4 col-md-4 col-xs-4"></label>
					<div class="col col-8 col-md-8 col-xs-8">
						<input type="Checkbox" name="active" id="active" value="1" <cfif len(get_expense.expense_active) and get_expense.expense_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
					</div>
				</div>
			<div class="form-group" id="item-product_cat_code_old">
				<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='54287.Üst Masraf Merkezi'></label>
				<div class="col col-8 col-md-8 col-xs-8">
					<cfset listuzun = listlen(get_expense.expense_code,".")>
					<cfset cat_code = listgetat(get_expense.expense_code,listuzun,".")>
					<cfset ust_cat_code = listdeleteat(get_expense.expense_code,listuzun,".")>
					<input type="Hidden" name="product_cat_code_old" id="product_cat_code_old" value="<cfoutput>#cat_code#</cfoutput>">
					<select name="exp_cntr_code" id="exp_cntr_code" onChange="setHeadExpenseCode()" style="width:202px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="GET_MUCH_EXPENSE">
							<option value="#expense_code#"<cfif ' '&ust_cat_code is ' '&expense_code> selected</cfif>><!--- integer karşılaştırma yapmaması için koşula alt+255 eklendi. --->
							<cfif listlen(expense_code,".") neq 1>
								<cfloop from="1" to="#listlen(expense_code,".")#" index="i">&nbsp;</cfloop>
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
					<div class="col col-3 col-md-3 col-xs-3"><input type="text" name="head_exp_code" id="head_exp_code" readonly  value="<cfoutput>#ust_cat_code#</cfoutput>"></div>
					<div class="col col-9 col-md-9 col-xs-9"><cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='54288.Alt Masraf Merkezi Kodu'></cfsavecontent>
						<cfinput type="text" name="exp_code"  required="yes" message="#message#" value="#cat_code#"></div>
				</div>
			</div>
			<div class="form-group" id="item-expense_name">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
				<div class="col col-8 col-md-8 col-xs-8">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
						<cfinput type="Text" name="expense_name" value="#get_expense.expense#" required="yes" maxlength="50" message="#message#">
				</div>
			</div>
			<div class="form-group" id="item-branch_id">
				<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id="57453.Şube"></label>
					<div class="col col-8 col-md-8 col-xs-8">
						<select name="branch_id" id="branch_id" >
							<cfoutput query="get_ssk_offices">
								<option value="#branch_id#" title="#BRANCH_NAME# (#ssk_office# - #ssk_no#)"<cfif get_expense.expense_branch_id eq branch_id> selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
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
			<div class="form-group" id="item-detail">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-md-8 col-xs-8">
					<textarea name="detail" id="detail" style="width:200px;height:50px;"><cfoutput>#get_expense.detail#</cfoutput></textarea>
				</div>
			</div>
			</div>
			<div class="row">
			<cf_box_footer>
				<cf_record_info query_name="get_expense">
					<cfquery name="GET_EXPENSE_ITEM_ROWS" datasource="#dsn_expense#">
						SELECT EXPENSE_CENTER_ID FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EXPENSE_ID#">
					</cfquery>
					<cfif get_expense_item_rows.recordcount or get_hier.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_expense_center&expense_id=#url.expense_id#'>
					</cfif>
				</cf_box_footer>
			</div>
			</cf_box_elements>
	</cfif>
</cfform>
</cf_box>
<script type="text/javascript">
function setHeadExpenseCode()
{
	if(document.getElementById('exp_cntr_code').value.length)
		document.getElementById('head_exp_code').value=document.getElementById('exp_cntr_code').value;
	else
		document.getElementById('head_exp_code').value = '';
}
</script>
