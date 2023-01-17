<cfparam name="attributes.param" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="&keyword=#attributes.keyword#">
<cfif isdefined('attributes.form_submit')>
<cfset url_str = "&form_submit=#attributes.form_submit#">
</cfif>
<cfif isdefined('attributes.form_submit')>
<cfinclude template="../../query/get_position_branches.cfm">
<cfquery name="get_discipline_event" datasource="#DSN#">
	SELECT
		EER.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_EVENT_REPORT EER,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = EER.TO_CAUTION AND
		EVENT_TYPE LIKE '%#ATTRIBUTES.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		<cfif not session.ep.ehesap>
			AND E.EMPLOYEE_ID IN	
			(	
			SELECT EMPLOYEE_ID 
			FROM EMPLOYEE_POSITIONS,DEPARTMENT
			WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#) 
			)
		</cfif>
</cfquery>
<cfelse>
<cfset get_discipline_event.recordcount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_discipline_event"  name="myform" method="post" >
            <cf_box_search>
                <input name="form_submit" id="form_submit" type="hidden" value="1">
                <div class="form-group">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#header_#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57591.Olay Tutanağı"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list>  
            <thead>
                <tr> 
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='53088.Olay Türü'></th>
                    <th><cf_get_lang dictionary_id='53089.İlgili Kişi'></th>
                    <th><cf_get_lang dictionary_id='53090.İlgili Kurum'> </th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <!-- sil -->
                    <th width="20"><A href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_discipline_event&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>" alt="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfparam name="attributes.totalrecords" default=#get_discipline_event.recordcount#>
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif get_discipline_event.recordcount>
                    <cfoutput query="get_discipline_event" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                        <tr>
                            <td width="35">#currentrow#</td>
                            <td><cfif event_type eq 1>Olay Tutanağı<cfelseif event_type eq 2>İş Kazası Tutanağı<cfelse>#event_type#</cfif></td>
                            <td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#TO_CAUTION#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#TO_COMPANY#</td>
                            <td>&nbsp;#dateformat(SIGN_DATE,dateformat_style)# </td>
                            <!-- sil -->
                            <td><a href="#request.self#?fuseaction=ehesap.list_discipline_event&event=upd&event_id=#EVENT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput> 
                    <cfelse>
                        <tr> 
                            <td colspan="6"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_flat_list>   
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="ehesap.list_discipline_event#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
