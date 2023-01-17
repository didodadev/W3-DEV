
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
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
			<!---<tr height="25" class="formbold">
			  <!---<td width="100">Eğitim</td>--->
			  <td width="100"><cf_get_lang_main no='217.Açıklama'></td>
			  <td width="100"><cf_get_lang no='257.Öngörülen'></td>
			  <td width="100"><cf_get_lang no='258.Gerçekleşen'></td>
			</tr>--->
	<cfset ONGORULEN_TOPLAM_ = 0>
	<cfset GERCEKLESEN_TOPLAM_ = 0>
	  	
		 <cfloop list="#attributes.class_id_list#" index="i">
	       <cfset attributes.class_id= i>
	      <cfinclude template="../query/get_report_queries.cfm">
	      <cfinclude template="../query/get_upd_class_queries.cfm">
		  <cfinclude template="../query/get_class.cfm">
          <cfinclude template="../query/get_class_costs.cfm">
			
			<cfif (len(GET_CLASS_COSTS.ONGORULEN_TOPLAM) and (GET_CLASS_COSTS.ONGORULEN_TOPLAM neq 0)) or  (len(GET_CLASS_COSTS.GERCEKLESEN_TOPLAM) and (GET_CLASS_COSTS.GERCEKLESEN_TOPLAM))>
			 <tr>
			   <td align="left"><cfoutput>#get_class.class_name#</cfoutput></td>
			    <td width="100" align="center"><cf_get_lang no='257.Öngörülen'></td>
				<td width="100" align="center"><cf_get_lang no='258.Gerçekleşen'></td>
			 </tr>
			</cfif>
			 <cfoutput query="GET_CLASS_COSTS">
			 <cfif (isDefined("ONGORULEN1") and len(ONGORULEN1) and (ONGORULEN1 neq 0)) or (isDefined("GERCEKLESEN1") and len(GERCEKLESEN1) and (GERCEKLESEN1 neq 0))>
			 <tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION1#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN1)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN1)#</td>
			 </tr>
			 </cfif>
			 <cfif (isDefined("ONGORULEN2") and len(ONGORULEN2) and (ONGORULEN2)) or (isDefined("GERCEKLESEN2") and len(GERCEKLESEN2) and (GERCEKLESEN2 neq 0))>
			 <tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION2#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN2)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN2)#</td>
			</tr>
			</cfif>
			<cfif (isDefined("ONGORULEN3") and len(ONGORULEN3) and (ONGORULEN3)) or (isDefined("GERCEKLESEN3") and len(GERCEKLESEN3) and (GERCEKLESEN3 neq 0))>
			<tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION3#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN3)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN3)#</td>
			</tr>
			</cfif>
			<cfif isDefined("ONGORULEN4") and (len(ONGORULEN4) and (ONGORULEN4 neq 0)) or (isDefined("GERCEKLESEN4") and len(GERCEKLESEN4) and (GERCEKLESEN4 neq 0))>
			<tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION4#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN4)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN4)#</td>
			</tr>
			</cfif>
			<cfif (isDefined("ONGORULEN5") and len(ONGORULEN5) and (ONGORULEN5 neq 0))  or (isDefined("GERCEKLESEN5") and len(GERCEKLESEN5) and (GERCEKLESEN5 neq 0))>
			<tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION5#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN5)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN5)#</td>
			</tr>
			</cfif>
			<cfif (isDefined("ONGORULEN6") and len(ONGORULEN6) and (ONGORULEN6 neq 0)) or (isDefined("GERCEKLESEN6") and len(GERCEKLESEN6) and (GERCEKLESEN6 neq 0))>
			<tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION6#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN6)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN6)#</td>
			</tr>
			</cfif>
			<cfif (isDefined("ONGORULEN7") and len(ONGORULEN7) and (ONGORULEN7 neq 0)) or (isDefined("GERCEKLESEN7") and len(GERCEKLESEN7) and (GERCEKLESEN7 neq 0))>
			<tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION7#&nbsp;
			  </td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN7)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN7)#</td>
			</tr>
			</cfif>
			<cfif (isDefined("ONGORULEN8") and len(ONGORULEN8) and (ONGORULEN8 neq 0)) or (isDefined("GERCEKLESEN8") and len(GERCEKLESEN8) and (GERCEKLESEN8 neq 0))>
			<tr height="20">
			  <td>#GET_CLASS_COSTS.EXPLANATION8#&nbsp;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN8)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN8)#</td>
			</tr>
			</cfif>
			<cfif (isDefined("ONGORULEN_TOPLAM") and len(ONGORULEN_TOPLAM) and (ONGORULEN_TOPLAM neq 0)) or (isDefined("GERCEKLESEN_TOPLAM") and len(GERCEKLESEN_TOPLAM) and (GERCEKLESEN_TOPLAM neq 0))>
			<tr id="conf" height="22" class="txtbold">
			  <td><cf_get_lang no='378.Toplam Maliyet&nbsp'>;</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.ONGORULEN_TOPLAM)#</td>
			  <td style="text-align:right;">#TLFormat(GET_CLASS_COSTS.GERCEKLESEN_TOPLAM)#</td>
			</tr>
			  <cfset ONGORULEN_TOPLAM_ = ONGORULEN_TOPLAM_ + ONGORULEN_TOPLAM>
			  <cfset GERCEKLESEN_TOPLAM_ = GERCEKLESEN_TOPLAM_ + GERCEKLESEN_TOPLAM>
			</cfif>
			 </cfoutput>
			
	   </cfloop>
	   <tr>
	     <td>&nbsp;</td>
		 <td style="text-align:right;"><cf_get_lang no='379.Öngörülen Toplam'> : <cfoutput><b>#TLFormat(ONGORULEN_TOPLAM_)#</b></cfoutput></td>
		 <td style="text-align:right;"><cf_get_lang no='380.Gerçekleşen Toplam'> : <cfoutput><b>#TLFormat(GERCEKLESEN_TOPLAM_)#</b></cfoutput></td>
	   </tr>
	   
		   
	  </table>
</td>
</tr>
	 <tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>		  
