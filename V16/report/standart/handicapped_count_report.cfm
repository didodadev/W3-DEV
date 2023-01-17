<cfsetting showdebugoutput="yes">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.year" default="#year(now())#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfscript>
	bu_ay_basi = CreateDate(attributes.year,12,1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfset start_date="1/1/#attributes.year#">
<cfset finish_date="#bu_ay_sonu#/12/#attributes.year#">
<cfif isdefined("start_date") and isdate(start_date)>
	<cf_date tarih = "start_date">
</cfif>
<cfif isdefined("finish_date") and isdate(finish_date)>
	<cf_date tarih = "finish_date">
</cfif>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
        COMP_ID, 
        NICK_NAME 
    FROM 
        OUR_COMPANY 
    <cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
    ORDER BY 
        NICK_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
    SELECT 
        BRANCH_ID,
        BRANCH_NAME 
    FROM 
        BRANCH 
    WHERE 
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#)
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
    ORDER BY 
        BRANCH_NAME
</cfquery>
<cfif isdefined('attributes.is_submitted')>
    <cfquery name="get_handicapped_count" datasource="#dsn#">
        SELECT
            EPR.IN_OUT_ID,
            EP.SAL_MON,
            OC.COMPANY_NAME,
            OC.COMP_ID,
            B.SSK_CITY,
            EI.DEFECTION_LEVEL,
            B.BRANCH_NAME,
            EP.SSK_BRANCH_ID
        FROM
            EMPLOYEES_PUANTAJ EP INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID 
            INNER JOIN EMPLOYEES_IN_OUT EI ON EI.IN_OUT_ID = EPR.IN_OUT_ID 
            LEFT JOIN BRANCH B ON B.BRANCH_ID = EP.SSK_BRANCH_ID
            LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
        WHERE
            EP.SAL_YEAR=#attributes.year#
            <cfif len(attributes.comp_id)>
                AND B.COMPANY_ID IN (#attributes.comp_id#)
            </cfif>
            <cfif len(attributes.branch_id)>
                AND EP.SSK_BRANCH_ID IN (#attributes.branch_id#)
            </cfif>
            <cfif not session.ep.ehesap>
                AND EP.SSK_BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_handicapped_count.recordcount = 0>
</cfif>

<cfset month_list ="Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
	
<cfsavecontent variable="head"><cf_get_lang dictionary_id='47814.Özürlü Çalışan Sayıları Raporu'></cfsavecontent>
<cfform name="thisForm" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <cf_report_list_search title="#head#">
		<cf_report_list_search_area>
            <div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                    <div class="col col-12">
                                        <div style="position:relative; z-index:1;">
                                            <cf_multiselect_check 
                                            query_name="get_company"  
                                            name="comp_id"
                                            width="140" 
                                            option_value="COMP_ID"
                                            option_name="NICK_NAME"
                                            option_text="#getLang('main',162)#"
                                            value="#attributes.comp_id#"
                                            onchange="get_branch_list(this.value)">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                    <div class="col col-12">
                                        <div id="BRANCH_PLACE" style="position:relative; z-index:1;">
                                            <cf_multiselect_check 
                                            query_name="get_branchs"  
                                            name="branch_id"
                                            width="140" 
                                            option_value="BRANCH_ID"
                                            option_name="BRANCH_NAME"
                                            option_text="#getLang('main',41)#"
                                            value="#attributes.branch_id#">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                    <div class="col col-12">
                                        <select name="year" id="year" style="width:50px;">
                                            <cfloop from="#year(now())+2#" to="#year(now())-3#" index="yr" step="-1">
                                                <option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.year') and (yr eq attributes.year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
                                            </cfloop>
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
							<input name="is_submitted" id="is_submitted" value="1" type="hidden">
							<cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div>
        </cf_report_list_search_area>
	</cf_report_list_search>
</cfform>

<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfif isdefined("is_submitted")>
    <cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_handicapped_count.recordcount>
	</cfif>
    <cf_report_list>
        <thead>
            <th colspan="3" class="form-title"></th>
            <cfloop list="#month_list#" index="i" delimiters=",">
                <th colspan="3" class="form-title" style="text-align:center;"><cfoutput>#i#</cfoutput></th>
                
            </cfloop>
            <tr>
            <th class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></th>
                <th class="form-title"><cf_get_lang dictionary_id='57453.Şube'></th>
                <th class="form-title"><cf_get_lang dictionary_id='58608.İl'></th>
            <cfloop list="#month_list#" index="i" delimiters=",">
                <th class="form-title"><cf_get_lang dictionary_id='29801.Zorunlu'></th>
                <th class="form-title"><cf_get_lang dictionary_id='58571.Mevcut'></th>
                <th class="form-title"><cf_get_lang dictionary_id='58583.Fark'></th>
            </cfloop>
            </tr>
        </thead>
        <tbody>	
            <cfif get_handicapped_count.recordcount>
                <cfquery name="get_comp_branch" dbtype="query" >
                    SELECT DISTINCT
                        COMPANY_NAME,
                        BRANCH_NAME,
                        COMP_ID,
                        SSK_BRANCH_ID,
                        SSK_CITY
                    FROM  
                        get_handicapped_count
                    ORDER BY
                        COMPANY_NAME,BRANCH_NAME,SSK_CITY
                </cfquery>
                <cfoutput query="get_comp_branch" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td >#COMPANY_NAME#</td>
                        <td >#BRANCH_NAME#</td>
                        <td >#SSK_CITY#</td>
                        <cfloop from="1" to="12" index="i">
                            <cfquery name="get_month_count" dbtype="query">
                                SELECT 
                                    COUNT(IN_OUT_ID) AS SY
                                FROM  
                                    get_handicapped_count
                                WHERE
                                    SAL_MON = #i#
                                    AND COMP_ID = #COMP_ID#
                                    AND SSK_CITY = '#SSK_CITY#'
                            </cfquery>
                            <cfquery name="get_existing" dbtype="query">
                                SELECT 
                                    COUNT(IN_OUT_ID) AS SY
                                FROM  
                                    get_handicapped_count
                                WHERE
                                    SAL_MON = #i#
                                    AND COMP_ID = #COMP_ID#
                                    AND SSK_CITY = '#SSK_CITY#'
                                    AND DEFECTION_LEVEL <> 0
                            </cfquery>
                            <td >
                                <cfif get_month_count.recordcount>
                                    <cfif get_month_count.sy gte 50>
                                        <cfquery name="get_sakat_percent" datasource="#dsn#">
                                            SELECT 
                                                SAKAT_PERCENT 
                                            FROM 
                                                SETUP_PROGRAM_PARAMETERS 
                                            WHERE 
                                                STARTDATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#start_date#"> 
                                                AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#finish_date#">
                                                AND (BRANCH_IDS = '#SSK_BRANCH_ID#' OR BRANCH_IDS LIKE '#SSK_BRANCH_ID#,%' OR BRANCH_IDS LIKE '%,#SSK_BRANCH_ID#' OR BRANCH_IDS LIKE '%,#SSK_BRANCH_ID#,%')
                                        </cfquery>
                                        <cfif get_sakat_percent.recordcount>
                                            <cfset zorunlu = round(get_month_count.sy * get_sakat_percent.sakat_percent / 100)>
                                        <cfelse>
                                            <cfset zorunlu = ''>
                                        </cfif>
                                        #zorunlu#
                                    <cfelseif get_month_count.sy lt 50>
                                        <cfset zorunlu = 0>#zorunlu#
                                    </cfif>
                                </cfif>
                            </td>
                            <td ><cfif get_existing.recordcount>#get_existing.sy#</cfif></td>
                            <td ><cfif isdefined('zorunlu') and len(zorunlu) and len(get_existing.sy)><cfset fark = zorunlu - get_existing.sy>#fark#</cfif></td>
                        </cfloop><cfset attributes.totalrecords=get_comp_branch.recordcount>	
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="39"><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
                <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
            </cfif>
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
            </cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
            </cfif>
            <cfif isdefined("attributes.year") and len(attributes.year)>
                <cfset url_str = "#url_str#&year=#attributes.year#">
            </cfif>
            <cfif attributes.is_excel eq 0>
				<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&#url_str#"> 
            </cfif>
    </cfif>
</cfif>

<script type="text/javascript">
    function control()
    {  
        if(document.thisForm.is_excel.checked==false)
            {
                document.thisForm.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
                return true;
            }
        else{
                document.thisForm.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_handicapped_count_report</cfoutput>";
                
        }

    }
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	function get_department_list(gelen){
	}
</script>
