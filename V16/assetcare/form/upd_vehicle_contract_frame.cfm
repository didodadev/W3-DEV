<cfinclude template="../query/get_money.cfm">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="get_assetp_contract" datasource="#dsn#">
	SELECT 
        ASSETP_ID, 
        RENT_AMOUNT, 
        RENT_AMOUNT_CURRENCY, 
        RENT_PAYMENT_PERIOD, 
        RENT_START_DATE, 
        RENT_FINISH_DATE, 
        FUEL_EXPENSE, 
        CARE_EXPENSE,
        FUEL_AMOUNT, 
        FUEL_AMOUNT_CURRENCY, 
        CARE_AMOUNT, 
        CARE_AMOUNT_CURRENCY, 
        STATUS, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	ASSET_P_RENT 
    WHERE 
    	ASSETP_ID = #attributes.assetp_id# AND STATUS = 1	
</cfquery>
<cf_medium_list_search title="#getLang('assetcare',491)# #getLang('main',1656)# : #get_assetp.assetp# #images_#"></cf_medium_list_search>
<cfform name="upd_contract" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_contract" onsubmit="return(unformat_fields());">
<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
	<table style="float:left; margin-left:5px;">
		<tr>
			<td class="txtboldblue" colspan="2"><cf_get_lang no='332.Kira Bilgileri'></td>
		</tr>
		<tr> 
			<td style="width:150px"><cf_get_lang no='333.Kira Tutarı'>(<cf_get_lang no='785.KDV Hariç'>)</td>
			<td><cfinput type="text" name="rent_amount" style="width:112px;" value="#tlformat(get_assetp_contract.rent_amount)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox"> 
				<select name="rent_amount_currency" id="rent_amount_currency" style="width:60px;">
				  <cfoutput query="get_money"> 
					<option value="#money#" <cfif money eq get_assetp_contract.rent_amount_currency>selected</cfif>>#money#</option>
				  </cfoutput>
				</select>
			</td>
		</tr>
		<tr> 
			<td><cf_get_lang no='334.Ödeme Periyodu'></td>
			<td><select name="rent_payment_period" id="rent_payment_period" style="width:175px;">
					<option value=""></option>
					<option value="1" <cfif get_assetp_contract.rent_payment_period eq 1>selected</cfif>><cf_get_lang_main no='1046.Haftalık'></option>
					<option value="2" <cfif get_assetp_contract.rent_payment_period eq 2>selected</cfif>><cf_get_lang_main no='1520.Aylık'></option>
					<option value="3" <cfif get_assetp_contract.rent_payment_period eq 3>selected</cfif>>3 <cf_get_lang_main no='1520.Aylık'></option>
					<option value="4" <cfif get_assetp_contract.rent_payment_period eq 4>selected</cfif>><cf_get_lang_main no='1603.Yıllık'></option>
				</select>
			</td>
		</tr>
		<tr> 
			<td><cf_get_lang no='337.Kiralama Süresi'></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent> 
			<cfinput type="text" name="rent_start_date" value="#dateformat(get_assetp_contract.rent_start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px"> 
			<cf_wrk_date_image date_field="rent_start_date"> 
			<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
			<cfinput type="text" name="rent_finish_date" value="#dateformat(get_assetp_contract.rent_finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px"> 
			<cf_wrk_date_image date_field="rent_finish_date"></td>
		</tr>					
		<tr>
			<td></td>
		</tr>
		<tr>
			<td class="txtboldblue" colspan="2"><cf_get_lang no='339.Masraf Bilgileri'></td>
			<td class="txtboldblue" style="display:none;" id="limit"><cf_get_lang no='341.Üst Limit'></td>
		</tr>
		<tr>
			<td><cf_get_lang no='345.Yakıt Masrafı'></td>
			<td>
				<table>
					<tr>
						
						<td><input name="is_fuel_added" id="is_fuel_added" type="radio" value="0" <cfif get_assetp_contract.fuel_expense eq 0>checked</cfif> onClick="show_hide(fuel);"><cf_get_lang no='342.Hariç'></td>
						<td><input name="is_fuel_added" id="is_fuel_added" type="radio" value="2" <cfif get_assetp_contract.fuel_expense eq 2>checked</cfif> onClick="show_hide(fuel);"><cf_get_lang no='536.Limitsiz'></td>
						<td><input name="is_fuel_added" id="is_fuel_added" type="radio" value="1" <cfif get_assetp_contract.fuel_expense neq 0 and get_assetp_contract.fuel_expense neq 2 >checked</cfif> onClick="show_hide(fuel);"><cf_get_lang no='343.Dahil'></td>
					</tr>
				</table>
			</td>
			<td id="fuel" <cfif get_assetp_contract.fuel_expense eq 0 or get_assetp_contract.fuel_expense eq 2>style="display:none;"</cfif>>
				<input type="text" name="fuel_amount" id="fuel_amount" value="<cfoutput>#tlformat(get_assetp_contract.fuel_amount)#</cfoutput>" style="width:112px;" onKeyUP="FormatCurrency(this,event);" class="moneybox"> 
				<select name="fuel_amount_currency" id="fuel_amount_currency" style="width:60px;">                        
					<cfoutput query="get_money"> 
						<option value="#money#"<cfif money eq get_assetp_contract.fuel_amount_currency>selected</cfif>>#money#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr> 
			<td style="width:65px;"><cf_get_lang no='344.Bakım Masrafı'></td>
			<td>
				<table>
					<tr>
						
						<td><input name="is_care_added" id="is_care_added" type="radio" value="0" <cfif get_assetp_contract.care_expense eq 0>checked</cfif> onClick="show_hide(care);" ><cf_get_lang no='342.Hariç'></td>
						<td><input name="is_care_added" id="is_care_added" type="radio" value="2" <cfif get_assetp_contract.care_expense eq 2>checked</cfif> onClick="show_hide(care);" ><cf_get_lang no='536.Limitsiz'></td>
						<td><input name="is_care_added" id="is_care_added" type="radio" value="1" <cfif get_assetp_contract.care_expense neq 0 and get_assetp_contract.care_expense neq 2 >checked</cfif> onClick="show_hide(care);"><cf_get_lang no='343.Dahil'></td>
					</tr>
				</table>
			</td>
			<td id="care" <cfif get_assetp_contract.care_expense eq 0 or get_assetp_contract.care_expense eq 2>style="display:none;"</cfif>>
			 <input type="text" name="care_amount" id="care_amount" value="<cfoutput>#tlformat(get_assetp_contract.care_amount)#</cfoutput>" style="width:112px;" onKeyUp="FormatCurrency(this,event);" class="moneybox"> 
			 <select name="care_amount_currency" id="care_amount_currency" style="width:60px;">                         
				 <cfoutput query="get_money"> 
					<option value="#money#" <cfif money eq get_assetp_contract.care_amount_currency>selected</cfif>>#money#</option>
				 </cfoutput>
			 </select>
			</td>
		</tr>
	</table>
      <table width="100%">
    	<tr>
        	<td>
            	<cf_popup_box_footer>
                    <cf_record_info query_name="get_assetp_contract">
                    <cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0' is_delete='0'></td>
                </cf_popup_box_footer>
            </td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
function unformat_fields()
{
	document.upd_contract.rent_amount.value = filterNum(document.upd_contract.rent_amount.value);
	document.upd_contract.fuel_amount.value = filterNum(document.upd_contract.fuel_amount.value);
	document.upd_contract.care_amount.value = filterNum(document.upd_contract.care_amount.value);
}
	
function show_hide()
{
	if(document.upd_contract.is_care_added[0].checked)
	{
		gizle(care);
		document.upd_contract.care_amount.value = "" ;				
		document.upd_contract.care_amount_currency.selectedIndex = "";		
	}
	
	if(document.upd_contract.is_care_added[1].checked)
	{
		gizle(care);
		document.upd_contract.care_amount.value = "" ;				
		document.upd_contract.care_amount_currency.selectedIndex = "";		
	}
	
	if(document.upd_contract.is_care_added[2].checked)
	{
		goster(care);
	}
	
	if(document.upd_contract.is_fuel_added[0].checked)
	{
		gizle(fuel);
		document.upd_contract.fuel_amount.value = "" ;
		document.upd_contract.fuel_amount_currency.selectedIndex = "";			
	}
	
	if(document.upd_contract.is_fuel_added[1].checked)
	{
		gizle(fuel);
		document.upd_contract.fuel_amount.value = "" ;
		document.upd_contract.fuel_amount_currency.selectedIndex = "";			
	}
	if(document.upd_contract.is_fuel_added[2].checked)
		goster(fuel);			
	
	if(document.upd_contract.is_care_added[2].checked || document.upd_contract.is_fuel_added[2].checked)
		goster(limit);
	else
		gizle(limit);
}
</script>
