<CFCOMPONENT 
  HINT="Provides data about merchandise records.">
  
  <!--- GetMerchList() function --->
  <CFFUNCTION
    NAME="get_for_flash"
    HINT="Returns a recordset of all products in the Merchandise table."
    RETURNTYPE="query"
    ACCESS="Remote">

    <!--- Query the database for merchandise records --->
    <CFQUERY NAME="getting_for_flash" DATASOURCE="#dsn#">
      SELECT * FROM CONTENT WHERE CONTENT_ID = 175
    </CFQUERY>

    <!--- Return the query --->
    <CFRETURN getting_for_flash>
  </CFFUNCTION>
</cfcomponent>
