
<cfsetting showdebugoutput="no">
<cfif attributes.report_type eq 3 or attributes.report_type eq 4>
	<cfset table_name = 'PRODUCT'>
<cfelseif attributes.report_type eq 5>
	<cfset table_name = 'DEMAND'>
<cfelseif attributes.report_type eq 1>
	<cfset table_name = 'MEMBER'>
</cfif>


<cfparam name="attributes.sayfa" default="1">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.maxrows" default="10">

<cfif attributes.sayfa neq 1>
	<cfset attributes.startrow = attributes.maxrows * (attributes.sayfa-1) + 1>
</cfif>


<cfif attributes.report_type eq 9>
<cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
	<cfquery name="getConference" datasource="#dsn#">
    	SELECT
        	LOG_DATE,
            LOG_DURATION
        FROM
        	VIDEO_CONFERENCE_LOG
        WHERE
        	USER_ID = #attributes.user_id#
			<cfif len(attributes.start_date)>
                AND LOG_DATE >= #attributes.start_date#
            </cfif>
            <cfif len(attributes.start_date)>
                AND LOG_DATE <= #attributes.finish_date#
            </cfif>
    </cfquery>
<cfset toplam_sayfa_sayisi = wrk_round(getConference.recordcount / attributes.maxrows,0)>
</cfif>

<cfif attributes.report_type neq 9>
<cfquery name="get_product_click_row" datasource="#dsn#_report">
    SELECT  
         CASE USER_TYPE WHEN   1 THEN (SELECT COMPANY_PARTNER_NAME +' '+COMPANY_PARTNER_SURNAME AS NAME FROM #dsn_alias#.COMPANY_PARTNER WHERE PARTNER_ID =wvp.USER_ID) 
                        WHEN   0 THEN (SELECT EMPLOYEE_NAME + '' + EMPLOYEE_SURNAME AS NAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEE_ID = wvp.USER_ID) 
                        WHEN   2 THEN (SELECT CONSUMER_NAME + '' + CONSUMER_SURNAME AS NAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = wvp.USER_ID)   
         ELSE 'Ziyaretçi' END AS USERNAME,
         CASE USER_TYPE WHEN 1 THEN 'Partner'
         				WHEN 2 THEN 'Consumer'
                        WHEN 0 THEN 'Çalışan'
                        ELSE 'Ziyaretçi' END AS TIP,
         VISIT_DATE
    FROM 
         WRK_VISIT_2012_<cfoutput>#month#_GENERAL</cfoutput> wvp
    WHERE 
    	PROCESS_ID = #attributes.object_name# AND PROCESS_TYPE = '#table_name#'
    ORDER BY 
    	VISIT_DATE DESC
</cfquery>
<cfset toplam_sayfa_sayisi = wrk_round(get_product_click_row.recordcount / attributes.maxrows,1)>
</cfif>
<cfif attributes.report_type neq 9>
<div id="asayfa<cfoutput>#attributes.object_name##attributes.month#</cfoutput>">
    <cf_form_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='41644.İşlemi Yapan'></th>
                <th><cf_get_lang dictionary_id='43926.Üye Tipi'></th>
                <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
            </tr>
        </thead>
        
        <cfoutput query="get_product_click_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        	<tbody> 
                <td>#currentrow#</td>
                <td>#USERNAME#</td>
                <td>#TIP#</td>
                <td>#DATEFORMAT(VISIT_DATE,dateformat_style)#</td>
        	</tbody>
		</cfoutput>
        <tr>
        	<input type="hidden" name="startrow" id="<cfoutput>startrow#attributes.object_name##attributes.month#</cfoutput>" value="<cfoutput>#attributes.startrow#</cfoutput>">
            <input type="hidden" name="maxrows" id="<cfoutput>maxrows#attributes.object_name##attributes.month#</cfoutput>" value="<cfoutput>#attributes.maxrows#</cfoutput>">
            <input type="hidden" name="sayfa<cfoutput>#attributes.object_name##attributes.month#</cfoutput>" id="sayfa<cfoutput>#attributes.object_name##attributes.month#</cfoutput>" value="<cfoutput>#attributes.sayfa#</cfoutput>" />
            <cfif get_product_click_row.recordcount gt 0>
            	<td nowrap="nowrap" colspan="4" style="text-align:center">
                    <input type="button" name="geri" value="Geri" id="geri" style="float:left; display:<cfif attributes.sayfa gt 1>block;<cfelse>none;</cfif>" onclick="connectAjax4('<cfoutput>#attributes.object_name##attributes.month#</cfoutput>','<cfoutput>#attributes.object_name#</cfoutput>',this.value);" />
                    <input type="button" name="ileri" value="ileri" id="ileri" style="float:right; display:<cfif attributes.sayfa gt toplam_sayfa_sayisi or toplam_sayfa_sayisi eq attributes.sayfa>none;<cfelse>block;</cfif>" onclick="connectAjax4('<cfoutput>#attributes.object_name##attributes.month#</cfoutput>','<cfoutput>#attributes.object_name#</cfoutput>',this.value);" />
				</td>
            </cfif>
        </tr>
    </cf_form_list>
</div>

<script language="javascript">
	function connectAjax4(crtrow,pid,kontrol_value)
	{
		var page = document.getElementById('sayfa'+crtrow).value ;
		var maxrows = document.getElementById('maxrows'+crtrow).value;
		var startrow = document.getElementById('startrow'+crtrow).value;
		if(kontrol_value == 'ileri')
		{
			page ++;
		}
		else
		{
			page --;
			startrow = startrow - 10;
		}
		var bb = '<cfoutput>#request.self#?fuseaction=report.emptypopup_list_product_row</cfoutput>&month='+<cfoutput>#attributes.month#</cfoutput>+'&object_name='+ pid+'&sayfa='+page+'&startrow='+startrow+'&maxrows='+maxrows+'&report_type='+<cfoutput>#attributes.report_type#</cfoutput>;
		AjaxPageLoad(bb,'asayfa'+crtrow,1);
	}
</script>
<cfelse>
<div id="asayfa<cfoutput>#attributes.user_id#</cfoutput>">
    <cf_form_list>
    <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='56677.Görüşme Tarihi'></th>
                <th><cf_get_lang dictionary_id='60783.Görüşme Süresi'></th>
            </tr>
        </thead>
	 <cfoutput query="getConference" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <tbody> 
            <td>#currentrow#</td>
            <td>#dateformat(log_date,dateformat_style)#-#TimeFormat(log_date,timeformat_style)#</td>
            <td>#TimeFormat(DateAdd("s", log_duration, CreateTime(0,0,0)), 'HH:mm:ss')#</td>
        </tbody>
    </cfoutput>
            	<input type="hidden" name="startrow" id="startrow<cfoutput>#attributes.user_id#</cfoutput>" value="<cfoutput>#attributes.startrow#</cfoutput>">
                <input type="hidden" name="maxrows" id="maxrows<cfoutput>#attributes.user_id#</cfoutput>" value="<cfoutput>#attributes.maxrows#</cfoutput>">
                <input type="hidden" name="sayfa" id="sayfa<cfoutput>#attributes.user_id#</cfoutput>" value="<cfoutput>#attributes.sayfa#</cfoutput>" />
               <cfif getConference.recordcount gt 10>
            	<td nowrap="nowrap" colspan="4" style="text-align:center">
                    <input type="button" name="geri" value="Geri" id="geri" style="float:left; display:<cfif attributes.sayfa gt 1>block;<cfelse>none;</cfif>" onclick="connectAjax4('<cfoutput>#attributes.user_id#</cfoutput>','',this.value);" />
                    <input type="button" name="ileri" value="ileri" id="ileri" style="float:right; display:<cfif  attributes.sayfa gt toplam_sayfa_sayisi or toplam_sayfa_sayisi eq attributes.sayfa >none;<cfelse>block;</cfif>" onclick="connectAjax4('<cfoutput>#attributes.user_id#</cfoutput>','',this.value);" />
				</td>
            </cfif>
    </cf_form_list>
</div>
    <script language="javascript">
	function connectAjax4(crtrow,pid,kontrol_value)
	{
		var page = document.getElementById('sayfa'+crtrow).value ;
		var maxrows = document.getElementById('maxrows' +crtrow).value;
		var startrow = document.getElementById('startrow' +crtrow).value;
		if(kontrol_value == 'ileri')
		{
			page ++;
		}
		else
		{
			page --;
			startrow = startrow - 10;
		}
		var bb = '<cfoutput>#request.self#?fuseaction=report.emptypopup_list_product_row</cfoutput>&' + 'user_id=' + '<cfoutput>#attributes.user_id#</cfoutput>' + '&report_type='+'<cfoutput>#attributes.report_type#</cfoutput>' + '&sayfa='+page + '&start_date=' + '<cfoutput>#attributes.start_date#</cfoutput>' + '&finish_date=' + '<cfoutput>#attributes.finish_date#</cfoutput>' ;
		AjaxPageLoad(bb,'asayfa'+crtrow,1);
	}
</script>
</cfif>
