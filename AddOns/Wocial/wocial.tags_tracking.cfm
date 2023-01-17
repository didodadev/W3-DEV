<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_box_search>
            <div class="form-group">
                <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <input type="text" name="keyword" style="width:100px;" maxlength="255" placeholder="<cfoutput>#place#</cfoutput>">
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                <input type="text" name="maxrows" value="" required="yes" validate="integer" range="1,999" message="<cfoutput>#message#</cfoutput>" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>
    </cf_box>
    <cf_box>
        <cf_flat_list>
            <thead>
                <th><cf_get_lang dictionary_id='37353.İlişkili Markalar'></th>
                <th><cf_get_lang dictionary_id='50555.İlişkili Ürünler'></th>
                <th><cf_get_lang dictionary_id='61440.Anahtar Müşteri'> / <cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                <th><cf_get_lang dictionary_id='61441.Anahtar Çalışan'></th>
                <th width="20" class="header_icn_none text-center">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=wocial.tags_tracking&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </th>
            </thead>
            <tbody>
                <td>#</td>
                <td>#</td>
                <td>#</td>
                <td>#</td>
                <td width="20" style="text-align:center;"><i class="fa fa-pencil"></i></td>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>