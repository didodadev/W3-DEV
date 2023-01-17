<cfparam name="attributes.module_id_control" default="7">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_EMP" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME,
		IS_MASTER,
		LEVEL_ID,
		USER_GROUP_ID 
	FROM 
		EMPLOYEE_POSITIONS
	<cfif len(attributes.keyword)>
	WHERE
		POSITION_NAME LIKE '%#attributes.keyword#%' OR
		EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR  
		EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'		
	</cfif>
	ORDER BY
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME
</cfquery>
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT MODULE_ID,MODULE_SHORT_NAME FROM MODULES WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_NAME
</cfquery>
<cfquery name="get_user_groups" datasource="#DSN#">
	SELECT 
		USER_GROUP_NAME,USER_GROUP_ID,USER_GROUP_PERMISSIONS 
	FROM 
		USER_GROUP
	ORDER BY
		USER_GROUP_ID
</cfquery>
<cfoutput query="get_user_groups">
	<cfset 'group_#USER_GROUP_ID#' = USER_GROUP_PERMISSIONS>
	<cfset 'group_name_#USER_GROUP_ID#' = USER_GROUP_NAME>
</cfoutput>
<cfparam name="attributes.totalrecords" default="#get_emp.RecordCount#">
<cfform name="get_emp" action="#request.self#?fuseaction=report.security_report_module_based" method="post">
    <cf_report_list_search title="#getLang('report',1959)#">
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
                          <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel"  id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label> 
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
                <th><cf_get_lang_main no='158.Ad Soyad'></th>
                <th><cf_get_lang_main no='1085.Pozisyon'></th>
                <th>M</th>
                <th>G</th>
                <th><cf_get_lang_main no='1557.Grup Adı'></th>
                <cfoutput query="get_modules">
                    <cfset detay = replace(MODULE_SHORT_NAME,'"',"'",'all')>
                    <th title="#detay#">#left(MODULE_SHORT_NAME,20)#</th>
                </cfoutput>
            </tr>
            </thead>
            <tbody>
                <cfif get_emp.recordcount>
                    <cfoutput query="get_emp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>#position_name#</td>
                        <td><cfif IS_MASTER eq 1>M</cfif></td>
                        <td><cfif listlen(get_emp.level_id)>K<cfelseif len(get_emp.user_group_id)>G<cfelse>T</cfif></td>
                        <td><cfif len(get_emp.user_group_id) and isdefined('group_name_#get_emp.user_group_id#')>#evaluate('group_name_#get_emp.user_group_id#')#</cfif></td>
                        <cfloop query="get_modules">
                            <td>                    
                            <cfif len(get_emp.user_group_id)>
                                <cfif isdefined("group_#get_emp.user_group_id#") and listFindNoCase(evaluate("group_#get_emp.user_group_id#"),get_modules.module_id)>1<cfelse>0</cfif>
                            <cfelse>
                                -
                            </cfif>
                        </td>
                        </cfloop>
                    </tr>
                    </cfoutput>
                <cfelse>
                      <tr>
                        <td colspan="60"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
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
			  adres="report.security_report_module_based=#url_str#"> 	
</cfif>

<script>
    function control()
    {
		if(document.get_emp.is_excel.checked==false)
		{
			document.get_emp.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.get_emp.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_security_report_module_based&maxrows=#get_emp.recordcount#</cfoutput>"
	}
</script>




