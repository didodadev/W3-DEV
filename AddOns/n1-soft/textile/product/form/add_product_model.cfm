<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">
<cfparam name="attributes.model_id" default="">
<cfif isdefined('attributes.model_id') and len(attributes.model_id)>
	<cfquery name="get_model_det" datasource="#dsn1#">
		SELECT MODEL_NAME, MODEL_CODE,BRAND_ID,EMP_ID,REQUEST_ID,STAGE_ID,RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
	</cfquery>
</cfif>


<!---künye numune özet--->

<cfinclude template="../../sales/query/get_req.cfm">
<!---
<cfscript>
	CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQUEST_ID');
</cfscript>--->
<!---künye numune özet--->


<cf_catalystHeader>
<cfif isdefined('attributes.model_id') and len(attributes.model_id)>
    <cfset model_id = attributes.model_id>
    <cfscript>
        CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_sample_request");
        getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.model_id#,action_section:'PRODUCT_MODEL_ID');
		
    </cfscript>
    <cfset uploadFolder = application.systemParam.systemParam().upload_folder />
    <cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>
    
    <cfscript>
    
        imageSettings =	{///thumbnail Settings
    
            1	:	{
                folderName	:	"icon",
                PositionX	:	0,
                PositionY	:	0,
                newWidth	:	128,
                newHeight	:	128
            },
            2	:	{
                folderName	:	"middle",
                PositionX	:	0,
                PositionY	:	0,
                newWidth	:	512,
                newHeight	:	256
            }
        };
    
    </cfscript>

                <cfset icon = false>
                <cfset fileType = "">
                <cfset imagePath = "">
                <cfset ext="">
              <!---  <cfset url_="">
                <cfif len(getAsset.asset_file_name) and FileExists("#uploadFolder#thumbnails/middle/#getAsset.asset_file_name#")>

                    <cfset imagePath = "documents/thumbnails/middle/#getAsset.asset_file_name#">
                    <cfset icon = false>
                    <cfset ext=lcase(listlast(getAsset.asset_file_name, '.')) />
                <cfelse>
                    
                    <cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> 
                    <cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
                    <cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />

                    <cfset imageOperations = CreateObject("Component","cfc.image_operations") />

                   
                    
                    <cfset imagePath = "documents/thumbnails/middle/#getAsset.asset_file_name#" />
                    <cfset icon = false>

                </cfif>--->



<cfelse>
	<cfset model_id = 0>
</cfif>
<cfform action="#request.self#?fuseaction=textile.emptypopup_add_product_model&model_id=#model_id#" method="post" name="product_cat" enctype="multipart/form-data">

<input type="hidden" name="model_id" id="model_id" value="<cfoutput>#model_id#</cfoutput>">
<input type="hidden" name="request_id" id="request_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
<input type="hidden" name="plan_id" id="plan_id" value="<cfoutput>#attributes.plan_id#</cfoutput>">

	<div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-workcube_process">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1447.Süreç'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif not isdefined('get_model_det.stage_id')>
                                         <cf_workcube_process is_upd='0' select_value=''  is_detail='0'>
                                     <cfelse>
                                        <cf_workcube_process is_upd='0' select_value='#get_model_det.stage_id#'  is_detail='1'>   
                                     </cfif>
                                </div>
                            </div>
                        </div>
						<div class="form-group" id="item-model_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1173.Kod'>*</label>
                            <div class="col col-8 col-xs-12">
                            	<div <cfif isdefined('attributes.model_id') and len(attributes.model_id)>class="input-group"</cfif>>
                                    <input type="text" name="model_code" id="model_code" value="<cfif isdefined('get_model_det.model_code') and len(get_model_det.model_code)><cfoutput>#get_model_det.model_code#</cfoutput><cfelse><cfoutput>M-#ListLast(GET_OPPORTUNITY.req_no,'-')#</cfoutput></cfif>" maxlength="50">
                                    <cfif isdefined("attributes.model_id") AND LEN(attributes.model_id)>
                                    	<span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="PRODUCT_BRANDS_MODEL" 
                                            column_name="MODEL_CODE" 
                                            column_id_value="#attributes.model_id#" 
                                            maxlength="500" 
                                            datasource="#dsn1#" 
                                            column_id="MODEL_ID" 
                                            control_type="0">
                                        </span>
                                    </cfif>
                                </div>    
                            </div>
                        </div>

						
						<div class="form-group" id="item-model_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='813.Model'>*</label>
                            <div class="col col-8 col-xs-12">
                            	<div <cfif isdefined('attributes.model_id') and len(attributes.model_id)>class="input-group"</cfif>>
                                    <input type="text" name="model_name" id="model_name" value="<cfif isdefined('get_model_det.model_name') and len(get_model_det.model_name)><cfoutput>#get_model_det.model_name#</cfoutput><cfelse><cfoutput>M-#ListLast(GET_OPPORTUNITY.req_no,'-')#</cfoutput></cfif>" maxlength="75">
                                    <cfif isdefined("attributes.model_id") AND LEN(attributes.model_id)>
                                        <span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="PRODUCT_BRANDS_MODEL" 
                                            column_name="MODEL_NAME" 
                                            column_id_value="#attributes.model_id#" 
                                            maxlength="500" 
                                            datasource="#dsn1#" 
                                            column_id="MODEL_ID" 
                                            control_type="0">
                                        </span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-brand_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
                            <div class="col col-8 col-xs-12">
								<cfif not isdefined('get_model_det.brand_id')>
                                   <input type="hidden" name="brand_code" id="brand_code" value="">
                                    <cf_wrkProductBrand
                                        returnInputValue="brand_id,brand_name,brand_code"
                                        returnQueryValue="brand_id,brand_name,brand_code"
                                        width="200"
                                        compenent_name="getProductBrand"               
                                        boxwidth="300"
                                        boxheight="150"
                                        is_internet="1"
                                        brand_code="1"
                                        brand_ID="">
                                <cfelse>
                                    <cf_wrkProductBrand
                                        returnInputValue="brand_id,brand_name,brand_code"
                                        returnQueryValue="brand_id,brand_name,brand_code"
                                        width="200"
                                        compenent_name="getProductBrand"               
                                        boxwidth="300"
                                        boxheight="150"
                                        is_internet="1"
                                        brand_code="1"
                                        brand_ID="#get_model_det.brand_id#">
                                </cfif>
                            </div>
                        </div>
                                                
						 <div class="form-group" id="item-sales_emp_id">
							 <label class="col col-4 col-xs-12">Tarih </label>
							    <div class="col col-8 col-xs-12">
										<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
										<cfif isdefined("get_model_det.model_date")>
											<cfinput type="text" name="model_date" id="model_date" value="#dateformat(get_model_det.model_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
										<cfelse>
											<cfinput type="text" name="model_date" id="model_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="model_date"></span>
										</div>
								</div>
						 </div>
                        <div class="form-group" id="item-sales_emp_id">
                            <label class="col col-4 col-xs-12">Tasarımcı </label>
                            <div class="col col-8 col-xs-12">
                                    <cfif not isdefined('get_model_det.emp_id')>
                            	        <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="">
										<div class="input-group">
											<input type="text" name="sales_emp" id="sales_emp" value="" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','140');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=product_cat.sales_emp_id&field_name=product_cat.sales_emp&select_list=1','list');"></span>
                                        </div>   
                                    <cfelse>
                                        <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfoutput>#get_model_det.emp_id#</cfoutput>">
										<div class="input-group">
											<input type="text" name="sales_emp" id="sales_emp" value="<cfoutput>#get_emp_info(get_model_det.emp_id,0,0)#</cfoutput>" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','140');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=product_cat.sales_emp_id&field_name=product_cat.sales_emp&select_list=1','list');"></span>
                                        </div>   
                                    </cfif>
                            </div>
                        </div>
						<div class="form-group" id="item-sales_emp_id">
						<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='TEXTILE_MODEL_ID' action_id='#model_id#'>
						   </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                   <!--- <cf_box>--->
                    <cfif model_id eq 0 or (isdefined("getAsset") and getAsset.recordcount eq 0)>
                               <input type="hidden" name="asset_add">
                              <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
                                <div class="col col-11 col-md-11 col-sm-12 col-xs-12" >
                                        <div class="form-group" id="item-asset">
                                            <cfset foldername =createUUID()>
                                                <div id="fileUpload" class="fileUpload" style="heigth:10px;">
                                                    <cfoutput>
                                                    <div style="heigth:10px;" class=" col col-12 col-md-12 col-sm-10 col-xs-12 offset-1">
                                                        <!-- Nav tabs -->
                                                        <input type="hidden" name="foldername" value="#foldername#">
                                                        <input type="hidden" name="asset" id="asset" value="">
                                                        <div class="dropzone dz-clickable dropzonescroll" style="heigth:5mm;" id="file-dropzone">
                                                        <div class="dz-default dz-message">
																  <span>Model resimlerinizi sürükleyerek bırakın ya da burayı tıklayarak seçin.</span>
                                                            </div>
                                                        </div>
                                                                            
                                                    </div>  
                                                    </cfoutput>      
                                                </div>  
                                        </div>
                                </div>
                    <cfelseif model_id gt 0 and  isdefined("getAsset") and getAsset.recordcount gt 0>
   
                                <cfoutput query="getAsset">
			
									<cfset ext="">
						<cfset url_="">
						<cfset url_ = "#file_web_path#product/">
											<cfset path = "#upload_folder#product#dir_seperator#">
												<cfset file_path = '#path##getAsset.asset_file_name#'>
			<cfif len(getAsset.asset_file_name) and FileExists(file_path)>
						<cfif len(getAsset.asset_file_name) and FileExists("#uploadFolder#thumbnails/middle/#getAsset.asset_file_name#")>

							<cfset imagePath = "documents/thumbnails/middle/#getAsset.asset_file_name#">
							<cfset icon = false>
							<cfset ext=lcase(listlast(getAsset.asset_file_name, '.')) />
						<cfelse>
							
							<cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
							<cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
							<cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />

							<cfset imageOperations = CreateObject("Component","cfc.image_operations") />
						<cfif FileExists(file_path)>
							<cfloop from="1" to="#imageSettings.count()#" index="row">
								
								<cfset imageOperations.imageCrop(
													imagePath : "#file_path#",
													imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#getAsset.asset_file_name#",
													imageCropType	:	1, <!--- Orantılı boyutlandır --->
													newWidth : #imageSettings[row]["newWidth"]#,
													newHeight : #imageSettings[row]["newHeight"]#
													) />

							</cfloop>
						</cfif>
							<cfset imagePath = "documents/thumbnails/middle/#getAsset.asset_file_name#" />
							<cfset icon = false>

						</cfif>
			<cfelse>
						<cfset imagePath = "images/intranet/no-image.png">
						<cfset icon = true>
			</cfif>
			
			
                <div class="box-list box-list-small col col-11 col-md-11 col-sm-6 col-xs-12">
                                <div class="box-list-content col col-12">
                                        <div class="box-list-image box-list-image-small">
                                                <div class="box-list-image-content">
                                                    <div class="image">
                                                        <cfif icon>
                                                            <img src="#imagePath#" style="margin: 20px; width:70px;">
                                                        <cfelse>
                                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##getAsset.asset_file_name#&file_control=asset.form_upd_asset&asset_id=#getAsset.asset_id#&assetcat_id=#getAsset.assetcat_id#','medium');">
                                                                <img src="#imagePath#"  >
                                                            </a>
                                                        </cfif>
                                                    </div>
                                                </div>
                                        </div>
                                        <div class="box-list-text">
                                                <div class="box-list-header">
                                                            <div class="box-list-title col col-8" title="Orjinal Dosya Adı : #getAsset.asset_file_real_name#">
                                                                #getAsset.asset_name#
                                                            </div>
                                                    
                                                            <div class="box-list-button-panel col col-4" style="padding-right:4px">
                            
                                                                <ul class="box-button-panel">
                                                                        <cfif filetype eq "video">
                                                                            <!---#my_video_file_path#--->
                                                                            <li title="#getLang('asset',6)#"><i class="fa fa-download" onclick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#my_video_file_path#&ext=#ext#&content_id=#asset_id#','video');"></i></li>
                                                                        <!---<cfelseif listfind(mediaplayer_extensions, "."&ext)>
                                                                            <a href="#url_##asset_file_name#" class="tableyazi">#asset_name#</a>--->
                                                                        <cfelse>
                                                                            <li title="#getLang('asset',6)#"><i class="fa fa-download" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##getAsset.asset_file_name#&file_control=asset.form_upd_asset&asset_id=#getAsset.asset_id#&assetcat_id=#getAsset.assetcat_id#','medium');"></i></li>
                                                                        </cfif>
                                                                    <a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#getAsset.asset_id#&assetcat_id=#getAsset.assetcat_id#"><li title="#getLang('main',52)#"><i class="fa fa-edit"></i></li></a>
                                                                </ul>
                            
                                                            </div>
                                                </div>
                                                <div class="box-list-footer">
                                                    <div class="box-list-footer-top">
                                                        <i class="fa fa-calendar"></i><span class="date">#dateformat(getAsset.record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,getAsset.record_date),timeformat_style)#</span> 
                                                        <i class="fa fa-pie-chart"></i><span class="filesize"> #getAsset.asset_file_size# KB</span>
                                                    </div>
                                                    <div class="box-list-footer-bottom">
                                                        <span class="author">
                                                            <cfif len(getAsset.record_emp)>
                                                            <!--- <a href="javascript://" onclick="nModal({head: 'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(get_emp_list_2,getAsset.record_emp,',')]#'});" class="tableyazi">#get_emp.employee_name[listfind(get_emp_list_2,getAsset.record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list_2,getAsset.record_emp,',')]#</a>--->
                                                            <cfelseif len(getAsset.record_pub)>
                                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons.consumer_id[listfind(get_cons_list_2,record_pub,',')]#','medium')" class="tableyazi">#get_cons.consumer_name[listfind(get_cons_list_2,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list_2,record_pub,',')]#</a>
                                                            <cfelseif len(getAsset.record_par)>
                                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par.partner_id[listfind(get_par_list_2,record_par,',')]#','medium')" class="tableyazi">#get_par.company_partner_name[listfind(get_par_list_2,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list_2,record_par,',')]#</a>
                                                            </cfif>
                                                        </span>
                                                    </div>
                                                </div>
                                      </div>
                                </div>
                 </div>

        </cfoutput>
                
                    
                    </cfif>                   
                   <!--- </cf_box>--->
                </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12" >
						<cfif isdefined('attributes.model_id') and len(attributes.model_id)>
                           <div class="col col-6"><cf_record_info query_name="get_model_det" is_partner='1'></div>
						  </cfif>
                        <div style="float:right;">
						 <cfif model_id eq 0>
                             <button type="button" class="btn btn-primary" onclick="control()">Kaydet</button>
						<cfelse>
							 <button type="button" class="btn btn-primary" onclick="control()">Güncelle</button>
						</cfif>
                         </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
	</cfform>
	<div class="col col-12">
	<div class="col col-9 col-xs-12 ">
							<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >	
								<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
								<cfinclude template="../../sales/display/dsp_sample_request.cfm">
							</cf_box>
			</div>
	</div>
<script type="text/javascript">
function control()
{
	
	if($('#model_name').val()=='')
	{
		alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='813.Model'>");
		return false;
	}
	if($('#model_code').val()=='')
	{
		alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='1173.Kod'>");
		return false;
	}
    /*if($('#brand_id').val()=='')
	{
		alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='1435.Kod'>");
		return false;
    }*/
    document.product_cat.submit();
	return true;
}
</script>
<script type="text/javascript" src="/JS/fileupload/dropzone.js"></script>
<script type="text/javascript" src="/JS/fileupload/fileupload-min.js"></script>