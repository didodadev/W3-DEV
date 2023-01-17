<cfparam name="attributes.search" default=''>
<cfform name="form_product_search" id="form_product_search" method="post" class="mb-0">
    <div>
        <div class="col-md-5 mx-auto">
            <div class="input-group">             
                <input class="form-control border-end-0 border" type="text" value="<cfoutput>#attributes.search#</cfoutput>" id="search_solr" name="search_solr" placeholder="<cf_get_lang dictionary_id='50616.Anahtar Kelime'>, <cf_get_lang dictionary_id='57486.Kategori'>, <cf_get_lang dictionary_id='58847.Marka'>, <cf_get_lang dictionary_id='59107.Özellik'>">
                <span class="input-group-append" onclick="search()">
                    <span class="btn btn-outline-secondary border-start-0 border ms-n5 pt-2" >
                        <i class="fa fa-search"></i>
                    </span>
                </span>
            </div>
        </div>
    </div>
</cfform>
<script>
    function search(){
        $('#form_product_property_filter input[name=search]').val($('input[name=search_solr]').val());
        $('#form_product_property_filter').submit();
    }
    $(document).keypress(function(event){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            search();
            return false;
        }
      });
</script>