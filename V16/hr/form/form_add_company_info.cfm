<cfquery name="check" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME, 
        NICK_NAME, 
        TAX_OFFICE, 
        TAX_NO, 
        TEL_CODE, 
        TEL, 
        FAX, 
        MANAGER, 
        MANAGER_POSITION_CODE, 
        MANAGER_POSITION_CODE2, 
        WEB, 
        EMAIL, 
        ADDRESS, 
        ADMIN_MAIL, 
        TEL2, 
        TEL3, 
        TEL4, 
        FAX2, 
        T_NO, 
        SERMAYE, 
        CHAMBER, 
        CHAMBER_NO, 
        CHAMBER2, 
        CHAMBER2_NO, 
        ASSET_FILE_NAME1, 
        ASSET_FILE_NAME1_SERVER_ID, 
        ASSET_FILE_NAME2, 
        ASSET_FILE_NAME2_SERVER_ID, 
        ASSET_FILE_NAME3, 
        ASSET_FILE_NAME3_SERVER_ID, 
        IS_ORGANIZATION 
    FROM 
	    OUR_COMPANY 
    WHERE 
    	COMP_ID=#attributes.COMP_ID#<!--- #session.ep.company_id# --->
</cfquery>
<cf_box title="#getLang('','Şirket Çalışma Bilgileri',55194)#">
    <cfoutput>
        <div class="col col-4 col-xs-12">
            <cf_seperator id="gemel_bilgiler_" header="#getLang('','Genel Bilgiler',57980)#" is_closed="0">
            <cf_box_elements id="gemel_bilgiler_">
                <div class="col col-12 col-xs-12">
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57631.ad'></label>
                        </div> 
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            : #check.company_name#
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55914.Kısa Ünvanı'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.nick_name#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='29511.Yönetici'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.manager#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.tax_office#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.tax_no#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55916.Oda'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.chamber#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55917.Oda Sicil No'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.chamber_no#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55916.Oda'> 2</label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.chamber2#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55917.Oda Sicil No'> 2</label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.chamber2_no#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='58410.Sermaye'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.SERMAYE#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55918.Ticaret Sicil No'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.T_NO#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55919.Sistem Yönetici EMailleri'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.admin_mail#</div>
                    </div>
                </div>
            </cf_box_elements>
        </div>
        <div class="col col-4 col-xs-12">
            <cf_seperator id="iletisim_" header="#getLang('main','İletişim',58143)#" is_closed="0">
            <cf_box_elements id="iletisim_">
                <div class="col col-12 col-xs-12">
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55920.Telefon Kodu'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.tel_code#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.tel#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.TEL2#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.TEL3#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'> 4</label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.TEL4#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57488.Faks'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.fax#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57488.Faks'> 2</label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.fax2#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='57428.E-mail'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.email#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='55435.İnternet'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.web#</div>
                    </div>
                    <div class="form-group">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <label class="txtbold"><cf_get_lang dictionary_id='58723.Adres'></label>
                        </div>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">: #check.address#</div>
                    </div>
                </div>
            </cf_box_elements>
        </div>
        <div class="col col-4 col-xs-12">
            <cf_seperator header="#getLang('','Logolar',55921)#" id="logolar_" is_closed="0">
            <cf_box_elements id="logolar_">
                <div class="col col-12 col-xs-12">
                    <cfif len(check.asset_file_name1)>
                        <div class="form-group">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label class="txtbold"><cf_get_lang dictionary_id='55922.Büyük Logo'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_get_server_file output_file="settings/#check.asset_file_name1#" output_server="#check.asset_file_name1_server_id#" output_type="0"  image_link="1">
                            </div>
                        </div>
                    </cfif>
                    <cfif len(check.asset_file_name2)>
                        <div class="form-group">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label class="txtbold"><cf_get_lang dictionary_id='55923.Orta Logo'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_get_server_file output_file="settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="0" image_link="1">
                            </div>
                        </div>
                    </cfif>
                    <cfif len(check.asset_file_name3)>
                        <div class="form-group">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label class="txtbold"><cf_get_lang dictionary_id='55924.Küçük Logo'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_get_server_file output_file="settings/#check.asset_file_name3#" output_server="#check.asset_file_name3_server_id#" output_type="0"  image_link="1">
                            </div>
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>
        </div>
    </cfoutput>
</cf_box>
