<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="get_detail_offer" datasource="#dsn#">
	SELECT 
    	DEMAND_OFFER_ID, 
        DEMAND_ID, 
        COMPANY_ID, 
        PARTNER_ID, 
        CONSUMER_ID, 
        EMPLOYEE_ID, 
        OFFER_TOTAL, 
        OFFER_MONEY, 
        DELIVER_DATE, 
        DELIVER_ADDRES, 
        PAYMETHOD, 
        SHIP_METHOD, 
        OFFER_FILE, 
        OFFER_FILE_SERVER_ID, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_MEMBER, 
        RECORD_MEMBER_TYPE, 
        UPDATE_DATE, 
        UPDATE_MEMBER, 
        UPDATE_MEMBER_TYPE, 
        UPDATE_IP, 
        OFFER_STAGE 
    FROM 
    	WORKNET_DEMAND_OFFER 
    WHERE 
    	DEMAND_OFFER_ID = #attributes.demand_offer_id#
</cfquery>
<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
<cfset getDemand = cmp.getDemand(demand_id:get_detail_offer.demand_id) />
<cfform name="upd_demand_offer" action="#request.self#?fuseaction=worknet.emptypopup_upd_demand_offer" method="post" enctype="multipart/form-data">
<input type="hidden" name="demand_offer_id" id="demand_offer_id" value="<cfoutput>#attributes.demand_offer_id#</cfoutput>">
<input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#get_detail_offer.demand_id#</cfoutput>">
<input type="hidden" name="old_offer_file" id="old_offer_file" value="<cfoutput>#get_detail_offer.offer_file#</cfoutput>">
<input type="hidden" name="old_offer_file_server_id" id="old_offer_file_server_id" value="<cfoutput>#get_detail_offer.offer_file_server_id#</cfoutput>">
<div style="display:none;"><cf_workcube_process is_upd='0' select_value='#get_detail_offer.offer_stage#' is_detail='1'></div>
<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
	<tr height="30">
		<td class="headbold"><cfoutput>#getDemand.fullname# / #getDemand.demand_head#</cfoutput></td>
	</tr>
	<tr valign="top">
		<td>
			<table border="0">  
				<cfoutput query="get_detail_offer">
					<tr>
						<td><cf_get_lang no ='106.Toplam Bedel'></td>
						<td>
							<cfinput type="text" name="total_amount" maxlength="38" style="width:100px; float:left;" value="#Tlformat(get_detail_offer.offer_total)#" passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
							<cfquery name="get_moneys" datasource="#dsn2#">
								SELECT MONEY_ID,MONEY FROM SETUP_MONEY
							</cfquery>
							<select name="money" style="width:50px;">
							  <cfloop query="get_moneys">
								<option value="#get_moneys.money#"<cfif get_moneys.money eq get_detail_offer.offer_money>selected</cfif>>#get_moneys.money#</option>
							  </cfloop>
							</select>
						</td>				
					</tr>
					<tr>
						<td><cf_get_lang_main no='233.Teslim Tarihi'></td>
						<td><input type="hidden" name="today" id="today" value="<cfoutput>#dateformat(get_detail_offer.record_date,dateformat_style)#</cfoutput>" />
							<input type="text" name="deliver_date" id="deliver_date" value="#dateformat(deliver_date,dateformat_style)#" maxlength="10" style="width:100px;">
							<cf_wrk_date_image date_field="deliver_date">
						</td>				
					</tr>
					<tr>
						<td><cf_get_lang_main no='1037.Teslim Yeri'></td>
						<td><input type="text" name="deliver_addres" id="deliver_addres" value="<cfif len(deliver_addres)>#deliver_addres#</cfif>" style="width:100px;" maxlength="250"></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no ='1104.Ödeme Yöntemi'></td>
						<td><input type="text" name="paymethod" id="paymethod" value="<cfif len(paymethod)>#paymethod#</cfif>" style="width:100px;" maxlength="250"></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
						<td><input type="text" name="ship_method" id="ship_method" value="<cfif len(ship_method)>#ship_method#</cfif>" style="width:100px;" maxlength="250"></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no ='56.Belge'></td>
						<td><input type="file" name="offer_file" id="offer_file" style="width:165px;">
							<cfif len(get_detail_offer.offer_file)>
								<cf_get_server_file output_file="worknet/#get_detail_offer.offer_file#" output_server="#get_detail_offer.offer_file_server_id#" output_type="2" image_link="1" small_image="/images/asset.gif" image_width="17" image_height="19">
							</cfif>
						</td>
					</tr>
					<cfif len(get_detail_offer.offer_file)>
					<tr>
						<td><cf_get_lang_main no="56.Belge"> <cf_get_lang_main no="51.Sil"></td>
						<td><input type="checkbox" name="del_file" id="del_file" value=""></td>
					</tr>
					</cfif>
					<tr valign="top">
						<td><cf_get_lang_main no ='217.Açıklama'></td>
						<td><textarea name="detail" id="detail" style="width:200px; height:80px;">#detail#</textarea></td>
					</tr>
					<tr>
						<td></td>
						<!--- delete_page_url='#request.self#?fuseaction=worknet.emptypopup_del_demand_offer&demand_offer_id=#attributes.demand_offer_id#' --->
						<td height="35"><cf_workcube_buttons is_upd='1' is_delete="0" add_function="kontrol()"></td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
function kontrol()
{
	document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value);
	if(document.getElementById('deliver_date').value != "")
	{
		if (!date_check_hiddens(document.getElementById('today'), document.getElementById('deliver_date'), "Teslim tarihi kayıt tarihinden önce olamaz!"))
			return false;
	}
	if(document.getElementById('detail').value == '')
		{	
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='217.Açiklama'>!");
			return false;
		}
	
	return true;
}
</script>


