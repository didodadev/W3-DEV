<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_PERF_DEF" datasource="#dsn#">
		SELECT 
        	ID,
			EMPLOYEE_PERFORM_WEIGHT,
			COMP_TARGET_WEIGHT,
            YEAR,
            COMP_PERFORM_RESULT,
            TITLE_ID,
            FUNC_ID
		FROM
			EMPLOYEE_PERFORMANCE_DEFINITION
         WHERE
         	1=1
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND (EMPLOYEE_PERFORM_WEIGHT = #attributes.keyword# OR COMP_TARGET_WEIGHT = #attributes.keyword#)
			</cfif>
            <cfif isdefined("attributes.is_active") and len(attributes.is_active)>
				AND IS_ACTIVE = #attributes.is_active#
			</cfif>
	</cfquery>
<cfelse>
	<cfset GET_PERF_DEF.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_PERF_DEF.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.is_active)>
	<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_target" method="post" action="#request.self#?fuseaction=hr.emp_perf_definition">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active">
                        <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                        <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emp_perf_definition&event=add"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getlang('','Değerlendirme Ağırlıkları','47089')#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id="33726.Bireysel Hedef Ağırlığı"></th>
                    <th><cf_get_lang dictionary_id="33725.Şirket Performans Sonucu Ağırlığı"></th>
                    <th><cf_get_lang dictionary_id="33724.Şirket Performans Sonucu"></th>
                    <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                    <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                    <th><cf_get_lang dictionary_id='58701.Fonksiyon'></th>
                    <th width="20" class="header_icn_none text-center"> <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emp_perf_definition&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_PERF_DEF.recordcount>
                    <cfoutput query="GET_PERF_DEF" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td height="35">#currentrow#</td>
                            <td>#EMPLOYEE_PERFORM_WEIGHT#</td>
                            <td>#COMP_TARGET_WEIGHT#</td>
                            <td>#COMP_PERFORM_RESULT#</td>
                            <td>#YEAR#</td>
                            <td><cfloop list="#title_id#" delimiters="," index="i">
                                    <cfquery name="GET_TITLE" datasource="#dsn#">
                                        SELECT 
                                            TITLE
                                        FROM
                                            SETUP_TITLE
                                        WHERE
                                            TITLE_ID = #i# 
                                    </cfquery>
                                    #GET_TITLE.TITLE#<cfif ListLast(title_id,',') neq i>,</cfif>
                                </cfloop>
                            </td>
                            <td><cfloop list="#func_id#" delimiters="," index="i">
                                    <cfquery name="GET_UNIT" datasource="#dsn#">
                                        SELECT 
                                            UNIT_NAME
                                        FROM
                                            SETUP_CV_UNIT
                                        WHERE
                                            UNIT_ID = #i# 
                                    </cfquery>
                                    #GET_UNIT.UNIT_NAME#<cfif ListLast(func_id,',') neq i>,</cfif>
                                </cfloop>
                            </td>
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=hr.emp_perf_definition&event=upd&weight_id=#ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.emp_perf_definition#url_str#">
    </cf_box>
</div>
<script language="javascript">
	document.getElementById('keyword').focus();
</script>	
