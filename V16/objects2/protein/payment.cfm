<p class="small">Ref: CTLS-2345-4354-5435</p>
<div class="tab mb-3">
    <button class="tablinks mr-5 mb-2" onclick="openPayment(event, 'card')" id="defaultOpen">
        <h5><cf_get_lang dictionary_id='61908.Kartla Ödeme'></h5>
    </button>
    <button class="tablinks" onclick="openPayment(event, 'transfer')">
        <h5><cf_get_lang dictionary_id='61909.Havale ile Ödeme'></h5>
    </button>
</div>
<!-- Tab content -->
<div id="card" class="tabcontent">
    <div class="row">
        <div class="col-md-12">
            <div class="form-row">
                <div class="form-group col-lg-6 col-xl-4 mb-3">
                    <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='30233.Kart No'></label>
                    <input type="text" class="form-control" placeholder="____-____-____-____">
                </div>
                <div class="form-group col-lg-4 col-xl-2 mt-4 py-2">
                    <select class="form-control">
                        <option>VISA</option>
                        <option>2</option>
                        <option>3</option>
                        <option>4</option>
                        <option>5</option>
                    </select>
                </div>
            </div>

            <form>
                <div class="form-row">                           
                    <div class="form-group col-lg-2 col-xl-1">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='49020.CVV'></label>                            
                        <input type="text" class="form-control" placeholder="___">                            
                    </div>
                    <div class="form-group col-lg-3 col-xl-3"> 
                        <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61910.Sk Tarihi'></label>
                        <div class="col-lg-6 pl-0 pr-0">                                                     
                            <input type="text" class="form-control" placeholder="__ /__">
                        </div> 
                    </div>
                </div>
            </form>

            <div class="row">
                <div class="col-lg-6 col-xl-4">
                    <div class="form-group">
                        <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='34581.Kart Sahibi'></label>
                        <input type="text" class="form-control" placeholder="">
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-lg-3 col-xl-2 mb-3">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57673.Tutar'></label>
                    <input type="text" class="form-control text-right" placeholder="4.200,00">
                </div>
                <div class="form-group  col-lg-2 col-xl-1 mt-2 py-4">
                    <input type="text" class="form-control" placeholder="TL">
                </div>
            </div>
            <button type="button" class="btn btn-color-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61911.Ödemeyi Tamamla'></button>
        </div>
    </div>
</div>

<div id="transfer" class="tabcontent">
    <div class="row mb-2">                
        <div class="form-group col-lg-10 col-xl-8">
            <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61912.Havale gönderilen hesabın iban kodu'></label>
            <div class="col-lg-7 pl-0 pr-0">
                <input type="text" class="form-control" placeholder="TR123123123123123123">
            </div>
        </div>
    </div>

    <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61913.Dekont belgesini yükleyin'></label>
    <div class="row mb-4">
        <div class="col-lg-8 col-xl-6">
            <div class="input-group">                      
                <input type="text" class="form-control none-border-r" placeholder="dekont.pdf">
                <div class="input-group-append">
                    <span class="input-group-text append-icon"><a href="#" class="none-decoration"><i class="fas fa-file-upload"></i></a></span>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-2">                
        <div class="form-group col-lg-6 col-xl-4">
            <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='49091.Havale Tarihi'></label>
            <div class="col-lg-12 px-0">
                <input type="date" class="form-control">
            </div>
        </div>               
    </div>

    <div class="form-row">
        <div class="form-group col-lg-3 col-xl-2 mb-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57673.Tutar'></label>
            <input type="text" class="form-control text-right" placeholder="4.200,00">
        </div>

        <div class="form-group col-lg-2 col-xl-1 mt-4 py-2">
            <input type="text" class="form-control" placeholder="TL">
        </div>
    </div>

    <button type="button" class="btn btn-color-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61914.Ödemeyi bildir'></button>
</div>

<script>
    function openPayment(evt, paymentName) {
        // Declare all variables
        var i, tabcontent, tablinks;

        // Get all elements with class="tabcontent" and hide them
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }

        // Get all elements with class="tablinks" and remove the class "active"
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }

        // Show the current tab, and add an "active" class to the button that opened the tab
        document.getElementById(paymentName).style.display = "block";
        evt.currentTarget.className += " active";
    }
    document.getElementById("defaultOpen").click();
</script>