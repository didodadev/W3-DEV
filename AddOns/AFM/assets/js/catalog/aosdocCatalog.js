$(document).ready(function(){
    $("#aosMarka").change(function(){
        var Markaid = $("#aosMarka").find("option:selected").attr("value");
        GetModelList(Markaid);
    })
    $("#aosModel").change(function(){
        var Modelid =$("#aosModel").find("option:selected").attr("value");
        GetYilList(Modelid);
    })
    $("#aosYil").change(function(){
        var Modelid =$("#aosModel").find("option:selected").attr("value");
        var aosYil =$("#aosYil").find("option:selected").attr("value");
        GetMotorTable(Modelid,aosYil);
    })
    $("#aosArac").change(function(){
        var Modelid =$("#aosModel").find("option:selected").attr("value");
        GetMainCategories(Modelid);
    })
    GetMarkaList();
})
function GetMarkaList(){
    $.ajax({
        type: "GET",
        url: "http://192.168.30.7:8665/Otoismail/GetMarkaList",
        //url: "/Otoismail/GetModelList?MarkaId=" + Markaid,      
    }).done(function (data) {
        $("#aosMarka.selectpicker").empty();
        JSON.parse(data).forEach(element => {
            $("#aosMarka.selectpicker").append(`<option value="${element["Id"]}">${element["Ad"]}</option>`);
        })
        $("#aosMarka.selectpicker").selectpicker("refresh");
        var Markaid = $("#aosMarka").find("option:selected").attr("value");
        GetModelList(Markaid);
    })
}
function GetModelList(Markaid) {
    $.ajax({
        type: "GET",
        url: "http://192.168.30.7:8665/Otoismail/GetModels?MarkaId=" + Markaid,
        //url: "/Otoismail/GetModelList?MarkaId=" + Markaid,      
    }).done(function (data) {
        $("#aosModel.selectpicker").empty();
        JSON.parse(data).forEach(element => {
            $("#aosModel.selectpicker").append(`<option value="${element["Id"]}">${element["Ad"]}</option>`);
        })
        $("#aosModel.selectpicker").selectpicker("refresh");
        var Modelid =$("#aosModel").find("option:selected").attr("value");
        GetYilList(Modelid);
    })
}

function GetYilList(Modelid) {
    $.ajax({
        //url : "http://31.169.71.253:8665/Otoismail/GetYilList?ModelId=" + Modelid
        url: "http://192.168.30.7:8665/Otoismail/GetYilList?ModelId=" + Modelid
    }).done(function (data) {
        $("#aosYil.selectpicker").empty();
        $("#aosYil.selectpicker").append(`<option value="0" onclick="GetMotorTable(${Modelid},0)">TÜM YILLAR</option>`);
        JSON.parse(data).forEach(element => {
            $("#aosYil.selectpicker").append(`<option value="${element}">${element}</option>`)
        })
        $("#aosYil.selectpicker").selectpicker("refresh");
        var aosYil =$("#aosYil").find("option:selected").attr("value");
        GetMotorTable(Modelid,aosYil);

    })
}

function GetMotorTable(Modelid,Yil) {
        $.ajax({
             //url: "http://31.169.71.253:8665/Otoismail/GetMotorList?ModelId=" + Modelid+"&Yil="+Yil,      
            url: "http://192.168.30.7:8665/Otoismail/GetMotorList?ModelId=" + Modelid+"&Yil="+Yil,  
        }).done(function (data) {
            $("#aosArac.selectpicker").empty();
            JSON.parse(data).forEach(element => {
                $("#aosArac.selectpicker").append(`<option value="${element["Id"]}">${element["Ad"]} - ${element["MotorKodu"]} - ${element["KasaTipi"]}</option>`)
            })
            $("#aosArac.selectpicker").selectpicker("refresh");
            GetMainCategories(Modelid);
        })
    }
function GetMainCategories(ModelId) {
    $.ajax({
        //url: `http://31.169.71.253:8665/Otoismail/GetCategories?MotorId=${ModelId}&KategoriId=0`
        url: `http://192.168.30.7:8665/Otoismail/GetCategories?MotorId=${ModelId}&KategoriId=0`
    }).done(function (data) {
        $("#aosKategori.selectpicker").empty();
        JSON.parse(data).forEach(element => {
            $("#aosKategori.selectpicker").append(`<option value="${element["KategoriNo"]}">${element["KategoriAd"]}</option>`)
        })
        $("#aosKategori.selectpicker").selectpicker("refresh");
    });
}
    function GetCategories(ModelId, KategoriId) {
        $.ajax({
            //url: `http://31.169.71.253:8665/Otoismail/GetCategories?MotorId=${ModelId}&KategoriId=${KategoriId}`
            url: `http://192.168.30.7:8665/Otoismail/GetCategories?MotorId=${ModelId}&KategoriId=${KategoriId}`
        }).done(function (data) {
            $("#aosKategori.selectpicker").empty();
            JSON.parse(data).forEach(element => {
                $("#aosKategori.selectpicker").append(`<option value="${element["KategoriNo"]}">${element["KategoriAd"]}</option>`)
            })
            $("#aosKategori.selectpicker").selectpicker("refresh");
        });
    }
    function SearchPart(){
        var MotorId =$("#aosArac").find("option:selected").attr("value");
        var KategoriId =$("#aosKategori").find("option:selected").attr("value");
        $.ajax({
            //url: `http://31.169.71.253:8665/Otoismail/GetCategories?MotorId=${ModelId}&KategoriId=${KategoriId}`
            url: `http://192.168.30.7:8665/Otoismail/GetUrunler?MotorId=${MotorId}&KategoriId=${KategoriId}`
        }).done(function (data) {
            $("#partList").empty();
            JSON.parse(data).forEach(parca => {
                $("#partList").append(`<tr><td>${parca["ParcaKodu"]}</td><td style="width:150px"><a href="javascript://" onclick="add_barkod_serial('${parca["ParcaKodu"]}')">200.41.${parca["ParcaKodu"]}</a></td><td style="width:130px">${parca["Marka"]}</td><td style="max-width:40px;">-</td><td style="max-width:40px;">-</td><td style="max-width:40px;">Ekle</td></tr>`)
            })
        });
    }
    function PartFilter() {
        var input, filter, ul, txtValue;
        input = document.getElementById("categoryFilter");
        filter = input.value.toUpperCase();
        ul = $("[id='kategoriler']").each(function(idx,ele){
            txtValue = ele.textContent || ele.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                ele.style.display = "";
            } else {
                ele.style.display = "none";
            }
        });
    }
