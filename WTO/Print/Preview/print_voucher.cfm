<cfset attributes.id = attributes.action_id>
<cfinclude template="../../../V16/cheque/query/get_voucher_detail.cfm">
<cf_woc_header>
<table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC">
	<tr>
		<td width="200">
			<table width="100%" height="188" border="0" cellpadding="0" cellspacing="3">
				<tr>
					<td><cf_get_lang dictionary_id='57487.Number'> </td>
					<td width="3">:</td>
					<td width="100%">....................</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="56560.Lira"></td>
					<td>:</td>
					<td>....................</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="56565.Kr."></td>
					<td>:</td>
					<td>....................</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="58180.Borçlu"></td>
					<td>:</td>
					<td>....................</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="57640.Vade"></td>
					<td>:</td>
					<td>....................</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="57742.Tarih"></td>
					<td>:</td>
					<td>....................</td>
				</tr>
			</table>
		</td>
		<td width="75">&nbsp;</td>
		<td>
			<table>
				<tr>
					<td valign="top"><table width="100%">
				<tr align="center">
					<td width="110"><cf_get_lang dictionary_id="54821.Ödeme Günü"></td>
					<td width="110"><cf_get_lang dictionary_id="56581.Türk Lirası"></td>
					<td width="110"><cf_get_lang dictionary_id="56591.Kuruş"></td>
					<td width="110"><cf_get_lang dictionary_id="57487.No">.</td>
				</tr>
					<tr align="center" class="formbold">
					<td height="30"><cfoutput>#dateformat(get_voucher_detail.VOUCHER_DUEDATE,dateformat_style)#</cfoutput></td>
					<td height="30"><cfoutput>#TLFormat(get_voucher_detail.VOUCHER_VALUE)# #get_voucher_detail.CURRENCY_ID#</cfoutput></td>
					<td height="30">.....................</td>
					<td height="30"><cfoutput>#get_voucher_detail.VOUCHER_NO#</cfoutput></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><p> 
			İşbu emre muharrer senedim...........mukabilinde <cfoutput><strong>#dateformat(get_voucher_detail.VOUCHER_DUEDATE,dateformat_style)#</strong></cfoutput> tarihinde<br/>
			Bay   <cfoutput><strong>#session.ep.company#</strong></cfoutput>  veyahut emrühavale...........................<br/>
			Ödeyeceği <cfoutput><strong>#TLFormat(get_voucher_detail.VOUCHER_VALUE)# #get_voucher_detail.CURRENCY_ID#</strong></cfoutput> Bedeli arzolunmuştur. İş bu bono vadesinde ödenmediği<br/>
			takdirde müteakip bonoların da muacceliyet kesbedeceğini, ihtilaf vukuunda..................<br/>
			mahkemelerin selahiyetini şimdiden kabul eyleri<br/>          
			</p>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td width="15" rowspan="4">Ö<br/>                
						d<br/>
						e<br/>
						y<br/>
						e<br/>
						c<br/>
						e<br/>
						k</td>
					<td><cf_get_lang dictionary_id="44592.İsim"> :</td>
					<td><cfoutput><strong>#get_voucher_detail.DEBTOR_NAME#</cfoutput></strong></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="49318.Adresi"> :</td>
					<td>......................................................</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="58626.Kefil"> :</td>
					<td>......................................................</td>
				</tr>
				<tr>
					<td width="65"><cf_get_lang dictionary_id="56592.V.Da.No"> :</td>
					<td>......................................................</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<cf_woc_footer>

