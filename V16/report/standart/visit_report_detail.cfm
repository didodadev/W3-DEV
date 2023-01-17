<cfif isdefined("attributes.form_submitted")>
    <cfif isdefined("attributes.month") and len(attributes.month)>
    	<cfset date = attributes.day&'/'& attributes.month&'/'&'2012'>
        <cfset date1 = attributes.day1&'/'& attributes.month&'/'&'2012'>
        <cf_date tarih="date">
        <cf_date tarih="date1">
		<cfquery  name="get_wrk_visit_report" datasource="#dsn_report#">
       		SELECT 
                count(WRK_VISIT_ID) AS VISIT_COUNT,
                BROWSER_INFO,
                VISIT_SITE,
                VISIT_MODULE,
                VISIT_FUSEACTION,
                CASE USER_TYPE 
                     WHEN '0' THEN 'Calisan'
                     WHEN '1' THEN 'Partner'
                     WHEN '2' THEN 'Consumer'
                     WHEN '-1' THEN 'Ziyaretci'
                    END AS TIP 
            FROM
                WRK_VISIT_2012_#attributes.month#
            WHERE
                <cfif isdefined("attributes.browser_info") and len(attributes.browser_info)>BROWSER_INFO='#attributes.browser_info#' and</cfif>
                <cfif isdefined("attributes.visit_site")and len(attributes.visit_site)>VISIT_SITE='#attributes.visit_site#' and</cfif>
                <cfif isdefined("attributes.module") and len(attributes.module)>VISIT_MODULE='#attributes.module#' and</cfif>
                <cfif isdefined("attributes.fuseaction_name")and len(attributes.fuseaction_name)>VISIT_FUSEACTION like '%#attributes.fuseaction_name#%' and</cfif>
                <cfif isdefined("attributes.tip")and len(attributes.tip)>USER_TYPE='#attributes.tip#' and</cfif>
                <cfif isdefined("attributes.day") and len("attributes.day")>VISIT_DATE > #date# and </cfif>
                <cfif isdefined("attributes.day1") and len("attributes.day1")>VISIT_DATE < #date1# and </cfif>	
                    1=1	
            GROUP BY
            	BROWSER_INFO,
                VISIT_SITE,
                VISIT_MODULE,
                VISIT_FUSEACTION,
                USER_TYPE
            ORDER BY 
                VISIT_COUNT DESC 
        </cfquery>
    <cfelse>    
        <cfquery datasource="#dsn#" name="get_wrk_visit_report">
            SELECT 
                VISIT_COUNT,
                BROWSER_INFO,
                VISIT_SITE,
                VISIT_MODULE,
                VISIT_FUSEACTION,
                CASE USER_TYPE 
                     WHEN '0' THEN 'Calisan'
                     WHEN '1' THEN 'Partner'
                     WHEN '2' THEN 'Consumer'
                     WHEN '-1' THEN 'Ziyaretci'
                    END AS TIP 
            FROM
                WRK_VISIT_GENERAL_REPORT
            WHERE
                <cfif isdefined("attributes.browser_info") and len(attributes.browser_info)>BROWSER_INFO='#attributes.browser_info#' and</cfif>
                <cfif isdefined("attributes.visit_site")and len(attributes.visit_site)>VISIT_SITE='#attributes.visit_site#' and</cfif>
                <cfif isdefined("attributes.module") and len(attributes.module)>VISIT_MODULE='#attributes.module#' and</cfif>
                <cfif isdefined("attributes.fuseaction_name")and len(attributes.fuseaction_name)>VISIT_FUSEACTION like '%#attributes.fuseaction_name#%' and</cfif>
                <cfif isdefined("attributes.tip")and len(attributes.tip)>USER_TYPE='#attributes.tip#' and</cfif>	
                    1=1	
            ORDER BY 
                VISIT_COUNT DESC
        </cfquery>
        <cfquery dbtype="query" name="get_tip_count">
            SELECT SUM(VISIT_COUNT) AS TOTAL,TIP FROM get_wrk_visit_report GROUP BY TIP
        </cfquery>
    </cfif>
<cfelse>
	<cfscript>
	get_wrk_visit_report.recordcount=0;
	</cfscript>
</cfif>

<cfquery name="get_browser_info" datasource="#dsn#">
	SELECT DISTINCT(BROWSER_INFO) AS BROWSER_INFO FROM WRK_VISIT_GENERAL_REPORT WHERE BROWSER_INFO IS NOT NULL ORDER BY BROWSER_INFO ASC
</cfquery>

<cfquery name="get_domain" datasource="#dsn#">
	SELECT DISTINCT (VISIT_SITE) AS VISIT_SITE FROM WRK_VISIT_GENERAL_REPORT WHERE VISIT_SITE IS NOT NULL 
</cfquery>

<cfquery name="get_tip" datasource="#dsn#">
	SELECT 
		DISTINCT(USER_TYPE) AS TIP, 
		 CASE USER_TYPE 
				 WHEN '0' THEN 'Calisan'
				 WHEN '1' THEN 'Partner'
				 WHEN '2' THEN 'Consumer'
				 WHEN '-1' THEN 'Ziyaretci'
				END AS TIP_NAME
	FROM WRK_VISIT_GENERAL_REPORT
</cfquery>

<cfquery name="get_module" datasource="#dsn#">
	SELECT MODULE_SHORT_NAME  FROM MODULES WHERE MODULE_SHORT_NAME IS NOT NULL
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_wrk_visit_report.recordcount#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=report.visit_report_detail" method="post">
<cf_report_list_search title="#getLang('main',2653)#">
	<cf_report_list_search_area>
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">     
            <div class="row">
                <div class="col col-12 col-xs-12">
                     <div class="row formContent">
                         <div class="row" type="row">
                             <div class="col col-2 col-md-4 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                    <label><cf_get_lang_main no="2130.Browser"></label>
                                    <div>
                                        <select id="browser_info" name="browser_info">
                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                            <cfoutput query="get_browser_info">
                                                <option value="#BROWSER_INFO#" <cfif isdefined("attributes.browser_info") and attributes.browser_info eq  BROWSER_INFO>selected</cfif>>#BROWSER_INFO#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                 </div>
                             </div>
                             <div class="col col-2 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang_main no="480.Domain"></label>
                                     <div>
                                        <select name="visit_site" id="visit_site" style="width:110px;">
                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                            <cfoutput query="get_domain">
                                                <option value="#VISIT_SITE#" <cfif isdefined("attributes.visit_site") and attributes.visit_site eq visit_site>selected</cfif>>#VISIT_SITE#</option>
                                            </cfoutput>
                                        </select>
                                     </div>   
                                </div>
                             </div>
                             <div class="col col-2 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang no="1853.Fuseaction"></label>
                                    <div>
                                        <input type="text" width="110" name="fuseaction_name" <cfif isdefined("attributes.fuseaction_name")>value="<cfoutput>#attributes.fuseaction_name#</cfoutput>"</cfif>  id="fuseaction_name" />
                                    </div>   
                                </div>
                             </div>
                             <div class="col col-2 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang_main no="218.Tip"></label>
                                    <div>
                                            <select name="tip" id="tip">
                                                <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                                <cfoutput query="get_tip">
                                                  <option value="#TIP#" <cfif isdefined("attributes.tip") and attributes.tip eq tip>selected</cfif>>#TIP_NAME#</option>
                                                </cfoutput>
                                            </select>
                                   </div>
                                </div>
                             </div>
                             <div class="col col-2 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang_main no="1145.Modul"></label>
                                    <div>
                                        <select name="module" id="module" style="width:110px;">
                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                            <cfoutput query="get_module"> 		
                                                <option value="#MODULE_SHORT_NAME#" <cfif isdefined("attributes.module") and attributes.module eq MODULE_SHORT_NAME>selected</cfif>>#MODULE_SHORT_NAME#</option>
                                            </cfoutput>	
                                         </select>
                                    </div>    
                                </div>
                             </div>
                         </div>
                     </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>checked</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                        <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                        <cf_wrk_report_search_button is_excel='1' button_type='1' insert_info='#message#' search_function='control()'>            
                    </div>
                </div>
            </div>
              
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>	

<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
    </cfif>
    
    <cfif isDefined("attributes.form_submitted")>
        <cf_report_list>   
                <thead>
                    <tr>
                        <th width="15"></th>
                        <th width="100">Browser Info</th>
                        <th width="100">Domain</th>
                        <th width="80">Module</th>
                        <th>Fuseaction</th>
                        <th>User Type</th>
                        <th width="90">Visit Count</th>
                        <th class="header_icn_none">&nbsp;</th>
                    </tr>
            </thead> 
            <tbody>    
                    <cfif  get_wrk_visit_report.recordcount and isdefined("attributes.form_submitted")>
                        <cfoutput query="get_wrk_visit_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td>#BROWSER_INFO#</td>
                                <td>#VISIT_SITE#</td>
                                <td>#VISIT_MODULE#</td>
                                <td>#VISIT_FUSEACTION#</td>
                                <td>#TIP#</td>	
                                <td>#VISIT_COUNT#</td>
                                <td><a href="#request.self#?fuseaction=report.visit_report_user_detail&browser_info=#BROWSER_INFO#&visit_site=#VISIT_SITE#&visit_module=#VISIT_MODULE#&visit_fuseaction=#VISIT_FUSEACTION#&tip=#TIP#" ><img src="/images/update_list.gif" /></a></td>
                            </tr>
                        </cfoutput>				
                    <cfelse>
                        <tr>
                            <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>! </cfif></td>
                        </tr>
                    </cfif>
                </tbody>
        
        </cf_report_list>
    </cfif>               
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_string = ''>
	<cfif isdefined("attributes.browser_info") and len(attributes.browser_info)>
		<cfset url_string = '#url_string#&browser_info=#attributes.browser_info#'>
	</cfif>
	<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
		<cfset url_string = '#url_string#&form_submitted=1'>
	</cfif>
	<cfif isdefined("attributes.visit_site") and len(attributes.visit_site)>
		<cfset url_string = '#url_string#&visit_site=#attributes.visit_site#'>
	</cfif>
	<cfif isdefined("attributes.module") and len(attributes.module)>
		<cfset url_string = '#url_string#&module=#attributes.module#'>
	</cfif>
	<cfif isdefined("attributes.fuseaction_name") and len(attributes.fuseaction_name)>
		<cfset url_string = '#url_string#&fuseaction_name=#attributes.fuseaction_name#'>
	</cfif>
	<cfif isdefined("attributes.tip") and len(attributes.tip)>
		<cfset url_string = '#url_string#&tip=#attributes.tip#'>
	</cfif>
	<cfif isdefined("attributes.month") and len(attributes.month)>
		<cfset url_string = '#url_string#&month=#attributes.month#'>
	</cfif>
	<cfif isdefined("attributes.day") and len(attributes.day)>
		<cfset url_string = '#url_string#&day=#attributes.day#'>
	</cfif>
	<cfif isdefined("attributes.day1") and len(attributes.day1)>
		<cfset url_string = '#url_string#&day1=#attributes.day1#'>
	</cfif>
	
	<tr>
		<td>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="report.visit_report_detail#url_string#">
		</td>
		<cfif isdefined("get_tip_count")>
		<td>
			<cfoutput query="get_tip_count">
				<b>#TIP#-#TOTAL#</b> /
			</cfoutput>
		</td>
		</cfif>
	
</cfif>
<script type="text/javascript">
	function show_day()
	{
		document.getElementById('my_column1').style.display='';	
    }
    
    function control()
    {
        if(document.form.is_excel.checked==false)
					{
						document.form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
						return true;
					}
					else
						document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_visit_report_detail</cfoutput>"
					
		
    }
</script>
