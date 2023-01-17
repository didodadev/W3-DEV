<cfparam name="attributes.utility_id" default="0">
<cfparam name="attributes.utility_type" default="">
<cfparam name="attributes.UTILITY_NAME" default="">
<cfparam name="attributes.DEVELOPER" default="">
<cfparam name="attributes.VERSION" default="">
<cfparam name="attributes.DETAIL" default="">
<cfparam name="attributes.UPLOADED_FILE" default="">
<cfset rootFolder = ExpandPath("/")>
<cfset upload_folder_ = ExpandPath("Utility/")>
<cfset utilityPath = 'Utility/'>
<cfset utilityCustomTagPath = 'Utility/CustomTag/'>

<cfif isdefined("attributes.utility_type") and attributes.utility_type eq 3>
	<cfset upload_folder_ = ExpandPath("Utility/CustomTag/")>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform id="utilityForm" name="utilityForm" method="post"  action="WDO/utility_add.cfm">
            <input type="hidden" name="utility_id" id="utility_id" value="#getUtility.utility_id#" />
            <cf_box_elements>
                <div class="col col-9 col-md-9 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-UTILITY_NAME">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Name</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="UTILITY_NAME" id="UTILITY_NAME" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-DETAIL">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Detail</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea rows="7" name="DETAIL" id="DETAIL"></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Type</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="utility_type" id="utility_type">
                                <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                <option value="0">ThreePoint</option>
                                <option value="1">AutoComplete</option>
                                <option value="2">MethodQuery</option>
                                <option value="3">Custom Tag</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-UPLOADED_FILE">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">File Path</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file" style="width:210px;"> 
                            <label></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-DEVELOPER">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Developers</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="DEVELOPER" id="DEVELOPER">
                        </div>
                    </div>
                    <div class="form-group" id="item-version">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Version </label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="VERSION" id="VERSION">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>