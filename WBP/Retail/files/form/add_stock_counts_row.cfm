
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_form" action="">
			<cfinput type="hidden" name="order_id" value="#attributes.order_id#"/>
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-keyword">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="text" name="keyword" id="keyword" style="width:300px;" onkeyup="islem_yap();"/>
                        </div>
                    </div>
					<div id="action_div" style="height:300px; display:none; overflow:auto;"></div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd="0">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>


<script>
function islem_yap()
{
	deger_ = document.getElementById('keyword').value.replace("%"," ");
	
	if(deger_.length >= 3)
	{
		show('action_div');
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_product_names&type=2&keyword=</cfoutput>' + deger_,'action_div',1);	
	}
}
document.getElementById('keyword').focus();
</script>