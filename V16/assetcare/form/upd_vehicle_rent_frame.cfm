<cfinclude template="../query/get_money.cfm">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_ASSETP_RENT" datasource="#DSN#">
	SELECT 
		RENT_AMOUNT,
		RENT_AMOUNT_CURRENCY,
		RENT_PAYMENT_PERIOD,
		RENT_START_DATE,
		RENT_FINISH_DATE,
		RECORD_DATE,
		UPDATE_DATE,
		UPDATE_EMP,
		RECORD_EMP
	FROM 
		ASSET_P_RENT
	WHERE	
		ASSETP_ID = #attributes.assetp_id# AND
		STATUS = 1
</cfquery>
<cf_medium_list_search title="#getLang('assetcare',332)# #getLang('main',1656)# : #get_assetp.assetp# #images_#"></cf_medium_list_search>
<cfform name="upd_rent" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_rent">
<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">					
	<table style="float:left; margin-left:5px;">
		<tr> 
			<td width="130"><cf_get_lang no='333.Kira Tutarı'>(<cf_get_lang no='785.KDV Hariç'>)</td>
			<td><cfinput type="text" name="rent_amount" style="width:112px;" value="#tlformat(get_assetp_rent.rent_amount)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox"> 
			<select name="rent_amount_currency" id="rent_amount_currency" style="width:60px;">			
				<cfoutput query="get_money"> 
				<cfif get_assetp_rent.rent_amount_currency eq 'YTL'><cfset curr = 'TL'><cfelse><cfset curr = get_assetp_rent.rent_amount_currency></cfif>
					<option value="#money#" <cfif money eq curr>selected</cfif>>#money#</option>
				</cfoutput>
			</select></td>
		</tr>
		<tr> 
			<td><cf_get_lang no='334.Ödeme Periyodu'></td>
			<td><select name="rent_payment_period" id="rent_payment_period" style="width:175px;">
					<option value=""></option>
					<option value="1" <cfif get_assetp_rent.rent_payment_period eq 1>selected</cfif>><cf_get_lang_main no='1046.Haftalık'></option>
					<option value="2" <cfif get_assetp_rent.rent_payment_period eq 2>selected</cfif>><cf_get_lang_main no='1520.Aylık'></option>
					<option value="3" <cfif get_assetp_rent.rent_payment_period eq 3>selected</cfif>>3<cf_get_lang_main no='1520.Aylık'></option>
					<option value="4" <cfif get_assetp_rent.rent_payment_period eq 4>selected</cfif>><cf_get_lang_main no='1603.Yıllık'></option>
				</select>
			</td>
		</tr>
		<tr> 
			<td><cf_get_lang no='337.Kiralama Süresi'></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='337.Kiralama süresi'> !</cfsavecontent> 
				<cfinput type="text" name="rent_start_date" value="#dateformat(get_assetp_rent.rent_start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px"> 
				<cf_wrk_date_image date_field="rent_start_date">
				<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='337.Kiralama süresi'> !</cfsavecontent>
				<cfinput type="text" name="rent_finish_date" value="#dateformat(get_assetp_rent.rent_finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px"> 
				<cf_wrk_date_image date_field="rent_finish_date"></td>
		</tr>
	</table>
    <table width="100%">
    	<tr>
        	<td>
                <cf_popup_box_footer>
                    <cf_record_info query_name="get_assetp_rent">
                    <cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' is_delete='0' add_function='unformat_fields()'></td>
                </cf_popup_box_footer>  
            </td>
        </tr>
    </table>
               
</cfform>
<script type="text/javascript">
function unformat_fields()
{
	document.upd_rent.rent_amount.value = filterNum(document.upd_rent.rent_amount.value);
	
}
</script>

