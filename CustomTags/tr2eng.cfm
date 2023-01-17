<CFSETTING enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!--- 
amaç :
verdiğiniz utf2tr tarafında çevrilmiş türkçe string içeren değişkenin içeriğini ingilizce karakterlere çevirir

parametre :
	var_name ==> değişkenin adı

kullanım :
<cf_tr2eng var_name="content_body">
 --->
<cfscript>
	turkish_list = "u,g,i,s,c,o,U,G,I,S,C,O,";
	utf_list = "ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö, ";
	"caller.#attributes.var_name#" = replacelist(evaluate("caller.#attributes.var_name#"),utf_list,turkish_list);
</cfscript>

</cfprocessingdirective><cfsetting enablecfoutputonly="no">
