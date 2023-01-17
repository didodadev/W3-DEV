<cfparam name="attributes.pid" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.contentId" default="">
<cfparam name="attributes.class_id" default="">
<cfparam name="attributes.train_id" default="">
<cfparam name="attributes.train_group_id" default="">
<cfparam name="attributes.procut_sample_id" default="">

<cfset file_web_path = "#file_web_path#">
<cfset getComponent = createObject('component','cfc.wrk_images')>
<cfif isDefined("attributes.pid") and len(attributes.pid)>
    <cfset getImages = getComponent.GET_IMAGES(pid:attributes.pid)>
    <cfset image_id = attributes.pid>
    <cfset image_type = "product">
    <cfset query_ = getImages>
    <script>
		var adres_ = encodeURIComponent(document.getElementById('product_name').value);
	</script>
<cfelseif isdefined("attributes.brand_id") and len(attributes.brand_id)>
    <cfset getImages = getComponent.GET_IMAGES_BRAND(pid:attributes.brand_id)>
    <cfset image_id = attributes.brand_id>
    <cfset image_type = "brand">
    <cfset image_detail = get_brand.brand_name>
    <cfset query_ = getImages>
<cfelseif isdefined("attributes.contentId") and len(attributes.contentId)>
    <cfset getImages = getComponent.GET_IMAGE_CONT(contentId:attributes.contentId)>
    <cfset image_type = "content">
    <cfset image_id = attributes.contentId>
    <cfset query_ = getImages>
<cfelseif isDefined("attributes.class_id") and len(attributes.class_id)>
    <cfset getImages = getComponent.GET_TRAINING_CLASS_IMG(class_id : attributes.class_id)>
    <cfset image_type = "training">
    <cfset image_id = attributes.class_id>
    <cfset query_ = getImages>
<cfelseif isDefined("attributes.train_id") and len(attributes.train_id)>
    <cfset getImages = getComponent.GET_TRAINING_SUBJECT_IMG(train_id : attributes.train_id)>
    <cfset image_type = "train_subject">
    <cfset image_id = attributes.train_id>
    <cfset query_ = getImages>
<cfelseif isDefined("attributes.train_group_id") and len(attributes.train_group_id)>
    <cfset getImages = getComponent.GET_TRAINING_CLASS_GROUPS_IMG(train_group_id : attributes.train_group_id)>
    <cfset image_type = "train_group">
    <cfset image_id = attributes.train_group_id>
    <cfset query_ = getImages>
<cfelseif isDefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
    <cfset getImages = getComponent.GET_PRODUCT_SAMPLE_IMAGE(product_sample_id : attributes.product_sample_id)>
    <cfset image_type = "sample">
    <cfset image_id = attributes.product_sample_id>
    <cfset query_ = getImages>
</cfif>
<div style="display:none;z-index:999;" id="upd"></div>
<cfif (image_type neq 'training') and (image_type neq 'train_group') and (image_type neq 'train_subject')>
<cfif getImages.recordcount gt 0>
    <cfoutput query="query_">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cfif len(PATH) and PATH contains '/' and not len(video_path)>
                <cfset VIDEO_PATH_ = PATH>
            </cfif>
                    <cfif isDefined("PATH") AND LEN(PATH) and isDefined("VIDEO_PATH") AND LEN(VIDEO_PATH)> 
                        <a target="_blank" href="#VIDEO_PATH#" class="tableyazi"><img width="100%" height="100%" src="#file_web_path##image_type#/#path#"></a>  
                    <cfelseif isDefined("PATH") AND LEN(PATH) and isDefined("VIDEO_PATH_") AND LEN(VIDEO_PATH_)> 
                        <a target="_blank" href="#VIDEO_PATH_#" class="tableyazi"><img width="100%" height="100%" src="#VIDEO_PATH_#"></a>
                    <cfelseif is_external_link eq 1 AND VIDEO_LINK eq 1 AND isDefined("VIDEO_PATH") AND LEN(VIDEO_PATH) >
                        <cfset video = "#REPLACE("#VIDEO_PATH#","watch?v=","embed/","ALL")#">
                        <iframe frameBorder="0" src="#video#"  width="100%" height="100%"></iframe>
                    <cfelseif is_external_link eq 1 AND isDefined("VIDEO_PATH") AND LEN(VIDEO_PATH) and VIDEO_LINK eq 0>
                        <a target="_blank" href="#VIDEO_PATH#" class="tableyazi"><img width="100%" height="100%"  src="#VIDEO_PATH#"></a>
                    <cfelse>
                        <a target="_blank" href="#file_web_path##image_type#/#path#" class="tableyazi"><img width="100%" height="100%" src="#file_web_path##image_type#/#path#"></a>  
                    </cfif>
               <div class="ui-cards-text">
                    <ul class="ui-icon-list">
                        <cfsavecontent variable="message">#getLang('content',44,'Kayıtlı Resmi Siliyorsunuz! Emin misiniz')#</cfsavecontent>
                        <cfif isDefined("attributes.pid") and len(attributes.pid) or isdefined("attributes.brand_id") and len(attributes.brand_id)>
                            <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.form_upd_popup_image&action_id=#PRODUCT_IMAGEID#&type=product');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                            <li><a href="##" onClick="javascript:if (confirm('#message#')) openBoxDraggable('#request.self#?fuseaction=product.del_image&imid=#product_imageid#&type=#IMAGE_TYPE#') ;else return;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>                        
                        <cfelseif isDefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
                            <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.form_upd_popup_image&action_id=#PRODUCT_SAMPLE_IMAGE_ID#&type=sample');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                            <li><a href="##" onClick="javascript:if (confirm('#message#')) openBoxDraggable('#request.self#?fuseaction=product.del_image&imid=#product_sample_image_id#&type=#IMAGE_TYPE#') ;else return;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>                
                        <cfelse>
                            <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.form_upd_popup_image&action_id=#contimage_id#&type=#IMAGE_TYPE#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                            <li><a href="##" onclick="javascript:if(confirm('#message#')) openBoxDraggable('#request.self#?fuseaction=content.emptypopup_del_image&cnfid=#contimage_id#'); else return false;" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
                        </cfif>
                    </ul>
                </div> 
        </div>
    </cfoutput>
<cfelse>
    <div class="ui-info-text">
        <p><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</p>
    </div>
</cfif>
<cfelse>
    <cfif (getImages.path neq '') or (getImages.video_path neq '')>
        <cfoutput query="query_">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cfif len(PATH) and PATH contains '/' and not len(video_path)>
                    <cfset VIDEO_PATH_ = PATH>
                </cfif>
                <div class="ui-cards">
                    <div class="ui-cards-img">
                        <cfif isDefined("PATH") AND LEN(PATH) and isDefined("VIDEO_PATH") AND LEN(VIDEO_PATH)> 
                            <a target="_blank" href="#VIDEO_PATH#" class="tableyazi"><img src="#file_web_path##image_type#/#path#"></a>  
                        <cfelseif isDefined("PATH") AND LEN(PATH) and isDefined("VIDEO_PATH_") AND LEN(VIDEO_PATH_)> 
                            <a target="_blank" href="#VIDEO_PATH_#" class="tableyazi"><img src="#VIDEO_PATH_#"></a>
                        <cfelseif is_external_link eq 1 AND VIDEO_LINK eq 1 AND isDefined("VIDEO_PATH") AND LEN(VIDEO_PATH) >
                            <cfset video = "#REPLACE("#VIDEO_PATH#","watch?v=","embed/","ALL")#">
                            <iframe src="#video#"></iframe>
                        <cfelseif is_external_link eq 1 AND isDefined("VIDEO_PATH") AND LEN(VIDEO_PATH) and VIDEO_LINK eq 0>
                            <a target="_blank" href="#VIDEO_PATH#" class="tableyazi"><img src="#VIDEO_PATH#"></a>
                        <cfelse>
                            <a target="_blank" href="#file_web_path##image_type#/#path#" class="tableyazi"><img src="#file_web_path##image_type#/#path#"></a>  
                        </cfif>
                    </div>
                    <div class="ui-cards-text">
                        <ul class="ui-icon-list">
                            <cfsavecontent variable="message">#getLang('content',44,'Kayıtlı Resmi Siliyorsunuz! Emin misiniz')#</cfsavecontent>  
                            <cfif isDefined("attributes.class_id") and len(attributes.class_id)>                  
                                <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.form_upd_popup_image&action_id=#attributes.class_id#&type=#IMAGE_TYPE#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                                <li><a href="##" onclick="javascript:if(confirm('#message#')) del_img(#attributes.class_id#); else return false;" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
                            <cfelseif isDefined("attributes.train_group_id") and len(attributes.train_group_id)>
                                <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.form_upd_popup_image&action_id=#attributes.train_group_id#&type=#IMAGE_TYPE#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                                <li><a href="##" onclick="javascript:if(confirm('#message#')) del_img_group(#attributes.train_group_id#); else return false;" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li> 
                            <cfelseif isDefined("attributes.train_id") and len(attributes.train_id)>
                                <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.form_upd_popup_image&action_id=#attributes.train_id#&type=#IMAGE_TYPE#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
                                <li><a href="##" onclick="javascript:if(confirm('#message#')) del_img_subject(#attributes.train_id#); else return false;" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li> 
                            </cfif> 
                        </ul>
                    </div>
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <div class="ui-info-text">
            <p><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</p>
        </div>
    </cfif>
</cfif>
    
<script>
    function open_img(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('right','100%');
		$("#"+id).css('margin-top',$("#upd").position().top);
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	}

    function del_img(id) {
        var data = new FormData();
        data.append('class_id',id);
            AjaxControlPostData("CustomTags/cfc/wrk_images.cfc?method=DEL_TRAINING_IMG" ,data,function(response) {          
            console.log(response);   
            location.reload();       
        });        
    }   

    function del_img_group(id) {
        var data = new FormData();
        data.append('train_group_id',id);
            AjaxControlPostData("CustomTags/cfc/wrk_images.cfc?method=DEL_TRAINING_GROUP_IMG" ,data,function(response) {          
            console.log(response);   
            location.reload();       
        });        
    }   

    function del_img_subject(id) {
        var data = new FormData();
        data.append('train_id',id);
        AjaxControlPostData("CustomTags/cfc/wrk_images.cfc?method=DEL_TRAIN_SUBJECT_IMG" ,data,function(response) {          
            console.log(response);   
            location.reload();       
        });        
    }   
</script>