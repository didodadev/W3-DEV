<cf_form_box title="#getLang('forum',4)#">
  <cfform name="add_topic" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_add_topic">
    <div class="w3-forum-form">
        <div class="row">   
            <div class="container formContent">
                <div class="row">
                    <div class="col col-5 col-md-8 col-xs-12">
                    
                                <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                        <cf_get_lang no='65.Forum Adı'>*
                                    </label>
                                    <div class="col col-9 col-xs-12">
                                            <cfinclude template="../query/get_forums.cfm">
                                            <select name="forumid" id="forumid" style="width:583px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="forums">
                                                    <option value="#FORUMID#" <cfif FORUMID eq attributes.forumid>selected</cfif>>#FORUMNAME#</option>
                                                </cfoutput>
                                            </select>
                                    </div>
                                </div>

                                 <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                        <cf_get_lang_main no='68.Başlık'>*
                                    </label>
                                    <div class="col col-9 col-xs-12">
                                           <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='68.Başlık'></cfsavecontent>
                                            <cfinput type="Text" name="title" style="width:583px;" required="yes" message="#message#" maxlength="150">
                                    </div>
                                </div>

                                 <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                       
                                    </label>
                                    <div class="col col-9 col-xs-12">
                                           <cfmodule
                                                template="/fckeditor/fckeditor.cfm"
                                                toolbarSet="WRKContent"
                                                basePath="/fckeditor/"
                                                instanceName="topic"
                                                valign="top"
                                                value=""
                                                width="100%"
                                                height="325">
                                    </div>
                                </div>

                                <div class="form-group">
                                  
                                    <div class="col col-12">
                                    <div class="col col-3 col-xs-12">
                                        <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>"><cf_get_lang no='56.Cevapları Mail Gönder'>
                                    </div>
                                     <div class="col col-3 col-xs-12">
                                         <input type="Checkbox" name="locked" id="locked" value="1"><cf_get_lang no='66.Yeni Cevap Kapalı'>
                                    </div>
                                     <div class="col col-2 col-xs-12">
                                     <input type="checkbox" name="topic_status" id="topic_status" value="1" checked><cf_get_lang_main no='81.Aktif'>
                                    </div>
                                     <div class="col col-4 col-xs-12">
                                    <input type="checkbox" name="email" id="email" value="1"><cf_get_lang no='71.Forum Yöneticisine Mail Gönder'>
                                    </div>
                                        
                                            
                                    </div>
                                </div>


                                 <div class="form-group">
                                    <label  class="col col-3 col-xs-12">
                                       <cf_get_lang_main no='103.Dosya Ekle'>
                                    </label>
                                    <div class="col col-9 col-xs-12 input-group">
                                         <input type="file" name="attach_topic_file" id="attach_topic_file">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col col-12">
                                        	<cf_form_box_footer><cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'></cf_form_box_footer>
                                    </div>
                                </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
  </cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_topic.forumid.value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='65.Forum Adı'>");
			return false;
		}
	}
</script>
