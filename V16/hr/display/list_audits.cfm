<!--- list_employee_healty_all --->
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.audit_type" default="">
<cfif len(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
	<cfset date_1=dateformat(attributes.startdate,dateformat_style)>
<cfelse>
	<cfset date_1="">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
	<cfset date_2=dateformat(attributes.finishdate,dateformat_style)>
<cfelse>
	<cfset date_2="">
</cfif>
<cfif isdefined('attributes.form_submit')>
<cfinclude template="../query/get_audits.cfm">
<cfelse>
<cfset get_audits.recordcount = 0>
</cfif>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_AUDITS.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=hr.list_audits" method="post" name="form1">
            <input name="form_submit" id="form_submit" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getlang('','filtre','57460')#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group" id="item-branch_id">
                    <select name="branch_id" id="branch_id">
                        <option value="0" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 0>selected</cfif>><cf_get_lang dictionary_id='29434.Şubeler'></option>
                        <cfoutput query="get_branches" group="NICK_NAME">
                            <optgroup label="#NICK_NAME#"></optgroup>
                            <cfoutput>
                                <option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                            </cfoutput>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-department">
                    <cfquery name="get_departmant" datasource="#dsn#">
                        SELECT D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME FROM DEPARTMENT D,BRANCH B WHERE D.BRANCH_ID = B.BRANCH_ID AND D.IS_STORE <> 1 ORDER BY B.BRANCH_NAME,D.DEPARTMENT_HEAD
                    </cfquery>
                    <select name="department" id="department">
                        <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                        <cfoutput query="get_departmant" group="BRANCH_NAME">
                            <optgroup label="#BRANCH_NAME#"></optgroup>
                            <cfoutput>
                                <option value="#DEPARTMENT_ID#"<cfif isdefined("attributes.department") and (attributes.department eq DEPARTMENT_ID)> selected</cfif>>#DEPARTMENT_HEAD#</option>
                            </cfoutput>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-startdate">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.başlangıç tarihi'></cfsavecontent>
                        <cfinput type="text" name="startdate" maxlength="10" value="#date_1#" placeholder="#message#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group" id="item-finishdate">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.bitiş tarihi'></cfsavecontent>
                        <cfinput type="text" name="finishdate" maxlength="10" value="#date_2#" placeholder="#message#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>                    
                    </div>
                </div>
                <div class="form-group">
                    <select name="audit_type" id="audit_type">
                        <option value="" selected><cf_get_lang dictionary_id="57630.Tip"></option>
                        <option value="1" <cfif attributes.audit_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58561.İç'></option>
                        <option value="0" <cfif attributes.audit_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58562.Dış'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button search_function="date_check(form1.startdate,form1.finishdate,'#message_date#')" button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="47129.İşyeri Denetim İşlemleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1"> 
        <cf_flat_list>   
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='55230.Denetlenen Şube'></th>
                    <th><cf_get_lang dictionary_id="59307.Denetlenen Departman"></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='55231.Denetleyen'></th>
                    <th><cf_get_lang dictionary_id='55232.Verilen Süre'></th>
                    <th><cf_get_lang dictionary_id ='57640.Vade'></th>
                    <th><cf_get_lang dictionary_id='57630.Tip'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center">
                        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.list_audits&event=add</cfoutput>','','ui-draggable-box-large')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                          
                        </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif GET_AUDITS.recordcount>
                    <cfoutput QUERY="GET_AUDITS"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(GET_AUDITS.AUDIT_RECHECK_DATE)>
                            <cfset a = datediff('d',now(),GET_AUDITS.AUDIT_RECHECK_DATE)>	
                            <cfelse>
                            <cfset a = 0>				
                        </cfif>
                        <tr<cfif (a gt 0) and (a lte 7)>style="color:red;"</cfif>>
                            <td>#currentrow#</td>
                            <td>#GET_AUDITS.BRANCH_NAME#</td>
                            <td>#GET_AUDITS.DEPARTMENT_HEAD#</td>
                            <td>#dateformat(GET_AUDITS.AUDIT_DATE,dateformat_style)#</td>
                            <td>#GET_AUDITS.AUDITOR#</td>
                            <td>#dateformat(GET_AUDITS.AUDIT_RECHECK_DATE,dateformat_style)#</td>
                            <td>#dateformat(GET_AUDITS.term_date,dateformat_style)#</td>
                            <td><cfif GET_AUDITS.AUDIT_TYPE is 1><cf_get_lang dictionary_id='58561.İç'><cfelse><cf_get_lang dictionary_id='58562.Dış'></cfif></td>
                            <!-- sil -->
                            <td style="text-align:center;"> 
                                <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.list_audits&event=upd&audit_id=#AUDIT_ID#','','ui-draggable-box-large')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.güncelle'>" alt="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a> 
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list> 
        <cfset adres=attributes.fuseaction>
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.startdate)>
            <cfset adres = "#adres#&startdate=#date_1#">
        </cfif>
        <cfif len(attributes.finishdate)>
            <cfset adres = "#adres#&finishdate=#date_2#">
        </cfif>
        <cfif len(attributes.audit_type)>
            <cfset adres = "#adres#&audit_type=#attributes.audit_type#">
        </cfif>
        <cfif isdefined('attributes.form_submit')>
            <cfset adres = "#adres#&form_submit=#attributes.form_submit#">
        </cfif>
        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
            <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isdefined('attributes.department') and len(attributes.department)>
            <cfset adres = "#adres#&department=#attributes.department#">
        </cfif>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
