<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif not isdefined("attributes.is_form_submitted")>
	<cfset filtered = 1>
<cfelse>
	<cfset filtered = 0>
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif filtered eq 1>
	<cfquery name="get_cv" datasource="#dsn#">
		SELECT
			AP.EMPAPP_ID,
			AP.NAME,
			AP.SURNAME,
			AP.EMAIL,
			AP.MOBILCODE,
			AP.MOBIL,
			AP.MOBILCODE2,
			AP.MOBIL2,
			AP.PHOTO,
			AP.PHOTO_SERVER_ID,
			AP.HOMETELCODE,
			AP.HOMETEL,
			AP.SEX,
			AP.CV_STAGE,
			AP.APP_COLOR_STATUS,
			AP.RECORD_DATE
		FROM
			EMPLOYEES_APP AP
		WHERE
			EMPAPP_ID IS NOT NULL
			<cfif len(attributes.keyword)>
				AND (AP.NAME + ' ' + AP.SURNAME LIKE '#attributes.keyword#%' OR AP.SURNAME LIKE '#attributes.keyword#%')
			</cfif>
			ORDER BY 
			NAME
	</cfquery>
<cfelse>
	<cfset get_cv.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_cv.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('main',48)#">
	<cf_medium_list_search_area>
	<!--- Arama --->
		<cfform name="search_cv" action="#request.self#?fuseaction=hr.popup_list_cvs#url_str#" method="post">
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='29767.Cv'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>	
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button>
					</td>
				</tr>
			</table>
		</cfform>
	<!--- Arama --->
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
			<th align="center"><cf_get_lang dictionary_id='57756.Durum'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_cv.recordcount>
			<cfset app_color_status_list =''>
				<cfset cv_stage_list=''>
					<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(app_color_status) and (not listfind(app_color_status_list,app_color_status))>
							<cfset app_color_status_list = listappend(app_color_status_list,get_cv.app_color_status,',')>
						</cfif>
						<cfif len(cv_stage) and (not listfind(cv_stage_list,cv_stage))>
							<cfset cv_stage_list = listappend(cv_stage_list,cv_stage)>
						</cfif>
					</cfoutput>	
			<cfif len(cv_stage_list)>
				<cfset cv_stage_list=listsort(cv_stage_list,"numeric","ASC",",")>
				<cfquery name="process_type" datasource="#dsn#">
					SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#cv_stage_list#) ORDER BY PROCESS_ROW_ID
				</cfquery>
			</cfif>
			<cfif listlen(app_color_status_list)>
				<cfquery name="get_cv_status" datasource="#dsn#">
					SELECT 
						STATUS_ID,
						STATUS,
						ICON_NAME
					FROM 
						SETUP_CV_STATUS
					WHERE 
						STATUS_ID IN (#app_color_status_list#)
					ORDER BY 
						STATUS_ID
				</cfquery>
				<cfset app_color_status_list = listsort(valuelist(get_cv_status.status_id,','),"numeric","ASC",',')>
			</cfif>
			<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td><a href="javascript://" onclick="send_info('#EMPAPP_ID#','#name# #surname#')" class="tableyazi">#NAME# #SURNAME#</a></td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td align="center">
					<cfif len(CV_STAGE)>#process_type.stage[listfind(cv_stage_list,CV_STAGE,',')]#</cfif>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="4"><cfif filtered eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif len(attributes.keyword)>
		<!---<cfset url_str = "#url_str#&keyword=#attributes.keyword#&is_form_submitted=1">--->
			<cfif isdefined("attributes.field_name")>
				<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
			</cfif>
			<cfif isdefined("attributes.field_id")>
				<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
			</cfif>
			<cfset url_str = "#url_str#&is_form_submitted=1">
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0" width="99%" height="30" align="center">
		<tr>
			<td> <cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="hr.popup_list_cvs#url_str#"> </td>
				<!-- sil -->
				<td style="text-align:right;" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
		</tr>
	</table>
</cfif>
<br/>
<script type="text/javascript">
document.getElementById('keyword').focus();
function send_info(id,name)
{	
	<cfif isdefined("attributes.field_id")>
		window.opener.document.getElementById("<cfoutput>#attributes.field_id#</cfoutput>").value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		window.opener.document.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value = name;
	</cfif>
	window.close();
}
</script>
