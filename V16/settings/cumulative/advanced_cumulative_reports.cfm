<cfsetting showdebugoutput="no">
<cfparam name="table_name" default="#attributes.report_table_name#">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.period_id" default="#session.ep.period_id#">
<cfparam name="attributes.period_year" default="#session.ep.period_year#">
<cfparam name="attributes.our_company_id" default="#session.ep.company_id#">
<cfquery name="get_period" datasource="#dsn#">
    SELECT 
        PERIOD,
        PERIOD_ID,
        PERIOD_YEAR,
        OUR_COMPANY_ID
    FROM 
        SETUP_PERIOD 
    ORDER BY 
        PERIOD_YEAR DESC
</cfquery>
<table cellpadding="2" cellspacing="1" class="color-border" height="100%" width="100%">
	<tr class="color-header">
    	<td colspan="8" class="form-title"><cfoutput>#attributes.REPORT_NAME#</cfoutput>
        <div style="float:right;margin-top:-15;"> <img style="cursor:pointer;" onClick="AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=settings.ajax_emptypopup_advanced_cumulative_reports_type&report_name=#attributes.report_name#&report_table_name=#attributes.report_table_name#&period_id='+list_getat(document.getElementById('action_period_year').value,2)+'&period_year='+list_getat(document.getElementById('action_period_year').value,1)+'&our_company_id='+list_getat(document.getElementById('action_period_year').value,3)+''</cfoutput>,'report_categoris',1)" alt="Refresh" src="images/reload_page.gif" border="0" onClick="gizle(prod_stock_and_spec_detail_div);"></div></td>
    </tr>
    <tr class="color-list">
    	<td  colspan="8">
        	 <select name="action_period_year" id="action_period_year" style="width:180px" onChange="AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=settings.ajax_emptypopup_advanced_cumulative_reports_type&report_name=#attributes.report_name#&report_table_name=#attributes.report_table_name#&period_id='+list_getat(this.value,2)+'&period_year='+list_getat(this.value,1)+'&our_company_id='+list_getat(this.value,3)+''</cfoutput>,'report_categoris',1)">
				<cfoutput query="GET_PERIOD">
                    <option value="#PERIOD_YEAR#,#PERIOD_ID#,#OUR_COMPANY_ID#"<cfif attributes.period_id eq PERIOD_ID>selected</cfif>>#PERIOD#</option>
                </cfoutput>
            </select>
        </td>
    </tr>
    <tr class="color-row">
    	<td width="1%"></td>
       	<td width="200" class="txtboldblue"><cf_get_lang_main no='1312.Ay'></td> 
       	<td width="100" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang no='2583.İşlem Sayısı'></td>
        <td class="txtboldblue" width="200"><cf_get_lang_main no='641.Başlangıç Tarihi'></td> 
        <td class="txtboldblue" width="200"><cf_get_lang_main no='288.Bitiş Tarihi'></td> 
        <td class="txtboldblue"><cf_get_lang_main no='487.Kaydeden'></td> 
        <td class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td> 
        <td width="1%"></td>
    </tr>
    <cfquery name="get_cum_rep" datasource="#dsn_report#">
        SELECT 
            ISNULL(PROCESS_ROW_COUNT,0) as PROCESS_ROW_COUNT,
            PROCESS_START_DATE,
            PROCESS_FINISH_DATE,
            RECORD_EMP_ID,PERIOD_MONTH,PERIOD_YEAR
        FROM 
            REPORT_SYSTEM 
		WHERE 
        	REPORT_TABLE ='#table_name#' 
            AND PERIOD_YEAR = #attributes.period_year# 
            AND OUR_COMPANY_ID = #attributes.our_company_id#
    </cfquery>
	<cfscript>
    for(ti=1;ti lte get_cum_rep.recordcount; ti = ti+1){//eğer kayıt olan aylar varsa burda yukarda yok diye tanımladıklarımızı var diye tanımlıyoruz!
        if(isdate(get_cum_rep.PROCESS_FINISH_DATE[ti])) finish_date = DateFormat(get_cum_rep.PROCESS_FINISH_DATE[ti],dateformat_style); else finish_date ='&nbsp';
        'report_system_info#get_cum_rep.PERIOD_MONTH[ti]#' = '#get_cum_rep.PROCESS_ROW_COUNT[ti]#█#DateFormat(get_cum_rep.PROCESS_START_DATE[ti],dateformat_style)#█#finish_date#█#get_cum_rep.RECORD_EMP_ID[ti]#';
        }
    </cfscript>
    <cfloop from="1" to="12" index="ay">
        <cfset table_status = 'Var'>
        <cfif not isdefined("report_system_info#ay#")><cfset table_status = 'Yok'><cfset "report_system_info#ay#" ='&nbsp;█&nbsp;█&nbsp;█&nbsp;█'> </cfif>
        <cfoutput>
        <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td>#ay#</td>
            <td>
                <cfset dil_number = 180 + ay-1>
                <cf_get_lang_main no ='#dil_number#.Aylar'>
            </td>
            <td align="right" style="text-align:right;" >#ListGetAt(Evaluate("report_system_info#ay#"),1,'█')#</td>
            <td><cfset basl_tarihi = ListGetAt(Evaluate("report_system_info#ay#"),2,'█')>#basl_tarihi#</td>
            <td><cfset bitis_tarihi = ListGetAt(Evaluate("report_system_info#ay#"),3,'█')><cfif isdate(bitis_tarihi)>#bitis_tarihi#</cfif></td>
            <td>#get_emp_info(ListGetAt(Evaluate("report_system_info#ay#"),4,'█'),0,0)#</td>
            <td>#ListGetAt(Evaluate("report_system_info#ay#"),2,'█')#</td>
            <td align="right" style="text-align:right;">
                <input type="button" value="<cfif isdate(basl_tarihi) or (isdate(basl_tarihi) and not isdate(bitis_tarihi))>Yeniden</cfif> Oluştur" onclick="cre_report('#ay#','#table_status#');">
            </td>
        </tr>
        </cfoutput>
    </cfloop>
   <tr class="color-row" id="cumule_report_step2" style="display:none;">
    	<td colspan="8"><div id="show_stok_detail_report"></div></td>
    </tr> 
</table>
<script type="text/javascript">
function cre_report(period_month,table_status){
		goster(cumule_report_step2);
		var period_year = list_getat(document.getElementById('action_period_year').value,1,',');
		var period_id = list_getat(document.getElementById('action_period_year').value,2,',');
		var period_our_company_id = list_getat(document.getElementById('action_period_year').value,3,',');
		AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=settings.emptypopup_ajax_crea_cumulative_reports&table_name=#table_name#&table_status='+table_status+'&period_month='+period_month+'&period_year='+period_year+'&period_id='+period_id+'&period_our_company_id='+period_our_company_id+''</cfoutput>,'show_stok_detail_report',1)
	}
</script>
