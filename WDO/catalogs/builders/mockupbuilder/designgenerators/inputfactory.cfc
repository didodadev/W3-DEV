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
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.textarea").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="hidden input">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.hidden").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="select">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.select").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="multi select">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.multiselect").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="radio button">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.radio").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="checkbox">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.checkbox").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="image">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.image").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="upload file">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.upload").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="text">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.text").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="custom tag">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.customtag").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="process cat">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.processcat").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="workflow">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.workflow").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfcase value="paper no">
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.paperno").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfcase>
            <cfdefaultcase>
                <cfreturn createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.#group#.textinput").init(arguments.data, arguments.domain, arguments.eventtype, arguments.ident, arguments.preattr, arguments.index, arguments.group, arguments.hasoutputtag)>
            </cfdefaultcase>
        </cfswitch>
    </cffunction>
</cfcomponent>