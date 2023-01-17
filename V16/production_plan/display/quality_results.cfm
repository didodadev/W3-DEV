<cfparam name="attributes.branch" default="">
<cfparam name="attributes.warehouse" default="">
<cfparam name="attributes.station" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.grouping" default="">
<cfparam name="attributes.is_filter" default="0">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">


<cfset get_quality_success = createObject("component","V16.production_plan.cfc.get_succes_name").get_succes_name()>
<cfset queries = createObject("component","V16.production_plan.cfc.quality_results")>
<cfset get_branch = queries.get_branch()>

<cfset url_str = "">
<cfif len(attributes.grouping)><cfset url_str = "#url_str#&grouping=#attributes.grouping#"></cfif>
<cfif len(attributes.branch)><cfset url_str = "#url_str#&branch=#attributes.branch#"></cfif>
<cfif len(attributes.warehouse)><cfset url_str = "#url_str#&warehouse=#attributes.warehouse#"></cfif>
<cfif len(attributes.station)><cfset url_str = "#url_str#&station=#attributes.station#"></cfif>
<cfif len(attributes.start_date)><cfset url_str="#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#"></cfif>
<cfif len(attributes.finish_date)><cfset url_str="#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#"></cfif>
<cfset url_str = "#url_str#&is_filter=#attributes.is_filter#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_result" id="search_result" method="post" action="#request.self#?fuseaction=prod.quality_results">
			<input type="hidden" name="is_filter" id="is_filter" value="1">
            <cf_box_search>
                <div class="form-group">
                    <select name="branch" id="branch" onchange="get_depo(this.value)">
                        <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#" <cfif attributes.branch eq branch_id>selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="warehouse" id="warehouse" onchange="get_station(this.value)">
                        <option value=""><cf_get_lang dictionary_id='57284.Depo Seçiniz'></option>
                        <cfif len(attributes.branch)>
                            <cfquery name="get_department" datasource="#dsn#">
                                SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM  DEPARTMENT WHERE BRANCH_ID = <cfqueryparam value="#attributes.branch#" cfsqltype="cf_sql_integer"> ORDER BY DEPARTMENT_HEAD
                            </cfquery>
                            <cfoutput query="get_department">
                                <option value="#DEPARTMENT_ID#" <cfif attributes.warehouse eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <select name="station" id="station">
                        <option value=""><cf_get_lang dictionary_id='34288.İstasyon Seçiniz'></option>
                        <cfif len(attributes.branch)>
                            <cfquery name="get_stations" datasource="#dsn3#">
                                SELECT W.STATION_NAME,W.STATION_ID FROM WORKSTATIONS W WHERE W.BRANCH = <cfqueryparam value="#attributes.branch#" cfsqltype="cf_sql_integer"> ORDER BY W.STATION_NAME
                            </cfquery>
                            <cfoutput query="get_stations">
                                <option value="#STATION_ID#" <cfif attributes.station eq STATION_ID>selected</cfif>>#STATION_NAME#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                        <input type="text" name="product_name" id="product_name" placeholder="<cf_get_lang dictionary_id='57657.Ürün'>" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_name,stock_id','','2','200');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_result.stock_id&field_name=search_result.product_name&keyword='+encodeURIComponent(document.search_result.product_name.value));"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput name="start_date" id="start_date" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Başlangıç Tarihi','58053')# #iif(len(attributes.grouping),DE("*"),DE(""))#" value="#dateformat(attributes.start_date,dateformat_style)#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span> 
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput name="finish_date" id="finish_date" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Bitiş Tarihi','57700')# #iif(len(attributes.grouping),DE("*"),DE(""))#" value="#dateformat(attributes.finish_date,dateformat_style)#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span> 
                    </div>
                </div>
                <div class="form-group">
                    <select name="grouping" id="grouping">
                        <option value=""><cf_get_lang dictionary_id='46583.Gruplama'></option>
                        <option value="1" <cfif attributes.grouping eq 1>selected</cfif>><cf_get_lang dictionary_id='62221.İşlem Bazında'></option>
                        <option value="2" <cfif attributes.grouping eq 2>selected</cfif>><cf_get_lang dictionary_id='45555.Stok Bazında'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfif attributes.grouping eq 1>
        <!--- Kalite Başarımına Göre Üretim Sonuçları --->
        <cfinclude template="../display/prod_results_quality_success.cfm">
    <cfelseif attributes.grouping eq 2>
        <!--- Stok Bazında Kalite Başarımı --->
        <cfinclude template="../display/quality_success_by_stock.cfm">
    </cfif>
</div>
<script>
    function kontrol() {
        if($("#warehouse").val() != "" && $("#branch").val() == ""){
            alert("<cf_get_lang dictionary_id='30332.Şube Seçmelisiniz'>!");
            return false;
        }

        if($("#station").val() != "" && $("#warehouse").val() == ""){
            alert("<cf_get_lang dictionary_id='41844.Depo Seçmelisiniz'>!");
            return false;
        }

        if($("#grouping").val() != ""){
            if($("#start_date").val() == ""){
                alert("<cf_get_lang dictionary_id='36485.Lütfen Başlangıç Tarihi Giriniz'>!");
                return false;
            }
            if($("#finish_date").val() == ""){
                alert("<cf_get_lang dictionary_id='50693.Lütfen Bitiş Tarihi Giriniz'>!");
                return false;
            }
        }
            
        $("#search_result").submit();
    }

    function get_depo(branch_id) {
		if(branch_id != ''){
			var get_depo_detail = wrk_query("SELECT  DEPARTMENT_HEAD,DEPARTMENT_ID FROM  DEPARTMENT WHERE BRANCH_ID ="+ branch_id+ "ORDER BY DEPARTMENT_HEAD","dsn");

			$("#warehouse option").remove();
			$("#warehouse").append($("<option></option>").attr("value", '').text( "<cf_get_lang dictionary_id='57284.Depo Seçiniz'>" ));
            $("#station option").remove();
            $("#station").append($("<option></option>").attr("value", '').text( "<cf_get_lang dictionary_id='34288.İstasyon Seçiniz'>" ));

			if(get_depo_detail.recordcount > 0){
                for(i = 1;i<=get_depo_detail.recordcount;++i)
				{
					$("#warehouse").append($("<option></option>").attr("value", get_depo_detail.DEPARTMENT_ID[i-1]).text(get_depo_detail.DEPARTMENT_HEAD[i-1]));
				}
			}
		}
        else{
            $("#warehouse option").remove();
			$("#warehouse").append($("<option></option>").attr("value", '').text( "<cf_get_lang dictionary_id='57284.Depo Seçiniz'>" ));
            $("#station option").remove();
            $("#station").append($("<option></option>").attr("value", '').text( "<cf_get_lang dictionary_id='34288.İstasyon Seçiniz'>" ));
        } 
	}

    function get_station(department_id) {
		if(department_id != ''){
			var get_station_detail = wrk_query("SELECT W.STATION_NAME,W.STATION_ID FROM  WORKSTATIONS W WHERE W.BRANCH ="+ $("#branch").val()+ "ORDER BY W.STATION_NAME","dsn3");
            $("#station option").remove();
			$("#station").append($("<option></option>").attr("value", '').text( "<cf_get_lang dictionary_id='34288.İstasyon Seçiniz'>" ));
            if(get_station_detail.recordcount > 0){
                for(i = 1;i<=get_station_detail.recordcount;++i)
				{
					$("#station").append($("<option></option>").attr("value", get_station_detail.STATION_ID[i-1]).text(get_station_detail.STATION_NAME[i-1]));
				}
			} 
        }
        else{
            $("#station option").remove();
            $("#station").append($("<option></option>").attr("value", '').text( "<cf_get_lang dictionary_id='34288.İstasyon Seçiniz'>" ));
        } 
    }
</script>