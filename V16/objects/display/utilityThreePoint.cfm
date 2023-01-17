<cfparam name="attributes.op" default="">
<cfswitch expression="#attributes.op#">

    <cfcase value="select">
        <div class="row">
            <div class="col col-12">
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Fuseaction</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>#attributes.fact#</cfoutput>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12">Params</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" id="param_input" style="width: 100%">
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-12">
                        <button type="button" class="btn btn-green-haze" onclick="buildFields()">Select</button>
                    </div>
                </div>
            </div>
            
        </div>

        <script type="text/javascript">
            function buildFields() {
                var val = $("#param_input").val();
                setValue(val);
            }
            function setValue(val) {
                window.opener.setFieldValue({ type: "ThreePoint", fuseaction: '<cfoutput>#attributes.fact#</cfoutput>', formula: val, value: "ThreePoint=><cfoutput>#attributes.fact#:</cfoutput>" + val });
                window.close();
            }
        </script>
    </cfcase>

    <cfdefaultcase>

        <cfquery name="query_threepoint" datasource="#dsn#">
            SELECT * FROM WRK_OBJECTS WHERE FULL_FUSEACTION LIKE 'objects.popup_list%'
        </cfquery>

        <cf_grid_list>
            <thead>
                <tr>
                    <th>Head</th>
                    <th>Fuseaction</th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="query_threepoint">
                <tr>
                    <td><a href="javascript:void(0);" onclick="setDetailPage('#FULL_FUSEACTION#')">#HEAD#</a></td>
                    <td>#FULL_FUSEACTION#</td>
                </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
        <script type="text/javascript">
            function setDetailPage(link) {
                ajaxPage('ThreePoint&op=select&fact=' + link, 'ThreePoint');
            }
        </script>
    </cfdefaultcase>

</cfswitch>