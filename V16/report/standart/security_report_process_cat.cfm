<cfparam name="attributes.module_id_control" default="7">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.POSITION_NAME,
		EP.IS_MASTER,
		SPC.PROCESS_CAT,
		M.MODULE_SHORT_NAME
	FROM 
		#dsn_alias#.EMPLOYEE_POSITIONS EP,
		SETUP_PROCESS_CAT SPC,
		SETUP_PROCESS_CAT_ROWS SPCR,
		#dsn_alias#.MODULES M
	WHERE
		SPC.PROCESS_MODULE = M.MODULE_ID AND
		SPCR.PROCESS_CAT_ID = SPC.PROCESS_CAT_ID AND
		(
		SPCR.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
		SPCR.POSITION_CODE = EP.POSITION_CODE
		)
        AND EP.EMPLOYEE_ID <> 0 
        AND EP.EMPLOYEE_ID IS NOT NULL
	<cfif len(attributes.keyword)>
		AND
		(
		EP.POSITION_NAME LIKE '%#attributes.keyword#%' OR
		SPC.PROCESS_CAT LIKE '%#attributes.keyword#%' OR
		EP.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR  
		EP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	ORDER BY
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		SPC.PROCESS_CAT
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_process_cat.RecordCount#">
<cfform name="get_process_cat" action="#request.self#?fuseaction=report.security_report_process_cat" method="post">
	<cf_report_list_search title="#getLang('report',1961)#">
		<cf_report_list_search_area>
		  <div class="row">
			<div class="col col-12 col-xs-12">
				<div class="row formContent">
					<div class="row" type="row">
						<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
						 <div class="col col-3 col-md-6 col-xs-12">
							<div class="form-group">
								<label class="col col-12 col-xs-12"><cf_get_lang_main no='48.Filtre'></label>
								    <div class="col col-12 col-xs-12">
									    <cfinput type="text" name="keyword" value="#attributes.keyword#">
								    </div>														
							</div>
						 </div>
					</div>					
				</div>
				<div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label> 
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                        <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
                    </div> 
                </div>
			</div>
		  </div>

            <!---
			<table>
				<tr>
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button is_excel="1" button_type="1"></td>	
				</tr>
			</table>
		--->
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>

<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">    
</cfif>

<cfif isDefined("attributes.form_submitted")>
<cf_report_list>
		<thead>
			<tr> 
				<th width="150"><cf_get_lang_main no='158.Ad Soyad'></th>
				<th><cf_get_lang_main no='1085.Pozisyon'></th>
				<th>M</th>
				<th><cf_get_lang no='7.Modül'></th>
				<th width="150"><cf_get_lang no='1962.İşlem Kategorisi'></th>
			</tr>
		</thead>
        <tbody>
			<cfif get_process_cat.recordcount>
				<cfoutput query="get_process_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>#POSITION_NAME#</td>
                        <td><cfif IS_MASTER eq 1>M</cfif></td>
                        <td>#MODULE_SHORT_NAME#</td>
                        <td>#PROCESS_CAT#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
</cf_report_list>


<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.form_submitted)>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
	
	  <cf_paging
	      page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="report.security_report_process_cat#url_str#">
		
    </cfif>
</cfif>

<script>
    function control()
    {
		if(document.get_process_cat.is_excel.checked==false)
		{
			document.get_process_cat.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.get_process_cat.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_security_report_process_cat</cfoutput>"
	}
</script>
