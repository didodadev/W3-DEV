<cfparam name="attributes.is_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
	<cfquery name="SCHOOLS" datasource="#dsn#">
		SELECT
		   *
		FROM
			SETUP_SCHOOL
		<cfif len(attributes.keyword)>
		WHERE
			SCHOOL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		ORDER BY
			SCHOOL_NAME 
	</cfquery>
<cfelse>
	<cfset SCHOOLS.RecordCount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#SCHOOLS.RecordCount#">
<cf_box title="#getLang('','Üniversiteler',31413)#">
    <cfform name="form" action="#request.self#?fuseaction=settings.list_school" method="post">
        <cfinput name="is_submit" value="1" type="hidden">
        <cf_box_elements>
            <div class="ui-form-list flex-list">
                <div class="form-group medium">
                    <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </div>
        </cf_box_elements>
    </cfform>
    <cf_grid_list>
        <thead>
            <tr>
                <th style="width:25%;"><cf_get_lang dictionary_id='30645.Okul Adı'></th>
                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                <th style="width:15px;"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_form_add_school','add_school_box','ui-draggable-box-small');"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfif SCHOOLS.RecordCount>
                <cfoutput query="SCHOOLS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_school&id=#SCHOOL_ID#','upd_school_box','ui-draggable-box-small');" class="tableyazi">#SCHOOL_NAME#</a>
                    </td>
                    <td>#DETAIL#</td>
                    <td>
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_school&id=#SCHOOL_ID#','upd_school_box','ui-draggable-box-small');"><i class="fa fa-pencil"></i></a>
                    </td>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="8">
                        <cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
                            <cf_get_lang dictionary_id ="57484.Kayıt Yok">!
                        <cfelse>
                            <cf_get_lang dictionary_id ="57701.Filtre Ediniz">!
                        </cfif>
                    </td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset adres="settings.list_school">
        <cfif len(attributes.is_submit)>
            <cfset adres = "#adres#&is_submit=#attributes.is_submit#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>