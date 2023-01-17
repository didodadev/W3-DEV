<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfquery name="get_odenek" datasource="#dsn#">
    SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE IS_ODENEK = 1 
</cfquery>
<!-- sil -->
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39986.Ek Ödenek'></cfsavecontent>
<cf_big_list_search title="#title#">
    <cf_big_list_search_area>
        <table>
            <tr>
                <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
            </tr>
        </table>
    </cf_big_list_search_area>
</cf_big_list_search>
<cf_big_list>
    <thead>
        <tr>
            <th width="50"><cf_get_lang dictionary_id ='57630.Tip'></th>
            <th><cf_get_lang dictionary_id='58233.Tanım'></th>
            <th width="100"><cf_get_lang dictionary_id ='58083.Net'>\<cf_get_lang dictionary_id ='38990.Brüt'></th>
            <th width="100"><cf_get_lang dictionary_id ='39989.Başlangıç Ay'></th>
            <th width="100"><cf_get_lang dictionary_id ='39990.Bitiş Ay'></th>
            <th width="100"><cf_get_lang dictionary_id ='29472.Yöntem'></th>
            <th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput QUERY="get_odenek">
			<tr>
				<td>#odkes_id#</td>
				<td>#comment_pay#</td>
				<td><cfif get_odenek.from_salary eq 1><cf_get_lang dictionary_id ='38990.Brüt'><cfelseif get_odenek.from_salary eq 0><cf_get_lang dictionary_id ='58083.Net'></cfif></td>
				<td>#LISTgetat(ay_list(),start_SAL_MON,',')#</td>
				<td>#LISTgetat(ay_list(),END_SAL_MON,',')#</td>
				<td>
				  <cfif get_odenek.METHOD_PAY EQ 1><cf_get_lang dictionary_id ='39991.Artı'><cfelseif get_odenek.METHOD_PAY EQ 2><cf_get_lang dictionary_id ='39473.Yüzde'></cfif>
				</td>
				<td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(AMOUNT_PAY)#"></td>
			</tr>
        </cfoutput>
    </tbody>
</cf_big_list>
<br />
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39992.Kesinti'></cfsavecontent>
<cf_big_list_search title="#title#"></cf_big_list_search>
    <cfquery name="get_kesinti" datasource="#dsn#">
        SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE IS_ODENEK = 0 
    </cfquery>
<cf_big_list>
    <thead>
        <tr>
            <th width="50"><cf_get_lang dictionary_id ='57630.Tip'></th>
            <th><cf_get_lang dictionary_id='58233.Tanım'></th>
            <th width="100"><cf_get_lang dictionary_id ='39989.Başlangıç Ay'></th>
            <th width="100"><cf_get_lang dictionary_id ='39990.Bitiş Ay'></th>
            <th width="100"><cf_get_lang dictionary_id ='29472.Yöntem'></th>
            <th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
        </tr>
    </thead>
    <tbody>
		<cfoutput QUERY="get_kesinti">
            <tr>
                <td>#odkes_id#</td>
                <td>#comment_pay#</td>
                <td>#LISTgetat(ay_list(),start_SAL_MON,',')#</td>
                <td>#LISTgetat(ay_list(),END_SAL_MON,',')#</td>
                <td> <cfif get_kesinti.METHOD_PAY EQ 1><cf_get_lang dictionary_id ='39993.Eksi'><cfelseif get_kesinti.METHOD_PAY EQ 2><cf_get_lang dictionary_id ='39473.Yüzde'></cfif></td>
                <td align="right" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(amount_pay)#"></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_big_list>
<br />
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39994.Vergi İstisnaları'></cfsavecontent>
<cf_big_list_search title="#title#"></cf_big_list_search>
    <cfquery name="get_tax_exc" datasource="#dsn#">
        SELECT * FROM TAX_EXCEPTION
    </cfquery>
<cf_big_list>
    <thead>
        <tr>
            <th width="50"><cf_get_lang dictionary_id ='57630.Tip'></th>
            <th><cf_get_lang dictionary_id='58233.Tanım'></th>
            <th width="100"><cf_get_lang dictionary_id ='39989.Başlangıç Ay'></th>
            <th width="100"><cf_get_lang dictionary_id ='39990.Bitiş Ay'></th>
            <th style="text-align:right;" width="100"><cf_get_lang dictionary_id ='57635.Miktar'></th>
            <th width="25">%</th>
        </tr>
    </thead>
    <tbody>
        <cfoutput QUERY="GET_TAX_EXC">
            <tr>
                <td>#tax_exception_id#</td>
                <td>#tax_exception#</td>
                <td>#LISTgetat(ay_list(),start_month,',')#</td>
                <td>#LISTgetat(ay_list(),finish_month,',')#</td>
                <td align="right" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(AMOUNT)#"></td>
                <td>#YUZDE_SINIR#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_big_list>
<!-- sil -->
