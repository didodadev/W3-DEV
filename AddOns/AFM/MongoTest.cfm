<cfset isSearch=false>
<cfset isRecreateCollection = false>
<cfset isAlternativeInsert = false>
<cfset isInsertBrands = false>

<!--- <cfscript>
    searchKey = "GL-71-3442/5 0,25"
    searchData = {
        q:"title:#replace(replace(searchKey,'-',''),'.','')#",
        category:"Parts",
        categoryTree:"Bases",
        collection : "GlobalB2BProductSearchV1",
        maxRows : 20
    }
    searchData2 = {
        q:"contentsExact:#searchKey#",
        category:"Parts",
        categoryTree:"Bases",
        collection : "GlobalB2BProductSearchV1",
        maxRows : 20
    }
</cfscript>

<!--- <cfset response = deserializeJSON(SerializeJSON(data.result))> 
<cfset queryVar=queryNew(data.columns,data.columnTypes,response)> <!--- [{},{}] ---><!--- "Id,Adı,Soyadı" ---><!--- "Integer,Varchar" --->
<cfindex collection=#data.collectionName# action="update" query="queryVar" key=#data.key# body=#data.columns# status="status" category=#data.category# categoryTree=#data.categoryTree#>
<cfreturn status> --->
<cfif isSearch>
    <cfset afmSearch = CreateObject("component","cfc.AfmSearch")>
<cfset GlobalB2BProductSearchV1 = application.mongo.getDBCollection( "GlobalB2BProductSearchV1" )>
    <cfset BrandList = GlobalB2BProductSearchV1.aggregate({"$group": {"_id":{"BrandName": '$BrandName',"BrandId": '$BrandId'}}},{"$sort" : {"_id.BrandId": 1}}).asArray()>
    <cfloop array="#BrandList#" index="i" item="BrandData">
        <cfdump var="#BrandData._id["BrandName"]#"> 

    </cfloop>
<!---     <cfset PRODUCT_CODE = "GL-71-3442/5 0,25">
 --->    <!--- <cfset Alternatives = afmSearch.SearchByKeywordSolr('"#PRODUCT_CODE#"',"GlobalB2BProductSearchV1")> --->

<!---     <cfset Alternatives = afmSearch.SearchByKeywordSolr('""',"GlobalB2BProductSearchV1",50)>
 --->    <!--- <cfset Alternatives = queryFilter(Alternatives,function(alternative){return alternative.title != "GL-71-3442/50,25"})> --->

<!---      <cfset SearchResult = afmSearch.GetAfmProducts(searchKey,10)>
 --->    <!--- <cfset SearchResult2 = afmSearch.SearchSolr(searchData)>     --->

<!---     <cfdump var="#SearchResult2#">
 ---></cfif>
<cfif not isSearch>
    <cfset afmSearch = CreateObject("component","cfc.AfmSearch")>
<cfset GlobalB2BProductSearchV1 = application.mongo.getDBCollection( "GlobalB2BProductSearchV1" )>
    <cfif isRecreateCollection>
        <cfoutput>#afmSearch.RecreateCollection("GlobalB2BProductSearchV1")#</cfoutput>
    </cfif>        
    <cfoutput>#afmSearch.RecreateSolrDatas(1291349)#</cfoutput>
    <cfif isAlternativeInsert>
        <cfoutput>#afmSearch.InsertAlternatives()#</cfoutput>
    </cfif>
    <cfif isInsertBrands>
        <cfoutput>#afmSearch.InsertBrands()#</cfoutput>
    </cfif>
</cfif> --->
