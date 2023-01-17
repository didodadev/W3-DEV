<cfinclude template="./catalogs/designers/themes/model.cfm">

<cfset attributes.mode = attributes.mode?: attributes.event />

<cfswitch expression="#attributes.mode#">

    <cfcase value="add,upd" delimiters=",">
        <cfinclude template="./catalogs/designers/themes/form.cfm">
    </cfcase>

    <cfcase value="save">
        <cfinclude template="./catalogs/designers/themes/save.cfm">
    </cfcase>

    <cfcase value="get">
        <cfinclude template="./catalogs/designers/themes/get.cfm">
    </cfcase>

    <cfdefaultcase>
        <cfinclude template="./catalogs/designers/themes/list.cfm">
    </cfdefaultcase>

</cfswitch>
