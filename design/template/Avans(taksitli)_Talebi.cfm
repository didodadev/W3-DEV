<!--- Taksitli Avans Taleb(standart) --->
<cf_get_lang_set module_name="myhome"><!--- sayfanin en altinda kapanisi var --->
<cfif attributes.iid eq 1>
	<cfquery name="get_payment_request" datasource="#dsn#">
		SELECT * FROM SALARYPARAM_GET_REQUESTS WHERE SPGR_ID=#attributes.action_id#
	</cfquery> 
<cfelseif attributes.iid eq 0>
	<cfquery name="get_payment_request" datasource="#dsn#">
		SELECT * FROM CORRESPONDENCE_PAYMENT WHERE ID=#attributes.action_id#
	</cfquery>
</cfif>
<cfquery name="check" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
		COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
	<cfif isDefined("session.ep.company_id")>
		COMP_ID = #session.ep.company_id#
	<cfelseif isDefined("session.pp.our_company_id")>	
		COMP_ID = #session.pp.our_company_id#
	<cfelseif isDefined("session.ww.our_company_id")>
		COMP_ID = #session.ww.our_company_id#
	<cfelseif isDefined("session.cp.our_company_id")>
		COMP_ID = #session.cp.our_company_id#
	</cfif>
</cfquery>
<style type="text/css">.minik_yazi {font-size:9px;}</style>
<style type="text/css">.minik_yazi_ {font-size:13px;}</style>
<table cellspacing="0" cellpadding="0" border="0" width="100%" style="width:177mm">
	<tr>
        <td style="width:21mm;" rowspan="40">&nbsp;</td>
        <td style="height:22mm;" style="text-align:right;">&nbsp;</td>
    </tr>
	<tr>
		<td>
		<table border="1" cellpadding="0" cellspacing="0" bordercolorlight="000000" width="100%">
		<tr>
			<td>
			<table>
				<tr valign="top" style="height:20mm;">
				<td style="height:20mm">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr height="20">
						<td width="100%" colspan="2" align="left">
							<cfif len(CHECK.ASSET_FILE_NAME2)>
								<cfset attributes.type = 1>
								<table border="0" bordercolorlight="000000" cellspacing="0" cellpadding="0" width="100%">
									<tr style="height:20mm"> 
										<td align="left" style="width:40mm">
											<cf_get_server_file output_file="settings/#CHECK.asset_file_name2#" output_server="#CHECK.asset_file_name2_server_id#" output_type="5" image_height="50" image_width="70">
										</td>
									</tr>
									<tr style="height:7mm">
										<td align="center" class="minik_yazi_">
										<cfif attributes.iid eq 1><cf_get_lang no='816.Taksitli Avans Talebi'>
										<cfelseif attributes.iid eq 0><cf_get_lang no='157.Avans Talebi'></cfif>
									</td>
									</tr>
								</table>
							</cfif>
						</td>
					</tr>	
				</table>
				</td>
			</tr>
				<tr style="height:10mm">
					<td>
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>
				<tr style="height:86mm">
					<td valign="top">
					<cfoutput>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
							<table border="0" bordercolorlight="000000" cellspacing="0" cellpadding="0" width="100%">
								<tr>
									<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang no='72.Talep Eden'></td>
									<td style="width:110mm">: #get_emp_info(get_payment_request.record_emp,0,0)#</td>
								</tr>
								<tr>
									<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang_main no='330.Tarih'></td>
									<td>: <cfif len(get_payment_request.record_date)>#dateformat(get_payment_request.record_date,dateformat_style)#<cfelse>&nbsp;</cfif></td>
								</tr>
								<cfif isdefined('get_payment_request.paymethod_id') and len(get_payment_request.paymethod_id) and attributes.iid eq 0>
								<tr>
									<cfquery name="PAY_METHODS" datasource="#DSN#">
										SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_STATUS = 1 AND PAYMETHOD_ID = #get_payment_request.paymethod_id#
									</cfquery>
									<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
									<td>: #PAY_METHODS.paymethod#</td>
								</tr>
								</cfif>
								<tr>
									<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang_main no='261.Tutar'></td>
									<td>: <cfif isdefined('get_payment_request.amount') and len(get_payment_request.amount)>#TLformat(get_payment_request.amount)# #get_payment_request.money#<cfelseif isdefined('get_payment_request.amount_get') and len(get_payment_request.amount_get)>#TLformat(get_payment_request.amount_get)# TL</cfif> </td>
								</tr>
								<cfif attributes.iid eq 1>
									<tr>
										<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang no='793.Taksit Sayısı'></td>
										<td>: <cfif isdefined('get_payment_request.taksit_number') and len(get_payment_request.taksit_number)>#get_payment_request.taksit_number#</cfif></td>
									</tr>
									<tr>
										<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang_main no='823.Taksit'> <cf_get_lang_main no='223.Miktarı'></td>
										<td>: #TLformat(get_payment_request.amount_get/get_payment_request.taksit_number)# TL</td>
									</tr>
								</cfif>
								<tr>
									<td style="height:8mm;width:25mm" class="minik_yazi_"><cf_get_lang_main no='217.Açıklama'></td>
									<td>: #get_payment_request.detail#</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr style="height:50mm">
							<td>
							<table border="0" width="100%" height="100%">
								<tr style="height:7mm">
									<td class="minik_yazi_"><u><cf_get_lang no='72.Talep Eden'></u></td>
									<td class="minik_yazi_"><u>1.<cf_get_lang_main no='88.Onay'></u></td>
									<td class="minik_yazi_"><u>2.<cf_get_lang_main no='88.Onay'></u></td>
								</tr>
							</table>
							</td>
						</tr>						
					</table>
					</cfoutput>
					</td>
				</tr>
			</table>
			</td>
		</tr>			
		</table>
		</td>
	</tr>	
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
