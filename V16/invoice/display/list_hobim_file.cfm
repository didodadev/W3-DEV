<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfquery name="getHobimStage" datasource="#DSN#">
	SELECT
		PTR.STAGE STAGE_NAME,
		PTR.PROCESS_ROW_ID STAGE_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%invoice.list_hobim_file%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_hobim_file" datasource="#DSN2#">
		SELECT
			FE.FILE_NAME,
			FE.TARGET_SYSTEM,
			FE.RECORD_DATE,
			FE.RECORD_EMP,
			FE.E_ID,
            FE.FILE_STAGE,
            PTR.STAGE,
            PTR.PROCESS_ROW_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
		FROM
			FILE_EXPORTS FE
            LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = FE.FILE_STAGE
            RIGHT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = FE.RECORD_EMP
		WHERE
			FE.PROCESS_TYPE = -22
            AND FE.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
            <cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)>
                AND FE.RECORD_EMP = #attributes.employee_id#
            </cfif>
            <cfif isdefined('attributes.stage_id') and len(attributes.stage_id)>
                AND FE.FILE_STAGE = #attributes.stage_id#
            </cfif>
		ORDER BY
			FE.E_ID DESC
	</cfquery>
    
    <cfset hobim_id_list = valuelist(get_hobim_file.e_id)>
	<cfif listlen(hobim_id_list)>
		<cfquery name="get_invoice" datasource="#dsn2#">
        SELECT
            SUM(TOPLAM) TOPLAM,
            SUM(SAYI) SAYI,<!--- FATURA SAYISI --->
            SUM(TOPLAM_2) TOPLAM_2,
            SUM(SAYI_2) SAYI_2,<!--- BASILMAYAN FATURA SAYISI --->
            HOBIM_ID
        FROM
            (
                SELECT 
                    SUM(NETTOTAL) TOPLAM,
                    COUNT(INVOICE.INVOICE_MULTI_ID) SAYI,
                    0 TOPLAM_2,
                    0 SAYI_2,
                    HOBIM_ID
                FROM
                    INVOICE,
                    INVOICE_MULTI,
                    #dsn_alias#.COMPANY COMPANY
                WHERE
                    INVOICE.INVOICE_MULTI_ID = INVOICE_MULTI.INVOICE_MULTI_ID AND
                    INVOICE_MULTI.HOBIM_ID IN (#hobim_id_list#) AND
                    COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND
                    ISNULL(COMPANY.RESOURCE_ID,0) = 1 <!--- FATURA basılacaklar --->
                GROUP BY
                    HOBIM_ID
            UNION ALL
                SELECT 
                    SUM(NETTOTAL) TOPLAM,
                    COUNT(INVOICE.INVOICE_MULTI_ID) SAYI,
                    0 TOPLAM_2,
                    0 SAYI_2,
                    HOBIM_ID
                FROM
                    INVOICE,
                    INVOICE_MULTI,
                    #dsn_alias#.CONSUMER CONSUMER
                WHERE
                    INVOICE.INVOICE_MULTI_ID = INVOICE_MULTI.INVOICE_MULTI_ID AND
                    INVOICE_MULTI.HOBIM_ID IN (#hobim_id_list#) AND
                    CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND
                    ISNULL(CONSUMER.RESOURCE_ID,0) = 1 <!--- FATURA basılacaklar --->
                GROUP BY
                    HOBIM_ID
            UNION ALL
                SELECT 
                    0 TOPLAM,
                    0 SAYI,
                    SUM(NETTOTAL) TOPLAM_2,
                    COUNT(INVOICE.INVOICE_MULTI_ID) SAYI_2,
                    HOBIM_ID
                FROM
                    INVOICE,
                    INVOICE_MULTI,
                    #dsn_alias#.COMPANY COMPANY
                WHERE
                    INVOICE.INVOICE_MULTI_ID = INVOICE_MULTI.INVOICE_MULTI_ID AND
                    INVOICE_MULTI.HOBIM_ID IN (#hobim_id_list#) AND
                    COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND
                    ISNULL(COMPANY.RESOURCE_ID,0) <> 1 <!--- FATURA basılmayacaklar --->
                GROUP BY
                    HOBIM_ID
            UNION ALL
                SELECT 
                    0 TOPLAM,
                    0 SAYI,
                    SUM(NETTOTAL) TOPLAM_2,
                    COUNT(INVOICE.INVOICE_MULTI_ID) SAYI_2,
                    HOBIM_ID
                FROM
                    INVOICE,
                    INVOICE_MULTI,
                    #dsn_alias#.CONSUMER CONSUMER
                WHERE
                    INVOICE.INVOICE_MULTI_ID = INVOICE_MULTI.INVOICE_MULTI_ID AND
                    INVOICE_MULTI.HOBIM_ID IN (#hobim_id_list#) AND
                    CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND
                    ISNULL(CONSUMER.RESOURCE_ID,0) <> 1 <!--- FATURA basılmayacaklar --->
                GROUP BY
                    HOBIM_ID
            ) T1
        GROUP BY
            HOBIM_ID
        </cfquery>
		<cfset invoice_hobim_id_list = valuelist(get_invoice.hobim_id)>
	</cfif>
<cfelse>
  	<cfset get_hobim_file.recordcount = 0>
</cfif>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.stage_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_hobim_file.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=invoice.list_hobim_file">
<input name="is_submitted" id="is_submitted" value="1" type="hidden">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="47123.Hobim Dosyaları"></cfsavecontent>
	<cf_big_list_search title="#message#"> 
		<cf_big_list_search_area>
			<table>
				<tr>
                    <td><cf_get_lang dictionary_id='57899.Kaydeden'></td>
                    <td><input type="hidden" maxlength="50" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                        <input type="text" maxlength="50" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_form.employee_name&field_emp_id=search_form.employee_id&select_list=1','list');return false"><img src="/images/plus_thin.gif" align="top"></a>
                    </td>
                    <td>
                        <select name="stage_id" id="stage_id" style="width:100px;">
                            <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                            <cfoutput query="getHobimStage">
                                <option value="#stage_id#" <cfif attributes.stage_id eq stage_id>selected</cfif>>#stage_name#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes">
						<cf_wrk_date_image date_field="start_date">
					</td>
					<td>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes">
						<cf_wrk_date_image date_field="finish_date">
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" onKeyUp="isNumber(this)" maxlength="3" validate="integer" range="1,250" required="yes" message="#message#">
					</td>
					<td><cf_wrk_search_button></td><!--- search_function="kontrol()"--->
				</tr>
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
        	<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
            <th width="60"><cf_get_lang dictionary_id="57092.Hobim ID"></th>
			<th><cf_get_lang dictionary_id='57468.Belge'></th>
            <th width="40"><cf_get_lang dictionary_id='58082.Adet'></th>
			<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
			<th width="40"><cf_get_lang dictionary_id='58082.Adet'></th>
			<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th width="110"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			<th width="110"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
            <th width="110"><cf_get_lang dictionary_id='57482.Aşama'></th>
            <th class="header_icn_none"></th>
            <th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.popup_upd_hobim_invoice_number_import','small');"><img src="/images/add_not.gif" alt="" title="Hobim Fatura Numaraları Update"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_hobim_file.recordcount>
			<cfoutput query="get_hobim_file" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#e_id#</td>
                    <td>#file_name#</td>
                    <td style="text-align:right;">#get_invoice.sayi[listfind(invoice_hobim_id_list,e_id)]#</td>
                    <td style="text-align:right;">#TLFormat(get_invoice.toplam[listfind(invoice_hobim_id_list,e_id)])#</td>
                    <td style="text-align:right;">#get_invoice.sayi_2[listfind(invoice_hobim_id_list,e_id)]#</td>
                    <td style="text-align:right;">#TLFormat(get_invoice.toplam_2[listfind(invoice_hobim_id_list,e_id)])#</td>
                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi"> 
                    		#employee_name# #employee_surname#
                        </a>
                    </td>
                    <td>#dateformat(date_add("h",session.ep.time_zone,record_date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
                    <td>#stage#</td>
                    <!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.popup_form_export_hobim&hobim_id=#e_id#','small');"><img src="/images//update_list.gif" alt=""></a></td><!-- sil -->
                    <!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.popup_open_multi_prov_file&is_hobim_key=0&file_name=#file_name#','small');"><img src="/images/download.gif" alt=""></a></td><!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="12">
					<cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz!'>!</cfif> 
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_string = ''>
<cfif isdefined("attributes.is_submitted")>
	<cfset url_string = '#url_string#&is_submitted=#attributes.is_submitted#'>
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,"dd/mm/yyyy")#'>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,"dd/mm/yyyy")#'>
</cfif>
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfset url_string = "#url_string#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
	<cfset url_string = "#url_string#&employee_name=#attributes.employee_name#">
</cfif>
<cfif isdefined("attributes.stage_id") and len(attributes.stage_id)>
	<cfset url_string = "#url_string#&stage_id=#attributes.stage_id#">
</cfif>
<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="invoice.list_hobim_file#url_string#">
<script type="text/javascript">
	document.getElementById('employee_name').focus();
</script>
