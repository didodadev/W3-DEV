
<cfparam name="attributes.keyword" default="">
<cfobject name="packages" component="addons.jedi.models.jedipackage">
<cfset qpackages = packages.listpackage(attributes.keyword)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box scroll="0">
        <cfform name="search_asset" method="post" action="#request.self#?fuseaction=jedi.package">
            <input type="hidden" name="form_submitted" id="item-form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-form_ul_keyword">				
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="Filtre">
                </div>
                <div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
				</div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="Paketler" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th style="width: 60px;">ID</th>
                    <th>Paket</th>
                    <th style="width: 150px;">Durum</th>
                    <th style="width: 30px;">#</th>
                    <th style="width: 30px;">#</th>
                </tr>
            </thead>
            <tbody>
                <cfif qpackages.recordcount>
                <cfoutput query="qpackages">
                <tr>
                    <td>#package_id#</td>
                    <td>#head#</td>
                    <td>#is_active eq 1 ? "Aktif" : "Pasif"#</td>
                    <td>
                        <a href="#request.self#?fuseaction=jedi.package&event=upd&id=#package_id#"><i class="fa fa-pencil" title="<cf_get_lang_main no='52.Güncelle'>" alt="<cf_get_lang_main no='52.Güncelle'>"></i></a>
                    </td>
                    <td>
                        <a href="#request.self#?fuseaction=jedi.playground&event=init&id=#package_id#" target="_blank"><i class="fa fa-play" title="Çalıştır" alt="Çalıştır"></i></a>
                    </td>
                </tr>
                </cfoutput>
                <cfelse>
                <tr>
                    <td colspan="4">Kayıt Bulunamadı</td>
                </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        return true;
    }
</script>