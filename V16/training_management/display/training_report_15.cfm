<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_class_costs.cfm">
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
<!---<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>--->
<tr>
<td valign="top">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
  <cfelse>
   <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='239.Eğitim Maliyetleri'></font></td>
  </tr> 
  </cfif>
</table>
		 <table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
		   <tr>
		     <td colspan="7" class="txtbold"><cfoutput>#get_class.class_name#</cfoutput></td>
		   </tr>
			<tr height="25" class="formbold" align="center">
			  <td>&nbsp;</td>
			  <td width="100" colspan="3" align="center"><cf_get_lang no='257.Öngörülen'></td>
			  <td width="100" colspan="3" align="center"><cf_get_lang no='258.Gerçekleşen'></td>
			</tr>
			<tr height="20">
			  <td class="txtbold">&nbsp;<cf_get_lang_main no='217.Açıklama'></td>
			  <td class="txtbold">&nbsp;Miktar</td>
			  <td class="txtbold">&nbsp;Birim</td>
			  <td class="txtbold">&nbsp;Toplam</td>
			  <td class="txtbold">&nbsp;Miktar</td>
			  <td class="txtbold">&nbsp;Birim</td>
			  <td class="txtbold">&nbsp;Toplam</td>
			</tr>
		<cfif get_class_costs.recordcount>
		  <cfoutput query="GET_CLASS_COST_ROWS">
			<tr height="20" align="center">
			  <td>#GET_CLASS_COST_ROWS.EXPLANATION#</td>
			  <td align="right" align="center"> &nbsp;#TLFormat(GET_CLASS_COST_ROWS.ONGORULEN_MIKTAR)#</td>
			  <td align="right" align="center"> &nbsp;#TLFormat(GET_CLASS_COST_ROWS.ONGORULEN_BIRIM)#</td>
			  <td align="right" align="center"> &nbsp;#TLFormat(GET_CLASS_COST_ROWS.ONGORULEN)#</td>
			  <td align="right" align="center"> &nbsp;#TLFormat(GET_CLASS_COST_ROWS.GERCEKLESEN_MIKTAR)#</td>
			  <td align="right" align="center"> &nbsp;#TLFormat(GET_CLASS_COST_ROWS.GERCEKLESEN_BIRIM)#</td>
			  <td align="right" align="center"> &nbsp;#TLFormat(GET_CLASS_COST_ROWS.GERCEKLESEN)#</td>
			</tr>
			</cfoutput>
			   <cfif GET_CLASS_COSTS.recordcount>
				<cfquery name="get_emp_att" datasource="#dsn#">
					SELECT COUNT(EMP_ID) AS EMP_ID,COUNT(CON_ID) AS CON_ID,COUNT(PAR_ID) AS PAR_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID#
				</cfquery>
				<cfif isNumeric(GET_CLASS_COSTS.ONGORULEN_TOPLAM) and get_emp_att.recordcount>
					<!--- <cfset kisi_sayisi = get_emp_att.RecordCount> --->
					<cfset kisi_sayisi = get_emp_att.emp_id + get_emp_att.con_id + get_emp_att.par_id>
					<cfset ongorulen_kisi = GET_CLASS_COSTS.ONGORULEN_TOPLAM/kisi_sayisi>
					<cfset gerceklesen_kisi = GET_CLASS_COSTS.GERCEKLESEN_TOPLAM/kisi_sayisi>
			   <cfelse>
					<cfset kisi_sayisi = 0>
			   </cfif>
				   <cfif isNumeric(GET_CLASS_COSTS.ONGORULEN_TOPLAM) and (kisi_sayisi gt 0)>
					   <tr>
							<td colspan="2">&nbsp;</td>
							<td class="txtbold">Toplam:</td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(GET_CLASS_COSTS.ONGORULEN_TOPLAM)#</cfoutput></td>
							<td colspan="2">&nbsp;</td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(GET_CLASS_COSTS.GERCEKLESEN_TOPLAM)#</cfoutput></td>
					   </tr>
					   <tr>
							<td colspan="2">&nbsp;</td>
							<td class="txtbold">Kişi Başı:</td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(ongorulen_kisi)#</cfoutput></td>
							<td colspan="2">&nbsp;</td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(gerceklesen_kisi)#</cfoutput></td>
					   </tr>
					   <tr>
							<td colspan="2">&nbsp;</td>
							<td class="txtbold">Katılımcı Sayısı:</td>
							<td class="txtbold" style="text-align:right;"><cfoutput>#kisi_sayisi#</cfoutput></td>
							<td colspan="3">&nbsp;</td>
					   </tr>
				   </cfif>
			   </cfif>
		</cfif>
	  </table>
</td>
</tr>
<!---<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>--->
</table>		  
