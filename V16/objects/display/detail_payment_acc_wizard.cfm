<cfif  not isdefined('attributes.due_date_rate')>
	<cfset attributes.due_date_rate="">
</cfif>
<cfif not isdefined('attributes.in_advance')>
	<cfset attributes.in_advance="">
</cfif>
<cfif not isdefined('attributes.in_advance_total')>
	<cfset attributes.in_advance_total="">
</cfif>
<cfif isdefined('attributes.is_compound')>
	<cfset attributes.is_compound=1>
<cfelse>
	<cfset attributes.is_compound=0>
</cfif>
<cfif isdefined('attributes.D_DATE')>
	<cfset tarih=attributes.D_DATE>
<cfelse>
	<cfset tarih=dateformat(now(),dateformat_style)>
</cfif>
<!--- Pesin miktar var ise: --->	
<cfset total_pesin=0>	
<cfif LEN(attributes.due_date_rate) >
	<cfset due_date_rate=attributes.due_date_rate>
<cfelse>
	<cfset due_date_rate=0>
</cfif>
<cfset en_genel_toplam=0>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
	<td height="25" clasS="headbold"><cf_get_lang dictionary_id='32499.Ödeme Planı'></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr clasS="color-border">
	<td>
		<table cellpadding="2" cellspacing="1" border="0" width="100%">
			<tr height="22" class="color-header">
				<td width="30" class="form-title"><cf_get_lang dictionary_id='32500.Seçim'></td>
				<td width="30" class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
				<td class="form-title"><cf_get_lang dictionary_id='32502.Vade Farkı Oranı'>(%)</td>		
				<td class="form-title"><cf_get_lang dictionary_id='57673.Tutar'></td>
			</tr>
			<cfif LEN(attributes.in_advance) or  LEN(attributes.in_advance_total)>
				<tr class="color-row" height="20">
					<td><cf_get_lang dictionary_id='32504.Peşinat'></td>
					<td><cfoutput>#dateformat(tarih,dateformat_style)#</cfoutput></td>
					<td>
						<cfoutput>
							<cfif LEN(attributes.in_advance_total)>
								#TLFormat(attributes.in_advance_total)#
								<cfset total_pesin=attributes.in_advance_total>
								<cfset pesinat=attributes.in_advance_total>
							<cfelse>
								#attributes.in_advance# (%) 
								<cfset total_pesin=attributes.in_advance*attributes.main_total/100>
								<cfset pesinat=total_pesin>
							</cfif>
						</cfoutput>
					</td>
					<td>
					</td>
					<td  style="text-align:right;">
						<cfoutput>#TLFormat(pesinat)#</cfoutput>
						<cfoutput>#SESSION.EP.MONEY#</cfoutput>
					</td>
				</tr>	
			</cfif>
			<cfset en_genel_toplam=en_genel_toplam+total_pesin>
			<cfset kalan_pesin=attributes.main_total-total_pesin>
			<cfif isdefined('attributes.instalment') and LEN(attributes.instalment) >	
				<cfloop from="1" to="#attributes.instalment#" index="m">
					<tr class="color-row" height="20">
						<td><cfoutput>#m#.</cfoutput> <cf_get_lang dictionary_id='32505.Taksit'></td>
						<td>
							<cfif attributes.is_compound eq 1 >
								<cfset odenecek=kalan_pesin/attributes.instalment+((due_date_rate*kalan_pesin*m/attributes.instalment)/100) >	
							<cfelse>
								<cfset odenecek=kalan_pesin/attributes.instalment+((due_date_rate*kalan_pesin/attributes.instalment)/100) >	
							</cfif>
							<cfset tarih=date_add('m',1,tarih)>	
							<cfoutput>#dateformat(tarih,dateformat_style)#</cfoutput>
						</td>
						<td>
							<cfif LEN(attributes.in_advance)>
								<cfset fark_rate=attributes.in_advance>
							<cfelse>
								<cfset fark_rate=0>
							</cfif>
							<cfoutput>#Round(evaluate((100-fark_rate)/attributes.instalment))# (%)</cfoutput>
						</td>
						<td>
							<cfif due_date_rate neq 0>
								<cfoutput>#due_date_rate#</cfoutput>
							</cfif>
						</td>				
						<td  style="text-align:right;">
							<cfoutput>#TLFormat(odenecek)#</cfoutput>
							<cfoutput>#SESSION.EP.MONEY#</cfoutput>
							<cfset en_genel_toplam=en_genel_toplam+odenecek>
						</td>
					</tr>
				</cfloop>
			</cfif>
			<tr class="color-row" height="20">
				<td colspan="4" class="txtbold" ><cf_get_lang dictionary_id='57492.Toplam'></td>
				<td   class="txtbold" style="text-align:right;">
					<cfoutput>#TLFormat(en_genel_toplam)#</cfoutput> 
					<cfoutput>#SESSION.EP.MONEY#</cfoutput>
				</td>				
			</tr>
		</table>
    </td>
  </tr>
</table>
