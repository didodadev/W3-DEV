<!---
Description :
   returns a string encrypted (hash:geri donusu yok!)

Parameters :
	password ==> Password Text Entry
	output   ==> Output Text Exit  

Syntax :
   <cf_CryptedPassword password="Password_text" output = "Output_Text">
--->
<cfscript>
	temp = "#attributes.password#";
	cryptedPassword = hash(temp, "SHA-256", "UTF-8");
	"caller.#attributes.output#" = "#cryptedPassword#";
</cfscript>
