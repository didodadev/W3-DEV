<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_excel" default="">
<cfif isdefined("is_submitted")>
	<cf_date tarih="attributes.startdate">
    <cf_date tarih="attributes.finishdate">
	<cfquery name="get_orientations" datasource="#dsn#">
    	SELECT 
            EI.TC_IDENTY_NO,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            OC.COMPANY_NAME,
            B.BRANCH_NAME,
            D.DEPARTMENT_HEAD,
            SPC.POSITION_CAT,
            TOR.ORIENTATION_HEAD,
            T1.EMPLOYEE_NAME AS S_ADI,
            T1.EMPLOYEE_SURNAME AS S_SOYADI,
            TOR.START_DATE,
            TOR.FINISH_DATE,
            TOR.DETAIL
        FROM 
            TRAINING_ORIENTATION TOR 
            INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TOR.ATTENDER_EMP
            LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = TOR.ATTENDER_EMP
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
            LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
            LEFT JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
            LEFT JOIN SETUP_POSITION_CAT SPC ON EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
            LEFT JOIN (SELECT E2.EMPLOYEE_NAME, E2.EMPLOYEE_SURNAME, E2.EMPLOYEE_ID FROM EMPLOYEES E2 WHERE E2.EMPLOYEE_ID IN (SELECT DISTINCT TRAINER_EMP FROM TRAINING_ORIENTATION)) AS T1 ON 
            T1.EMPLOYEE_ID = TOR.TRAINER_EMP
        WHERE 
            EP.IS_MASTER = 1
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            	AND B.BRANCH_ID = #attributes.branch_id#
			</cfif>
            <cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
            	AND EP.POSITION_CAT_ID = #attributes.pos_cat_id#
			</cfif>
            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
				AND TOR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                AND TOR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
			</cfif>
			<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
				AND TOR.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                AND TOR.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
			</cfif>
        ORDER BY
            TOR.START_DATE DESC,TOR.FINISH_DATE DESC
    </cfquery>
<cfelse>
	<cfset get_orientations.recordcount = 0>
</cfif>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_pos_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_orientations.recordcount#'>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
</cfif>
<cfif isdate(attributes.finishdate)>
    <cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
</cfif>
<cfform name="search_form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
    <cf_report_list_search id="search" title="#getLang('asset',155)#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="branch_id" id="branch_id">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_branchs">
                                                    <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>	
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                            <select name="pos_cat_id" id="pos_cat_id" style="width:150px;">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_pos_cats">
                                                    <option value="#position_cat_id#" <cfif isdefined("attributes.pos_cat_id") and attributes.pos_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
                                                </cfoutput>
                                            </select> 
                                    </div>
                                </div>
                            </div>	
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12" nowrap><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
									<div class="col col-6" nowrap>
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
											<input value="<cfoutput>#attributes.startdate#</cfoutput>" type="text" name="startdate" id="startdate" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
										</div>
									</div>
									<div class="col col-6" nowrap>
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
											<input value="<cfoutput>#attributes.finishdate#</cfoutput>" type="text" name="finishdate" id="finishdate" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
										</div>
									</div>
								</div>
                                   
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
                                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                                <cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel="1">   
                        </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename="training_orientation_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_orientations.recordcount>
	<cfset type_ = 1>
	<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submitted")>
    <cf_report_list>
            <thead>
                <tr height="22">
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
                    <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                    <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_orientations.recordcount>
                    <cfoutput query="get_orientations" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#tc_identy_no#</td>
                            <td>#employee_name# #employee_surname#</td>
                            <td>#company_name#</td>
                            <td>#branch_name#</td>
                            <td>#department_head#</td>
                            <td>#position_cat#</td>
                            <td>#orientation_head#</td>
                            <td>#s_adi# #s_soyadi#</td>
                            <td>#dateformat(start_date,dateformat_style)#</td>
                            <td>#dateformat(finish_date,dateformat_style)#</td>
                            <td>#detail#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
						<td colspan="12"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
					</tr>
                </cfif>
            </tbody>
        
    </cf_report_list>
</cfif>
<cfset adres = "">
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "#attributes.fuseaction#&is_submitted=1">
    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
		<cfset adres = "#adres#&pos_cat_id=#attributes.pos_cat_id#">
    </cfif>
    <cfif len(attributes.startdate) and isdate(attributes.startdate)>
		<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
    </cfif>
    <cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
		<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
    </cfif>
    <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr>
            <td><cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
            </td>
        	<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
    </table>
</cfif>
<script>
    function control()
    {
        if(document.search_form.is_excel.checked==false)
        {
            document.search_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.training_orientation_report"
            return true;
        }
        else{
            
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_training_orientation_report</cfoutput>"
        }
        
    }
</script>