var serviceUrl = "http://catsvc.debian.aos/tr/etka";

function GetMarket() {
    var market = $("#market");
    market.valid();
    var prmMake = $('#make-sel-btngroup').find("input:checked").attr("value");
    var prmMarket = $("#market").find("option:selected").attr("value");

    $.ajax({
        type: "GET",
        url: `${serviceUrl}/${prmMake}/${prmMarket}/models`,
        contentType: 'application/json',
        beforeSend: function () {
            //$("#overlay").show();
        },
        success: function (msg) {

            var arr = msg.data.models;
            var i;
            var out = "<option Value='' class='hidden'>" + $('#market').attr('data-model-seciniz-language') + "</option>";

            for (i = 0; i < arr.length; i++) {
                var manufactured_to = arr[i].manufactured_to;
                if (manufactured_to == null) {
                    manufactured_to = "";
                }
                if (i > 0) {
                    if (arr[i].model_name[0] != arr[i - 1].model_name[0]) {
                        out += "<option data-divider='true'></option>";
                    }
                }
                out += "<option value='" + arr[i].model_code + "' data-subtext='" + arr[i].manufactured_from + "..." + manufactured_to + "'>" + arr[i].model_name + "</option>";
            }
            $("#model").html(out);
            $("#model").selectpicker('refresh');
        },
        error: function (msg) {
            alert(msg);
        },
        complete: function () {
            //$("#overlay").hide();
        }
    });
}
