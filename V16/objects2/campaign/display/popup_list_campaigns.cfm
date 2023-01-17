<script type="text/javascript">
function don(id,name,startdate,finishdate,start_hour,start_minute,finish_hour,finish_minute)
{
	<cfif isdefined("attributes.field_id")>
		window.opener.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		window.opener.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_start_date")>
		window.opener.<cfoutput>#field_start_date#</cfoutput>.value = startdate;
	</cfif>
	<cfif isdefined("attributes.field_start_date1")>
		window.opener.<cfoutput>#field_start_date1#</cfoutput>.value = startdate;
	</cfif>
	<cfif isdefined("attributes.field_finish_date")>
		<cfif isdefined("attributes.is_next_day")>
			window.opener.<cfoutput>#field_finish_date#</cfoutput>.value = date_add("d",1,finishdate);
		<cfelse>
			window.opener.<cfoutput>#field_finish_date#</cfoutput>.value = finishdate;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_finish_date1")>
		<cfif isdefined("attributes.is_next_day")>
			window.opener.<cfoutput>#field_finish_date1#</cfoutput>.value = date_add("d",1,finishdate);
		<cfelse>
			window.opener.<cfoutput>#field_finish_date1#</cfoutput>.value = finishdate;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.call_function") and attributes.call_function is 'add_camp_date'>
		window.opener.<cfoutput>#call_function#</cfoutput>(start_hour,start_minute,finish_hour,finish_minute);
	<cfelseif isdefined("attributes.call_function")>
		window.opener.<cfoutput>#call_function#</cfoutput>();
	</cfif>
	window.close();
}
</script>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfif isdefined("session.ww")>
	<cfset attributes.compid = session.ww.our_company_id>
<cfelse>
	<cfset attributes.compid = session.pp.our_company_id>
</cfif>
<cfquery name="CAMPAIGNS" datasource="#DSN3#">
	SELECT
		CAMPAIGNS.CAMP_ID,
		CAMPAIGNS.CAMP_CAT_ID,
		CAMPAIGNS.CAMP_NO,
		CAMPAIGNS.CAMP_STATUS,
		CAMPAIGNS.CAMP_HEAD,
		CAMPAIGNS.PROJECT_ID,
		CAMPAIGNS.CAMP_STAGE_ID,
		CAMPAIGNS.CAMP_STARTDATE,
		CAMPAIGNS.CAMP_FINISHDATE,
		CAMPAIGNS.CAMP_OBJECTIVE,
		CAMPAIGNS.LEADER_EMPLOYEE_ID
	FROM
		CAMPAIGNS
WHERE
	CAMPAIGNS.IS_INTERNET = 1 AND
    CAMPAIGNS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.compid#">
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND 
		(
			CAMPAIGNS.CAMP_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			OR
			CAMPAIGNS.CAMP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			OR
			CAMPAIGNS.CAMP_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		)
	</cfif>
	<cfif isDefined("attributes.tarih_kontrol") and (attributes.tarih_kontrol eq 1)>
		AND CAMPAIGNS.CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
	</cfif>
ORDER BY 	
	CAMPAIGNS.CAMP_HEAD
</cfquery>
<cfparam name="attributes.totalrecords" default='#campaigns.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="headbold" height="35">Kampanyalar</td>
		<td  style="text-align:right;">
			<table>
				<tr>
					<cfform name="search_asset" action="" method="post">
						<td><cf_get_lang_main no='48.Filtre'>:</td>
						<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#"></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</td>
						<td>
							<select name="tarih_kontrol" id="tarih_kontrol">
								<option value="0" <cfif isdefined("attributes.tarih_kontrol") and (attributes.tarih_kontrol eq 0)>selected</cfif>>Tümü</option>
								<option value="1" <cfif isdefined("attributes.tarih_kontrol") and (attributes.tarih_kontrol eq 1)>selected</cfif>>Bugünden Sonrası</option>
							</select>
						</td>
						<td><cf_wrk_search_button></td>
					</cfform>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" align="center" class="color-border">
	<tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang_main no='75.No'></td>
		<td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
		<td class="form-title" width="65"><cf_get_lang_main no='89.Başlama'></td>
		<td class="form-title" width="65"><cf_get_lang_main no='90.Bitiş'></td>
		<td class="form-title" width="150">Lider</td>
		<td class="form-title" width="75">Proje</td>
	</tr>
	<cfif campaigns.recordcount>
		<cfoutput query="campaigns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<cfset camp_start_date=date_add("H",session_base.time_zone,camp_startdate)>
				<cfset camp_finish_date=date_add("H",session_base.time_zone,camp_finishdate)>
				<cfset camp_start_hour=datepart("H",camp_start_date)>
				<cfset camp_start_minute=datepart("N",camp_start_date)>
				<cfset camp_finish_hour=datepart("H",camp_finish_date)>
				<cfset camp_finish_minute=datepart("N",camp_finish_date)>
				<td><a href="javascript://" onClick="don('#camp_id#','#camp_head# (#dateformat(camp_start_date,'dd/mm/yyyy')# - #dateformat(camp_finish_date,'dd/mm/yyyy')#)','#dateformat(camp_start_date,'dd/mm/yyyy')#','#dateformat(camp_finish_date,'dd/mm/yyyy')#','#camp_start_hour#','#camp_start_minute#','#camp_finish_hour#','#camp_finish_minute#');" class="tableyazi">#camp_no#</a></td>
				<td><a href="javascript://" onClick="don('#camp_id#','#camp_head# (#dateformat(camp_start_date,'dd/mm/yyyy')# - #dateformat(camp_finish_date,'dd/mm/yyyy')#)','#dateformat(camp_start_date,'dd/mm/yyyy')#','#dateformat(camp_finish_date,'dd/mm/yyyy')#','#camp_start_hour#','#camp_start_minute#','#camp_finish_hour#','#camp_finish_minute#');" class="tableyazi">#camp_head#</a></td>
				<td>#dateformat(camp_start_date,'dd/mm/yyyy')#</td>
				<td>#dateformat(camp_finish_date,'dd/mm/yyyy')#</td>
				<td><cfif len(LEADER_EMPLOYEE_ID)>#get_emp_info(LEADER_EMPLOYEE_ID,0,1)#</cfif></td>
				<td>
					<cfif len(PROJECT_ID)>
						<cfset attributes.project_id = PROJECT_ID>
						<cfquery name="GET_PROJECT_HEAD" datasource="#dsn#">
							SELECT
								PROJECT_HEAD
							FROM
								PRO_PROJECTS
							WHERE
								PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROJECT_ID#">
						</cfquery>			  
						#GET_PROJECT_HEAD.project_head#
					</cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>! 
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" align="center" width="98%">
		<tr>
			<td>
				<cfset adres=attributes.fuseaction>
				<cfif len(attributes.keyword)>
					<cfset adres = "#adres#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isdefined("attributes.tarih_kontrol") and len(attributes.tarih_kontrol)>
					<cfset adres = "#adres#&tarih_kontrol=#attributes.tarih_kontrol#">
				</cfif>
				<cfif isdefined("attributes.field_id")>
					<cfset adres = "#adres#&field_id=#attributes.field_id#">
				</cfif>
				<cfif isDefined('attributes.field_name') and len(attributes.field_name)>
					<cfset adres = "#adres#&field_name=#attributes.field_name#">
				</cfif>
				<cfif isDefined('attributes.field_start_date') and len(attributes.field_start_date)>
					<cfset adres = "#adres#&field_start_date=#attributes.field_start_date#">
				</cfif>
				<cfif isDefined('attributes.field_start_date1') and len(attributes.field_start_date1)>
					<cfset adres = "#adres#&field_start_date1=#attributes.field_start_date1#">
				</cfif>
				<cfif isDefined('attributes.field_finish_date') and len(attributes.field_finish_date)>
					<cfset adres = "#adres#&field_finish_date=#attributes.field_finish_date#">
				</cfif>
				<cfif isDefined('attributes.field_finish_date1') and len(attributes.field_finish_date1)>
					<cfset adres = "#adres#&field_finish_date1=#attributes.field_finish_date1#">
				</cfif>
				<cfif isDefined('attributes.is_next_day')>
					<cfset adres = "#adres#&is_next_day=#attributes.is_next_day#">
				</cfif>
				<cfif isDefined('attributes.call_function') and len(attributes.call_function)>
					<cfset adres = "#adres#&call_function=#attributes.call_function#">
				</cfif>
				<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#"> </td>
					<!-- sil --><td height="30"  style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
