<cfform name="employees" method="post" action="#request.self#?fuseaction=rule.list_hr"><input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_box_search id="rule_list_hr" more="0" plus="0">
        <div class="form-group">
            <cfinput type="text" name="keyword" placeholder="#getLang('','Who are you looking for?',61433)#"  value="#attributes.keyword#" maxlength="50">
        </div>
        <div class="form-group">
            <select name="emp_status" id="emp_status">
                <option value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                <option value="-1" <cfif isDefined("attributes.emp_status")and(attributes.emp_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                <option value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
            </select>
        </div>
        <div class="form-group small">
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#!" maxlength="3">
        </div>
        <div class="form-group">
            <cf_wrk_search_button button_type="4"> 	
        </div>
    </cf_box_search>
<script type="text/javascript">
	document.employees.keyword.focus();
</script>
</cfform>