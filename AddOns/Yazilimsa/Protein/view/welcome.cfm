<!---
    File :          AddOns\Yazilimsa\Protein\view\welcome.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          28.08.2020
    Description :   Protein menüsü 
--->
<style>
    body{background:url(/AddOns/Yazilimsa/Protein/src/assets/img/protein_bg.png)}
    .flex{
        display:flex;
        flex-wrap: wrap;
        justify-content:center;
    }
    .flex span, .flex a{
        display:flex;
        justify-content:center;
        color:#463a3a;
    }
    .box_link {
    background-color:transparent;
    border-radius: 5px;
    transition:.4s;
    height: 125px;
    margin: 10px;
    position: relative;
    flex-direction:column;
    width: 150px;
    cursor:pointer;
    
    }
    .box_link:hover{
        background-color:#fff;color:#FF9800;box-shadow:0 0 5px rgba(174,174,174,.25);transition:.4s;
    }

</style>
<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfset pageHead = "#pageHead# - #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div class="row"> 
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="flex">
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=add</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0224 fa-2x" title="Yeni Site Oluştur"></i></div>
                    <div class="searchText">Yeni Site Oluştur</div>
                </div>
            </a>
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=upd&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0026 fa-2x" title="Genel Tanımlar"></i></div>
                    <div class="searchText">Genel Tanımlar</div>
                </div>
            </a>
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=add_step_two&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0184 fa-2x" title="Bölgesel Tanımlar"></i></div>
                    <div class="searchText">Bölgesel Tanımlar</div>
                </div>
            </a>
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=add_step_three&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0102 fa-2x" title="Erişim Ayarları"></i></div>
                    <div class="searchText">Erişim Ayarları</div>
                </div>
            </a>
        </div>
        <div class="flex">
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=add_step_four&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0216 fa-2x" title="Tema"></i></div>
                    <div class="searchText">Tema</div>
                </div>
            </a>
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=list_template&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0006 fa-2x" title="Şablon Tanımları"></i></div>
                    <div class="searchText">Şablon Tanımları</div>
                </div>
            </a>
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=list_page&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0138 fa-2x" title="Sayfa Tanımları"></i></div>
                    <div class="searchText">Sayfa Tanımları</div>
                </div>
            </a>
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=list_menu&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0056 fa-2x" title="Menü Tanımları"></i></div>
                    <div class="searchText">Menü Tanmıları</div>
                </div>
            </a>
        </div>
        <div class="flex">
            <a class="col col-2 col-md-2 col-sm-2 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=protein.core&event=list_widget&id=#attributes.id#</cfoutput>">
                <div class="box_link flex">
                    <div class="searchText"><i class="wrk-uF0084 fa-2x" title="Widget Tanımları"></i></div>
                    <div class="searchText">Widget Tanımları</div>
                </div>
            </a>
        </div>        
    </div>
</div>