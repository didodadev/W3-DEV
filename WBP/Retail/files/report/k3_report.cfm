<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.kasa_numarasi" default="">
<cfparam name="attributes.iptal_type" default="0">
<cfset baslangic_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfset base_date_start_ = baslangic_>
<cfset base_date_ = baslangic_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_start_)#-#month(base_date_start_)#-#day(base_date_start_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_action" datasource="#dsn_dev#">
	SELECT
        *
    FROM 
    	GET_ALL_CASH_PAYMENTS GA
    WHERE
		<cfif not session.ep.ehesap>
            GA.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	GA.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
    	GA.ACTION_DATE >= #attributes.startdate# AND GA.ACTION_DATE < #dateadd('d',1,attributes.finishdate)#
    ORDER BY
    	GA.ACTION_DATE
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_action.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_report_list_search title="#getLang('','Kasadan Yapılan Ödemeler',62848)#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.k3_report" method="post" name="search_">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
									<div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="#getLang('','Şube',57453)#" 
                                        width="150"
                                        option_name="department_head" 
                                        option_value="BRANCH_ID"
                                        filter="0"
                                        value="#attributes.search_department_id#">
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#" required="yes">
                                            <span class="input-group-addon"> <cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
									</div>
								</div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                		<div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<cfscript>
	g_odeme_total = 0;
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='48543.Ödeme Tutarı'></th>
                    <th><cf_get_lang dictionary_id='62849.Ödeme Yapılan Firma'></th>
                    <th><cf_get_lang dictionary_id='58133.Fatura No'> / <cf_get_lang dictionary_id='50417.Makbuz No'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='62850.Ödeme Yapılan Kasa'></th>
                </tr>
            </thead>
            <tbody>
            <cfif get_action.recordcount>
                <cfoutput query="get_action" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>#dateformat(action_date,'dd.mm.yyyy')#</td>
                    <td style="text-align:right;">#tlformat(ODEME)#</td>
                    <td>#SIRKET##BIREYSEL#</td>
                    <td>#PAPER_NO#</td>
                    <td>#ACTION_DETAIL#</td>
                    <td>#branch_name#</td>
                </tr>
                <cfscript>
                    g_odeme_total = g_odeme_total + ODEME;
                </cfscript>
                </cfoutput>
                <cfoutput>
                <tfooter>
                <tr>
                    <td>&nbsp;</td>
                    <td style="text-align:right;" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                    <td style="text-align:right;" class="formbold">#tlformat(g_odeme_total)#</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                </tfooter>
                </cfoutput>
            </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif isdefined("attributes.search_department_id")>
                <cfset url_string = '#url_string#&search_department_id=#attributes.search_department_id#'>
            </cfif>	
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.k3_report#url_string#">
        </cfif>
    </cf_box>
</div>