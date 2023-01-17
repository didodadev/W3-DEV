<cfsetting showdebugoutput="no">
<cfinclude template="../../project/query/get_work_history.cfm">
<cfinclude template="../../project/query/get_work.cfm">
<cfquery name="GET_ACTIVITY" datasource="#DSN#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1
</cfquery>
<cfoutput query="get_work_history">
<cfset work_detail_ = replace(work_detail,'<form','<fform','all')>
<cfset work_detail_ = replace(work_detail_,'</form','</fform','all')>
<table width="100%" style="filter:alpha(Opacity=90,FinishOpacity=90);" class="color-border">
	<tr height="25" class="color-list">
		<td><font color="##FF0000"><cf_get_lang_main no='68.Başlık'> :</font>#work_head#</td>
	</tr>
	<tr class="color-row">
		<td><b><font color="##FF0000"><cf_get_lang_main no='217.Açıklama'> :</font></b></font><br />#work_detail_#</td>
	</tr>
</table>
<table width="100%" style="filter:alpha(Opacity=60,FinishOpacity=30);"  class="color-row">
	<tr style="height:15px;">
		<td>
			<font color="##FF0000"><cf_get_lang_main no='157.Görevli'>:</font>
			<cfif upd_work.project_emp_id neq 0 and len(upd_work.project_emp_id)>
				<cfset person="#get_emp_info(project_emp_id,0,0)#">
			<cfelseif outsrc_partner_id neq 0 and len(outsrc_partner_id)>
				<cfset person="#get_par_info(outsrc_partner_id,0,0,0)#">
			<cfelse>
				<cfset person="">
			</cfif>
			#person#&nbsp;
		</td>
		<td>
			<font color="##FF0000"><cf_get_lang_main no='479.Güncelleyen'> :</font>
			<cfif len(get_work_history.update_author)>
				#get_emp_info(get_work_history.update_author,0,1)#
			</cfif>
			<cfif len(get_work_history.update_par)>
				#get_par_info(get_work_history.update_par,0,0,1)#
			</cfif>
			&nbsp;
		</td>
		<td>
			<cfif Len(update_date)>
            <cfif isDefined('session.ep.userid')>
				<cfset upd_date = date_add('h',session.ep.time_zone,update_date)>
			<cfelseif isDefined('session.pda.userid')>
				<cfset upd_date = date_add('h',session.pda.time_zone,update_date)>            
            </cfif>
			<font color="##FF0000">Güncelleme Tarihi :</font> #Dateformat(upd_date,'dd/mm/yyyy')# #Timeformat(upd_date,'HH:mm')#<br/>
			</cfif>
		</td>
	</tr>	
	<tr style="height:15px;">
		<cfif len(target_start)>
            <cfif isDefined('session.ep.userid')>
				<cfset sdate=date_add("h",session.ep.time_zone,TARGET_START)>
			<cfelseif isDefined('session.pda.userid')>
            	<cfset sdate=date_add("h",session.pda.time_zone,TARGET_START)>
            </cfif>
            <td>
				<font color="##FF0000"><cf_get_lang_main no='243.Başlangıç'>:</font> #dateformat(sdate,'dd/mm/yyyy')# #timeformat(sdate,'HH:mm')#
			</td>
		<cfelse>
			<td></td>
		</cfif>
		<cfif len(target_finish)>
        	<cfif isDefined('session.ep.userid')>
				<cfset fdate=date_add("h",session.ep.time_zone,TARGET_FINISH)>
			<cfelseif isDefined('session.pda.userid')>
				<cfset fdate=date_add("h",session.pda.time_zone,TARGET_FINISH)>          
            </cfif>
            <td>
				<font color="##FF0000"><cf_get_lang_main no='288.Bitiş'>:</font> #dateformat(fdate,'dd/mm/yyyy')# #timeformat(fdate,'HH:mm')#
			</td>
				<cfelse>
			<td></td>
		</cfif>
		<td>
			<cfif isdefined('estimated_time') and len(estimated_time)>
				<cfset liste=#estimated_time#/60>
				<cfset saat_=#listfirst(liste,'.')#>
				<cfset dak_=#estimated_time#-saat_*60>
				<font color="##FF0000">Öngörülen Süre:</font>#saat_#&nbsp;<cf_get_lang_main no ='79.saat'>&nbsp;&nbsp;<cfif dak_ gt 0>#dak_#&nbsp;<cf_get_lang_main no='1415.dk'>.</cfif>
			<cfelse>
				<font color="##FF0000">Öngörülen Süre:</font> -&nbsp;-
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			<cfquery name="GET_PROCESS" datasource="#dsn#">
				SELECT STAGE FROM PROCESS_TYPE,PROCESS_TYPE_ROWS WHERE PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = #get_work_history.work_currency_id#
			</cfquery>
			<font color="##FF0000"><cf_get_lang_main no='70.Aşama'>:</font> #get_process.stage#
		</td>
		<td><font color="##FF0000"><cf_get_lang_main no='73.Öncelik'>:</font> #prıority#</td>
		<td><font color="##FF0000">İş Kategorisi:</font> #work_cat#</td>
	</tr>
	<tr style="height:15px;">
		<td>
			<cfif len(activity_id)>
				<cfquery name="get_act" dbtype="query">
					SELECT ACTIVITY_NAME FROM GET_ACTIVITY WHERE ACTIVITY_ID = #activity_id#
				</cfquery>
			</cfif>
			<font color="##FF0000">Aktivite Tipi:</font> <cfif len(activity_id)>#get_act.activity_name#</cfif>
		</td>
		<td>
			<font color="##FF0000">Harcanan Zaman&nbsp;</font><cfif len(get_work_history.TOTAL_TIME_HOUR)>#get_work_history.TOTAL_TIME_HOUR#&nbsp;<cf_get_lang_main no='79.saat'>&nbsp;<cfelse>-</cfif>
			<cfif len(get_work_history.TOTAL_TIME_MINUTE)>#get_work_history.TOTAL_TIME_MINUTE#&nbsp;<cf_get_lang_main no='1415.dk'>.&nbsp;<cfelse>-</cfif>
		</td>
		<td>
			<font color="##FF0000">Tamamlanma Yüzdesi:&nbsp;</font>%&nbsp;#get_work_history.to_complete#
		</td>
		<td></td>
	</tr>
	<tr>
		<td colspan="3"><cfif get_work_history.recordcount gt 1><hr></cfif></td>
	</tr>
</table>
</cfoutput>
