<cfinclude template="./catalogs/designers/bestpracticedesigner/model.cfm">

<cfset attributes.mode = attributes.mode?: attributes.event />

<cfswitch expression="#attributes.mode#">

    <cfcase value="add,upd" delimiters=",">
        <cfinclude template="./catalogs/designers/bestpracticedesigner/form.cfm">
    </cfcase>

    <cfcase value="save">
        <cfinclude template="./catalogs/designers/bestpracticedesigner/save.cfm">
    </cfcase>

    <cfcase value="get">
        <cfinclude template="./catalogs/designers/bestpracticedesigner/get.cfm">
    </cfcase>

    <cfdefaultcase>
        <cfinclude template="./catalogs/designers/bestpracticedesigner/list.cfm">
    </cfdefaultcase>

</cfswitch>
