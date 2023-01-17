<cfif isDefined("attributes.is_submit") and len(attributes.is_submit) and attributes.is_submit eq 1>
    <cfquery name="del_gib" datasource="#dsn#"> 
        DELETE FROM SETUP_GIB
    </cfquery>
    <cfif isdefined("attributes.k_no")>
    <cfquery name="add_gib" datasource="#dsn#"> 
        INSERT INTO 
            SETUP_GIB
            (
                GIB_USERNAME,
                GIB_PASSWORD,
                RECORD_EMP,
                RECORD_DATE
            )
            VALUES 
            (
                <cfif isDefined("attributes.k_no") and len(attributes.k_no)>'#attributes.k_no#',</cfif>
                <cfif isDefined("attributes.k_sifre") and len(attributes.k_sifre)>'#attributes.k_sifre#',</cfif>
                #session.ep.userid#,
                #now()#
            )
    </cfquery>
    </cfif>
</cfif>
<cfparam name="attributes.k_no" default="">
<cfparam name="attributes.k_sifre" default="">
<cfquery name="get_gib" datasource="#dsn#">
    SELECT * FROM SETUP_GIB
</cfquery>
<cfif get_gib.recordCount>
    <cfset attributes.k_no = get_gib.GIB_USERNAME>
    <cfset attributes.k_sifre = get_gib.GIB_PASSWORD>
</cfif>
<cf_box title="Noterler birliği mükellef sorgulama erişim bilgileri">
    <cfform name="add_type" method="post">
            <input type="hidden" name="is_submit" value="1">
            <div class="ui-form-list ui-form-block">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <label>Kullanıcı Kimlik No</label>
                    <input type="text" name="k_no" id="k_no" value="<cfset writeOutput(attributes.k_no)>">
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <label>Şifre</label>
                    <input type="text" name="k_sifre" id="k_sifre" value="<cfset writeOutput(attributes.k_sifre)>">
                </div>
                
            </div>
        
            <div class="ui-form-list-btn">
                <div>
                    <input type="submit" value="<cf_get_lang_main no='52.Güncelle'>">	
                </div>
            </div>
        
    </cfform>
</cf_box>