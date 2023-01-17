<cfparam name="attributes.min_price" default="">
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_SOLD" datasource="#DSN#">
	SELECT ASSET_P_SOLD_ID FROM ASSET_P_SOLD
</cfquery>
<cfif get_sold.recordcount>
	<cfset max_id = get_sold.asset_p_sold_id>
<cfelse>
	<cfset max_id = 0>
</cfif>
<cf_box title="#getLang('','Fiyat Önerisi',32086)#">
	<cfform name="add_price_proposition" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_sales_price_proposition" onsubmit="return(unformat_fields());">
<cf_box_elements>
	<input type="hidden" name="old_min_price" id="old_min_price" value="">
	<input type="hidden" name="old_max_price" id="old_max_price" value="">	
	
		
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="branch_id">
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='51100.Talep'>/<cf_get_lang dictionary_id='55657.Sıra No'>
				</label>
				<div class="col col-8 col-xs-12">

					<div class="col col-6">
						<input type="text" name="request_id" id="request_id" value="" readonly >
					</div>
					<div class="col col-6">
						<div class="input-group">
							<input type="text" name="request_row_id" id="request_row_id" value="" readonly >
							<span class="input-group-addon icon-ellipsis" onClick="request_selected(); windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_vehicles&field_assetp_id=add_price_proposition.assetp_id&field_assetp_name=add_price_proposition.assetp_name&field_request_id=add_price_proposition.request_id&field_request_row_id=add_price_proposition.request_row_id&list_select=2','wide','popup_list_sales_vehicles');"></span>
						</div>
					</div>
				</div>
				
			</div>
			<div class="form-group" id="branch_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'> *</label>
				<div class="col col-8 col-xs-12 ">
					<div class="input-group">
						<input type="hidden" name="assetp_id" id="assetp_id" value="">
				<cfsavecontent variable="arac"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58480.Araç'></cfsavecontent>
				<cfinput type="text" name="assetp_name" required="yes" message="#arac#" readonly style="width:200px;">
				<span class="input-group-addon icon-ellipsis" onClick="asset_selected(); windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_price_proposition.assetp_id&field_name=add_price_proposition.assetp_name&list_select=2','list','popup_list_ship_vehicles');"> </span>
			
					</div>
				</div>
			</div>

			<div class="form-group" id="branch_id">
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='48168.Min Fiyat'> *
				</label>
				<div class="col col-8 col-xs-12">

					<div class="col col-8">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48168.Min Fiyat'>!</cfsavecontent>
							<cfinput type="text" name="min_price" value="#tlformat(attributes.min_price)#" required="yes" message="#message#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:125px;">
					</div>
					<div class="col col-4">
						<select name="min_currency" id="min_currency">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_money">
							<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
							</cfoutput>
							</select>
					</div>
				</div>
			</div>
				<div class="form-group" id="branch_id">
					<label class="col col-4 col-xs-12">
						<cf_get_lang dictionary_id='48169.Max Fiyat'>*
					</label>
					<div class="col col-8 col-xs-12">
	
						<div class="col col-8">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48169.Max Fiyat'>!</cfsavecontent>
								<cfinput type="text" name="max_price" required="yes" message="#message#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:125px;">
						</div>
						<div class="col col-4">
							<select name="max_currency" id="max_currency" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_money">
								<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
								</cfoutput>
								</select>
						</div>
					</div>
				</div>
			</div>

</cf_box_elements>	
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
		</cf_box_footer>

	</cfform>
</cf_box>


<script type="text/javascript">
	function unformat_fields()
	{
		add_price_proposition.min_price.value = filterNum(add_price_proposition.min_price.value);
		add_price_proposition.max_price.value = filterNum(add_price_proposition.max_price.value);
	}
	function kontrol()
	{
		unformat_fields();
		x = document.add_price_proposition.min_currency.selectedIndex;
		if (document.add_price_proposition.min_currency[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='48168.Min Fiyat'>");
			return false;
		}
		y = document.add_price_proposition.max_currency.selectedIndex;
		if (document.add_price_proposition.max_currency[y].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='48169.Max Fiyat'>");
			return false;
		}
		
		a = filterNum(document.add_price_proposition.min_price.value);
		b = filterNum(document.add_price_proposition.max_price.value);
		if (a>b)
		{
			alert ("<cf_get_lang dictionary_id='48472.Fiyat Aralığını Kontrol Ediniz'> !");
			return false;
		}
		return true;
	}
	function request_selected()
	{
		if(document.add_price_proposition.request_id.value!='')
		{
			document.add_price_proposition.request_id.value='';
			document.add_price_proposition.request_row_id.value='';
			document.add_price_proposition.assetp_id.value='';
			document.add_price_proposition.assetp_name.value='';
	
		}
	}
	function asset_selected()
	{
		if(document.add_price_proposition.assetp_id.value!='')
		{
			document.add_price_proposition.assetp_id.value='';
			document.add_price_proposition.assetp_name.value='';
			document.add_price_proposition.request_id.value='';
			document.add_price_proposition.request_row_id.value='';
		}
	}
</script>
