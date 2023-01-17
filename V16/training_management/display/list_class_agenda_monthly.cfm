<cfset tarih_bugun=dateformat(now(),"yyyy-mm-dd")>
<table cellspacing="1" cellpadding="2" width="99%" border="0" align="center" class="color-border">
	<tr class="color-header">
		<td height="22" align="center" width="15%" class="form-title"><cf_get_lang_main no='192.Pazartesi'></td>
		<td align="center" width="15%" class="form-title"><cf_get_lang_main no='193.Sali'></td>
		<td align="center" width="15%" class="form-title"><cf_get_lang_main no='194.Çarsamba'></td>
		<td align="center" width="15%" class="form-title"><cf_get_lang_main no='195.Persembe'></td>
		<td align="center" width="15%" class="form-title"><cf_get_lang_main no='196.Cuma'></td>
		<td align="center" width="15%" class="form-title"><cf_get_lang_main no='197.Cumartesi'></td>
		<td align="center" class="form-title"><cf_get_lang_main no='198.Pazar'></td>
	</tr>
	<cfset sayac =0>
	<tr class="color-list">
	  <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
		<td height="20">&nbsp;</td>
	  </cfloop>
	  <cfloop index="x" from="#bas#" to="7">
		<td height="20" class="txtbold"><cfoutput>#gun#</cfoutput></td>
		<cfset gun = gun +1>
		<cfset sayac = sayac +1>
	  </cfloop>
	</tr>
	<cfset gun = gun - sayac>
	<tr class="color-row">
	  <cfloop index="x" from="1" to="#Evaluate(bas-1)#">
		<td height="79">&nbsp;</td>
	  </cfloop>
	  <cfset gun=0>
	  <cfloop index="x" from="#bas#" to="7">
		<cfset gun = gun + 1>
		<cfoutput>
		<td height="79" valign="top" class="label">
			<cfset attributes.to_day = date_add("h",-session.ep.time_zone,CreateODBCDatetime('#yil#-#ay#-#gun#'))>
			<cfset compare_tarih="#yil#-#numberformat(ay,'00')#-#numberformat(gun,'00')#">
			<cfset attributes.tarih_egitim = '#yil#-#ay#-#gun#'>
			<cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >
			<cfinclude  template="../query/get_todays_trainings.cfm">
			<cfloop query="get_tr">
				<cfif NOT LEN(get_tr.FINISH_DATE[currentrow]) and NOT LEN(get_tr.START_DATE[currentrow])>
					<cfset color_="000000">
				<cfelse>
					<cfset compare_tarih=dateformat(get_tr.FINISH_DATE[currentrow],"yyyy-mm-dd")>
					<cfset start_tarih=dateformat(get_tr.START_DATE[currentrow],"yyyy-mm-dd")>
					
					<cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih LT tarih_bugun and compare_tarih GT tarih_bugun )>
						<cfset color_="FF0000">
					<cfelse>
						<cfset color_="FF00FF">
					</cfif>
				</cfif>
				<cfif attributes.tarih_egitim eq compare_tarih or start_tarih eq attributes.tarih_egitim>
				<a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#get_tr.CLASS_ID#" ><font color="#color_#">#get_tr.CLASS_NAME# </font></a> 
				<cfif compare_tarih eq start_tarih >
					<img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle">
				<cfelseif attributes.tarih_egitim eq compare_tarih >
					<img src="/images/stop.gif" border="0" title="<cf_get_lang_main no='90.Bitiş'>" align="absmiddle"> <img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"></cfif>
				<br/>
				</cfif>						
				</cfloop>
					&nbsp;
				 </td>
			  </cfoutput>
			</cfloop>
			<cfset gun = gun + 1>
		  </tr>
		  <cfloop index=y from=2 to=6>
			<cfset sayac=0>
			<tr class="color-list">
			  <cfloop index=x from=1 to=7>
				<cfif gun LTE son>
				  <td height="20" class="txtbold"><cfoutput>#gun#</cfoutput></td>
				<cfelse>
				  <td>&nbsp;</td>
				</cfif>
				<cfset gun = gun +1>
				<cfset sayac = sayac +1>
			  </cfloop>
			</tr>
			<cfset gun=gun-sayac>
			<tr valign="top" class="color-row"> 
			<cfoutput>
				<cfloop index="x" from="1" to="7" >
				  <cfif gun LTE son>
					<td height="80" class="label">
					  <cfset attributes.tarih_egitim= '#yil#-#ay#-#gun#'>
					  <cfset attributes.tarih_egitim_for_query =dateformat(attributes.tarih_egitim,dateformat_style) >						  
					  <cfinclude  template="../query/get_todays_trainings.cfm">
					  <cfloop  query="get_tr">
                      	<cfif NOT LEN(get_tr.FINISH_DATE[currentrow]) and NOT LEN(get_tr.START_DATE[currentrow])>
						  <cfset color_="000000" >
						<cfelse>
						  <cfset compare_tarih=dateformat(get_tr.FINISH_DATE[currentrow],"yyyy-mm-dd")>
						  <cfset start_tarih=dateformat(get_tr.START_DATE[currentrow],"yyyy-mm-dd")>
						  <cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih LT tarih_bugun and compare_tarih GT tarih_bugun )>
							  <cfset color_="FF0000" >
						  <cfelseif (compare_tarih gt tarih_bugun) and  (start_tarih  gt tarih_bugun)>
							  <cfset color_ = "000000" >
						  <cfelse>
							  <cfset color_ = "FF00FF" >
						  </cfif>
						</cfif>
						<cfif is_active neq 1>
							<cfset color_="777777" >
						</cfif>
						<cfif attributes.tarih_egitim eq compare_tarih or start_tarih eq attributes.tarih_egitim>
							<a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#get_tr.CLASS_ID#" ><font color="#color_#">#get_tr.CLASS_NAME#</font></a> 
								<cfif compare_tarih eq start_tarih >
                            		<img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle"> <img src="/images/stop.gif" border="0" title="<cf_get_lang_main no='90.Bitiş'>"  align="absmiddle">
								<cfelseif attributes.tarih_egitim eq compare_tarih >
                                	<img src="/images/stop.gif" border="0" title="<cf_get_lang_main no='90.Bitiş'>"  align="absmiddle">
								<cfelse>
                                	<img src="/images/starton.gif" border="0"  title="<cf_get_lang_main no='1055.Start'>" align="absmiddle">
								</cfif>
                                <br/>
						</cfif>
					  </cfloop>
					</td>
				  <cfelse>
					<td height="80">&nbsp;</td>
				  </cfif>
				  <cfset gun = gun +1>
				</cfloop>
			  </cfoutput> 
			  </tr>
		  </cfloop>
		</table>
<br/>
