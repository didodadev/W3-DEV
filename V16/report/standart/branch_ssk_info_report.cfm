<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.pdks_status" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_emp_branch" datasource="#DSN#">
		SELECT
			*
		FROM
			EMPLOYEE_POSITION_BRANCHES
		WHERE
			POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfset emp_branch_list=valuelist(get_emp_branch.branch_id)>
	<cfquery name="get_branches" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			BRANCH 
		WHERE 
			BRANCH_ID = BRANCH_ID
			<cfif len(attributes.keyword)>
				AND BRANCH_NAME LIKE '%#attributes.keyword#%'
			</cfif>
			<cfif not session.ep.ehesap>
				AND BRANCH_ID IN (#emp_branch_list#)
			</cfif>
			<cfif len(attributes.status) and attributes.status eq 1>
				AND BRANCH_STATUS = 1
			<cfelseif len(attributes.status) and attributes.status eq 0>
				AND BRANCH_STATUS = 0
		   </cfif>
		   <cfif len(attributes.pdks_status) and attributes.pdks_status eq 1>
				AND (BRANCH_PDKS_CODE IS NOT NULL OR BRANCH_PDKS_CODE <> '')
			<cfelseif len(attributes.pdks_status) and attributes.pdks_status eq 0>
				AND (BRANCH_PDKS_CODE IS NULL OR BRANCH_PDKS_CODE = '')
		   </cfif>
		ORDER BY 
			BRANCH_NAME
	</cfquery>
<cfelse>
    <cfset get_branches.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_branches.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header"><cf_get_lang dictionary_id ='39577.Şube SGK Bilgileri Raporu'></cfsavecontent>
<cfform name="theform" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#header#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-12">
                                <div class="form-group">
                                    <label class="col col-12"><cf_get_lang dictionary_id='57460.Filtre'>:</label>
                                    <div class="col col-12">
                                        <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-12">
                                        <select name="status" id="status">
                                            <option value=""><cf_get_lang dictionary_id ='57756.Durum'></option>
                                            <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                            <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>												
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-12">
                                        <select name="pdks_status" id="pdks_status" style="width:75px;">
                                            <option value=""><cf_get_lang dictionary_id='58009.PDKS'></option>
                                            <option value="1" <cfif attributes.pdks_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='39965.Dolu Olanlar'></option>
                                            <option value="0" <cfif attributes.pdks_status eq 0>selected</cfif>><cf_get_lang dictionary_id ='39966.Boş Olanlar'></option>												
                                        </select>
                                    </div>
                                </div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                                <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                            <cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
    <cfset type_ = 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
    <cfset type_ = 0>
</cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cf_report_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='29532.Şube Adı'></th>
                    <th><cf_get_lang dictionary_id ='39968.PDKS No'></th>
                    <th><cf_get_lang dictionary_id ='39969.İşkur Şube Adı'></th>
                    <th><cf_get_lang dictionary_id ='39970.İşkur Şube No'></th>
                    <th>5084</th>
                    <th>5615</th>
                    <th>5510</th>
                    <th>6486</th>
                    <th>6322</th>
                    <th><cf_get_lang dictionary_id ='39971.İşin Mahiyeti'></th>				
                    <th><cf_get_lang dictionary_id ='38955.İlgili Şirket'></th>
                    <th><cf_get_lang dictionary_id ='39972.SSK Ofis'></th>
                    <th>M</th>
                    <th><cf_get_lang dictionary_id ='39973.İş Kolu'></th>
                    <th><cf_get_lang dictionary_id ='39974.Ünite Kodu'></th>
                    <th><cf_get_lang dictionary_id ='39975.İşyeri No'></th>
                    <th><cf_get_lang dictionary_id ='39976.İl Kodu'></th>
                    <th><cf_get_lang dictionary_id ='39977.İlçe Kodu'></th>
                    <th><cf_get_lang dictionary_id ='39978.Kontrol No'></th>
                    <th><cf_get_lang dictionary_id ='39979.Aracı Kodu'></th>
                    <th><cf_get_lang dictionary_id ='39705.SSK No'></th>
                    <th><cf_get_lang dictionary_id ='39980.İşe Başlama T'>.</th>
                    <th><cf_get_lang dictionary_id ='39981.Çalışma Bölge'></th>
                    <th><cf_get_lang dictionary_id ='39982.Çalışma Bölge No'></th>
                    <cfif session.ep.ehesap eq 1>
                        <th><cf_get_lang dictionary_id ='39983.Açılış Tarihi'></th>
                        <th><cf_get_lang dictionary_id ='57551.Kullanıcı Adı'></th>
                        <th><cf_get_lang dictionary_id ='39984.Sistem Şifresi'></th>
                        <th><cf_get_lang dictionary_id ='39985.İşyeri Şifresi'></th>
                        <th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id ='58497.Pozisyonu'></th>
                    </cfif>
                </tr>
            </thead>
            <cfif get_branches.recordcount>
                <cfset employee_id_list=''>
                <cfoutput query="get_branches" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(ssk_employee_id) and not listfind(employee_id_list,ssk_employee_id)>
                        <cfset employee_id_list=listappend(employee_id_list,ssk_employee_id)>
                    </cfif>
                </cfoutput> 
                <cfif listlen(employee_id_list)>
                    <cfquery name="get_employee_info" datasource="#DSN#">
                        SELECT
                            EMPLOYEE_ID,
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            POSITION_NAME
                        FROM
                            EMPLOYEE_POSITIONS
                        WHERE
                            EMPLOYEE_ID IN (#employee_id_list#)
                        ORDER BY
                            EMPLOYEE_ID
                    </cfquery>
                    <cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee_info.employee_id,',')),'numeric','ASC',',')>
                </cfif>
                <tbody>
                    <cfoutput query="get_branches" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#branch_name#</td>
                            <td>#BRANCH_PDKS_CODE#</td>
                            <td>#iskur_branch_name#</td>
                            <td>#iskur_branch_no#</td>
                            <td><cfif kanun_5084_oran eq 100>%100<cf_get_lang dictionary_id ='40068.Tabi'><cfelseif kanun_5084_oran eq 80>%80<cf_get_lang dictionary_id ='40068.Tabi'><cfelse><cf_get_lang dictionary_id ='40573.Tabi Değil'></cfif></td>
                            <td><cfif is_5615 eq 1><cf_get_lang dictionary_id ='40068.Tabi'><cfelse><cf_get_lang dictionary_id ='40573.Tabi Değil'></cfif></td>
                            <td><cfif is_5510 eq 1><cf_get_lang dictionary_id ='40068.Tabi'><cfelse><cf_get_lang dictionary_id ='40573.Tabi Değil'></cfif></td>
                            <td><cfif len(kanun_6486)>#kanun_6486# <cf_get_lang dictionary_id='58455.Yıl'></cfif></td>
                            <td>
                                <cfif kanun_6322 eq 1> 1-5. <cf_get_lang dictionary_id='60658.Bölgeler veya Gemi İnşa Yatırımı'>
                                <cfelseif kanun_6322 eq 2>6.<cf_get_lang dictionary_id='57992.Bölge'>
                                </cfif>
                            </td>
                            <td>#real_work#</td>
                            <td>#related_company#</td>
                            <td>#ssk_office#</td>
                            <td>#ssk_m#</td>
                            <td>#ssk_job#</td>
                            <td>#ssk_branch##ssk_branch_old#</td>
                            <td>#ssk_no#</td>
                            <td>#ssk_city#</td>
                            <td>#ssk_country#</td>
                            <td>#ssk_cd#</td>
                            <td>#ssk_agent#</td>
                            <td>#ssk_m##ssk_job##ssk_branch##ssk_branch_old##ssk_no##ssk_city##ssk_country##ssk_cd##ssk_agent#</td>
                            <td><cfif len(foundation_date)>#dateformat(foundation_date,dateformat_style)#</cfif></td>
                            <td>#cal_bol_mud_name#</td>
                            <td>#work_zone_m##work_zone_job##work_zone_file##work_zone_city#</td>
                            <cfif session.ep.ehesap eq 1>
                                <td>#dateformat(open_date,dateformat_style)#</td>
                                <td>#tckimlik_no# #user_name#</td>
                                <td>#system_password#</td>
                                <td>#company_password#</td>
                                <td>#employee_system_name#</td>
                                <td>#position_name#</td>
                            </cfif>
                        </tr>
                    </cfoutput>
                </tbody>
            <cfelse>
                <tbody>
                    <tr>
                        <td height="20" colspan="28"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </tbody>
            </cfif>
        </cf_report_list>
        <cfif attributes.is_excel neq 1>
            <cfif attributes.totalrecords gt attributes.maxrows>
                <cfset url_str = "#attributes.fuseaction#">
                <cfset url_str = "#url_str#&form_submitted=1">
                <cfif len(attributes.keyword)>
                    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
                </cfif>
                <cfif len(attributes.status)>
                    <cfset url_str = "#url_str#&status=#attributes.status#">
                </cfif>
                    <cf_paging page="#attributes.page#" 
                        maxrows="#attributes.maxrows#" 
                        totalrecords="#attributes.totalrecords#" 
                        startrow="#attributes.startrow#" 
                        adres="#url_str#">
            </cfif>
        </cfif>
    </cfif>
<script type="text/javascript">
    function control(){
        if(document.theform.is_excel.checked==false)
        {
            document.theform.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
            return true;
        }
        else
            document.theform.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_branch_ssk_info_report</cfoutput>"
    }
</script>