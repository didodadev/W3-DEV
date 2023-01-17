<cfprocessingdirective pageEncoding="utf8">
<cfhttp url="http://31.169.71.253:38764/api/vehicles/getmanufacturers?sprachnr=23" result="manufacturers"></cfhttp>
<cfhttp url="http://31.169.71.253:38764/api/search/getpartmanufacturers" result="partmanufacturers"></cfhttp>
<cfhttp url="http://31.169.71.253:38764/api/categories/getmaincategories?sprachnr=23" result="categories"></cfhttp>
<!--- <cfsearch collection="categories" name="categories" category='' categorytree="" criteria="" maxrows="5000">
 ---><!--- <cfscript>
    categoriesNew = queryMap(categories,
    function(obj) {
        obj.Summary = mid(obj.Summary,len(toString(obj.Key))+1,len(obj.Summary)-len(toString(obj.Key)))
        return obj
    })
</cfscript> --->
<cfset manufacturersArray = deserializeJSON(manufacturers.filecontent) >
<cfset categoriesArray = deserializeJSON(categories.filecontent) >
<cfset partmanufacturersArray = deserializeJSON(partmanufacturers.filecontent) >
<cfset manufacturersArray = arrayMap(manufacturersArray,function (item){return { Name :item.Bez}})>
<cfset categoriesArray = arrayMap(categoriesArray,function (item){return { Name :item.desc}})>
<cfset manufacturersQuery = queryNew("Name","Varchar",manufacturersArray)>
<cfset categoriesQuery = queryNew("Name","Varchar",categoriesArray)>
<cfset partmanufacturersQuery = queryNew("DLNr,Marke","Integer,Varchar",partmanufacturersArray)>
<link rel="stylesheet" href="/AddOns/AFM/assets/css/_bootstrap4.css">
<!--<link rel="stylesheet" href="/AddOns/AFM/css/select2.min.css">-->
<link rel="stylesheet" href="/AddOns/AFM/assets/css/tecdoc.css">
<script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>
<script src="/JS/assets/lib/jquery-ui/jquery-ui.js"></script>
<script src="/AddOns/AFM/assets/JS/popper.min.js"></script>
<script src="/AddOns/AFM/assets/JS/BsMultiSelect.js"></script>
<script src="/AddOns/AFM/assets/JS/AfmIntegration.js"></script>
<script src="/AddOns/AFM/assets/JS/select2.min.js"></script>


<div class="bootstrap">
    <div class="cl-xl-4 cl-md-4 cl-sm-12 cl-12">
        <cf_box title="Tecdoc Search" closable="0" collapsable="0" name="Search">
            <div class="search">
                <div class="searhc_body">
                    <div class="form-group">
                        <cf_multiselect2 name="marka" label="Marka Seçiniz" query_name="manufacturersQuery" option_name="Name" option_value="Name">          
                    </div>
                    <div class="form-group">
                        <cf_multiselect2 name="kategoriler" label="Kategori Seçiniz" query_name="categoriesQuery" option_name="Name" option_value="Name">          
                    </div>
                    <div class="form-group">
                        <cf_multiselect2 name="ureticiler" label="Üretici Seçiniz" query_name="partmanufacturersQuery" option_name="Marke" option_value="DLNr">          

                    </div>
                    <div class="form-group">
                        <button id="search-btn" onclick="sendFilterRequest()">Arama Yap</button>
                    </div>
                </div>
            </div>
        </cf_box>
    </div>
    <div class="cl-xl-8 cl-md-8 cl-sm-12 cl-12">
        <cf_box title="Integration" closable="0" collapsable="0">
            <div class="item_body">
                <div class="item_body_filter d-flex">
                    <div class="form-group cl-9 ">
                        <input type="text" placeholder="Filtre için birşeyler yazın">
                    </div>
                    <div class="form-group cl-3">
                        <button onclick="SolrIndex.IndexManufacturers();SolrIndex.IndexCategories();">Filtrele</button>
                    </div>
                </div>
                <div class="item_body_table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>TecDoc Kodu</th>
                                <th>Ürün</th>
                                <th>GTİP</th>
                                <th>Alış Fiyatı</th>
                                <th>Satış Fiyatı</th>
                                <th>KDV</th>
                                <th>
                                    <div class="form-group">
                                        <label>Muhasebe</label>
                                    </div>
                                </th>
                                <th>
                                    <input type="checkbox">
                                </th>
                            </tr>
                        </thead>
                        <tbody id="ProductTable">
                            <tr><td>1</td><td>W 718/2</td><td>Yag filtresi</td><td><div class="form-group"><input type="text"></div></td><td><div class="form-group" style="float:left;width:64%!important"><input type="text"></div><div class="form-group" style="float:right;width:35%!important"><select class="multiple_select"><option value="TL">TL</option><option value="USD">USD</option><option value="EUR">EUR</option></select></div></td><td><div class="form-group" style="float:left;width:64%!important"><input type="text"></div><div class="form-group" style="float:right;width:35%!important"><select class="multiple_select"><option value="TL">TL</option><option value="USD">USD</option><option value="EUR">EUR</option></select></div></td><td><div class="form-group"><input type="text"></div></td><td><div class="form-group"><input type="text"></div></td><td><input type="checkbox"></td></tr>
                            <tr><td>2</td><td>W 717/2</td><td>Yag filtresi</td><td><div class="form-group"><input type="text"></div></td><td><div class="form-group" style="float:left;width:64%!important"><input type="text"></div><div class="form-group" style="float:right;width:35%!important"><select class="multiple_select"><option value="TL">TL</option><option value="USD">USD</option><option value="EUR">EUR</option></select></div></td><td><div class="form-group" style="float:left;width:64%!important"><input type="text"></div><div class="form-group" style="float:right;width:35%!important"><select class="multiple_select"><option value="TL">TL</option><option value="USD">USD</option><option value="EUR">EUR</option></select></div></td><td><div class="form-group"><input type="text"></div></td><td><div class="form-group"><input type="text"></div></td><td><input type="checkbox"></td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="item_bottom">
                    <div class="item_bottom_btn">
                        <button id="btn-sumbit">Kaydet</button>
                    </div>
                    <ul class="pagi">
                        <li><a><i class="icon-chevron-left"></i></a></li>
                        <li class="active"><a>1</a></li>
                        <li><a>2</a></li>
                        <li><a>3</a></li>
                        <li><a>4</a></li>
                        <li><a><i class="icon-chevron-right"></i></a></li>
                    </ul>
                </div>
            </div>
        </cf_box>
    </div>
</div>

    