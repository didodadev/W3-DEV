$(function(){
    $('.multiple_select').select2({
        placeholder: "Seçiniz",
        allowClear: false
    });
    $('#search-btn').click(function(){
        var html = '<div class="sk-circle"><div class="sk-circle1 sk-child"></div><div class="sk-circle2 sk-child"></div>'+
                    '<div class="sk-circle3 sk-child"></div><div class="sk-circle4 sk-child"></div><div class="sk-circle5 sk-child"></div>'+
                    '<div class="sk-circle6 sk-child"></div><div class="sk-circle7 sk-child"></div><div class="sk-circle8 sk-child"></div><div class="sk-circle9 sk-child"></div>'+
                    '<div class="sk-circle10 sk-child"></div><div class="sk-circle11 sk-child"></div><div class="sk-circle12 sk-child"></div></div>';
    
        $(this).html(html);

    });
})

async function sendFilterRequest(){
    categoryList = $("#kategoriler").val();
    dlnr_array = $("#ureticiler").val();
    vehicleList = $("#marka").val();
    rowCount = 10;
    getVehiclesArray().then((res) =>{
        getCategoriesArray().then((catres) => {
        var data = {
            genartnr_array : catres,
            ktypenr_array: res,
            dlnr_array : dlnr_array,
            RowCount : rowCount,
            lang : 23
        }
        
    $.ajax({
        url:'http://31.169.71.253:38764/api/test/w3filter',
        type: "POST",
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=utf-8',
        },
        data: JSON.stringify(data)
    }).done((resp)=>{
        i= 1;
        document.getElementById("ProductTable").innerHTML = "";
        resp = JSON.parse(resp);
        resp.forEach((element)=>{
            $("#ProductTable").append(`<tr><td>${i}</td><td>${element.ArtNr}</td><td>${element.Bez}</td><td><div class="form-group"><input type="text"></input></div></td><td><div class="form-group" style="float:left;width:64%!important"><input type="text"></input></div><div class="form-group" style="float:right;width:35%!important"><select class="multiple_select"><option value="TL">TL</option><option value="USD">USD</option><option value="EUR">EUR</option></select></div></td><td><div class="form-group" style="float:left;width:64%!important"><input type="text"></input></div><div class="form-group" style="float:right;width:35%!important"><select class="multiple_select"><option value="TL">TL</option><option value="USD">USD</option><option value="EUR">EUR</option></select></div></td><td><div class="form-group" ><input type="text"></input></div></td><td><div class="form-group"><input type="text"></input></div></td><td><input type="checkbox"></td></tr>`);
            i++;
        })
    });
})
    })

}
async function getVehiclesArray(){
    return new Promise(async (resolve) => {
    const vehicles = await searchForVehicles(vehicleList);
    let ktypenr_array = [];
    while(true){
        let category = await vehicles.next()
        if(category.done){
            break;
        }
        let searchData = {
            q:"",
            category:"",
            categoryTree:category.value,
            collection : "vehicles"
        }
        let resp = await ajaxPostPromise("http://localhost:8500/rest/api/AFMSolr/search",searchData);
        console.log(resp)
        for await(const row of resp.QRESULT.DATA){
            ktypenr_array.push(row[13])
        }
        console.log(ktypenr_array)
    }
    resolve(ktypenr_array) ;
    })
}
async function getCategoriesArray(){
    return new Promise(async (resolve) => {
    const categories = await searchForCategories(categoryList);
    let genartnr_array = [];
    while(true){
        let category = await categories.next()
        if(category.done){
            break;
        }
        let searchData = {
            q:"",
            category:"",
            categoryTree:category.value,
            collection : "categories"
        }
        let resp = await ajaxPostPromise("http://localhost:8500/rest/api/AFMSolr/search",searchData);
        console.log(resp)
        for await(const row of resp.QRESULT.DATA){
            genartnr_array.push(row[13])
        }
        console.log(genartnr_array)
    }
    resolve(genartnr_array) ;
    })
}
function ajaxPostPromise(url, data) {
return new Promise(async (resolve) => {
    await $.ajax({
        headers: {
            'Content-Type': 'application/json',
        },
        url: url,
        data: JSON.stringify(data),
        type: "POST",
    }).done((resp) => {
        resolve(resp);
    })
})
}
async function* searchForVehicles(items){
        for(const item of items){
            yield item;
    }}
