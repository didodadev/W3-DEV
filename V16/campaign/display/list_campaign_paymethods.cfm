<cfquery name="GET_PAYMETHODS" datasource="#dsn3#">
	SELECT
		PAYMENT_TYPE_ID,
		CARD_NO,
		SERVICE_RATE,
		P_TO_INSTALMENT_ACCOUNT,
		COMMISSION_PRODUCT_ID,
		COMMISSION_STOCK_ID,
		COMMISSION_MULTIPLIER
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE
		IS_ACTIVE = 1 AND
		POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
	ORDER BY
		CARD_NO
</cfquery>
<cfset paymethod_id_list = ValueList(GET_PAYMETHODS.PAYMENT_TYPE_ID)>
<cfif len(paymethod_id_list)>
	<cfset paymethod_id_list=listsort(paymethod_id_list,"numeric","ASC",",")>
	<cfquery name="get_comm_detail" datasource="#dsn3#">
		SELECT
			CP.COMMISSION_RATE,
			CP.SERVICE_COMM_PRODUCT_ID,
			CP.SERVICE_COMM_STOCK_ID,
			CP.SERVICE_COMM_MULTIPLIER,
			CP.DAY_TO_ACC,
			CP.USED_IN_CAMPAIGN,
			CP.PAYMETHOD_ID,
			CP.RECORD_DATE,
			CP.RECORD_EMP,
			C.IS_BEFORE_PAYMENT
		FROM
			CAMPAIGN_PAYMETHODS CP,
			CAMPAIGNS C
		WHERE
			C.CAMP_ID = CP.CAMPAIGN_ID AND
			CP.CAMPAIGN_ID = #attributes.campaign_id# AND
			CP.PAYMETHOD_ID IN (#paymethod_id_list#)
		ORDER BY
			CP.PAYMETHOD_ID
	</cfquery>
	<cfset yeni_list=valuelist(get_comm_detail.PAYMETHOD_ID)>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='49603.Ödeme Yöntemlerinizi Kontrol Ediniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ödeme Yöntemleri',42030)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_paymethod" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=campaign.emptypopup_add_campaign_paymethod">
			<cfoutput>
				<input type="hidden" name="total_record" id="total_record" value="#GET_PAYMETHODS.recordcount#">
				<input type="hidden" name="campaign_id" id="campaign_id" value="#attributes.campaign_id#">
			</cfoutput>
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id ='58516.Ödeme Yöntemi'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='49604.Kampanya Kullan'></th>
						<th width="60" class="form-title" class="text-center"><cf_get_lang dictionary_id ='49605.Banka Kom Oranı'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='49606.Komisyon Çarpanı'></th>
						<th class="text-center"><cf_get_lang dictionary_id ='57657.Ürün'></th>
						<th width="50" class="text-center"><cf_get_lang dictionary_id ='49607.Hesaba Geçiş Günü'> </th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id ='49608.Tüm Ödeme Yöntemlerini Kullan'></td>
						<td class="text-center"><input type="checkbox" name="all_check" id="all_check" value="1" onclick="hepsi();"></td>
						<td colspan="4"></td>
					</tr>
					<cfif GET_PAYMETHODS.recordcount>
						<cfset product_id_list=''>
						<cfoutput query="GET_PAYMETHODS">
							<cfif len(COMMISSION_PRODUCT_ID) and not listfind(product_id_list,COMMISSION_PRODUCT_ID)>
								<cfset product_id_list=listappend(product_id_list,COMMISSION_PRODUCT_ID)>
							</cfif>
						</cfoutput>
					</cfif>
					<cfif isdefined('product_id_list') and len(product_id_list)>
						<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
						<cfquery name="get_product_detail" datasource="#dsn3#">
							SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
						</cfquery>
					</cfif>
					<cfoutput query="GET_PAYMETHODS">
						<cfif get_comm_detail.recordcount>
							<tr>
								<td width="200"><input type="hidden" name="paymethod_id#currentrow#" id="paymethod_id#currentrow#" value="#PAYMENT_TYPE_ID#">#CARD_NO#</td>
								<td class="text-center"><div class="form-group"><input type="checkbox" name="used_in_campaign#currentrow#" id="used_in_campaign#currentrow#" <cfif get_comm_detail.USED_IN_CAMPAIGN[listfind(yeni_list,PAYMENT_TYPE_ID,',')] eq 1>checked</cfif>></div></td>
								<td><div class="form-group"><input type="text" name="comm_rate#currentrow#" id="comm_rate#currentrow#" value="#TLFormat(get_comm_detail.COMMISSION_RATE[listfind(yeni_list,PAYMENT_TYPE_ID,',')])#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div></td>
								<td><div class="form-group"><input type="text" name="comm_multiplier#currentrow#" id="comm_multiplier#currentrow#" value="#TLFormat(get_comm_detail.SERVICE_COMM_MULTIPLIER[listfind(yeni_list,PAYMENT_TYPE_ID,',')])#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div></td>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#get_comm_detail.SERVICE_COMM_PRODUCT_ID[listfind(yeni_list,PAYMENT_TYPE_ID,',')]#">
											<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#get_comm_detail.SERVICE_COMM_STOCK_ID[listfind(yeni_list,PAYMENT_TYPE_ID,',')]#">
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif len(get_comm_detail.SERVICE_COMM_PRODUCT_ID[listfind(yeni_list,PAYMENT_TYPE_ID,',')])>#get_product_name(get_comm_detail.SERVICE_COMM_PRODUCT_ID[listfind(yeni_list,PAYMENT_TYPE_ID,',')])#</cfif>" style="width:120px;">
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=list_paymethod.product_id#currentrow#&field_id=list_paymethod.stock_id#currentrow#&field_name=list_paymethod.product_name#currentrow#');"></span>
										</div>
									</div>
								</td>
								<td><div class="form-group"><input type="text" name="day_to_acc#currentrow#" id="day_to_acc#currentrow#" value="#get_comm_detail.DAY_TO_ACC[listfind(yeni_list,PAYMENT_TYPE_ID,',')]#" class="moneybox"></div></td>
							</tr>
						<cfelse>
							<tr>
								<td width="200">
									<input type="hidden" name="paymethod_id#currentrow#" id="paymethod_id#currentrow#" value="#PAYMENT_TYPE_ID#">
									#CARD_NO#
								</td>
								<td class="text-center"><input type="checkbox" name="used_in_campaign#currentrow#" id="used_in_campaign#currentrow#"></td>
								<td><div class="form-group"><input type="text" name="comm_rate#currentrow#"  id="comm_rate#currentrow#" value="#TLFormat(SERVICE_RATE)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div></td>
								<td><div class="form-group"><input type="text" name="comm_multiplier#currentrow#" id="comm_multiplier#currentrow#" value="#TLFormat(COMMISSION_MULTIPLIER)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div></td>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#COMMISSION_PRODUCT_ID#">
											<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#COMMISSION_STOCK_ID#">								
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif len(COMMISSION_PRODUCT_ID)>#get_product_detail.PRODUCT_NAME[listfind(product_id_list,COMMISSION_PRODUCT_ID,',')]#</cfif>">
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=list_paymethod.product_id#currentrow#&field_id=list_paymethod.stock_id#currentrow#&field_name=list_paymethod.product_name#currentrow#');"></span>
										</div>
									</div>
								</td>
								<td><div class="form-group"><input type="text" name="day_to_acc#currentrow#" id="day_to_acc#currentrow#" value="#P_TO_INSTALMENT_ACCOUNT#" class="moneybox"></div></td>
							</tr>
						</cfif>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="6" class="txtbold"><div class="col col-12">
							<input style="width:20px !important;" type="checkbox" name="is_before_payment" id="is_before_payment" value="1" <cfif get_comm_detail.is_before_payment eq 1>checked</cfif>>
							<cf_get_lang dictionary_id ='49609.Bu Kampanyadan Önceki Borçlar Yukarıda Seçili Ödeme Yöntemleriyle Ödensin'>.. 
							</div> 
						</td>				
					</tr>
				</tfoot>
			</cf_grid_list>
			<cf_box_footer>
				<div class="col col-6">
					<cfif get_comm_detail.recordcount>
						<cf_record_info query_name="get_comm_detail">
					</cfif>
				</div>
				<div class="col col-6">
					<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function="unformat_field()">
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
	
<script type="text/javascript">
function unformat_field()
{
	for(var i=1;i<=list_paymethod.total_record.value;i++)
	{
		eval('list_paymethod.comm_rate' + i).value = filterNum(eval('list_paymethod.comm_rate' + i).value);
		eval('list_paymethod.comm_multiplier' + i).value = filterNum(eval('list_paymethod.comm_multiplier' + i).value);
	}
	loadPopupBox('list_paymethod' , <cfoutput>#attributes.modal_id#</cfoutput>);
	
	return false;
}
function hepsi()
{
	if (document.list_paymethod.all_check.checked)
	{
	<cfif get_paymethods.recordcount gt 0>
		<cfoutput query="get_paymethods">
			list_paymethod.used_in_campaign#currentrow#.checked = true;
		</cfoutput>
	</cfif>
	}
	else
	{
	<cfif get_paymethods.recordcount gt 0>	
		<cfoutput query="get_paymethods">
			list_paymethod.used_in_campaign#currentrow#.checked = false;
		</cfoutput>	
	</cfif>
	}
}
</script>
