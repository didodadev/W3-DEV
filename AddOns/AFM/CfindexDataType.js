data = {
    result: [], // Mongodan gelecek datalar eklenecek. Örnek {Bez: item["Bez"],KTypeNr: item["KTypeNr"]} 
    columns: "PartNumber,PartDescription,Image,BrandName,BrandId,TecDocId,SearchKey,OemNo,StockCode,IsStock", //Warehouse,DescriptionList,ManufacturerList,EngineCodeList,AlternativeList,ManufacturerModel (Tamamı Liste şeklinde, aktarım araştırılacak) 
    columnTypes: "Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Integer,Varchar,Varchar,Varchar,Boolean", //Array,Array,Array,Array,Array,Array,Array
    collectionName: "AosDoc", //Hangi koleksiyon ismi kullanılacaksa o yazılacak.
    categoryTree: "GlobalB2BProductSearchV1", //Verilerin bulunacağı ana kategori ismi
    category: "", //Verilerin bulunacağı alt kategori ismi - Araç markası kullanılabilir
    key: "PartNumber" //Primary Key
}

