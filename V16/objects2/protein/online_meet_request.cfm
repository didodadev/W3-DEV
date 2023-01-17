<button type="button" class="close header-color" aria-label="Close">
    <span aria-hidden="true">&times;</span>
</button>
<div class="row mb-4">
    <div class="col-md-12 pl-0">
        <svg height="50" width="50" style="float: left;">
            <image href="w3menu.png" height="50px" width="50px" />
        </svg>
        <h4 class="mt-2 header-color"><cf_get_lang dictionary_id='61624.Online Meet Talebi'></h4>
    </div>
</div>
<div class="row">
    <div class="col-md-4">
        <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61766.Abone ID'></p>
        <p class="mb-0">CTLS-1290-1782-333X</p>
        <div class="span-class">
            <span class="badge mb-4 btn-color-3">LYKP</span>
            <span class="badge mb-4 btn-color-4">WORKDESK SILVER</span>
        </div>
    </div>
    <div class="col-md-4">
        <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61900.Meet Talebi'></p>
        <p class="mb-0">Democrat Party - Bernie Sender</p>
    </div>
    <div class="col-md-4">
        <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61901.Çağrı ID'></p>
        <p class="mb-0">BN-20211</p>
    </div>
</div>
<p class="font-weight-bold"><cf_get_lang dictionary_id='61902.Danışman seçebilir veya uygun danışmanı arayabilirsiniz.'></p>
<div class="form-inline mb-4">
    <div class="input-group col-sm-8 col-md-6 col-lg-5 pl-0">
        <input type="text" class="form-control none-border-r" placeholder="Vecihi Hürkuş">
        <div class="input-group-append">
            <span class="input-group-text append-icon"><a href="#" class="none-decoration"><i class="far fa-user"></i></a></span>
        </div>
    </div>
    <div class="form-group">
        <button type="button" class="btn font-weight-bold btn-color-7 text-uppercase"><i class="fa fa-search"></i> <cf_get_lang dictionary_id='57565.Ara'></button>
    </div>
</div>
<div class="row mb-4">
    <div class="col-md-12">
        <a href="#" class="none-decoration">
            <svg height="50" width="50" style="float: left;">
                <image href="w3menu.png" height="50px" width="50px" />
            </svg>
            <p class="font-weight-bold mt-3"><cf_get_lang dictionary_id='61903.Danışmanın ajandasını kontrol etmek için tıklayın'>.</p>
        </a>
    </div>
</div>
<form>
    <div class="form-row mb-3">     
        <div class="form-group col-12 col-sm-8 col-md-6 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='31940.Görüşme Tarihi'></label>
            <input type="date" class="form-control form-control">
        </div>

        <div class="form-group col-8 col-sm-4 col-md-4 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57491.Saat'></label>
            <div class="form-row">
                <div class="col-6 ">
                    <input type="text" class="form-control text-right">
                </div>
                <div class="col-6">
                    <input type="text" class="form-control">
                </div>
            </div>
        </div>             

        <div class="form-group col-8 col-sm-4 col-md-4 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38215.Öngörülen Süre'></label>
            <div class="form-row">
                <div class="col-6">
                    <input type="text" class="form-control text-right">
                </div>
                <div class="col-6">
                    <input type="text" class="form-control" >
                </div>
            </div>
        </div>   

        <div class="form-group col-8 col-sm-4 col-md-4 col-lg-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='40000.Tahmini Bütçe'></label>
            <div class="form-row">
                <div class="col-6">
                    <input type="text" class="form-control text-right" placeholder="210" >
                </div>
                <div class="col-4 pl-0">
                    <input type="text" class="form-control" placeholder="TL" >
                </div>
            </div>
        </div>            
    </div>
</form>
<div class="row mb-3">
    <div class="col-md-12">
        <div id="editor">
            <p>This is some sample content.</p>
        </div>
    </div>
</div>
<div class="row mb-3">
    <div class="col-md-12">
        <label class="checkbox-container font-weight-bold mb-0"><cf_get_lang dictionary_id='61904.Dikkat bu talebiniz seçtiğiniz danışmanın tarifesine göre ücretlendirilecektir'>.
            <input type="checkbox">
            <span class="checkmark"></span>
        </label>    
        <a href="#" class="none-decoration ml-4 pl-1"><small>><cf_get_lang dictionary_id='61905.Kuralları okuyunuz'>.</small></a>                                                                
    </div>
</div>       
<button type="submit" class="btn btn-color-2 float-right"> <cf_get_lang dictionary_id='61895.Meet Talep Et'></button>

<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script>