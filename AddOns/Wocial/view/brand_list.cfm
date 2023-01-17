<cfinclude template="../wocial_app.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset brand = createObject("component","AddOns/Wocial/Component/data/brand")>
<cfset get = brand.get() />

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform>
        <cf_box>
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <input type="text" name="keyword" style="width:100px;" maxlength="255" placeholder="<cfoutput>#place#</cfoutput>">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="<cfoutput>#message#</cfoutput>" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cf_box>
    </cfform>
    <cf_box title="Brands Accounts" add_href="#request.self#?fuseaction=wocial.brand&event=add">
        <cf_flat_list>
            <thead>
                <th width="20">#</th>
                <th>Brand</th>
                <th>Platform</th>
                <th>Post</th>
                <th>Follower</th>
                <th>Comment</th>
                <th width="20"><i class="fa fa-space-shuttle" title="Spark"></i></th>
                <th width="20"><i class="fa fa-google"></i></th>
                <th width="20" class="header_icn_none text-center">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=wocial.brand&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </th>
            </thead>
            <tbody>
            <cfif get.recordcount>
                <cfoutput query="get" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="20">1</td>
                        <td>#BRAND_NAME#</td>
                        <td>#PLATFORM_NAME#</td>
                        <td>67</td>
                        <td>18.670</td>
                        <td>3.621</td>
                        <td width="20"><i class="fa fa-space-shuttle" title="Spark"></i></td>
                        <td width="20">><a href="#BRAND_SOCIAL_MEDIA_URL#" target="_blank"><i class="fa fa-unlink"></i></a></td>
                        <td width="20" style="text-align:center;"><a href="#request.self#?fuseaction=wocial.brand&event=upd&brand_id=#BRAND_ID#"><i class="fa fa-pencil"></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr><td colspan="9"><cf_get_lang dictionary_id = "57484.Kayıt Yok"></td></tr>
            </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>