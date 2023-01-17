<cf_get_lang_set module_name="settings">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ek Bilgi Aktarım','42821')#">
        <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_import_add_info">
            <cfif fusebox.use_period>
            <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                SELECT
                    PRODUCT_CATID,
                    PRODUCT_CAT,
                    HIERARCHY
                FROM
                    PRODUCT_CAT
                WHERE   
                    IS_SUB_PRODUCT_CAT = 0
                ORDER BY
                    HIERARCHY,
                    PRODUCT_CAT		
            </cfquery>
            </cfif>
            <cfinclude template="../query/get_info_plus_list.cfm"> 
            <cffunction name="get_p_work">
                <cfargument name="work_cat_id">
                <cfquery name="GET_P_CAT_" dbtype="query">
                    SELECT
                        WORK_CAT
                    FROM
                        get_work_cat
                    WHERE
                        WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_cat_id#">
                </cfquery>
                <cfreturn GET_P_CAT_.WORK_CAT>
            </cffunction>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" item="item-upload_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">  
                        </div>
                    </div>
                    <div class="form-group" item="item-add_info_pos">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42798.Ek Bilgi Kullanım yeri'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="add_info_pos" id="add_info_pos">
                                <cfoutput query="infoplus_names" >
                                    <option value="#ID#;#owner_type_id#">
                                        <cfswitch expression="#owner_type_id#">
                                            <cfcase value="-1"><cf_get_lang dictionary_id='49909.Kurumsal Üye'></cfcase>
                                            <cfcase value="-2"><cf_get_lang dictionary_id='57586.Bireysel Üye'></cfcase>
                                            <cfcase value="-3"><cf_get_lang dictionary_id='58612.Üye Şirket Çalışanı'></cfcase>
                                            <cfcase value="-4"><cf_get_lang dictionary_id='57576.Çalışan'></cfcase>
                                            <cfcase value="-5"><cf_get_lang dictionary_id='57657.Ürün'></cfcase>
                                            <cfcase value="-6"><cf_get_lang dictionary_id='37104.Ürün Ağacı'></cfcase>
                                            <cfcase value="-7"><cf_get_lang dictionary_id='58207.Satış Siparişleri'></cfcase>
                                            <cfcase value="-8"><cf_get_lang dictionary_id='57441.Fatura'></cfcase>
                                            <cfcase value="-9"><cf_get_lang dictionary_id='30007.Satış Teklifleri'></cfcase>
                                            <cfcase value="-10"><cf_get_lang dictionary_id='57416.Proje'></cfcase>
                                            <cfcase value="-11"><cf_get_lang dictionary_id='58832.Abone'></cfcase>
                                            <cfcase value="-12"><cf_get_lang dictionary_id='30008.Satınalma Siparişleri'></cfcase>
                                            <cfcase value="-13"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></cfcase>
                                            <cfcase value="-14"><cf_get_lang dictionary_id='39500.Alış İrsaliyeleri'></cfcase>
                                            <cfcase value="-15"><cf_get_lang dictionary_id='57656.Servis'></cfcase>
                                            <cfcase value="-16"><cf_get_lang dictionary_id='32447.Satış Fırsatlar'></cfcase>
                                            <cfcase value="-17"><cf_get_lang dictionary_id='59003.Masraf ve Gelir Fişleri'></cfcase>
                                            <cfcase value="-18"><cf_get_lang dictionary_id='58445.İş'></cfcase>
                                            <cfcase value="-19"><cf_get_lang dictionary_id='38893.IT Varlık'></cfcase>
                                            <cfcase value="-20"><cf_get_lang dictionary_id='57414.Araçlar'></cfcase>
                                            <cfcase value="-21"><cf_get_lang dictionary_id='29522.Sözleşme'></cfcase>
                                            <cfcase value="-22"><cf_get_lang dictionary_id='43214.Stok Fişleri'></cfcase>
                                            <cfcase value="-23"><cf_get_lang dictionary_id='29767.CV'></cfcase>
                                            <cfcase value="-24"><cf_get_lang dictionary_id='46917.Çağrı Merkezi'>-<cf_get_lang dictionary_id='58186.Başvurular'></cfcase>
                                            <cfcase value="-25"><cf_get_lang dictionary_id='46917.Çağrı Merkezi'>-<cf_get_lang dictionary_id='49270.Etkileşim'></cfcase>
                                            <cfcase value="-27"><cf_get_lang dictionary_id='58689.Teminat'></cfcase>
                                            <cfcase value="-28"><cf_get_lang dictionary_id="49752.Satınalma Talebi"></cfcase>
                                            <cfcase value="-29"><cf_get_lang dictionary_id="30782.İç Talepler"></cfcase>
                                            <cfcase value="-30"><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></cfcase>
                                            <cfcase value="-31"><cf_get_lang dictionary_id="39502.Satış İrsaliyeleri"></cfcase>
						                    <cfcase value="-32"><cf_get_lang dictionary_id='50921.Satış Faturaları'></cfcase>
                                        </cfswitch>
                                        <cfif listlen(infoplus_names.multi_product_catid) and owner_type_id eq -5>
                                        (
                                            <cfloop>
                                            <cf_get_lang dictionary_id='44126.Şablon ID'> : #ID#
                                            </cfloop>
                                        )
                                        </cfif>
                                        <cfif listlen(infoplus_names.multi_sub_catid) and owner_type_id eq -11>
                                            (
                                            <cfloop>

                                                <cf_get_lang dictionary_id='44126.Şablon ID'> : #ID#
                                                </cfloop>
                                            )
                                        </cfif>
                                        <cfif listlen(infoplus_names.multi_work_catid) and owner_type_id eq -18>
                                            (
                                            <cfloop>
                                                <cf_get_lang dictionary_id='44126.Şablon ID'> : #ID#
                                            </cfloop>
                                            )
                                        </cfif>
                                        <cfif listlen(infoplus_names.OWNER_TYPE_ID) and owner_type_id eq -21>
                                            (
                                            <cfloop>
                                                <cf_get_lang dictionary_id='44126.Şablon ID'> : #ID#
                                            </cfloop>
                                            )
                                        </cfif>
                                        <cfif listlen(infoplus_names.sales_add_option) and sales_add_option eq -21>
                                            (
                                            <cfloop>
                                                <cf_get_lang dictionary_id='44126.Şablon ID'> : #ID#
                                            </cfloop>
                                            )
                                        </cfif>
                                    </option> 
                                 </cfoutput>
                            </select> 
                        </div>                    
                    </div>
                    <div class="form-group" item="item-is_update">
                        <input type="checkbox" name="is_update" id="is_update"><cf_get_lang dictionary_id='44134.Eski Kayıtlar Update Edilsin mi?'>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>                    
                    </div>
                    <div class="form-group" id="item-exp1">
                        <ul style="list-style:none; padding:0;">
                            <li><cf_get_lang dictionary_id='44135.İmport İşlemi 2. Satırdan İtibaren Başlar'></li>
                            <li><cf_get_lang dictionary_id='44141.Bir Adet Sayısal ID Alanı'></li>
                            <li><cf_get_lang dictionary_id='44417.20 Adet Açıklama Alanı'></li>
                            <li><cf_get_lang dictionary_id='44429.Dosya Uzantısı csv Olmalı'></li>
                            <li><cf_get_lang dictionary_id='44486.Alanlar Noktalı Virgül ile Ayrılmalı'></li>
                            <li><cf_get_lang dictionary_id='44487.Aktarım işlemi dosyanın ilk satırından itibaren başlar'></li>
                            <li><cf_get_lang dictionary_id='44494.Boş Bırakılan Alanlar Güncellemelerde Dikkate Alınmaz'></li>
                            <li><cf_get_lang dictionary_id='44569.Alan içeriklerinde noktalı virgül (;) olmamalı'></li>
                        </ul>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div> 
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
