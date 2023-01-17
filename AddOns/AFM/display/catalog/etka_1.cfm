
<div class="row">
        <cfoutput><form action="javascript:goToEtka2()"></cfoutput>
            <div class="col-xs-12 col-sm-5 col-5 float-left">
                <h2 style="font-weight:500">Araç Seçimi</h2>
                <div class="form-group">
                    <fieldset class="make-sel">
                        <legend>Marka:</legend>
                        <div class="btn-group" data-toggle="buttons" id="make-sel-btngroup">
                            <label class="btn btn-make">
                                <input type="radio" name="make" id="make-vw" value="vw" autocomplete="off" />
                                <span class="logo"><img src="/AddOns\AFM\assets\img\vw.svg" alt="Volkswagen" /></span>
                                <span class="make">Volkswagen</span>
                            </label>
                            <label class="btn btn-make">
                                <input type="radio" name="make" id="make-audi" value="au" autocomplete="off" />
                                <span class="logo"><img src="/AddOns\AFM\assets\img\au.svg" alt="Audi" /></span>
                                <span class="make">Audi</span>
                            </label>
                            <label class="btn btn-make">
                                <input type="radio" name="make" id="make-seat" value="se" autocomplete="off" />
                                <span class="logo"><img src="/AddOns\AFM\assets\img\se.svg" alt="Seat" /></span>
                                <span class="make">Seat</span>
                            </label>
                            <label class="btn btn-make">
                                <input type="radio" name="make" id="make-skoda" value="sk" autocomplete="off" />
                                <span class="logo"><img src="/AddOns\AFM\assets\img\sk.svg" alt="Skoda" /></span>
                                <span class="make">Skoda</span>
                            </label>
                        </div>
                        <div class="form-group" id="market-group">
                            <label for="market">Market:</label>
                            <select class="selectpicker market" name="market" id="market" data-width="100%" data-model-seciniz-language="Model Seçiniz">
                                <option value=""> - </option>
                            </select>
                        </div>

                        <div class="form-group" id="model-group">
                            <label for="model">Model:</label>
                            <select class="selectpicker model" name="model" id="model" data-width="100%" data-yil-seciniz-language="Yıl Seçiniz">
                                <option value=""> - </option>
                            </select>
                        </div>
                        <div class="form-group" id="year-group">
                            <label for="year">Yıl:</label>
                            <select class="selectpicker year" name="epis_type" id="year" data-width="100%" data-show-subtext="true">
                                <option value=""> - </option>
                            </select>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn afm-ui-button-lg open-catalog-btn" id="open-catalog-btn">Kataloğu Aç</button>
                        </div>
                    </fieldset>
                </div>
            </div>
        </form>
        <div class="col-xs-12 col-sm-2 col-2 float-left">
            <div class="or-wrapper">
                <div class="ray"></div>
                <div class="or" style="font-size:26px;">Veya</div>
            </div>
        </div>
        <div class="col-xs-12 col-sm-5 col-5 float-left">
            <h2 style="font-weight:500;">Araç Şasi Numarasını Giriniz</h2>
            <cfform name="search_vin" action="javascript:goToEtkaVin()">
                <div class="input-group vin-input-group">
                    <span class="labelBox" id="vin-addon">Şasi:</span>
                    <input type="text" name="vin" id="vin" class="afmTextInput input-uppercase" aria-describedby="vin-addon" required pattern="[a-zA-Z0-9]{17}" title="VIN Number (17 characters)" />
                    <span class="input-group-btn">
                        <button class="afm-ui-button-lg" type="submit">Ara</button>
                    </span>
                </div>
                <span class="help-block">Örnek: <a href="#" id="vin-example" class="jslink">WVWZZZ13ZCV032869</a></span>
                <cfif isDefined("url.isVinAvailable") and url.isVinAvailable eq false>
                    <span style="font-size:13px;">Belirttiğiniz şasi numarasına ilişkin uygun veriler bulunamamıştır.<br> Ya bu şasi numarası mevcut değildir ya da ilgili aracın verileri henüz kayda geçirilmemiştir.<br> Başka bir şasi numarası deneyiniz, yazım hatası olup olmadığını kontrol ediniz veya sol taraftaki listeden bir model seçiniz.</span>
                </cfif>
                
            </cfform>
        </div>
    </div>

    <script>
    $( document ).ready(function(){
    $.fn.selectpicker.Constructor.BootstrapVersion = '4';

    $("input[name='make']").change(function () {
        var prmMake = $('.make-sel').find("input:checked").attr("value");
        var ParamForMarket = {
            make: prmMake,
        };
        $.ajax({
            type: "GET",
            url: `${serviceUrl}/${prmMake}/markets`,
            contentType: 'application/json',
            beforeSend: function () {
                //$("#overlay").show();
            },
            success: function (msg) {

                var arr = msg.data.markets;
                var i;
                var out = "<option Value='' class='hidden'>Market seçiniz</option>";
                for (i = 0; i < arr.length; i++) {
                    switch (arr[i].market) {
                        case 'BR':
                            out += "<option value='" + arr[i].market + "'>Brazil</option>";
                            break;
                        case 'CN':
                            out += "<option value='" + arr[i].market + "'>China Volkswagen Automotive Company</option>";
                            break;
                        case 'CA':
                            out += "<option value='" + arr[i].market + "'>FAW-VW (FAW-Volkswagen Automotive Company)</option>";
                            break;
                        case 'CZ':
                            out += "<option selected='selected' value='" + arr[i].market + "'>Local Market (for Skoda)</option>";
                            break;
                        case 'E':
                            out += "<option selected='selected' value='" + arr[i].market + "'>Local Market (for SEAT)</option>";
                            break;
                        case 'MEX':
                            out += "<option value='" + arr[i].market + "'>Mexico</option>";
                            break;
                        case 'RA':
                            out += "<option value='" + arr[i].market + "'>Argentina</option>";
                            break;
                        case 'RDW':
                            out += "<option selected='selected' value='" + arr[i].market + "'>Local Market</option>";
                            break;
                        case 'SVW':
                            out += "<option value='" + arr[i].market + "'>Shanghai Volkswagen Automotive Company</option>";
                            break;
                        case 'USA':
                            out += "<option value='" + arr[i].market + "'>USA</option>";
                            break;
                        case 'ZA':
                            out += "<option value='" + arr[i].market + "'>South Africa</option>";
                            break;
                        default:
                            
                            break;
                    };
                    //out += "<option value='" + arr[i].Market + "'>" + arr[i].Market + "</option>";
                }
                $("#market").html(out);
                $("#market").selectpicker('refresh');
                GetMarket();
            },
            error: function (msg) {
                alert(msg);
            },
            complete: function () {
                //$("#overlay").hide();
            }
        });

    });
    $("#model").change(function () {
        $(this).valid();
        var prmMake = $('#make-sel-btngroup').find("input:checked").attr("value");
        var prmMarket = $("#market").find("option:selected").attr("value");
        var prmModel = $("#model").find("option:selected").attr("value");
    
        $.ajax({
            type: "GET",
            url: `${serviceUrl}/${prmMake}/${prmMarket}/${prmModel}/years-and-restrictions`,
            contentType: 'application/json',
            beforeSend: function () {
                //$("#overlay").show();
            },
            success: function (msg) {
    
                var arr = msg.data.years_restrictions;
                var i;
                var out = "<option Value='' class='hidden'>"+$('#model').attr('data-yil-seciniz-language')+"</option>";
    
                for (i = 0; i < arr.length; i++) {
                    var restriction = arr[i].restriction;
                    if (restriction == null) {
                        restriction = "";
                    }
                    out += "<option value='" + arr[i].epis_typ + "' data-subtext=' " + restriction + "'>" + "<b>" + arr[i].man_year + "</b></option>";
                }
                $("#year").html(out);
                $("#year").selectpicker('refresh');
            },
            error: function (msg) {
                alert(msg);
            },
            complete: function () {
                //$("#overlay").hide();
            }
        });
    });
    $("#year").change(function () {
        $(this).valid();
    });
})
    function goToEtka2(){
        var prmMake = $('#make-sel-btngroup').find("input:checked").attr("value");
        var prmMarket = $("#market").find("option:selected").attr("value");
        var prmModel = $("#model").find("option:selected").attr("value");
        var prmEpisType = $("#year").find("option:selected").attr("value");
        var redirectlink = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_etka_2";
        redirectlink+= `&make=${prmMake}&market=${prmMarket}&model=${prmModel}&epis_type=${prmEpisType}`;
        refresh_box('etkaCatalog',`${redirectlink}`,'0');
        void(0);
    }
    function goToEtkaVin(){
        var prmVin = document.getElementById("vin").value;
        var redirectlink = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_etka_vin_findunit";
        redirectlink+= `&vin=${prmVin}`;
        refresh_box('etkaCatalog',`${redirectlink}`,'0');
        void(0);
    }
    </script>
<script src="/AddOns/AFM/assets/JS/catalog/jquery.panzoom.min.js"></script>
