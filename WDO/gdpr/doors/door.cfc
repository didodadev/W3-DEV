<!---
    File :          Door1.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          
    Description :   AES şifreleme
    Notes :         
--->
<cfcomponent>

    <cfset cryption_method = "AES/CBC/PKCS5Padding">
    <cfset result_format = "hex">
    <cfset padder = "_">

    <cffunction name="encrypt" access="public">
        <cfargument name="data">
        <cfargument name="salt_value">
    
        <cfscript>
            try {
                key = generate_aes_key(arguments.salt_value);
                result = encrypt( arguments.data, key, cryption_method, result_format );
            } catch (any e) {
                writeDump(e);abort;
                throw("Encription işleminde hata!");
            } 
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="decrypt" access="public">
        <cfargument name="data">
        <cfargument name="salt_value">
        <cfif len(arguments.data)> 
            <cfscript>
                try {
                    key = generate_aes_key(arguments.salt_value);
                    result = decrypt( arguments.data, key, cryption_method, result_format );
                } catch (any e) {
                    writeDump(e);abort;
                    throw("Decryption işleminde hata!");
                }
            </cfscript>
        <cfelse>
            <cfset result = "0">
        </cfif>
        <cfreturn result>
    </cffunction>

    <cffunction name="generate_aes_key">
        <cfargument name="salt_value">
        <cfset arguments.salt_value = pad_right(arguments.salt_value, 16)>
        <cfscript>
            try {
                hashed = binaryDecode(hash(arguments.salt_value, "sha"), "hex");
                trunc = arrayNew(1);
                for (i = 1; i <= 16; i++) {
                    trunc[i] = hashed[i];
                }
                result = binaryEncode(javaCast("byte[]", trunc), "Base64");
            } catch (any e) {
                throw("Salt oluşturulamadı!");
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="pad_right">
        <cfargument name="data">
        <cfargument name="length">

        <cfreturn data & repeatString(padder, length - len(data))>
    </cffunction>

</cfcomponent>