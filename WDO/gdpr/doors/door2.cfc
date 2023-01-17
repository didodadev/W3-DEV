<!---
    File :          door.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          
    Description :   Rakamlar için şifreleme kapısı
    Notes :         
--->

<cfcomponent extends="WDO.gdpr.doors.door">

    <cffunction name="defaultvalue">
        <cfreturn "''">
    </cffunction>

    <cffunction name="decrypt">
        <cfargument name="data">
        <cfargument name="salt_value">

        <cfreturn "'" & super.decrypt(arguments.data, arguments.salt_value) & "'">
    </cffunction>

</cfcomponent>