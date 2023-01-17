<!--- Bu Sayfa İnsankaynakalarıKategorisinde Butce Gider Kalemi eklemeye yariyor. --->
<!--- aNCAK EGİTİMDEDE BU KULLANILMIŞ VE SORUN OLUR EHESAP ALTINDA BU DOSYA DUZENLENİRSE İYİ OLUR--->
<cf_get_lang_set module_name="ehesap"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_expense_cat" datasource="#dsn2#">
	SELECT 
    	EXPENSE_CAT_ID, 
        EXPENSE_CAT_NAME, 
        EXPENCE_IS_HR, 
        RECORD_EMP, 
        RECORD_IP,
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    EXPENSE_CATEGORY 
    WHERE 
    	EXPENCE_IS_HR = 1
</cfquery>
<cfparam name="attributes.modal_id" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="add_expense_item" title="#iif(isDefined("attributes.draggable"),"getLang('','Gider Kalemi Ekle',53079)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_expense_item" action="#request.self#?fuseaction=ehesap.popup_add_expense_item" method="post">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-kategori">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
						<div class="col col-8 col-xs-12">
							<cfif get_expense_cat.recordcount and get_expense_cat.recordcount gt 1>
								<select name="expense_cat" id="expense_cat" >
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_expense_cat">
										<option value="#expense_cat_id#">#expense_cat_name#</option>
									</cfoutput>
								</select>
							<cfelse>
								<cfoutput>
									<input type="hidden" name="expense_cat" id="expense_cat" value="#get_expense_cat.expense_cat_id#">
									<input type="text" readonly   value="#get_expense_cat.expense_cat_name#">
								</cfoutput>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-giderKalemi">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="expense_item_name" id="expense_item_name">
						</div>
					</div>
					<cfif fusebox.use_period neq 0><!--- Eger donem yoksa muhasebe kodu da olmayacak --->
						<div class="form-group" id="item-muhasebe-kodu">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cf_wrk_account_codes form_name='add_expense_item' account_code="account_id" account_name='account_code' search_from_name='1' is_sub_acc='0' is_multi_no = '1'>									
									<input type="hidden" value="" name="account_id" id="account_id" >											
									<input type="text" value="" name="account_code" id="account_code"  onkeyup="get_wrk_acc_code_1();">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_expense_item.account_code&field_id=add_expense_item.account_id')"></span>
								</div>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-aciklama">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="expense_item_detail" id="expense_item_detail"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>



<script type="text/javascript">
function kontrol()
{
	if(document.add_expense_item.expense_cat.value== '')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57486.Kategori'>");
		return false;
	}
	if(document.add_expense_item.expense_item_name.value=='')
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58551.Gider Kalemi'>");
		return false;
	}
	<cfif isdefined("attributes.draggable")>
		loadPopupBox('add_expense_item' , <cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
	<cfelse>
		return true;
	</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

