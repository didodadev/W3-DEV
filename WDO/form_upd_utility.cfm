<cfparam name="attributes.delete" default="0">
<cfparam name="attributes.utility_type" default="">
<cfparam name="attributes.UTILITY_NAME" default="">
<cfparam name="attributes.DEVELOPER" default="">
<cfparam name="attributes.VERSION" default="">
<cfparam name="attributes.DETAIL" default="">
<cfparam name="attributes.UPLOADED_FILE" default="">
<cfset rootFolder = ExpandPath("\")>
<cfset upload_folder_ = ExpandPath("Utility\")>
<cfset utilityPath = 'Utility\'>
<cfset utilityCustomTagPath = 'Utility\CustomTag\'>

<cfif isdefined("attributes.utility_type") and attributes.utility_type eq 3>
	<cfset upload_folder_ = ExpandPath("Utility\CustomTag\")>
</cfif>
	
<cfquery name="getUtility" datasource="#dsn#">
    SELECT
        *
    FROM
        UTILITIES
    WHERE
        UTILITY_ID = #attributes.utility_id#
</cfquery>
<cfquery name="GET_FILE" datasource="#dsn#">
    SELECT
        PATH
    FROM
        UTILITIES
    WHERE
        UTILITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.utility_id#">
</cfquery>
<cfif len(GET_FILE.PATH) and len(attributes.uploaded_file)>
    <cftry>
        <cffile action="delete" file="#rootFolder##GET_FILE.PATH#">
    <cfcatch></cfcatch>
    </cftry>
</cfif>
<cfif len(attributes.uploaded_file)>
    <cfset upload_folder_temporary = upload_folder>
    <cffile action = "upload" 
            filefield = "uploaded_file" 
            destination = "#upload_folder_temporary#"
            nameconflict = "MakeUnique" 
            mode="777" charset="utf-8">
    <cfset file_name = "#CFFILE.serverfile#">
    <cffile action="rename" source="#upload_folder_temporary##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">
</cfif>       
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform id="utilityForm" name="utilityForm" method="post" enctype="multipart/form-data" action="">
            <cfoutput>
                <input type="hidden" name="utility_id" id="utility_id" value="#getUtility.utility_id#" />
                <cf_box_elements>
                    <div class="col col-9 col-md-9 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-UTILITY_NAME">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Name</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="UTILITY_NAME" id="UTILITY_NAME" value="#URLDecode(getUtility.UTILITY_NAME)#">
                            </div>
                        </div>
                        <div class="form-group" id="item-DETAIL">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Detail</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea rows="7" name="DETAIL" id="DETAIL" value="">#URLDecode(getUtility.DETAIL)#</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Type</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="utility_type" id="utility_type">
                                    <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                    <option value="0" <cfif getUtility.UTILITY_TYPE eq 0>selected</cfif>>ThreePoint</option>
                                    <option value="1" <cfif getUtility.UTILITY_TYPE eq 1>selected</cfif>>AutoComplete</option>
                                    <option value="2" <cfif getUtility.UTILITY_TYPE eq 2>selected</cfif>>MethodQuery</option>
                                    <option value="3" <cfif getUtility.UTILITY_TYPE eq 3>selected</cfif>>Custom Tag</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-UPLOADED_FILE">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">File Path</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="file" name="uploaded_file" id="uploaded_file" style="width:210px;"> 
                                <label>#URLDecode(getUtility.PATH)#</label>
                            </div>
                        </div>
                        <div class="form-group" id="item-DEVELOPER">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Developers</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="DEVELOPER" id="DEVELOPER" value="#URLDecode(getUtility.DEVELOPER)#">
                            </div>
                        </div>
                        <div class="form-group" id="item-version">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Version </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="VERSION" id="VERSION" value="#URLDecode(getUtility.VERSION)#">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
            </cfoutput>
            <cf_box_footer>
                <cf_workcube_buttons is_upd="1" is_delete="0">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>