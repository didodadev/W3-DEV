<!---
	9-)YapıKredi,
	11-)Türkiye finans, 
	12-)bankasya (dll Format)
--->
<cfscript>
	abort("Geçerli Pos Tipiniz Yoktur! Tahsilat İşlemi Yapılamaz");
</cfscript>
<cffunction name="get_approved_info">
	<cfhttp method="post" url="#post_adress#" timeout="60" charset="utf-8">
		<cfhttpparam name="data" type="formfield" value="#my_doc#">
	</cfhttp>
</cffunction>