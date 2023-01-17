<!---
    File :          inputfactory.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2018
    Description :   Input ve diğer girdi alanlarını oluşturacak bileşeni üretir.
    Notes :         Bu bileşen kod üretmez! Kod üreticiyi oluşturup geri döndürür.
--->
<cfcomponent>
    <cffunction name="create" access="public" returntype="any">
        <cfargument name="type" type="string">
        <cfargument name="data" type="any">
        <cfargument name="domain" type="any">
        <cfargument name="eventtype" type="string">
        <cfargument name="ident" type="numeric" default="1">
        <cfargument name="preattr" type="any" default="#[]#">
        <cfargument name="index" type="any" default="">
        <cfargument name="group" type="string" default="formelements">
        <cfargument name="hasoutputtag" type="numeric" default="1">
        <cfswitch expression="#arguments.type#">
            <cfcase value="textarea">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.textareawidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="hidden input">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.hiddenwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="select">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.selectwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="multi select">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.multiselectwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="radio button">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.radiowidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="checkbox">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.checkboxwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="image">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.imagewidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="upload file">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.uploadwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="text">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.textwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="custom tag">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.customtagwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="process cat">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.processcatwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="workflow">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.workflowwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="paper no">
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.papernowidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfdefaultcase>
                <cfreturn createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.#group#.textinputwidget").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfdefaultcase>
        </cfswitch>
    </cffunction>
</cfcomponent>