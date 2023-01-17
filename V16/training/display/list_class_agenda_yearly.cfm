<cfset tarih_bugun = dateformat(now(),"yyyy-mm-dd")>
<cfset bu_ay = month(now())>
<table cellSpacing="0" cellpadding="0" border="0" width="99%" align="center">
	<tr class="color-border"> 
	  <td> 
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
		  <tr class="color-header"> 
			<td height="22" class="form-title" width="75"><cf_get_lang_main no='1260.Aylar'></td>
			<td height="22" class="form-title"><cf_get_lang_main no='7.Eğitim'></td>
			<td height="22" align="right" class="form-title" style="text-align:right;"><cfloop from="-2" to="2" index="i">
				<cfset year_k=evaluate(session.ep.period_year + i)>
				<cfoutput>
					<a href="#request.self#?fuseaction=training.list_class_agenda#url_str#&yil_src=#year_k#&page_type=#page_type#">
					<cfif isdefined("attributes.yil_src") and attributes.yil_src eq year_k ><font color="FF0000">#year_k#</font><cfelse>#year_k#</cfif></a> | 
				</cfoutput>
			</cfloop></td>
		  </tr>
		  <cfoutput>
		  <cfloop from="1" to="12" index="attributes.month_id">  
		   <tr height="35" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			  <td><cfif attributes.month_id eq 1><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=1"><cf_get_lang_main no='180.Ocak'></a></cfif>
				<cfif attributes.month_id eq 2><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=2"><cf_get_lang_main no='181.Şubat'></a></cfif>
				<cfif attributes.month_id eq 3><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=3"><cf_get_lang_main no='182.Mart'></a></cfif>
				<cfif attributes.month_id eq 4><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=4"><cf_get_lang_main no='183.Nisan'></a></cfif>
				<cfif attributes.month_id eq 5><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=5"><cf_get_lang_main no='184.Mayıs'></a></cfif>
				<cfif attributes.month_id eq 6><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=6"><cf_get_lang_main no='185.Haziran'></a></cfif>
				<cfif attributes.month_id eq 7><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=7"><cf_get_lang_main no='186.Temmuz'></a></cfif>
				<cfif attributes.month_id eq 8><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=8"><cf_get_lang_main no='187.Ağustos'></a></cfif>
				<cfif attributes.month_id eq 9><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=9"><cf_get_lang_main no='188.Eylül'></a></cfif>
				<cfif attributes.month_id eq 10><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=10"><cf_get_lang_main no='189.Ekim'></a></cfif>
				<cfif attributes.month_id eq 11><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=11"><cf_get_lang_main no='190.Kasım'></a></cfif>				
				<cfif attributes.month_id eq 12><a class="tableyazi" href="#request.self#?fuseaction=training_management.list_class_agenda&page_type=1&ay=12"><cf_get_lang_main no='191.Aralık'></a></cfif></td>
			  <td colspan="2">
				<cfinclude template="../query/get_class_agenda.cfm">
				<cfloop query="get_class">
					<cfif not len(finish_date) and not len(start_date)><cfset color_ = "000000"><cfelse>
						<cfset compare_tarih = dateformat(finish_date,"yyyy-mm-dd")>
						<cfset start_tarih=dateformat(start_date,"yyyy-mm-dd")>
						<cfif start_tarih eq tarih_bugun or compare_tarih eq tarih_bugun or (start_tarih lt tarih_bugun and compare_tarih gt tarih_bugun)>
							<cfset color_="FF0000">
						<cfelseif start_tarih gt tarih_bugun>
							<cfset color_="000000">
						<cfelseif compare_tarih lt tarih_bugun>
							<cfset color_="FF00FF">
						</cfif></cfif>				
					<a href="#request.self#?fuseaction=training.view_class&class_id=#get_class.class_id#" class="tableyazi"><font color="#color_#">#get_class.class_name#</font></a>
				<cfif get_class.currentrow neq get_class.Recordcount>,</cfif>
				</cfloop>
			  </td>
			</tr>
		  </cfloop> 
		  </cfoutput>
		</table>
	  </td>
	</tr>
</table>
