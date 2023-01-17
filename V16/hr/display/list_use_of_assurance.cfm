<cfset HealthExpense= createObject("component","V16.myhome.cfc.health_expense") />
<cfif fusebox.circuit eq 'myhome'>
    <cfset get_expense=HealthExpense.GET_EXPENSE(health_id : attributes.health_id,emp_id : session.ep.userid) />
<cfelse>  
    <cfset get_expense=HealthExpense.GET_EXPENSE(health_id : attributes.health_id) />
</cfif>
<cfset HEComponent = createObject("component","V16.hr.cfc.health_expense")>
<cfset use_of_limbs = HEComponent.GET_USE_OF_TOTAL_LIMBS(emp_id : attributes.emp_id, assurance_id : attributes.assurance_id)>
<cfset use_of_complaints = HEComponent.GET_USE_OF_TOTAL_COMPLAINTS(emp_id : attributes.emp_id, assurance_id : attributes.assurance_id)>
<cfset use_of_mecidions = HEComponent.GET_USE_OF_TOTAL_MECIDIONS(emp_id : attributes.emp_id, assurance_id : attributes.assurance_id)>
<div class="col col-4" id="treatments">
    <cf_ajax_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="34925.Teminatlar"></th>
                <th><cf_get_lang dictionary_id="58909.MAX"></th>
                <th><cf_get_lang dictionary_id="57635.Miktar"></th>
                <th><cf_get_lang dictionary_id="57673.Tutar"></th>
            </tr>
        </thead>
        <tbody>
            <cfif use_of_complaints.recordCount>
                <cfoutput query="use_of_complaints">
                    <tr>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#COMPLAINT#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#MAX#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#COUNT#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#TLFormat(TOTAL,x_rnd_nmbr)#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4"><cf_get_lang dictionary_id ="57484. kayıt yok">!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>
</div>
<div class="col col-4" id="medications">
    <cf_ajax_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="35919.İlaç ve malzemeler"></th>
                <th><cf_get_lang dictionary_id="58909.MAX"></th>
                <th><cf_get_lang dictionary_id="57635.Miktar"></th>
                <th><cf_get_lang dictionary_id="57673.Tutar"></th>
            </tr>
        </thead>
        <tbody>
            <cfif use_of_mecidions.recordCount>
                <cfoutput query="use_of_mecidions">
                    <tr>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#DRUG_MEDICINE#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#MAX#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#COUNT#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#TLFormat(TOTAL,x_rnd_nmbr)#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <td colspan="4"><cf_get_lang dictionary_id ="57484. kayıt yok">!</td>
            </cfif>
        </tbody>
    </cf_ajax_list>
</div>
<div class="col col-4" id="limbs">
    <cf_ajax_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="59566.Uzuvlar"></th>
                <th><cf_get_lang dictionary_id="58909.MAX"></th>
                <th><cf_get_lang dictionary_id="57635.Miktar"></th>
                <th><cf_get_lang dictionary_id="60682.Ölçüm-Derece"></th>
            </tr>
        </thead>
        <tbody>
            <cfif use_of_limbs.recordCount>
                <cfoutput query="use_of_limbs">
                    <cfset get_use_of_limbs_measurement = components.GET_LIMBS_MEASUREMENT(health_id : attributes.health_id, limb_id:limb_id)>
                    <tr>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#LIMB_NAME#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#MAX#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#COUNT#</td>
                        <td <cfif COUNT gt MAX>style="color:red!important;"</cfif>>#TLFormat(get_use_of_limbs_measurement.LIMB_MEASUREMENT,x_rnd_nmbr)#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4"><cf_get_lang dictionary_id ="57484. kayıt yok">!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>
</div>