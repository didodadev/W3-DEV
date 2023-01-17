<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_box_search>
            <div class="form-group">
                <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <input type="text" placeholder="<cfoutput>#place#</cfoutput>">
            </div>
            <div class="form-group">
                <div class="input-group">
                    <input type="text" placeholder="Kampanya">
                    <span class="input-group-addon icon-ellipsis"></span>
                </div>
            </div>
            <div class="form-group">
                <select>
                    <option value="">Multiselect 
                </select>
            </div>
            <div class="form-group">
                <div class="input-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                    <input type="text" name="maxrows" value="" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function='kontrol()'>
                <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
            </div>
        </cf_box_search>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='49486.Gönderiler'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <th>#</th>
                <th><cf_get_lang dictionary_id='58820.Başlık'></th>
                <th><cf_get_lang dictionary_id='57446.Kampanya'></th>
                <th><cf_get_lang dictionary_id='57416.Proje'></th>
                <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                <th><cf_get_lang dictionary_id='31639.Yayın Tarihi'></th>
                <th width="30">P</th>
                <th width="20" class="header_icn_none text-center">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=wocial.post&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </th>
            </thead>
            <tbody>
                <td>#</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td width="20" style="text-align:center;"><i class="fa fa-pencil"></i></td>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>