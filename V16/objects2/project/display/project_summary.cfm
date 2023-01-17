<cfinclude template="../query/get_prodetail.cfm">
<cfif project_detail.recordcount>
	<script type="text/javascript">
	function satirac(ac)
		{
		if (ac.style.display == "none")
			{
			ac.style.display = "block";
			return false;
			}
		else
			{
			ac.style.display = "none";
			return false;
			}
		}
	</script>
	<cfquery name="get_pro_currency_name" datasource="#dsn#">
		SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_detail.pro_currency_id#">
	</cfquery>
	<cfquery name="get_priority" datasource="#dsn#">
		SELECT PRIORITY FROM SETUP_PRIORITY,PRO_PROJECTS WHERE PRO_PRIORITY_ID = PRIORITY_ID AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
		  <table width="100%">
		  <tr class="color-row" height="20">
		  	<td class="txtbold"><cf_get_lang_main no='4.Proje'></td>
			<td colspan="2"><cfoutput>#project_detail.PROJECT_HEAD#</cfoutput></td>
			<td style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_mail&id=#attributes.id#</cfoutput>','medium');"><img src="/images/mail.gif" title="<cf_get_lang no ='1385.Proje Ekibine Mail Gönder'>" border="0"></a></td>
		  </tr>
			<tr class="color-row" height="20">
			  <td class="txtbold" width="100"><cf_get_lang_main no='217.Açıklama'></td>
			  <td colspan="3">
				<cfif len(project_detail.PROJECT_DETAIL)>
				  <cfoutput>#project_detail.PROJECT_DETAIL#</cfoutput>
				</cfif>
			  </td>
			</tr>
			<tr class="color-row" height="20">
			  <td class="txtbold"><cf_get_lang no='674.Proje Hedefi'></td>
			  <td colspan="3">
				<cfif len(project_detail.PROJECT_TARGET)>
				  <cfoutput>#project_detail.PROJECT_TARGET#</cfoutput>
				</cfif>
			  </td>
			</tr>
			<tr class="color-row" height="20">
			  <td class="txtbold"><cf_get_lang_main no='246.Üye'></td>
			  <td><cfoutput>
					<cfif len(project_detail.PARTNER_ID)>
						#GET_PAR_INFO(project_detail.PARTNER_ID,0,1,0)#
					<cfelseif len(project_detail.CONSUMER_ID)>
						#GET_CONS_INFO(project_detail.CONSUMER_ID,1)#
					<cfelseif len (project_detail.company_id)>
						#GET_PAR_INFO(project_detail.company_id,1,0,0)#
					</cfif>
				</cfoutput>
			  </td>
			  <td class="txtbold"><cf_get_lang no='675.Proje Lideri'></td>
			  <td>
				<cfif (project_detail.OUTSRC_PARTNER_ID NEQ 0) and len(project_detail.OUTSRC_PARTNER_ID)>
					<cfoutput>#GET_PAR_INFO(project_detail.OUTSRC_PARTNER_ID,0,0,0)#</cfoutput>
				<cfelseif len(project_detail.project_emp_id)>
					<cfoutput>#GET_EMP_INFO(project_detail.project_emp_id,0,0,0)#</cfoutput>
				</cfif>
			  </td>
			</tr>
			<tr class="color-row" height="20">
			  <td class="txtbold" width="100"><cf_get_lang_main no='70.Aşama'></td>
			  <td><cfoutput>#get_pro_currency_name.stage#</cfoutput></td>
			  <td class="txtbold"><cf_get_lang_main no='73.Öncelik'></td>
			  <td> <cfoutput query="get_priority">#get_hist_detail.PRIORITY#</cfoutput></td>
			</tr>
			<tr class="color-row" height="20">
			  <td class="txtbold"><cf_get_lang no='676.İlişkili Proje'></td>
			  <td>
			  <cfif len(project_detail.related_project_id)>
				<cfquery name="get_pro_name" datasource="#dsn#">
					SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_detail.related_project_id#">
				</cfquery>
			  </cfif>
			  <cfif len(project_detail.related_project_id)><cfoutput><!--- <a href="#request.self#?fuseaction=project.prodetail&id=#PROJECT_DETAIL.related_project_id#" class="tableyazi">#get_pro_name.project_head#</a> --->#get_pro_name.project_head#</cfoutput><cfelse><cf_get_lang_main no='1047.Projesiz'></cfif>
			  </td>
			  <td class="txtbold" width="100"><cf_get_lang no='116.Kalan Zaman'></td>
			  <td nowrap><cf_per_cent start_date = '#project_detail.TARGET_START#' finish_date = '#project_detail.TARGET_FINISH#' color1='66CC33' color2='3399FF' width="175">
				 <cfset days=abs(datediff("d",project_detail.TARGET_FINISH,project_detail.TARGET_START))><cfoutput>#days+1# gün</cfoutput>
			  </td>
			</tr>
		  <tr class="color-row" height="20">
			  <td class="txtbold"><cf_get_lang no='677.Hedef Tarih'></td>
			  <cfset TARGET_START = date_add('h',session.pp.TIME_ZONE,project_detail.TARGET_START)>
			  <td><cfoutput>#Dateformat(TARGET_START,'dd/mm/yyyy')# #Timeformat(TARGET_START,'HH:mm')# - </cfoutput>
			  <cfset TARGET_FINISH = date_add('h',session.pp.TIME_ZONE,project_detail.TARGET_FINISH)>
			  <cfoutput>#Dateformat(TARGET_FINISH,'dd/mm/yyyy')# #Timeformat(TARGET_FINISH,'HH:mm')#</cfoutput></td>
			  <td colspan="2">&nbsp;</td>
			</tr>
			<tr class="color-row" height="20">
			  <td colspan="4" class="txtbold">
			  <cfset rec_date = date_add('h',session.pp.TIME_ZONE,project_detail.RECORD_DATE)>
			  <cf_get_lang_main no='71.Kayıt'>:
			  <cfif len(project_detail.RECORD_EMP)>
					<cfoutput>#GET_EMP_INFO(project_detail.RECORD_EMP,0,0)#</cfoutput>
				  <cfelseif len(project_detail.RECORD_PAR)>
					<cfoutput>#GET_PAR_INFO(project_detail.RECORD_PAR,0,1,0)#</cfoutput>
				  </cfif>
			  <cfoutput>#Dateformat(rec_date,'dd/mm/yyyy')#</cfoutput></td>
			</tr>              
		  </table>
<cfelse>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr class="color-row">
			<td colspan="9" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	</table>	
</cfif>
