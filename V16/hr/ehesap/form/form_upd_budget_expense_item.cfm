<cfinclude template="../query/get_expense_item_static_cat.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="upd_expense_item" title="#iif(isDefined("attributes.draggable"),"getLang('','Gider Kalemi Güncelle',53206)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="upd_expense_item" action="#request.self#?fuseaction=ehesap.emptypopup_upd_expense_item" method="post">
			<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#url.item_id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-kategori">	
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
						<div class="col col-8 col-xs-12">
							<cfif get_expense_item_sta.recordcount and get_expense_item_sta.recordcount gt 1>
								<select name="expense_cat" id="expense_cat">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_expense_item_sta">
										<option value="#expense_cat_id#" <cfif GET_EXPENSE_ITEM_STA.EXPENSE_CATEGORY_ID eq expense_cat_id>selected</cfif>>#expense_cat_name#</option>
									</cfoutput>
								</select>
							<cfelse>
								<input type="hidden" name="expense_cat" id="expense_cat"  value="<cfoutput>#get_expense_item_sta.expense_cat_id#</cfoutput>">
								<input type="text" readonly value="<cfoutput>#get_expense_item_sta.expense_cat_name#</cfoutput>">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-giderKalemi">	
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="expense_item_name" id="expense_item_name"   value="<cfoutput>#GET_EXPENSE_ITEM_STA.EXPENSE_ITEM_NAME#</cfoutput>"/>
							<input type="hidden" name="item_id" id="item_id" value="<cfoutput>#url.item_id#</cfoutput>"/>
						</div>
					</div>
					<cfif fusebox.use_period neq 0><!--- Eger donem yoksa muhasebe kodu da olmayacak --->
						<div class="form-group" id="item-muhasebe-kodu">	
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>
							</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cf_wrk_account_codes form_name='upd_expense_item' account_code="account_id" account_name='account_code' search_from_name='1' is_sub_acc='0' is_multi_no = '1'>
									<input type="hidden" name="account_id" id="account_id"  value="<cfoutput>#get_expense_item_sta.account_code#</cfoutput>">
									<cfset attributes.account_code = get_expense_item_sta.account_code>
									<cfinclude template="../query/get_account_name.cfm">
									<input type="text" name="account_code" id="account_code" value="<cfoutput>#get_account_name.account_name#</cfoutput>"  onkeyup="get_wrk_acc_code_1();">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_expense_item.account_code&field_id=upd_expense_item.account_id')"></span>
								</div>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-aciklama">	
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="expense_item_detail" id="expense_item_detail"><cfoutput>#get_expense_item_sta.expense_item_detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_expense_item_sta">
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ehesap.list_expense_item&event=del&item_id=#url.item_id#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>




<script type="text/javascript">
function kontrol()
{
	if(document.upd_expense_item.expense_cat.value== '')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57486.Kategori'>");
		return false;
	}
	if(document.upd_expense_item.expense_item_name.value=='')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58551.Gider Kalemi'>");
		return false;
	}
	<cfif isdefined("attributes.draggable")>
		loadPopupBox('upd_expense_item' , <cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
	<cfelse>
		return true;
	</cfif>
}
</script>

