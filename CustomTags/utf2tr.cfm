<CFSETTING ENABLECFOUTPUTONLY="YES"><cfprocessingdirective suppresswhitespace="Yes">
<!--- 
amaç :
verdiğiniz utf-8 string içeren değişken içeriğini türkçe karakterlere çevirir

parametre :
	var_name ==> değişkenin adı

kullanım :
<cf_utf2tr var_name="content_body">
 --->
<cfscript>
	turkish_list = "ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö";
	utf_list = "Ã¼,Ä,Ä±,Å,Ã§,Ã¶,Ã,Ä,Ä°,Å,Ã,Ã";
	"caller.#attributes.var_name#" = replacelist(evaluate("caller.#attributes.var_name#"),utf_list,turkish_list);
</cfscript>

</cfprocessingdirective><CFSETTING ENABLECFOUTPUTONLY="No">
