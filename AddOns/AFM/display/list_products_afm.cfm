<cfparam name="attributes.is_submit" default="false">
<cfparam name="attributes.keyword" default="">
<cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=afm.install_wizard','medium');" class="tableyazi">Kurulum Sihirbazı</a></cfoutput>
<cfform name="searchProducts" action="#request.self#?fuseaction=afm.list_product" method="post">
    <input type="hidden" name="is_submit" value="true">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
    <div class="col-6">
    <cf_box title="#message#">
    <div class="form-group" id="keyword">
        <cfif isdefined("prod_order_result_") and prod_order_result_ eq 1><!--- üretim sonucu sayfasından geliyorsa readonly olsun (attributes değeri filtreden silinemesin) --->
            <cfinput type="text" name="keyword" value="#attributes.keyword#" readonly>
        <cfelse>
            <label for="keyword">Parça Kodu</label>
            <cfinput type="text" name="keyword"  placeholder="#message#" value="#attributes.keyword#">
        </cfif>
    </div>
    <div class="form-group">
        <cf_wrk_search_button search_function='' button_type="4">
    </div>
</cf_box>
</div>
</cfform>

<cfif attributes.is_submit>
    <cfset afmSearch = CreateObject("component","AddOns.AFM.cfc.AfmSearch")>
    <cfscript>
        searchKey = "#attributes.keyword#"
        searchData = {
            q:"#replace(replace(searchKey,'-',''),'.','')#",
            category:"Parts",
            categoryTree:"Bases",
            collection : "GlobalB2BProductSearchV1",
            maxRows : 20
        }
        SearchResult = afmSearch.SearchSolr(searchData)
        if(len(attributes.keyword)){
            searchData2 = {
                q:"contentsExact:#searchKey#",
                category:"Parts",
                categoryTree:"Bases",
                collection : "GlobalB2BProductSearchV1",
                maxRows : 20
            }
            SearchResult2 = afmSearch.SearchSolr(searchData2)
        }
    </cfscript>

    <div class="col-5 float-left">
        <cf_box title="Parça Kodu ile Arama">
        <table class="table table-bordered table-hover" style="height:300px;overflow-y:scroll">
            <thead>
                <th>Parça Id'si</th>
                <th>Parça Kodu</th>
            </thead>
            <tbody>
                <cfoutput query="SearchResult">
                    <tr>
                        <td>#Key#</td>
                        <td>#Title#</td>
                    </tr>
                </cfoutput>
            </tbody>
        </table>
    </cf_box>
    </div>
    <cfif len(attributes.keyword)>
        <div class="col-5 float-right">
            <cf_box title="Tam Parça Kodu ile Arama">
                <table class="table table-bordered table-hover ">
                    <thead>
                        <th>Parça Id'si</th>
                        <th>Parça Kodu</th>
                    </thead>
                    <tbody>
                        <cfoutput query="SearchResult2">
                            <tr>
                                <td>#Key#</td>
                                <td>#Title#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </cf_box>
        </div>
    </cfif>
</cfif>
