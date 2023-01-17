<div class="ui-info-text">
	<h1>Documents Settings</h1>
</div>
<div class="col-md-12 paddingLess">
    <div class="panel panel-default">
        <div class="panel-body">
            <cfoutput>
                <div class="col-md-12">In order to store your documents in Workcube, you need to configure the document settings..</div>
                <div class="col-md-12">You can store your documents in your application or in any directory on your server.</div>
                <div class="col-md-12">For this, simply enter the path of the directory where you want to store your documents.</div>
                <div class="col-md-12">To Inform: You can will use Google Drive Application in Workcube next soon!</div>
            </cfoutput>
        </div>
    </div>
</div>
<cfform name="installation_2_1" id="installation_2_1" type="formControl" method="post" action="#installUrl#">
    <input type="hidden" name="installation_type" id="installation_type" value="install_2_1" />
    <div class="ui-form-list">
        <div class="col-md-12 paddingLess">
            <div class="form-group">
                <label>Document Path <font color="red">*</font></label>
                <div class="col-md-12 pdnl pdnr">
                    <input required class="form-control" message="Enter Document Path"  name="document_path" id="document_path" type="text" value="<cfoutput>#index_folder#documents/</cfoutput>" autocomplete="off" />
                </div>
            </div>
            <div class="form-group">
                <label>Download Path <font color="red">*</font></label>
                <div class="col-md-12 pdnl pdnr">
                    <input required class="form-control" message="Enter Document Path"  name="download_path" id="download_path" type="text" value="<cfoutput>#index_folder#</cfoutput>" autocomplete="off" />
                </div>
            </div>
        </div>
    </div>
    <div class="ui-form-list-btn">
        <div class="col-md-12 paddingLess">
            <div class="form-group button-panel">
                <input  class="btn btn-info" type="submit" value="Next Step">
            </div>
        </div>
    </div>
</cfform>