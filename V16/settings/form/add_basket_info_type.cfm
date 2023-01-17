<cfquery name="GET_BASKET" datasource="#DSN3#">
	SELECT 
    	BASKET_ID, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    SETUP_BASKET 
    ORDER BY 
    	BASKET_ID 
</cfquery>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('settings',808,42791)#" add_href="#request.self#?fuseaction=settings.add_basket_info_type"><!--- Basket Ek Tanımları --->
		<cfform name="add_info_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_basket_info_type">			
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_basket_info_types.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-extra_info_type">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43747.Ek Tanım'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='43748.Ek Tanım Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="extra_info_type"  value="" maxlength="100" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-option_number">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='59359.Görüntüleneceği Yer'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="option_number" id="option_number">
									<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1" selected><cf_get_lang dictionary_id='42791.Basket Ek Tanım'> 1</option>
									<option value="2"><cf_get_lang dictionary_id='42791.Basket Ek Tanım'> 2</option>
									<option value="3"><cf_get_lang dictionary_id='57708.Tümü'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-basket_detail">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfinput type="text" name="basket_detail" value="" maxlength="100">
							</div>
						</div>
						<div class="form-group" id="item-basket_id">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='61296.Basket Şablonu'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="basket_id" id="basket_id" style="width=200px;height:100px;" multiple>
									<cfoutput query="get_basket">
										<option value="#get_basket.basket_id#" selected>#get_basket_name(get_basket.basket_id)#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' is_reset='0' add_function='control()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	function control()
	{
		if(document.add_info_type.extra_info_type.value=='')
		{
			alert("<cf_get_lang dictionary_id='43748.Ek Tanım Girmelisiniz'>!");
			return false;
		}
		else
			return true;
}
</script>
