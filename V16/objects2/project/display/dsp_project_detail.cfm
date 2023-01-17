<cfif isNumeric(attributes.project_id)>
	<cfinclude template="../query/get_prodetail.cfm">
<cfelse>
	<cfset project_detail.recordcount = 0>
</cfif>
<cfif not project_detail.recordcount>
	<script language="javascript">
		alert("<cf_get_lang_main no ='1531.Böyle Bir Kayıt Bulunmamaktadır'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfif project_detail.recordcount>
	<script language="JavaScript">
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
	<cfquery name="GET_PRO_CURRENCY_NAME" datasource="#DSN#">
		SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_detail.pro_currency_id#">
	</cfquery>
	<cfquery name="GET_PRIORITY" datasource="#DSN#">
		SELECT PRIORITY FROM SETUP_PRIORITY,PRO_PROJECTS WHERE PRO_PRIORITY_ID = PRIORITY_ID AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
    <table style="width:100%">
        <tr class="color-row" style="height:20px;">
            <td class="txtbold"><cf_get_lang_main no= '4.Proje'></td>
            <td colspan="2"><cfoutput>#project_detail.project_head#</cfoutput></td>
            <td style="text-align:right;">
            	<cfif isDefined('attributes.is_proj_material') and attributes.is_proj_material eq 1>
                    <a href="javascript://" onclick="sent_project_graph(<cfoutput>#attributes.project_id#</cfoutput>);"><img src="/images/cizelge.gif" title="<cf_get_lang no='91.Proje Seyri'>" border="0"></a>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_mail&id=#attributes.project_id#</cfoutput>','medium');"><img src="/images/mail.gif" title="<cf_get_lang no ='1385.Proje Ekibine Mail Gönder'>" border="0"></a>
                </cfif>			
            </td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold" style="vertical-align:top; width:100px;"><cf_get_lang_main no='217.Açıklama'></td>
            <td colspan="3">
                <cfif len(project_detail.project_detail)>
                    <cfoutput>#project_detail.project_detail#</cfoutput>
                </cfif>
            </td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold"><cf_get_lang no='674.Proje Hedefi'></td>
            <td colspan="3">
                <cfif len(project_detail.project_target)>
                    <cfoutput>#project_detail.project_target#</cfoutput>
                </cfif>
            </td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold"><cf_get_lang_main no='246.Üye'></td>
            <td>
                <cfoutput>
                    <cfif len(project_detail.partner_id)>
                        #GET_PAR_INFO(project_detail.partner_id,0,1,0)#
                    <cfelseif len(project_detail.consumer_id)>
                        #GET_CONS_INFO(project_detail.consumer_id,1)#
                    <cfelseif len (project_detail.company_id)>
                        #GET_PAR_INFO(project_detail.company_id,1,0,0)#
                    </cfif>
                </cfoutput>
            </td>
            <td class="txtbold"><cf_get_lang no='675.Proje Lideri'></td>
            <td>
                <cfif (project_detail.outsrc_partner_id neq 0) and len(project_detail.outsrc_partner_id)>
                    <cfoutput>#GET_PAR_INFO(project_detail.outsrc_partner_id,0,0,0)#</cfoutput>
                <cfelseif len(project_detail.project_emp_id)>
                    <cfoutput>#GET_EMP_INFO(project_detail.project_emp_id,0,0,0)#</cfoutput>
                </cfif>
            </td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold" style="width:100px;"><cf_get_lang_main no='70.Aşama'></td>
            <td><cfoutput>#get_pro_currency_name.stage#</cfoutput></td>
            <td class="txtbold"><cf_get_lang_main no='73.Öncelik'></td>
            <td><cfoutput query="get_priority">#get_hist_detail.priority#</cfoutput></td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold"><cf_get_lang no='676.İlişkili Proje'></td>
            <td>
                <cfif len(project_detail.related_project_id)>
                    <cfquery name="GET_PRO_NAME" datasource="#DSN#">
                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_detail.related_project_id#">
                    </cfquery>
                </cfif>
                <cfif len(project_detail.related_project_id)><cfoutput><!--- <a href="#request.self#?fuseaction=project.prodetail&id=#PROJECT_DETAIL.related_project_id#" class="tableyazi">#get_pro_name.project_head#</a> --->#get_pro_name.project_head#</cfoutput><cfelse><cf_get_lang_main no='1047.Projesiz'></cfif>
            </td>
            <td class="txtbold" style="width:100px;"><cf_get_lang no='116.Kalan Zaman'></td>
            <td nowrap>
                <cf_per_cent start_date = '#project_detail.target_start#' finish_date = '#project_detail.target_finish#' color1='66CC33' color2='3399FF' width="175">
                <cfset days=abs(datediff("d",project_detail.target_finish,project_detail.target_start))><cfoutput>#days+1# gün</cfoutput>
            </td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold"><cf_get_lang no='677.Hedef Tarih'></td>
	        <cfset target_start = date_add('h',session.pp.time_zone,project_detail.target_start)>
            <td>
				<cfoutput>#Dateformat(target_start,'dd/mm/yyyy')# #Timeformat(target_start,'HH:mm')# - </cfoutput>
				<cfset target_finish = date_add('h',session.pp.time_zone,project_detail.target_finish)>
				<cfoutput>#Dateformat(target_finish,'dd/mm/yyyy')# #Timeformat(target_finish,'HH:mm')#</cfoutput>
            </td>
            <td class="txtbold" style="width:200px;"><cf_get_lang no='92.Tamamlanma'></td>
            <td>
                <cfif len(project_detail.complete_rate)>
                    <cf_per_cent per_cent = '#project_detail.complete_rate#' color1='ff6600' color2='99cc66' width="150">
                <cfelse>
                    <cf_per_cent per_cent = '0' color1='ff6600' color2='99cc66' width="150">
                </cfif>
            </td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td colspan="4" class="txtbold">
				<cfset rec_date = date_add('h',session.pp.time_zone,project_detail.record_date)>
                <cf_get_lang_main no='71.Kayıt'>:
                <cfif len(project_detail.record_emp)>
                    <cfoutput>#GET_EMP_INFO(project_detail.record_emp,0,0)#</cfoutput>
                <cfelseif len(project_detail.record_par)>
                    <cfoutput>#GET_PAR_INFO(project_detail.record_par,0,1,0)#</cfoutput>
                </cfif>
                <cfoutput>#Dateformat(rec_date,'dd/mm/yyyy')#</cfoutput>
            </td>
        </tr>              
    </table>
<cfelse>
	<table border="0" cellspacing="0" cellpadding="0" style="width:100%">
		<tr class="color-row" style="height:20px;">
			<td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	</table>	
</cfif>
<form name="pop_gonder_graph" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.graph" method="post">
	<input type="hidden" name="project_id" id="project_id" value="">
</form>
<script type="text/javascript">
	function sent_project_graph(degisken)
	{
		document.getElementById('project_id').value = degisken;
		pop_gonder_graph.submit();
	}
</script>
