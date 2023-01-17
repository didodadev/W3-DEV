<cfinclude template="../display/report_menu.cfm"><cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_schedules" datasource="#dsn#">
        SELECT 
            SR.*,
            R.REPORT_NAME AS REPORT,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_ID,
            E.EMPLOYEE_SURNAME
        FROM
            SCHEDULED_REPORTS SR,
            REPORTS R,
            EMPLOYEES E
        WHERE
            R.REPORT_ID = SR.REPORT_ID
            AND
            E.EMPLOYEE_ID = SR.RECORD_EMP
            <cfif len(attributes.keyword)>
            AND
            (
            R.REPORT_NAME LIKE '%#attributes.keyword#%'
            OR
            SR.REPORT_NAME LIKE '%#attributes.keyword#%'
            )
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_schedules.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_schedules.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_catalystHeader>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='38783.Periyodik Raporlar'></cfsavecontent>
<cf_box title="#title#" uidrop="1">
    <cfform name="filter" action="#request.self#?fuseaction=report.list_schedules" method="post">
		<cf_box_search more="0">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="form-group">
                <input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" maxlength="255">
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>
            <div class="form-group"><cf_wrk_search_button button_type="4"></div>
            <div class="form-group"><a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_schedule_settings&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></div>
        </cf_box_search>
    </cfform>
	<cf_flat_list>
        <thead>
            <tr>
                <th width="250"><cf_get_lang dictionary_id='38818.Zamanlı Rapor'></th>
                <th><cf_get_lang dictionary_id='57434.Rapor'></th>
                <th width="150"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                <th width="65"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                <th style="width:20px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_schedule_settings&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            </tr>
        </thead>
        <tbody>
			<cfif get_schedules.recordcount>
				<cfoutput query="get_schedules" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#report_name#</td>
                        <td>#REPORT#</td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                        <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                        <td><a href="#request.self#?fuseaction=settings.list_schedule_settings&event=upd&schedule_id=#replace(SCHEDULE_IDS,",","","ALL")#" class="tableyazi"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr class="color-row">
                	<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
    <tr>
      <td>
      	<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>		
		<cfif len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
        <cf_pages page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="report.list_schedules#url_str#"> </td>
      <!-- sil --><td align="right" style="text-align:right;"> <cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	document.getElementById("keyword").focus();
</script>
