<cf_box title="#getLang('main',1344)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">  
	<cfform name="add_bill_other" action="#request.self#?fuseaction=account.emptypopup_add_bill_opening_other" method="post">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<cf_box_elements>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id="61806.İşlem Tipi">*</label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cf_workcube_process_cat slct_width="180px;">
				</div> 				
			</div>
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='57629.Açıklama'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<textarea name="bill_detail" id="bill_detail" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" ></textarea>
				</div>				
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='control()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function control()
{
	if(!document.getElementById("process_cat").value)
	{	alert("<cf_get_lang dictionary_id ='815.Lütfen İşlem Tipi Seçiniz'>!");
		return false;
	}
	if (!chk_process_cat('add_bill_other')) return false;
	var get_default_process_ = wrk_safe_query('new_control_process','dsn3');
	var selected_ptype = document.add_bill_other.process_cat.options[document.add_bill_other.process_cat.selectedIndex].value;
	if(selected_ptype.length && get_default_process_.PROCESS_CAT_ID==selected_ptype)
	{
		var get_default_acc_card = wrk_safe_query('acc_ctrl_card','dsn2',0,get_default_process_.PROCESS_CAT_ID);
		if(get_default_acc_card.recordcount)
		{
			alert("<cf_get_lang dictionary_id ='816.Default İşlem Kategorisi Seçilemez'>!");
			return false;
		}
	}
}
</script>
