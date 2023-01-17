<cfset attributes.class_id = attributes.id>
<cfinclude template="../display/view_class.cfm">
<cfinclude template="../query/get_class_costs.cfm">
<table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td class="headbold" height="35"><cf_get_lang no='239.Eğitim Maliyet'></td>
  </tr>
</table>
<table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
	<td valign="top">
	  <table width="100%" height="100%"border="0" cellspacing="1" cellpadding="2">
		<tr class="color-row">
		  <td>
			  <table>
				<tr>
				  <td class="txtboldblue"><cf_get_lang_main no='217.Açıklama'></td>
				  <td width="100" class="txtboldblue" align="center"><cf_get_lang no='257.Öngörülen'></td>
				  <td width="100" class="txtboldblue" align="center"><cf_get_lang no='258.Gerçekleşen'></td>
				</tr>
				<cfif GET_CLASS_COST_ROWS.recordcount>
					<cfquery name="get_emp_att" datasource="#dsn#">
						SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
					</cfquery>
					<cfif isNumeric(GET_CLASS_COSTS.ONGORULEN_TOPLAM) and get_emp_att.recordcount>
						<cfset kisi_sayisi = get_emp_att.RecordCount>
						<cfset ongorulen_kisi = GET_CLASS_COSTS.ONGORULEN_TOPLAM/get_emp_att.recordcount>
						<cfset gerceklesen_kisi = GET_CLASS_COSTS.GERCEKLESEN_TOPLAM/get_emp_att.recordcount>
				   <cfelse>
						<cfset kisi_sayisi = 0>
				   </cfif>
					<cfoutput query="GET_CLASS_COST_ROWS">
					<tr>
					  <td class="txtbold" width="250">#EXPLANATION#</td>
					  <td style="text-align:right;">#TLFormat(ONGORULEN)#</td>
					  <td style="text-align:right;">#TLFormat(GERCEKLESEN)#</td>
					</tr>
					</cfoutput>
				<cfelse>
					<cfset get_emp_att.recordcount = 0>
				</cfif>
				<tr>
				  <td class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
				  <td valign="top" style="text-align:right;"><cfoutput>#TLFormat(GET_CLASS_COSTS.ONGORULEN_TOPLAM)#</cfoutput></td>
				  <td valign="top" style="text-align:right;"><cfoutput>#TLFormat(GET_CLASS_COSTS.GERCEKLESEN_TOPLAM)#</cfoutput></td>
				</tr>
				<cfif get_emp_att.recordcount>
					<tr>
						<td class="txtbold">Kişi Başı (<cfoutput>#get_emp_att.recordcount#</cfoutput>)</td>
						<td style="text-align:right;"><cfoutput>#TLFormat(ongorulen_kisi)#</cfoutput></td>
						<td style="text-align:right;"><cfoutput>#TLFormat(gerceklesen_kisi)#</cfoutput></td>
					</tr>
				</cfif>
			 </table>
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
