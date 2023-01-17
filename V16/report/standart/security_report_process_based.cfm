<cfparam name="attributes.module_id_control" default="7">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_process" datasource="#dsn#">
	SELECT
		PROCESS_NAME,
		PT.PROCESS_ID,
		0 AS PROCESS_ROW_ID,
		STAGE, 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME,
		IS_MASTER	
	FROM 
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_ROWS_POSID PTRP,
		EMPLOYEE_POSITIONS EP
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTRP.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		EP.POSITION_ID = PRO_POSITION_ID
	<cfif len(attributes.keyword)>
		AND
		(
		POSITION_NAME LIKE '%#attributes.keyword#%' OR
		PROCESS_NAME LIKE '%#attributes.keyword#%' OR
		EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR  
		EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	UNION
	SELECT
		PROCESS_NAME,
		PT.PROCESS_ID,
		PTRW.PROCESS_ROW_ID,
		STAGE, 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME,
		IS_MASTER	
	FROM 
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_ROWS_POSID PTRP,
		PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
		EMPLOYEE_POSITIONS EP
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PTRP.PROCESS_ROW_ID IS NULL AND
		PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
		PTRW.MAINWORKGROUP_ID = PTRP.WORKGROUP_ID AND
		EP.POSITION_ID = PTRP.PRO_POSITION_ID 
	<cfif len(attributes.keyword)>
		AND
		(
		POSITION_NAME LIKE '%#attributes.keyword#%' OR
		PROCESS_NAME LIKE '%#attributes.keyword#%' OR
		EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR  
		EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	GROUP BY
		PROCESS_NAME,
		PT.PROCESS_ID,
		PTRW.PROCESS_ROW_ID,
		STAGE, 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME,
		IS_MASTER
	ORDER BY
		EMPLOYEE_NAME,EMPLOYEE_SURNAME,PROCESS_NAME
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_process.RecordCount#">
<cfform name="get_process" action="#request.self#?fuseaction=report.security_report_process_based" method="post">
 <input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<cf_report_list_search title="#getLang('report',1960)#">
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

<cfif isdefined("attributes.form_submitted")>
   <cf_report_list>
        <thead>
            <tr> 
                <th width="150"><cf_get_lang_main no='158.Ad Soyad'></th>
                <th><cf_get_lang_main no='1085.Pozisyon'></th>
                <th>M</th>
                <th width="150"><cf_get_lang_main no='1447.Süreç'></th>
                <th><cf_get_lang_main no='70.Aşama'></th>
            </tr>
        </thead>
        <tbody>
        	<cfif get_process.recordcount>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows = get_process.recordcount>
				</cfif>
				<cfoutput query="get_process" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>#position_name#</td>
                        <td><cfif IS_MASTER eq 1>M</cfif></td>
                        <td>#PROCESS_NAME#</td>
                        <td>#STAGE#</td>	
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
                </tr> 
            </cfif>
        </tbody>

    </cf_report_list>
</cfif>  
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
			  adres="report.security_report_process_based#url_str#"> 
	
</cfif>
<script>
    function control()
    {
		if(document.get_process.is_excel.checked==false)
		{
			document.get_process.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.get_process.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_security_report_process_based</cfoutput>"
	}
</script>



