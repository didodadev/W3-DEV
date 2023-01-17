<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="">
<cfif isdefined('attributes.form_submit')>
	<cfquery name="get_progress_pay" datasource="#dsn#">
		SELECT 
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EP.*,
			B.BRANCH_NAME,
			O.NICK_NAME
		FROM 
			EMPLOYEE_PROGRESS_PAYMENT EP,
			EMPLOYEES E,
			BRANCH B,
			OUR_COMPANY O
		WHERE
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			(E.EMPLOYEE_NAME LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
			E.EMPLOYEE_SURNAME LIKE '#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI) AND
			</cfif>
		EP.EMPLOYEE_ID=E.EMPLOYEE_ID AND
		EP.BRANCH_ID = B.BRANCH_ID AND
		EP.COMP_ID = O.COMP_ID
		ORDER BY
			E.EMPLOYEE_NAME
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_progress_pay.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset url_str ="#url_str#&form_submit=#attributes.form_submit#">
<cfelse>
	<cfset get_progress_pay.recordcount = 0>
	<cfparam name="attributes.totalrecords" default="#get_progress_pay.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
	<cfset url_str ="#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str ="#url_str#&keyword=#attributes.keyword#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_emp_progress_payment" name="myform" method="post">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <input type="text" name="keyword" maxlength="50" id="keyword" placeholder="<cfoutput>#getlang('main',48)#</cfoutput>" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53528.Kıdem Bilgileri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id ='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id ='57501.Başlangıç'></th>
                    <th><cf_get_lang dictionary_id ='53529.Çalışılan Gün Say.'></th>
                    <th><cf_get_lang dictionary_id ='52991.Kıdem Tazminatı'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_emp_progress_payment&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_progress_pay.recordcount>
                    <cfoutput query="get_progress_pay" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#employee_name# #employee_surname#</td>
                            <td>#NICK_NAME#</td>
                            <td>#branch_name#</td>
                            <td>#dateformat(STARTDATE,dateformat_style)#</td>
                            <td>#WORKED_DAY#</td>
                            <td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFORMAT(KIDEM_AMOUNT,2)#"></td>
                            <!-- sil -->
                            <td width="20">
                                <a href="#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=upd&progress_id=#PROGRESS_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="8"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="ehesap.list_emp_progress_payment#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
