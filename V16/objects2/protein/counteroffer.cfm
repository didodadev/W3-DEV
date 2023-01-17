<button type="button" class="close header-color" aria-label="Close">
    <span aria-hidden="true">&times;</span>
</button>
<div class="row mb-2">
    <div class="col-md-12 pl-0">                
        <h4 class="mt-2 header-color"><i class="fas fa-money-bill-wave"></i> <cf_get_lang dictionary_id='61628.?'>:Boti Can/ Botin - İŞ ID: 120.354</h4>            
    </div>
</div>
<form>
    <div class="form-row">
        <div class="form-group col-7 col-sm-4 col-md-6 col-lg-4 col-xl-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38308.Estimated Budget'></label>                    
            <input type="text" class="form-control text-right" placeholder="<cf_get_lang dictionary_id='61853.Rakam Giriniz'>">                    
        </div>

        <div class="form-group col-5 col-sm-4 col-md-4 col-lg-3 col-xl-2 mt-4 py-2">                    
            <select class="form-control">
                <option>USD</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
            </select>
        </div>            
    </div>
</form>

<form>
    <div class="form-row"> 
        <div class="form-group col-md-7 col-lg-4 col-xl-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='36798.Termin'></label>
            <input type="date" class="form-control">
        </div>
        <div class="form-group col-8 col-sm-4 col-md-5 col-lg-4 col-xl-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38215.Öngörülen Süre'></label>
            <div class="form-row">
                <div class="col-6">
                    <input type="text" class="form-control text-right" placeholder="<cf_get_lang dictionary_id='57491.Saat'>" >
                </div>
                <div class="col-6">
                    <input type="text" class="form-control" placeholder="<cf_get_lang dictionary_id='58127.Dakika'>">
                </div>
            </div>
        </div>           
    </div>
</form>       

<div class="row mb-3">
    <div class="col-md-12">
        <label><cf_get_lang dictionary_id='61801.Not ekleyebilirsiniz'>.</label>
        <div id="editor">
            <p>This is some sample content.</p>
        </div>
    </div>
</div> 

<div class="row mb-3">
    <div class="col-md-12">
        <label class="checkbox-container font-weight-bold"><cf_get_lang dictionary_id='61852.?'><cf_get_lang dictionary_id='61804.Sözleşme niteliği taşır.'>
            <input type="checkbox">
            <span class="checkmark"></span>
        </label>    
        <a href="#" class="none-decoration ml-4 pl-1">
            ><cf_get_lang dictionary_id='61802.Sözleşme detaylarını okuyunuz.'>
        </a>                                                                
    </div>
</div>         
<button type="submit" class="btn btn-color-2 text-uppercase float-right"><i class="fa fa-check"></i> <cf_get_lang dictionary_id='59031.Kaydet'></button>
<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script> 