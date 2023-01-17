<cfquery name="GET_WORKS" datasource="#DSN#">
    SELECT 
        PW.WORK_HEAD,
        PW.WORK_ID,		
        PW.TARGET_FINISH,
        PW.WORK_CURRENCY_ID,
        PW.WORK_PRIORITY_ID,
        SP.COLOR,
        SP.PRIORITY
    FROM 
        PRO_WORKS PW,
        SETUP_PRIORITY SP
    WHERE 
        PW.WORK_STATUS=1 AND
        (
        	PW.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        )
        AND PW.WORK_PRIORITY_ID=SP.PRIORITY_ID
    ORDER BY 
        PW.RECORD_DATE	DESC		
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" class="color-list" style="width:100%">
	<tr class="color-header" style="height:22px;">
      	<td class="form-title"><cf_get_lang_main no='1408.Başlık'></td>
	  	<td class="form-title" style="width:80px;"><cf_get_lang_main no='70.Aşama'></td>
	  	<td class="form-title" style="width:80px;"><cf_get_lang_main no='73.Öncelik'></td>
	  	<td class="form-title" style="width:65px;"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
	  <!---<td width="15"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_opportunity"><img src="/images/plus_square.gif" border="0"></a></td>--->
	</tr>
	<cfif get_works.recordcount>
		<cfset project_stage_list = "">
		<cfoutput query="get_works">
			<cfif len(work_currency_id) and not listfind(project_stage_list,work_currency_id)>
				<cfset project_stage_list=listappend(project_stage_list,work_currency_id)>
			</cfif>
		</cfoutput>
		<cfif len(project_stage_list)>
			<cfset project_stage_list = listsort(project_stage_list,'numeric','ASC',',')>
			<cfquery name="GET_CURRENCY_NAME" datasource="#DSN#">
				SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
		</cfif>
		<cfoutput query="get_works">
			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(get_works.work_id,"WORKCUBE","BLOWFISH","Hex")#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif>','medium');" class="tableyazi">#get_works.work_head#</a></td>
				<td>#get_currency_name.stage[listfind(project_stage_list,work_currency_id,',')]#</td>
				<td><font color="#get_works.color#">#get_works.priority#</font></td>	
				<td>#dateformat(get_works.target_finish,'dd/mm/yyyy')#</td>	
				<!---<td align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#GET_WORKS.WORK_ID#&id=','medium');"><img src="/images/update_list.gif" border="0"></a></td>--->
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td>
				<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
			</td>
		</tr>
	</cfif>
</table>

