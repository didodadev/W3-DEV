<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.acc_code" default="">
<cfparam name="attributes.modal_id" default="">
<script type="text/javascript">
function add_pro(expense_item_id,expense_item_name)
{  
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { ROW_EXP_ITEM_ID: expense_item_id, ROW_EXP_ITEM_NAME: expense_item_name}); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
	
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfif isDefined("attributes.is_exp") and attributes.is_exp eq 1><!---satırdaki seçilen masraf merkezine bağlı gider kalemleri MK 011019 --->
	<cfset is_accounting_budget = "">
	<cfset expense_item_id_list = "0">
	<cfset account_code_list = "0">
	<cfif isDefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
		<cfquery name="EXPENSE_ROW" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
			SELECT 
				EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
				EXPENSE_CENTER_ROW.ACCOUNT_ID,
				EXPENSE_CENTER_ROW.ACCOUNT_CODE,
				EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
				EXPENSE_CENTER.IS_ACCOUNTING_BUDGET
			FROM 
				EXPENSE_CENTER,
				EXPENSE_CENTER_ROW
				LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
			WHERE 
				EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND 
				EXPENSE_CENTER_ROW.EXPENSE_ID = #attributes.expense_center_id#
			GROUP BY
				EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
				EXPENSE_CENTER_ROW.ACCOUNT_ID,
				EXPENSE_CENTER_ROW.ACCOUNT_CODE,
				EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
				EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
		</cfquery>
		<cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
			<cfset is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
			<cfset expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
			<cfset account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
		</cfif>
	</cfif>
</cfif> 
<cfquery name="GET_EXPENSE_ITEM" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT
		EI.EXPENSE_ITEM_NAME,
		EI.EXPENSE_ITEM_DETAIL,
		EI.ACCOUNT_CODE,
		<cfif fusebox.use_period eq 1>
		EI.TAX_CODE,
        </cfif>
		EI.EXPENSE_ITEM_ID,
		EI.EXPENSE_CATEGORY_ID,
		EC.EXPENSE_CAT_NAME
	FROM
		EXPENSE_ITEMS EI
        LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
	WHERE
	<cfif isDefined("is_budget_items")>
		EXPENSE_ITEM_ID IS NOT NULL
	<cfelseif isDefined("is_income")>
		INCOME_EXPENSE = 1
	<cfelse>
		IS_EXPENSE = 1
	</cfif>
		AND IS_ACTIVE=1
	<cfif len(attributes.keyword)>
		AND EXPENSE_ITEM_NAME LIKE '%#attributes.keyword#%'
	</cfif> 
	<cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
		AND EXPENSE_CATEGORY_ID = #attributes.expense_cat#
	</cfif>
	<cfif len(attributes.acc_code)>
		AND ACCOUNT_CODE = '#attributes.acc_code#'
	</cfif>
	<cfif isDefined("attributes.is_exp") and attributes.is_exp eq 1>
		<cfif len(is_accounting_budget)>
			<cfif is_accounting_budget eq 0>
				<cfif len(expense_item_id_list)>
					AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
				</cfif>
			<cfelseif is_accounting_budget eq 1>
				<cfif len(account_code_list)>
					AND (
						<cfloop list="#account_code_list#" delimiters="," index="_account_code_">					
							(
								EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
							)
							<cfif _account_code_ neq listlast(account_code_list,',') and listlen(account_code_list,',') gte 1> OR </cfif>
						</cfloop>
						)
				</cfif>
			</cfif>
		<cfelse>
			AND 1 = 2
		</cfif>		
	</cfif>
	ORDER BY
		EXPENSE_ITEM_NAME
</cfquery>
<!--- <cfdump var = "#GET_EXPENSE_ITEM#"> --->
<cfquery name="GET_EXPENSE_CAT" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT EXPENSE_CAT_ID,EXPENSE_CAT_NAME FROM EXPENSE_CATEGORY ORDER BY EXPENSE_CAT_NAME
</cfquery>

<cfparam name="attributes.totalrecords" default="#get_expense_item.recordcount#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_expense_item.recordcount#'>
<cfscript>
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	url_string = "";
	if (isdefined('attributes.function_name') and len(attributes.function_name))
		url_string = "#url_string#&function_name=#attributes.function_name#";
	if (isdefined('attributes.function_name_parameter') and len(attributes.function_name_parameter))
		url_string = "#url_string#&function_name_parameter=#attributes.function_name_parameter#";
	if (isDefined("attributes.field_cat_id") and len(attributes.field_cat_id))
		url_string = "#url_string#&field_cat_id=#attributes.field_cat_id#";
	if (isDefined("attributes.field_cat_name") and len(attributes.field_cat_name))
		url_string = "#url_string#&field_cat_name=#attributes.field_cat_name#";
	if (isDefined("attributes.expense_item_id") and len(attributes.expense_item_id))
		url_string = "#url_string#&expense_item_id=#attributes.expense_item_id#";
	if (isDefined("attributes.expense_item_name") and len(attributes.expense_item_name))
		url_string = "#url_string#&expense_item_name=#attributes.expense_item_name#";
	if (isDefined("attributes.satir") and len(attributes.satir))
		url_string = "#url_string#&satir=#attributes.satir#";
	if(isdefined("attributes.#listfirst(session.dark_mode,":").trim()#"))
		url_string = "#url_string#&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#";
</cfscript>
<cfsavecontent variable="head_">
	<cfif isDefined("is_budget_items")><cf_get_lang dictionary_id ='34181.Bütçe Kalemleri'><cfelseif isDefined("is_income")><cf_get_lang dictionary_id ='51365.Bütçe Kalemleri'><cfelse><cf_get_lang dictionary_id='51365.Bütçe Kalemleri'></cfif>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform method="post" name="search_con" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<cfoutput>
					<input type="hidden" name="field_id" id="field_id" value="<cfif isdefined("attributes.field_id")>#attributes.field_id#</cfif>">
					<input type="hidden" name="field_name" id="field_name" value="<cfif isdefined("attributes.field_name")>#attributes.field_name#</cfif>">
					<input type="hidden" name="is_exp" id="is_exp" value="<cfif isdefined("attributes.is_exp")>#attributes.is_exp#</cfif>">
					<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfif isdefined("attributes.expense_center_id")>#attributes.expense_center_id#</cfif>">
					<input type="hidden" name="expense_center_name" id="expense_center_name" value="<cfif isdefined("attributes.expense_center_name")>#attributes.expense_center_name#</cfif>">
					<cfif isdefined("is_budget_items")><input type="hidden" name="is_budget_items" id="is_budget_items" value="1"></cfif>
					<cfif isDefined("attributes.is_income")><input type="hidden" name="is_income" id="is_income" value="<cfif isdefined("attributes.is_income")>#attributes.is_income#</cfif>"></cfif>
					<cfif isDefined("attributes.field_tax_code")><input type="hidden" name="field_tax_code" id="field_tax_code" value="#attributes.field_tax_code#"></cfif>
					<cfif isDefined("attributes.field_account_no")><input type="hidden" name="field_account_no" id="field_account_no" value="#attributes.field_account_no#"></cfif>
					<cfif isDefined("attributes.field_account_no2")><input type="hidden" name="field_account_no2" id="field_account_no2" value="#attributes.field_account_no2#"></cfif>
					<cfif isDefined("attributes.field_acc_name")><input type="hidden" name="field_acc_name" id="field_acc_name" value="#attributes.field_acc_name#"></cfif>
				</cfoutput>
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" placeholder= "#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="acc_code">
					<div class="input-group">
						<cfinput type="text" name="acc_code" id="acc_code" placeholder= "#getLang('','Muhasebe Kodu',58811)#" value="#attributes.acc_code#" onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','form','3','250');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="javascript:open_acc_code('search_con.acc_code','search_con.acc_code','search_con.acc_code');"></span>
					</div>
				</div>
				<div class="form-group" id="expense_cat">
					<select name="expense_cat" id="">
						<option value=""><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'>
						<cfoutput query="get_expense_cat">
							<option value="#expense_cat_id#" <cfif attributes.expense_cat eq expense_cat_id>selected</cfif>>#expense_cat_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_con' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>		
					<th width="30"><cf_get_lang dictionary_id='57487.no'></th>
					<th>
						<cfif isDefined("is_budget_items")>
							<cf_get_lang dictionary_id='58234.bütçe kalemi'>
						<cfelseif isDefined("is_income")>
							<cf_get_lang dictionary_id='58173.gelir kalemi'>
						<cfelse>
							<cf_get_lang dictionary_id='58551.gider kalemi'>
						</cfif>
					</th>
					<th><cf_get_lang dictionary_id='58811.muhasebe kodu'></th>
					<th><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th>
					<th><cf_get_lang dictionary_id='57629.açıklama'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_expense_item.recordcount>
				<cfoutput query="get_expense_item" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif isdefined("attributes.satir") and len(attributes.satir)>
								<a href="javascript://"  onClick="add_pro('#expense_item_id#','#expense_item_name#');">#expense_item_name#</a>
							<cfelse>
								<a href="javascript://"  onClick="gonder('#expense_item_id#','#jsStringFormat(expense_item_name)#','#account_code#','#expense_category_id#','#jsStringFormat(expense_cat_name)#','#tax_code#')">#expense_item_name#</a>
							</cfif>
						</td>
						<td>#account_code#</td>
						<td>#expense_cat_name#</td>
						<td>#expense_item_detail#</td>
					</tr>		
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		
		<cfscript>
			if (isdefined("attributes.keyword"))
				url_string = "#url_string#&keyword=#attributes.keyword#";
			if (isdefined("field_id"))
				url_string = "#url_string#&field_id=#field_id#";
			if (isdefined("field_name"))
				url_string = "#url_string#&field_name=#field_name#";
			if (isdefined("attributes.is_budget_items"))
				url_string = "#url_string#&is_budget_items=#attributes.is_budget_items#";
			if (isdefined("attributes.is_income"))
				url_string = "#url_string#&is_income=#attributes.is_income#";
			if (isdefined("field_tax_code"))
				url_string = "#url_string#&field_tax_code=#field_tax_code#";
			if (isdefined("field_account_no"))
				url_string = "#url_string#&field_account_no=#field_account_no#";
			if (isdefined("field_account_no2"))
				url_string = "#url_string#&field_account_no2=#field_account_no2#";
			if (isdefined("attributes.field_acc_name") and len(attributes.field_acc_name))
				url_string = "#url_string#&field_acc_name=#attributes.field_acc_name#";
			if (len(attributes.acc_code))
				url_string = "#url_string#&acc_code=#attributes.acc_code#";
			if (len(attributes.expense_cat))
				url_string = "#url_string#&expense_cat=#attributes.expense_cat#";
			if(isdefined("attributes.#listfirst(session.dark_mode,":").trim()#"))
				url_string = "#url_string#&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#";
		</cfscript>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_list_exp_item&#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(id,name,account_no,cat_id,cat_name,tax_code)
{
	<cfif isDefined("attributes.field_cat_id") and len(attributes.field_cat_id)>
		<cfif listlen(attributes.field_cat_id,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_cat_id#").value=cat_id;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_cat_id#</cfoutput>.value=cat_id;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_cat_name") and len(attributes.field_cat_name)>
		<cfif listlen(attributes.field_cat_name,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_cat_name#").value=cat_name;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_cat_name#</cfoutput>.value=cat_name;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_id") and len(attributes.field_id)>	
		<cfif listlen(attributes.field_id,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id#").value=id;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_name") and len(attributes.field_name)>
		<cfif listlen(attributes.field_name,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").value=name;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_acc_name") and len(attributes.field_acc_name)>
		<cfif listlen(attributes.field_id,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_acc_name#").value=account_no+' - '+name;;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_acc_name#</cfoutput>.value=account_no+' - '+name;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_tax_code") and len(attributes.field_tax_code)>
		<cfif listlen(attributes.field_tax_code,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_tax_code#").value=tax_code;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tax_code#</cfoutput>.value=tax_code;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_account_no") and len(attributes.field_account_no)>
		<cfif listlen(attributes.field_account_no,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_account_no#").value=account_no;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_account_no#</cfoutput>.value=account_no;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_account_no2") and len(attributes.field_account_no2)>
		<cfif listlen(attributes.field_account_no2,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_account_no2#").value=account_no;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_account_no2#</cfoutput>.value=account_no;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.cash_control_upd") and len(attributes.cash_control_upd)>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.CASH_ACTION_TO_COMPANY_ID.value="";
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.comp_name.value="";
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.EMPLOYEE_ID.value="";
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.emp_name.value="";
	</cfif>
	
	<cfif isdefined('attributes.function_name')>
		<cfif isdefined('attributes.function_name_parameter')>		
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.function_name#(#attributes.function_name_parameter#);</cfoutput>
		<cfelse>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.function_name#();</cfoutput>
		</cfif>
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
function open_acc_code(str_alan_1,str_alan_2,str_alan)
{
	var txt_keyword = eval(str_alan_1 + ".value" );
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword);
}
</script>
