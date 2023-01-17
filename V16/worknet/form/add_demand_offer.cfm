<cfif not isdefined("session_base.userid")>
	<cfinclude template="../objects/member_login.cfm">
<cfelse>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
	<cfset getDemand = cmp.getDemand(demand_id:attributes.demand_id) />
	<cfform name="add_demand_offer" action="#request.self#?fuseaction=worknet.emptypopup_add_demand_offer" method="post" enctype="multipart/form-data">
		<input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>">
		<div style="display:none;"><cf_workcube_process is_upd='0' is_detail='0'></div>
		<table>   
			<tr height="30">
				<td colspan="2" class="headbold"><cfoutput><big>#getDemand.fullname# / #getDemand.demand_head#</big></cfoutput></td>
			</tr>
			<tr>
				<td><cf_get_lang no ='106.Toplam Bedel'></td>
				<td>
					<cfinput type="text" name="total_amount" id="total_amount" maxlength="38" style="width:100px;float:left; " passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
					<cfquery name="GET_MONEYS" datasource="#DSN#">
						SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.period_id#
					</cfquery>
					<select name="MONEY" style="width:50px;">
					  <cfoutput query="get_moneys">
						<option value="#money#"<cfif money eq session_base.money>selected</cfif>>#money#</option>
					  </cfoutput>
					</select>
				</td>				
			</tr>
			<tr>
				<td><cf_get_lang_main no='233.Teslim Tarihi'></td>
				<td><input type="hidden" name="today" id="today" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" />
					<input type="text" name="deliver_date" id="deliver_date" value="" maxlength="10" style="width:100px;">
					<cf_wrk_date_image date_field="deliver_date">
				</td>				
			</tr>
			<tr>
				<td><cf_get_lang_main no='1037.Teslim Yeri'></td>
				<td><input type="text" name="deliver_addres" id="deliver_addres" value="" style="width:220px;" maxlength="250"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='1104.Ödeme Yöntemi'></td>
				<td><input type="text" name="paymethod" id="paymethod" value="" style="width:220px;" maxlength="250"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
				<td><input type="text" name="ship_method" id="ship_method" value="" style="width:220px;" maxlength="250"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='56.Belge'></td>
				<td><input type="file" name="offer_file" id="offer_file" style="width:165px;"></td>
			</tr>
			<tr valign="top">
				<td><cf_get_lang_main no ='217.Açıklama'> *</td>
				<td><textarea name="detail" id="detail" style="width:220px; height:80px;"></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td height="35"><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
			</tr>
		</table>
	</cfform>
	<script type="text/javascript">
	function kontrol()
	{
		document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value);
		
		if(document.getElementById('deliver_date').value != "")
		{
			if (!date_check_hiddens(document.getElementById('today'), document.getElementById('deliver_date'), "Teslim tarihi bugünden önce olamaz!"))
				return false;
		}
		
		if(document.add_demand_offer.detail.value == '')
		{	
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='217.Açiklama'>!");
			return false;
		}
		
		return true;
	}
	</script>
</cfif>
