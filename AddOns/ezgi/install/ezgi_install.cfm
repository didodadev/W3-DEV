<!---
    File: ezgi_install.cfm
    Folder: AddOns\ezgi\install
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2019-10-18 22:34:42 
    Description:
        E-Furniture sektörel çözümün kurulumu için kullanılır
        Hata oluştuğunda tüm işlemleri rollback yapar 
    History:
        
    To Do:

--->

<cfquery name="get_company" datasource="#dsn#">
    SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMP_ID
</cfquery>

<div>
    <div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze">
        <span class="pageCaption font-green-sharp bold">E-Furniture Kurulum İşlemi</span>
        <div id="pageTab" class="pull-right text-right">
            <nav class="detailHeadButton" id="tabMenu"></nav>
        </div>
    </div>
</div>

<cfform action="#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#" method="post">
    <input type="hidden" name="form_submit" value="1" />
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label class="col col-12 col-md-12 col-xs-12">Kurulum Yapılmak İstenen Şirket</label>
                            <div class="col col-12 col-md-12 col-xs-12">
                                <select name="company_id" id="company_id" style="width:100px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_company">
                                    <option value="#COMP_ID#">#COMP_ID# - #COMPANY_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>	
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <input type="submit" value="Kurulumu Başlat">	
                </div>
            </div>
        </div>
    </div>
</cfform>

<cfif isDefined("attributes.form_submit") And isDefined("attributes.company_id") And Len(attributes.company_id)>
    <cfset attributes.main_db       = dsn />
    <cfset attributes.company_db    = attributes.main_db & '_' & attributes.company_id />
    <cflock name="#createUUID()#" timeout="600">
        <cftransaction>
            <cftry>
                <cfset acilis_ = '<cfquery datasource="#attributes.main_db#">'>
                <cfset kapanis_ = '</cfquery>'>

                <cfsavecontent variable="db_tables_icerik"><cfoutput>#acilis_#</cfoutput><cfinclude template="..#dir_seperator#..#dir_seperator#AddOns#dir_seperator#ezgi#dir_seperator#install#dir_seperator#db_tables.txt" /><cfoutput>#kapanis_#</cfoutput></cfsavecontent>
                <cfset db_tables_icerik = replace(db_tables_icerik,'@main_db@','#attributes.main_db#','all') />
                <cfset db_tables_icerik = replace(db_tables_icerik,'@company_db@','#attributes.company_db#','all') />
                <cfset db_tables_icerik = replace(db_tables_icerik,'@company_id@','#attributes.company_id#','all') />
                <cfset db_tables_icerik = replace(db_tables_icerik,'@period_db@','#attributes.main_db#_#year(Now())#_#attributes.company_id#','all') />
                <cfset db_tables_icerik = replace(db_tables_icerik,'@product_db@','#attributes.main_db#_product','all') />
                <cffile action="write" output="#db_tables_icerik#" addnewline="yes" file="#upload_folder#db_tables.cfm" charset="utf-8" />
                <cfinclude template="../db_tables.cfm" />
                <cffile action="delete" file="#upload_folder#db_tables.cfm" charset="utf-8" />
                
                <cfsavecontent variable="db_views_icerik"><cfoutput>#acilis_#</cfoutput><cfinclude template="..#dir_seperator#..#dir_seperator#AddOns#dir_seperator#ezgi#dir_seperator#install#dir_seperator#db_views.txt" /><cfoutput>#kapanis_#</cfoutput></cfsavecontent>
                <cfset db_views_icerik = replace(db_views_icerik,'@main_db@','#attributes.main_db#','all') />
                <cfset db_views_icerik = replace(db_views_icerik,'@company_db@','#attributes.company_db#','all') />
                <cfset db_views_icerik = replace(db_views_icerik,'@company_id@','#attributes.company_id#','all') />
                <cfset db_views_icerik = replace(db_views_icerik,'@period_db@','#attributes.main_db#_#year(Now())#_#attributes.company_id#','all') />
                <cfset db_views_icerik = replace(db_views_icerik,'@product_db@','#attributes.main_db#_product','all') />
                <cffile action="write" output="#db_views_icerik#" addnewline="yes" file="#upload_folder#db_views.cfm" charset="utf-8" />
                <cfinclude template="../db_views.cfm" />
                <cffile action="delete" file="#upload_folder#db_views.cfm" charset="utf-8" />

                <cfsavecontent variable="db_views2_icerik"><cfinclude template="..#dir_seperator#..#dir_seperator#AddOns#dir_seperator#ezgi#dir_seperator#install#dir_seperator#db_views2.txt" /></cfsavecontent>
                <cfset db_views2_icerik = replace(db_views2_icerik,'@main_db@','#attributes.main_db#','all') />
                <cfset db_views2_icerik = replace(db_views2_icerik,'@company_db@','#attributes.company_db#','all') />
                <cfset db_views2_icerik = replace(db_views2_icerik,'@company_id@','#attributes.company_id#','all') />
                <cfset db_views2_icerik = replace(db_views2_icerik,'@period_db@','#attributes.main_db#_#year(Now())#_#attributes.company_id#','all') />
                <cfset db_views2_icerik = replace(db_views2_icerik,'@product_db@','#attributes.main_db#_product','all') />
                <cfset db_views2_icerik = replace(db_views2_icerik,'IF OBJECT_ID','#kapanis_##acilis_#IF OBJECT_ID','all') />
                <cfset db_views2_icerik = replace(db_views2_icerik,'#kapanis_#','','one') />
                <cfset db_views2_icerik = db_views2_icerik & kapanis_ />
                <cffile action="write" output="#db_views2_icerik#" addnewline="yes" file="#upload_folder#db_views2.cfm" charset="utf-8" />
                <cfinclude template="../db_views2.cfm" />
                <cffile action="delete" file="#upload_folder#db_views2.cfm" charset="utf-8" />

                <cftransaction action="commit" />
            <cfcatch type="any">
                <cftransaction action="rollback" />
                <cfdump var="#cfcatch#" />
            </cfcatch>
            </cftry>
        </cftransaction>
    </cflock>
</cfif>