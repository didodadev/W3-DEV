<cfinclude template="../query/get_money.cfm">
<cfquery name="get_solds" datasource="#dsn#">
	SELECT
		ASSET_P_SOLD.ASSET_P_SOLD_ID,
		ASSET_P_SOLD.ASSETP_ID,
		ASSET_P_SOLD.MIN_PRICE,
		ASSET_P_SOLD.MAX_PRICE,
		ASSET_P_SOLD.MAX_MONEY,
		ASSET_P_SOLD.MIN_MONEY,
		ASSET_P_SOLD.REQUEST_ID,
		ASSET_P_SOLD.REQUEST_ROW_ID,
		ASSET_P_SOLD.RECORD_EMP,
		ASSET_P_SOLD.RECORD_DATE,
		ASSET_P_SOLD.UPDATE_EMP,
		ASSET_P_SOLD.UPDATE_DATE,
		ASSET_P.ASSETP
	FROM
		ASSET_P_SOLD,
		ASSET_P
	WHERE
		ASSET_P_SOLD.ASSETP_ID = ASSET_P.ASSETP_ID AND
		ASSET_P_SOLD.ASSET_P_SOLD_ID = #attributes.sold_id#
</cfquery>
<!--- <cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_sales_price_proposition</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang dictionary_id='170.Ekle'>" title="<cf_get_lang dictionary_id='170.Ekle'>"></a></cfsavecontent> --->

<cf_box title="#getLang('','Fiyat Önerisi',32086)# #getLang('','Güncelle',57464)#" add_href="#request.self#?fuseaction=assetcare.popup_add_sales_price_proposition">
<cfform name="upd_price_proposition" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_sales_price_proposition" onsubmit="return(unformat_fields());">        
<input type="hidden" name="sold_id" id="sold_id" value="<cfoutput>#attributes.sold_id#</cfoutput>">
<cf_box_elements>	
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="branch_id">
			<label class="col col-4 col-xs-12">
				<cf_get_lang dictionary_id='51100.Talep'>/<cf_get_lang dictionary_id='55657.Sıra No'>
			</label>
			<div class="col col-8 col-xs-12">

				<div class="col col-6">
					<td><cfinput type="text" style="width:98;" name="request_id" value="#get_solds.request_id#" readonly>
				</div>
				<div class="col col-6">
					<div class="input-group">
						<cfinput type="text" name="request_row_id" value="#get_solds.request_row_id#" readonly style="width:98px;">
						<span class="input-group-addon icon-ellipsis" onClick="request_selected(); windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_vehicles&field_assetp_id=upd_price_proposition.assetp_id&field_assetp_name=upd_price_proposition.assetp_name&field_request_id=upd_price_proposition.request_id&field_request_row_id=upd_price_proposition.request_row_id&list_select=2','list');"></span>
					</div>
				</div>
			</div>
			
		</div>
		<div class="form-group" id="branch_id">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'> *</label>
			<div class="col col-8 col-xs-12 ">
				<div class="input-group">
					<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_solds.assetp_id#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58480.Araç'></cfsavecontent>
						<cfinput type="text" name="assetp_name" required="yes" message="#message#" value="#get_solds.assetp#" readonly style="width:200px;">
						<span class="input-group-addon icon-ellipsis" onClick="asset_selected(); windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_price_proposition.assetp_id&field_name=upd_price_proposition.assetp_name&list_select=2','list');"></span>
				</div>
			</div>
		</div>

		<div class="form-group" id="branch_id">
			<label class="col col-4 col-xs-12">
				<cf_get_lang dictionary_id='48168.Min Fiyat'> *
			</label>
			<div class="col col-8 col-xs-12">

				<div class="col col-8">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='48168.Min Fiyat'></cfsavecontent>
					<cfinput type="text" name="min_price" value="#tlformat(get_solds.min_price)#" class="moneybox" required="yes" message="#message#" onKeyup="return(FormatCurrency(this,event));" style="width:125px;">
					</div>
				<div class="col col-4">
					<select name="min_currency" id="min_currency">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_money">
							<option value="#money#" <cfif get_solds.min_money eq money>selected</cfif>>#money#</option>
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
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='48169.Max Fiyat'></cfsavecontent>
							<cfinput type="text" name="max_price" value="#tlformat(get_solds.max_price)#" class="moneybox" required="yes" message="#message#" onKeyup="return(FormatCurrency(this,event));" style="width:125px;">
					</div>
					<div class="col col-4">
						<select name="max_currency" id="max_currency" >
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_money">
								<option value="#money#" <cfif get_solds.max_money eq money>selected</cfif>>#money#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
		</div>

</cf_box_elements>	

		<cf_box_footer>
			<cf_record_info query_name="get_solds">
			<cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'>
		</cf_box_footer>

</cfform>
</cf_box>
<script type="text/javascript">
function unformat_fields()
{
	upd_price_proposition.min_price.value = filterNum(upd_price_proposition.min_price.value);
	upd_price_proposition.max_price.value = filterNum(upd_price_proposition.max_price.value);
}
function kontrol()
{
	unformat_fields();
	x = document.upd_price_proposition.min_currency.selectedIndex;
	if (document.upd_price_proposition.min_currency[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48470.Lütfen (Min Tutar) Para Birimi Seçiniz'> !");
		return false;
	}
	y = document.upd_price_proposition.max_currency.selectedIndex;
	if (document.upd_price_proposition.max_currency[y].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48471.Lütfen (Max Tutar) Para Birimi Seçiniz'> !");
		return false;
	}	
	
	a = filterNum(document.upd_price_proposition.min_price.value);
	b = filterNum(document.upd_price_proposition.max_price.value);
	if (a>b)
	{
		alert ("<cf_get_lang dictionary_id='48472.Fiyat Aralığını Kontrol Ediniz'> !");
		return false;
	}
	return true;
}
function request_selected()
{
	if(document.upd_price_proposition.request_id.value!='')
	{
		document.upd_price_proposition.request_id.value='';
		document.upd_price_proposition.request_row_id.value='';
		document.upd_price_proposition.assetp_id.value='';
		document.upd_price_proposition.assetp_name.value='';

	}
}
function asset_selected()
{
	if(document.upd_price_proposition.assetp_id.value!='')
	{
		document.upd_price_proposition.assetp_id.value='';
		document.upd_price_proposition.assetp_name.value='';
		document.upd_price_proposition.request_id.value='';
		document.upd_price_proposition.request_row_id.value='';
	}
}
</script>
