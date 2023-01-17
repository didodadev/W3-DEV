<cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information( get_all : true ) />

<cf_box title="Release History">
	<cf_grid_list sort = "0">
        <thead>
            <tr>
                <th>Release No</th>
                <th>Release Date</th>
            </tr>
        </thead>
        <tbody>
            <cfif workcube_license.recordcount>
                <cfoutput query = "workcube_license">
                    <tr>
                        <td>#RELEASE_NO#</td>
                        <td>#dateformat(RELEASE_DATE,dateformat_style)# #dateformat(RELEASE_DATE,timeformat_style)#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr><td colspan = "2"><cf_get_lang dictionary_id = "57484.Kayıt yok"></td></tr>    
            </cfif>
        </tbody>
    </cf_grid_list>
</cf_box>