<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.isactive" default="1">
<cfparam name="attributes.template_type" default="">
<cfif isdefined("attributes.form_exist")>
	<cfquery name="GET_EXPENSE" datasource="#dsn2#">
		SELECT 
			TEMPLATE_ID,
			TEMPLATE_NAME,
			IS_INCOME,
			RECORD_DATE,
			RECORD_EMP
		FROM
			EXPENSE_PLANS_TEMPLATES
		WHERE
			TEMPLATE_ID IS NOT NULL
			<cfif len(attributes.keyword)>AND TEMPLATE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
			<cfif len(attributes.isactive)>AND IS_ACTIVE = #attributes.isactive#</cfif>
            <cfif attributes.template_type eq 1>
            	AND IS_INCOME = 0
            <cfelseif attributes.template_type eq 0>
            	AND IS_INCOME = 1
            </cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_expense.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
    <cfset GET_EXPENSE.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_asset" action="#request.self#?fuseaction=budget.list_cost_bill_templates" method="post">
            <input name="form_exist" id="form_exist" value="1" type="hidden">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="template_type" id="template_type Type">
                        <option value="" <cfif attributes.template_type eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="0" <cfif attributes.template_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58677.Gelir'></option>
                        <option value="1"  <cfif attributes.template_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58678.Gider'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="isactive" id="isactive">
                        <option value="1" <cfif attributes.isactive eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.isactive eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value=""  <cfif attributes.isactive eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                    </select>
                </div>
                <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(53,'Masraf/Gelir Şablonları',49147)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='57487.No'></td>
                    <th><cf_get_lang dictionary_id='58640.Şablon'></th>
                    <th><cf_get_lang dictionary_id='49146.Şablon Tipi'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <!-- sil --><th width="20" class="header_icn_none" nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_cost_bill_templates&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_expense.recordcount>	
                <cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#template_name#</td>
                        <td><cfif is_income eq 1><cf_get_lang dictionary_id='58677.Gelir'><cfelse><cf_get_lang dictionary_id='58678.Gider'></cfif></td>
                        <td>#get_emp_info(record_emp,0,1)#</td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                        <!-- sil --><td width="15"><a href="#request.self#?fuseaction=budget.list_cost_bill_templates&event=upd&template_id=#template_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6"><cfif isdefined("attributes.form_exist")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset url_str = "">
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.template_type") and len(attributes.template_type)>
            <cfset url_str = "#url_str#&template_type=#attributes.template_type#">
        </cfif>
        <cfif isdefined("attributes.form_exist") and len(attributes.form_exist)>
            <cfset url_str = "#url_str#&form_exist=#attributes.form_exist#">
        </cfif>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="budget.list_cost_bill_templates#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
