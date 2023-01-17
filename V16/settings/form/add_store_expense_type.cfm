<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42769.Şube Harcama Tipleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_store_expense_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_store_expense_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform method="post" name="add_expense_type" action="#request.self#?fuseaction=settings.emptypopup_add_store_expense_type">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="cat-name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="Text" name="expense_type" value="" maxlength="100" required="Yes" message="#getLang('','Kategori Adı Girmelisiniz',58555)#!">							
							</div>	
						</div>
						<div class="form-group" id="account-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="account_code" value="" readonly maxlength="100">
									<span class="input-group-addon icon-ellipsis btnPointer" alt="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_expense_type.account_code');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="account-name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="expense_type_detail" id="expense_type_detail" maxlength="100"></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='sayfa_kontrol()'>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
	function sayfa_kontrol()
	{
		if (session.ep.period_is_integrated == 1)
		{
			if (document.add_expense_type.account_code =='')
			{
				alert("<cf_get_lang dictionary_id ='43840.Lütfen Muhasebe Kodu Seçiniz'> !");
				return false;
			}
		}
		return true;
	}
</script>



