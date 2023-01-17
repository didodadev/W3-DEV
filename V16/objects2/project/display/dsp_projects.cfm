<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.project_status" default="1">
<cfinclude template="../query/get_projects_list.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_projects.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("session.pp.our_company_id")>
	<cfset my_our_comp_ = session.pp.our_company_id>
<cfelseif isdefined("session.ww.our_company_id")>
	<cfset my_our_comp_ = session.ww.our_company_id>
<cfelse>
	<cfset my_our_comp_ = session.ep.company_id>
</cfif>
<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_our_comp_#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.list_projects%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfif isdefined('attributes.dsp_projects_filter') and attributes.dsp_projects_filter eq 1>
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:100%">
		<tr class="formbold" style="height:30px;">
			<td><!---<cf_get_lang_main no='603.Projeler'>---></td>    	
			<td>
            	<cfform name="list_project" action="#request.self#?fuseaction=objects2.list_projects" method="post">
					<table align="right">
						<cfinclude template="../query/get_priority.cfm">
						<tr>
							<td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
							<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
							<td>
								<select name="priority_cat" id="priority_cat" style="width:100px;">
									<option value="" selected><cf_get_lang_main no='73.Öncelik'></option>
									<cfoutput query="get_cats">
										<option value="#priority_id#"<cfif isDefined("attributes.priority_cat") and (attributes.priority_cat is priority_id)>selected</cfif>>#priority#</option>
									</cfoutput>
								</select>
								<select name="currency" id="currency" style="width:90px; height:17px;">
									<option value="" selected><cf_get_lang_main no='70.Aşama'></option>
									<cfoutput query="get_procurrency">
										<option value="#process_row_id#"<cfif isDefined("attributes.currency") and (attributes.currency eq process_row_id)>selected</cfif>>#stage#</option>
									</cfoutput>
								</select>
								<select name="project_status" id="project_status" style="width:60px; height:17px;">
									<option value="0" <cfif isDefined("attributes.project_status") and (attributes.project_status eq 0)>selected</cfif>><cf_get_lang_main no='296.Tümü'>
									<option value="1" <cfif isDefined("attributes.project_status") and (attributes.project_status eq 1)>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
									<option value="-1" <cfif isDefined("attributes.project_status") and (attributes.project_status eq -1)>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
								</select>
							</td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</td>
							<td><cf_wrk_search_button is_excel='0'></td>
						</tr>
					</table>
				</cfform>
            </td>    	
		</tr>
	</table>
</cfif>
<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-list" style="width:100%">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:20px;"><cf_get_lang_main no='75.No'></td>
	  	<td class="form-title"><cf_get_lang_main no= '4.Proje'></td>
	  	<td class="form-title" style="width:160px;"><cf_get_lang_main no='162.Şirket'></td>
	 	<td class="form-title" style="width:75px;"><cf_get_lang_main no='73.Öncelik'></td>
	  	<td class="form-title" style="width:75px;"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
	  	<td class="form-title" style="width:90px;"><cf_get_lang_main no='70.Aşama'></td>
	</tr>
	<cfif get_projects.recordcount>
	  	<cfset project_stage_list = "">
	   	<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(pro_currency_id) and not listfind(project_stage_list,pro_currency_id)>
				<cfset project_stage_list=listappend(project_stage_list,pro_currency_id)>
			</cfif>
	   	</cfoutput>
		<cfif len(project_stage_list)>
			<cfset project_stage_list = listsort(project_stage_list,'numeric','ASC',',')>
			<cfquery name="GET_CURRENCY_NAME" datasource="#DSN#">
				SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
		</cfif>
	  	<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
		  		<td style="width:20px;"><font color="#get_projects.color#">&nbsp;#get_projects.CurrentRow#</font></td>
		  		<td><a href="javascript://" onclick="sent_project(#project_id#)" class="tableyazi">&nbsp;<font color="#get_projects.color#">#project_head#</font></a></td>
				<!---<td><a href="#request.self#?fuseaction=objects2.dsp_pro_detail&id=#encrypt(project_id,session.pp.userid,"CFMX_COMPAT","Hex")#" class="tableyazi">&nbsp;<font color="#get_projects.color#">#project_head#</font></a></td>--->
		  		<td>
					<cfif len(get_projects.company_id)>
						#get_par_info(get_projects.company_id,1,0,0)#
					</cfif>
		  		</td>
		  		<td><font color="#get_projects.color#">#get_projects.priority#</font></td>
		  		<cfset fdate=dateformat(get_projects.target_finish,"dd/mm/yyyy")>
				<td><font color="#get_projects.color#">#fdate#</font></td>
		  		<td><font color="#get_projects.color#">#get_currency_name.stage[listfind(project_stage_list,pro_currency_id,',')]#</font></td>
			</tr>
	  	</cfoutput>
    <cfelse>
   		<tr class="color-row" style="height:20px;">
			<td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
	  	</tr>
	</cfif>
</table>

<cfif not isDefined('attributes.is_paging') or (isDefined('attributes.is_paging') and attributes.is_paging eq 1)>
	<cfif attributes.totalrecords gt attributes.maxrows>
        <table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:30px;">
            <tr>
                <td> <cf_pages page="#attributes.page#"
                        page_type="3"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        adres="#attributes.fuseaction#&keyword=#attributes.keyword#&currency=#attributes.currency#&priority_cat=#attributes.priority_cat#"> </td>
                <!-- sil -->
                <td  class="label" style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_projects.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
            </tr>
        </table>
    </cfif>
</cfif>

<form name="pop_gonder" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.dsp_pro_detail" method="post">
	<input type="hidden" name="project_id" id="project_id" value="">
</form>

<script type="text/javascript">
	function sent_project(degisken)
	{
		document.getElementById('project_id').value = degisken;
		pop_gonder.submit();
	}
</script>
