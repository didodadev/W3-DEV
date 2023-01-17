<cfparam name="attributes.salary_year" default="#session.ep.period_year#">
<cfif isdefined('attributes.form_submit')>
	<cfquery name="GET_SETUP_SALARIES" datasource="#dsn#">
		SELECT
			SU.*
		FROM
			SALARY_UPDATE SU
		WHERE
			SU.UPDATE_ID IS NOT NULL
			<cfif isdefined("attributes.salary_year") and len(attributes.salary_year)>
				AND SU.UPDATE_ID IN (SELECT SUY.UPDATE_ID FROM SALARY_UPDATE_YEARS SUY WHERE SUY.SAL_YEAR = #attributes.salary_year#)
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_setup_salaries.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_SETUP_SALARIES.recordcount#>
<cfparam name="attributes.keyword" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="#request.self#?fuseaction=ehesap.list_setup_salary">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="salary_year" id="salary_year">
                        <option value=""><cf_get_lang dictionary_id="53555.Tüm Yıllar"></option>
                        <cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
                            <cfoutput>
                                <option value="#i#"<cfif attributes.salary_year eq i> selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="52966.Toplu Ücret Ayarlama"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                    <th><cf_get_lang dictionary_id='53132.Başlama Ayı'></th>
                    <th><cf_get_lang dictionary_id='53293.Kimler Etkilensin'></th>
                    <th>(&plusmn;) <cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='53042.Onay Durumu'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <!-- sil --><th class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_setup_salary&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_setup_salaries.recordcount>
                    <cfoutput query="get_setup_salaries" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <cfquery name="get_setup_salary_years" datasource="#dsn#">
                                SELECT * FROM SALARY_UPDATE_YEARS WHERE	UPDATE_ID = #UPDATE_ID#
                            </cfquery>
                            <td width="35">#currentrow#</td>
                            <td>#ValueList(get_setup_salary_years.sal_year)#</td>
                            <td>#ListGetAt(ay_list(),SAL_MON)#</td>
                            <td><cfif CHANGE_ALL EQ 1>
                                    <cf_get_lang dictionary_id='53294.Sadece İşaretliler'>
                                    <cfelse>
                                    <cf_get_lang dictionary_id="57952.Herkes">
                                </cfif>
                            </td>
                            <td><cfif SGN(update_percent) EQ 1>
                                    +
                                    <cfelse>
                                    -
                                </cfif>
                                % #tlformat(update_percent-100,1)#
                            </td>
                            <td><cfif valid eq 1>
                                    <cf_get_lang dictionary_id="58699.Onaylandı"> - #dateformat(valid_date,dateformat_style)#
                                    #get_emp_info(valid_emp,0,0)#
                                <cfelseif valid eq 0>
                                    <cf_get_lang dictionary_id='57617.Reddedildi'> - #dateformat(valid_date,dateformat_style)#
                                    #get_emp_info(valid_emp,0,0)#
                                <cfelse>
                                    <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                                    #get_emp_info(validator_position,1,0)#
                                </cfif>
                            </td>
                            <td><cfif len(update_date)>
                                    #dateformat(update_date,dateformat_style)#
                                <cfelse>
                                    #dateformat(record_date,dateformat_style)#
                                </cfif>
                            </td>
                            <!-- sil --><td align="center"><a href="#request.self#?fuseaction=ehesap.list_setup_salary&event=upd&update_id=#update_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="8"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_flat_list> 
        <cfset url_str = "">
        <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
            <cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
        </cfif>
        <cfif isdefined("attributes.salary_year") and len(attributes.salary_year)>
            <cfset url_str = "#url_str#&salary_year=#attributes.salary_year#">
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="ehesap.list_setup_salary#url_str#">
    </cf_box>
</div>
