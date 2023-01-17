<!---E.A 20072012 SELECT ifadeleri düzenlendi..--->
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_exist" default="0">
<cfparam name="attributes.acc_code" default="">
<cfif attributes.form_exist>
	<cfquery name="GET_EXPENSE_ITEMS" datasource="#dsn2#">
		SELECT
			EXPENSE_ITEMS.EXPENSE_ITEM_ID,
			#dsn#.Get_Dynamic_Language(EXPENSE_ITEMS.EXPENSE_ITEM_ID,'#session.ep.language#','EXPENSE_ITEMS','EXPENSE_ITEM_NAME',NULL,NULL,EXPENSE_ITEMS.EXPENSE_ITEM_NAME) AS EXPENSE_ITEM_NAME,
			EXPENSE_ITEMS.ACCOUNT_CODE,
			#dsn#.Get_Dynamic_Language(EXPENSE_ITEMS.EXPENSE_ITEM_ID,'#session.ep.language#','EXPENSE_ITEMS','EXPENSE_ITEM_DETAIL',NULL,NULL,EXPENSE_ITEMS.EXPENSE_ITEM_DETAIL) AS EXPENSE_ITEM_DETAIL,
			EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
			EXPENSE_ITEMS.IS_ACTIVE,
            EXPENSE_ITEMS.EXPENSE_ITEM_CODE,
            ACCOUNT_PLAN.ACCOUNT_NAME,
			#dsn#.Get_Dynamic_Language(EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,'#session.ep.language#','EXPENSE_CATEGORY','EXPENSE_CAT_NAME',NULL,NULL,EXPENSE_CATEGORY.EXPENSE_CAT_NAME) AS EXPENSE_CAT_NAME
		FROM
			EXPENSE_ITEMS
            	LEFT JOIN ACCOUNT_PLAN ON EXPENSE_ITEMS.ACCOUNT_CODE = ACCOUNT_PLAN.ACCOUNT_CODE
                LEFT JOIN EXPENSE_CATEGORY ON EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID
		WHERE
			EXPENSE_ITEM_ID IS NOT NULL
		<cfif len(attributes.keyword)>
			AND EXPENSE_ITEM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif len(attributes.process_type) and attributes.process_type eq 1>
			AND IS_EXPENSE = 1
		<cfelseif len(attributes.process_type) and attributes.process_type eq 0>
			AND INCOME_EXPENSE = 1
		</cfif>
		<cfif len(attributes.is_active) and attributes.is_active eq 1>
			AND IS_ACTIVE=1
		<cfelseif len(attributes.is_active) and attributes.is_active eq 0>
			AND IS_ACTIVE = 0
		</cfif>
		<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
			AND EXPENSE_CATEGORY_ID = #attributes.expense_cat#
		</cfif>
		<cfif len(attributes.acc_code)>
			AND (EXPENSE_ITEMS.ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code#"> OR EXPENSE_ITEMS.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code#.%">)
		</cfif>
		ORDER BY 
			EXPENSE_ITEM_NAME
	</cfquery>
<cfelse>
    <cfset get_expense_items.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_expense_items.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" id="form" method="post" action="#request.self#?fuseaction=budget.list_expense_item">
			<input type="hidden" name="form_exist" id="form_exist" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" placeholder="#place#" name="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></cfsavecontent>
						<cfinput type="text" name="acc_code" id="acc_code" value="#attributes.acc_code#" placeholder="#place#" onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','form','3','250');" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:open_acc_code('form.acc_code','form.acc_code','form.acc_code');" title="<cfoutput>#place#</cfoutput>"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></cfsavecontent>
						<cf_wrk_budgetCat
						name="expense_cat"
						option_text="#text#"
						value="#attributes.expense_cat#">
					</div>
				</div>
				<div class="form-group">
					<select name="process_type" id="process_type">
						<option value=""><cf_get_lang dictionary_id='57559.Bütçe'> <cf_get_lang dictionary_id='49142.Tipi'></option>
						<option value="1" <cfif attributes.process_type eq 1>selected</cfif> ><cf_get_lang dictionary_id='58678.Gider'></option>
						<option value="0" <cfif attributes.process_type eq 0>selected</cfif> ><cf_get_lang dictionary_id='58677.Gelir'></option>												
					</select>
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value=""><cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>												
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" onKeyUp="isNumber (this)" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='34181.Bütçe Kalemleri'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='49181.Kodu'></th>
					<th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
					<th><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th>
					<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=budget.list_expense_item&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_expense_items.recordcount>
					<cfoutput query="get_expense_items" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#expense_item_code#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=budget.list_expense_item&event=upd&item_id=#expense_item_id#','small');" class="tableyazi">#expense_item_name#</a></td>
							<td>#EXPENSE_CAT_NAME#</td>
							<td>#ACCOUNT_CODE# - #ACCOUNT_NAME#</td>
							<td>#expense_item_detail#</td>
							<!-- sil -->
							<td align="center">
								<a href="#request.self#?fuseaction=budget.list_expense_item&event=upd&item_id=#expense_item_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<cfif attributes.form_exist>
							<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						<cfelse>
							<td colspan="7"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
						</cfif>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		
		<cfset url_str = "">
		<cfif isdefined ("attributes.keyword") and len (attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined ("attributes.form_exist") and len (attributes.form_exist)>
			<cfset url_str = "#url_str#&form_exist=#attributes.form_exist#">
		</cfif>
		<cfif isdefined ("attributes.process_type") and len (attributes.process_type)>
			<cfset url_str = "#url_str#&process_type=#attributes.process_type#">
		</cfif>
		<cfif isdefined ("attributes.is_active") and len (attributes.is_active)>
			<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
		</cfif>
		<cfif isdefined ("attributes.expense_cat") and len (attributes.expense_cat)>
			<cfset url_str = "#url_str#&expense_cat=#attributes.expense_cat#">
		</cfif>
		<cfif isdefined ("attributes.acc_code") and len (attributes.acc_code)>
			<cfset url_str = "#url_str#&acc_code=#attributes.acc_code#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="budget.list_expense_item#url_str#">
	
	</cf_box>
</div>

<script type="text/javascript">
document.getElementById('keyword').focus();
function open_acc_code(str_alan_1,str_alan_2,str_alan)
{
	var txt_keyword = eval(str_alan_1 + ".value" );
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
}
</script>
