<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.form_exist" default="0">
<cfif attributes.form_exist>
	<cfquery name="GET_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
		SELECT
            EXPENSE_ID,
            #dsn#.Get_Dynamic_Language(EXPENSE_ID,'#session.ep.language#','EXPENSE_CENTER','EXPENSE',NULL,NULL,EXPENSE) AS EXPENSE,
			*
		FROM
			EXPENSE_CENTER
		WHERE	
			EXPENSE_ID IS NOT NULL
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
					EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
				)
			</cfif>
			<cfif len(attributes.process_type) and attributes.process_type eq 1>
				AND EXPENSE_ACTIVE = 1
			<cfelseif len(attributes.process_type) and attributes.process_type eq 0>
				AND EXPENSE_ACTIVE = 0
		    </cfif>
		ORDER BY
			EXPENSE_CODE
	</cfquery>
<cfelse>
	<cfset get_expense.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_expense.recordcount#'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" id="form" action="#request.self#?fuseaction=budget.list_expense_center" method="post">
            <input type="hidden" name="form_exist" id="form_exist" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#">
                </div>
                <div class="form-group">
                    <select name="process_type" id="process_type" style="width:90px;">
                        <option value=""><cf_get_lang dictionary_id='30111.Durumu'></option>
                        <option value="1" <cfif attributes.process_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.process_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>												
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(86,'Masraf Merkezleri',49180)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='49181.Kodu'></th>
                    <th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none" nowrap="nowrap"> <a href="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_expense_center&event=add','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_expense.recordcount>
                <cfset response_id_list=''>
                    <cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif not listfind(response_id_list,get_expense.responsible1)>
                            <cfset response_id_list=listappend(response_id_list,get_expense.responsible1)>
                        </cfif>
                    </cfoutput>
                <cfif listlen(response_id_list)>
                <cfset response_id_list=listsort(response_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_EMP" datasource="#DSN#">
                        SELECT
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            POSITION_CODE
                        FROM 
                            EMPLOYEE_POSITIONS
                        WHERE
                            POSITION_CODE IN (#response_id_list#)
                        ORDER BY
                            POSITION_CODE
                    </cfquery>
                </cfif>
                <cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#get_expense.currentrow#</td>
                        <td style="mso-number-format:\@;">#EXPENSE_CODE#</td>
                        <td>
                            <cfif ListLen(EXPENSE_CODE,".") neq 1>
                            <cfloop from="1" to="#ListLen(EXPENSE_CODE,".")#" index="i">
                            &nbsp;
                            </cfloop>
                            </cfif>
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=budget.list_expense_center&event=upd&obj=1&expense_id=#expense_id#',<cfif ListLen(EXPENSE_CODE,".") neq 1>'medium'<cfelse>'medium'</cfif>);" class="tableyazi"> #EXPENSE# </a> </td>
                            <td>#DETAIL#</td>
                        <td>
                            <cfif listlen(response_id_list)>
                            #get_emp.EMPLOYEE_NAME[listfind(response_id_list,responsible1,',')]# #get_emp.EMPLOYEE_SURNAME[listfind(response_id_list,responsible1,',')]#
                            </cfif>
                        </td>
                        <!-- sil -->
                        <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=budget.list_expense_center&event=upd&obj=1&expense_id=#expense_id#',<cfif ListLen(EXPENSE_CODE,".") neq 1>'medium'<cfelse>'medium'</cfif>);" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <cfif attributes.form_exist>
                            <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        <cfelse>
                            <td colspan="7"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                        </cfif>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset url_str="">
        <cfif isdefined ("attributes.keyword") and len (attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined ("attributes.form_exist") and len (attributes.form_exist)>
            <cfset url_str = "#url_str#&form_exist=#attributes.form_exist#">
        </cfif>
        <cfif isdefined ("attributes.process_type") and len (attributes.process_type)>
            <cfset url_str ="#url_str#&process_type=#attributes.process_type#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="budget.list_expense_center#url_str#"> 
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
