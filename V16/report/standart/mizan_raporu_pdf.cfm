<cfset row_count = 70>
<cfset satir_say = 0>
<cfdocument format="pdf" orientation="portrait" backgroundvisible="false" pagetype="custom" unit="cm" pageheight="28" pagewidth="21" >
<style type="text/css">table{font-size:4px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;}</style>
<cfset filename1 = "#createuuid()#">
<cfheader name="Content-Disposition" value="attachment; filename=#filename1#.pdf">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
	<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
	  <tr class="color-border">
		<td>
	 <table cellpadding="2" cellspacing="1" border="0" width="100%">
		   <tr class="color-row">
			<td colspan="14" class="txtboldblue"><cfoutput>#attributes.date1# - #attributes.date2#</cfoutput> <cf_get_lang dictionary_id='39363.Dönemi'> <cfoutput>#attributes.money#</cfoutput>  <cf_get_lang dictionary_id='38886.Mizan Planı'></td>
			</tr>
			<tr class="color-header" height="20">
			  <td class="form-title" nowrap><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
			  <td class="form-title"><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
			  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
			  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
			  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
			  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
			<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
				<cfoutput>
				<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></td>
				<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></td>
				<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
				<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
				</cfoutput>
			</cfif>
			<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
				<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57587.Borç'></td>
				<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57588.Alacak'></td>
				<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
				<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
			</cfif>
			</tr>
			<cfif isdefined("attributes.form_varmi") and get_acc_remainder.recordcount >
				<cfscript>
					sayfa_total_borc_all = 0;
					sayfa_total_alacak_all = 0;
					sayfa_total_bakiye_all = 0;
					sayfa_borc_bakiye_tpl = 0;
					sayfa_alacak_bakiye_tpl = 0;
					
					total_borc_all = 0;
					total_alacak_all = 0;
					total_bakiye_all = 0;
					borc_bakiye_tpl = 0;
					alacak_bakiye_tpl = 0;
		
					sayfa_total_borc_all_2 = 0;
					sayfa_total_alacak_all_2 = 0;
					sayfa_total_bakiye_all_2 = 0;
					sayfa_borc_bakiye_tpl_2 = 0;
					sayfa_alacak_bakiye_tpl_2 = 0;
					
					total_borc_all_2 = 0;
					total_alacak_all_2 = 0;
					total_bakiye_all_2 = 0;
					borc_bakiye_tpl_2 = 0;
					alacak_bakiye_tpl_2 = 0;
				</cfscript>
				<cfoutput query="get_acc_remainder">
				  <cfset satir_say = satir_say + 1>
				  <cfif not Find(".",account_code) or listlen(account_code,".") eq 2 ><cfset str_line = "class='txtbold'"><cfelse><cfset str_line = "" ></cfif>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td #str_line# >
					<cfif ListLen(account_code,".") neq 1><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif>
					#account_code#
					</td>
					<td #str_line# >
						#account_name#
					</td>
					<cfset BORC_ = BORC / attributes.rate>
					<cfset ALACAK_ = ALACAK / attributes.rate>
					<cfset BAKIYE_ = BAKIYE / attributes.rate>
					<td align="right" style="text-align:right;" #str_line#>#TLFormat(BORC_)#</td>
					<td align="right" style="text-align:right;" #str_line#>#TLFormat(ALACAK_)#</td>
					<cfif BORC GT ALACAK>
						<td align="right" style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_))#
							<cfif listlen(ACCOUNT_CODE,'.') eq 1>
								<cfset borc_bakiye_tpl=borc_bakiye_tpl+abs(BAKIYE_)>
								<cfset sayfa_borc_bakiye_tpl=sayfa_borc_bakiye_tpl+abs(BAKIYE_)>
							</cfif>
						</td>
						<td align="right" style="text-align:right;" #str_line#>#TLFormat(0)#</td>
					<cfelse>
						<td align="right" style="text-align:right;" #str_line# >#TLFormat(0)#</td>				
						<td align="right" style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_))#
						<cfif listlen(ACCOUNT_CODE,'.') eq 1>
							<cfset alacak_bakiye_tpl=alacak_bakiye_tpl+abs(BAKIYE_)>
							<cfset sayfa_alacak_bakiye_tpl=sayfa_alacak_bakiye_tpl+abs(BAKIYE_)>
						</cfif>
						</td>
					</cfif>
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
						<td align="right" nowrap style="text-align:right;" #str_line#>#TLFormat(BORC_2)# #session.ep.money2#</td>				
						<td align="right" nowrap style="text-align:right;" #str_line#>#TLFormat(ALACAK_2)# #session.ep.money2#</td>
						<cfif BORC_2 GT ALACAK_2>
							<td align="right" style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_2))#
								<cfif listlen(ACCOUNT_CODE,'.') eq 1>
									<cfset borc_bakiye_tpl_2=borc_bakiye_tpl_2+abs(BAKIYE_2)>
									<cfset sayfa_borc_bakiye_tpl_2=sayfa_borc_bakiye_tpl_2+abs(BAKIYE_2)>
								</cfif>
							</td>
							<td align="right" style="text-align:right;" #str_line#>#TLFormat(0)#</td>
						<cfelse>
							<td align="right" style="text-align:right;" #str_line# >#TLFormat(0)#</td>				
							<td align="right" style="text-align:right;" #str_line#> #TLFormat(abs(BAKIYE_2))#
							<cfif listlen(ACCOUNT_CODE,'.') eq 1>
								<cfset alacak_bakiye_tpl_2=alacak_bakiye_tpl_2+abs(BAKIYE_2)>
								<cfset sayfa_alacak_bakiye_tpl_2=sayfa_alacak_bakiye_tpl_2+abs(BAKIYE_2)>
							</cfif>
							</td>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
						<td align="right" nowrap style="text-align:right;" #str_line#>#TLFormat(OTHER_BORC)# #OTHER_CURRENCY#</td>				
						<td align="right" nowrap style="text-align:right;" #str_line#>#TLFormat(OTHER_ALACAK)# #OTHER_CURRENCY#</td>
						<cfif OTHER_BORC GT OTHER_ALACAK>
							<td align="right" style="text-align:right;" #str_line#> <cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif></td>
							<td align="right" style="text-align:right;" #str_line#>#TLFormat(0)#</td>
						<cfelse>
							<td align="right" style="text-align:right;" #str_line# >#TLFormat(0)#</td>				
							<td align="right" style="text-align:right;" #str_line#><cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif> </td>
						</cfif>
					</cfif>	
					<cfif listlen(ACCOUNT_CODE,'.') eq 1>
						<cfset total_borc_all=total_borc_all+BORC_>
						<cfset total_alacak_all=total_alacak_all+ALACAK_>
						<cfset total_bakiye_all=total_bakiye_all+BAKIYE_>
						<cfset sayfa_total_borc_all=total_borc_all+BORC_>
						<cfset sayfa_total_alacak_all=total_alacak_all+ALACAK_>
						<cfset sayfa_total_bakiye_all=total_bakiye_all+BAKIYE_>
						<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>	
							<cfset total_borc_all_2 = total_borc_all_2 + BORC_2>
							<cfset total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
							<cfset total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
							<cfset sayfa_total_borc_all_2 = total_borc_all_2 + BORC_2>
							<cfset sayfa_total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
							<cfset sayfa_total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
						</cfif>
					</cfif>
					</tr>
					<cfif satir_say eq row_count>
						<cfset satir_say = 0>
						<tr class="color-row">
							<td colspan="2" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all))#</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all))#</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl)))#</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl)))#</td>
							<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all_2))#</td>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all_2))#</td>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl_2)))#</td>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl_2)))#</td>
							</cfif>
							<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
								<td colspan="4" align="right" class="txtbold" style="text-align:right;">&nbsp;</td>
							</cfif>
						</tr> 
						</table>
							<cfdocumentitem type="pagebreak"/>
						<table cellpadding="2" cellspacing="1" border="0" width="98%">
						<tr class="color-header" height="20">
						  <td class="form-title" nowrap><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
						  <td class="form-title"><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
						  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
						  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
						  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
						  <td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
						<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
							<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></td>
							<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></td>
							<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
							<td align="right" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
						</cfif>
						<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
							<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57587.Borç'></td>
							<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='57588.Borç'></td>
							<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47441.Bakiye Borç'></td>
							<td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><br/><cf_get_lang dictionary_id='47442.Bakiye Alacak'></td>
						</cfif>
						</tr>
						<tr class="color-row">
							<td colspan="2" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='38876.Önceki Sayfa Toplam'>:</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all))#</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all))#</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl)))#</td>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl)))#</td>
							<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_borc_all_2))#</td>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(sayfa_total_alacak_all_2))#</td>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_borc_bakiye_tpl_2)))#</td>
								<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(sayfa_alacak_bakiye_tpl_2)))#</td>
							</cfif>
							<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
								<td colspan="4" align="right" class="txtbold" style="text-align:right;">&nbsp;</td>
							</cfif>
						</tr> 
					</cfif>
				</cfoutput>
				<tr class="color-row">
					<cfoutput>
					<td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_borc_all))#</td>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_alacak_all))#</td>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(borc_bakiye_tpl)))#</td>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(alacak_bakiye_tpl)))#</td>
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_borc_all_2))#</td>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(wrk_round(total_alacak_all_2))#</td>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(borc_bakiye_tpl_2)))#</td>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(abs(wrk_round(alacak_bakiye_tpl_2)))#</td>
					</cfif>
					</cfoutput>
					<cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
						<td colspan="4" align="right" class="txtbold" style="text-align:right;">&nbsp;</td>
					</cfif>
				</tr> 
			</cfif>
	   </table>	  
		</td>
	  </tr>
	</table>
</cfdocument>
