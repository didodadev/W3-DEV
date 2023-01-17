var webadress = "http://31.169.71.253:38764/api/test";
var categoryAddress = "http://31.169.71.253:38764/api/category";
var vehiclesAddress = "http://31.169.71.253:38764/api/vehicles";

var lang = 23
class SolrIndex {
    constructor() {

    }
    async IndexManufacturers() {
        await $.ajax({
            url : "https://devcatalyst.workcube.com/rest/api/AFMSolr/createCollection",
            type: "POST",
            data: JSON.stringify({collectionName:"AFM_Integration_Brands"}),
            success: function(resp){
                console.log(resp);
            }
        }).done(()=>{
                      
        });
        await $.ajax({
            url: vehiclesAddress + "/getmanufacturers?sprachnr=" + lang,
        }).done(async function (resp) {
            let i = 0;
            const msgen = ModelSeriesAsyncGenerator(resp);
            while (true) {
                let msgres = await msgen.next()
                if (msgres.done) {
                    break;
                }
                const modelsgen = ModelsAsyncGenerator(msgres.value);
                let j = 0;
                while (true) {
                    let mgres = await modelsgen.next()
                    if (mgres.done) {
                        break;
                    }
                    let data = {
                        result: [],
                        columns: "KTypeNr,Bez",
                        columnTypes: "Integer,Varchar",
                        collectionName: "AFM_Integration_Brands",
                        categoryTree: resp[i]["Bez"],
                        category: msgres.value[j]["Bez"],
                        key: "KTypeNr"
                    };
                    for await (const item of mgres.value) {
                        data.result.push({
                            Bez: item["Bez"],
                            KTypeNr: item["KTypeNr"]
                        })
                    }
                    console.log(await ajaxPostPromise("https://devcatalyst.workcube.com/rest/api/AFMSolr/createIndex", data))
                    j += 1;

                }
                i +=1;
            }
        });
    }
    async IndexCategories() {
        await $.ajax({
            url : "https://devcatalyst.workcube.com/rest/api/AFMSolr/createCollection",
            type: "POST",
            data: JSON.stringify({collectionName:"AFM_Integration_Categories"}),
            success: function(resp){
                console.log(resp);
            }
        }).done(()=>{
            await $.ajax({
                url: categoryAddress + "/getmaincategories?sprachnr=" + 23,
            }).done(async (resp) => {
                let subCategories = await SubCategoryGenerator(resp);
                let i = 0;
                while (true) {
                    let subCategory = await subCategories.next();
                    if (subCategory.done)
                        break;
                    const products = await ProductsGenerator(subCategory.value);
                    let j=0;
                    while (true) {
                        let product = await products.next();
                        if (product.done)
                            break;
                        let data = {
                            result: [],
                            columns: "value,desc",
                            columnTypes: "Integer,Varchar",
                            collectionName: "AFM_Integration_Categories",
                            categoryTree: resp[i]["desc"],
                            category: subCategory.value[j]["desc"],
                            key: "value"
                        }
                        for await (const item of product.value) {
                            data.result.push({
                                desc: item["desc"],
                                value: item["value"]
                            })
                        }
                        console.log(await ajaxPostPromise("https://devcatalyst.workcube.com/rest/api/AFMSolr/createIndex", data))
                        j+=1;
                    }
                    i+=1;
                }
            })
        })
        
    }

    async StartIndex() {
        await this.GetManufacturers(this.manufacturerArray);
        /*         this.manufacturerArray.forEach(async element => {
                    await this.GetModelSeries(this.modelseriesArray,element["LBezNr"]);
                }) */
    }
}
async function* ModelSeriesAsyncGenerator(ml) {
    for (const items of ml) {
        yield await ajaxPromise(vehiclesAddress + "/getmodelseries?hernr=" + items["HerNr"] + "&sprachnr=23");
    }
}
async function* ModelsAsyncGenerator(ml) {
    for (const items of ml) {
        yield await ajaxPromise(vehiclesAddress + "/getmodels?kmodnr=" + items["KModNr"] + "&sprachnr=23");
    }
}
async function* SubCategoryGenerator(ml) {
    for (const items of ml) {
        yield await ajaxPromise(categoryAddress + "/getsubcategories?node_parent_id=" + items["value"] + "&sprachnr=23");
    }
}
async function* ProductsGenerator(ml) {
    for (const items of ml) {
        yield await ajaxPromise(categoryAddress + "/getproducts?node_id=" + items["value"] + "&sprachnr=23");
    }
}

function ajaxPromise(url) {
    return new Promise(async (resolve) => {
        await $.ajax({
            url: url
        }).done((resp) => {
            resolve(resp);
        })
    })
}

function ajaxPostPromise(url, data) {
    return new Promise(async (resolve) => {
        await $.ajax({
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            url: url,
            data: JSON.stringify(data),
            type: "POST",
        }).done((resp) => {
            resolve(resp);
        })
    })
}