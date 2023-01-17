<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
	
	if(isdefined('attributes.form_submited'))
	{
		if(isdefined('attributes.ccno_key_1') and len(attributes.ccno_key_1) and !getCCNOKey1.recordcount)
			add_ccno_key = getCCNOKey.addCCNOKey(ccno_key1 : contentEncryptingandDecodingAES(isEncode:1,accountKey:session.ep.userid,content:attributes.ccno_key_1));
		else if(isdefined('attributes.ccno_key_2') and len(attributes.ccno_key_2) and !getCCNOKey2.recordcount)
			add_ccno_key = getCCNOKey.addCCNOKey(ccno_key2 : contentEncryptingandDecodingAES(isEncode:1,accountKey:session.ep.userid,content:attributes.ccno_key_2));
		
		location(url="#request.self#?fuseaction=settings.form_add_ccno_key");
	}
</cfscript>

<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
	<script language="javascript">
		alert('<cf_get_lang dictionary_id='64400.Kredi kartı şifreleme anahtar tanımları tamamlanmıştır. Bu sayfaya giriş izniniz bulunmamaktadır'> !');
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.security';
	</script>
    <cfabort>
</cfif>

<cf_box title="#getLang('','Kredi Kartı Şifreleme Anahtarı','43423')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_ccno_key" method="post" action="">
    	<input type="hidden" name="form_submited" value="1" />
       <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <cfif !getCCNOKey1.recordcount>
                    <div class="form-group" id="item-ccno_key_1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48918.Anahtar'> 1*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='64401.Anahtar Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="ccno_key_1" required="yes" message="#message#" maxlength="50" style="width:180px;">
                        </div>
                    </div>
                <cfelseif !getCCNOKey2.recordcount> 
                    <div class="form-group" id="item-ccno_key_2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48918.Anahtar'> 2*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='64401.Anahtar Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="ccno_key_2" required="yes" message="#message#" maxlength="50" style="width:180px;">
                        </div>
                    </div>
                </cfif>
            </div>
            </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' is_delete='0'>
        </cf_box_footer>
    </cfform>
</cf_box>

