<!---
    File: del_contract_assetp.cfm
    Folder: assetcare\query
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2019-11-19 21:30:13 
    Description:
        Anlaşmalar modülü sözleşme ile bağlantılı fiziki varlık bağlantısını silmek için kullanılır
    History:
        
    To Do:

--->
<cfquery datasource="#dsn#">
	DELETE FROM RELATION_PHYSICAL_ASSET_CONTRACT WHERE RELATION_ID = #attributes.relation_id#
</cfquery>
<cflocation url="#CGI.REFERER#" addtoken="no" />